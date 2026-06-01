: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_isbs_dbk_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_dbk.f.${batch_date}.dat
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
,paytype
,txcode
,tc1amt
,txrem
,txcode2
,tc2amt
,tx2rem
,isref
,crtuser
,inptelc
,rptdate
,regno from idl.aml_isbs_dbk where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_dbk.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes