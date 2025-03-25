{ lib, ... }:
with lib; {
  imports = [
    ./syncthing.nix
  ];

  options.my = {
    user = mkOption { type = with lib.types; str; default = null; };
  };
}
