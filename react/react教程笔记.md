## React的介绍：


		React来自于Facebook公司的开源项目



		React 可以开发单页面应用       spa（单页面应用）
		

		react 组件化模块化  开发模式
	

		React通过对DOM的模拟(虚拟dom)，最大限度地减少与DOM的交互  （数据绑定）
		

		react灵活  React可以与已知的库或框架很好地配合。
	

		react 基于jsx的语法，JSX是React的核心组成部分，它使用XML标记的方式去直接声明界面，  html  js混写模式



	
搭建React开发环境之前的准备工作。

	
	1、必须安装nodejs      注意：安装nodejs稳定版本


	2、安装cnpm用cnpm替代npm

		地址：http://npm.taobao.org/
	
		安装cnpm:

			npm install -g cnpm --registry=https://registry.npm.taobao.org

	3、用yarn替代npm

		

		yarn的安装：

			第一种方法：参考官方文档https://yarn.bootcss.com/


			第二种方法：cnpm install -g yarn  或者 npm install -g yarn


		





搭建React开发环境的第一种方法（老-现在推荐）：



	https://reactjs.org/docs/create-a-new-react-app.html



	1、必须要安装nodejs     注意：安装nodejs稳定版本      教程中的nodejs版本:v8.11.2            教程中的npm版本:v5.6.0


	

	2.安装脚手架工具   （单文件组件项目生成工具）   只需要安装一次
		

		npm install -g create-react-app   /  cnpm install -g create-react-app

		
	
	3.创建项目   （可能创建多次）
	

		找到项目要创建的目录：

		create-react-app reactdemo



	4.cd  到项目里面	
	
		cd  reactdemo


		npm start             yarn start运行项目


		npm run build         yarn build 生成项目




搭建React的开发环境的第二种方法（新-未来推荐）：



	https://reactjs.org/docs/create-a-new-react-app.html



	1、必须要安装nodejs     注意：安装nodejs稳定版本      教程中的nodejs版本:v8.11.2            教程中的npm版本:v5.6.0


	

	2.安装脚手架工具并创建项目


		找到项目要创建的目录执行：
		

		npx create-react-app reactdemo
		
		
		
		



	4.cd  到项目里面	
	
		cd  reactdemo


		npm start  运行项目（调试）


		npm run build 生成项目（发布）





npx介绍：
	

	npm v5.2.0引入的一条命令（npx），引入这个命令的目的是为了提升开发者使用包内提供的命令行工具的体验。



详情：
	http://www.phonegap100.com/thread-4910-1-1.html



	npx create-react-app reactdemo这条命令会临时安装 create-react-app 包，命令完成后create-react-app 会删掉，不会出现在 global 中。下次再执行，还是会重新临时安装。
	npx 会帮你执行依赖包里的二进制文件。



	再比如 npx http-server 可以一句话帮你开启一个静态服务器