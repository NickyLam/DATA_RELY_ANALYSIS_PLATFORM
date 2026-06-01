/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_bookkeeping_obj_his
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
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his_ex purge;
alter table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_bookkeeping_obj_his where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_bookkeeping_obj_his_ex(
    tsk_id -- 任务Id
    ,beg_date -- 开始日期
    ,end_date -- 结束日期
    ,subj_org_id -- 机构码
    ,subj_code -- 科目码
    ,subj_sub_code -- 科目子码
    ,inner_acct_sn -- 内部账序号
    ,core_acct_code -- 核心账号
    ,currency -- 币种
    ,debit_value -- 借方余额
    ,credit_value -- 贷方余额
    ,pay_value -- 付款余额
    ,receive_value -- 收款余额
    ,secu_acct_id -- 券账户
    ,cash_acct_id -- 资金账户
    ,update_time -- 更新时间
    ,core_acct_name -- 核心账号名称
    ,t_currency -- 折算币种
    ,t_credit_value -- 折算后贷方余额
    ,t_debit_value -- 折算后借方余额
    ,ext_i_code -- 金融工具代码
    ,ext_a_type -- 金融工具资产类型
    ,ext_m_type -- 金融工具市场类型
    ,ext_dim1 -- 扩展维度1
    ,ext_dim2 -- 扩展维度2
    ,ext_dim3 -- 扩展维度3
    ,ext_dim4 -- 扩展维度4
    ,ext_dim5 -- 扩展维度5
    ,ext_dim6 -- 扩展维度6
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tsk_id -- 任务Id
    ,beg_date -- 开始日期
    ,end_date -- 结束日期
    ,subj_org_id -- 机构码
    ,subj_code -- 科目码
    ,subj_sub_code -- 科目子码
    ,inner_acct_sn -- 内部账序号
    ,core_acct_code -- 核心账号
    ,currency -- 币种
    ,debit_value -- 借方余额
    ,credit_value -- 贷方余额
    ,pay_value -- 付款余额
    ,receive_value -- 收款余额
    ,secu_acct_id -- 券账户
    ,cash_acct_id -- 资金账户
    ,update_time -- 更新时间
    ,core_acct_name -- 核心账号名称
    ,t_currency -- 折算币种
    ,t_credit_value -- 折算后贷方余额
    ,t_debit_value -- 折算后借方余额
    ,ext_i_code -- 金融工具代码
    ,ext_a_type -- 金融工具资产类型
    ,ext_m_type -- 金融工具市场类型
    ,ext_dim1 -- 扩展维度1
    ,ext_dim2 -- 扩展维度2
    ,ext_dim3 -- 扩展维度3
    ,ext_dim4 -- 扩展维度4
    ,ext_dim5 -- 扩展维度5
    ,ext_dim6 -- 扩展维度6
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_bookkeeping_obj_his
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_his to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_bookkeeping_obj_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);