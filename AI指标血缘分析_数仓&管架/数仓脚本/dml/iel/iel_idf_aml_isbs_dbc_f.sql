: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_isbs_dbc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_dbc.f.${batch_date}.dat
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
,custype
,idcode
,custcod
,custnm
,oppuser
,txccy
,txamt
,exrate
,lcyamt
,lcyacc
,fcyamt
,fcyacc
,othamt
,othacc
,methods
,buscode
,actuccy
,actuamt
,outchargeccy
,outchargeamt
,lcbgno
,issdate
,tenor from idl.aml_isbs_dbc where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_dbc.f.${batch_date}.dat" \
        charset=utf8
        safe=yes