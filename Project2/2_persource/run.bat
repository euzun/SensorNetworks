@echo off 

FOR /L %%G IN (1,1,10) DO (Call :subprogram 2_persource 2_MODEL 37 C)
GOTO :eof

:subprogram
del /f %1%3.lst
rd /s /q 225a 225b 225c 225d
taskkill /f /IM gamscmex.exe
taskkill /f /IM gmsgennx.exe
GAMS %4:\WSN\%1\%1%3.gms
type %4:\WSN\%2%3_T.txt %4:\WSN\%2%3.txt >%4:\WSN\temp.txt
type %4:\WSN\%2%3_ED_T.txt %4:\WSN\%2%3_ED.txt >%4:\WSN\temp_ED.txt
TIMEOUT 1
del /f %4:\WSN\%2%3_T.txt
del /f %4:\WSN\%2%3.txt
del /f %4:\WSN\%2%3_ED_T.txt
del /f %4:\WSN\%2%3_ED.txt
TIMEOUT 1
ren %4:\WSN\temp.txt %2%3_T.txt
ren %4:\WSN\temp_ED.txt %2%3_ED_T.txt
TIMEOUT 1
