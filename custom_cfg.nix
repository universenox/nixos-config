{ config, lib, pkgs, ... }:
let
  cfg = config.custom_cfg;
  hostname = config.networking.hostName;
in
with lib;
{
  # my own configuration options. 
  options.custom_cfg = {
    user = mkOption { type = with lib.types; str; default = null; };
    enableTailscaleClient = mkEnableOption (lib.mdDoc "tailscale client");
    enableSyncthingClient = mkEnableOption (lib.mdDoc "syncthing client");

    # do not change these. idk how to just get global constants vs ptions 
    # nixpkgs syncthing, idk how to configure devices....
    tailscale_user = mkOption { type = with lib.types; str; default = "${hostname}"; };
    syncthing_gui_port = mkOption { type = with types; int; default = 8384; };
    syncthing_transfer_port = mkOption { type = with types; int; default = 22000; };
    domain = mkOption { type = with types; str; default = "mycute.cafe"; };
    vpn_domain = mkOption { type = with types; str; default = "vpn.net"; }; # note tailscale DNS means this is internal only.
    headscale_login_server = mkOption { type = with types; str; default = "https://headscale.${cfg.domain}"; };
    vpn_address = mkOption { type = with types; str; default = "${hostname}.${cfg.tailscale_user}.${cfg.vpn_domain}"; };
  };

  config = {
    assertions = [
      {
        assertion = hasAttr cfg.user config.users.users;
        message = "user mismatch";
      }
    ];

    # headscale is borken.
    # idk if i even wanna bother....
    # services.tailscale = lib.mkIf (cfg.enableTailscaleClient) {
    #   enable = true;
    #   openFirewall = true;
    #   extraUpFlags = [ "--login-server" "${config.custom_cfg.headscale_login_server}" ];
    # };

    services.syncthing = lib.mkIf (cfg.enableSyncthingClient) {
      enable = cfg.enableSyncthingClient;
      # would slightly prefer syncthing on vpn only, but w/e.
      openDefaultPorts = true;
      # guiAddress = "0.0.0.0:${toString cfg.syncthing_gui_port}";
      guiAddress = "localhost:${toString cfg.syncthing_gui_port}";

      user = "${cfg.user}";
      dataDir = "/home/${cfg.user}";

      settings = {
        options = {
          globalAnnounceEnabled = false;
          localAnnounceEnabled = true;
          relaysEnabled = false;
        };
        # don't specify the IP addresses. rely on global/local discovery.
        # note this relies on some local state; would require manual reconfig for device ids etc
        # if you cleared its home dir
        devices = {
          vps.id = "IPP3SII-HQODAZU-5FE6NIG-3PXZ5KC-N4QCPOL-BO2PRCX-6YLJI33-5OU4JQK";
          legion.id = "RVLK6S2-XOB5XRM-4Y2N6F7-F7WT7BP-N2FBRIX-4EDXWXB-FSFLS2W-OBC55QV";
          pixel.id = "R2H6G4T-IIBAH4A-W6J7IPO-DPRQLRC-RBC46CP-CP6DMBV-6L2JCW5-5JYXHA2";
          carbonara.id = "RIXWUCR-O42UR2U-AQD632P-YBUNCSC-KPORSUG-NHVZNWR-BABZM4Q-C7QHPQ5";
        };
        # note this is the view of things from the local device.
        folders = let all_devices = [ "pixel" "legion" "carbonara" ]; 
        in {
          # this works for me, but can set device-specific path too if you want.
          Documents = { path = "~/Documents/"; devices = all_devices; };
          Music = { path = "~/Music/"; devices = all_devices; };
          Pictures = { path = "~/Pictures/"; devices = all_devices; };

          # TODO: be better about using git...
          MyCode = { path = "~/MyCode"; devices = all_devices; };

          nixos = { path = "/etc/nixos/"; devices = all_devices; };
          home-manager = { path = "~/.config/home-manager/"; devices = all_devices; };
          passwords = { path = "~/.password-store"; devices = all_devices; };
          gnupg = { path = "~/.gnupg"; devices = all_devices; };
          ssh = { path = "~/.ssh"; devices = all_devices; };
        };
      };
    };

  # no longer using.
  #   networking.firewall.interfaces.tailscale0.allowedTCPPorts =
  #     let
  #       openssh = config.services.openssh;
  #       syncthing = config.services.syncthing;
  #       cfg = config.custom_cfg;
  #       optionals = lib.lists.optionals;
  #     in
  #     optionals openssh.enable openssh.ports ++
  #     optionals syncthing.enable [ cfg.syncthing_gui_port cfg.syncthing_transfer_port ];
  # };
  };
}
