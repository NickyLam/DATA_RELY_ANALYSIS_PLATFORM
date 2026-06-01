/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_temp_fm_loan
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
drop table ${iol_schema}.icms_temp_fm_loan_ex purge;
alter table ${iol_schema}.icms_temp_fm_loan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_temp_fm_loan;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_temp_fm_loan_ex nologging
compress
as
select * from ${iol_schema}.icms_temp_fm_loan where 0=1;

insert /*+ append */ into ${iol_schema}.icms_temp_fm_loan_ex(
    business_date -- 业务日期 D日
    ,loan_id -- 借据号
    ,start_date -- 开始日期 起息日期
    ,end_date -- 到期日期
    ,settle_date -- 结清日期 贷款实际结清日期，结清前为空
    ,loan_amt -- 借据金额 （单位：元）
    ,periods -- 总期数
    ,cur_period -- 当前期数
    ,unclear_periods -- 未结清期数
    ,ovd_periods -- 逾期期次数
    ,ovd_days -- 逾期天数
    ,prin_bal -- 本金余额 （单位：元）
    ,loan_status -- 贷款状态 1-正常 2-逾期 3-结清 4-冲销
    ,norm_pri_bal -- 正常本金余额 （单位：元）
    ,ovd_pri_bal -- 逾期本金余额 （单位：元）
    ,norm_int_bal -- 正常利息余额 （单位：元）
    ,ovd_int_bal -- 逾期利息余额 （单位：元）
    ,pin_bal -- 罚息余额 （单位：元）
    ,cin_bal -- 复利余额 （单位：元）
    ,repay_way -- 还款方式 01--等额本息
    ,finance_type -- 资产类型 1-联合出资 2-机构全资
    ,asset_identification -- 资产标识
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    business_date -- 业务日期 D日
    ,loan_id -- 借据号
    ,start_date -- 开始日期 起息日期
    ,end_date -- 到期日期
    ,settle_date -- 结清日期 贷款实际结清日期，结清前为空
    ,loan_amt -- 借据金额 （单位：元）
    ,periods -- 总期数
    ,cur_period -- 当前期数
    ,unclear_periods -- 未结清期数
    ,ovd_periods -- 逾期期次数
    ,ovd_days -- 逾期天数
    ,prin_bal -- 本金余额 （单位：元）
    ,loan_status -- 贷款状态 1-正常 2-逾期 3-结清 4-冲销
    ,norm_pri_bal -- 正常本金余额 （单位：元）
    ,ovd_pri_bal -- 逾期本金余额 （单位：元）
    ,norm_int_bal -- 正常利息余额 （单位：元）
    ,ovd_int_bal -- 逾期利息余额 （单位：元）
    ,pin_bal -- 罚息余额 （单位：元）
    ,cin_bal -- 复利余额 （单位：元）
    ,repay_way -- 还款方式 01--等额本息
    ,finance_type -- 资产类型 1-联合出资 2-机构全资
    ,asset_identification -- 资产标识
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_temp_fm_loan
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_temp_fm_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_temp_fm_loan_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_temp_fm_loan to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_temp_fm_loan_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_temp_fm_loan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);