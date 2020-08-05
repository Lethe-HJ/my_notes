# anaconda

## 配置源

`conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/`

`conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/`

`conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/`

`conda config --set show_channel_urls yes`

添加完之后：
找到 .condarc 文件，删除其中的default

- windows: `c:\Users\username\.condarc`
- linux: `~/.condarc`

conda info

conda update conda
conda update --all

## 创建虚拟环境

`conda create -n py2 python=2.7`

`conda env list`

`activate py2`

