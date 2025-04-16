{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let 
      #browser = "google-chrome.desktop";
      browser = "firefox.desktop";
      image-viewer = "imv.desktop";
    in {
      "image/png" = image-viewer;
      "text/html" = browser;
      "application/pdf" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
    };
  };
}
