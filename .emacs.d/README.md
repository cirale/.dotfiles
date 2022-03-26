# WSL-emacs 環境構築
基本はここを参考に
* [WSL で emacs を使うための設定 - NTEmacs @ ウィキ - アットウィキ](https://www49.atwiki.jp/ntemacs/pages/69.html)

## 基本

1. とりあえずアップデート

    ```
    $ sudo apt update
    $ sudo apt upgrade
    ```

2. locale変更と日本語マニュアルインストールとタイムゾーン変更(WLinuxなら不要)

    ```
    $ sudo apt install language-pack-ja language-pack-gnome-ja
    $ sudo update-locale LANG=ja_JP.UTF-8
    $ sudo apt install manpages-ja manpages-ja-dev
    $ sudo dpkg-reconfigure tzdata
    ```

3. emacsインストール

    ```
    $ sudo apt install emacs25 emacs25-el
    ```

4. [vcxsrv](https://sourceforge.net/projects/vcxsrv/)か[X410](https://www.microsoft.com/ja-jp/p/x410/9nlp712zmn9q)をインストール
   * WLinuxの場合初回起動より先にやるのがよさげ

5. ~/.bashrcに追記

    ```bash
    umask 022
    if [ "$INSIDE_EMACS" ]; then
        TERM=eterm-color
    fi

    export DISPLAY=localhost:0.0
    alias ls="ls --color=auto"
    ```

6. フォント共有設定(WLinuxなら不要？)

    ```
    $ sudo ln -s /mnt/c/Windows/Fonts /usr/share/fonts/windows
    $ sudo fc-cache -fv
    ```

## 日本語入力関連
1. [mozc_emacs_helper](https://github.com/smzht/mozc_emacs_helper)をダウンロードして適当な場所に保存（以下ではC:\Users\cirale\wsl\に保存した前提）

2. mozc_emacs_helper.sh を以下の内容で作成し、実行権を付加(chmod +x)した後、コマンドパスが通ったディレクトリ(/usr/local/bin や ~/bin 等)に格納

    ```bash
    #!/bin/sh

    cd /mnt/c/Users/cirale/wsl/
    ./mozc_emacs_helper.exe "$@"
    ```

## emacsセットアップ
初回起動時以下を実行
* Jediサーバインストール(要:virtualenv,flake8)
    ```
    M-x jedi:install-server RET
    ```
* ironyサーバインストール(要:cmake,clang,llvm,libclang-dev)
    ```
    M-x irony-install-server RET
    ```
## その他ソフトウェアセットアップ
### Dockerインストール
Windows 10 October 2018 Update以降Dockerのインストールが楽になりました
1. 管理者権限で以下のコマンドを実行
   ```
   $ sudo apt install -y zfsutils-linux  cgroup-bin cgroup-lite cgroup-tools cgroupfs-mount libcgroup1
   $ sudo apt install -y docker.io
   $ sudo cgroupfs-mount
   $ sudo usermod -aG docker $USER
   ```
2. 以降，Windows再起動のたびに`sudo service docker start`を管理者権限で実行
   * `cgroupfs-mout`もいるかも
