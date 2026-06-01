: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_isbs_brd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_brd.f.${batch_date}.dat
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
,pnttyp
,pntinr
,predat
,shpdat
,spddat
,totdat
,advdat
,matdat
,rcvdat
,disdat
,docflg
,rejflg
,approvcod
,relgodflg
,relgoddat
,trpdocnum
,frepayflg
,ver
,advtyp
,reltyp
,expdat
,rtoaplflg
,trpdoctyp
,tradat
,tramod
,mattxtflg
,dscinsflg
,docprbrol
,docsta
,igndisflg
,totcur
,totamt
,payrol
,acpnowflg
,orddat
,advdocflg
,etyextkey
,bchkeyinr
,branchinr
,ngrcod
,sgdinr
,blnum
,shgref
,fincod
,fintyp
,nraflg
,qsqdbh
,invnum from idl.aml_isbs_brd where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_brd.f.${batch_date}.dat" \
        charset=utf8
        safe=yes