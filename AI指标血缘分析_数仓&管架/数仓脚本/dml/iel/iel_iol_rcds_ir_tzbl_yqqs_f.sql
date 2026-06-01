: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_tzbl_yqqs_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_tzbl_yqqs.f.${batch_date}.dat
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
    ,t.var0401 as var0401
    ,t.var0402 as var0402
    ,t.var0403 as var0403
    ,t.var0404 as var0404
    ,t.var0405 as var0405
    ,t.var0406 as var0406
    ,t.var0407 as var0407
    ,t.var0408 as var0408
    ,t.var0409 as var0409
    ,t.var0410 as var0410
    ,t.var0411 as var0411
    ,t.var0412 as var0412
    ,t.var0413 as var0413
    ,t.var0414 as var0414
    ,t.var0415 as var0415
    ,t.var0416 as var0416
    ,t.var0417 as var0417
    ,t.var0418 as var0418
    ,t.var0419 as var0419
    ,t.var0420 as var0420
    ,t.var0421 as var0421
    ,t.var0422 as var0422
    ,t.var0423 as var0423
    ,t.var0424 as var0424
    ,t.var0425 as var0425
    ,t.var0426 as var0426
    ,t.var0427 as var0427
    ,t.var0428 as var0428
    ,t.var0429 as var0429
    ,t.var0430 as var0430
    ,t.var0431 as var0431
    ,t.var0432 as var0432
    ,t.var0433 as var0433
    ,t.var0434 as var0434
    ,t.var0435 as var0435
    ,t.var0436 as var0436
    ,t.var0437 as var0437
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_tzbl_yqqs t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_tzbl_yqqs.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes