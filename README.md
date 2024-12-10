## notes
- unstable을 사용하는 이유는 google-chrome, nvim 때문

## howto

    nix flake update --update-input nixpkgs-unstable

    NIXPKGS_ALLOW_UNFREE=1 nix build --impure .#packages.vivado-2022_2
    result/bin/vivado

## reference
- https://github.com/lschuermann/nur-packages/blob/master/pkgs/vivado/vivado-2022_2.nix

## Adding files to the store 

```
$ sudo unshare -m bash  # open a shell as root in a private mount namespace
$ largefile=/path/to/file
$ hash=$(nix-hash --type sha256 --flat --base32 $largefile)  # sha256 hash of the file
$ storepath=$(nix-store --print-fixed-path sha256 $hash $(basename $largefile))  # destination path in the store
$ mount -o remount,rw /nix/store  # remount the store in read/write mode (only for this session)
$ cp $largefile $storepath  # copy the file
$ printf "$storepath\n\n0\n" | nix-store --register-validity --reregister  # register the file in the Nix database
$ exit  # exit to the original shell where /nix/store is still mounted read-only
```

## build packages
    
    nix build .#packages.claude-engineer --show-trace --print-build-logs --verbose

