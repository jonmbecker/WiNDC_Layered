gams exec_core.gms
gams exec_core.gms --sw_osubval=1 --scn=TRAN
gams exec_core.gms --sw_osubval=1 --swwasteval=1 --scn=WASTE
gams exec_core.gms --sw_osubval=1 --swjpowval=1 --scn=JPOW

gdxmerge recursive_*.gdx
