下面是在所有 Linux 发行版中安装 Visual Studio Code 的几个简单步骤。
1. 下载 Visual Studio Code 软件包

`sudo mkdir /tmp/vscode; cd /tmp/vscode/`
`sudo wget https://az764295.vo.msecnd.net/public/0.3.0/VSCode-linux-x64.zip`
     

2. 提取软件包

`sudo unzip /tmp/vscode/VSCode-linux-x64.zip -d /opt/`

3. 运行 Visual Studio Code

展开软件包之后，我们可以直接运行一个名为 Code 的文件启动 Visual Studio Code。
`sudo chmod +x /opt/VSCode-linux-x64/code`
`sudo /opt/VSCode-linux-x64/code`

如果我们想通过终端在任何地方启动 Code，我们就需要创建 /opt/vscode/Code 的一个链接 /usr/local/bin/code。

`sudo ln -s /opt/VSCode-linux-x64/Code /usr/local/bin/code`

现在，我们就可以在终端中运行以下命令启动 Visual Studio Code 了。

`sudo code .`

4. 创建桌面启动

下一步，成功展开 Visual Studio Code 软件包之后，我们打算创建桌面启动程序，使得根据不同桌面环境能够从启动器、菜单、桌面启动它。首先我们要复制一个图标文件到 /usr/share/icons/ 目录。

`sudo cp /opt/VSCode-linux-x64/resources/app/resources/linux/code.png /usr/share/icons/`

然后，我们创建一个桌面启动程序，文件扩展名为 .desktop。这里我们使用喜欢的文本编辑器在 /tmp/VSCODE/ 目录中创建名为 visualstudiocode.desktop 的文件。

`sudo vi /tmp/vscode/visualstudiocode.desktop`

然后，粘贴下面的行到那个文件中。
```text
    [Desktop Entry]
    Name=Visual Studio Code
    Comment=Multi-platform code editor for Linux
    Exec=/opt/VSCode-linux-x64/code
    Icon=/usr/share/icons/code.png
    Type=Application
    StartupNotify=true
    Categories=TextEditor;Development;Utility;
    MimeType=text/plain;
```


创建完桌面文件之后，我们会复制这个桌面文件到 /usr/share/applications/ 目录，这样启动器和菜单中就可以单击启动 Visual Studio Code 了。

`cp /tmp/vscode/visualstudiocode.desktop /usr/share/applications/`

完成之后，我们可以在启动器或者菜单中启动它。
