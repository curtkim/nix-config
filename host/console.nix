{ config, pkgs, ... }:
{
  console.packages = [ pkgs.terminus_font ];
  console.font = "ter-u32n";
}
