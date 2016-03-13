@echo off 
cd D:\GAMS23.7

GAMS D:\WSN\ran_hcb_10.gms
del ran_hcb_10.lst
rd /s /q 225a 225b 225c 225d 225e 225f

taskkill /f /IM gamscmex.exe
taskkill /f /IM gmsgennx.exe
TIMEOUT 2

GAMS D:\WSN\ran_hcb_100.gms
del ran_hcb_100.lst
rd /s /q 225a 225b 225c 225d 225e 225f

taskkill /f /IM gamscmex.exe
taskkill /f /IM gmsgennx.exe
TIMEOUT 2

GAMS D:\WSN\inf_hcb_10.gms
del inf_hcb_10.lst
rd /s /q 225a 225b 225c 225d 225e 225f

taskkill /f /IM gamscmex.exe
taskkill /f /IM gmsgennx.exe
TIMEOUT 2

GAMS D:\WSN\inf_hcb_100.gms
del inf_hcb_100.lst
rd /s /q 225a 225b 225c 225d 225e 225f

taskkill /f /IM gamscmex.exe
taskkill /f /IM gmsgennx.exe
TIMEOUT 2