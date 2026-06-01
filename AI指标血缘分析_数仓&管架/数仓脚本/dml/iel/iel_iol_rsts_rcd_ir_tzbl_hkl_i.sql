: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_tzbl_hkl_i
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_tzbl_hkl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,var0301
,var0302
,var0303
,var0304
,var0305
,var0306
,var0307
,var0308
,var0309
,var0310
,var0311
,var0312
,var0313
,var0314
,var0315
,var0316
,var0317
,var0318
,var0319
,var0320
,var0321
,var0322
,var0323
,var0324
,var0325
,var0326
,var0327
,var0328
,var0329
,var0330
,var0331
,var0332
,var0333
,var0334
,var0335
,var0336
,var0337
,var0338
,var0339
,var0340
,var0341
,var0342
,var0343
,var0344
,var0345
,var0346
,var0347
,var0348
,replace(replace(t1.exc_id,chr(13),''),chr(10),'') as exc_id
,generated_time
,replace(replace(t1.partition_month,chr(13),''),chr(10),'') as partition_month

from ${iol_schema}.rsts_rcd_ir_tzbl_hkl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_tzbl_hkl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
