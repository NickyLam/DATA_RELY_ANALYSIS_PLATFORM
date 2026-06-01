: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_psp_rwo_relative_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_psp_rwo_relative.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.operateid,chr(13),''),chr(10),'') as operateid
,replace(replace(t1.warningsignalno,chr(13),''),chr(10),'') as warningsignalno
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,updatedate
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag

from ${iol_schema}.icms_psp_rwo_relative t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_psp_rwo_relative.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
