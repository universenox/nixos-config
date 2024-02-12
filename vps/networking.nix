{ config, lib, pkgs, ... }:
{
  networking.hostName = "kimserv";
  networking.domain = "mycute.cafe";
  networking.firewall.enable = true;
  networking.nftables.enable = true;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    user = "nginx";
    group = "nginx";

    # TODO: no work.
    appendHttpConfig =
      ''
        # catch-all
        server {
          listen 80;
          return 444;
        }
        server {
          listen 443;
          ssl_certificate     /mycute-cafe/cert.pem;
          ssl_certificate_key /mycute-cafe/key.pem;
          return 444;
        }
      '' +
      (if config.services.syncthing.enable then
        ''
          upstream syncthing {
            server ${config.services.syncthing.guiAddress};
          }
          server {
            listen 80;
            server_name sync.mycute.cafe www.sync.mycute.cafe;
            return 301 https://$host$request_uri;
          }
          server {
            listen 443 ssl;
            server_name sync.mycute.cafe;

            location / {
              proxy_set_header  Host            $host;
              proxy_set_header  X-Real-IP       $remote_addr;
              proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_pass        http://syncthing;
            }
          }
        '' else "")
      +
      ''
         server {
           listen 80;
           server_name www.mycute.cafe mycute.cafe;
           return 301 https://$host$request_uri;
         }
        server {
          listen 443 ssl;
          server_name www.mycute.cafe mycute.cafe;

          ssl_certificate     /mycute-cafe/cert.pem;
          ssl_certificate_key /mycute-cafe/key.pem;
          root /mycute-cafe/content/;
          location / {
            index index.html;
          }
        }
      '';
  };
}
