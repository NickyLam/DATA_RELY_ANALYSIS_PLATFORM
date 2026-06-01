: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_tzbl_yqqs_a
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_tzbl_yqqs.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,var0401
,var0402
,var0403
,var0404
,var0405
,var0406
,var0407
,var0408
,var0409
,var0410
,var0411
,var0412
,var0413
,var0414
,var0415
,var0416
,var0417
,var0418
,var0419
,var0420
,var0421
,var0422
,var0423
,var0424
,var0425
,var0426
,var0427
,var0428
,var0429
,var0430
,var0431
,var0432
,var0433
,var0434
,var0435
,var0436
,var0437
,replace(replace(t1.exc_id,chr(13),''),chr(10),'') as exc_id
,generated_time
,replace(replace(t1.partition_month,chr(13),''),chr(10),'') as partition_month

from ${iol_schema}.rsts_rcd_ir_tzbl_yqqs t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_tzbl_yqqs.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
