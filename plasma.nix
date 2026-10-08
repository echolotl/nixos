{ ... }:

let
  font = {
    family = "IBM Plex Sans";
    pointSize = 10;
  };
in
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
    fonts = {
      general = font;
      menu = font;
      toolbar = font;
      windowTitle = font;

      fixedWidth = {
        family = "Google Sans Code";
        pointSize = 10;
      };
      small = {
        family = "IBM Plex Sans";
        pointSize = 8;
      };
    };
  };
}
