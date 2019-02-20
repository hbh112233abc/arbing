@echo off

rem 设置新站点
set vhost_tpl_file=%~sdp0tmp\vhost.tpl

for /f "tokens=*" %%e in ('findstr /b /i "cmd.exe" %vhost_tpl_file%') do (
    echo %%e
)