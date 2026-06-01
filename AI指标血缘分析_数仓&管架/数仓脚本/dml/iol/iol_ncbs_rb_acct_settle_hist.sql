/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_settle_hist
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
drop table ${iol_schema}.ncbs_rb_acct_settle_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_acct_settle_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_acct_settle_hist;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_acct_settle_hist_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_acct_settle_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_acct_settle_hist_ex(
    client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,acct_settle_operate_type -- 结算账户绑定操作类型
    ,company -- 法人
    ,seq_no -- 序号
    ,settle_acct_class -- 结算账户分类
    ,settle_bank_flag -- 资金转移账户银行标识
    ,settle_mobile_phone -- 绑定账户手机号码
    ,settle_no -- 结算编号
    ,last_charge_date -- 上一收费日期
    ,tran_timestamp -- 交易时间戳
    ,last_change_user_id -- 最后修改柜员
    ,old_settle_base_acct_no -- 原利息入账账号
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_internal_key -- 结算账户标志符
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_base_acct_no -- 结算账号
    ,settle_branch -- 清算机构
    ,settle_client -- 结算客户号
    ,settle_prod_type -- 结算账户产品类型
    ,bind_acct_branch -- 开户银行金融机构编码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,acct_settle_operate_type -- 结算账户绑定操作类型
    ,company -- 法人
    ,seq_no -- 序号
    ,settle_acct_class -- 结算账户分类
    ,settle_bank_flag -- 资金转移账户银行标识
    ,settle_mobile_phone -- 绑定账户手机号码
    ,settle_no -- 结算编号
    ,last_charge_date -- 上一收费日期
    ,tran_timestamp -- 交易时间戳
    ,last_change_user_id -- 最后修改柜员
    ,old_settle_base_acct_no -- 原利息入账账号
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_internal_key -- 结算账户标志符
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_base_acct_no -- 结算账号
    ,settle_branch -- 清算机构
    ,settle_client -- 结算客户号
    ,settle_prod_type -- 结算账户产品类型
    ,bind_acct_branch -- 开户银行金融机构编码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_acct_settle_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_acct_settle_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_settle_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_settle_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_acct_settle_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_settle_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);