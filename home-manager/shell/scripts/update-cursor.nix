{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "update-cursor" ''
# Script to fetch the latest Cursor version and update the nix package

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the latest download URL by following the redirect
echo -e "''${YELLOW}Fetching latest Cursor version...''${NC}"
LATEST_URL=$(${curl}/bin/curl -sI "https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/2.0" | ${gnugrep}/bin/grep -i "^location:" | ${gawk}/bin/awk '{print $2}' | tr -d '\r')

if [ -z "$LATEST_URL" ]; then
    echo -e "''${RED}Error: Could not fetch latest Cursor URL''${NC}"
    exit 1
fi

echo -e "''${GREEN}Latest URL: ''${LATEST_URL}''${NC}"

# Extract version from URL
VERSION=$(echo "$LATEST_URL" | ${gnugrep}/bin/grep -oP 'Cursor-\K[0-9]+\.[0-9]+\.[0-9]+' || echo "")
if [ -z "$VERSION" ]; then
    echo -e "''${RED}Error: Could not extract version from URL''${NC}"
    exit 1
fi

echo -e "''${GREEN}Latest version: ''${VERSION}''${NC}"

# Extract hash from URL (the production hash directory)
HASH=$(echo "$LATEST_URL" | ${gnugrep}/bin/grep -oP 'production/\K[a-f0-9]+' || echo "")
if [ -z "$HASH" ]; then
    echo -e "''${RED}Error: Could not extract hash from URL''${NC}"
    exit 1
fi

echo -e "''${GREEN}Production hash: ''${HASH}''${NC}"

# Get current version from the nix file
SCRIPT_DIR="$(cd "$(dirname "''${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
NIX_FILE="$SCRIPT_DIR/packages/cursor.nix"

if [ ! -f "$NIX_FILE" ]; then
    echo -e "''${RED}Error: cursor.nix not found at $NIX_FILE''${NC}"
    exit 1
fi

CURRENT_VERSION=$(${gnugrep}/bin/grep 'version = ' "$NIX_FILE" | head -n1 | ${gnused}/bin/sed 's/.*"\(.*\)".*/\1/')
echo -e "''${YELLOW}Current version: ''${CURRENT_VERSION}''${NC}"

if [ "$VERSION" = "$CURRENT_VERSION" ]; then
    echo -e "''${GREEN}Already on latest version ''${VERSION}''${NC}"
    exit 0
fi

# Calculate SHA256 hash
echo -e "''${YELLOW}Downloading and calculating SHA256 hash (this may take a moment)...''${NC}"
SHA256=$(nix-prefetch-url "$LATEST_URL" 2>/dev/null)

if [ -z "$SHA256" ]; then
    echo -e "''${RED}Error: Could not calculate SHA256 hash''${NC}"
    exit 1
fi

echo -e "''${GREEN}SHA256: ''${SHA256}''${NC}"

# Update the nix file
echo -e "''${YELLOW}Updating $NIX_FILE...''${NC}"

# Backup the original file
cp "$NIX_FILE" "$NIX_FILE.bak"

# Update version
${gnused}/bin/sed -i "s/version = \".*\";/version = \"$VERSION\";/" "$NIX_FILE"

# Update URL hash
${gnused}/bin/sed -i "s|production/[a-f0-9]*/linux/x64/Cursor-|production/$HASH/linux/x64/Cursor-|" "$NIX_FILE"

# Update SHA256
${gnused}/bin/sed -i "s/sha256 = \".*\";/sha256 = \"$SHA256\";/" "$NIX_FILE"

echo -e "''${GREEN}Successfully updated Cursor from ''${CURRENT_VERSION} to ''${VERSION}!''${NC}"
echo -e "''${YELLOW}Backup saved to $NIX_FILE.bak''${NC}"
echo ""
echo -e "''${YELLOW}Next steps:''${NC}"
echo "  1. Review the changes: git diff $NIX_FILE"
echo "  2. Test the build: nix-build -A cursor (or rebuild your system)"
echo "  3. Remove backup if successful: rm $NIX_FILE.bak"
    '')
  ];
}
