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

    services.tailscale = lib.mkIf (cfg.enableTailscaleClient) {
      enable = true;
      openFirewall = true;
      extraUpFlags = [ "--login-server" "${config.custom_cfg.headscale_login_server}" ];
    };

    # note this is not very reproducible: 
    # device IDs get reset if we start from scratch, and phone that's not on Nix
    # is going to require manual config. but, shouldn't be required often....
    services.syncthing = lib.mkIf (cfg.enableSyncthingClient) {
      enable = cfg.enableSyncthingClient;
      openDefaultPorts = false;
      guiAddress = "0.0.0.0:${toString cfg.syncthing_gui_port}";

      # because it basically needs to touch everything in my ~ anyways.
      user = "${cfg.user}";
      dataDir = "/home/${cfg.user}";

      # note overrideDevices, without key and cert, regens ids.
      # I'm too lazy to set up sops right now.
      # overrideDevices = true;
      # overrideFolders = true;

      settings = {
        listenAddresses = [ "tcp://${cfg.vpn_address}:${toString cfg.syncthing_transfer_port}" ];

        gui = {
          insecureAdminAccess = true; # false warning; we're on vpn.
        };
        options = {
          globalAnnounceEnabled = false;
          localAnnounceEnabled = true;
          relaysEnabled = false;
        };
        devices =
          let
            mkIp = name: "tcp://${name}.${name}.${cfg.vpn_domain}";
          in
          {
            vps = {
              id = "IPP3SII-HQODAZU-5FE6NIG-3PXZ5KC-N4QCPOL-BO2PRCX-6YLJI33-5OU4JQK";
              addresses = [ (mkIp "vps") ];
            };
            legion = {
              id = "RVLK6S2-XOB5XRM-4Y2N6F7-F7WT7BP-N2FBRIX-4EDXWXB-FSFLS2W-OBC55QV";
              addresses = [ (mkIp "legion") ];
            };
            nord = {
              id = "OSH3ZHU-LWQKY7N-7ZDC7LP-K3QJMIK-M4GB56R-BLJYTXT-P6PQNK2-OUEBZQN";
              addresses = [ (mkIp "nord") ];
            };
          };
        folders = let all_devices = [ "vps" "nord" "legion" ]; in {
          # this works for me, but can set device-specific path too if you want.
          nixos = { path = "/etc/nixos/"; devices = all_devices; };
          home-manager = { path = "~/.config/home-manager/"; devices = all_devices; };
          Documents = { path = "~/Documents/"; devices = all_devices; };
          Music = { path = "~/Music/"; devices = all_devices; };
          Pictures = { path = "~/Pictures/"; devices = all_devices; };
        };
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts =
      let
        openssh = config.services.openssh;
        syncthing = config.services.syncthing;
        cfg = config.custom_cfg;
        optionals = lib.lists.optionals;
      in
      optionals openssh.enable openssh.ports ++
      optionals syncthing.enable [ cfg.syncthing_gui_port cfg.syncthing_transfer_port ];
  };
}
