/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tda_hist
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
drop table ${iol_schema}.ncbs_rb_tda_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_tda_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_tda_hist;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_tda_hist_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_tda_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_tda_hist_ex(
    client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,add_term -- 续存期数
    ,addtl_principal -- 是否允许增加本金
    ,auto_renew_rollover -- 自动转存方式
    ,company -- 法人
    ,impound_type -- 扣划类型
    ,lost_no -- 挂失编号
    ,mat_notice_flag -- 是否到期通知
    ,movt_status -- 转存类型
    ,partial_renew_roll -- 是否部分本金转存
    ,prefix -- 前缀
    ,renew_no -- 本金转存次数
    ,rev_seq_no -- 冲正交易序号
    ,rollover_no -- 本息转存次数
    ,seq_no -- 序号
    ,seq_renew_rollover_no -- 转存序号
    ,tda_certificate_no -- 定期存单号
    ,tda_status -- 定期交易状态
    ,tran_scene -- 交易场景
    ,tran_seq_no -- 交易序号
    ,acct_movt_date -- 转存交易日期
    ,acct_open_date -- 账户开户日期
    ,maturity_date -- 到期日期
    ,tran_timestamp -- 交易时间戳
    ,acct_level_int_rate -- 账户基础利率
    ,debt_amt -- 支取金额
    ,debt_int_rate -- 支取利率
    ,dep_term_period -- 定期存期
    ,dep_term_type -- 定期账户存期类型
    ,gross_interest_amt -- 总利息金额
    ,int_adj -- 利息调增金额
    ,int_adj_ctd -- 计提日利息调整
    ,net_interest_amt -- 净利息
    ,notice_period -- 通知期限
    ,principal_amt -- 交易本金
    ,principal_amt_actual -- 实际本金金额
    ,spread_rate -- 浮动点数
    ,tax_amt -- 税金
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,add_term -- 续存期数
    ,addtl_principal -- 是否允许增加本金
    ,auto_renew_rollover -- 自动转存方式
    ,company -- 法人
    ,impound_type -- 扣划类型
    ,lost_no -- 挂失编号
    ,mat_notice_flag -- 是否到期通知
    ,movt_status -- 转存类型
    ,partial_renew_roll -- 是否部分本金转存
    ,prefix -- 前缀
    ,renew_no -- 本金转存次数
    ,rev_seq_no -- 冲正交易序号
    ,rollover_no -- 本息转存次数
    ,seq_no -- 序号
    ,seq_renew_rollover_no -- 转存序号
    ,tda_certificate_no -- 定期存单号
    ,tda_status -- 定期交易状态
    ,tran_scene -- 交易场景
    ,tran_seq_no -- 交易序号
    ,acct_movt_date -- 转存交易日期
    ,acct_open_date -- 账户开户日期
    ,maturity_date -- 到期日期
    ,tran_timestamp -- 交易时间戳
    ,acct_level_int_rate -- 账户基础利率
    ,debt_amt -- 支取金额
    ,debt_int_rate -- 支取利率
    ,dep_term_period -- 定期存期
    ,dep_term_type -- 定期账户存期类型
    ,gross_interest_amt -- 总利息金额
    ,int_adj -- 利息调增金额
    ,int_adj_ctd -- 计提日利息调整
    ,net_interest_amt -- 净利息
    ,notice_period -- 通知期限
    ,principal_amt -- 交易本金
    ,principal_amt_actual -- 实际本金金额
    ,spread_rate -- 浮动点数
    ,tax_amt -- 税金
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_tda_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_tda_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_tda_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_tda_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_tda_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_tda_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);