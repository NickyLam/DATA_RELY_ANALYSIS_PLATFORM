: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_tzbl_yqje_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_tzbl_yqje.f.${batch_date}.dat
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
    ,t.var0501 as var0501
    ,t.var0502 as var0502
    ,t.var0503 as var0503
    ,t.var0504 as var0504
    ,t.var0505 as var0505
    ,t.var0506 as var0506
    ,t.var0507 as var0507
    ,t.var0508 as var0508
    ,t.var0509 as var0509
    ,t.var0510 as var0510
    ,t.var0511 as var0511
    ,t.var0512 as var0512
    ,t.var0513 as var0513
    ,t.var0514 as var0514
    ,t.var0515 as var0515
    ,t.var0516 as var0516
    ,t.var0517 as var0517
    ,t.var0518 as var0518
    ,t.var0519 as var0519
    ,t.var0520 as var0520
    ,t.var0521 as var0521
    ,t.var0522 as var0522
    ,t.var0523 as var0523
    ,t.var0524 as var0524
    ,t.var0525 as var0525
    ,t.var0526 as var0526
    ,t.var0527 as var0527
    ,t.var0528 as var0528
    ,t.var0529 as var0529
    ,t.var0530 as var0530
    ,t.var0531 as var0531
    ,t.var0532 as var0532
    ,t.var0533 as var0533
    ,t.var0534 as var0534
    ,t.var0535 as var0535
    ,t.var0536 as var0536
    ,t.var0537 as var0537
    ,t.var0538 as var0538
    ,t.var0539 as var0539
    ,t.var0540 as var0540
    ,t.var0541 as var0541
    ,t.var0542 as var0542
    ,t.var0543 as var0543
    ,t.var0544 as var0544
    ,t.var0545 as var0545
    ,t.var0546 as var0546
    ,t.var0547 as var0547
    ,t.var0548 as var0548
    ,t.var0549 as var0549
    ,t.var0550 as var0550
    ,t.var0551 as var0551
    ,t.var0552 as var0552
    ,t.var0553 as var0553
    ,t.var0554 as var0554
    ,t.var0555 as var0555
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_tzbl_yqje t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_tzbl_yqje.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes