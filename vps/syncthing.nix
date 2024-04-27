{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pass
    gnupg
    syncthing
  ];

  # networking.firewall.allowedTCPPorts = [
  #   8384
  # ];
  services.syncthing = {
    enable = true;
    # Do not allow external access. Tailscale is used instead.
    openDefaultPorts = false;
    guiAddress = "127.0.0.1:8384";
    # cert = "/mycute-cafe/cert.pem";
    # key = "/mycute-cafe/key.pem";
    # guiPasswordFile = "${config.sops.secrets."syncthing-gui-pw".path}";

    settings = {
      gui = {
        user = "kim";
        tls = true;
        insecureSkipHostCheck = true; # bound to localhost, yet, ....
      };
      devices = {
        legion.id = "UMGM442-NCUHA74-K4A7RGG-T5VMYIH-3IW62WY-5HPWDVS-JULPCDB-ZR3DDQI";
        phone.id = "YTJLLTH-2BR26UF-667VH2R-GOIUGYM-ZOYWPZX-GGF4ZSQ-GT5P2R3-BXZWJQ4";
      };
    };
  };
}
