#### QIN-SYNC

> 简单的 vim sftp 上传插件, inspired by [vim-hsftp](https://github.com/hesselbom/vim-hsftp)

        ____  _  _          _______  __     ____ 
       /  _ \/ \/ \  /|    / ___\  \// \  //   _\
       | / \|| || |\ ||____|    \\  /| |\ ||  /  
       | \_\|| || | \|\____\___ |/ / | | \||  \_ 
       \____\\_/\_/  \|    \____/_/  \_/  \\____/
                                          

#### 命令介绍

`:QinSync`     上传文件至服务器
`:QinToggle`   打开/关闭自动上传开关

#### 配置介绍

`:let g:qin_sync_rc = '.sync'` 配置文件名，缺省值为 '.sync'

#### 如何使用

1. 使用 vim 打开项目后，运行 :QinSync ，根据系统提示输入配置信息
  * host     服务器域名
  * admin    登录用户名
  * pass     登录密码
  * remote   服务器部署路径

2. 保存任意文件，会根据配置自动上传至对应目录

3. 通过运行 `:QinToggle` 关闭或开启自动上传
  * 若关闭自动上传，通过 `:QinSync` 手动上传

#### 如何安装

1. 推荐使用 [vim-plug](https://github.com/junegunn/vim-plug)
  * `Plug 'elrrrrrrr/qin-sync'`

#### TODO

1. 回显上传结果
2. 全局配置文件

#### License

MIT
