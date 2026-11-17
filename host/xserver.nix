# modules/nixos/xserver.nix 로 옮겼다. 아직 dendritic 으로 전환하지 않은 호스트를 위한 shim.
{ inputs, ... }:
{
  imports = [ inputs.self.modules.nixos.xserver ];
}
