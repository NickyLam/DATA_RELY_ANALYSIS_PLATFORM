: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_tzbl_hkl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_tzbl_hkl.f.${batch_date}.dat
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
    ,t.var0301 as var0301
    ,t.var0302 as var0302
    ,t.var0303 as var0303
    ,t.var0304 as var0304
    ,t.var0305 as var0305
    ,t.var0306 as var0306
    ,t.var0307 as var0307
    ,t.var0308 as var0308
    ,t.var0309 as var0309
    ,t.var0310 as var0310
    ,t.var0311 as var0311
    ,t.var0312 as var0312
    ,t.var0313 as var0313
    ,t.var0314 as var0314
    ,t.var0315 as var0315
    ,t.var0316 as var0316
    ,t.var0317 as var0317
    ,t.var0318 as var0318
    ,t.var0319 as var0319
    ,t.var0320 as var0320
    ,t.var0321 as var0321
    ,t.var0322 as var0322
    ,t.var0323 as var0323
    ,t.var0324 as var0324
    ,t.var0325 as var0325
    ,t.var0326 as var0326
    ,t.var0327 as var0327
    ,t.var0328 as var0328
    ,t.var0329 as var0329
    ,t.var0330 as var0330
    ,t.var0331 as var0331
    ,t.var0332 as var0332
    ,t.var0333 as var0333
    ,t.var0334 as var0334
    ,t.var0335 as var0335
    ,t.var0336 as var0336
    ,t.var0337 as var0337
    ,t.var0338 as var0338
    ,t.var0339 as var0339
    ,t.var0340 as var0340
    ,t.var0341 as var0341
    ,t.var0342 as var0342
    ,t.var0343 as var0343
    ,t.var0344 as var0344
    ,t.var0345 as var0345
    ,t.var0346 as var0346
    ,t.var0347 as var0347
    ,t.var0348 as var0348
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_tzbl_hkl t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_tzbl_hkl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes