: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_points_pool_result_i
CreateDate: 20240717
FileName:   ${iel_data_path}/rsts_rcd_ir_points_pool_result.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.pd,chr(13),''),chr(10),'') as pd
,replace(replace(t1.pd_ci_1,chr(13),''),chr(10),'') as pd_ci_1
,replace(replace(t1.pd_ci_2,chr(13),''),chr(10),'') as pd_ci_2
,replace(replace(t1.lgd,chr(13),''),chr(10),'') as lgd
,replace(replace(t1.lgd_ci_1,chr(13),''),chr(10),'') as lgd_ci_1
,replace(replace(t1.lgd_ci_2,chr(13),''),chr(10),'') as lgd_ci_2
,replace(replace(t1.pool_type,chr(13),''),chr(10),'') as pool_type
,replace(replace(t1.mode_type,chr(13),''),chr(10),'') as mode_type
,replace(replace(t1.pd_logical_deteil,chr(13),''),chr(10),'') as pd_logical_deteil
,replace(replace(t1.lgd_logical_deteil,chr(13),''),chr(10),'') as lgd_logical_deteil
,replace(replace(t1.pd_average,chr(13),''),chr(10),'') as pd_average
,replace(replace(t1.lgd_average,chr(13),''),chr(10),'') as lgd_average
,replace(replace(t1.serial_no,chr(13),''),chr(10),'') as serial_no

from ${iol_schema}.rsts_rcd_ir_points_pool_result t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_points_pool_result.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
