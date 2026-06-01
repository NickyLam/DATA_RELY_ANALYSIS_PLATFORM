: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_isbs_bod_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_bod.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,inr
,ownref
,nam
,agtref
,agtact
,agtcom
,shpdat
,predat
,rcvdat
,opndat
,advdat
,matdat
,clsdat
,doctypcod
,matperbeg
,matpercnt
,matpertyp
,trpdoctyp
,trpdocnum
,tradat
,tramod
,shpfro
,shpto
,waicolcod
,wairmtcod
,chato
,stacty
,stagod
,credat
,ownusr
,ver
,focflg
,dircolflg
,ccdpurflg
,ccdndrflg
,issdat
,paydocnum
,paydoctyp
,mattxtflg
,othins
,docsta
,resflg
,amenbr
,msgrol
,etyextkey
,lescom
,branchinr
,bchkeyinr
,nraflg from idl.aml_isbs_bod where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_bod.f.${batch_date}.dat" \
        charset=utf8
        safe=yes