**English** | [简体中文](./README_ZH_CN.md)

# paf  <!-- omit from toc -->

- [Features](#features)
- [Installation](#installation)
  - [Method 1: Clone the repository (recommended)](#method-1-clone-the-repository-recommended)
  - [Method 2: Download the archive of the repository](#method-2-download-the-archive-of-the-repository)
  - [Method 3: Download paf.cmd](#method-3-download-pafcmd)
- [Usage](#usage)
  - [Help](#help)
  - [Update bucket](#update-bucket)
  - [Search](#search)
  - [Install portable app](#install-portable-app)
  - [Download portable software](#download-portable-software)
  - [Update portable software](#update-portable-software)
  - [Uninstall portable software](#uninstall-portable-software)
  - [List installed apps](#list-installed-apps)
  - [List outdated apps](#list-outdated-apps)
  - [List all the apps that can be installed](#list-all-the-apps-that-can-be-installed)
  - [Export installed apps](#export-installed-apps)
  - [Import a CSV file to install apps in bulk](#import-a-csv-file-to-install-apps-in-bulk)
  - [Displays information about the app](#displays-information-about-the-app)
  - [Displays more detailed information about the app](#displays-more-detailed-information-about-the-app)
  - [Open the app on the home page of PortableApps](#open-the-app-on-the-home-page-of-portableapps)
  - [Clear cache](#clear-cache)
  - [Check the dependency of the paf](#check-the-dependency-of-the-paf)
- [Advanced options](#advanced-options)
- [Thanks](#thanks)

paf is a command-line package manager for PortableApps.

## Features

Use paf to install the PortableApps portable software you need with just a few lines of command. Its main features are:

- More than 460 high-quality portable software can be installed on [PortableApps.com](https://portableapps.com/apps).
- Portable software added to PortableApps.com can be installed or updated in paf right away.
- No graphical interface, which runs faster than [PortableApps.com Platform](https://portableapps.com/platform/features).
- Written in Batch scripts, which is compatible with all Windows OS and does not need to release execution permissions like PowerShell scripts.
- Pretty much the same command usage as Scoop, quick to learn (if you're already familiar with Scoop).
- Downloading portable software is faster than PortableApps.com Platforms **in China**, using aria2 to speed up downloads.

## Installation

### Method 1: Clone the repository (recommended)

Run the following command to clone this repository to your system:

    git clone https://github.com/duzyn/paf
    cd paf

Run `paf` to view the instructions. If there is an update to paf, it can be updated using Git.

### Method 2: Download the archive of the repository

Click to [Download](https://github.com/duzyn/paf/archive/refs/heads/main.zip) the archive of the latest code, unzip it to a folder, go to the folder, and run `paf` to view the instructions.

### Method 3: Download paf.cmd

If you don't want to use the executable file from this repository, you can just download the [paf.cmd](./paf.cmd) file and run `paf` to view the instructions.

This application relies on the three tools of aria2, ripgrep, sed, and when there is no corresponding executable file, run `paf checkup` to view the help. Go to the URL below to manually download aria2, ripgrep, sed,

- [aria2](https://github.com/aria2/aria2/releases)
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases)
- [sed](https://github.com/mbuilov/sed-windows/releases)

It is recommended to download the 32-bit (x86) version so that it can run on both 32-bit and 64-bit Windows. After downloading, put the corresponding executable file into the bin folder (sed needs to be renamed), and the end result should look like this:

```
paf.cmd
bin\
├── aria2c.exe
├── rg.exe
└── sed.exe
```

That's all the files you need to run paf.

## Usage

### Help

Run `paf` or `paf help` to see the help. Run `paf help <command>` to see the help of the command, e.g. `paf help install`

```
>paf help

Usage: paf <command> [<args>]

Available commands are listed below.
Type 'paf help <command>' to get more help for a specific command.

Command    Summary
-------    -------
cat        Show content of specified app manifest
checkup    Check for dependencies
clean      Clean the download cache
download   Download apps in the downloads folder and verify hashes
export     Exports installed apps in CSV format
help       Show this help
home       Opens the app homepage
import     Imports apps from a text file
info       Display information about an app
install    Install an app
known      List all known apps
list       List installed apps
search     Search available apps
status     Show status and check for new app versions
uninstall  Uninstall an app
update     Update cache
upgrade    Update an app
```

```
>paf help install

Usage: paf install <app>

e.g. The usual way to install an app:
    paf install FirefoxPortable
To install multi apps:
    paf install FirefoxPortable GoogleChromePortable
```

### Update bucket

Before installing the portable apps, you need to run `paf update` to update the bucket, wait for a while, and wait until the update is over, and then you can install the portable apps.

```
>paf update

Updating apps cache ... Done
Updating bucket ... Done
Total: 462 apps.
```

### Search

You can use `paf search <app>` to search for portable apps. The results of the search can be used to install the app.

```
>paf search notepad

Search results:
* Notepad++Portable
* Notepad2-modPortable
* Notepad2Portable
Total: 3 apps.
```
### Install portable app

You can use `paf install <app>` to install portable software. It is possible to install one at a time, for example:

```
>paf install Notepad2Portable

Downloading Notepad2Portable_4.2.25_Rev_2_English.paf.exe ...
[#9fedb5 848KiB/879KiB(96%) CN:1 DL:47KiB]
Download Results:
gid   |stat|avg speed  |path/URI
======+====+===========+=======================================================
9fedb5|OK  |    55KiB/s|C:/Users/John Doe/paf/downloads/Notepad2Portable_4.2.25_Rev_2_English.paf.exe

Status Legend:
(OK):download completed.
Checking hash of Notepad2Portable_4.2.25_Rev_2_English.paf.exe ... OK
Installing Notepad2Portable 4.2.25 Rev 2 ...
Please continue with the PortableApps.com Installer.
Notepad2Portable 4.2.25 Rev 2 was installed successfully.
```

It is also possible to install more than one at a time, for example:

```
>paf install Notepad2Portable Notepad2-modPortable

Downloading Notepad2Portable_4.2.25_Rev_2_English.paf.exe ...
[#e08484 384KiB/879KiB(43%) CN:1 DL:157KiB ETA:3s]
Download Results:
gid   |stat|avg speed  |path/URI
======+====+===========+=======================================================
e08484|OK  |   252KiB/s|C:/Users/John Doe/paf/downloads/Notepad2Portable_4.2.25_Rev_2_English.paf.exe

Status Legend:
(OK):download completed.
Checking hash of Notepad2Portable_4.2.25_Rev_2_English.paf.exe ... OK
Installing Notepad2Portable 4.2.25 Rev 2 ...
Please continue with the PortableApps.com Installer.
Notepad2Portable 4.2.25 Rev 2 was installed successfully.
Downloading Notepad2-modPortable_4.2.25.998_English.paf.exe ...
[#0fefce 1.4MiB/1.4MiB(98%) CN:1 DL:19KiB]
Download Results:
gid   |stat|avg speed  |path/URI
======+====+===========+=======================================================
0fefce|OK  |    49KiB/s|C:/Users/John Doe/paf/downloads/Notepad2-modPortable_4.2.25.998_English.paf.exe

Status Legend:
(OK):download completed.
Checking hash of Notepad2-modPortable_4.2.25.998_English.paf.exe ... OK
Installing Notepad2-modPortable 4.2.25.998 ...
Please continue with the PortableApps.com Installer.
Notepad2-modPortable 4.2.25.998 was installed successfully.
```

Note:

- Because the PortableApps installation package does not support the command line option, you can only manually follow the wizard step by step to install it.
- By default, paf only detects PortableApps folders under the same disk partition, such as E:\PortableApps, so you need to install portable programs in the same disk partition as paf

### Download portable software

If you only want to download portable software, you can use `paf download <app>`, which allows you to download one or more at a time.

```
>paf download Notepad2Portable

Downloading Notepad2Portable_4.2.25_Rev_2_English.paf.exe ...
[#9fedb5 848KiB/879KiB(96%) CN:1 DL:47KiB]
Download Results:
gid   |stat|avg speed  |path/URI
======+====+===========+=======================================================
9fedb5|OK  |    55KiB/s|C:/Users/John Doe/paf/downloads/Notepad2Portable_4.2.25_Rev_2_English.paf.exe

Status Legend:
(OK):download completed.
Checking hash of Notepad2Portable_4.2.25_Rev_2_English.paf.exe ... OK
```

### Update portable software

You can use `paf upgrade <app>` to update portable software, which supports one or more updates at a time. You can also type `paf upgrade *` and you can update all known portable software.

```
>paf upgrade *

FirefoxPortableESR is up to date.
MPC-HCPortable is up to date.
Notepad++Portable is up to date.
Notepad2-modPortable is up to date.
Notepad2Portable 4.2.25 is installed.
* Notepad2Portable: 4.2.25 -> 4.2.25 Rev 2
Checking hash of Notepad2Portable_4.2.25_Rev_2_English.paf.exe ... OK
Installing Notepad2Portable 4.2.25 Rev 2 ...
Please continue with the PortableApps.com Installer.
Notepad2Portable 4.2.25 Rev 2 was installed successfully.
SMPlayerPortable is up to date.
VentoyPortable is up to date.
VLCPortable is up to date.
WinMergePortable is up to date.
ZSoftUninstallerPortable is up to date.
```

### Uninstall portable software

You can use `paf uninstall <app>` to uninstall portable software, which allows you to uninstall one or more at a time.

```
>paf uninstall Notepad2Portable

Uninstalling Notepad2Portable 4.2.25 Rev 2 ...
Removing C:\PortableApps\Notepad2Portable\ ...
Notepad2Portable 4.2.25 Rev 2 was uninstalled successfully.
```

### List installed apps

```
>paf list

Installed apps:
* FirefoxPortableESR: 115.4.0 Rev 2
* MPC-HCPortable: 2.0.0
* Notepad++Portable: 8.5.8
* Notepad2-modPortable: 4.2.25.998
* Notepad2Portable: 4.2.25
* SMPlayerPortable: 23.6.0
* VentoyPortable: 1.0.96
* VLCPortable: 3.0.19
* WinMergePortable: 2.16.32
* ZSoftUninstallerPortable: 2.5 Rev 3
Total: 10 apps.
```

### List outdated apps

```
>paf status

Outdated apps:
* Notepad2Portable: 4.2.25 -> 4.2.25 Rev 2
Total: 1 apps.

```

### List all the apps that can be installed

`paf known`

This command outputs too much, so I won't show an example. It can be viewed using the `paf known > apps.csv` export. apps.csv, This file name can be changed as you wish.

### Export installed apps

`paf export > paf.csv`

paf.csv, This file name can be changed as you wish.

### Import a CSV file to install apps in bulk

`paf import paf.csv`

paf.csv, This file name can be changed as you wish.

### Displays information about the app

```
>paf info Notepad2Portable

Name: Notepad2 Portable
AppID: Notepad2Portable
Version: 4.2.25 Rev 2
Homepage: https://portableapps.com/apps/development/notepad2_portable
```

### Displays more detailed information about the app

```
>paf cat Notepad2Portable

"Name","Notepad2 Portable"
"AppID","Notepad2Portable"
"Version","4.2.25 Rev 2"
"FileName","Notepad2Portable_4.2.25_Rev_2_English.paf.exe"
"Hash","e8450aa5bee3c192c45a051a1bc62df7"
"PackageUrl1","https://download2.portableapps.com/portableapps/Notepad2Portable/Notepad2Portable_4.2.25_Rev_2_English.paf.exe"
"RefererUrl1","https://portableapps.com/downloading/?a=Notepad2Portable&s=s&p=&d=pa&n=Notepad2 Portable&f=Notepad2Portable_4.2.25_Rev_2_English.paf.exe"
"PackageUrl2","https://sourceforge.net/projects/portableapps/files/Notepad2 Portable/Notepad2Portable_4.2.25_Rev_2_English.paf.exe/download"
"Homepage","https://portableapps.com/apps/development/notepad2_portable"
```

### Open the app on the home page of PortableApps

`paf home <app>`

### Clear cache

`paf clean`

### Check the dependency of the paf

`paf checkup`

## Advanced options

The following advanced options can be set according to your actual situation.

- [_aria2c_min_split_size](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k): Default is 1MB
- [_aria2c_split](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s): Default is 10
- [_aria2c_max_connection_per_server](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-x): Default is 10
- [_aria2c_max_concurrent_downloads](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-j): Default is 50
- [_aria2c_max_tries](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-m): Default is 2
- [_aria2c_connect_timeout](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-connect-timeout): Default is 10
- _github_mirror: Default is false, If users in China are slow to access GitHub, they can set it to <https://ghproxy.com>

## Thanks

- [Scoop](https://github.com/ScoopInstaller/Scoop)
- [Homebrew](https://github.com/Homebrew/brew)
- [PortableApps.com](https://portableapps.com/apps)
