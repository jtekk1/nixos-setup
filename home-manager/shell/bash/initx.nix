{ pkgs, ... }:

{
  programs.bash.initExtra = ''
    # Initialize ble.sh (Bash Line Editor) - must be first
    ble-import integration/fzf-competion
    ble-import integration/fzf-key-bindings
    source ${pkgs.blesh}/share/blesh/ble.sh

    set +h

    # Ensure FIDO2 SSH keys work properly
    unset SSH_SK_PROVIDER

    # Default to Bitwarden SSH agent if available
    if [ -S "$HOME/.bitwarden-ssh-agent.sock" ]; then
      export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
    fi

    ### Functions ###

    zd() {
      if [ $# -eq 0 ]; then
        builtin cd ~ && return
      elif [ -d "$1" ]; then
        builtin cd "$1"
      else
        z "$@" && printf " \U000F17A9 " && pwd || echo "Error: Directory not found"
      fi
    }

    open() {
      xdg-open "$@" >/dev/null 2>&1 &
    }

    compress() {
      tar -czf "''${1%/}.tar.gz" "''${1%/}"
    }

    transcode-video-1080p() {
      ffmpeg -i $1 -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy ''${1%.*}-1080p.mp4
    }

    transcode-video-4K() {
      ffmpeg -i $1 -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k ''${1%.*}-optimized.mp4
    }

    img2jpg() {
      magick $1 -quality 95 -strip ''${1%.*}.jpg
    }

    img2jpg-small() {
      magick $1 -resize 1080x\> -quality 95 -strip ''${1%.*}.jpg
    }

    img2png() {
      magick "$1" -strip -define png:compression-filter=5 \
        -define png:compression-level=9 \
        -define png:compression-strategy=1 \
        -define png:exclude-chunk=all \
        "''${1%.*}.png"
    }
  '';
}
