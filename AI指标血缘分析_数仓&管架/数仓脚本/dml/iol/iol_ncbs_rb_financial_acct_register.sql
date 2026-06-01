/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_financial_acct_register
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_financial_acct_register_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_financial_acct_register
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_financial_acct_register_op purge;
drop table ${iol_schema}.ncbs_rb_financial_acct_register_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_financial_acct_register_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_financial_acct_register where 0=1;

create table ${iol_schema}.ncbs_rb_financial_acct_register_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_financial_acct_register where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_financial_acct_register_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,agg -- 积数
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,agreement_id -- 协议编号
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,individual_flag -- 对公对私标志
            ,int_accrued_diff -- 计提金额差额
            ,int_appl_type -- 利率启用方式
            ,int_calc_bal -- 计息方式
            ,int_ind_flag -- 是否计息
            ,month_basis -- 月基准
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,acct_close_date -- 销户日期
            ,acct_open_date -- 账户开户日期
            ,last_accrual_date -- 上一利息计提日
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,maturity_date -- 到期日期
            ,next_accr_date -- 下一计提日期
            ,next_cycle_date -- 下一结息日
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,parent_internal_key -- 上级账户标识符
            ,real_rate -- 执行利率
            ,total_amount -- 汇总金额
            ,total_amount_prev -- 上日总金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_financial_acct_register_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,agg -- 积数
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,agreement_id -- 协议编号
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,individual_flag -- 对公对私标志
            ,int_accrued_diff -- 计提金额差额
            ,int_appl_type -- 利率启用方式
            ,int_calc_bal -- 计息方式
            ,int_ind_flag -- 是否计息
            ,month_basis -- 月基准
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,acct_close_date -- 销户日期
            ,acct_open_date -- 账户开户日期
            ,last_accrual_date -- 上一利息计提日
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,maturity_date -- 到期日期
            ,next_accr_date -- 下一计提日期
            ,next_cycle_date -- 下一结息日
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,parent_internal_key -- 上级账户标识符
            ,real_rate -- 执行利率
            ,total_amount -- 汇总金额
            ,total_amount_prev -- 上日总金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.agg, o.agg) as agg -- 积数
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.acct_desc, o.acct_desc) as acct_desc -- 账户描述
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_type, o.agreement_type) as agreement_type -- 协议类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.individual_flag, o.individual_flag) as individual_flag -- 对公对私标志
    ,nvl(n.int_accrued_diff, o.int_accrued_diff) as int_accrued_diff -- 计提金额差额
    ,nvl(n.int_appl_type, o.int_appl_type) as int_appl_type -- 利率启用方式
    ,nvl(n.int_calc_bal, o.int_calc_bal) as int_calc_bal -- 计息方式
    ,nvl(n.int_ind_flag, o.int_ind_flag) as int_ind_flag -- 是否计息
    ,nvl(n.month_basis, o.month_basis) as month_basis -- 月基准
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.acct_close_date, o.acct_close_date) as acct_close_date -- 销户日期
    ,nvl(n.acct_open_date, o.acct_open_date) as acct_open_date -- 账户开户日期
    ,nvl(n.last_accrual_date, o.last_accrual_date) as last_accrual_date -- 上一利息计提日
    ,nvl(n.last_bal_upd_date, o.last_bal_upd_date) as last_bal_upd_date -- 上次动户日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_cycle_date, o.last_cycle_date) as last_cycle_date -- 上一结息日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.next_accr_date, o.next_accr_date) as next_accr_date -- 下一计提日期
    ,nvl(n.next_cycle_date, o.next_cycle_date) as next_cycle_date -- 下一结息日
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.int_accrued, o.int_accrued) as int_accrued -- 累计计提
    ,nvl(n.int_accrued_calc_ctd, o.int_accrued_calc_ctd) as int_accrued_calc_ctd -- 计提日计提实际金额
    ,nvl(n.int_accrued_ctd, o.int_accrued_ctd) as int_accrued_ctd -- 计提日计提利息
    ,nvl(n.int_accrued_prev, o.int_accrued_prev) as int_accrued_prev -- 上日累计计提利息
    ,nvl(n.int_adj, o.int_adj) as int_adj -- 利息调增金额
    ,nvl(n.int_adj_ctd, o.int_adj_ctd) as int_adj_ctd -- 计提日利息调整
    ,nvl(n.int_adj_prev, o.int_adj_prev) as int_adj_prev -- 上日利息调整(累计)
    ,nvl(n.int_posted, o.int_posted) as int_posted -- 结息金额
    ,nvl(n.int_posted_ctd, o.int_posted_ctd) as int_posted_ctd -- 结息日利息金额
    ,nvl(n.parent_internal_key, o.parent_internal_key) as parent_internal_key -- 上级账户标识符
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.total_amount, o.total_amount) as total_amount -- 汇总金额
    ,nvl(n.total_amount_prev, o.total_amount_prev) as total_amount_prev -- 上日总金额
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_financial_acct_register_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_financial_acct_register where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.acct_status <> n.acct_status
        or o.agg <> n.agg
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.int_type <> n.int_type
        or o.prod_type <> n.prod_type
        or o.profit_center <> n.profit_center
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.acct_desc <> n.acct_desc
        or o.acct_exec <> n.acct_exec
        or o.agreement_id <> n.agreement_id
        or o.agreement_type <> n.agreement_type
        or o.company <> n.company
        or o.individual_flag <> n.individual_flag
        or o.int_accrued_diff <> n.int_accrued_diff
        or o.int_appl_type <> n.int_appl_type
        or o.int_calc_bal <> n.int_calc_bal
        or o.int_ind_flag <> n.int_ind_flag
        or o.month_basis <> n.month_basis
        or o.year_basis <> n.year_basis
        or o.int_class <> n.int_class
        or o.acct_close_date <> n.acct_close_date
        or o.acct_open_date <> n.acct_open_date
        or o.last_accrual_date <> n.last_accrual_date
        or o.last_bal_upd_date <> n.last_bal_upd_date
        or o.last_change_date <> n.last_change_date
        or o.last_cycle_date <> n.last_cycle_date
        or o.maturity_date <> n.maturity_date
        or o.next_accr_date <> n.next_accr_date
        or o.next_cycle_date <> n.next_cycle_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.int_accrued <> n.int_accrued
        or o.int_accrued_calc_ctd <> n.int_accrued_calc_ctd
        or o.int_accrued_ctd <> n.int_accrued_ctd
        or o.int_accrued_prev <> n.int_accrued_prev
        or o.int_adj <> n.int_adj
        or o.int_adj_ctd <> n.int_adj_ctd
        or o.int_adj_prev <> n.int_adj_prev
        or o.int_posted <> n.int_posted
        or o.int_posted_ctd <> n.int_posted_ctd
        or o.parent_internal_key <> n.parent_internal_key
        or o.real_rate <> n.real_rate
        or o.total_amount <> n.total_amount
        or o.total_amount_prev <> n.total_amount_prev
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_financial_acct_register_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,agg -- 积数
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,agreement_id -- 协议编号
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,individual_flag -- 对公对私标志
            ,int_accrued_diff -- 计提金额差额
            ,int_appl_type -- 利率启用方式
            ,int_calc_bal -- 计息方式
            ,int_ind_flag -- 是否计息
            ,month_basis -- 月基准
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,acct_close_date -- 销户日期
            ,acct_open_date -- 账户开户日期
            ,last_accrual_date -- 上一利息计提日
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,maturity_date -- 到期日期
            ,next_accr_date -- 下一计提日期
            ,next_cycle_date -- 下一结息日
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,parent_internal_key -- 上级账户标识符
            ,real_rate -- 执行利率
            ,total_amount -- 汇总金额
            ,total_amount_prev -- 上日总金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_financial_acct_register_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,agg -- 积数
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,agreement_id -- 协议编号
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,individual_flag -- 对公对私标志
            ,int_accrued_diff -- 计提金额差额
            ,int_appl_type -- 利率启用方式
            ,int_calc_bal -- 计息方式
            ,int_ind_flag -- 是否计息
            ,month_basis -- 月基准
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,acct_close_date -- 销户日期
            ,acct_open_date -- 账户开户日期
            ,last_accrual_date -- 上一利息计提日
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,last_cycle_date -- 上一结息日
            ,maturity_date -- 到期日期
            ,next_accr_date -- 下一计提日期
            ,next_cycle_date -- 下一结息日
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_ctd -- 计提日计提利息
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_ctd -- 计提日利息调整
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,parent_internal_key -- 上级账户标识符
            ,real_rate -- 执行利率
            ,total_amount -- 汇总金额
            ,total_amount_prev -- 上日总金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.acct_status -- 账户状态
    ,o.agg -- 积数
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.int_type -- 利率类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.profit_center -- 利润中心
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.acct_desc -- 账户描述
    ,o.acct_exec -- 银行客户经理编号
    ,o.agreement_id -- 协议编号
    ,o.agreement_type -- 协议类型
    ,o.company -- 法人
    ,o.individual_flag -- 对公对私标志
    ,o.int_accrued_diff -- 计提金额差额
    ,o.int_appl_type -- 利率启用方式
    ,o.int_calc_bal -- 计息方式
    ,o.int_ind_flag -- 是否计息
    ,o.month_basis -- 月基准
    ,o.year_basis -- 年基准天数
    ,o.int_class -- 利息分类
    ,o.acct_close_date -- 销户日期
    ,o.acct_open_date -- 账户开户日期
    ,o.last_accrual_date -- 上一利息计提日
    ,o.last_bal_upd_date -- 上次动户日期
    ,o.last_change_date -- 最后修改日期
    ,o.last_cycle_date -- 上一结息日
    ,o.maturity_date -- 到期日期
    ,o.next_accr_date -- 下一计提日期
    ,o.next_cycle_date -- 下一结息日
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.int_accrued -- 累计计提
    ,o.int_accrued_calc_ctd -- 计提日计提实际金额
    ,o.int_accrued_ctd -- 计提日计提利息
    ,o.int_accrued_prev -- 上日累计计提利息
    ,o.int_adj -- 利息调增金额
    ,o.int_adj_ctd -- 计提日利息调整
    ,o.int_adj_prev -- 上日利息调整(累计)
    ,o.int_posted -- 结息金额
    ,o.int_posted_ctd -- 结息日利息金额
    ,o.parent_internal_key -- 上级账户标识符
    ,o.real_rate -- 执行利率
    ,o.total_amount -- 汇总金额
    ,o.total_amount_prev -- 上日总金额
    ,o.tran_branch -- 核心交易机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_financial_acct_register_bk o
    left join ${iol_schema}.ncbs_rb_financial_acct_register_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_financial_acct_register_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_financial_acct_register;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_financial_acct_register') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_financial_acct_register drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_financial_acct_register add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_financial_acct_register exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_financial_acct_register_cl;
alter table ${iol_schema}.ncbs_rb_financial_acct_register exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_financial_acct_register_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_financial_acct_register to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_financial_acct_register_op purge;
drop table ${iol_schema}.ncbs_rb_financial_acct_register_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_financial_acct_register_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_financial_acct_register',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
