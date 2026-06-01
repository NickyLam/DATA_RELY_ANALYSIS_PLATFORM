/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_precontract
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
create table ${iol_schema}.ncbs_rb_dc_precontract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_dc_precontract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_precontract_op purge;
drop table ${iol_schema}.ncbs_rb_dc_precontract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_precontract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_precontract where 0=1;

create table ${iol_schema}.ncbs_rb_dc_precontract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_precontract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_precontract_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_nature -- 存款账户类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,cycle_int_flag -- 按频率付息标志
            ,email -- 电子邮件
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,narrative -- 摘要
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,print_cnt -- 打印次数
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,channel -- 渠道
            ,delete_date -- 删除日期
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,next_cycle_date -- 下一结息日
            ,pledged_flag -- 质押标志
            ,precontract_date -- 预约登记日期
            ,precontract_open_date -- 预约开户日期
            ,redeem_date -- 资产赎回日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,actual_rate -- 行内利率
            ,auth_user_id -- 授权柜员
            ,del_auth_user_id -- 删除授权柜员
            ,del_reason -- 删除原因
            ,del_user_id -- 删除柜员
            ,failure_reason -- 失败原因
            ,float_rate -- 浮动利率
            ,issue_amt -- 期次发行金额
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_ccy -- 对手账户币种
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,precontract_amt -- 预约金额
            ,precontract_branch -- 预约/认购机构
            ,precontract_ccy -- 期次产品预约币种
            ,real_rate -- 执行利率
            ,tran_amt -- 交易金额
            ,int_day -- 存贷结息日期
            ,hang_seq_no -- 挂账序列号
            ,dep_term_internal_key -- 定期一本通账户内部键
            ,acct_int_type -- 计息方法
            ,subs_internal_key -- 认购账户内部键
            ,comb_prod_no -- 组合产品编号
            ,charge_int_internal_key -- 收息账户内部键
            ,sub_hang_seq_no -- 追加挂账子序号
            ,exp_redeem_int_amt -- 预计赎回利息
            ,cancel_date -- 撤单日期|撤单日期
            ,deposit_nature -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_precontract_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_nature -- 存款账户类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,cycle_int_flag -- 按频率付息标志
            ,email -- 电子邮件
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,narrative -- 摘要
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,print_cnt -- 打印次数
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,channel -- 渠道
            ,delete_date -- 删除日期
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,next_cycle_date -- 下一结息日
            ,pledged_flag -- 质押标志
            ,precontract_date -- 预约登记日期
            ,precontract_open_date -- 预约开户日期
            ,redeem_date -- 资产赎回日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,actual_rate -- 行内利率
            ,auth_user_id -- 授权柜员
            ,del_auth_user_id -- 删除授权柜员
            ,del_reason -- 删除原因
            ,del_user_id -- 删除柜员
            ,failure_reason -- 失败原因
            ,float_rate -- 浮动利率
            ,issue_amt -- 期次发行金额
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_ccy -- 对手账户币种
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,precontract_amt -- 预约金额
            ,precontract_branch -- 预约/认购机构
            ,precontract_ccy -- 期次产品预约币种
            ,real_rate -- 执行利率
            ,tran_amt -- 交易金额
            ,int_day -- 存贷结息日期
            ,hang_seq_no -- 挂账序列号
            ,dep_term_internal_key -- 定期一本通账户内部键
            ,acct_int_type -- 计息方法
            ,subs_internal_key -- 认购账户内部键
            ,comb_prod_no -- 组合产品编号
            ,charge_int_internal_key -- 收息账户内部键
            ,sub_hang_seq_no -- 追加挂账子序号
            ,exp_redeem_int_amt -- 预计赎回利息
            ,cancel_date -- 撤单日期|撤单日期
            ,deposit_nature -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.withdrawal_type, o.withdrawal_type) as withdrawal_type -- 支取方式
    ,nvl(n.acct_nature, o.acct_nature) as acct_nature -- 存款账户类型
    ,nvl(n.auto_settle_flag, o.auto_settle_flag) as auto_settle_flag -- 自动结清标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cycle_freq, o.cycle_freq) as cycle_freq -- 结息频率
    ,nvl(n.cycle_int_flag, o.cycle_int_flag) as cycle_int_flag -- 按频率付息标志
    ,nvl(n.email, o.email) as email -- 电子邮件
    ,nvl(n.int_calc_type, o.int_calc_type) as int_calc_type -- 计息类型
    ,nvl(n.issue_year, o.issue_year) as issue_year -- 发行年度
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.precontract_no, o.precontract_no) as precontract_no -- 预约号
    ,nvl(n.precontract_status, o.precontract_status) as precontract_status -- 期次产品预约状态
    ,nvl(n.precontract_type, o.precontract_type) as precontract_type -- 预约登记的账户类型
    ,nvl(n.print_cnt, o.print_cnt) as print_cnt -- 打印次数
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.stage_code, o.stage_code) as stage_code -- 期次代码
    ,nvl(n.stage_prod_class, o.stage_prod_class) as stage_prod_class -- 期次产品分类
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.delete_date, o.delete_date) as delete_date -- 删除日期
    ,nvl(n.issue_end_date, o.issue_end_date) as issue_end_date -- 发行终止日期
    ,nvl(n.issue_start_date, o.issue_start_date) as issue_start_date -- 发行起始日期
    ,nvl(n.next_cycle_date, o.next_cycle_date) as next_cycle_date -- 下一结息日
    ,nvl(n.pledged_flag, o.pledged_flag) as pledged_flag -- 质押标志
    ,nvl(n.precontract_date, o.precontract_date) as precontract_date -- 预约登记日期
    ,nvl(n.precontract_open_date, o.precontract_open_date) as precontract_open_date -- 预约开户日期
    ,nvl(n.redeem_date, o.redeem_date) as redeem_date -- 资产赎回日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.del_auth_user_id, o.del_auth_user_id) as del_auth_user_id -- 删除授权柜员
    ,nvl(n.del_reason, o.del_reason) as del_reason -- 删除原因
    ,nvl(n.del_user_id, o.del_user_id) as del_user_id -- 删除柜员
    ,nvl(n.failure_reason, o.failure_reason) as failure_reason -- 失败原因
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.issue_amt, o.issue_amt) as issue_amt -- 期次发行金额
    ,nvl(n.oth_acct_name, o.oth_acct_name) as oth_acct_name -- 对方账户名称
    ,nvl(n.oth_acct_seq_no, o.oth_acct_seq_no) as oth_acct_seq_no -- 对方账户序列号
    ,nvl(n.oth_base_acct_no, o.oth_base_acct_no) as oth_base_acct_no -- 对方账号/卡号
    ,nvl(n.oth_ccy, o.oth_ccy) as oth_ccy -- 对手账户币种
    ,nvl(n.oth_internal_key, o.oth_internal_key) as oth_internal_key -- 对手账户内部键
    ,nvl(n.oth_prod_type, o.oth_prod_type) as oth_prod_type -- 对方账户产品类型
    ,nvl(n.precontract_amt, o.precontract_amt) as precontract_amt -- 预约金额
    ,nvl(n.precontract_branch, o.precontract_branch) as precontract_branch -- 预约/认购机构
    ,nvl(n.precontract_ccy, o.precontract_ccy) as precontract_ccy -- 期次产品预约币种
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.int_day, o.int_day) as int_day -- 存贷结息日期
    ,nvl(n.hang_seq_no, o.hang_seq_no) as hang_seq_no -- 挂账序列号
    ,nvl(n.dep_term_internal_key, o.dep_term_internal_key) as dep_term_internal_key -- 定期一本通账户内部键
    ,nvl(n.acct_int_type, o.acct_int_type) as acct_int_type -- 计息方法
    ,nvl(n.subs_internal_key, o.subs_internal_key) as subs_internal_key -- 认购账户内部键
    ,nvl(n.comb_prod_no, o.comb_prod_no) as comb_prod_no -- 组合产品编号
    ,nvl(n.charge_int_internal_key, o.charge_int_internal_key) as charge_int_internal_key -- 收息账户内部键
    ,nvl(n.sub_hang_seq_no, o.sub_hang_seq_no) as sub_hang_seq_no -- 追加挂账子序号
    ,nvl(n.exp_redeem_int_amt, o.exp_redeem_int_amt) as exp_redeem_int_amt -- 预计赎回利息
    ,nvl(n.cancel_date, o.cancel_date) as cancel_date -- 撤单日期|撤单日期
    ,nvl(n.deposit_nature, o.deposit_nature) as deposit_nature -- 
    ,case when
            n.precontract_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.precontract_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.precontract_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_dc_precontract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_dc_precontract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.precontract_no = n.precontract_no
where (
        o.precontract_no is null
    )
    or (
        n.precontract_no is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.acct_status <> n.acct_status
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.int_type <> n.int_type
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.voucher_no <> n.voucher_no
        or o.withdrawal_type <> n.withdrawal_type
        or o.acct_nature <> n.acct_nature
        or o.auto_settle_flag <> n.auto_settle_flag
        or o.company <> n.company
        or o.cycle_freq <> n.cycle_freq
        or o.cycle_int_flag <> n.cycle_int_flag
        or o.email <> n.email
        or o.int_calc_type <> n.int_calc_type
        or o.issue_year <> n.issue_year
        or o.narrative <> n.narrative
        or o.precontract_status <> n.precontract_status
        or o.precontract_type <> n.precontract_type
        or o.print_cnt <> n.print_cnt
        or o.res_seq_no <> n.res_seq_no
        or o.seq_no <> n.seq_no
        or o.source_type <> n.source_type
        or o.stage_code <> n.stage_code
        or o.stage_prod_class <> n.stage_prod_class
        or o.channel <> n.channel
        or o.delete_date <> n.delete_date
        or o.issue_end_date <> n.issue_end_date
        or o.issue_start_date <> n.issue_start_date
        or o.next_cycle_date <> n.next_cycle_date
        or o.pledged_flag <> n.pledged_flag
        or o.precontract_date <> n.precontract_date
        or o.precontract_open_date <> n.precontract_open_date
        or o.redeem_date <> n.redeem_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.actual_rate <> n.actual_rate
        or o.auth_user_id <> n.auth_user_id
        or o.del_auth_user_id <> n.del_auth_user_id
        or o.del_reason <> n.del_reason
        or o.del_user_id <> n.del_user_id
        or o.failure_reason <> n.failure_reason
        or o.float_rate <> n.float_rate
        or o.issue_amt <> n.issue_amt
        or o.oth_acct_name <> n.oth_acct_name
        or o.oth_acct_seq_no <> n.oth_acct_seq_no
        or o.oth_base_acct_no <> n.oth_base_acct_no
        or o.oth_ccy <> n.oth_ccy
        or o.oth_internal_key <> n.oth_internal_key
        or o.oth_prod_type <> n.oth_prod_type
        or o.precontract_amt <> n.precontract_amt
        or o.precontract_branch <> n.precontract_branch
        or o.precontract_ccy <> n.precontract_ccy
        or o.real_rate <> n.real_rate
        or o.tran_amt <> n.tran_amt
        or o.int_day <> n.int_day
        or o.hang_seq_no <> n.hang_seq_no
        or o.dep_term_internal_key <> n.dep_term_internal_key
        or o.acct_int_type <> n.acct_int_type
        or o.subs_internal_key <> n.subs_internal_key
        or o.comb_prod_no <> n.comb_prod_no
        or o.charge_int_internal_key <> n.charge_int_internal_key
        or o.sub_hang_seq_no <> n.sub_hang_seq_no
        or o.exp_redeem_int_amt <> n.exp_redeem_int_amt
        or o.cancel_date <> n.cancel_date
        or o.deposit_nature <> n.deposit_nature
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_precontract_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_nature -- 存款账户类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,cycle_int_flag -- 按频率付息标志
            ,email -- 电子邮件
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,narrative -- 摘要
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,print_cnt -- 打印次数
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,channel -- 渠道
            ,delete_date -- 删除日期
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,next_cycle_date -- 下一结息日
            ,pledged_flag -- 质押标志
            ,precontract_date -- 预约登记日期
            ,precontract_open_date -- 预约开户日期
            ,redeem_date -- 资产赎回日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,actual_rate -- 行内利率
            ,auth_user_id -- 授权柜员
            ,del_auth_user_id -- 删除授权柜员
            ,del_reason -- 删除原因
            ,del_user_id -- 删除柜员
            ,failure_reason -- 失败原因
            ,float_rate -- 浮动利率
            ,issue_amt -- 期次发行金额
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_ccy -- 对手账户币种
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,precontract_amt -- 预约金额
            ,precontract_branch -- 预约/认购机构
            ,precontract_ccy -- 期次产品预约币种
            ,real_rate -- 执行利率
            ,tran_amt -- 交易金额
            ,int_day -- 存贷结息日期
            ,hang_seq_no -- 挂账序列号
            ,dep_term_internal_key -- 定期一本通账户内部键
            ,acct_int_type -- 计息方法
            ,subs_internal_key -- 认购账户内部键
            ,comb_prod_no -- 组合产品编号
            ,charge_int_internal_key -- 收息账户内部键
            ,sub_hang_seq_no -- 追加挂账子序号
            ,exp_redeem_int_amt -- 预计赎回利息
            ,cancel_date -- 撤单日期|撤单日期
            ,deposit_nature -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_precontract_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_nature -- 存款账户类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,cycle_int_flag -- 按频率付息标志
            ,email -- 电子邮件
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,narrative -- 摘要
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,print_cnt -- 打印次数
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,channel -- 渠道
            ,delete_date -- 删除日期
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,next_cycle_date -- 下一结息日
            ,pledged_flag -- 质押标志
            ,precontract_date -- 预约登记日期
            ,precontract_open_date -- 预约开户日期
            ,redeem_date -- 资产赎回日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,actual_rate -- 行内利率
            ,auth_user_id -- 授权柜员
            ,del_auth_user_id -- 删除授权柜员
            ,del_reason -- 删除原因
            ,del_user_id -- 删除柜员
            ,failure_reason -- 失败原因
            ,float_rate -- 浮动利率
            ,issue_amt -- 期次发行金额
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_ccy -- 对手账户币种
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,precontract_amt -- 预约金额
            ,precontract_branch -- 预约/认购机构
            ,precontract_ccy -- 期次产品预约币种
            ,real_rate -- 执行利率
            ,tran_amt -- 交易金额
            ,int_day -- 存贷结息日期
            ,hang_seq_no -- 挂账序列号
            ,dep_term_internal_key -- 定期一本通账户内部键
            ,acct_int_type -- 计息方法
            ,subs_internal_key -- 认购账户内部键
            ,comb_prod_no -- 组合产品编号
            ,charge_int_internal_key -- 收息账户内部键
            ,sub_hang_seq_no -- 追加挂账子序号
            ,exp_redeem_int_amt -- 预计赎回利息
            ,cancel_date -- 撤单日期|撤单日期
            ,deposit_nature -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.acct_status -- 账户状态
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.int_type -- 利率类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.voucher_no -- 凭证号码
    ,o.withdrawal_type -- 支取方式
    ,o.acct_nature -- 存款账户类型
    ,o.auto_settle_flag -- 自动结清标志
    ,o.company -- 法人
    ,o.cycle_freq -- 结息频率
    ,o.cycle_int_flag -- 按频率付息标志
    ,o.email -- 电子邮件
    ,o.int_calc_type -- 计息类型
    ,o.issue_year -- 发行年度
    ,o.narrative -- 摘要
    ,o.precontract_no -- 预约号
    ,o.precontract_status -- 期次产品预约状态
    ,o.precontract_type -- 预约登记的账户类型
    ,o.print_cnt -- 打印次数
    ,o.res_seq_no -- 限制编号
    ,o.seq_no -- 序号
    ,o.source_type -- 渠道编号
    ,o.stage_code -- 期次代码
    ,o.stage_prod_class -- 期次产品分类
    ,o.channel -- 渠道
    ,o.delete_date -- 删除日期
    ,o.issue_end_date -- 发行终止日期
    ,o.issue_start_date -- 发行起始日期
    ,o.next_cycle_date -- 下一结息日
    ,o.pledged_flag -- 质押标志
    ,o.precontract_date -- 预约登记日期
    ,o.precontract_open_date -- 预约开户日期
    ,o.redeem_date -- 资产赎回日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.actual_rate -- 行内利率
    ,o.auth_user_id -- 授权柜员
    ,o.del_auth_user_id -- 删除授权柜员
    ,o.del_reason -- 删除原因
    ,o.del_user_id -- 删除柜员
    ,o.failure_reason -- 失败原因
    ,o.float_rate -- 浮动利率
    ,o.issue_amt -- 期次发行金额
    ,o.oth_acct_name -- 对方账户名称
    ,o.oth_acct_seq_no -- 对方账户序列号
    ,o.oth_base_acct_no -- 对方账号/卡号
    ,o.oth_ccy -- 对手账户币种
    ,o.oth_internal_key -- 对手账户内部键
    ,o.oth_prod_type -- 对方账户产品类型
    ,o.precontract_amt -- 预约金额
    ,o.precontract_branch -- 预约/认购机构
    ,o.precontract_ccy -- 期次产品预约币种
    ,o.real_rate -- 执行利率
    ,o.tran_amt -- 交易金额
    ,o.int_day -- 存贷结息日期
    ,o.hang_seq_no -- 挂账序列号
    ,o.dep_term_internal_key -- 定期一本通账户内部键
    ,o.acct_int_type -- 计息方法
    ,o.subs_internal_key -- 认购账户内部键
    ,o.comb_prod_no -- 组合产品编号
    ,o.charge_int_internal_key -- 收息账户内部键
    ,o.sub_hang_seq_no -- 追加挂账子序号
    ,o.exp_redeem_int_amt -- 预计赎回利息
    ,o.cancel_date -- 撤单日期|撤单日期
    ,o.deposit_nature -- 
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
from ${iol_schema}.ncbs_rb_dc_precontract_bk o
    left join ${iol_schema}.ncbs_rb_dc_precontract_op n
        on
            o.precontract_no = n.precontract_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_dc_precontract_cl d
        on
            o.precontract_no = d.precontract_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_dc_precontract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_dc_precontract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_dc_precontract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_dc_precontract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_dc_precontract exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_precontract_cl;
alter table ${iol_schema}.ncbs_rb_dc_precontract exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_dc_precontract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_precontract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_precontract_op purge;
drop table ${iol_schema}.ncbs_rb_dc_precontract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_dc_precontract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_precontract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
