: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_isbs_led_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_led.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,inr
,ownref
,nam
,ownusr
,credat
,opndat
,clsdat
,cnfdat
,advdat
,issnam
,issref
,amedat
,amenbr
,avbby
,avbwth
,bennam
,benref
,chato
,cnfflg
,cnfdet
,cnfsta
,expdat
,expplc
,lcrtyp
,nomspc
,nomtop
,nomton
,preadvdt
,shpdat
,shpfro
,shppar
,shpto
,shptrs
,stacty
,stagod
,utlnbr
,ver
,aplbnkdirsnd
,tenmaxday
,cnfsnd
,revflg
,revnbr
,revtimes
,revdat
,revcum
,revtyp
,cnfins
,redclsflg
,advnbr
,resflg
,inctrf
,apprul
,apprultxt
,pordis
,porloa
,nonban
,etyextkey
,partcon
,collflg
,teskeyunc
,dbtflg
,branchinr
,bchkeyinr
,rskrat
,dflg
,tratyp
,negflg
,shppars18
,prepers18
,prepertxts18
,shptrss18
,spcbenflg
,spcrcbflg from idl.aml_isbs_led where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_led.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes