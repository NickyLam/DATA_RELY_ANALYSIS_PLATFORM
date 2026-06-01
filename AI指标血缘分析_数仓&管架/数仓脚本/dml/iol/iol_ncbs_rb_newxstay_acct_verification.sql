/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_newxstay_acct_verification
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
drop table ${iol_schema}.ncbs_rb_newxstay_acct_verification_ex purge;
alter table ${iol_schema}.ncbs_rb_newxstay_acct_verification add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_newxstay_acct_verification;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_newxstay_acct_verification_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_newxstay_acct_verification where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_newxstay_acct_verification_ex(
    acct_name -- 账户名称
    ,acct_status -- 账户状态
    ,acct_type -- 账户类型
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,client_no -- 客户编号
    ,client_type -- 客户类型
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,acct_verification -- 账户核实情况
    ,company -- 法人
    ,verification_flag -- 核实标志
    ,tran_timestamp -- 交易时间戳
    ,verification_date -- 核实日期
    ,acct_ccy -- 账户币种
    ,home_branch -- 客户管理行
    ,tran_branch -- 核心交易机构编号
    ,verification_user_id -- 核实柜员
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_name -- 账户名称
    ,acct_status -- 账户状态
    ,acct_type -- 账户类型
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,client_no -- 客户编号
    ,client_type -- 客户类型
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,acct_verification -- 账户核实情况
    ,company -- 法人
    ,verification_flag -- 核实标志
    ,tran_timestamp -- 交易时间戳
    ,verification_date -- 核实日期
    ,acct_ccy -- 账户币种
    ,home_branch -- 客户管理行
    ,tran_branch -- 核心交易机构编号
    ,verification_user_id -- 核实柜员
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_newxstay_acct_verification
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_newxstay_acct_verification exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_newxstay_acct_verification_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_newxstay_acct_verification to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_newxstay_acct_verification_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_newxstay_acct_verification',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);