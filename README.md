# develop-set

- vimrcを共通管理してます。
- 以下のように使います。

```
$ git clone git@github.com:mtb-beta/develop-set.git
$ ln -s develop-set/src/vim/.vimrc ~/.vimrc
```

# vim-plug

- vim-plugをプラグイン管理に使っているので以下を実行します。macやlinuxの場合

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

- 以下を実行してプラグインをインストールします

```
:PlugInstall
```

# Python-Language-Server

- いい感じにpython-language-serverをインストールします

```
pip install python-language-server
```
