: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_rcd_ir_points_pool_result_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_rcd_ir_points_pool_result.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.key_id,chr(13),''),chr(10),'') as key_id
    ,replace(replace(t.loan_no,chr(13),''),chr(10),'') as loan_no
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.data_dt,chr(13),''),chr(10),'') as data_dt
    ,replace(replace(t.pd,chr(13),''),chr(10),'') as pd
    ,replace(replace(t.pd_ci_1,chr(13),''),chr(10),'') as pd_ci_1
    ,replace(replace(t.pd_ci_2,chr(13),''),chr(10),'') as pd_ci_2
    ,replace(replace(t.lgd,chr(13),''),chr(10),'') as lgd
    ,replace(replace(t.lgd_ci_1,chr(13),''),chr(10),'') as lgd_ci_1
    ,replace(replace(t.lgd_ci_2,chr(13),''),chr(10),'') as lgd_ci_2
    ,replace(replace(t.pool_type,chr(13),''),chr(10),'') as pool_type
    ,replace(replace(t.mode_type,chr(13),''),chr(10),'') as mode_type
    ,replace(replace(t.pd_logical_deteil,chr(13),''),chr(10),'') as pd_logical_deteil
    ,replace(replace(t.lgd_logical_deteil,chr(13),''),chr(10),'') as lgd_logical_deteil
    ,replace(replace(t.pd_average,chr(13),''),chr(10),'') as pd_average
    ,replace(replace(t.lgd_average,chr(13),''),chr(10),'') as lgd_average
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_rcd_ir_points_pool_result t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_rcd_ir_points_pool_result.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes