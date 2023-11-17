# paf  <!-- omit from toc -->

[English](./README.md) | **简体中文**

- [特性](#特性)
- [安装](#安装)
  - [方法一：克隆本仓库（推荐）](#方法一克隆本仓库推荐)
  - [方法二：下载仓库的存档](#方法二下载仓库的存档)
- [用法](#用法)
- [高级选项](#高级选项)
- [致谢](#致谢)

paf 是一个用于管理 PortableApps 便携软件的命令行包管理器。

## 特性

使用 paf 只需几行命令就能装好你所需的 PortableApps 便携软件。它的主要特性有：

- 可以安装 [PortableApps.com](https://portableapps.com/apps) 上的 490 个以上的高质量便携软件
- 在 PortableApps.com 新增的便携软件，马上在 paf 就能安装或更新
- 没有图形界面，比 [PortableApps.com 平台](https://portableapps.com/platform/features) 运行更快
- 使用 Batch 脚本编写，系统兼容性好，不需要像 PowerShell 脚本放开执行权限
- 和 Scoop 基本相同的命令用法，上手很快（如果你已经熟悉 Scoop 的话）
- **在中国**下载便携软件的速度比 PortableApps.com 平台更快，使用 aria2 来加速下载

## 安装

### 方法一：克隆本仓库（推荐）

运行以下命令克隆本仓库到你的系统：

    git clone https://github.com/duzyn/paf
    // or git clone https://mirror.ghproxy.com/github.com/duzyn/paf
    // or git clone https://gh-proxy.com/github.com/duzyn/paf
    cd paf

运行 `paf` 查看使用说明。这样后续 paf 有更新，可以使用 Git 更新。

### 方法二：下载仓库的存档

点击 [下载](https://github.com/duzyn/paf/archive/refs/heads/main.zip) 或 [从镜像一下载](https://mirror.ghproxy.com/github.com/duzyn/paf/archive/refs/heads/main.zip) 或 [从镜像二下载](https://gh-proxy.com/github.com/duzyn/paf/archive/refs/heads/main.zip) 最新代码的存档，解压缩到一个文件夹后，进入文件夹，运行 `paf` 查看使用说明。


## 用法

```
C:\paf-cli>paf
paf 1.0
一个用于管理 PortableApps 便携软件的命令行包管理器。
项目主页： https://github.com/duzyn/paf

用法：
    paf 命令 [参数]

参数
    AppID
        AppID 在 PortableApps.com 格式有定义，参见：
        https://portableapps.com/development/portableapps.com_format#appinfo
    *
        当更新应用时，* 表示全部。

命令：
    cat
        显示应用的元数据。
            paf cat FirefoxPortable
    checkup
        检测依赖工具。
            paf checkup
    clean
        清理下载的缓存。
            paf clean
    download
        下载应用到 downloads 文件夹并校验哈希值。
            paf download FirefoxPortable
            paf download FirefoxPortable GoogleChromePortable
    export
        将已安装的应用导出，显示为 CSV 格式。
            paf export
    help
        显示此帮助。
            paf
            paf help
            paf --help
            paf -h
    home
        打开应用的主页。
            paf home FirefoxPortable
    import
        从一个文本文件导入应用。
            paf import apps.csv
    info
        显示一个应用的信息。
            paf info FirefoxPortable
    install
        安装应用。
            paf install FirefoxPortable
            paf install FirefoxPortable GoogleChromePortable
    known
        列出所有已知的应用。
            paf known
    list
        列出已安装的应用。
            paf list
    search
        搜索应用。
            paf search firefox
    status
        显示状态，检查应用的新版本。
            paf status
    uninstall
        卸载应用。
            paf uninstall FirefoxPortable
            paf uninstall FirefoxPortable GoogleChromePortable
    update
        更新缓存。
            paf update
    upgrade
        更新应用。
            paf upgrade FirefoxPortable
            paf upgrade FirefoxPortable GoogleChromePortable
            paf upgrade *
```

## 高级选项

以下高级选项可以根据你的实际情况设置。

- [aria2-min-split-size](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k): 默认是 1MB
- [aria2-split](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s): 默认是 10
- [aria2-max-connection-per-server](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-x): 默认是 10
- [aria2-max-concurrent-downloads](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-j): 默认是 50
- [aria2-max-tries](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-m): 默认是 2
- [aria2-connect-timeout](https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-connect-timeout): 默认是 10
- github-mirror：默认是 false，中国的用户访问 GitHub 慢的话，可以设置为 <https://gh-proxy.com/github.com> 或 <https://mirror.ghproxy.com/github.com>

## 致谢

- [Scoop](https://github.com/ScoopInstaller/Scoop)
- [Homebrew](https://github.com/Homebrew/brew)
- [PortableApps.com](https://portableapps.com/apps)
