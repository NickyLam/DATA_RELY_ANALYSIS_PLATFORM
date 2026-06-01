: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_isbs_dbs_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_dbs.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,inr
,tmpref
,ownextkey
,ver
,actiontype
,actiondesc
,rptno
,country
,isref
,paytype
,payattr
,txcode
,tc1amt
,txcode2
,tc2amt
,impdate
,contrno
,invoino
,billno
,contamt
,regno
,crtuser
,inptelc
,rptdate from idl.aml_isbs_dbs where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_dbs.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes