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
      InitialKeyRepeat = 25;
      # Holding a key repeats it (e.g. hjkl in nvim) instead of opening the accent picker.
      ApplePressAndHoldEnabled = false;
    };

    trackpad = {
      Clicking = true; # tap to click
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };

    # Rectangle handles window tiling, so macOS's own drag-to-edge tiling is off.
    WindowManager = {
      EnableTiledWindowMargins = false;
      EnableTilingByEdgeDrag = false;
      EnableTopTilingByEdgeDrag = false;
      EnableTilingOptionAccelerator = false;
    };

    menuExtraClock.ShowSeconds = true;
    controlcenter.Bluetooth = true; # show in menu bar

    CustomUserPreferences."com.apple.HIToolbox".AppleEnabledInputSources = [
      { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 252; "KeyboardLayout Name" = "ABC"; }
      { InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = -18432; "KeyboardLayout Name" = "Hebrew"; }
      { InputSourceKind = "Non Keyboard Input Method"; "Bundle ID" = "com.apple.CharacterPaletteIM"; }
    ];
  };
}
