xelatex generic-color
bibtex generic-color
xelatex generic-color
xelatex generic-color
::======================================
:: 清除文件以及清除更多文件
::======================================
:clean
echo 删除编译临时文件
del /f /q /s *.log *.glo *.ilg *.lof *.ind *.out *.thm *.toc *.lot *.loe *.out.bak *.blg *.synctex.gz *.aux *.bbl *.xdv
del /f /q *.idx
del /f /s *.dvi *.ps
goto end

::======================================
:: 结束符，无任何具体意义
::======================================
:end