: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_tzbl_a_jyddkzhs_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_tzbl_a_jyddkzhs.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
    ,t.a_ln_auto_cm_cnt_active as a_ln_auto_cm_cnt_active
    ,t.a_ln_auto_cm_cnt_close_l24m as a_ln_auto_cm_cnt_close_l24m
    ,t.a_ln_auto_cm_cnt_nd as a_ln_auto_cm_cnt_nd
    ,t.a_ln_auto_cm_cnt_new_l24m as a_ln_auto_cm_cnt_new_l24m
    ,t.a_ln_auto_cm_cnt_new_l12m as a_ln_auto_cm_cnt_new_l12m
    ,t.a_ln_auto_cm_cnt_new_l3m as a_ln_auto_cm_cnt_new_l3m
    ,t.a_ln_auto_cm_cnt_new_l6m as a_ln_auto_cm_cnt_new_l6m
    ,t.a_ln_auto_cm_cnt_tot as a_ln_auto_cm_cnt_tot
    ,t.a_ln_cm_cnt_mana_ndf_l12_p as a_ln_cm_cnt_mana_ndf_l12_p
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_tzbl_a_jyddkzhs t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_tzbl_a_jyddkzhs.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes