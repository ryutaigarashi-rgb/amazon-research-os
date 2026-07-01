@echo off
chcp 65001 > nul
echo ============================================
echo  Amazon Research OS - GitHub Pages 公開
echo ============================================
echo.

cd /d "%~dp0"

git add reports/
git commit -m "docs: update reports"
git push origin master

echo.
echo 公開完了！
echo https://yukiura-code.github.io/amazon-research-os/
echo.
pause
