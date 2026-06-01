: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_tzbl_yqje_a
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_tzbl_yqje.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,var0501
,var0502
,var0503
,var0504
,var0505
,var0506
,var0507
,var0508
,var0509
,var0510
,var0511
,var0512
,var0513
,var0514
,var0515
,var0516
,var0517
,var0518
,var0519
,var0520
,var0521
,var0522
,var0523
,var0524
,var0525
,var0526
,var0527
,var0528
,var0529
,var0530
,var0531
,var0532
,var0533
,var0534
,var0535
,var0536
,var0537
,var0538
,var0539
,var0540
,var0541
,var0542
,var0543
,var0544
,var0545
,var0546
,var0547
,var0548
,var0549
,var0550
,var0551
,var0552
,var0553
,var0554
,var0555
,replace(replace(t1.exc_id,chr(13),''),chr(10),'') as exc_id
,generated_time
,replace(replace(t1.partition_month,chr(13),''),chr(10),'') as partition_month

from ${iol_schema}.rsts_rcd_ir_tzbl_yqje t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_tzbl_yqje.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
