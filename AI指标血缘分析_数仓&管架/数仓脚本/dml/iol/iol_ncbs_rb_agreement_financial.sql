/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_financial
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
create table ${iol_schema}.ncbs_rb_agreement_financial_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_financial
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_financial_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_financial_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_financial_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_financial where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_financial_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_financial where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_financial_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_extend -- 是否自动延期
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,failure_times -- 累积失败次数
            ,fin_prod_desc -- 理财产品类型描述
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_transfer_date -- 上次划转日期
            ,next_transfer_date -- 下次划转日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,failure_reason -- 失败原因
            ,fin_prod_type -- 理财产品编号
            ,financial_amount -- 理财产品金额
            ,int_min_amt -- 最小起存金额
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,remain_amt -- 协议留存金额
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,tda_acct_ccy -- 定期账户币种
            ,tda_acct_prod_type -- 定期账户产品类型
            ,tda_acct_seq_no -- 定期账户序列号
            ,tda_base_acct_no -- 定期账号
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,deposit_nature -- 核心存款性质
            ,failure_total_times -- 失败总次数
            ,unsign_reference -- 解约流水
            ,fin_fixed_amt -- 理财固定金额
            ,sign_reference -- 签约流水
            ,transfer_start_date -- 转存起始日期
            ,transfer_freq_type -- 划转频率类型
            ,last_transfer_reference -- 上一转存流水
            ,transfer_end_date -- 转存结束日期或终止日期
            ,success_times -- 累积成功次数
            ,success_total_times -- 成功总次数
            ,unsign_operate_date -- 解约操作日期|解约操作日期
            ,retry_transfer_date -- 重新尝试转存日重新尝试转存日
            ,limit_period_freq -- 限额周期限额周期
            ,limit_max_amt -- 最大限额最大限额
            ,next_calc_date -- 下一计算日期下一计算日期
            ,holding_limit -- 已占用额度已占用额度
            ,backup_date -- 
            ,month_total_amount -- 
            ,is_auto_sign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_financial_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_extend -- 是否自动延期
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,failure_times -- 累积失败次数
            ,fin_prod_desc -- 理财产品类型描述
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_transfer_date -- 上次划转日期
            ,next_transfer_date -- 下次划转日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,failure_reason -- 失败原因
            ,fin_prod_type -- 理财产品编号
            ,financial_amount -- 理财产品金额
            ,int_min_amt -- 最小起存金额
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,remain_amt -- 协议留存金额
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,tda_acct_ccy -- 定期账户币种
            ,tda_acct_prod_type -- 定期账户产品类型
            ,tda_acct_seq_no -- 定期账户序列号
            ,tda_base_acct_no -- 定期账号
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,deposit_nature -- 核心存款性质
            ,failure_total_times -- 失败总次数
            ,unsign_reference -- 解约流水
            ,fin_fixed_amt -- 理财固定金额
            ,sign_reference -- 签约流水
            ,transfer_start_date -- 转存起始日期
            ,transfer_freq_type -- 划转频率类型
            ,last_transfer_reference -- 上一转存流水
            ,transfer_end_date -- 转存结束日期或终止日期
            ,success_times -- 累积成功次数
            ,success_total_times -- 成功总次数
            ,unsign_operate_date -- 解约操作日期|解约操作日期
            ,retry_transfer_date -- 重新尝试转存日重新尝试转存日
            ,limit_period_freq -- 限额周期限额周期
            ,limit_max_amt -- 最大限额最大限额
            ,next_calc_date -- 下一计算日期下一计算日期
            ,holding_limit -- 已占用额度已占用额度
            ,backup_date -- 
            ,month_total_amount -- 
            ,is_auto_sign -- 
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
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.acct_exec_name, o.acct_exec_name) as acct_exec_name -- 客户经理姓名
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.agreement_type, o.agreement_type) as agreement_type -- 协议类型
    ,nvl(n.auto_extend, o.auto_extend) as auto_extend -- 是否自动延期
    ,nvl(n.auto_renew_rollover, o.auto_renew_rollover) as auto_renew_rollover -- 自动转存方式
    ,nvl(n.auto_settle_flag, o.auto_settle_flag) as auto_settle_flag -- 自动结清标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.failure_times, o.failure_times) as failure_times -- 累积失败次数
    ,nvl(n.fin_prod_desc, o.fin_prod_desc) as fin_prod_desc -- 理财产品类型描述
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_transfer_date, o.last_transfer_date) as last_transfer_date -- 上次划转日期
    ,nvl(n.next_transfer_date, o.next_transfer_date) as next_transfer_date -- 下次划转日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.failure_reason, o.failure_reason) as failure_reason -- 失败原因
    ,nvl(n.fin_prod_type, o.fin_prod_type) as fin_prod_type -- 理财产品编号
    ,nvl(n.financial_amount, o.financial_amount) as financial_amount -- 理财产品金额
    ,nvl(n.int_min_amt, o.int_min_amt) as int_min_amt -- 最小起存金额
    ,nvl(n.out_sign_branch, o.out_sign_branch) as out_sign_branch -- 解约机构
    ,nvl(n.out_sign_user_id, o.out_sign_user_id) as out_sign_user_id -- 解约柜员
    ,nvl(n.remain_amt, o.remain_amt) as remain_amt -- 协议留存金额
    ,nvl(n.sign_branch, o.sign_branch) as sign_branch -- 签约机构
    ,nvl(n.sign_user_id, o.sign_user_id) as sign_user_id -- 签约柜员
    ,nvl(n.tda_acct_ccy, o.tda_acct_ccy) as tda_acct_ccy -- 定期账户币种
    ,nvl(n.tda_acct_prod_type, o.tda_acct_prod_type) as tda_acct_prod_type -- 定期账户产品类型
    ,nvl(n.tda_acct_seq_no, o.tda_acct_seq_no) as tda_acct_seq_no -- 定期账户序列号
    ,nvl(n.tda_base_acct_no, o.tda_base_acct_no) as tda_base_acct_no -- 定期账号
    ,nvl(n.transfer_day, o.transfer_day) as transfer_day -- 划转日
    ,nvl(n.transfer_freq, o.transfer_freq) as transfer_freq -- 划转频率
    ,nvl(n.deposit_nature, o.deposit_nature) as deposit_nature -- 核心存款性质
    ,nvl(n.failure_total_times, o.failure_total_times) as failure_total_times -- 失败总次数
    ,nvl(n.unsign_reference, o.unsign_reference) as unsign_reference -- 解约流水
    ,nvl(n.fin_fixed_amt, o.fin_fixed_amt) as fin_fixed_amt -- 理财固定金额
    ,nvl(n.sign_reference, o.sign_reference) as sign_reference -- 签约流水
    ,nvl(n.transfer_start_date, o.transfer_start_date) as transfer_start_date -- 转存起始日期
    ,nvl(n.transfer_freq_type, o.transfer_freq_type) as transfer_freq_type -- 划转频率类型
    ,nvl(n.last_transfer_reference, o.last_transfer_reference) as last_transfer_reference -- 上一转存流水
    ,nvl(n.transfer_end_date, o.transfer_end_date) as transfer_end_date -- 转存结束日期或终止日期
    ,nvl(n.success_times, o.success_times) as success_times -- 累积成功次数
    ,nvl(n.success_total_times, o.success_total_times) as success_total_times -- 成功总次数
    ,nvl(n.unsign_operate_date, o.unsign_operate_date) as unsign_operate_date -- 解约操作日期|解约操作日期
    ,nvl(n.retry_transfer_date, o.retry_transfer_date) as retry_transfer_date -- 重新尝试转存日重新尝试转存日
    ,nvl(n.limit_period_freq, o.limit_period_freq) as limit_period_freq -- 限额周期限额周期
    ,nvl(n.limit_max_amt, o.limit_max_amt) as limit_max_amt -- 最大限额最大限额
    ,nvl(n.next_calc_date, o.next_calc_date) as next_calc_date -- 下一计算日期下一计算日期
    ,nvl(n.holding_limit, o.holding_limit) as holding_limit -- 已占用额度已占用额度
    ,nvl(n.backup_date, o.backup_date) as backup_date -- 
    ,nvl(n.month_total_amount, o.month_total_amount) as month_total_amount -- 
    ,nvl(n.is_auto_sign, o.is_auto_sign) as is_auto_sign -- 
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
from (select * from ${iol_schema}.ncbs_rb_agreement_financial_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_financial where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
where (
        o.agreement_id is null
    )
    or (
        n.agreement_id is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.acct_exec <> n.acct_exec
        or o.acct_exec_name <> n.acct_exec_name
        or o.agreement_status <> n.agreement_status
        or o.agreement_type <> n.agreement_type
        or o.auto_extend <> n.auto_extend
        or o.auto_renew_rollover <> n.auto_renew_rollover
        or o.auto_settle_flag <> n.auto_settle_flag
        or o.company <> n.company
        or o.failure_times <> n.failure_times
        or o.fin_prod_desc <> n.fin_prod_desc
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.last_transfer_date <> n.last_transfer_date
        or o.next_transfer_date <> n.next_transfer_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.failure_reason <> n.failure_reason
        or o.fin_prod_type <> n.fin_prod_type
        or o.financial_amount <> n.financial_amount
        or o.int_min_amt <> n.int_min_amt
        or o.out_sign_branch <> n.out_sign_branch
        or o.out_sign_user_id <> n.out_sign_user_id
        or o.remain_amt <> n.remain_amt
        or o.sign_branch <> n.sign_branch
        or o.sign_user_id <> n.sign_user_id
        or o.tda_acct_ccy <> n.tda_acct_ccy
        or o.tda_acct_prod_type <> n.tda_acct_prod_type
        or o.tda_acct_seq_no <> n.tda_acct_seq_no
        or o.tda_base_acct_no <> n.tda_base_acct_no
        or o.transfer_day <> n.transfer_day
        or o.transfer_freq <> n.transfer_freq
        or o.deposit_nature <> n.deposit_nature
        or o.failure_total_times <> n.failure_total_times
        or o.unsign_reference <> n.unsign_reference
        or o.fin_fixed_amt <> n.fin_fixed_amt
        or o.sign_reference <> n.sign_reference
        or o.transfer_start_date <> n.transfer_start_date
        or o.transfer_freq_type <> n.transfer_freq_type
        or o.last_transfer_reference <> n.last_transfer_reference
        or o.transfer_end_date <> n.transfer_end_date
        or o.success_times <> n.success_times
        or o.success_total_times <> n.success_total_times
        or o.unsign_operate_date <> n.unsign_operate_date
        or o.retry_transfer_date <> n.retry_transfer_date
        or o.limit_period_freq <> n.limit_period_freq
        or o.limit_max_amt <> n.limit_max_amt
        or o.next_calc_date <> n.next_calc_date
        or o.holding_limit <> n.holding_limit
        or o.backup_date <> n.backup_date
        or o.month_total_amount <> n.month_total_amount
        or o.is_auto_sign <> n.is_auto_sign
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_financial_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_extend -- 是否自动延期
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,failure_times -- 累积失败次数
            ,fin_prod_desc -- 理财产品类型描述
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_transfer_date -- 上次划转日期
            ,next_transfer_date -- 下次划转日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,failure_reason -- 失败原因
            ,fin_prod_type -- 理财产品编号
            ,financial_amount -- 理财产品金额
            ,int_min_amt -- 最小起存金额
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,remain_amt -- 协议留存金额
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,tda_acct_ccy -- 定期账户币种
            ,tda_acct_prod_type -- 定期账户产品类型
            ,tda_acct_seq_no -- 定期账户序列号
            ,tda_base_acct_no -- 定期账号
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,deposit_nature -- 核心存款性质
            ,failure_total_times -- 失败总次数
            ,unsign_reference -- 解约流水
            ,fin_fixed_amt -- 理财固定金额
            ,sign_reference -- 签约流水
            ,transfer_start_date -- 转存起始日期
            ,transfer_freq_type -- 划转频率类型
            ,last_transfer_reference -- 上一转存流水
            ,transfer_end_date -- 转存结束日期或终止日期
            ,success_times -- 累积成功次数
            ,success_total_times -- 成功总次数
            ,unsign_operate_date -- 解约操作日期|解约操作日期
            ,retry_transfer_date -- 重新尝试转存日重新尝试转存日
            ,limit_period_freq -- 限额周期限额周期
            ,limit_max_amt -- 最大限额最大限额
            ,next_calc_date -- 下一计算日期下一计算日期
            ,holding_limit -- 已占用额度已占用额度
            ,backup_date -- 
            ,month_total_amount -- 
            ,is_auto_sign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_financial_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,auto_extend -- 是否自动延期
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,failure_times -- 累积失败次数
            ,fin_prod_desc -- 理财产品类型描述
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_transfer_date -- 上次划转日期
            ,next_transfer_date -- 下次划转日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,failure_reason -- 失败原因
            ,fin_prod_type -- 理财产品编号
            ,financial_amount -- 理财产品金额
            ,int_min_amt -- 最小起存金额
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,remain_amt -- 协议留存金额
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,tda_acct_ccy -- 定期账户币种
            ,tda_acct_prod_type -- 定期账户产品类型
            ,tda_acct_seq_no -- 定期账户序列号
            ,tda_base_acct_no -- 定期账号
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,deposit_nature -- 核心存款性质
            ,failure_total_times -- 失败总次数
            ,unsign_reference -- 解约流水
            ,fin_fixed_amt -- 理财固定金额
            ,sign_reference -- 签约流水
            ,transfer_start_date -- 转存起始日期
            ,transfer_freq_type -- 划转频率类型
            ,last_transfer_reference -- 上一转存流水
            ,transfer_end_date -- 转存结束日期或终止日期
            ,success_times -- 累积成功次数
            ,success_total_times -- 成功总次数
            ,unsign_operate_date -- 解约操作日期|解约操作日期
            ,retry_transfer_date -- 重新尝试转存日重新尝试转存日
            ,limit_period_freq -- 限额周期限额周期
            ,limit_max_amt -- 最大限额最大限额
            ,next_calc_date -- 下一计算日期下一计算日期
            ,holding_limit -- 已占用额度已占用额度
            ,backup_date -- 
            ,month_total_amount -- 
            ,is_auto_sign -- 
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
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.acct_exec -- 银行客户经理编号
    ,o.acct_exec_name -- 客户经理姓名
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.agreement_type -- 协议类型
    ,o.auto_extend -- 是否自动延期
    ,o.auto_renew_rollover -- 自动转存方式
    ,o.auto_settle_flag -- 自动结清标志
    ,o.company -- 法人
    ,o.failure_times -- 累积失败次数
    ,o.fin_prod_desc -- 理财产品类型描述
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.last_transfer_date -- 上次划转日期
    ,o.next_transfer_date -- 下次划转日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.failure_reason -- 失败原因
    ,o.fin_prod_type -- 理财产品编号
    ,o.financial_amount -- 理财产品金额
    ,o.int_min_amt -- 最小起存金额
    ,o.out_sign_branch -- 解约机构
    ,o.out_sign_user_id -- 解约柜员
    ,o.remain_amt -- 协议留存金额
    ,o.sign_branch -- 签约机构
    ,o.sign_user_id -- 签约柜员
    ,o.tda_acct_ccy -- 定期账户币种
    ,o.tda_acct_prod_type -- 定期账户产品类型
    ,o.tda_acct_seq_no -- 定期账户序列号
    ,o.tda_base_acct_no -- 定期账号
    ,o.transfer_day -- 划转日
    ,o.transfer_freq -- 划转频率
    ,o.deposit_nature -- 核心存款性质
    ,o.failure_total_times -- 失败总次数
    ,o.unsign_reference -- 解约流水
    ,o.fin_fixed_amt -- 理财固定金额
    ,o.sign_reference -- 签约流水
    ,o.transfer_start_date -- 转存起始日期
    ,o.transfer_freq_type -- 划转频率类型
    ,o.last_transfer_reference -- 上一转存流水
    ,o.transfer_end_date -- 转存结束日期或终止日期
    ,o.success_times -- 累积成功次数
    ,o.success_total_times -- 成功总次数
    ,o.unsign_operate_date -- 解约操作日期|解约操作日期
    ,o.retry_transfer_date -- 重新尝试转存日重新尝试转存日
    ,o.limit_period_freq -- 限额周期限额周期
    ,o.limit_max_amt -- 最大限额最大限额
    ,o.next_calc_date -- 下一计算日期下一计算日期
    ,o.holding_limit -- 已占用额度已占用额度
    ,o.backup_date -- 
    ,o.month_total_amount -- 
    ,o.is_auto_sign -- 
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
from ${iol_schema}.ncbs_rb_agreement_financial_bk o
    left join ${iol_schema}.ncbs_rb_agreement_financial_op n
        on
            o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_financial_cl d
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
--truncate table ${iol_schema}.ncbs_rb_agreement_financial;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_financial') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_financial drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_financial add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_financial exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_financial_cl;
alter table ${iol_schema}.ncbs_rb_agreement_financial exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_financial_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_financial to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_financial_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_financial_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_financial_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_financial',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
