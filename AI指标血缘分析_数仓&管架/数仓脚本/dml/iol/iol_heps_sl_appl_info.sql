/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_heps_sl_appl_info
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
drop table ${iol_schema}.heps_sl_appl_info_ex purge;
alter table ${iol_schema}.heps_sl_appl_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.heps_sl_appl_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.heps_sl_appl_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.heps_sl_appl_info where 0=1;

insert /*+ append */ into ${iol_schema}.heps_sl_appl_info_ex(
    flow_no -- 业务流水号
    ,sl_house_nature -- 赎楼对应房产性质
    ,sl_house_name -- 赎楼对应房产名称
    ,is_gage_sts -- 赎楼对应房产抵押状态
    ,house_gage_owner -- 赎楼对应房产抵押权人
    ,o_loan_bk -- 原贷款银行
    ,o_loan_spls_cptl -- 原贷款剩余本金
    ,next_bk_reply_amt -- 下一手银行批复金额
    ,sl_type -- 赎楼类型
    ,transaction_amt -- 交易价格
    ,price_amt -- 定价金额
    ,capital_super_amt -- 资金监管金额
    ,cus_source -- 客户来源
    ,guar_com_id -- 担保公司编号
    ,create_time -- 创建时间
    ,update_time -- 更细时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    flow_no -- 业务流水号
    ,sl_house_nature -- 赎楼对应房产性质
    ,sl_house_name -- 赎楼对应房产名称
    ,is_gage_sts -- 赎楼对应房产抵押状态
    ,house_gage_owner -- 赎楼对应房产抵押权人
    ,o_loan_bk -- 原贷款银行
    ,o_loan_spls_cptl -- 原贷款剩余本金
    ,next_bk_reply_amt -- 下一手银行批复金额
    ,sl_type -- 赎楼类型
    ,transaction_amt -- 交易价格
    ,price_amt -- 定价金额
    ,capital_super_amt -- 资金监管金额
    ,cus_source -- 客户来源
    ,guar_com_id -- 担保公司编号
    ,create_time -- 创建时间
    ,update_time -- 更细时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.heps_sl_appl_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.heps_sl_appl_info exchange partition p_${batch_date} with table ${iol_schema}.heps_sl_appl_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.heps_sl_appl_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.heps_sl_appl_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'heps_sl_appl_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);