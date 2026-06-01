/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_sweep
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
create table ${iol_schema}.ncbs_rb_agreement_sweep_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_sweep
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_sweep_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_sweep_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_sweep_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_sweep where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_sweep_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_sweep where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_sweep_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,con_transfer_count -- 持续划款次数
            ,narrative -- 摘要
            ,oth_acct_desc -- 对方账户描述
            ,oth_acct_sort -- 转入方账户类型
            ,priority -- 优先级
            ,renew_method -- 转存方式
            ,renew_multiple -- 转账倍数
            ,renew_type -- 约定转存方式
            ,sched_no -- 计划编号
            ,seq_no -- 序号
            ,sum_con_count -- 累计追踪次数
            ,sum_count -- 累计转账次数
            ,lowest_amt -- 保底金额
            ,end_date -- 结束日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,bal_ratio -- 余额比例
            ,limit_amt_out_day -- 出账日累计限额
            ,month_limit -- 本月累计限额
            ,oth_acct_ccy -- 对方账户币种
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_bank_code -- 对方银行代码
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,priint_acct_seq_no -- 本息入账账户序列号
            ,priint_base_acct_no -- 本息入账账号
            ,priint_ccy -- 本息入账账户币种
            ,priint_prod_type -- 本息入账账户产品类型
            ,renew_min_amt -- 最低转存金额
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_base_acct_no -- 结算账号
            ,settle_prod_type -- 结算账户产品类型
            ,sum_amt -- 累计转账金额
            ,tran_base_amt -- 转账基数
            ,tran_amt -- 交易金额
            ,renew_acct_type -- 转存账户类型
            ,fin_fixed_amt -- 理财固定金额
            ,open_num_type -- 开立笔数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_sweep_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,con_transfer_count -- 持续划款次数
            ,narrative -- 摘要
            ,oth_acct_desc -- 对方账户描述
            ,oth_acct_sort -- 转入方账户类型
            ,priority -- 优先级
            ,renew_method -- 转存方式
            ,renew_multiple -- 转账倍数
            ,renew_type -- 约定转存方式
            ,sched_no -- 计划编号
            ,seq_no -- 序号
            ,sum_con_count -- 累计追踪次数
            ,sum_count -- 累计转账次数
            ,lowest_amt -- 保底金额
            ,end_date -- 结束日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,bal_ratio -- 余额比例
            ,limit_amt_out_day -- 出账日累计限额
            ,month_limit -- 本月累计限额
            ,oth_acct_ccy -- 对方账户币种
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_bank_code -- 对方银行代码
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,priint_acct_seq_no -- 本息入账账户序列号
            ,priint_base_acct_no -- 本息入账账号
            ,priint_ccy -- 本息入账账户币种
            ,priint_prod_type -- 本息入账账户产品类型
            ,renew_min_amt -- 最低转存金额
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_base_acct_no -- 结算账号
            ,settle_prod_type -- 结算账户产品类型
            ,sum_amt -- 累计转账金额
            ,tran_base_amt -- 转账基数
            ,tran_amt -- 交易金额
            ,renew_acct_type -- 转存账户类型
            ,fin_fixed_amt -- 理财固定金额
            ,open_num_type -- 开立笔数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reason_code, o.reason_code) as reason_code -- 账户用途
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.agreement_type, o.agreement_type) as agreement_type -- 协议类型
    ,nvl(n.auto_settle_flag, o.auto_settle_flag) as auto_settle_flag -- 自动结清标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.con_transfer_count, o.con_transfer_count) as con_transfer_count -- 持续划款次数
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.oth_acct_desc, o.oth_acct_desc) as oth_acct_desc -- 对方账户描述
    ,nvl(n.oth_acct_sort, o.oth_acct_sort) as oth_acct_sort -- 转入方账户类型
    ,nvl(n.priority, o.priority) as priority -- 优先级
    ,nvl(n.renew_method, o.renew_method) as renew_method -- 转存方式
    ,nvl(n.renew_multiple, o.renew_multiple) as renew_multiple -- 转账倍数
    ,nvl(n.renew_type, o.renew_type) as renew_type -- 约定转存方式
    ,nvl(n.sched_no, o.sched_no) as sched_no -- 计划编号
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.sum_con_count, o.sum_con_count) as sum_con_count -- 累计追踪次数
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 累计转账次数
    ,nvl(n.lowest_amt, o.lowest_amt) as lowest_amt -- 保底金额
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签约日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.acct_fixed_rate, o.acct_fixed_rate) as acct_fixed_rate -- 分户级固定利率
    ,nvl(n.acct_percent_rate, o.acct_percent_rate) as acct_percent_rate -- 分户级利率浮动百分比
    ,nvl(n.acct_spread_rate, o.acct_spread_rate) as acct_spread_rate -- 分户级利率浮动百分点
    ,nvl(n.bal_ratio, o.bal_ratio) as bal_ratio -- 余额比例
    ,nvl(n.limit_amt_out_day, o.limit_amt_out_day) as limit_amt_out_day -- 出账日累计限额
    ,nvl(n.month_limit, o.month_limit) as month_limit -- 本月累计限额
    ,nvl(n.oth_acct_ccy, o.oth_acct_ccy) as oth_acct_ccy -- 对方账户币种
    ,nvl(n.oth_acct_seq_no, o.oth_acct_seq_no) as oth_acct_seq_no -- 对方账户序列号
    ,nvl(n.oth_bank_code, o.oth_bank_code) as oth_bank_code -- 对方银行代码
    ,nvl(n.oth_base_acct_no, o.oth_base_acct_no) as oth_base_acct_no -- 对方账号/卡号
    ,nvl(n.oth_internal_key, o.oth_internal_key) as oth_internal_key -- 对手账户内部键
    ,nvl(n.oth_prod_type, o.oth_prod_type) as oth_prod_type -- 对方账户产品类型
    ,nvl(n.priint_acct_seq_no, o.priint_acct_seq_no) as priint_acct_seq_no -- 本息入账账户序列号
    ,nvl(n.priint_base_acct_no, o.priint_base_acct_no) as priint_base_acct_no -- 本息入账账号
    ,nvl(n.priint_ccy, o.priint_ccy) as priint_ccy -- 本息入账账户币种
    ,nvl(n.priint_prod_type, o.priint_prod_type) as priint_prod_type -- 本息入账账户产品类型
    ,nvl(n.renew_min_amt, o.renew_min_amt) as renew_min_amt -- 最低转存金额
    ,nvl(n.settle_acct_ccy, o.settle_acct_ccy) as settle_acct_ccy -- 结算账户币种
    ,nvl(n.settle_acct_seq_no, o.settle_acct_seq_no) as settle_acct_seq_no -- 结算账户序号
    ,nvl(n.settle_base_acct_no, o.settle_base_acct_no) as settle_base_acct_no -- 结算账号
    ,nvl(n.settle_prod_type, o.settle_prod_type) as settle_prod_type -- 结算账户产品类型
    ,nvl(n.sum_amt, o.sum_amt) as sum_amt -- 累计转账金额
    ,nvl(n.tran_base_amt, o.tran_base_amt) as tran_base_amt -- 转账基数
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.renew_acct_type, o.renew_acct_type) as renew_acct_type -- 转存账户类型
    ,nvl(n.fin_fixed_amt, o.fin_fixed_amt) as fin_fixed_amt -- 理财固定金额
    ,nvl(n.open_num_type, o.open_num_type) as open_num_type -- 开立笔数类型
    ,case when
            n.agreement_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_agreement_sweep_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_sweep where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
where (
        o.agreement_id is null
    )
    or (
        n.agreement_id is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.reason_code <> n.reason_code
        or o.user_id <> n.user_id
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.agreement_status <> n.agreement_status
        or o.agreement_type <> n.agreement_type
        or o.auto_settle_flag <> n.auto_settle_flag
        or o.company <> n.company
        or o.con_transfer_count <> n.con_transfer_count
        or o.narrative <> n.narrative
        or o.oth_acct_desc <> n.oth_acct_desc
        or o.oth_acct_sort <> n.oth_acct_sort
        or o.priority <> n.priority
        or o.renew_method <> n.renew_method
        or o.renew_multiple <> n.renew_multiple
        or o.renew_type <> n.renew_type
        or o.sched_no <> n.sched_no
        or o.seq_no <> n.seq_no
        or o.sum_con_count <> n.sum_con_count
        or o.sum_count <> n.sum_count
        or o.lowest_amt <> n.lowest_amt
        or o.end_date <> n.end_date
        or o.sign_date <> n.sign_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.acct_fixed_rate <> n.acct_fixed_rate
        or o.acct_percent_rate <> n.acct_percent_rate
        or o.acct_spread_rate <> n.acct_spread_rate
        or o.bal_ratio <> n.bal_ratio
        or o.limit_amt_out_day <> n.limit_amt_out_day
        or o.month_limit <> n.month_limit
        or o.oth_acct_ccy <> n.oth_acct_ccy
        or o.oth_acct_seq_no <> n.oth_acct_seq_no
        or o.oth_bank_code <> n.oth_bank_code
        or o.oth_base_acct_no <> n.oth_base_acct_no
        or o.oth_internal_key <> n.oth_internal_key
        or o.oth_prod_type <> n.oth_prod_type
        or o.priint_acct_seq_no <> n.priint_acct_seq_no
        or o.priint_base_acct_no <> n.priint_base_acct_no
        or o.priint_ccy <> n.priint_ccy
        or o.priint_prod_type <> n.priint_prod_type
        or o.renew_min_amt <> n.renew_min_amt
        or o.settle_acct_ccy <> n.settle_acct_ccy
        or o.settle_acct_seq_no <> n.settle_acct_seq_no
        or o.settle_base_acct_no <> n.settle_base_acct_no
        or o.settle_prod_type <> n.settle_prod_type
        or o.sum_amt <> n.sum_amt
        or o.tran_base_amt <> n.tran_base_amt
        or o.tran_amt <> n.tran_amt
        or o.renew_acct_type <> n.renew_acct_type
        or o.fin_fixed_amt <> n.fin_fixed_amt
        or o.open_num_type <> n.open_num_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_sweep_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,con_transfer_count -- 持续划款次数
            ,narrative -- 摘要
            ,oth_acct_desc -- 对方账户描述
            ,oth_acct_sort -- 转入方账户类型
            ,priority -- 优先级
            ,renew_method -- 转存方式
            ,renew_multiple -- 转账倍数
            ,renew_type -- 约定转存方式
            ,sched_no -- 计划编号
            ,seq_no -- 序号
            ,sum_con_count -- 累计追踪次数
            ,sum_count -- 累计转账次数
            ,lowest_amt -- 保底金额
            ,end_date -- 结束日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,bal_ratio -- 余额比例
            ,limit_amt_out_day -- 出账日累计限额
            ,month_limit -- 本月累计限额
            ,oth_acct_ccy -- 对方账户币种
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_bank_code -- 对方银行代码
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,priint_acct_seq_no -- 本息入账账户序列号
            ,priint_base_acct_no -- 本息入账账号
            ,priint_ccy -- 本息入账账户币种
            ,priint_prod_type -- 本息入账账户产品类型
            ,renew_min_amt -- 最低转存金额
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_base_acct_no -- 结算账号
            ,settle_prod_type -- 结算账户产品类型
            ,sum_amt -- 累计转账金额
            ,tran_base_amt -- 转账基数
            ,tran_amt -- 交易金额
            ,renew_acct_type -- 转存账户类型
            ,fin_fixed_amt -- 理财固定金额
            ,open_num_type -- 开立笔数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_sweep_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,con_transfer_count -- 持续划款次数
            ,narrative -- 摘要
            ,oth_acct_desc -- 对方账户描述
            ,oth_acct_sort -- 转入方账户类型
            ,priority -- 优先级
            ,renew_method -- 转存方式
            ,renew_multiple -- 转账倍数
            ,renew_type -- 约定转存方式
            ,sched_no -- 计划编号
            ,seq_no -- 序号
            ,sum_con_count -- 累计追踪次数
            ,sum_count -- 累计转账次数
            ,lowest_amt -- 保底金额
            ,end_date -- 结束日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,bal_ratio -- 余额比例
            ,limit_amt_out_day -- 出账日累计限额
            ,month_limit -- 本月累计限额
            ,oth_acct_ccy -- 对方账户币种
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_bank_code -- 对方银行代码
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,priint_acct_seq_no -- 本息入账账户序列号
            ,priint_base_acct_no -- 本息入账账号
            ,priint_ccy -- 本息入账账户币种
            ,priint_prod_type -- 本息入账账户产品类型
            ,renew_min_amt -- 最低转存金额
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_base_acct_no -- 结算账号
            ,settle_prod_type -- 结算账户产品类型
            ,sum_amt -- 累计转账金额
            ,tran_base_amt -- 转账基数
            ,tran_amt -- 交易金额
            ,renew_acct_type -- 转存账户类型
            ,fin_fixed_amt -- 理财固定金额
            ,open_num_type -- 开立笔数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.reason_code -- 账户用途
    ,o.user_id -- 交易柜员编号
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.agreement_type -- 协议类型
    ,o.auto_settle_flag -- 自动结清标志
    ,o.company -- 法人
    ,o.con_transfer_count -- 持续划款次数
    ,o.narrative -- 摘要
    ,o.oth_acct_desc -- 对方账户描述
    ,o.oth_acct_sort -- 转入方账户类型
    ,o.priority -- 优先级
    ,o.renew_method -- 转存方式
    ,o.renew_multiple -- 转账倍数
    ,o.renew_type -- 约定转存方式
    ,o.sched_no -- 计划编号
    ,o.seq_no -- 序号
    ,o.sum_con_count -- 累计追踪次数
    ,o.sum_count -- 累计转账次数
    ,o.lowest_amt -- 保底金额
    ,o.end_date -- 结束日期
    ,o.sign_date -- 签约日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.acct_fixed_rate -- 分户级固定利率
    ,o.acct_percent_rate -- 分户级利率浮动百分比
    ,o.acct_spread_rate -- 分户级利率浮动百分点
    ,o.bal_ratio -- 余额比例
    ,o.limit_amt_out_day -- 出账日累计限额
    ,o.month_limit -- 本月累计限额
    ,o.oth_acct_ccy -- 对方账户币种
    ,o.oth_acct_seq_no -- 对方账户序列号
    ,o.oth_bank_code -- 对方银行代码
    ,o.oth_base_acct_no -- 对方账号/卡号
    ,o.oth_internal_key -- 对手账户内部键
    ,o.oth_prod_type -- 对方账户产品类型
    ,o.priint_acct_seq_no -- 本息入账账户序列号
    ,o.priint_base_acct_no -- 本息入账账号
    ,o.priint_ccy -- 本息入账账户币种
    ,o.priint_prod_type -- 本息入账账户产品类型
    ,o.renew_min_amt -- 最低转存金额
    ,o.settle_acct_ccy -- 结算账户币种
    ,o.settle_acct_seq_no -- 结算账户序号
    ,o.settle_base_acct_no -- 结算账号
    ,o.settle_prod_type -- 结算账户产品类型
    ,o.sum_amt -- 累计转账金额
    ,o.tran_base_amt -- 转账基数
    ,o.tran_amt -- 交易金额
    ,o.renew_acct_type -- 转存账户类型
    ,o.fin_fixed_amt -- 理财固定金额
    ,o.open_num_type -- 开立笔数类型
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
from ${iol_schema}.ncbs_rb_agreement_sweep_bk o
    left join ${iol_schema}.ncbs_rb_agreement_sweep_op n
        on
            o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_sweep_cl d
        on
            o.agreement_id = d.agreement_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_sweep;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_sweep') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_sweep drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_sweep add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_sweep exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_sweep_cl;
alter table ${iol_schema}.ncbs_rb_agreement_sweep exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_sweep_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_sweep to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_sweep_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_sweep_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_sweep_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_sweep',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
