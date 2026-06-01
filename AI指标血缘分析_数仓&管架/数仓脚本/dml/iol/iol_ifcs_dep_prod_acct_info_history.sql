/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_dep_prod_acct_info_history
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
drop table ${iol_schema}.ifcs_dep_prod_acct_info_history_ex purge;
alter table ${iol_schema}.ifcs_dep_prod_acct_info_history add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ifcs_dep_prod_acct_info_history;

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_dep_prod_acct_info_history_ex nologging
compress
as
select * from ${iol_schema}.ifcs_dep_prod_acct_info_history where 0=1;

insert /*+ append */ into ${iol_schema}.ifcs_dep_prod_acct_info_history_ex(
    part_id -- HASH分区ID
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,dep_acct_id -- 存款账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,ext_prod_id -- 外部产品代码
    ,dep_acct_status_cd -- 存款账户状态代码
    ,acpt_pay_status -- 收付标志
    ,froz_status -- 冻结状态
    ,stpay_status_cd -- 止付状态
    ,int_accr_flg -- 计息标志
    ,open_acct_dt -- 开户日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,bal -- 本金金额（余额）
    ,froz_amt -- 冻结金额
    ,stpaybl -- 止付金额
    ,acct_instit_id -- 账务机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_id -- 开户渠道编号
    ,open_acct_flow_num -- 开户流水号
    ,last_activ_acct_dt -- 上次动户日期
    ,exec_int_rat -- 执行利率
    ,base_rat -- 基准利率
    ,spread_val -- 浮动值（点差值）
    ,close_acct_dt -- 销户日期
    ,close_acct_flow_num -- 销户流水号
    ,pa_ext_cnt -- 部提次数
    ,dep_term_cd -- 存期代码
    ,ext_acct_dt -- 对接行的账务日期
    ,open_acct_ti -- 开户时间
    ,close_acct_ti -- 销户时间
    ,fee_dt -- 费用日期
    ,bind_acct_id -- 微众银行卡号
    ,dps_type_cd -- 储种
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    part_id -- HASH分区ID
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,dep_acct_id -- 存款账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,ext_prod_id -- 外部产品代码
    ,dep_acct_status_cd -- 存款账户状态代码
    ,acpt_pay_status -- 收付标志
    ,froz_status -- 冻结状态
    ,stpay_status_cd -- 止付状态
    ,int_accr_flg -- 计息标志
    ,open_acct_dt -- 开户日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,bal -- 本金金额（余额）
    ,froz_amt -- 冻结金额
    ,stpaybl -- 止付金额
    ,acct_instit_id -- 账务机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_id -- 开户渠道编号
    ,open_acct_flow_num -- 开户流水号
    ,last_activ_acct_dt -- 上次动户日期
    ,exec_int_rat -- 执行利率
    ,base_rat -- 基准利率
    ,spread_val -- 浮动值（点差值）
    ,close_acct_dt -- 销户日期
    ,close_acct_flow_num -- 销户流水号
    ,pa_ext_cnt -- 部提次数
    ,dep_term_cd -- 存期代码
    ,ext_acct_dt -- 对接行的账务日期
    ,open_acct_ti -- 开户时间
    ,close_acct_ti -- 销户时间
    ,fee_dt -- 费用日期
    ,bind_acct_id -- 微众银行卡号
    ,dps_type_cd -- 储种
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_dep_prod_acct_info_history
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_dep_prod_acct_info_history exchange partition p_${batch_date} with table ${iol_schema}.ifcs_dep_prod_acct_info_history_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_dep_prod_acct_info_history to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_dep_prod_acct_info_history_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_dep_prod_acct_info_history',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);