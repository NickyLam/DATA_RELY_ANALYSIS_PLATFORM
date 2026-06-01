/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_rcd_ir_tzbl_yqqs
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
drop table ${iol_schema}.rsts_rcd_ir_tzbl_yqqs_ex purge;
alter table ${iol_schema}.rsts_rcd_ir_tzbl_yqqs add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_rcd_ir_tzbl_yqqs truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_rcd_ir_tzbl_yqqs_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_rcd_ir_tzbl_yqqs where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_rcd_ir_tzbl_yqqs_ex(
    key_id -- 主键
    ,loan_no -- 借据号
    ,data_dt -- 数据日期
    ,loan_biz_type_cd -- 业务品种代码
    ,var0401 -- 当前月逾期期数
    ,var0402 -- 过去3个月逾期期数最大值
    ,var0403 -- 过去6个月逾期期数最大值
    ,var0404 -- 过去12个月逾期期数最大值
    ,var0405 -- 过去3个月1期及以上逾期的次数
    ,var0406 -- 过去6个月1期及以上逾期的次数
    ,var0407 -- 过去12个月1期及以上逾期的次数
    ,var0408 -- 过去3个月1期及以上逾期最后一次的距今月数
    ,var0409 -- 过去6个月1期及以上逾期最后一次的距今月数
    ,var0410 -- 过去12个月1期及以上逾期最后一次的距今月数
    ,var0411 -- 过去3个月2期及以上逾期的次数
    ,var0412 -- 过去6个月2期及以上逾期的次数
    ,var0413 -- 过去12个月2期及以上逾期的次数
    ,var0414 -- 过去3个月2期及以上逾期最后一次的距今月数
    ,var0415 -- 过去6个月2期及以上逾期最后一次的距今月数
    ,var0416 -- 过去12个月2期及以上逾期最后一次的距今月数
    ,var0417 -- 过去3个月3期及以上逾期的次数
    ,var0418 -- 过去6个月3期及以上逾期的次数
    ,var0419 -- 过去12个月3期及以上逾期的次数
    ,var0420 -- 过去3个月3期及以上逾期最后一次的距今月数
    ,var0421 -- 过去6个月3期及以上逾期最后一次的距今月数
    ,var0422 -- 过去12个月3期及以上逾期最后一次的距今月数
    ,var0423 -- 过去3个月4期及以上逾期的次数
    ,var0424 -- 过去6个月4期及以上逾期的次数
    ,var0425 -- 过去12个月4期及以上逾期的次数
    ,var0426 -- 过去3个月4期及以上逾期最后一次的距今月数
    ,var0427 -- 过去6个月4期及以上逾期最后一次的距今月数
    ,var0428 -- 过去12个月4期及以上逾期最后一次的距今月数
    ,var0429 -- 过去3个月内最长连续未逾期月数
    ,var0430 -- 过去6个月内最长连续未逾期月数
    ,var0431 -- 过去12个月内最长连续未逾期月数
    ,var0432 -- 过去3个月内最长连续逾期月数
    ,var0433 -- 过去6个月内最长连续逾期月数
    ,var0434 -- 过去12个月内最长连续逾期月数
    ,var0435 -- 过去3个月内逾期并且逾期期数连续增加的月数
    ,var0436 -- 过去6个月内逾期并且逾期期数连续增加的月数
    ,var0437 -- 过去12个月内逾期并且逾期期数连续增加的月数
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
    ,var0401 -- 当前月逾期期数
    ,var0402 -- 过去3个月逾期期数最大值
    ,var0403 -- 过去6个月逾期期数最大值
    ,var0404 -- 过去12个月逾期期数最大值
    ,var0405 -- 过去3个月1期及以上逾期的次数
    ,var0406 -- 过去6个月1期及以上逾期的次数
    ,var0407 -- 过去12个月1期及以上逾期的次数
    ,var0408 -- 过去3个月1期及以上逾期最后一次的距今月数
    ,var0409 -- 过去6个月1期及以上逾期最后一次的距今月数
    ,var0410 -- 过去12个月1期及以上逾期最后一次的距今月数
    ,var0411 -- 过去3个月2期及以上逾期的次数
    ,var0412 -- 过去6个月2期及以上逾期的次数
    ,var0413 -- 过去12个月2期及以上逾期的次数
    ,var0414 -- 过去3个月2期及以上逾期最后一次的距今月数
    ,var0415 -- 过去6个月2期及以上逾期最后一次的距今月数
    ,var0416 -- 过去12个月2期及以上逾期最后一次的距今月数
    ,var0417 -- 过去3个月3期及以上逾期的次数
    ,var0418 -- 过去6个月3期及以上逾期的次数
    ,var0419 -- 过去12个月3期及以上逾期的次数
    ,var0420 -- 过去3个月3期及以上逾期最后一次的距今月数
    ,var0421 -- 过去6个月3期及以上逾期最后一次的距今月数
    ,var0422 -- 过去12个月3期及以上逾期最后一次的距今月数
    ,var0423 -- 过去3个月4期及以上逾期的次数
    ,var0424 -- 过去6个月4期及以上逾期的次数
    ,var0425 -- 过去12个月4期及以上逾期的次数
    ,var0426 -- 过去3个月4期及以上逾期最后一次的距今月数
    ,var0427 -- 过去6个月4期及以上逾期最后一次的距今月数
    ,var0428 -- 过去12个月4期及以上逾期最后一次的距今月数
    ,var0429 -- 过去3个月内最长连续未逾期月数
    ,var0430 -- 过去6个月内最长连续未逾期月数
    ,var0431 -- 过去12个月内最长连续未逾期月数
    ,var0432 -- 过去3个月内最长连续逾期月数
    ,var0433 -- 过去6个月内最长连续逾期月数
    ,var0434 -- 过去12个月内最长连续逾期月数
    ,var0435 -- 过去3个月内逾期并且逾期期数连续增加的月数
    ,var0436 -- 过去6个月内逾期并且逾期期数连续增加的月数
    ,var0437 -- 过去12个月内逾期并且逾期期数连续增加的月数
    ,exc_id -- 执行清单表ID
    ,generated_time -- 生成时间
    ,partition_month -- 分区月份
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_rcd_ir_tzbl_yqqs
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_rcd_ir_tzbl_yqqs exchange partition p_${batch_date} with table ${iol_schema}.rsts_rcd_ir_tzbl_yqqs_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_rcd_ir_tzbl_yqqs to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_rcd_ir_tzbl_yqqs_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_rcd_ir_tzbl_yqqs',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);