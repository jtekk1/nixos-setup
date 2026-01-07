{ config, lib, ... }:

# Homebrew on Linux (Linuxbrew) integration
# Install homebrew manually first: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#
# Packages to install via brew:
#   brew tap ublue-os/tap
#   brew tap ublue-os/experimental-tap
#   brew install spotify-tui
#   brew install --cask jetbrains-toolbox-linux
#   brew install --cask lm-studio-linux
#   brew install --cask cursor-linux
#   brew install --cask helium-browser
{
  # Add Homebrew to PATH
  home.sessionPath = [
    "/home/linuxbrew/.linuxbrew/bin"
    "/home/linuxbrew/.linuxbrew/sbin"
  ];

  # Set up Homebrew environment variables
  home.sessionVariables = {
    HOMEBREW_PREFIX = "/home/linuxbrew/.linuxbrew";
    HOMEBREW_CELLAR = "/home/linuxbrew/.linuxbrew/Cellar";
    HOMEBREW_REPOSITORY = "/home/linuxbrew/.linuxbrew/Homebrew";
  };

  # Add homebrew completions and man pages
  programs.bash.initExtra = lib.mkAfter ''
    # Homebrew shell integration
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  '';
}
