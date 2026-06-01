/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_view_new_business_volume
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
drop table ${iol_schema}.bdms_view_new_business_volume_ex purge;
alter table ${iol_schema}.bdms_view_new_business_volume add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdms_view_new_business_volume;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_view_new_business_volume_ex nologging
compress
as
select * from ${iol_schema}.bdms_view_new_business_volume where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_view_new_business_volume_ex(
    txn_dt -- 交易日期
    ,txn_tm -- 交易时间
    ,blng_org_id -- 所属机构编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_teller_name -- 经办柜员名称
    ,auth_teller_id -- 授权柜员编号
    ,auth_teller_name -- 授权柜员名称
    ,txn_num -- 交易码
    ,txn_desc -- 交易描述
    ,biz_sys_evt_id -- 业务系统流水号
    ,bcs_evt_id -- 核心系统流水号
    ,data_src_cd -- 系统代码
    ,pay_agt_id -- 付款账户
    ,rcv_agt_id -- 收款账户
    ,txn_amt -- 交易金额
    ,etl_dt_ora -- 数据日期
    ,menuid -- 柜面菜单码
    ,eft_flag -- 金融交易类型
    ,serv_flag -- 业务交易类型
    ,acct_flag -- 账户交易类型
    ,ca_flag -- 现金交易类型
    ,bd_flag -- 存取款交易类型
    ,start_tm -- 交易开始时间
    ,end_tm -- 交易结束时间
    ,role_name -- 经办柜员岗位
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    txn_dt -- 交易日期
    ,txn_tm -- 交易时间
    ,blng_org_id -- 所属机构编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_teller_name -- 经办柜员名称
    ,auth_teller_id -- 授权柜员编号
    ,auth_teller_name -- 授权柜员名称
    ,txn_num -- 交易码
    ,txn_desc -- 交易描述
    ,biz_sys_evt_id -- 业务系统流水号
    ,bcs_evt_id -- 核心系统流水号
    ,data_src_cd -- 系统代码
    ,pay_agt_id -- 付款账户
    ,rcv_agt_id -- 收款账户
    ,txn_amt -- 交易金额
    ,etl_dt_ora -- 数据日期
    ,menuid -- 柜面菜单码
    ,eft_flag -- 金融交易类型
    ,serv_flag -- 业务交易类型
    ,acct_flag -- 账户交易类型
    ,ca_flag -- 现金交易类型
    ,bd_flag -- 存取款交易类型
    ,start_tm -- 交易开始时间
    ,end_tm -- 交易结束时间
    ,role_name -- 经办柜员岗位
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_view_new_business_volume
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_view_new_business_volume exchange partition p_${batch_date} with table ${iol_schema}.bdms_view_new_business_volume_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_view_new_business_volume to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_view_new_business_volume_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_view_new_business_volume',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);