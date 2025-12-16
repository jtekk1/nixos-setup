#!/usr/bin/env python3
"""
Deploy Controller - Simple container deployment service for homelab sites.

Handles webhooks from CI to deploy containers to the appropriate environment.
"""

import json
import os
import subprocess
import sys
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler
from pathlib import Path
import hmac
import hashlib

# Configuration from environment
CONFIG = {
    "port": int(os.environ.get("PORT", "9500")),
    "sites_dir": os.environ.get("SITES_DIR", "/sites"),
    "state_dir": os.environ.get("STATE_DIR", "/var/lib/deploy-controller"),
    "deploy_token": os.environ.get("DEPLOY_TOKEN", ""),
    "registry": os.environ.get("REGISTRY", "git.jtekk.dev"),
}


def log(msg: str):
    """Log with timestamp."""
    print(f"[{datetime.now().isoformat()}] {msg}", flush=True)


def run_cmd(cmd: list[str], cwd: str = None) -> tuple[int, str, str]:
    """Run a command and return (returncode, stdout, stderr)."""
    log(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    return result.returncode, result.stdout, result.stderr


def pull_image(image: str) -> bool:
    """Pull a container image."""
    code, out, err = run_cmd(["podman", "pull", image])
    if code != 0:
        log(f"Failed to pull {image}: {err}")
        return False
    log(f"Pulled {image}")
    return True


def deploy_site(site: str, env: str, image: str, sha: str) -> dict:
    """Deploy a site to the specified environment."""
    site_dir = Path(CONFIG["sites_dir"]) / site
    state_file = Path(CONFIG["state_dir"]) / f"{site}.json"

    # Load or create state
    state = {}
    if state_file.exists():
        state = json.loads(state_file.read_text())

    # Container name based on site and env
    container_name = f"site-{site}-{env}"

    # Pull the new image
    if not pull_image(image):
        return {"success": False, "error": "Failed to pull image"}

    # Stop existing container if running
    run_cmd(["podman", "stop", container_name])
    run_cmd(["podman", "rm", container_name])

    # Determine port based on site config
    port_map = {
        "tekkverse": {"prod": 8200, "preview": 8201, "dev": 8202, "stage": 8203},
    }
    port = port_map.get(site, {}).get(env, 8200)

    # Start new container
    cmd = [
        "podman", "run", "-d",
        "--name", container_name,
        "--restart", "always",
        "-p", f"127.0.0.1:{port}:80",
        image
    ]

    code, out, err = run_cmd(cmd)
    if code != 0:
        return {"success": False, "error": f"Failed to start container: {err}"}

    container_id = out.strip()

    # Update state
    state[env] = {
        "image": image,
        "sha": sha,
        "container_id": container_id,
        "deployed_at": datetime.now().isoformat(),
        "port": port,
    }

    state_file.parent.mkdir(parents=True, exist_ok=True)
    state_file.write_text(json.dumps(state, indent=2))

    log(f"Deployed {site}/{env} from {image} on port {port}")

    return {
        "success": True,
        "container_id": container_id,
        "port": port,
        "image": image,
    }


def get_site_status(site: str) -> dict:
    """Get current status of a site."""
    state_file = Path(CONFIG["state_dir"]) / f"{site}.json"
    if not state_file.exists():
        return {"site": site, "environments": {}}

    state = json.loads(state_file.read_text())

    # Check container status for each env
    result = {"site": site, "environments": {}}
    for env, info in state.items():
        container_name = f"site-{site}-{env}"
        code, out, _ = run_cmd(["podman", "inspect", "--format", "{{.State.Status}}", container_name])

        result["environments"][env] = {
            **info,
            "status": out.strip() if code == 0 else "not running",
        }

    return result


class DeployHandler(BaseHTTPRequestHandler):
    """HTTP request handler for deploy webhooks."""

    def _send_json(self, status: int, data: dict):
        """Send JSON response."""
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def _check_auth(self) -> bool:
        """Verify authorization token."""
        auth = self.headers.get("Authorization", "")
        if not auth.startswith("Bearer "):
            return False
        token = auth[7:]
        return hmac.compare_digest(token, CONFIG["deploy_token"])

    def do_GET(self):
        """Handle GET requests."""
        if self.path == "/health":
            self._send_json(200, {"status": "healthy"})
            return

        if self.path.startswith("/api/status/"):
            site = self.path.split("/")[-1]
            status = get_site_status(site)
            self._send_json(200, status)
            return

        if self.path == "/api/sites":
            state_dir = Path(CONFIG["state_dir"])
            sites = []
            if state_dir.exists():
                for f in state_dir.glob("*.json"):
                    sites.append(f.stem)
            self._send_json(200, {"sites": sites})
            return

        self._send_json(404, {"error": "Not found"})

    def do_POST(self):
        """Handle POST requests."""
        if self.path == "/webhook/registry":
            if not self._check_auth():
                self._send_json(401, {"error": "Unauthorized"})
                return

            content_length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(content_length).decode()

            try:
                data = json.loads(body)
            except json.JSONDecodeError:
                self._send_json(400, {"error": "Invalid JSON"})
                return

            site = data.get("site", "").split("/")[-1]  # Extract site name from repo path
            env = data.get("env", "dev")
            image = data.get("image", "")
            sha = data.get("sha", "")

            if not site or not image:
                self._send_json(400, {"error": "Missing site or image"})
                return

            log(f"Received deploy request: site={site}, env={env}, image={image}")

            result = deploy_site(site, env, image, sha)

            if result["success"]:
                self._send_json(200, result)
            else:
                self._send_json(500, result)
            return

        self._send_json(404, {"error": "Not found"})

    def log_message(self, format, *args):
        """Override to use our logging."""
        log(f"{self.address_string()} - {format % args}")


def main():
    """Run the deploy controller server."""
    if not CONFIG["deploy_token"]:
        log("WARNING: DEPLOY_TOKEN not set - webhooks will be unauthenticated!")

    # Ensure state directory exists
    Path(CONFIG["state_dir"]).mkdir(parents=True, exist_ok=True)

    server = HTTPServer(("0.0.0.0", CONFIG["port"]), DeployHandler)
    log(f"Deploy controller starting on port {CONFIG['port']}")
    log(f"Sites directory: {CONFIG['sites_dir']}")
    log(f"State directory: {CONFIG['state_dir']}")

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        log("Shutting down...")
        server.shutdown()


if __name__ == "__main__":
    main()
