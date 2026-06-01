/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_int_rate_form_hist
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
drop table ${iol_schema}.ncbs_rb_int_rate_form_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_int_rate_form_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_int_rate_form_hist;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_int_rate_form_hist_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_int_rate_form_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_int_rate_form_hist_ex(
    base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,reason -- 原因
    ,company -- 法人
    ,om_hist_version_id -- 历史版本号
    ,last_change_date -- 最后修改日期
    ,tran_timestamp -- 交易时间戳
    ,valid_from_date -- 有效期起始日期
    ,valid_thru_date -- 有效期截止日期
    ,disc_base_rate -- 基准利率1
    ,float_point -- 浮动点差
    ,real_rate -- 执行利率
    ,int_rate_term -- 利率协议期限
    ,add_agreement_flag -- 新增协议标志
    ,pre_int_rate_form_no -- 原审批单号
    ,auth_client_flag -- 是否为我行授信客户
    ,pri_amt_limit -- 申请本金金额上限
    ,int_valid_from_date -- 利率优惠有效期起始日期
    ,int_valid_thru_date -- 利率优惠有效期截止日期
    ,int_agreement_status -- 利率协议状态
    ,int_rate_form_apply_type -- 利率审批申请类别
    ,auth_client_payment -- 授信客户的综合收益请款
    ,new_acct_no_flag -- 是否为新账号
    ,rb_prod_term -- 存款期限
    ,int_rate_rb_prod_type -- 利率审批单存款品种
    ,int_rate_form_no -- 利率审批单单号
    ,internal_key -- 账户内部键值
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,reason -- 原因
    ,company -- 法人
    ,om_hist_version_id -- 历史版本号
    ,last_change_date -- 最后修改日期
    ,tran_timestamp -- 交易时间戳
    ,valid_from_date -- 有效期起始日期
    ,valid_thru_date -- 有效期截止日期
    ,disc_base_rate -- 基准利率1
    ,float_point -- 浮动点差
    ,real_rate -- 执行利率
    ,int_rate_term -- 利率协议期限
    ,add_agreement_flag -- 新增协议标志
    ,pre_int_rate_form_no -- 原审批单号
    ,auth_client_flag -- 是否为我行授信客户
    ,pri_amt_limit -- 申请本金金额上限
    ,int_valid_from_date -- 利率优惠有效期起始日期
    ,int_valid_thru_date -- 利率优惠有效期截止日期
    ,int_agreement_status -- 利率协议状态
    ,int_rate_form_apply_type -- 利率审批申请类别
    ,auth_client_payment -- 授信客户的综合收益请款
    ,new_acct_no_flag -- 是否为新账号
    ,rb_prod_term -- 存款期限
    ,int_rate_rb_prod_type -- 利率审批单存款品种
    ,int_rate_form_no -- 利率审批单单号
    ,internal_key -- 账户内部键值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_int_rate_form_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_int_rate_form_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_int_rate_form_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_int_rate_form_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_int_rate_form_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_int_rate_form_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);