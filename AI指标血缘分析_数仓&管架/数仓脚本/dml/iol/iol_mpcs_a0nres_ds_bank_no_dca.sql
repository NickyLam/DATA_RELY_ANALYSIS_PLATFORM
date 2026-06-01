/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0nres_ds_bank_no_dca
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
drop table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca_ex purge;
alter table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0nres_ds_bank_no_dca where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a0nres_ds_bank_no_dca_ex(
    partition_date -- 分区日期
    ,repay_date -- 还款日期
    ,card_no -- 逻辑卡号
    ,ref_nbr -- 借据号
    ,due_days -- 逾期天数
    ,bank_group_id -- 参贷方案编号
    ,bank_no -- 银行编号
    ,bank_proportion -- 参贷方案比例
    ,repay_amt -- 还款金额
    ,commission_ratio -- 委外费率
    ,out_expense -- 委外费用
    ,batchfilename -- 批量文件名
    ,seqno -- 序列号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    partition_date -- 分区日期
    ,repay_date -- 还款日期
    ,card_no -- 逻辑卡号
    ,ref_nbr -- 借据号
    ,due_days -- 逾期天数
    ,bank_group_id -- 参贷方案编号
    ,bank_no -- 银行编号
    ,bank_proportion -- 参贷方案比例
    ,repay_amt -- 还款金额
    ,commission_ratio -- 委外费率
    ,out_expense -- 委外费用
    ,batchfilename -- 批量文件名
    ,seqno -- 序列号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a0nres_ds_bank_no_dca
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0nres_ds_bank_no_dca to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a0nres_ds_bank_no_dca_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0nres_ds_bank_no_dca',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);