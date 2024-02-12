{ pkgs, ... }: {
  # Can see previously-banned by searching "Ban" in journalctl.
  # some stats can be seein in `fail2ban-client status sshd`
  services.fail2ban = {
    enable = true;
    bantime = "1d"; # initial
    bantime-increment.enable = true;
    bantime-increment.maxtime = "4w";
    bantime-increment.factor = "2";

    # should never fail bc I only access w/ key
    maxretry = 1;
  };
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-import-id gh:universenox'' ];
  users.users.kim.openssh.authorizedKeys.keys = [ ''ssh-import-id gh:universenox'' ];

  # TODO
  # ssh.knownHostss

  services.openssh = {
    enable = true;
    hostKeys = [{ path = "/etc/ssh/mycute.cafe"; type = "ed25519"; }];
    extraConfig = ''
      ChallengeResponseAuthentication no
      PasswordAuthentication no
      PermitRootLogin no
      PermitRootLogin prohibit-password
    '';
  };
}
