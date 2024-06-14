{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      #EDITOR = "lvim";
      #BROWSER = "librewolf";
      #TERMINAL = "kitty";
      GBM_BACKEND= "nvidia-drm";
      LIBVA_DRIVER_NAME= "nvidia"; # hardware acceleration
      __GLX_VENDOR_LIBRARY_NAME= "nvidia";
      __GL_VRR_ALLOWED="1";
      #WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      WLR_RENDERER = "vulkan";
      CLUTTER_BACKEND = "wayland";
      NIXOS_OZONE_WL = "1";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
