我们现在假设要做一个电子书，共两章，第一章为两节。第二章无节。

需要使用的工具包括：

    gitbook
    gitbook-pdf
    calibre-ebook 

gitbook需要node，需要你首先安装它。

具体做法如下：

## 安装gitbook套件
执行:

        npm install gitbook-cli -g 
        npm install gitbook-pdf -g
         
### 安装calibre

安装calibre需要下载安装包，然后完成惯常的App安装过程即可：

    下载地址：http://calibre-ebook.com/download

安装完毕后，需要使用命令，手工链接ebook-convert到/usr/local/bin内：

    ln -s /Applications/calibre.app/Contents/MacOS/ebook-convert /usr/local/bin

### 初始化

    mkdir gitbook
    cd gitbook
    gitbook init
    
可看到两个文件被创建

    $ ls
    README.md	SUMMARY.md

###电子书编辑开始

文件SUMMARY.md就是目录，可以使用类似MD的URL格式来制作目录

    $cat SUMMARY.md
    * [Chapter1](chapter1/README.md)
      * [Section1.1](chapter1/section1.1.md)
      * [Section1.2](chapter1/section1.2.md)
    * [Chapter2](chapter2/README.md)
    
随即补足文件：

    $mkdir chapter1 chapter2
    $touch chapter1/README.md chapter1/section1.1.md chapter1/section1.2.md chapter2/README.md
    $cat  chapter1/README.md chapter1/section1.1.md chapter1/section1.2.md chapter2/README.md
    
输出：
        # 第1章
        这里是第1章的内容
        ## 第1节
        这里是第1节的内容
        ## 第2节
        这里是第2节的内容
        # 第2章
        这里是第2章的内容
        
### 生成PDF

    gitbook pdf .
    open book.pdf

大功告成。


