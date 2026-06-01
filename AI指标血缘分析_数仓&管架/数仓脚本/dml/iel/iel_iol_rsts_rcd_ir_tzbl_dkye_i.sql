: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_tzbl_dkye_i
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_tzbl_dkye.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,var0101
,var0102
,var0103
,var0104
,replace(replace(t1.exc_id,chr(13),''),chr(10),'') as exc_id
,generated_time
,replace(replace(t1.partition_month,chr(13),''),chr(10),'') as partition_month

from ${iol_schema}.rsts_rcd_ir_tzbl_dkye t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_tzbl_dkye.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
