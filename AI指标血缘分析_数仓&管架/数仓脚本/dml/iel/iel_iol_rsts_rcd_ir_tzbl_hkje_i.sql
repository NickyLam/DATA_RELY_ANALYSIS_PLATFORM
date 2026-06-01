: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_tzbl_hkje_i
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_tzbl_hkje.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,var0201
,var0202
,var0203
,var0204
,var0205
,var0206
,var0207
,var0208
,var0209
,var0210
,var0211
,var0212
,var0213
,var0214
,var0215
,var0216
,var0217
,var0218
,var0219
,replace(replace(t1.exc_id,chr(13),''),chr(10),'') as exc_id
,generated_time
,replace(replace(t1.partition_month,chr(13),''),chr(10),'') as partition_month
,replace(replace(t1.repay_mode,chr(13),''),chr(10),'') as repay_mode

from ${iol_schema}.rsts_rcd_ir_tzbl_hkje t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_tzbl_hkje.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
