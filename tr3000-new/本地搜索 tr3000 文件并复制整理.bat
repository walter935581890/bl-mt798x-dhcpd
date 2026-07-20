@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
color 0A
title 搜索并复制 tr3000 文件

:: 定义目标文件夹
set "TARGET_FOLDER=tr3000-new"

echo ==================================================
echo          本地搜索 tr3000 文件并复制整理
echo ==================================================
echo.
echo 搜索范围：当前目录所有文件（排除 !TARGET_FOLDER! 文件夹）
echo 目标目录：!TARGET_FOLDER!
echo.

:: 创建目标文件夹（不存在则创建）
if not exist "!TARGET_FOLDER!" (
    mkdir "!TARGET_FOLDER!"
    echo 已创建目标文件夹：!TARGET_FOLDER!
    echo.
)

:: 开始递归搜索 文件名包含 tr3000 的文件
echo 正在搜索文件，请稍候...
echo.

:: 搜索逻辑：递归查找文件，排除目标文件夹，包含 tr3000
for /f "delims=" %%f in ('dir /b /s /a-d ^| findstr /i /v "\\%TARGET_FOLDER%\\" ^| findstr /i "tr3000"') do (
    :: 获取文件完整路径
    set "FILE_PATH=%%f"
    :: 获取文件相对路径
    set "REL_PATH=!FILE_PATH:%cd%\=!"
    :: 目标保存路径
    set "DEST_PATH=!TARGET_FOLDER!\!REL_PATH!"
    
    :: 自动创建文件所在的目录结构（核心修复）
    for %%d in ("!DEST_PATH!") do (
        if not exist "%%~dpd" mkdir "%%~dpd"
    )
    
    :: 复制文件
    echo 复制：!REL_PATH!
    copy "%%f" "!DEST_PATH!" >nul 2>&1
)

echo.
echo ==================================================
echo               操作完成！
echo 所有包含 tr3000 的文件已按原路径保存到：
echo  !cd!\!TARGET_FOLDER!
echo ==================================================
echo.
pause