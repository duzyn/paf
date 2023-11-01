[English](./README.md) | **简体中文**

# paf  <!-- omit from toc -->

- [特性](#特性)
- [安装](#安装)
  - [方法一：克隆本仓库（推荐）](#方法一克隆本仓库推荐)
  - [方法二：下载仓库的存档](#方法二下载仓库的存档)
  - [方法三：下载 paf.cmd](#方法三下载-pafcmd)
- [用法](#用法)
  - [查看帮助](#查看帮助)
  - [更新软件库](#更新软件库)
  - [搜索便携软件](#搜索便携软件)
  - [安装便携软件](#安装便携软件)
  - [下载便携软件](#下载便携软件)
  - [更新便携软件](#更新便携软件)
  - [卸载便携软件](#卸载便携软件)
  - [列出已安装的软件](#列出已安装的软件)
  - [列出有更新的软件](#列出有更新的软件)
  - [列出所有可安装的软件](#列出所有可安装的软件)
  - [导出已安装的软件](#导出已安装的软件)
  - [导入 CSV 文件以批量安装软件](#导入-csv-文件以批量安装软件)
  - [显示软件的信息](#显示软件的信息)
  - [显示软件更详细的信息](#显示软件更详细的信息)
  - [打开软件在 PortableApps 的主页](#打开软件在-portableapps-的主页)
  - [清除缓存](#清除缓存)
  - [检查 paf 的依赖](#检查-paf-的依赖)
- [高级选项](#高级选项)
- [致谢](#致谢)

paf 是一个用于管理 PortableApps 便携软件的命令行包管理器。

## 特性

使用 paf 只需几行命令就能装好你所需的 PortableApps 便携软件。它的主要特性有：

- 可以安装 [PortableApps.com](https://portableapps.com/apps) 上的 460 个以上的高质量便携软件
- 在 PortableApps.com 新增的便携软件，马上在 paf 就能安装或更新
- 没有图形界面，比 [PortableApps.com 平台](https://portableapps.com/platform/features) 运行更快
- 使用 Batch 脚本编写，系统兼容性好，不需要像 PowerShell 脚本放开执行权限
- 和 Scoop 基本相同的命令用法，上手很快（如果你已经熟悉 Scoop 的话）
- **在中国**下载便携软件的速度比 PortableApps.com 平台更快，使用 aria2 来加速下载

## 安装

### 方法一：克隆本仓库（推荐）

运行以下命令克隆本仓库到你的系统：

    git clone https://github.com/duzyn/paf
    cd paf

运行 `paf` 查看使用说明。这样后续 paf 有更新，可以使用 Git 更新。

### 方法二：下载仓库的存档

点击 [下载](https://github.com/duzyn/paf/archive/refs/heads/main.zip) 最新代码的存档，解压缩到一个文件夹后，进入文件夹，运行 `paf` 查看使用说明。

### 方法三：下载 paf.cmd

如果不想要使用本仓库的可执行文件，可以只下载 [paf.cmd](./paf.cmd) 文件，运行 `paf` 查看使用说明。

本应用依赖 aria2, ripgrep, sed 这三个工具，没有相应的可执行文件时，运行 `paf checkup` 可以查看帮助。在下方的网址去手动下载 aria2, ripgrep, sed，

- [aria2](https://github.com/aria2/aria2/releases)
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases)
- [sed](https://github.com/mbuilov/sed-windows/releases)

推荐下载 32 位（X86）版本的，这样在 32 位和 64 位的 Windows 上都可以运行。下载之后，将对应的可执行文件放入 bin 文件夹（sed 需要重命名），最终结果应该是这样的：

```
paf.cmd
bin\
├── aria2c.exe
├── rg.exe
└── sed.exe
```

以上就是 paf 运行所需要的所有文件了。

## 用法

### 查看帮助

运行 `paf` 或 `paf help` 查看帮助。运行 `paf help <command>` 查看命令的帮助，例如 `paf help install`

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

### 更新软件库

安装便携软件前，需要先运行 `paf update` 来更新软件库，稍等一会，等到更新结束后，就可以安装便携软件了。

```
>paf update

Updating apps cache ... Done
Updating bucket ... Done
Total: 462 apps.
```

### 搜索便携软件

可以使用 `paf search <app>` 来搜索便携软件。搜索出来的结果可以用来安装应用。

```
>paf search notepad

Search results:
* Notepad++Portable
* Notepad2-modPortable
* Notepad2Portable
Total: 3 apps.
```

### 安装便携软件

可以使用 `paf install <app>` 来安装便携软件。可以一次安装一个，例如：

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

也可以一次安装多个，例如：

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

注意：

- 因为 PortableApps 的安装包不支持命令行选项，所以安装时只能手动按向导一步步点击安装。
- paf 默认只检测同一个磁盘分区下的 PortableApps 文件夹，例如 E:\PortableApps，所以安装便携程序需要和 paf 在一个磁盘分区下

### 下载便携软件

如果你只想下载便携软件，可以使用 `paf download <app>`，支持一次下载一个或多个。

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

### 更新便携软件

可以使用 `paf upgrade <app>` 来更新便携软件，支持一次更新一个或多个。也可以输入 `paf upgrade *`，这时可以更新所有已知的便携软件。

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

### 卸载便携软件

可以使用 `paf uninstall <app>` 来卸载便携软件，支持一次卸载一个或多个。

```
>paf uninstall Notepad2Portable

Uninstalling Notepad2Portable 4.2.25 Rev 2 ...
Removing C:\PortableApps\Notepad2Portable\ ...
Notepad2Portable 4.2.25 Rev 2 was uninstalled successfully.
```

### 列出已安装的软件

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

### 列出有更新的软件

```
>paf status

Outdated apps:
* Notepad2Portable: 4.2.25 -> 4.2.25 Rev 2
Total: 1 apps.

```

### 列出所有可安装的软件

`paf known`

这个命令输出太多，就不显示例子了。可以使用 `paf known > apps.csv` 导出来查看。apps.csv 这个文件名可以按你自己的意愿修改。

### 导出已安装的软件

`paf export > paf.csv`

paf.csv 这个文件名可以按你自己的意愿修改。

### 导入 CSV 文件以批量安装软件

`paf import paf.csv`

paf.csv 这个文件应该是你的文件的实际路径。

### 显示软件的信息

```
>paf info Notepad2Portable

Name: Notepad2 Portable
AppID: Notepad2Portable
Version: 4.2.25 Rev 2
Homepage: https://portableapps.com/apps/development/notepad2_portable
```

### 显示软件更详细的信息

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

### 打开软件在 PortableApps 的主页

`paf home <app>`

### 清除缓存

`paf clean`

### 检查 paf 的依赖

`paf checkup`

## 高级选项

以下高级选项可以根据你的实际情况设置。

- [_aria2c_min_split_size](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k): 默认是 1MB
- [_aria2c_split](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s): 默认是 10
- [_aria2c_max_connection_per_server](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-x): 默认是 10
- [_aria2c_max_concurrent_downloads](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-j): 默认是 50
- [_aria2c_max_tries](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-m): 默认是 2
- [_aria2c_connect_timeout](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-connect-timeout): 默认是 10
- _github_mirror：默认是 false，中国的用户访问 GitHub 慢的话，可以设置为 <https://ghproxy.com>

## 致谢

- [Scoop](https://github.com/ScoopInstaller/Scoop)
- [Homebrew](https://github.com/Homebrew/brew)
- [PortableApps.com](https://portableapps.com/apps)
