: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_grade_consumer_loan_i
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_grade_consumer_loan.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.var_name,chr(13),''),chr(10),'') as var_name
,replace(replace(t1.var_desc,chr(13),''),chr(10),'') as var_desc
,replace(replace(t1.var_value,chr(13),''),chr(10),'') as var_value
,grade
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.mode_type,chr(13),''),chr(10),'') as mode_type
,replace(replace(t1.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.iden_num,chr(13),''),chr(10),'') as iden_num
,replace(replace(t1.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t1.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,replace(replace(t1.exc_id,chr(13),''),chr(10),'') as exc_id

from ${iol_schema}.rsts_rcd_ir_grade_consumer_loan t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_grade_consumer_loan.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
