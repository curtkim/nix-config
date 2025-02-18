{
  # DLNA Server
  services.minidlna.enable = true;
  services.minidlna.settings ={
    notify_interval = 30;
    friendly_name = "um790";
    media_dir = [
      "/data/video/"
      "/data/music/"
    ];
    inotify = "yes";
  };

  users.users.minidlna = {
    extraGroups =
      [ "users" ]; # so minidlna can access the files.
  };
}
