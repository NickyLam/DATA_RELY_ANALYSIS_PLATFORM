: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_isbs_bcd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_bcd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,inr
,ownref
,nam
,relgodflg
,relgoddat
,rcvdat
,predat
,shpdat
,credat
,advdat
,clsdat
,matdat
,opndat
,doctypcod
,matperbeg
,matpercnt
,matpertyp
,ownusr
,ver
,trpdoctyp
,trpdocnum
,tradat
,tramod
,shpfro
,shpto
,chato
,othins
,stacty
,stagod
,accdat
,amenbr
,dftgarflg
,reltyp
,expdat
,rtodreflg
,mattxtflg
,focflg
,waicolcod
,wairmtcod
,oridre
,docsta
,resflg
,agtdat
,etyextkey
,proins
,branchinr
,bchkeyinr
,nraflg
,qsqdbh from idl.aml_isbs_bcd where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_bcd.f.${batch_date}.dat" \
        charset=utf8
        safe=yes