# Home Manager configuration for KDE Plasma using Plasma Manager
# ...lots of managing happening
{ ... }:

{
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = ./wallpapers/cotlawesome4.jpg;
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 22;
      };
    };
    kscreenlocker.appearance.wallpaper = ./wallpapers/lock.png;
    configFile = {
      kdeglobals.General.AccentColor = "233,58,154";
      kdeglobals.KDE.widgetStyle = "Union";
    };
  };
}
