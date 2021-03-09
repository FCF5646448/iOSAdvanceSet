Git 是分布式版本控制系统。分布式版本控制系统没有“中央服务器”，每个人电脑上都是一个完整的版本库。

* 安装
  命令行里输入$  git 就可以知道当前电脑是否安装git
  如果是Mac，可以通过homebrew安装git，也可以使用Xcode集成Git。不过Xcode默认没有安装，需要进入到Preferences，找到Downloads，选择“CommandLine Tools”,点击“Install”就可以了。

* 创建
  ```
  $ git init
  ```
  git init命令把目录变成可以使用git进行管理的仓库。这个目录可以是空目录，也可以是已经存在的目录。执行完成这个命令之后，会出现一个.git的隐藏目录。

* 添加

  ```
  $ git add readme.txt
  ```
  git add 将目录里添加或修改了的文件添加到仓库里。git add 可以添加多个，也可以连续添加，还可以一次性全部添加。比如：
  ```
  $ git add file1.txt
  $ git add file2.txt file3.txt
  $ git add .
  ```

* 提交

  ```
  $ git commit -m "wrote a readme file"
  ```

  git commit 把文件提交到仓库。-m 是本次提交的说明。

* 查看状态与修改

  ```
  $ git status
  ```

  git status 查看仓库当前状态，但是只能查看修改过的文件

  ```
  $ git diff
  ```

  git diff 可以查看具体的修改细节。之后则可以使用add和commit添加提交修改到仓库。

* 版本查看

  我们每次提交一个commit都相当于保存一个快照，所以一旦你把文件改错了，你可以从最近的一个commit里恢复。

  ```
  $ git log
  ```

  git log 查看所有提交的历史版本（注意这个版本指的是一次commit）。得到的结果中commit后续跟着的一大串字符就是commit id(版本号)，它是由SHA1计算出来的一个非常大的数字，避免冲突。

  

  







