An initial NixOS system configuration for my Lenovo Legion Y740. 

Note this does not contain much user configuration as I use home-manager for that.
(A separate repo.)

I switch between Hyprland and KDE sessions.

However, it appears the my login to Hyprland is bugged; sometimes it logs into tty instead, at which point 
I have to manually run `Hyprland`.

```
$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation CoffeeLake-H GT2 [UHD Graphics 630]
01:00.0 VGA compatible controller: NVIDIA Corporation TU104BM [GeForce RTX 2080 Mobile] (rev a1)
```
