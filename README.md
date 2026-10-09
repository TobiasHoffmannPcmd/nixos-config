# nixos-config

Shared NixOS + home-manager setup for WSL.

## Setup (new machine)

1. Install WSL2 and the [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) distro.
2. Clone this repo to `/etc/nixos` as your own user (not with `sudo`):
   ```
   git clone git@github.com:TobiasHoffmannPcmd/nixos-config.git /etc/nixos
   ```
3. Remove old `configuration.nix`.
4. In `flake.nix`, add yourself to the `hosts` list (copy the `newUser-pc` entry and edit it):
   ```nix
   your-pc = {
     username = "yourname";
     gitName = "Your Name";
     gitEmail = "you@globalwindsafety.org";
   };
   ```
5. Build and switch, using the host name you picked:
   ```
   sudo nixos-rebuild switch --flake /etc/nixos#your-pc
   ```
6. Commit and push your new `hosts` entry so your config is backed up.

## Updating

```
cd /etc/nixos
nix flake update
sudo nixos-rebuild switch --flake .#<your-host-name>
git add -A && git commit -m "update flake inputs"
git push
```
