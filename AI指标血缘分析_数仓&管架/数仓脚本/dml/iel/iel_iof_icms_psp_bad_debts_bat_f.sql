: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_psp_bad_debts_bat_f
CreateDate: 20241230
FileName:   ${iel_data_path}/icms_psp_bad_debts_bat.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.batdate,chr(13),''),chr(10),'') as batdate
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t1.exccertcodes,chr(13),''),chr(10),'') as exccertcodes
,inputdate
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid

from ${iol_schema}.icms_psp_bad_debts_bat t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_psp_bad_debts_bat.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
