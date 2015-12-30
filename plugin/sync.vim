" 绑定按键
function s:RegisterKey()
  augroup QinSync
    au BufWritePost * :call QinSync()
  augroup END
  let g:qin_sync_auto = 1
endfunction

" 配置文件名
if !exists('g:qin_sync_rc')
  let g:qin_sync_rc = './.sync'
endif

" 判断当前路径存不存在 rc 配置文件
" 若有配置，绑定按键在每次保存文件后，上传至服务器
if filereadable(g:qin_sync_rc)
  let s:hasConf = 1
  call s:RegisterKey()
else
  let s:hasConf = 0
endif

" 服务器同步需要的配置信息
let s:conf = {}

" 获取默认配置
function s:GetConf()
  if s:hasConf
    let s:conf = eval(join(readfile(g:qin_sync_rc)))
  else 
    call s:UpdateConf()
    call s:SaveConf()
    call s:RegisterKey()
  endif
  return s:conf
endfunction

" 更新配置信息
function s:UpdateConf()
  let s:conf['host'] = input('host? ')
  let s:conf['user'] = input('user? ', 'admin')
  let s:conf['pass'] = inputsecret('pass? ', '')
  let s:conf['remote'] = input('remote_path? ', '')
  let s:conf['port'] = input('port? ', '22')
endfunction

" 保存配置信息
function s:SaveConf()
  call writefile(split(string(s:conf), "\n"), g:qin_sync_rc)
endfunction

" 开启/关闭自动上传
function QinToggle()
  if g:qin_sync_auto  
    au! QinSync  
    let g:qin_sync_auto = 0
  else
    call s:RegisterKey()
  endif
endfunction

" 上传主函数
function QinSync()
  if expand('%:t') == fnamemodify(g:qin_sync_rc, ':p:t')
    return
  endif
  let l:currentPath = expand('%')
  let conf = s:GetConf()
  let conf['localpath'] = l:currentPath
  let conf['remotepath'] = conf['remote'] . conf['localpath']

  let sftpAction = printf('put %s %s', conf['localpath'], conf['remotepath'])
  let expectCmd = printf('expect -c "set timeout 5; spawn sftp -P %s %s@%s; expect \"*assword:\"; send %s\r; expect \"sftp>\"; send \" %s\r\"; expect -re \"100%\"; send \"exit\r\";" > /dev/null &', conf['port'], conf['user'], conf['host'], conf['pass'], sftpAction)
  " 执行上传命令，目前不返回状态
  silent exe '!' . expectCmd
  " 清空当前 CommandLine 信息，显示保存结果
  " 防止出现 hit-entry 提示
  if v:shell_error
    call s:logger('error, type :messages show detail')
  else
    redraw
    call s:logger('finished !')
  endif
endfunction

" 日志信息
function! s:logger(msg)
  echohl PmenuThumb 
  echom '[qin-sync] '.a:msg
  echohl None
  return 0
endfunction

