# Installing cardano-node and cardano-cli

## Pre-requisites:

Install Git,
```bash
sudo apt install git
sudo apt install nix-bin
```

Create .local/bin (standard for ubuntu Single User Setups). 
```bash
mkdir -p ~/.local/bin
```
Any executable placed under ~/.local/bin must be available to the user since `PATH` should have already be defined in `~/.profile` as `PATH="$HOME/.local/bin:$PATH"`

You may have to reload profile if `~/.local/bin` didn't exist before and was just created
```bash
source ~/.profile
echo $PATH
```

## Building via Nix

```bash
git clone https://github.com/IntersectMBO/cardano-node
cd cardano-node
git tag | sort -V
```

The `git tag` shows a list of tags which is equivalent to a version for cardano. Check the [cardano node releases](https://github.com/intersectmbo/cardano-node/releases) and choose the stable version. As of today, the `Latest` (stable) version is `10.4.1` and the `Pre-release` is `10.5.0`

```bash
git switch -d tags/<TAGGED VERSION>
```

### cardano-node

```bash
nix build .#cardano-node
```
NOTE: If you encounter an error, keep reading for more info or skip to [Using flakes](#using-flakes).

Error:
> error: experimental Nix feature 'nix-command' is disabled; use '--extra-experimental-features nix-command' to override

Why was the error thrown?
> Modern Nix CLI command (`nix build`) relies on an experimental feature called `nix-command`, which isn’t enabled by default in some Nix installations — especially on non-NixOS systems like Ubuntu

To fix, 
> nix --extra-experimental-features nix-command build .#cardano-node

### Using flakes

However, Cardano also uses `flakes` that can be determined by checking the repo and looking for a `flake.nix` and `flake.lock`. Add `nix-command` and `flakes`, 

```bash
sudo nix --extra-experimental-features 'nix-command flakes' build .#cardano-node
```

There will be prompts coming from Nix, asking whether you'd like to allow using [https://cache.iog.io] as an extra substituter — which is a binary cache (at [hydra.iohk.io]) maintained by `IOG (Input Output Global)`, the original developers of Cardano. Answer `y` to the following questions,
```bash
do you want to allow configuration setting 'extra-substituters' to be set to 'https://cache.iog.io' (y/N)? y
do you want to permanently mark this value as trusted (y/N)? y
do you want to allow configuration setting 'extra-trusted-public-keys' to be set to 'hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=' (y/N)? y    
do you want to permanently mark this value as trusted (y/N)? y
```

`cardano-node` must now be built and available for use. Move it to `~/.local/bin`
```bash
cp ~/cardano-node/result/bin/cardano-node ~/.local/bin
```

### cardano-cli

```bash
sudo nix --extra-experimental-features 'nix-command flakes' build .#cardano-cli
```

`cardano-cli` must now be built and available for use. Move it to `~/.local/bin`
```bash
cp ~/cardano-node/result/bin/cardano-cli ~/.local/bin
```

### cardano-node & cardano-cli
Both are now installed
```bash
cardano-node --version
cardano-cli --version
```