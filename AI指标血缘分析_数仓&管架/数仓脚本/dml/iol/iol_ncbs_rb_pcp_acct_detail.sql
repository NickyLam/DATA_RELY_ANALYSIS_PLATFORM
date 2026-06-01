/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_pcp_acct_detail
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
create table ${iol_schema}.ncbs_rb_pcp_acct_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_pcp_acct_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pcp_acct_detail_op purge;
drop table ${iol_schema}.ncbs_rb_pcp_acct_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_acct_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pcp_acct_detail where 0=1;

create table ${iol_schema}.ncbs_rb_pcp_acct_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pcp_acct_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pcp_acct_detail_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,cyc_ctrl_flag -- 是否循环使用限额标志
            ,down_max_senece -- 下拨最大场次
            ,down_method -- 下拨方法
            ,down_mod_unit -- 取整单位
            ,down_plan -- 下拨策略
            ,effect_flag -- 是否生效标志
            ,inc_exp_ind -- 收支标志
            ,inner_price_flag -- 是否开通内部计价
            ,inner_price_mode -- 内部计价模式
            ,inner_price_way -- 计价方式
            ,int_calc_bal -- 计息方式
            ,limit_mode -- 额度管理模式
            ,open_ctrl -- 开户是否开通限额
            ,open_limit -- 是否开通额度
            ,payment_flag -- 备款顺序
            ,pcp_acct_status -- 资金池账户状态
            ,pcp_agreement_flag -- 现金池协议标志
            ,price_freq -- 计价频率
            ,seq_no -- 序号
            ,up_max_senece -- 归集最大场次
            ,up_method -- 归集方法
            ,up_plan -- 归集策略
            ,down_time -- 下拨时点
            ,tran_timestamp -- 交易时间戳
            ,up_time -- 归集时点
            ,acct_ccy -- 账户币种
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,cr_rate -- 贷方利率
            ,down_day -- 下拨日
            ,down_fixed_amt -- 下拨固定金额
            ,down_freq -- 下拨频率
            ,down_remain_amt -- 下拨留底金额
            ,dr_rate -- 借方利率
            ,over_limit_amt -- 超额额度
            ,price_day -- 报价日
            ,tran_branch -- 核心交易机构编号
            ,up_day -- 归集日
            ,up_fixed_amt -- 归集固定金额
            ,up_freq -- 归集频率
            ,up_prop -- 归集比例
            ,up_remain_amt -- 归集留底金额
            ,payment_method -- 请款方法
            ,payment_plan -- 请款策略
            ,up_limit_amt -- 归集限制金额
            ,min_exe_amt -- 最小执行额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pcp_acct_detail_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,cyc_ctrl_flag -- 是否循环使用限额标志
            ,down_max_senece -- 下拨最大场次
            ,down_method -- 下拨方法
            ,down_mod_unit -- 取整单位
            ,down_plan -- 下拨策略
            ,effect_flag -- 是否生效标志
            ,inc_exp_ind -- 收支标志
            ,inner_price_flag -- 是否开通内部计价
            ,inner_price_mode -- 内部计价模式
            ,inner_price_way -- 计价方式
            ,int_calc_bal -- 计息方式
            ,limit_mode -- 额度管理模式
            ,open_ctrl -- 开户是否开通限额
            ,open_limit -- 是否开通额度
            ,payment_flag -- 备款顺序
            ,pcp_acct_status -- 资金池账户状态
            ,pcp_agreement_flag -- 现金池协议标志
            ,price_freq -- 计价频率
            ,seq_no -- 序号
            ,up_max_senece -- 归集最大场次
            ,up_method -- 归集方法
            ,up_plan -- 归集策略
            ,down_time -- 下拨时点
            ,tran_timestamp -- 交易时间戳
            ,up_time -- 归集时点
            ,acct_ccy -- 账户币种
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,cr_rate -- 贷方利率
            ,down_day -- 下拨日
            ,down_fixed_amt -- 下拨固定金额
            ,down_freq -- 下拨频率
            ,down_remain_amt -- 下拨留底金额
            ,dr_rate -- 借方利率
            ,over_limit_amt -- 超额额度
            ,price_day -- 报价日
            ,tran_branch -- 核心交易机构编号
            ,up_day -- 归集日
            ,up_fixed_amt -- 归集固定金额
            ,up_freq -- 归集频率
            ,up_prop -- 归集比例
            ,up_remain_amt -- 归集留底金额
            ,payment_method -- 请款方法
            ,payment_plan -- 请款策略
            ,up_limit_amt -- 归集限制金额
            ,min_exe_amt -- 最小执行额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cyc_ctrl_flag, o.cyc_ctrl_flag) as cyc_ctrl_flag -- 是否循环使用限额标志
    ,nvl(n.down_max_senece, o.down_max_senece) as down_max_senece -- 下拨最大场次
    ,nvl(n.down_method, o.down_method) as down_method -- 下拨方法
    ,nvl(n.down_mod_unit, o.down_mod_unit) as down_mod_unit -- 取整单位
    ,nvl(n.down_plan, o.down_plan) as down_plan -- 下拨策略
    ,nvl(n.effect_flag, o.effect_flag) as effect_flag -- 是否生效标志
    ,nvl(n.inc_exp_ind, o.inc_exp_ind) as inc_exp_ind -- 收支标志
    ,nvl(n.inner_price_flag, o.inner_price_flag) as inner_price_flag -- 是否开通内部计价
    ,nvl(n.inner_price_mode, o.inner_price_mode) as inner_price_mode -- 内部计价模式
    ,nvl(n.inner_price_way, o.inner_price_way) as inner_price_way -- 计价方式
    ,nvl(n.int_calc_bal, o.int_calc_bal) as int_calc_bal -- 计息方式
    ,nvl(n.limit_mode, o.limit_mode) as limit_mode -- 额度管理模式
    ,nvl(n.open_ctrl, o.open_ctrl) as open_ctrl -- 开户是否开通限额
    ,nvl(n.open_limit, o.open_limit) as open_limit -- 是否开通额度
    ,nvl(n.payment_flag, o.payment_flag) as payment_flag -- 备款顺序
    ,nvl(n.pcp_acct_status, o.pcp_acct_status) as pcp_acct_status -- 资金池账户状态
    ,nvl(n.pcp_agreement_flag, o.pcp_agreement_flag) as pcp_agreement_flag -- 现金池协议标志
    ,nvl(n.price_freq, o.price_freq) as price_freq -- 计价频率
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.up_max_senece, o.up_max_senece) as up_max_senece -- 归集最大场次
    ,nvl(n.up_method, o.up_method) as up_method -- 归集方法
    ,nvl(n.up_plan, o.up_plan) as up_plan -- 归集策略
    ,nvl(n.down_time, o.down_time) as down_time -- 下拨时点
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.up_time, o.up_time) as up_time -- 归集时点
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.cr_rate, o.cr_rate) as cr_rate -- 贷方利率
    ,nvl(n.down_day, o.down_day) as down_day -- 下拨日
    ,nvl(n.down_fixed_amt, o.down_fixed_amt) as down_fixed_amt -- 下拨固定金额
    ,nvl(n.down_freq, o.down_freq) as down_freq -- 下拨频率
    ,nvl(n.down_remain_amt, o.down_remain_amt) as down_remain_amt -- 下拨留底金额
    ,nvl(n.dr_rate, o.dr_rate) as dr_rate -- 借方利率
    ,nvl(n.over_limit_amt, o.over_limit_amt) as over_limit_amt -- 超额额度
    ,nvl(n.price_day, o.price_day) as price_day -- 报价日
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.up_day, o.up_day) as up_day -- 归集日
    ,nvl(n.up_fixed_amt, o.up_fixed_amt) as up_fixed_amt -- 归集固定金额
    ,nvl(n.up_freq, o.up_freq) as up_freq -- 归集频率
    ,nvl(n.up_prop, o.up_prop) as up_prop -- 归集比例
    ,nvl(n.up_remain_amt, o.up_remain_amt) as up_remain_amt -- 归集留底金额
    ,nvl(n.payment_method, o.payment_method) as payment_method -- 请款方法
    ,nvl(n.payment_plan, o.payment_plan) as payment_plan -- 请款策略
    ,nvl(n.up_limit_amt, o.up_limit_amt) as up_limit_amt -- 归集限制金额
    ,nvl(n.min_exe_amt, o.min_exe_amt) as min_exe_amt -- 最小执行额度
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_pcp_acct_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_pcp_acct_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.agreement_id <> n.agreement_id
        or o.company <> n.company
        or o.cyc_ctrl_flag <> n.cyc_ctrl_flag
        or o.down_max_senece <> n.down_max_senece
        or o.down_method <> n.down_method
        or o.down_mod_unit <> n.down_mod_unit
        or o.down_plan <> n.down_plan
        or o.effect_flag <> n.effect_flag
        or o.inc_exp_ind <> n.inc_exp_ind
        or o.inner_price_flag <> n.inner_price_flag
        or o.inner_price_mode <> n.inner_price_mode
        or o.inner_price_way <> n.inner_price_way
        or o.int_calc_bal <> n.int_calc_bal
        or o.limit_mode <> n.limit_mode
        or o.open_ctrl <> n.open_ctrl
        or o.open_limit <> n.open_limit
        or o.payment_flag <> n.payment_flag
        or o.pcp_acct_status <> n.pcp_acct_status
        or o.pcp_agreement_flag <> n.pcp_agreement_flag
        or o.price_freq <> n.price_freq
        or o.up_max_senece <> n.up_max_senece
        or o.up_method <> n.up_method
        or o.up_plan <> n.up_plan
        or o.down_time <> n.down_time
        or o.tran_timestamp <> n.tran_timestamp
        or o.up_time <> n.up_time
        or o.acct_ccy <> n.acct_ccy
        or o.appr_user_id <> n.appr_user_id
        or o.auth_user_id <> n.auth_user_id
        or o.cr_rate <> n.cr_rate
        or o.down_day <> n.down_day
        or o.down_fixed_amt <> n.down_fixed_amt
        or o.down_freq <> n.down_freq
        or o.down_remain_amt <> n.down_remain_amt
        or o.dr_rate <> n.dr_rate
        or o.over_limit_amt <> n.over_limit_amt
        or o.price_day <> n.price_day
        or o.tran_branch <> n.tran_branch
        or o.up_day <> n.up_day
        or o.up_fixed_amt <> n.up_fixed_amt
        or o.up_freq <> n.up_freq
        or o.up_prop <> n.up_prop
        or o.up_remain_amt <> n.up_remain_amt
        or o.payment_method <> n.payment_method
        or o.payment_plan <> n.payment_plan
        or o.up_limit_amt <> n.up_limit_amt
        or o.min_exe_amt <> n.min_exe_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pcp_acct_detail_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,cyc_ctrl_flag -- 是否循环使用限额标志
            ,down_max_senece -- 下拨最大场次
            ,down_method -- 下拨方法
            ,down_mod_unit -- 取整单位
            ,down_plan -- 下拨策略
            ,effect_flag -- 是否生效标志
            ,inc_exp_ind -- 收支标志
            ,inner_price_flag -- 是否开通内部计价
            ,inner_price_mode -- 内部计价模式
            ,inner_price_way -- 计价方式
            ,int_calc_bal -- 计息方式
            ,limit_mode -- 额度管理模式
            ,open_ctrl -- 开户是否开通限额
            ,open_limit -- 是否开通额度
            ,payment_flag -- 备款顺序
            ,pcp_acct_status -- 资金池账户状态
            ,pcp_agreement_flag -- 现金池协议标志
            ,price_freq -- 计价频率
            ,seq_no -- 序号
            ,up_max_senece -- 归集最大场次
            ,up_method -- 归集方法
            ,up_plan -- 归集策略
            ,down_time -- 下拨时点
            ,tran_timestamp -- 交易时间戳
            ,up_time -- 归集时点
            ,acct_ccy -- 账户币种
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,cr_rate -- 贷方利率
            ,down_day -- 下拨日
            ,down_fixed_amt -- 下拨固定金额
            ,down_freq -- 下拨频率
            ,down_remain_amt -- 下拨留底金额
            ,dr_rate -- 借方利率
            ,over_limit_amt -- 超额额度
            ,price_day -- 报价日
            ,tran_branch -- 核心交易机构编号
            ,up_day -- 归集日
            ,up_fixed_amt -- 归集固定金额
            ,up_freq -- 归集频率
            ,up_prop -- 归集比例
            ,up_remain_amt -- 归集留底金额
            ,payment_method -- 请款方法
            ,payment_plan -- 请款策略
            ,up_limit_amt -- 归集限制金额
            ,min_exe_amt -- 最小执行额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pcp_acct_detail_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,company -- 法人
            ,cyc_ctrl_flag -- 是否循环使用限额标志
            ,down_max_senece -- 下拨最大场次
            ,down_method -- 下拨方法
            ,down_mod_unit -- 取整单位
            ,down_plan -- 下拨策略
            ,effect_flag -- 是否生效标志
            ,inc_exp_ind -- 收支标志
            ,inner_price_flag -- 是否开通内部计价
            ,inner_price_mode -- 内部计价模式
            ,inner_price_way -- 计价方式
            ,int_calc_bal -- 计息方式
            ,limit_mode -- 额度管理模式
            ,open_ctrl -- 开户是否开通限额
            ,open_limit -- 是否开通额度
            ,payment_flag -- 备款顺序
            ,pcp_acct_status -- 资金池账户状态
            ,pcp_agreement_flag -- 现金池协议标志
            ,price_freq -- 计价频率
            ,seq_no -- 序号
            ,up_max_senece -- 归集最大场次
            ,up_method -- 归集方法
            ,up_plan -- 归集策略
            ,down_time -- 下拨时点
            ,tran_timestamp -- 交易时间戳
            ,up_time -- 归集时点
            ,acct_ccy -- 账户币种
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,cr_rate -- 贷方利率
            ,down_day -- 下拨日
            ,down_fixed_amt -- 下拨固定金额
            ,down_freq -- 下拨频率
            ,down_remain_amt -- 下拨留底金额
            ,dr_rate -- 借方利率
            ,over_limit_amt -- 超额额度
            ,price_day -- 报价日
            ,tran_branch -- 核心交易机构编号
            ,up_day -- 归集日
            ,up_fixed_amt -- 归集固定金额
            ,up_freq -- 归集频率
            ,up_prop -- 归集比例
            ,up_remain_amt -- 归集留底金额
            ,payment_method -- 请款方法
            ,payment_plan -- 请款策略
            ,up_limit_amt -- 归集限制金额
            ,min_exe_amt -- 最小执行额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.agreement_id -- 协议编号
    ,o.company -- 法人
    ,o.cyc_ctrl_flag -- 是否循环使用限额标志
    ,o.down_max_senece -- 下拨最大场次
    ,o.down_method -- 下拨方法
    ,o.down_mod_unit -- 取整单位
    ,o.down_plan -- 下拨策略
    ,o.effect_flag -- 是否生效标志
    ,o.inc_exp_ind -- 收支标志
    ,o.inner_price_flag -- 是否开通内部计价
    ,o.inner_price_mode -- 内部计价模式
    ,o.inner_price_way -- 计价方式
    ,o.int_calc_bal -- 计息方式
    ,o.limit_mode -- 额度管理模式
    ,o.open_ctrl -- 开户是否开通限额
    ,o.open_limit -- 是否开通额度
    ,o.payment_flag -- 备款顺序
    ,o.pcp_acct_status -- 资金池账户状态
    ,o.pcp_agreement_flag -- 现金池协议标志
    ,o.price_freq -- 计价频率
    ,o.seq_no -- 序号
    ,o.up_max_senece -- 归集最大场次
    ,o.up_method -- 归集方法
    ,o.up_plan -- 归集策略
    ,o.down_time -- 下拨时点
    ,o.tran_timestamp -- 交易时间戳
    ,o.up_time -- 归集时点
    ,o.acct_ccy -- 账户币种
    ,o.appr_user_id -- 复核柜员
    ,o.auth_user_id -- 授权柜员
    ,o.cr_rate -- 贷方利率
    ,o.down_day -- 下拨日
    ,o.down_fixed_amt -- 下拨固定金额
    ,o.down_freq -- 下拨频率
    ,o.down_remain_amt -- 下拨留底金额
    ,o.dr_rate -- 借方利率
    ,o.over_limit_amt -- 超额额度
    ,o.price_day -- 报价日
    ,o.tran_branch -- 核心交易机构编号
    ,o.up_day -- 归集日
    ,o.up_fixed_amt -- 归集固定金额
    ,o.up_freq -- 归集频率
    ,o.up_prop -- 归集比例
    ,o.up_remain_amt -- 归集留底金额
    ,o.payment_method -- 请款方法
    ,o.payment_plan -- 请款策略
    ,o.up_limit_amt -- 归集限制金额
    ,o.min_exe_amt -- 最小执行额度
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
from ${iol_schema}.ncbs_rb_pcp_acct_detail_bk o
    left join ${iol_schema}.ncbs_rb_pcp_acct_detail_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_pcp_acct_detail_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_pcp_acct_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_pcp_acct_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_pcp_acct_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_pcp_acct_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_pcp_acct_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_pcp_acct_detail_cl;
alter table ${iol_schema}.ncbs_rb_pcp_acct_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_pcp_acct_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_pcp_acct_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pcp_acct_detail_op purge;
drop table ${iol_schema}.ncbs_rb_pcp_acct_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_pcp_acct_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_pcp_acct_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
