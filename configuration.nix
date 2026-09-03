# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    # Use limine as the boot loader.
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
      limine = {
        enable = true;
        maxGenerations = 2;

        # Secure boot.
        secureBoot = {
          enable = true;
          autoGenerateKeys = true;
        };

        extraEntries = ''
              /Windows
          protocol: efi
          path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
        '';

        style.wallpapers = [ ./wallpapers/boot.png ];
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
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable the `nix` command and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = "echolotl-nixt";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."echolotl" = {
    isNormalUser = true;
    description = "echolotl";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
      heroic
      discord
      helium
      prismlauncher
    ];

    # Use fish shell instead of bash.
    shell = pkgs.fish;
  };

  # Documentation is all online anyways and I prefer that to the built-in one.
  documentation.nixos.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics.enable = true;

    # NVIDIA!!!!!!
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:101:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Enable bluetooth. (for passkeys on my phone mostly)
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Programs.
  programs = {
    fish.enable = true;
    git = {
      enable = true;
      config = {
        user.name = "echolotl";
        user.email = "echolotl@echolotl.lol";
        init.defaultBranch = "main";
        safe.directory = [
          "/etc/nixos"
        ];
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
    nil
    nixd
    bibata-cursors
    wineWow64Packages.stable
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
