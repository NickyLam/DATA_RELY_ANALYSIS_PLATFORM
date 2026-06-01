: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rrsp_east_zcfzmxb_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rrsp_east_zcfzmxb_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.sys_no,chr(13),''),chr(10),'') as sys_no
,replace(replace(t.sys_str,chr(13),''),chr(10),'') as sys_str
,replace(replace(t.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t.up_org_num,chr(13),''),chr(10),'') as up_org_num
,replace(replace(t.up_org_name,chr(13),''),chr(10),'') as up_org_name
,replace(replace(t.report_date,chr(13),''),chr(10),'') as report_date
,replace(replace(t.report_id,chr(13),''),chr(10),'') as report_id
,replace(replace(t.report_name,chr(13),''),chr(10),'') as report_name
,replace(replace(t.report_caliber,chr(13),''),chr(10),'') as report_caliber
,replace(replace(t.report_freq,chr(13),''),chr(10),'') as report_freq
,replace(replace(t.curr_code,chr(13),''),chr(10),'') as curr_code
,replace(replace(t.index_id,chr(13),''),chr(10),'') as index_id
,replace(replace(t.index_str,chr(13),''),chr(10),'') as index_str
,t.index_iv as index_iv
,replace(replace(t.etl_date,chr(13),''),chr(10),'') as etl_date
,replace(replace(t.area_id,chr(13),''),chr(10),'') as area_id
from iol.rrsp_east_zcfzmxb_data t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rrsp_east_zcfzmxb_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes