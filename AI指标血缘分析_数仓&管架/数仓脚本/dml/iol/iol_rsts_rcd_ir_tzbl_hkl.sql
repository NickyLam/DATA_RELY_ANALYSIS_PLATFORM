/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_rcd_ir_tzbl_hkl
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
drop table ${iol_schema}.rsts_rcd_ir_tzbl_hkl_ex purge;
alter table ${iol_schema}.rsts_rcd_ir_tzbl_hkl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_rcd_ir_tzbl_hkl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_rcd_ir_tzbl_hkl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_rcd_ir_tzbl_hkl where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_rcd_ir_tzbl_hkl_ex(
    key_id -- 主键
    ,loan_no -- 借据号
    ,data_dt -- 数据日期
    ,loan_biz_type_cd -- 业务品种代码
    ,var0301 -- 当前月实际还款率
    ,var0302 -- 过去3个月实际还款率的最小值
    ,var0303 -- 过去6个月实际还款率的最小值
    ,var0304 -- 过去12个月实际还款率的最小值
    ,var0305 -- 过去3个月实际还款率的最大值
    ,var0306 -- 过去6个月实际还款率的最大值
    ,var0307 -- 过去12个月实际还款率的最大值
    ,var0308 -- 过去3个月实际还款率的平均值
    ,var0309 -- 过去6个月实际还款率的平均值
    ,var0310 -- 过去12个月实际还款率的平均值
    ,var0311 -- 过去3个月实际还款率大于50%的月数
    ,var0312 -- 过去6个月实际还款率大于50%的月数
    ,var0313 -- 过去12个月实际还款率大于50%的月数
    ,var0314 -- 过去12个月实际还款率大于50%的距今月数
    ,var0315 -- 过去3个月实际还款率大于75%的月数
    ,var0316 -- 过去6个月实际还款率大于75%的月数
    ,var0317 -- 过去12个月实际还款率大于75%的月数
    ,var0318 -- 过去12个月实际还款率大于75%的距今月数
    ,var0319 -- 过去3个月实际还款率大于90%的月数
    ,var0320 -- 过去6个月实际还款率大于90%的月数
    ,var0321 -- 过去12个月实际还款率大于90%的月数
    ,var0322 -- 过去12个月实际还款率大于90%的距今月数
    ,var0323 -- 过去3个月实际还款率大于等于100%的月数
    ,var0324 -- 过去6个月实际还款率大于等于100%的月数
    ,var0325 -- 过去12个月实际还款率大于等于100%的月数
    ,var0326 -- 过去12个月实际还款率大于等于100%的距今月数
    ,var0327 -- 过去3个月实际还款率小于10%的月数
    ,var0328 -- 过去6个月实际还款率小于10%的月数
    ,var0329 -- 过去12个月实际还款率小于10%的月数
    ,var0330 -- 过去12个月实际还款率小于10%的距今月数
    ,var0331 -- 过去3个月实际还款率小于25%的月数
    ,var0332 -- 过去6个月实际还款率小于25%的月数
    ,var0333 -- 过去12个月实际还款率小于25%的月数
    ,var0334 -- 过去12个月实际还款率小于25%的距今月数
    ,var0335 -- 过去3个月实际还款率小于50%的月数
    ,var0336 -- 过去6个月实际还款率小于50%的月数
    ,var0337 -- 过去12个月实际还款率小于50%的月数
    ,var0338 -- 过去12个月实际还款率小于50%的距今月数
    ,var0339 -- 过去3个月实际还款率等于0%的月数
    ,var0340 -- 过去6个月实际还款率等于0%的月数
    ,var0341 -- 过去12个月实际还款率等于0%的月数
    ,var0342 -- 过去12个月实际还款率等于0%的距今月数
    ,var0343 -- 过去3个月还款率连续增加月份数
    ,var0344 -- 过去6个月还款率连续增加月份数
    ,var0345 -- 过去12个月还款率连续增加月份数
    ,var0346 -- 过去3个月还款率连续减少月份数
    ,var0347 -- 过去6个月还款率连续减少月份数
    ,var0348 -- 过去12个月还款率连续减少月份数
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
    ,var0301 -- 当前月实际还款率
    ,var0302 -- 过去3个月实际还款率的最小值
    ,var0303 -- 过去6个月实际还款率的最小值
    ,var0304 -- 过去12个月实际还款率的最小值
    ,var0305 -- 过去3个月实际还款率的最大值
    ,var0306 -- 过去6个月实际还款率的最大值
    ,var0307 -- 过去12个月实际还款率的最大值
    ,var0308 -- 过去3个月实际还款率的平均值
    ,var0309 -- 过去6个月实际还款率的平均值
    ,var0310 -- 过去12个月实际还款率的平均值
    ,var0311 -- 过去3个月实际还款率大于50%的月数
    ,var0312 -- 过去6个月实际还款率大于50%的月数
    ,var0313 -- 过去12个月实际还款率大于50%的月数
    ,var0314 -- 过去12个月实际还款率大于50%的距今月数
    ,var0315 -- 过去3个月实际还款率大于75%的月数
    ,var0316 -- 过去6个月实际还款率大于75%的月数
    ,var0317 -- 过去12个月实际还款率大于75%的月数
    ,var0318 -- 过去12个月实际还款率大于75%的距今月数
    ,var0319 -- 过去3个月实际还款率大于90%的月数
    ,var0320 -- 过去6个月实际还款率大于90%的月数
    ,var0321 -- 过去12个月实际还款率大于90%的月数
    ,var0322 -- 过去12个月实际还款率大于90%的距今月数
    ,var0323 -- 过去3个月实际还款率大于等于100%的月数
    ,var0324 -- 过去6个月实际还款率大于等于100%的月数
    ,var0325 -- 过去12个月实际还款率大于等于100%的月数
    ,var0326 -- 过去12个月实际还款率大于等于100%的距今月数
    ,var0327 -- 过去3个月实际还款率小于10%的月数
    ,var0328 -- 过去6个月实际还款率小于10%的月数
    ,var0329 -- 过去12个月实际还款率小于10%的月数
    ,var0330 -- 过去12个月实际还款率小于10%的距今月数
    ,var0331 -- 过去3个月实际还款率小于25%的月数
    ,var0332 -- 过去6个月实际还款率小于25%的月数
    ,var0333 -- 过去12个月实际还款率小于25%的月数
    ,var0334 -- 过去12个月实际还款率小于25%的距今月数
    ,var0335 -- 过去3个月实际还款率小于50%的月数
    ,var0336 -- 过去6个月实际还款率小于50%的月数
    ,var0337 -- 过去12个月实际还款率小于50%的月数
    ,var0338 -- 过去12个月实际还款率小于50%的距今月数
    ,var0339 -- 过去3个月实际还款率等于0%的月数
    ,var0340 -- 过去6个月实际还款率等于0%的月数
    ,var0341 -- 过去12个月实际还款率等于0%的月数
    ,var0342 -- 过去12个月实际还款率等于0%的距今月数
    ,var0343 -- 过去3个月还款率连续增加月份数
    ,var0344 -- 过去6个月还款率连续增加月份数
    ,var0345 -- 过去12个月还款率连续增加月份数
    ,var0346 -- 过去3个月还款率连续减少月份数
    ,var0347 -- 过去6个月还款率连续减少月份数
    ,var0348 -- 过去12个月还款率连续减少月份数
    ,exc_id -- 执行清单表ID
    ,generated_time -- 生成时间
    ,partition_month -- 分区月份
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_rcd_ir_tzbl_hkl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_rcd_ir_tzbl_hkl exchange partition p_${batch_date} with table ${iol_schema}.rsts_rcd_ir_tzbl_hkl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_rcd_ir_tzbl_hkl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_rcd_ir_tzbl_hkl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_rcd_ir_tzbl_hkl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);