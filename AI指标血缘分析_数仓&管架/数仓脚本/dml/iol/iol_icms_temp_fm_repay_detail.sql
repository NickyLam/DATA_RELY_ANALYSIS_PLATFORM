/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_temp_fm_repay_detail
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
drop table ${iol_schema}.icms_temp_fm_repay_detail_ex purge;
alter table ${iol_schema}.icms_temp_fm_repay_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_temp_fm_repay_detail;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_temp_fm_repay_detail_ex nologging
compress
as
select * from ${iol_schema}.icms_temp_fm_repay_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_temp_fm_repay_detail_ex(
    business_date -- 业务日期
    ,seq_no -- 交易流水号
    ,loan_id -- 借据号
    ,repay_acc_type -- 还款账户名称
    ,repay_acc_no -- 还款账号
    ,repay_time -- 交易时间 YYYYMMDDHHMMSS
    ,settlement_serial_no -- 清算交易编号
    ,repay_mode -- 还款类型 1-正常还款 2-逾期还款 4-提前还款
    ,repay_way -- 还款方式 1-线上还款 2-线下还款 3-系统扣款 9-未知
    ,receipt_type -- 回收类型 1-正常回收 2-担保代偿
    ,repay_amt -- 还款总金额
    ,period -- 还款期次
    ,repay_pri_amt -- 还款本金
    ,repay_int_amt -- 还款利息
    ,repay_pin_amt -- 还款罚息
    ,repay_cin_amt -- 还款复利
    ,repay_esfee_amt -- 还款提前结清手续费
    ,finance_type -- 资产类型 1-联合出资 2-机构全资
    ,in_seq_no -- 内部交易流水号
    ,asset_identification -- 资产标识
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    business_date -- 业务日期
    ,seq_no -- 交易流水号
    ,loan_id -- 借据号
    ,repay_acc_type -- 还款账户名称
    ,repay_acc_no -- 还款账号
    ,repay_time -- 交易时间 YYYYMMDDHHMMSS
    ,settlement_serial_no -- 清算交易编号
    ,repay_mode -- 还款类型 1-正常还款 2-逾期还款 4-提前还款
    ,repay_way -- 还款方式 1-线上还款 2-线下还款 3-系统扣款 9-未知
    ,receipt_type -- 回收类型 1-正常回收 2-担保代偿
    ,repay_amt -- 还款总金额
    ,period -- 还款期次
    ,repay_pri_amt -- 还款本金
    ,repay_int_amt -- 还款利息
    ,repay_pin_amt -- 还款罚息
    ,repay_cin_amt -- 还款复利
    ,repay_esfee_amt -- 还款提前结清手续费
    ,finance_type -- 资产类型 1-联合出资 2-机构全资
    ,in_seq_no -- 内部交易流水号
    ,asset_identification -- 资产标识
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_temp_fm_repay_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_temp_fm_repay_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_temp_fm_repay_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_temp_fm_repay_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_temp_fm_repay_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_temp_fm_repay_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);