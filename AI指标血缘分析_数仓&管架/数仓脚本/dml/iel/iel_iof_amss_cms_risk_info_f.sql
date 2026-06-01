: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_amss_cms_risk_info_f
CreateDate: 20260316
FileName:   ${iel_data_path}/amss_cms_risk_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,risk_id
,risk_pro
,risk_type
,risk_status
,risk_result
,replace(replace(t1.risk_info,chr(13),''),chr(10),'') as risk_info
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,create_user
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,create_time
,update_time
,fld_n1
,fld_n2
,replace(replace(t1.fld_s1,chr(13),''),chr(10),'') as fld_s1
,replace(replace(t1.fld_s2,chr(13),''),chr(10),'') as fld_s2
,replace(replace(t1.thi_risk_status,chr(13),''),chr(10),'') as thi_risk_status
,risk_level
,replace(replace(t1.channel_id,chr(13),''),chr(10),'') as channel_id

from ${iol_schema}.amss_cms_risk_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_cms_risk_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
