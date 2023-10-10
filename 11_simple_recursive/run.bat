gams exec_core.gms
gams exec_core.gms --sw_osubval=1 --scn=TRAN --sw_osub_rawval=1 --sw_osub_rateval=0
gams exec_core.gms --sw_osubval=1 --swwasteval=1 --scn=WASTE --sw_osub_rawval=1 --sw_osub_rateval=0
gams exec_core.gms --sw_osubval=1 --swjpowval=1 --scn=JPOW --sw_osub_rawval=1 --sw_osub_rateval=0

gdxmerge recursive_*.gdx
