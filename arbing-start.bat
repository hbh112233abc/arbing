@echo off

set php_path=%~sdp0php-5.6.39-nts-Win32-VC11-x86\
echo 当前php路径:%php_path%

echo start php
cd %php_path%
tasklist -v | findstr "php-cgi-spawner.exe" > nul
if not %errorlevel% == 1 (
    echo php is exists,kill php
    taskkill /im php-cgi-spawner.exe /f
    taskkill /im php-cgi.exe /f
)

set PHP_HELP_MAX_REQUESTS=100
set PHP_FCGI_MAX_REQUESTS=2000
echo %~sdp0php-cgi-spawner.exe "%php_path%php-cgi.exe -c %php_path%php.ini"
start "php-cgi-spawner" %~sdp0php-cgi-spawner.exe "%php_path%php-cgi.exe -c %php_path%php.ini" 9000 4+64

set nginx_path=%~sdp0nginx-1.15.7\
echo 当前nginx路径:%nginx_path%

echo start nginx
cd %nginx_path%
tasklist -v | findstr "nginx.exe" > nul
if %errorlevel% == 1 (
    echo start nginx
    echo %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf
    start "nginx" %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf
) else (
    echo nginx is exists,reload nginx
    echo %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf -s reload
    start "nginx" %nginx_path%nginx.exe -c %nginx_path%conf/nginx.conf -s reload
)




