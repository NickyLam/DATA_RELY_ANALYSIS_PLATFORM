/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_int_split
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
create table ${iol_schema}.ncbs_rb_int_split_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_int_split
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_int_split_op purge;
drop table ${iol_schema}.ncbs_rb_int_split_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_int_split_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_int_split where 0=1;

create table ${iol_schema}.ncbs_rb_int_split_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_int_split where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_int_split_cl(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,after_int_accrued_diff -- 期末计提差额
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,cr_rating -- 客户信用等级
            ,event_type -- 事件类型
            ,int_calc_bal -- 计息方式
            ,irl_gene_str -- 利率因子字符串
            ,month_basis -- 月基准
            ,pre_int_accrued_diff -- 期初计提差额
            ,source_type -- 渠道编号
            ,split_rate_flag -- 利率分段标志
            ,system_id -- 系统id
            ,tax_type -- 税种
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,td_end_accr_date -- 计提结束日期
            ,td_last_accr_date -- 当期上一计提日
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,after_int_accrued -- 期末累计计提
            ,after_int_adj -- 期末累计调整
            ,after_tax_accrued -- 期末累计利息税
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_reduce_amt -- 协议优惠金额
            ,agree_spread_rate -- 协议浮动百分点
            ,cur_int_accrued -- 当期累计计提
            ,cur_int_adj -- 当期累计调整
            ,cur_tax_accrued -- 当期累计利息税
            ,float_rate -- 浮动利率
            ,int_amt -- 利息金额
            ,pre_int_accrued -- 期初累计计提
            ,pre_int_adj -- 期初累计调整
            ,pre_tax_accrued -- 期初累计利息税
            ,real_rate -- 执行利率
            ,tax_rate -- 税率
            ,td_accr_int_day -- 计提起始日
            ,td_int_num_days -- 当期累计计息天数
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_int_split_op(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,after_int_accrued_diff -- 期末计提差额
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,cr_rating -- 客户信用等级
            ,event_type -- 事件类型
            ,int_calc_bal -- 计息方式
            ,irl_gene_str -- 利率因子字符串
            ,month_basis -- 月基准
            ,pre_int_accrued_diff -- 期初计提差额
            ,source_type -- 渠道编号
            ,split_rate_flag -- 利率分段标志
            ,system_id -- 系统id
            ,tax_type -- 税种
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,td_end_accr_date -- 计提结束日期
            ,td_last_accr_date -- 当期上一计提日
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,after_int_accrued -- 期末累计计提
            ,after_int_adj -- 期末累计调整
            ,after_tax_accrued -- 期末累计利息税
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_reduce_amt -- 协议优惠金额
            ,agree_spread_rate -- 协议浮动百分点
            ,cur_int_accrued -- 当期累计计提
            ,cur_int_adj -- 当期累计调整
            ,cur_tax_accrued -- 当期累计利息税
            ,float_rate -- 浮动利率
            ,int_amt -- 利息金额
            ,pre_int_accrued -- 期初累计计提
            ,pre_int_adj -- 期初累计调整
            ,pre_tax_accrued -- 期初累计利息税
            ,real_rate -- 执行利率
            ,tax_rate -- 税率
            ,td_accr_int_day -- 计提起始日
            ,td_int_num_days -- 当期累计计息天数
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.after_int_accrued_diff, o.after_int_accrued_diff) as after_int_accrued_diff -- 期末计提差额
    ,nvl(n.agree_change_type, o.agree_change_type) as agree_change_type -- 协议变动方式
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cr_rating, o.cr_rating) as cr_rating -- 客户信用等级
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.int_calc_bal, o.int_calc_bal) as int_calc_bal -- 计息方式
    ,nvl(n.irl_gene_str, o.irl_gene_str) as irl_gene_str -- 利率因子字符串
    ,nvl(n.month_basis, o.month_basis) as month_basis -- 月基准
    ,nvl(n.pre_int_accrued_diff, o.pre_int_accrued_diff) as pre_int_accrued_diff -- 期初计提差额
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.split_rate_flag, o.split_rate_flag) as split_rate_flag -- 利率分段标志
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.tax_type, o.tax_type) as tax_type -- 税种
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.calc_begin_date, o.calc_begin_date) as calc_begin_date -- 利息计算起始日
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.td_end_accr_date, o.td_end_accr_date) as td_end_accr_date -- 计提结束日期
    ,nvl(n.td_last_accr_date, o.td_last_accr_date) as td_last_accr_date -- 当期上一计提日
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_fixed_rate, o.acct_fixed_rate) as acct_fixed_rate -- 分户级固定利率
    ,nvl(n.acct_percent_rate, o.acct_percent_rate) as acct_percent_rate -- 分户级利率浮动百分比
    ,nvl(n.acct_spread_rate, o.acct_spread_rate) as acct_spread_rate -- 分户级利率浮动百分点
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.after_int_accrued, o.after_int_accrued) as after_int_accrued -- 期末累计计提
    ,nvl(n.after_int_adj, o.after_int_adj) as after_int_adj -- 期末累计调整
    ,nvl(n.after_tax_accrued, o.after_tax_accrued) as after_tax_accrued -- 期末累计利息税
    ,nvl(n.agree_fixed_rate, o.agree_fixed_rate) as agree_fixed_rate -- 协议固定利率
    ,nvl(n.agree_percent_rate, o.agree_percent_rate) as agree_percent_rate -- 协议浮动百分比
    ,nvl(n.agree_reduce_amt, o.agree_reduce_amt) as agree_reduce_amt -- 协议优惠金额
    ,nvl(n.agree_spread_rate, o.agree_spread_rate) as agree_spread_rate -- 协议浮动百分点
    ,nvl(n.cur_int_accrued, o.cur_int_accrued) as cur_int_accrued -- 当期累计计提
    ,nvl(n.cur_int_adj, o.cur_int_adj) as cur_int_adj -- 当期累计调整
    ,nvl(n.cur_tax_accrued, o.cur_tax_accrued) as cur_tax_accrued -- 当期累计利息税
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.pre_int_accrued, o.pre_int_accrued) as pre_int_accrued -- 期初累计计提
    ,nvl(n.pre_int_adj, o.pre_int_adj) as pre_int_adj -- 期初累计调整
    ,nvl(n.pre_tax_accrued, o.pre_tax_accrued) as pre_tax_accrued -- 期初累计利息税
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 税率
    ,nvl(n.td_accr_int_day, o.td_accr_int_day) as td_accr_int_day -- 计提起始日
    ,nvl(n.td_int_num_days, o.td_int_num_days) as td_int_num_days -- 当期累计计息天数
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.system_id is null
            and n.int_class is null
            and n.start_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.system_id is null
            and n.int_class is null
            and n.start_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.system_id is null
            and n.int_class is null
            and n.start_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_int_split_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_int_split where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.system_id = n.system_id
            and o.int_class = n.int_class
            and o.start_date = n.start_date
where (
        o.client_no is null
        and o.internal_key is null
        and o.system_id is null
        and o.int_class is null
        and o.start_date is null
    )
    or (
        n.client_no is null
        and n.internal_key is null
        and n.system_id is null
        and n.int_class is null
        and n.start_date is null
    )
    or (
        o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.int_type <> n.int_type
        or o.prod_type <> n.prod_type
        or o.after_int_accrued_diff <> n.after_int_accrued_diff
        or o.agree_change_type <> n.agree_change_type
        or o.company <> n.company
        or o.cr_rating <> n.cr_rating
        or o.event_type <> n.event_type
        or o.int_calc_bal <> n.int_calc_bal
        or o.irl_gene_str <> n.irl_gene_str
        or o.month_basis <> n.month_basis
        or o.pre_int_accrued_diff <> n.pre_int_accrued_diff
        or o.source_type <> n.source_type
        or o.split_rate_flag <> n.split_rate_flag
        or o.tax_type <> n.tax_type
        or o.year_basis <> n.year_basis
        or o.calc_begin_date <> n.calc_begin_date
        or o.end_date <> n.end_date
        or o.td_end_accr_date <> n.td_end_accr_date
        or o.td_last_accr_date <> n.td_last_accr_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_fixed_rate <> n.acct_fixed_rate
        or o.acct_percent_rate <> n.acct_percent_rate
        or o.acct_spread_rate <> n.acct_spread_rate
        or o.actual_rate <> n.actual_rate
        or o.after_int_accrued <> n.after_int_accrued
        or o.after_int_adj <> n.after_int_adj
        or o.after_tax_accrued <> n.after_tax_accrued
        or o.agree_fixed_rate <> n.agree_fixed_rate
        or o.agree_percent_rate <> n.agree_percent_rate
        or o.agree_reduce_amt <> n.agree_reduce_amt
        or o.agree_spread_rate <> n.agree_spread_rate
        or o.cur_int_accrued <> n.cur_int_accrued
        or o.cur_int_adj <> n.cur_int_adj
        or o.cur_tax_accrued <> n.cur_tax_accrued
        or o.float_rate <> n.float_rate
        or o.int_amt <> n.int_amt
        or o.pre_int_accrued <> n.pre_int_accrued
        or o.pre_int_adj <> n.pre_int_adj
        or o.pre_tax_accrued <> n.pre_tax_accrued
        or o.real_rate <> n.real_rate
        or o.tax_rate <> n.tax_rate
        or o.td_accr_int_day <> n.td_accr_int_day
        or o.td_int_num_days <> n.td_int_num_days
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_int_split_cl(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,after_int_accrued_diff -- 期末计提差额
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,cr_rating -- 客户信用等级
            ,event_type -- 事件类型
            ,int_calc_bal -- 计息方式
            ,irl_gene_str -- 利率因子字符串
            ,month_basis -- 月基准
            ,pre_int_accrued_diff -- 期初计提差额
            ,source_type -- 渠道编号
            ,split_rate_flag -- 利率分段标志
            ,system_id -- 系统id
            ,tax_type -- 税种
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,td_end_accr_date -- 计提结束日期
            ,td_last_accr_date -- 当期上一计提日
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,after_int_accrued -- 期末累计计提
            ,after_int_adj -- 期末累计调整
            ,after_tax_accrued -- 期末累计利息税
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_reduce_amt -- 协议优惠金额
            ,agree_spread_rate -- 协议浮动百分点
            ,cur_int_accrued -- 当期累计计提
            ,cur_int_adj -- 当期累计调整
            ,cur_tax_accrued -- 当期累计利息税
            ,float_rate -- 浮动利率
            ,int_amt -- 利息金额
            ,pre_int_accrued -- 期初累计计提
            ,pre_int_adj -- 期初累计调整
            ,pre_tax_accrued -- 期初累计利息税
            ,real_rate -- 执行利率
            ,tax_rate -- 税率
            ,td_accr_int_day -- 计提起始日
            ,td_int_num_days -- 当期累计计息天数
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_int_split_op(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,after_int_accrued_diff -- 期末计提差额
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,cr_rating -- 客户信用等级
            ,event_type -- 事件类型
            ,int_calc_bal -- 计息方式
            ,irl_gene_str -- 利率因子字符串
            ,month_basis -- 月基准
            ,pre_int_accrued_diff -- 期初计提差额
            ,source_type -- 渠道编号
            ,split_rate_flag -- 利率分段标志
            ,system_id -- 系统id
            ,tax_type -- 税种
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,td_end_accr_date -- 计提结束日期
            ,td_last_accr_date -- 当期上一计提日
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,after_int_accrued -- 期末累计计提
            ,after_int_adj -- 期末累计调整
            ,after_tax_accrued -- 期末累计利息税
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_reduce_amt -- 协议优惠金额
            ,agree_spread_rate -- 协议浮动百分点
            ,cur_int_accrued -- 当期累计计提
            ,cur_int_adj -- 当期累计调整
            ,cur_tax_accrued -- 当期累计利息税
            ,float_rate -- 浮动利率
            ,int_amt -- 利息金额
            ,pre_int_accrued -- 期初累计计提
            ,pre_int_adj -- 期初累计调整
            ,pre_tax_accrued -- 期初累计利息税
            ,real_rate -- 执行利率
            ,tax_rate -- 税率
            ,td_accr_int_day -- 计提起始日
            ,td_int_num_days -- 当期累计计息天数
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.int_type -- 利率类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.after_int_accrued_diff -- 期末计提差额
    ,o.agree_change_type -- 协议变动方式
    ,o.company -- 法人
    ,o.cr_rating -- 客户信用等级
    ,o.event_type -- 事件类型
    ,o.int_calc_bal -- 计息方式
    ,o.irl_gene_str -- 利率因子字符串
    ,o.month_basis -- 月基准
    ,o.pre_int_accrued_diff -- 期初计提差额
    ,o.source_type -- 渠道编号
    ,o.split_rate_flag -- 利率分段标志
    ,o.system_id -- 系统id
    ,o.tax_type -- 税种
    ,o.year_basis -- 年基准天数
    ,o.int_class -- 利息分类
    ,o.calc_begin_date -- 利息计算起始日
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
    ,o.td_end_accr_date -- 计提结束日期
    ,o.td_last_accr_date -- 当期上一计提日
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_fixed_rate -- 分户级固定利率
    ,o.acct_percent_rate -- 分户级利率浮动百分比
    ,o.acct_spread_rate -- 分户级利率浮动百分点
    ,o.actual_rate -- 行内利率
    ,o.after_int_accrued -- 期末累计计提
    ,o.after_int_adj -- 期末累计调整
    ,o.after_tax_accrued -- 期末累计利息税
    ,o.agree_fixed_rate -- 协议固定利率
    ,o.agree_percent_rate -- 协议浮动百分比
    ,o.agree_reduce_amt -- 协议优惠金额
    ,o.agree_spread_rate -- 协议浮动百分点
    ,o.cur_int_accrued -- 当期累计计提
    ,o.cur_int_adj -- 当期累计调整
    ,o.cur_tax_accrued -- 当期累计利息税
    ,o.float_rate -- 浮动利率
    ,o.int_amt -- 利息金额
    ,o.pre_int_accrued -- 期初累计计提
    ,o.pre_int_adj -- 期初累计调整
    ,o.pre_tax_accrued -- 期初累计利息税
    ,o.real_rate -- 执行利率
    ,o.tax_rate -- 税率
    ,o.td_accr_int_day -- 计提起始日
    ,o.td_int_num_days -- 当期累计计息天数
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
from ${iol_schema}.ncbs_rb_int_split_bk o
    left join ${iol_schema}.ncbs_rb_int_split_op n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.system_id = n.system_id
            and o.int_class = n.int_class
            and o.start_date = n.start_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_int_split_cl d
        on
            o.client_no = d.client_no
            and o.internal_key = d.internal_key
            and o.system_id = d.system_id
            and o.int_class = d.int_class
            and o.start_date = d.start_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_int_split;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_int_split') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_int_split drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_int_split add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_int_split exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_int_split_cl;
alter table ${iol_schema}.ncbs_rb_int_split exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_int_split_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_int_split to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_int_split_op purge;
drop table ${iol_schema}.ncbs_rb_int_split_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_int_split_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_int_split',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
