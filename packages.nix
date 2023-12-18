{ lib, config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim_configurable
    wget
    curl
    git
    htop
    lshw
  ];
  environment.variables.EDITOR = "vim";

  programs.neovim.enable = true;
  programs.command-not-found.enable = true;

  users.users.kim.packages = with pkgs; [
    firefox
    discord
    pass
    qbittorrent
    obs-studio
    vscodium-fhs
  ];

  # for gpg / pass
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };
}
