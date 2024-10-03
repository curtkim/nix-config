{
  # DLNA Server
  services.minidlna.enable = true;
  services.minidlna.settings ={
    notify_interval = 60;
    friendly_name = "PCMEDIA";
    media_dir = ["V,/home/curt/Videos/"];
  };
}
