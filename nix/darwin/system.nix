{ ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  # Determinate Nix owns the nix daemon and its config; nix-darwin must not manage it too.
  nix.enable = false;

  system.primaryUser = "tomhalo";
  system.stateVersion = 6;

  # reattach makes Touch ID work inside tmux sessions as well.
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # oh-my-zsh runs compinit itself; a second global one only slows shell startup.
  programs.zsh.enableGlobalCompInit = false;

  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 49;
      magnification = true;
      largesize = 16;
      show-recents = false;
      mineffect = "genie";
      persistent-apps = [
        "/System/Applications/Apps.app"
        "/Applications/Brave Browser.app"
        "/Applications/KeePassXC.app"
        "/Applications/Obsidian.app"
        "/Applications/Slack.app"
        "/Applications/Firefox.app"
        "/Applications/Ghostty.app"
      ];
    };

    finder.FXPreferredViewStyle = "Nlsv"; # list view

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 30;
    };

    trackpad = {
      Clicking = true; # tap to click
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };

    WindowManager.EnableTiledWindowMargins = false;

    menuExtraClock.ShowSeconds = true;
  };
}
