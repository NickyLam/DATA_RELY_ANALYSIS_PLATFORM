: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_a_ent_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_a_ent_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.application_num,chr(13),''),chr(10),'') as application_num
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,replace(replace(t.ent_name,chr(13),''),chr(10),'') as ent_name
    ,replace(replace(t.ent_id,chr(13),''),chr(10),'') as ent_id
    ,replace(replace(t.ent_est_date,chr(13),''),chr(10),'') as ent_est_date
    ,replace(replace(t.ent_legal_name,chr(13),''),chr(10),'') as ent_legal_name
    ,replace(replace(t.ent_tel,chr(13),''),chr(10),'') as ent_tel
    ,replace(replace(t.end_reg_ad,chr(13),''),chr(10),'') as end_reg_ad
    ,replace(replace(t.ent_office_ad,chr(13),''),chr(10),'') as ent_office_ad
    ,t.ent_reg_capital as ent_reg_capital
    ,t.ent_real_capital as ent_real_capital
    ,t.ent_emp_num as ent_emp_num
    ,replace(replace(t.ent_cus_relation,chr(13),''),chr(10),'') as ent_cus_relation
    ,replace(replace(t.ent_cus_relation_std,chr(13),''),chr(10),'') as ent_cus_relation_std
    ,t.ent_cus_share as ent_cus_share
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_a_ent_info t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_a_ent_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes