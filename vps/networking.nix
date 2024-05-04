{ config, lib, pkgs, ... }:
{
  networking.hostName = "vps";
  networking.domain = config.custom_cfg.domain;
  networking.firewall.enable = true;
  networking.nftables.enable = true;


  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # TODO: webui?
  # Headscale is served publicly via reverse proxy. (why reverse proxy? because future plans...)
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8181;

    settings = let hs = config.services.headscale; in {
      metrics_listen_addr = "127.0.0.1:9090";
      server_url = config.custom_cfg.headscale_login_server;
      dns_config.base_domain = config.custom_cfg.vpn_domain;
    };
  };

  # caddy just werks.
  services.caddy =
    let
      headscale_addr = "${config.services.headscale.address}:${toString config.services.headscale.port}";
    in
    {
      enable = true;
      configFile = pkgs.writeText "Caddyfile" ''
        headscale.${config.custom_cfg.domain} {
          reverse_proxy ${headscale_addr}
        }
        ${config.custom_cfg.domain} {
          file_server
          root * /mycute-cafe/content
        }
      '';
    };
}
