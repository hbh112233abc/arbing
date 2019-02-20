@echo off
title Arbing web console

set php5_path=%~sdp0php-5.6.39-nts-Win32-VC11-x86\
set php7_path=%~sdp0php-7.3.0-nts-Win32-VC15-x86\
set php_path
echo 当前php路径:%php_path%
set nginx_path=%~sdp0nginx-1.15.7\
echo 当前nginx路径:%nginx_path%
set PHP_HELP_MAX_REQUESTS=100
set PHP_FCGI_MAX_REQUESTS=2000

:select_php
set /p php_version=请选择php版本:1=php5,2=php7:
if %php_version% == 1 (
    set php_path=%php5_path%
) else (
    if %php_version% == 2 (
        set php_path=%php7_path%
    ) else (
        goto select_php
    )
)

:begin
echo php版本:%php_path%
echo ======================================
echo [   0=启动 app   ] [   9=停止 app     ]
echo --------------------------------------
echo [   1=启动 php   ] [   4=启动 nginx   ]
echo --------------------------------------
echo [   2=停止 php   ] [   5=停止 nginx   ]
echo --------------------------------------
echo [   3=重启 php   ] [   6=重启 nginx   ]
echo ======================================

set /p var=请选择:
if %var% == 1 (
    goto start-php
)
if %var% == 2 (
    goto stop-php
)
if %var% == 3 (
    goto restart-php
)
if %var% == 4 (
    goto start-nginx
)
if %var% == 5 (
    goto stop-nginx
)
if %var% == 6 (
    goto restart-nginx
)
if %var% == 0 (
    goto start-app
)
if %var% == 9 (
    goto stop-app
)
goto begin


:start-php
echo start php
cd %php_path%
tasklist -v | findstr "php-cgi-spawner.exe" > nul
if not %errorlevel% == 1 (
    echo php is exists
) else (
    echo %~sdp0php-cgi-spawner.exe "%php_path%php-cgi.exe -c %php_path%php.ini"
    start "php-cgi-spawner" %~sdp0php-cgi-spawner.exe "%php_path%php-cgi.exe -c %php_path%php.ini" 9000 4+64
)
goto begin

:stop-php
echo stop php
taskkill /im php-cgi-spawner.exe /f
taskkill /im php-cgi.exe /f
goto begin

:restart-php
echo restart php
cd %php_path%
tasklist -v | findstr "php-cgi-spawner.exe" > nul
if not %errorlevel% == 1 (
    echo php is exists,kill php
    taskkill /im php-cgi-spawner.exe /f
    taskkill /im php-cgi.exe /f
)
echo %~sdp0php-cgi-spawner.exe "%php_path%php-cgi.exe -c %php_path%php.ini"
start "php-cgi-spawner" %~sdp0php-cgi-spawner.exe "%php_path%php-cgi.exe -c %php_path%php.ini" 9000 4+64
goto begin

:start-nginx
echo start nginx
cd %nginx_path%
tasklist -v | findstr "nginx.exe" > nul
if not %errorlevel% == 1 (
    echo %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf -s reload
    start "nginx" %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf -s reload
) else (
    echo %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf
    start "nginx" %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf
)
goto begin

:stop-nginx
echo stop nginx
taskkill /im nginx.exe /f
goto begin

:restart-nginx
echo restart nginx
cd %nginx_path%
echo %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf -s reload
start "nginx" %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf -s reload
goto begin

:start-app
echo start app
tasklist -v | findstr "php-cgi-spawner.exe" > nul
if not %errorlevel% == 1 (
    echo php is exists,kill php
    taskkill /im php-cgi-spawner.exe /f
    taskkill /im php-cgi.exe /f
)
cd %php_path%
echo %~sdp0php-cgi-spawner.exe "%php_path%php-cgi.exe -c %php_path%php.ini"
start "php-cgi-spawner" %~sdp0php-cgi-spawner.exe "%php_path%php-cgi.exe -c %php_path%php.ini" 9000 4+64

echo start nginx
cd %nginx_path%
tasklist -v | findstr "nginx.exe" > nul
if %errorlevel% == 1 (
    echo start nginx
    echo %nginx_path%nginx.exe -c %nginx_path%conf\nginx.conf
    start "nginx" %nginx_path%nginx.exe -c %nginx_path%conf\nginx.conf
) else (
    echo nginx is exists,reload nginx
    echo %nginx_path%nginx.exe -c %nginx_path%conf\nginx.conf -s reload
    start "nginx" %nginx_path%nginx.exe -c %nginx_path%conf\nginx.conf -s reload
)
goto begin

:stop-app
echo stop app
taskkill /im nginx.exe /f
taskkill /im php-cgi-spawner.exe /f
taskkill /im php-cgi.exe /f
goto begin

rem 设置新站点
set vhost_tpl_file=%~sdp0tmp\vhost.tpl

