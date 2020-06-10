# Dotfiles

My configuration files to make the process of migration between hardware
easier.

## Set CapsLock to switch language layout on Linux

```bash
sudo apt install gnome-tweak-tool
gnome-tweaks
```

## Remap Super + Arrow

```
sudo apt-get update
sudo apt-get install autokey-gtk
```

- Register the phrases from `autokey-phrases`.
- Go to `Edit -> Preferences -> Application`
- Check `Automatically start AutoKey at login`

## Software installation instructions

### OpenSSL

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install libssl-dev
```


### [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Install and set `git push/pull` to default to the current branch.

> [Caveat](https://stackoverflow.com/a/37779390):
>
> Before this make sure to the `./ssh` directory from this repo to `~/.ssh`.
> If there is an error like `Permissions 0644 for '~/.ssh/id_rsa' are too open`.
> Use the following command to fix them:
>
> ```bash
> chmod 400 ~/.ssh/id_rsa
> ```

```bash
sudo apt install git-all
git config --global push.default current
git config --global pull.default current
```

[Register](http://egorsmirnov.me/2015/05/04/global-gitignore-file.html) `~/.gitignore_global`:
```bash
git config --global core.excludesfile ~/.gitignore_global
```

### Docker

- [`docker`](https://docs.docker.com/get-docker/)
    - [Follow docker post-install steps to manage docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)
    - [Change docker data dir](https://blog.adriel.co.nz/2018/01/25/change-docker-data-directory-in-debian-jessie/)

- [`docker-compose`](https://docs.docker.com/compose/install/)

### Rust

> [Caveat](https://stackoverflow.com/a/52445962): you are required to install the C linker
>
> ```bash
> sudo apt install build-essential
> ```

- [`rustup`](https://www.rust-lang.org/tools/install)
- [`sccache`](https://github.com/mozilla/sccache)
    ```bash
    cargo install sccache --features=all
    ```

### Premake5

Visit [the webpage](https://premake.github.io/download.html) and download the binary
manually.

### Nodejs

// TODO: fill in


### Java

// TODO: fill in
