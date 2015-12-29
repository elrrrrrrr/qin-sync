" 判断当前路径存不存在 rc 配置文件
" 若有配置，在每次保存文件后，上传至服务器
let s:exepath = expand('%:p:h') . '/.sync'
if filereadable(s:exepath)
  au BufWritePost * :call QinSync()
endif

" 服务器同步需要的配置信息
" 目前为默认配置
let s:conf = {}

" 获取默认配置
function GetConf()
  let s:conf['port'] = 22
  let s:conf['user'] = 'admin'
  let s:conf['pass'] = 'admin'
  let s:conf['host'] = 'host.example.com'
  let s:conf['remote'] = '/sync/path/'
  return s:conf
endfunction

" 上传主函数
function QinSync()
  let l:currentPath = expand('%')
  let conf = GetConf()
  let conf['localpath'] = l:currentPath
  let conf['remotepath'] = conf['remote'] . conf['localpath']

  let sftpAction = printf('put %s %s', conf['localpath'], conf['remotepath'])
  let expectCmd = printf('expect -c "set timeout 5; spawn sftp -P %s %s@%s; expect \"*assword:\"; send %s\r; expect \"sftp>\"; send \"%s\r\"; expect -re \"100%\"; send \"exit\r\";" > /dev/null &', conf['port'], conf['user'], conf['host'], conf['pass'], action)
  " 执行上传命令，目前不返回状态
  silent! exe expectCmd
  " 清空当前 CommandLine 信息，显示保存结果
  " 防止出现 hit-entry 提示
  redraw
  " 显示手动保存结果 
  echohl PmenuThumb | echo "upload after save success" | echohl None
endfunction
