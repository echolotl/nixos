{ config, pkgs, lib, ... }:

{
  # Import the hardware scan.
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    # Use limine as the boot loader.
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
      limine = {
        enable = true;
        maxGenerations = 2; # Only keep two generations cuz my EFI partition is too small...

        # Secure boot.
        secureBoot = {
          enable = true;
          autoGenerateKeys = true;
        };

        # Also put Windows as an option
        extraEntries = ''
          /Windows
            protocol: efi
            path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
        '';
        style.wallpapers = [ "/run/media/echolotl/2TB/boot.png" ];
      };
    };

    # Enable the Plymouth screen.
    plymouth.enable = true;
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
    loader.timeout = 0;

    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Give me access to the games drive (xbox 720)
  fileSystems."/mnt/sda3" = {
    device = "/dev/disk/by-uuid/C0A61990A61987D4";
    fsType = "ntfs3";
    options = [
      "uid=1000"
    ];
  };

  # Enable the `nix` command and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "echolotl-nixo";
    wireless.enable = true; # Enable Wi-Fi

    networkmanager.enable = true;
  };

  time.timeZone = "America/Chicago";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    # X11
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = [ "nvidia" ]; # NVIDIA!!!!
      excludePackages = [ pkgs.xterm ]; # Get rid of xterm, don't need it.
    };

    # Enable KDE Plasma.
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    # Printing.
    printing.enable = true;

    # Use pipewire instead of pulseaudio.
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable Tailscale.
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    # ya sure ig
    croc.enable = true;
  };

  security.rtkit.enable = true; # for Pipewire.

  users.users."echolotl" = {
    isNormalUser = true;
    description = "echolotl";
    extraGroups = [ "networkmanager" "wheel" ];
    # User packages.
    packages = with pkgs; [
      kdePackages.kate
      heroic
      discord
      helium
      prismlauncher
      zed-editor-fhs
    ];

    # Use fish shell instead of bash.
    shell = pkgs.fish;
  };

  # Documentation is all online anyways and I prefer that to the built-in one.
  documentation.nixos.enable = false;

  # Allow unfree software. (maybe come back to this and only allow specific things through?)
  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true; # For Steam, specifically.
    };

    # NVIDIA!!!!!!
    nvidia = {
      modesetting.enable = true;
      open = false; # ya
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Enable bluetooth. (for passkeys on my phone mostly)
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Programs.
  programs = {
    steam.enable = true;
    fish.enable = true;
    git = {
      enable = true;
      config = {
        user.name = "echolotl";
        user.email = "echolotl@echolotl.lol";
        init.defaultBranch = "main";
      };
    };
  };

  # Global system packages.
  environment.systemPackages = with pkgs; [
    haxe
    sbctl
    rustc
    cargo
    rustup
    pnpm
    gh
    gcc
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
