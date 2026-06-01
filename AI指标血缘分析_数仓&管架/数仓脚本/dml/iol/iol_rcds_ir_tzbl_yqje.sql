/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_yqje
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rcds_ir_tzbl_yqje_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_tzbl_yqje;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_yqje_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_yqje_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_yqje_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_yqje where 0=1;

create table ${iol_schema}.rcds_ir_tzbl_yqje_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_yqje where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_yqje_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0501 -- 当前月逾期金额
            ,var0502 -- 过去3个月逾期金额的平均值
            ,var0503 -- 过去6个月逾期金额的平均值
            ,var0504 -- 过去12个月逾期金额的平均值
            ,var0505 -- 过去3个月逾期金额的总和
            ,var0506 -- 过去6个月逾期金额的总和
            ,var0507 -- 过去12个月逾期金额的总和
            ,var0508 -- 过去3个月逾期金额最大值
            ,var0509 -- 过去6个月逾期金额最大值
            ,var0510 -- 过去12个月逾期金额最大值
            ,var0511 -- 过去3个月逾期金额>0的次数
            ,var0512 -- 过去6个月逾期金额>0的次数
            ,var0513 -- 过去12个月逾期金额>0的次数
            ,var0514 -- 过去3个月逾期金额最后一次>0的距今月数
            ,var0515 -- 过去6个月逾期金额最后一次>0的距今月数
            ,var0516 -- 过去12个月逾期金额最后一次>0的距今月数
            ,var0517 -- 过去3个月逾期金额连续增加月份数
            ,var0518 -- 过去6个月逾期金额连续增加月份数
            ,var0519 -- 过去12个月逾期金额连续增加月份数
            ,var0520 -- 过去3个月逾期1期以上（含）之逾期金额的最大值
            ,var0521 -- 过去3个月逾期1期以上（含）之逾期金额的平均值
            ,var0522 -- 过去3个月逾期1期以上（含）之逾期金额的总和
            ,var0523 -- 过去6个月逾期1期以上（含）之逾期金额的最大值
            ,var0524 -- 过去6个月逾期1期以上（含）之逾期金额的平均值
            ,var0525 -- 过去6个月逾期1期以上（含）之逾期金额的总和
            ,var0526 -- 过去12个月逾期1期以上（含）之逾期金额的最大值
            ,var0527 -- 过去12个月逾期1期以上（含）之逾期金额的平均值
            ,var0528 -- 过去12个月逾期1期以上（含）之逾期金额的总和
            ,var0529 -- 过去3个月逾期2期以上（含）之逾期金额的最大值
            ,var0530 -- 过去3个月逾期2期以上（含）之逾期金额的平均值
            ,var0531 -- 过去3个月逾期2期以上（含）之逾期金额的总和
            ,var0532 -- 过去6个月逾期2期以上（含）之逾期金额的最大值
            ,var0533 -- 过去6个月逾期2期以上（含）之逾期金额的平均值
            ,var0534 -- 过去6个月逾期2期以上（含）之逾期金额的总和
            ,var0535 -- 过去12个月逾期2期以上（含）之逾期金额的最大值
            ,var0536 -- 过去12个月逾期2期以上（含）之逾期金额的平均值
            ,var0537 -- 过去12个月逾期2期以上（含）之逾期金额的总和
            ,var0538 -- 过去3个月逾期3期以上（含）之逾期金额的最大值
            ,var0539 -- 过去3个月逾期3期以上（含）之逾期金额的平均值
            ,var0540 -- 过去3个月逾期3期以上（含）之逾期金额的总和
            ,var0541 -- 过去6个月逾期3期以上（含）之逾期金额的最大值
            ,var0542 -- 过去6个月逾期3期以上（含）之逾期金额的平均值
            ,var0543 -- 过去6个月逾期3期以上（含）之逾期金额的总和
            ,var0544 -- 过去12个月逾期3期以上（含）之逾期金额的最大值
            ,var0545 -- 过去12个月逾期3期以上（含）之逾期金额的平均值
            ,var0546 -- 过去12个月逾期3期以上（含）之逾期金额的总和
            ,var0547 -- 过去3个月逾期4期以上（含）之逾期金额的最大值
            ,var0548 -- 过去3个月逾期4期以上（含）之逾期金额的平均值
            ,var0549 -- 过去3个月逾期4期以上（含）之逾期金额的总和
            ,var0550 -- 过去6个月逾期4期以上（含）之逾期金额的最大值
            ,var0551 -- 过去6个月逾期4期以上（含）之逾期金额的平均值
            ,var0552 -- 过去6个月逾期4期以上（含）之逾期金额的总和
            ,var0553 -- 过去12个月逾期4期以上（含）之逾期金额的最大值
            ,var0554 -- 过去12个月逾期4期以上（含）之逾期金额的平均值
            ,var0555 -- 过去12个月逾期4期以上（含）之逾期金额的总和
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_yqje_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0501 -- 当前月逾期金额
            ,var0502 -- 过去3个月逾期金额的平均值
            ,var0503 -- 过去6个月逾期金额的平均值
            ,var0504 -- 过去12个月逾期金额的平均值
            ,var0505 -- 过去3个月逾期金额的总和
            ,var0506 -- 过去6个月逾期金额的总和
            ,var0507 -- 过去12个月逾期金额的总和
            ,var0508 -- 过去3个月逾期金额最大值
            ,var0509 -- 过去6个月逾期金额最大值
            ,var0510 -- 过去12个月逾期金额最大值
            ,var0511 -- 过去3个月逾期金额>0的次数
            ,var0512 -- 过去6个月逾期金额>0的次数
            ,var0513 -- 过去12个月逾期金额>0的次数
            ,var0514 -- 过去3个月逾期金额最后一次>0的距今月数
            ,var0515 -- 过去6个月逾期金额最后一次>0的距今月数
            ,var0516 -- 过去12个月逾期金额最后一次>0的距今月数
            ,var0517 -- 过去3个月逾期金额连续增加月份数
            ,var0518 -- 过去6个月逾期金额连续增加月份数
            ,var0519 -- 过去12个月逾期金额连续增加月份数
            ,var0520 -- 过去3个月逾期1期以上（含）之逾期金额的最大值
            ,var0521 -- 过去3个月逾期1期以上（含）之逾期金额的平均值
            ,var0522 -- 过去3个月逾期1期以上（含）之逾期金额的总和
            ,var0523 -- 过去6个月逾期1期以上（含）之逾期金额的最大值
            ,var0524 -- 过去6个月逾期1期以上（含）之逾期金额的平均值
            ,var0525 -- 过去6个月逾期1期以上（含）之逾期金额的总和
            ,var0526 -- 过去12个月逾期1期以上（含）之逾期金额的最大值
            ,var0527 -- 过去12个月逾期1期以上（含）之逾期金额的平均值
            ,var0528 -- 过去12个月逾期1期以上（含）之逾期金额的总和
            ,var0529 -- 过去3个月逾期2期以上（含）之逾期金额的最大值
            ,var0530 -- 过去3个月逾期2期以上（含）之逾期金额的平均值
            ,var0531 -- 过去3个月逾期2期以上（含）之逾期金额的总和
            ,var0532 -- 过去6个月逾期2期以上（含）之逾期金额的最大值
            ,var0533 -- 过去6个月逾期2期以上（含）之逾期金额的平均值
            ,var0534 -- 过去6个月逾期2期以上（含）之逾期金额的总和
            ,var0535 -- 过去12个月逾期2期以上（含）之逾期金额的最大值
            ,var0536 -- 过去12个月逾期2期以上（含）之逾期金额的平均值
            ,var0537 -- 过去12个月逾期2期以上（含）之逾期金额的总和
            ,var0538 -- 过去3个月逾期3期以上（含）之逾期金额的最大值
            ,var0539 -- 过去3个月逾期3期以上（含）之逾期金额的平均值
            ,var0540 -- 过去3个月逾期3期以上（含）之逾期金额的总和
            ,var0541 -- 过去6个月逾期3期以上（含）之逾期金额的最大值
            ,var0542 -- 过去6个月逾期3期以上（含）之逾期金额的平均值
            ,var0543 -- 过去6个月逾期3期以上（含）之逾期金额的总和
            ,var0544 -- 过去12个月逾期3期以上（含）之逾期金额的最大值
            ,var0545 -- 过去12个月逾期3期以上（含）之逾期金额的平均值
            ,var0546 -- 过去12个月逾期3期以上（含）之逾期金额的总和
            ,var0547 -- 过去3个月逾期4期以上（含）之逾期金额的最大值
            ,var0548 -- 过去3个月逾期4期以上（含）之逾期金额的平均值
            ,var0549 -- 过去3个月逾期4期以上（含）之逾期金额的总和
            ,var0550 -- 过去6个月逾期4期以上（含）之逾期金额的最大值
            ,var0551 -- 过去6个月逾期4期以上（含）之逾期金额的平均值
            ,var0552 -- 过去6个月逾期4期以上（含）之逾期金额的总和
            ,var0553 -- 过去12个月逾期4期以上（含）之逾期金额的最大值
            ,var0554 -- 过去12个月逾期4期以上（含）之逾期金额的平均值
            ,var0555 -- 过去12个月逾期4期以上（含）之逾期金额的总和
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_id, o.key_id) as key_id -- 主键
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 借据号
    ,nvl(n.data_dt, o.data_dt) as data_dt -- 数据日期
    ,nvl(n.loan_biz_type_cd, o.loan_biz_type_cd) as loan_biz_type_cd -- 业务品种代码
    ,nvl(n.var0501, o.var0501) as var0501 -- 当前月逾期金额
    ,nvl(n.var0502, o.var0502) as var0502 -- 过去3个月逾期金额的平均值
    ,nvl(n.var0503, o.var0503) as var0503 -- 过去6个月逾期金额的平均值
    ,nvl(n.var0504, o.var0504) as var0504 -- 过去12个月逾期金额的平均值
    ,nvl(n.var0505, o.var0505) as var0505 -- 过去3个月逾期金额的总和
    ,nvl(n.var0506, o.var0506) as var0506 -- 过去6个月逾期金额的总和
    ,nvl(n.var0507, o.var0507) as var0507 -- 过去12个月逾期金额的总和
    ,nvl(n.var0508, o.var0508) as var0508 -- 过去3个月逾期金额最大值
    ,nvl(n.var0509, o.var0509) as var0509 -- 过去6个月逾期金额最大值
    ,nvl(n.var0510, o.var0510) as var0510 -- 过去12个月逾期金额最大值
    ,nvl(n.var0511, o.var0511) as var0511 -- 过去3个月逾期金额>0的次数
    ,nvl(n.var0512, o.var0512) as var0512 -- 过去6个月逾期金额>0的次数
    ,nvl(n.var0513, o.var0513) as var0513 -- 过去12个月逾期金额>0的次数
    ,nvl(n.var0514, o.var0514) as var0514 -- 过去3个月逾期金额最后一次>0的距今月数
    ,nvl(n.var0515, o.var0515) as var0515 -- 过去6个月逾期金额最后一次>0的距今月数
    ,nvl(n.var0516, o.var0516) as var0516 -- 过去12个月逾期金额最后一次>0的距今月数
    ,nvl(n.var0517, o.var0517) as var0517 -- 过去3个月逾期金额连续增加月份数
    ,nvl(n.var0518, o.var0518) as var0518 -- 过去6个月逾期金额连续增加月份数
    ,nvl(n.var0519, o.var0519) as var0519 -- 过去12个月逾期金额连续增加月份数
    ,nvl(n.var0520, o.var0520) as var0520 -- 过去3个月逾期1期以上（含）之逾期金额的最大值
    ,nvl(n.var0521, o.var0521) as var0521 -- 过去3个月逾期1期以上（含）之逾期金额的平均值
    ,nvl(n.var0522, o.var0522) as var0522 -- 过去3个月逾期1期以上（含）之逾期金额的总和
    ,nvl(n.var0523, o.var0523) as var0523 -- 过去6个月逾期1期以上（含）之逾期金额的最大值
    ,nvl(n.var0524, o.var0524) as var0524 -- 过去6个月逾期1期以上（含）之逾期金额的平均值
    ,nvl(n.var0525, o.var0525) as var0525 -- 过去6个月逾期1期以上（含）之逾期金额的总和
    ,nvl(n.var0526, o.var0526) as var0526 -- 过去12个月逾期1期以上（含）之逾期金额的最大值
    ,nvl(n.var0527, o.var0527) as var0527 -- 过去12个月逾期1期以上（含）之逾期金额的平均值
    ,nvl(n.var0528, o.var0528) as var0528 -- 过去12个月逾期1期以上（含）之逾期金额的总和
    ,nvl(n.var0529, o.var0529) as var0529 -- 过去3个月逾期2期以上（含）之逾期金额的最大值
    ,nvl(n.var0530, o.var0530) as var0530 -- 过去3个月逾期2期以上（含）之逾期金额的平均值
    ,nvl(n.var0531, o.var0531) as var0531 -- 过去3个月逾期2期以上（含）之逾期金额的总和
    ,nvl(n.var0532, o.var0532) as var0532 -- 过去6个月逾期2期以上（含）之逾期金额的最大值
    ,nvl(n.var0533, o.var0533) as var0533 -- 过去6个月逾期2期以上（含）之逾期金额的平均值
    ,nvl(n.var0534, o.var0534) as var0534 -- 过去6个月逾期2期以上（含）之逾期金额的总和
    ,nvl(n.var0535, o.var0535) as var0535 -- 过去12个月逾期2期以上（含）之逾期金额的最大值
    ,nvl(n.var0536, o.var0536) as var0536 -- 过去12个月逾期2期以上（含）之逾期金额的平均值
    ,nvl(n.var0537, o.var0537) as var0537 -- 过去12个月逾期2期以上（含）之逾期金额的总和
    ,nvl(n.var0538, o.var0538) as var0538 -- 过去3个月逾期3期以上（含）之逾期金额的最大值
    ,nvl(n.var0539, o.var0539) as var0539 -- 过去3个月逾期3期以上（含）之逾期金额的平均值
    ,nvl(n.var0540, o.var0540) as var0540 -- 过去3个月逾期3期以上（含）之逾期金额的总和
    ,nvl(n.var0541, o.var0541) as var0541 -- 过去6个月逾期3期以上（含）之逾期金额的最大值
    ,nvl(n.var0542, o.var0542) as var0542 -- 过去6个月逾期3期以上（含）之逾期金额的平均值
    ,nvl(n.var0543, o.var0543) as var0543 -- 过去6个月逾期3期以上（含）之逾期金额的总和
    ,nvl(n.var0544, o.var0544) as var0544 -- 过去12个月逾期3期以上（含）之逾期金额的最大值
    ,nvl(n.var0545, o.var0545) as var0545 -- 过去12个月逾期3期以上（含）之逾期金额的平均值
    ,nvl(n.var0546, o.var0546) as var0546 -- 过去12个月逾期3期以上（含）之逾期金额的总和
    ,nvl(n.var0547, o.var0547) as var0547 -- 过去3个月逾期4期以上（含）之逾期金额的最大值
    ,nvl(n.var0548, o.var0548) as var0548 -- 过去3个月逾期4期以上（含）之逾期金额的平均值
    ,nvl(n.var0549, o.var0549) as var0549 -- 过去3个月逾期4期以上（含）之逾期金额的总和
    ,nvl(n.var0550, o.var0550) as var0550 -- 过去6个月逾期4期以上（含）之逾期金额的最大值
    ,nvl(n.var0551, o.var0551) as var0551 -- 过去6个月逾期4期以上（含）之逾期金额的平均值
    ,nvl(n.var0552, o.var0552) as var0552 -- 过去6个月逾期4期以上（含）之逾期金额的总和
    ,nvl(n.var0553, o.var0553) as var0553 -- 过去12个月逾期4期以上（含）之逾期金额的最大值
    ,nvl(n.var0554, o.var0554) as var0554 -- 过去12个月逾期4期以上（含）之逾期金额的平均值
    ,nvl(n.var0555, o.var0555) as var0555 -- 过去12个月逾期4期以上（含）之逾期金额的总和
    ,case when
            n.key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_tzbl_yqje_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_tzbl_yqje where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_id = n.key_id
where (
        o.key_id is null
    )
    or (
        n.key_id is null
    )
    or (
        o.loan_no <> n.loan_no
        or o.data_dt <> n.data_dt
        or o.loan_biz_type_cd <> n.loan_biz_type_cd
        or o.var0501 <> n.var0501
        or o.var0502 <> n.var0502
        or o.var0503 <> n.var0503
        or o.var0504 <> n.var0504
        or o.var0505 <> n.var0505
        or o.var0506 <> n.var0506
        or o.var0507 <> n.var0507
        or o.var0508 <> n.var0508
        or o.var0509 <> n.var0509
        or o.var0510 <> n.var0510
        or o.var0511 <> n.var0511
        or o.var0512 <> n.var0512
        or o.var0513 <> n.var0513
        or o.var0514 <> n.var0514
        or o.var0515 <> n.var0515
        or o.var0516 <> n.var0516
        or o.var0517 <> n.var0517
        or o.var0518 <> n.var0518
        or o.var0519 <> n.var0519
        or o.var0520 <> n.var0520
        or o.var0521 <> n.var0521
        or o.var0522 <> n.var0522
        or o.var0523 <> n.var0523
        or o.var0524 <> n.var0524
        or o.var0525 <> n.var0525
        or o.var0526 <> n.var0526
        or o.var0527 <> n.var0527
        or o.var0528 <> n.var0528
        or o.var0529 <> n.var0529
        or o.var0530 <> n.var0530
        or o.var0531 <> n.var0531
        or o.var0532 <> n.var0532
        or o.var0533 <> n.var0533
        or o.var0534 <> n.var0534
        or o.var0535 <> n.var0535
        or o.var0536 <> n.var0536
        or o.var0537 <> n.var0537
        or o.var0538 <> n.var0538
        or o.var0539 <> n.var0539
        or o.var0540 <> n.var0540
        or o.var0541 <> n.var0541
        or o.var0542 <> n.var0542
        or o.var0543 <> n.var0543
        or o.var0544 <> n.var0544
        or o.var0545 <> n.var0545
        or o.var0546 <> n.var0546
        or o.var0547 <> n.var0547
        or o.var0548 <> n.var0548
        or o.var0549 <> n.var0549
        or o.var0550 <> n.var0550
        or o.var0551 <> n.var0551
        or o.var0552 <> n.var0552
        or o.var0553 <> n.var0553
        or o.var0554 <> n.var0554
        or o.var0555 <> n.var0555
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_yqje_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0501 -- 当前月逾期金额
            ,var0502 -- 过去3个月逾期金额的平均值
            ,var0503 -- 过去6个月逾期金额的平均值
            ,var0504 -- 过去12个月逾期金额的平均值
            ,var0505 -- 过去3个月逾期金额的总和
            ,var0506 -- 过去6个月逾期金额的总和
            ,var0507 -- 过去12个月逾期金额的总和
            ,var0508 -- 过去3个月逾期金额最大值
            ,var0509 -- 过去6个月逾期金额最大值
            ,var0510 -- 过去12个月逾期金额最大值
            ,var0511 -- 过去3个月逾期金额>0的次数
            ,var0512 -- 过去6个月逾期金额>0的次数
            ,var0513 -- 过去12个月逾期金额>0的次数
            ,var0514 -- 过去3个月逾期金额最后一次>0的距今月数
            ,var0515 -- 过去6个月逾期金额最后一次>0的距今月数
            ,var0516 -- 过去12个月逾期金额最后一次>0的距今月数
            ,var0517 -- 过去3个月逾期金额连续增加月份数
            ,var0518 -- 过去6个月逾期金额连续增加月份数
            ,var0519 -- 过去12个月逾期金额连续增加月份数
            ,var0520 -- 过去3个月逾期1期以上（含）之逾期金额的最大值
            ,var0521 -- 过去3个月逾期1期以上（含）之逾期金额的平均值
            ,var0522 -- 过去3个月逾期1期以上（含）之逾期金额的总和
            ,var0523 -- 过去6个月逾期1期以上（含）之逾期金额的最大值
            ,var0524 -- 过去6个月逾期1期以上（含）之逾期金额的平均值
            ,var0525 -- 过去6个月逾期1期以上（含）之逾期金额的总和
            ,var0526 -- 过去12个月逾期1期以上（含）之逾期金额的最大值
            ,var0527 -- 过去12个月逾期1期以上（含）之逾期金额的平均值
            ,var0528 -- 过去12个月逾期1期以上（含）之逾期金额的总和
            ,var0529 -- 过去3个月逾期2期以上（含）之逾期金额的最大值
            ,var0530 -- 过去3个月逾期2期以上（含）之逾期金额的平均值
            ,var0531 -- 过去3个月逾期2期以上（含）之逾期金额的总和
            ,var0532 -- 过去6个月逾期2期以上（含）之逾期金额的最大值
            ,var0533 -- 过去6个月逾期2期以上（含）之逾期金额的平均值
            ,var0534 -- 过去6个月逾期2期以上（含）之逾期金额的总和
            ,var0535 -- 过去12个月逾期2期以上（含）之逾期金额的最大值
            ,var0536 -- 过去12个月逾期2期以上（含）之逾期金额的平均值
            ,var0537 -- 过去12个月逾期2期以上（含）之逾期金额的总和
            ,var0538 -- 过去3个月逾期3期以上（含）之逾期金额的最大值
            ,var0539 -- 过去3个月逾期3期以上（含）之逾期金额的平均值
            ,var0540 -- 过去3个月逾期3期以上（含）之逾期金额的总和
            ,var0541 -- 过去6个月逾期3期以上（含）之逾期金额的最大值
            ,var0542 -- 过去6个月逾期3期以上（含）之逾期金额的平均值
            ,var0543 -- 过去6个月逾期3期以上（含）之逾期金额的总和
            ,var0544 -- 过去12个月逾期3期以上（含）之逾期金额的最大值
            ,var0545 -- 过去12个月逾期3期以上（含）之逾期金额的平均值
            ,var0546 -- 过去12个月逾期3期以上（含）之逾期金额的总和
            ,var0547 -- 过去3个月逾期4期以上（含）之逾期金额的最大值
            ,var0548 -- 过去3个月逾期4期以上（含）之逾期金额的平均值
            ,var0549 -- 过去3个月逾期4期以上（含）之逾期金额的总和
            ,var0550 -- 过去6个月逾期4期以上（含）之逾期金额的最大值
            ,var0551 -- 过去6个月逾期4期以上（含）之逾期金额的平均值
            ,var0552 -- 过去6个月逾期4期以上（含）之逾期金额的总和
            ,var0553 -- 过去12个月逾期4期以上（含）之逾期金额的最大值
            ,var0554 -- 过去12个月逾期4期以上（含）之逾期金额的平均值
            ,var0555 -- 过去12个月逾期4期以上（含）之逾期金额的总和
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_yqje_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0501 -- 当前月逾期金额
            ,var0502 -- 过去3个月逾期金额的平均值
            ,var0503 -- 过去6个月逾期金额的平均值
            ,var0504 -- 过去12个月逾期金额的平均值
            ,var0505 -- 过去3个月逾期金额的总和
            ,var0506 -- 过去6个月逾期金额的总和
            ,var0507 -- 过去12个月逾期金额的总和
            ,var0508 -- 过去3个月逾期金额最大值
            ,var0509 -- 过去6个月逾期金额最大值
            ,var0510 -- 过去12个月逾期金额最大值
            ,var0511 -- 过去3个月逾期金额>0的次数
            ,var0512 -- 过去6个月逾期金额>0的次数
            ,var0513 -- 过去12个月逾期金额>0的次数
            ,var0514 -- 过去3个月逾期金额最后一次>0的距今月数
            ,var0515 -- 过去6个月逾期金额最后一次>0的距今月数
            ,var0516 -- 过去12个月逾期金额最后一次>0的距今月数
            ,var0517 -- 过去3个月逾期金额连续增加月份数
            ,var0518 -- 过去6个月逾期金额连续增加月份数
            ,var0519 -- 过去12个月逾期金额连续增加月份数
            ,var0520 -- 过去3个月逾期1期以上（含）之逾期金额的最大值
            ,var0521 -- 过去3个月逾期1期以上（含）之逾期金额的平均值
            ,var0522 -- 过去3个月逾期1期以上（含）之逾期金额的总和
            ,var0523 -- 过去6个月逾期1期以上（含）之逾期金额的最大值
            ,var0524 -- 过去6个月逾期1期以上（含）之逾期金额的平均值
            ,var0525 -- 过去6个月逾期1期以上（含）之逾期金额的总和
            ,var0526 -- 过去12个月逾期1期以上（含）之逾期金额的最大值
            ,var0527 -- 过去12个月逾期1期以上（含）之逾期金额的平均值
            ,var0528 -- 过去12个月逾期1期以上（含）之逾期金额的总和
            ,var0529 -- 过去3个月逾期2期以上（含）之逾期金额的最大值
            ,var0530 -- 过去3个月逾期2期以上（含）之逾期金额的平均值
            ,var0531 -- 过去3个月逾期2期以上（含）之逾期金额的总和
            ,var0532 -- 过去6个月逾期2期以上（含）之逾期金额的最大值
            ,var0533 -- 过去6个月逾期2期以上（含）之逾期金额的平均值
            ,var0534 -- 过去6个月逾期2期以上（含）之逾期金额的总和
            ,var0535 -- 过去12个月逾期2期以上（含）之逾期金额的最大值
            ,var0536 -- 过去12个月逾期2期以上（含）之逾期金额的平均值
            ,var0537 -- 过去12个月逾期2期以上（含）之逾期金额的总和
            ,var0538 -- 过去3个月逾期3期以上（含）之逾期金额的最大值
            ,var0539 -- 过去3个月逾期3期以上（含）之逾期金额的平均值
            ,var0540 -- 过去3个月逾期3期以上（含）之逾期金额的总和
            ,var0541 -- 过去6个月逾期3期以上（含）之逾期金额的最大值
            ,var0542 -- 过去6个月逾期3期以上（含）之逾期金额的平均值
            ,var0543 -- 过去6个月逾期3期以上（含）之逾期金额的总和
            ,var0544 -- 过去12个月逾期3期以上（含）之逾期金额的最大值
            ,var0545 -- 过去12个月逾期3期以上（含）之逾期金额的平均值
            ,var0546 -- 过去12个月逾期3期以上（含）之逾期金额的总和
            ,var0547 -- 过去3个月逾期4期以上（含）之逾期金额的最大值
            ,var0548 -- 过去3个月逾期4期以上（含）之逾期金额的平均值
            ,var0549 -- 过去3个月逾期4期以上（含）之逾期金额的总和
            ,var0550 -- 过去6个月逾期4期以上（含）之逾期金额的最大值
            ,var0551 -- 过去6个月逾期4期以上（含）之逾期金额的平均值
            ,var0552 -- 过去6个月逾期4期以上（含）之逾期金额的总和
            ,var0553 -- 过去12个月逾期4期以上（含）之逾期金额的最大值
            ,var0554 -- 过去12个月逾期4期以上（含）之逾期金额的平均值
            ,var0555 -- 过去12个月逾期4期以上（含）之逾期金额的总和
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_id -- 主键
    ,o.loan_no -- 借据号
    ,o.data_dt -- 数据日期
    ,o.loan_biz_type_cd -- 业务品种代码
    ,o.var0501 -- 当前月逾期金额
    ,o.var0502 -- 过去3个月逾期金额的平均值
    ,o.var0503 -- 过去6个月逾期金额的平均值
    ,o.var0504 -- 过去12个月逾期金额的平均值
    ,o.var0505 -- 过去3个月逾期金额的总和
    ,o.var0506 -- 过去6个月逾期金额的总和
    ,o.var0507 -- 过去12个月逾期金额的总和
    ,o.var0508 -- 过去3个月逾期金额最大值
    ,o.var0509 -- 过去6个月逾期金额最大值
    ,o.var0510 -- 过去12个月逾期金额最大值
    ,o.var0511 -- 过去3个月逾期金额>0的次数
    ,o.var0512 -- 过去6个月逾期金额>0的次数
    ,o.var0513 -- 过去12个月逾期金额>0的次数
    ,o.var0514 -- 过去3个月逾期金额最后一次>0的距今月数
    ,o.var0515 -- 过去6个月逾期金额最后一次>0的距今月数
    ,o.var0516 -- 过去12个月逾期金额最后一次>0的距今月数
    ,o.var0517 -- 过去3个月逾期金额连续增加月份数
    ,o.var0518 -- 过去6个月逾期金额连续增加月份数
    ,o.var0519 -- 过去12个月逾期金额连续增加月份数
    ,o.var0520 -- 过去3个月逾期1期以上（含）之逾期金额的最大值
    ,o.var0521 -- 过去3个月逾期1期以上（含）之逾期金额的平均值
    ,o.var0522 -- 过去3个月逾期1期以上（含）之逾期金额的总和
    ,o.var0523 -- 过去6个月逾期1期以上（含）之逾期金额的最大值
    ,o.var0524 -- 过去6个月逾期1期以上（含）之逾期金额的平均值
    ,o.var0525 -- 过去6个月逾期1期以上（含）之逾期金额的总和
    ,o.var0526 -- 过去12个月逾期1期以上（含）之逾期金额的最大值
    ,o.var0527 -- 过去12个月逾期1期以上（含）之逾期金额的平均值
    ,o.var0528 -- 过去12个月逾期1期以上（含）之逾期金额的总和
    ,o.var0529 -- 过去3个月逾期2期以上（含）之逾期金额的最大值
    ,o.var0530 -- 过去3个月逾期2期以上（含）之逾期金额的平均值
    ,o.var0531 -- 过去3个月逾期2期以上（含）之逾期金额的总和
    ,o.var0532 -- 过去6个月逾期2期以上（含）之逾期金额的最大值
    ,o.var0533 -- 过去6个月逾期2期以上（含）之逾期金额的平均值
    ,o.var0534 -- 过去6个月逾期2期以上（含）之逾期金额的总和
    ,o.var0535 -- 过去12个月逾期2期以上（含）之逾期金额的最大值
    ,o.var0536 -- 过去12个月逾期2期以上（含）之逾期金额的平均值
    ,o.var0537 -- 过去12个月逾期2期以上（含）之逾期金额的总和
    ,o.var0538 -- 过去3个月逾期3期以上（含）之逾期金额的最大值
    ,o.var0539 -- 过去3个月逾期3期以上（含）之逾期金额的平均值
    ,o.var0540 -- 过去3个月逾期3期以上（含）之逾期金额的总和
    ,o.var0541 -- 过去6个月逾期3期以上（含）之逾期金额的最大值
    ,o.var0542 -- 过去6个月逾期3期以上（含）之逾期金额的平均值
    ,o.var0543 -- 过去6个月逾期3期以上（含）之逾期金额的总和
    ,o.var0544 -- 过去12个月逾期3期以上（含）之逾期金额的最大值
    ,o.var0545 -- 过去12个月逾期3期以上（含）之逾期金额的平均值
    ,o.var0546 -- 过去12个月逾期3期以上（含）之逾期金额的总和
    ,o.var0547 -- 过去3个月逾期4期以上（含）之逾期金额的最大值
    ,o.var0548 -- 过去3个月逾期4期以上（含）之逾期金额的平均值
    ,o.var0549 -- 过去3个月逾期4期以上（含）之逾期金额的总和
    ,o.var0550 -- 过去6个月逾期4期以上（含）之逾期金额的最大值
    ,o.var0551 -- 过去6个月逾期4期以上（含）之逾期金额的平均值
    ,o.var0552 -- 过去6个月逾期4期以上（含）之逾期金额的总和
    ,o.var0553 -- 过去12个月逾期4期以上（含）之逾期金额的最大值
    ,o.var0554 -- 过去12个月逾期4期以上（含）之逾期金额的平均值
    ,o.var0555 -- 过去12个月逾期4期以上（含）之逾期金额的总和
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_tzbl_yqje_bk o
    left join ${iol_schema}.rcds_ir_tzbl_yqje_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_tzbl_yqje_cl d
        on
            o.key_id = d.key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_tzbl_yqje;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_tzbl_yqje exchange partition p_19000101 with table ${iol_schema}.rcds_ir_tzbl_yqje_cl;
alter table ${iol_schema}.rcds_ir_tzbl_yqje exchange partition p_20991231 with table ${iol_schema}.rcds_ir_tzbl_yqje_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_yqje to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_yqje_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_yqje_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_tzbl_yqje_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_yqje',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
