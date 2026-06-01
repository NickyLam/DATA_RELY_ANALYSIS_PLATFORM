: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbhisfeyehz_f
CreateDate: 20251229
FileName:   ${iel_data_path}/ifms_tbhisfeyehz.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,sum_date
,replace(replace(t1.sum_flag,chr(13),''),chr(10),'') as sum_flag
,replace(replace(t1.internal_branch,chr(13),''),chr(10),'') as internal_branch
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.ta_code,chr(13),''),chr(10),'') as ta_code
,tot_vol
,long_frozen_vol
,nav
,client_num
,replace(replace(t1.prd_type,chr(13),''),chr(10),'') as prd_type

from ${iol_schema}.ifms_tbhisfeyehz t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbhisfeyehz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
