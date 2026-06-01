: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_did_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_did_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select inr
,ownref
,nam
,ownusr
,credat
,opndat
,clsdat
,advnam
,advref
,amedat
,amenbr
,aplnam
,aplref
,avbby
,avbwth
,bennam
,benref
,chato
,cnfdet
,expdat
,expplc
,lcrtyp
,nomspc
,nomtop
,nomton
,preadvdt
,rmbact
,rmbcha
,rmbflg
,shpdat
,shpfro
,porloa
,pordis
,shppar
,shpto
,shptrs
,stacty
,stagod
,utlnbr
,advnbr
,redclsflg
,ver
,lcityp
,b2binr
,b2bref
,revnbr
,revtimes
,revflg
,revawapl
,revdat
,revcum
,revtyp
,initpty
,resflg
,apprul
,apprulrmb
,apprultxt
,autdat
,etyextkey
,tenmaxday
,branchinr
,bchkeyinr
,decflg
,cshpct
,isstyp
,fincod
,fintyp
,relcshpct
,jjh
,guaflg
,tratyp
,opnamo
,ameflg
,cretyp
,tadtyp
,shpins
,sermod
,serfro
,comflg
,insdat
,contractno
,negflg from ${idl_schema}.odss_did where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_did_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes