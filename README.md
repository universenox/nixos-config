An initial NixOS system configuration. 
This currently (mostly) works for my Lenovo Legion Y740.

Some info about my system:
```
$ nix-info -m
 - system: `"x86_64-linux"`
 - host os: `Linux 6.6.6, NixOS, 24.05 (Uakari), 24.05.20231211.a9bf124`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.18.1`
 - nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixos`
```

```
$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation CoffeeLake-H GT2 [UHD Graphics 630]
01:00.0 VGA compatible controller: NVIDIA Corporation TU104BM [GeForce RTX 2080 Mobile] (rev a1)
```
