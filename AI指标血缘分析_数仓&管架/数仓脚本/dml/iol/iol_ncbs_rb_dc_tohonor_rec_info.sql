/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_tohonor_rec_info
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
drop table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info_ex purge;
alter table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_tohonor_rec_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_dc_tohonor_rec_info_ex(
    acct_name -- 账户名称
    ,acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,batch_online -- 批处理或在线更新
    ,company -- 法人
    ,deal_type -- 处理类型
    ,seq_no -- 序号
    ,stage_code -- 期次代码
    ,stage_prod_class -- 期次产品分类
    ,tohonor_result -- 兑付/赎回结果
    ,acct_open_date -- 账户开户日期
    ,maturity_date -- 到期日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,failure_reason -- 失败原因
    ,int_amt -- 利息金额
    ,pri_amt -- 本金金额
    ,priint_acct_name -- 利息入账账户名称
    ,priint_acct_seq_no -- 本息入账账户序列号
    ,priint_base_acct_no -- 本息入账账号
    ,priint_ccy -- 本息入账账户币种
    ,priint_internal_key -- 本息入账账户标识符
    ,priint_prod_type -- 本息入账账户产品类型
    ,tohonor_rec_amt -- 兑付赎回金额
    ,tran_branch -- 核心交易机构编号
    ,year_rate -- 年利率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_name -- 账户名称
    ,acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,batch_online -- 批处理或在线更新
    ,company -- 法人
    ,deal_type -- 处理类型
    ,seq_no -- 序号
    ,stage_code -- 期次代码
    ,stage_prod_class -- 期次产品分类
    ,tohonor_result -- 兑付/赎回结果
    ,acct_open_date -- 账户开户日期
    ,maturity_date -- 到期日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,failure_reason -- 失败原因
    ,int_amt -- 利息金额
    ,pri_amt -- 本金金额
    ,priint_acct_name -- 利息入账账户名称
    ,priint_acct_seq_no -- 本息入账账户序列号
    ,priint_base_acct_no -- 本息入账账号
    ,priint_ccy -- 本息入账账户币种
    ,priint_internal_key -- 本息入账账户标识符
    ,priint_prod_type -- 本息入账账户产品类型
    ,tohonor_rec_amt -- 兑付赎回金额
    ,tran_branch -- 核心交易机构编号
    ,year_rate -- 年利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_dc_tohonor_rec_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_tohonor_rec_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_tohonor_rec_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);