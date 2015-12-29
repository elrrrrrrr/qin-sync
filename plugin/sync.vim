" 绑定按键
function RegisterKey()
  au BufWritePost * :call QinSync()
endfunction

" 配置文件名
if !exists('g:qin_sync_rc')
  let g:qin_sync_rc = './.sync'
endif

" 判断当前路径存不存在 rc 配置文件
" 若有配置，绑定按键在每次保存文件后，上传至服务器
if filereadable(g:qin_sync_rc)
  let s:hasConf = 1
  call RegisterKey()
else
  let s:hasConf = 0
endif

" 服务器同步需要的配置信息
let s:conf = {}

" 获取默认配置
function GetConf()
  if s:hasConf
    let s:conf = eval(join(readfile(g:qin_sync_rc)))
  else 
    call UpdateConf()
    call SaveConf()
  endif
  return s:conf
endfunction


" 更新配置信息
function UpdateConf()
  let s:conf['host'] = input('host? ')
  let s:conf['user'] = input('user? ', 'admin')
  let s:conf['pass'] = inputsecret('pass? ', '')
  let s:conf['remote'] = input('remote_path? ', '')
endfunction

" 保存配置信息
function SaveConf()
  call writefile(split(string(s:conf), "\n"), g:qin_sync_rc)
endfunction

" 上传主函数
function QinSync()
  let l:currentPath = expand('%')
  let conf = GetConf()
  let conf['localpath'] = l:currentPath
  let conf['remotepath'] = conf['remote'] . conf['localpath']
  echo conf

  let sftpAction = printf('put %s %s', conf['localpath'], conf['remotepath'])
  let expectCmd = printf('expect -c "set timeout 5; spawn sftp -P %s %s@%s; expect \"*assword:\"; send %s\r; expect \"sftp>\"; send \"%s\r\"; expect -re \"100%\"; send \"exit\r\";" > /dev/null &', conf['port'], conf['user'], conf['host'], conf['pass'], sftpAction)
  " 执行上传命令，目前不返回状态
  silent! exe expectCmd
  " 清空当前 CommandLine 信息，显示保存结果
  " 防止出现 hit-entry 提示
  redraw
  " 显示手动保存结果 
  call s:logger('finished !')
endfunction

" 日志信息
function! s:logger(msg)
  echohl PmenuThumb 
  echom '[qin-sync] '.a:msg
  echohl None
  return 0
endfunction
