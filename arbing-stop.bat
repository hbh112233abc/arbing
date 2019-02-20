@echo off

echo stop app
taskkill /im php-cgi-spawner.exe /f
taskkill /im php-cgi.exe /f
taskkill /im nginx.exe /f

echo goodbye ^_^
