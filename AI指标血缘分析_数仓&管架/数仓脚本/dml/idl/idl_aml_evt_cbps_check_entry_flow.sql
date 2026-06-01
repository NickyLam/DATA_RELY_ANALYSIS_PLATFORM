/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_evt_cbps_check_entry_flow
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_evt_cbps_check_entry_flow drop partition p_${last_date};
alter table ${idl_schema}.aml_evt_cbps_check_entry_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_evt_cbps_check_entry_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_evt_cbps_check_entry_flow (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,sys_id  -- 系统编号
    ,midgrod_flow_num  -- 中台流水号
    ,midgrod_tran_dt  -- 中台交易日期
    ,midgrod_tran_tm  -- 中台交易时间
    ,msg_type_id  -- 报文类型编号
    ,core_tran_code  -- 核心交易码
    ,midgrod_tran_code  -- 中台交易码
    ,mgmt_org_id  -- 管理机构编号
    ,tran_org_id  -- 交易机构编号
    ,teller_id  -- 柜员编号
    ,tran_type_cd  -- 交易类型代码
    ,tran_status_cd  -- 交易状态代码
    ,core_tran_dt  -- 核心交易日期
    ,core_tran_flow_num  -- 核心交易流水号
    ,payer_acct_num  -- 付款人账号
    ,payer_name  -- 付款人名称
    ,recver_acct_num  -- 收款人账号
    ,recver_name  -- 收款人名称
    ,pay_flow_num  -- 支付流水号
    ,init_pay_flow_num  -- 原支付流水号
    ,return_cd  -- 返回代码
    ,return_info_desc  -- 返回信息描述
    ,tran_amt  -- 交易金额
    ,entry_code  -- 记账分录编码
    ,check_entry_dt  -- 对账日期
    ,check_entry_status_cd  -- 对账状态代码
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.sys_id,chr(13),''),chr(10),'')  -- 系统编号
    ,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'')  -- 中台流水号
    ,t1.midgrod_tran_dt  -- 中台交易日期
    ,t1.midgrod_tran_tm  -- 中台交易时间
    ,replace(replace(t1.msg_type_id,chr(13),''),chr(10),'')  -- 报文类型编号
    ,replace(replace(t1.core_tran_code,chr(13),''),chr(10),'')  -- 核心交易码
    ,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'')  -- 中台交易码
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易机构编号
    ,replace(replace(t1.teller_id,chr(13),''),chr(10),'')  -- 柜员编号
    ,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'')  -- 交易类型代码
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,t1.core_tran_dt  -- 核心交易日期
    ,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'')  -- 核心交易流水号
    ,replace(replace(t1.payer_acct_num,chr(13),''),chr(10),'')  -- 付款人账号
    ,replace(replace(t1.payer_name,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.pay_flow_num,chr(13),''),chr(10),'')  -- 支付流水号
    ,replace(replace(t1.init_pay_flow_num,chr(13),''),chr(10),'')  -- 原支付流水号
    ,replace(replace(t1.return_cd,chr(13),''),chr(10),'')  -- 返回代码
    ,replace(replace(t1.return_info_desc,chr(13),''),chr(10),'')  -- 返回信息描述
    ,t1.tran_amt  -- 交易金额
    ,replace(replace(t1.entry_code,chr(13),''),chr(10),'')  -- 记账分录编码
    ,t1.check_entry_dt  -- 对账日期
    ,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'')  -- 对账状态代码
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_cbps_check_entry_flow t1    --城银清算对账流水
where t1.midgrod_tran_dt >= to_date('${batch_date}','yyyymmdd') - 14 and t1.midgrod_tran_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_evt_cbps_check_entry_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);