: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_rcd_ir_grade_collection_sum_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_rcd_ir_grade_collection_sum.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.key_id,chr(13),''),chr(10),'') as key_id
    ,replace(replace(t.loan_no,chr(13),''),chr(10),'') as loan_no
    ,replace(replace(t.data_dt,chr(13),''),chr(10),'') as data_dt
    ,replace(replace(t.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
    ,t.loan_total_bal as loan_total_bal
    ,replace(replace(t.rist_level,chr(13),''),chr(10),'') as rist_level
    ,t.grade as grade
    ,replace(replace(t.warning_level,chr(13),''),chr(10),'') as warning_level
    ,replace(replace(t.collection_level,chr(13),''),chr(10),'') as collection_level
    ,replace(replace(t.past_overdue,chr(13),''),chr(10),'') as past_overdue
    ,t.overdue as overdue
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.mode_type,chr(13),''),chr(10),'') as mode_type
    ,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
    ,replace(replace(t.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
    ,replace(replace(t.iden_num,chr(13),''),chr(10),'') as iden_num
    ,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_rcd_ir_grade_collection_sum t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_rcd_ir_grade_collection_sum.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes