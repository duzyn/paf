# paf  <!-- omit from toc -->

**English** | [简体中文](./README_ZH_CN.md)

- [Features](#features)
- [Installation](#installation)
  - [Method 1: Clone the repository (recommended)](#method-1-clone-the-repository-recommended)
  - [Method 2: Download the archive of the repository](#method-2-download-the-archive-of-the-repository)
- [Usage](#usage)
- [Advanced options](#advanced-options)
- [Thanks](#thanks)

paf is a command-line package manager for PortableApps.

## Features

Use paf to install the PortableApps portable software you need with just a few lines of command. Its main features are:

- More than 490 high-quality portable software can be installed from [PortableApps.com](https://portableapps.com/apps).
- Portable software added to PortableApps.com can be installed or updated in paf right away.
- No graphical interface, which runs faster than [PortableApps.com Platform](https://portableapps.com/platform/features).
- Written in Batch scripts, which is compatible with all Windows OS and does not need to release execution permissions like PowerShell scripts.
- Pretty much the same command usage as Scoop, quick to learn (if you're already familiar with Scoop).
- Downloading portable software is faster than PortableApps.com Platforms **in China**, using aria2 to speed up downloads.

## Installation

### Method 1: Clone the repository (recommended)

Run the following command to clone this repository to your system:

    git clone https://github.com/duzyn/paf
    // or git clone https://mirror.ghproxy.com/github.com/duzyn/paf
    // or git clone https://gh-proxy.com/github.com/duzyn/paf
    cd paf

Run `paf` to view the instructions. If there is an update to paf, it can be updated using Git.

### Method 2: Download the archive of the repository

Click to [Download](https://github.com/duzyn/paf/archive/refs/heads/main.zip) or [Download from mirror 1](https://mirror.ghproxy.com/github.com/duzyn/paf/archive/refs/heads/main.zip) or [Download from mirror 2](https://gh-proxy.com/github.com/duzyn/paf/archive/refs/heads/main.zip) the archive of the latest code, unzip it to a folder, go to the folder, and run `paf` to view the instructions.

## Usage

```
C:\paf-cli>paf
paf 1.0
A command-line installer for PortableApps.
Project home page: https://github.com/duzyn/paf

USAGE:
    paf COMMAND [ARGS]

ARGS:
    AppID
        AppID is defined in PortableApps.com Format, reference:
        https://portableapps.com/development/portableapps.com_format#appinfo
    *
        When upgrading apps, * means all.

COMMANDS:
    cat
        Show content of specified app manifest.
            paf cat FirefoxPortable
    checkup
        Check for dependencies.
            paf checkup
    clean
        Clean the download cache.
            paf clean
    download
        Download apps in the downloads folder and verify hashes.
            paf download FirefoxPortable
            paf download FirefoxPortable GoogleChromePortable
    export
        Exports installed apps in CSV format.
            paf export
    help
        Show this help.
            paf
            paf help
            paf --help
            paf -h
    home
        Opens the app homepage.
            paf home FirefoxPortable
    import
        Imports apps from a text file.
            paf import apps.csv
    info
        Display information about an app.
            paf info FirefoxPortable
    install
        Install an app.
            paf install FirefoxPortable
            paf install FirefoxPortable GoogleChromePortable
    known
        List all known apps.
            paf known
    list
        List installed apps.
            paf list
    search
        Search available apps.
            paf search firefox
    status
        Show status and check for new app versions.
            paf status
    uninstall
        Uninstall an app.
            paf uninstall FirefoxPortable
            paf uninstall FirefoxPortable GoogleChromePortable
    update
        Update cache.
            paf update
    upgrade
        Update an app.
            paf upgrade FirefoxPortable
            paf upgrade FirefoxPortable GoogleChromePortable
            paf upgrade *
```

## Advanced options

The following advanced options can be set according to your actual situation.

- [aria2-min-split-size](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k): Default is 1MB
- [aria2-split](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s): Default is 10
- [aria2-max-connection-per-server](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-x): Default is 10
- [aria2-max-concurrent-downloads](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-j): Default is 50
- [aria2-max-tries](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-m): Default is 2
- [aria2-connect-timeout](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-connect-timeout): Default is 10
- github-mirror: Default is false, If users in China are slow to access GitHub, they can set it to <https://gh-proxy.com/github.com> or <https://mirror.ghproxy.com/github.com>

## Thanks

- [Scoop](https://github.com/ScoopInstaller/Scoop)
- [Homebrew](https://github.com/Homebrew/brew)
- [PortableApps.com](https://portableapps.com/apps)
