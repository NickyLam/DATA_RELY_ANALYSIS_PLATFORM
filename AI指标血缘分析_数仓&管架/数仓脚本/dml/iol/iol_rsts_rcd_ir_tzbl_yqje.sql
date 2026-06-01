/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_rcd_ir_tzbl_yqje
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_rcd_ir_tzbl_yqje_ex purge;
alter table ${iol_schema}.rsts_rcd_ir_tzbl_yqje add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_rcd_ir_tzbl_yqje truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_rcd_ir_tzbl_yqje_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_rcd_ir_tzbl_yqje where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_rcd_ir_tzbl_yqje_ex(
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
    ,exc_id -- 执行清单表ID
    ,generated_time -- 生成时间
    ,partition_month -- 分区月份
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
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
    ,exc_id -- 执行清单表ID
    ,generated_time -- 生成时间
    ,partition_month -- 分区月份
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_rcd_ir_tzbl_yqje
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_rcd_ir_tzbl_yqje exchange partition p_${batch_date} with table ${iol_schema}.rsts_rcd_ir_tzbl_yqje_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_rcd_ir_tzbl_yqje to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_rcd_ir_tzbl_yqje_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_rcd_ir_tzbl_yqje',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);