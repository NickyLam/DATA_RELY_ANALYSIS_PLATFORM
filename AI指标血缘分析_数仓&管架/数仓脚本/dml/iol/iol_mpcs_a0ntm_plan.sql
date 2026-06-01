/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_plan
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.mpcs_a0ntm_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ntm_plan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_plan_op purge;
drop table ${iol_schema}.mpcs_a0ntm_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_plan_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0ntm_plan where 0=1;

create table ${iol_schema}.mpcs_a0ntm_plan_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0ntm_plan where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mpcs_a0ntm_plan_op(
        org -- 机构号
        ,plan_id -- 流水号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,logical_card_no -- 逻辑卡号
        ,plan_nbr -- 信用计划号
        ,plan_type -- 信用计划类型
        ,product_cd -- 产品代码
        ,ref_nbr -- 交易参考号
        ,curr_bal -- 当前余额
        ,begin_bal -- 期初余额
        ,dispute_amt -- 争议金额
        ,tot_due_amt -- 最小还款额
        ,plan_add_date -- 记录建立日期
        ,paid_out_date -- 还清日期
        ,past_principal -- 上期本金
        ,past_interest -- 上期利息
        ,past_card_fee -- 上期年费
        ,past_ovrlmt_fee -- 上期超限费
        ,past_lpc -- 上期滞纳金
        ,past_nsf_fee -- 上期资金不足费
        ,past_txn_fee -- 上期交易费
        ,past_svc_fee -- 上期服务费
        ,past_ins -- 上期保险金额
        ,past_user_fee1 -- 上期自定义费用1
        ,past_user_fee2 -- 上期自定义费用2
        ,past_user_fee3 -- 上期自定义费用3
        ,past_user_fee4 -- 上期自定义费用4
        ,past_user_fee5 -- 上期自定义费用5
        ,past_user_fee6 -- 上期自定义费用6
        ,ctd_principal -- 当期本金
        ,ctd_interest -- 当期利息
        ,ctd_card_fee -- 当期年费
        ,ctd_ovrlmt_fee -- 当期超限费
        ,ctd_lpc -- 当期滞纳金
        ,ctd_nsf_fee -- 当期资金不足费
        ,ctd_svc_fee -- 当期服务费
        ,ctd_txn_fee -- 当期交易费
        ,ctd_ins -- 当期保险金额
        ,ctd_user_fee1 -- 当期新增自定义费用1
        ,ctd_user_fee2 -- 当期新增自定义费用2
        ,ctd_user_fee3 -- 当期新增自定义费用3
        ,ctd_user_fee4 -- 当期新增自定义费用4
        ,ctd_user_fee5 -- 当期新增自定义费用5
        ,ctd_user_fee6 -- 当期新增自定义费用6
        ,ctd_amt_db -- 当期借记金额
        ,ctd_amt_cr -- 当期贷记金额
        ,ctd_nbr_db -- 当期借记交易笔数
        ,ctd_nbr_cr -- 当期贷记交易笔数
        ,nodefbnp_int_acru -- 非延迟利息
        ,beg_defbnp_int_acru -- 往期累积延时利息
        ,ctd_defbnp_int_acru -- 当期累积延时利息
        ,user_code1 -- 用户自定义代码1
        ,user_code2 -- 用户自定义代码2
        ,user_code3 -- 用户自定义代码3
        ,user_code4 -- 用户自定义代码4
        ,user_code5 -- 用户自定义代码5
        ,user_code6 -- 用户自定义代码6
        ,user_number1 -- 用户自定义笔数1
        ,user_number2 -- 用户自定义笔数2
        ,user_number3 -- 用户自定义笔数3
        ,user_number4 -- 用户自定义笔数4
        ,user_number5 -- 用户自定义笔数5
        ,user_number6 -- 用户自定义笔数6
        ,user_field1 -- 用户自定义域1
        ,user_field2 -- 用户自定义域2
        ,user_field3 -- 用户自定义域3
        ,user_field4 -- 用户自定义域4
        ,user_field5 -- 用户自定义域5
        ,user_field6 -- 用户自定义域6
        ,user_date1 -- 用户自定义日期1
        ,user_date2 -- 用户自定义日期2
        ,user_date3 -- 用户自定义日期3
        ,user_date4 -- 用户自定义日期4
        ,user_date5 -- 用户自定义日期5
        ,user_date6 -- 用户自定义日期6
        ,user_amt1 -- 用户自定义金额1
        ,user_amt2 -- 用户自定义金额2
        ,user_amt3 -- 用户自定义金额3
        ,user_amt4 -- 用户自定义金额4
        ,user_amt5 -- 用户自定义金额5
        ,user_amt6 -- 昨日贷记卡承诺余额
        ,jpa_version -- 乐观锁版本号
        ,past_penalty -- 往期罚息
        ,ctd_penalty -- 当期罚息
        ,past_compound -- 往期复利
        ,ctd_compound -- 当期复利
        ,penalty_acru -- 罚息累计
        ,compound_acru -- 复利累计
        ,interest_rate -- 基础利率
        ,penalty_rate -- 罚息利率
        ,compound_rate -- 复利利率
        ,use_plan_rate -- 是否使用plan的利率
        ,last_pmt_date -- 上一还款日期
        ,term -- 所在贷款期数
        ,calc_type -- 计费类型
        ,calc_cycle -- 计费周期
        ,fee_rate -- 费率
        ,last_fee_date -- 上一收费日
        ,next_fee_date -- 下一收费日
        ,txn_seq -- 交易流水号
        ,first_dd_date -- 首次约定还款日期
        ,consumer_trans_id -- 业务流水号
        ,sys_trans_id -- 系统调用流水号
        ,buser_field21 -- 系统备用域21
        ,sub_terminal_type -- 终端类型
        ,sub_merch_id -- 二级商户编码
        ,sub_merch_name -- 二级商户名称
        ,wares_desc -- 商品信息
        ,last_modified_datetime -- 修改时间
        ,original_amt -- 原始交易本金
        ,interest_calc_base -- 计息基数
        ,created_datetime -- 创建时间
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.org -- 机构号
    ,n.plan_id -- 流水号
    ,n.acct_no -- 账户编号
    ,n.acct_type -- 账户类型
    ,n.logical_card_no -- 逻辑卡号
    ,n.plan_nbr -- 信用计划号
    ,n.plan_type -- 信用计划类型
    ,n.product_cd -- 产品代码
    ,n.ref_nbr -- 交易参考号
    ,n.curr_bal -- 当前余额
    ,n.begin_bal -- 期初余额
    ,n.dispute_amt -- 争议金额
    ,n.tot_due_amt -- 最小还款额
    ,n.plan_add_date -- 记录建立日期
    ,n.paid_out_date -- 还清日期
    ,n.past_principal -- 上期本金
    ,n.past_interest -- 上期利息
    ,n.past_card_fee -- 上期年费
    ,n.past_ovrlmt_fee -- 上期超限费
    ,n.past_lpc -- 上期滞纳金
    ,n.past_nsf_fee -- 上期资金不足费
    ,n.past_txn_fee -- 上期交易费
    ,n.past_svc_fee -- 上期服务费
    ,n.past_ins -- 上期保险金额
    ,n.past_user_fee1 -- 上期自定义费用1
    ,n.past_user_fee2 -- 上期自定义费用2
    ,n.past_user_fee3 -- 上期自定义费用3
    ,n.past_user_fee4 -- 上期自定义费用4
    ,n.past_user_fee5 -- 上期自定义费用5
    ,n.past_user_fee6 -- 上期自定义费用6
    ,n.ctd_principal -- 当期本金
    ,n.ctd_interest -- 当期利息
    ,n.ctd_card_fee -- 当期年费
    ,n.ctd_ovrlmt_fee -- 当期超限费
    ,n.ctd_lpc -- 当期滞纳金
    ,n.ctd_nsf_fee -- 当期资金不足费
    ,n.ctd_svc_fee -- 当期服务费
    ,n.ctd_txn_fee -- 当期交易费
    ,n.ctd_ins -- 当期保险金额
    ,n.ctd_user_fee1 -- 当期新增自定义费用1
    ,n.ctd_user_fee2 -- 当期新增自定义费用2
    ,n.ctd_user_fee3 -- 当期新增自定义费用3
    ,n.ctd_user_fee4 -- 当期新增自定义费用4
    ,n.ctd_user_fee5 -- 当期新增自定义费用5
    ,n.ctd_user_fee6 -- 当期新增自定义费用6
    ,n.ctd_amt_db -- 当期借记金额
    ,n.ctd_amt_cr -- 当期贷记金额
    ,n.ctd_nbr_db -- 当期借记交易笔数
    ,n.ctd_nbr_cr -- 当期贷记交易笔数
    ,n.nodefbnp_int_acru -- 非延迟利息
    ,n.beg_defbnp_int_acru -- 往期累积延时利息
    ,n.ctd_defbnp_int_acru -- 当期累积延时利息
    ,n.user_code1 -- 用户自定义代码1
    ,n.user_code2 -- 用户自定义代码2
    ,n.user_code3 -- 用户自定义代码3
    ,n.user_code4 -- 用户自定义代码4
    ,n.user_code5 -- 用户自定义代码5
    ,n.user_code6 -- 用户自定义代码6
    ,n.user_number1 -- 用户自定义笔数1
    ,n.user_number2 -- 用户自定义笔数2
    ,n.user_number3 -- 用户自定义笔数3
    ,n.user_number4 -- 用户自定义笔数4
    ,n.user_number5 -- 用户自定义笔数5
    ,n.user_number6 -- 用户自定义笔数6
    ,n.user_field1 -- 用户自定义域1
    ,n.user_field2 -- 用户自定义域2
    ,n.user_field3 -- 用户自定义域3
    ,n.user_field4 -- 用户自定义域4
    ,n.user_field5 -- 用户自定义域5
    ,n.user_field6 -- 用户自定义域6
    ,n.user_date1 -- 用户自定义日期1
    ,n.user_date2 -- 用户自定义日期2
    ,n.user_date3 -- 用户自定义日期3
    ,n.user_date4 -- 用户自定义日期4
    ,n.user_date5 -- 用户自定义日期5
    ,n.user_date6 -- 用户自定义日期6
    ,n.user_amt1 -- 用户自定义金额1
    ,n.user_amt2 -- 用户自定义金额2
    ,n.user_amt3 -- 用户自定义金额3
    ,n.user_amt4 -- 用户自定义金额4
    ,n.user_amt5 -- 用户自定义金额5
    ,n.user_amt6 -- 昨日贷记卡承诺余额
    ,n.jpa_version -- 乐观锁版本号
    ,n.past_penalty -- 往期罚息
    ,n.ctd_penalty -- 当期罚息
    ,n.past_compound -- 往期复利
    ,n.ctd_compound -- 当期复利
    ,n.penalty_acru -- 罚息累计
    ,n.compound_acru -- 复利累计
    ,n.interest_rate -- 基础利率
    ,n.penalty_rate -- 罚息利率
    ,n.compound_rate -- 复利利率
    ,n.use_plan_rate -- 是否使用plan的利率
    ,n.last_pmt_date -- 上一还款日期
    ,n.term -- 所在贷款期数
    ,n.calc_type -- 计费类型
    ,n.calc_cycle -- 计费周期
    ,n.fee_rate -- 费率
    ,n.last_fee_date -- 上一收费日
    ,n.next_fee_date -- 下一收费日
    ,n.txn_seq -- 交易流水号
    ,n.first_dd_date -- 首次约定还款日期
    ,n.consumer_trans_id -- 业务流水号
    ,n.sys_trans_id -- 系统调用流水号
    ,n.buser_field21 -- 系统备用域21
    ,n.sub_terminal_type -- 终端类型
    ,n.sub_merch_id -- 二级商户编码
    ,n.sub_merch_name -- 二级商户名称
    ,n.wares_desc -- 商品信息
    ,n.last_modified_datetime -- 修改时间
    ,n.original_amt -- 原始交易本金
    ,n.interest_calc_base -- 计息基数
    ,n.created_datetime -- 创建时间
    ,n.batchfilename -- 批量文件名
    ,n.seqno -- 序列号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0ntm_plan_bk o
    right join (select * from ${itl_schema}.mpcs_a0ntm_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.plan_id = n.plan_id
where (
        o.plan_id is null
    )
    or (
        o.org <> n.org
        or o.acct_no <> n.acct_no
        or o.acct_type <> n.acct_type
        or o.logical_card_no <> n.logical_card_no
        or o.plan_nbr <> n.plan_nbr
        or o.plan_type <> n.plan_type
        or o.product_cd <> n.product_cd
        or o.ref_nbr <> n.ref_nbr
        or o.curr_bal <> n.curr_bal
        or o.begin_bal <> n.begin_bal
        or o.dispute_amt <> n.dispute_amt
        or o.tot_due_amt <> n.tot_due_amt
        or o.plan_add_date <> n.plan_add_date
        or o.paid_out_date <> n.paid_out_date
        or o.past_principal <> n.past_principal
        or o.past_interest <> n.past_interest
        or o.past_card_fee <> n.past_card_fee
        or o.past_ovrlmt_fee <> n.past_ovrlmt_fee
        or o.past_lpc <> n.past_lpc
        or o.past_nsf_fee <> n.past_nsf_fee
        or o.past_txn_fee <> n.past_txn_fee
        or o.past_svc_fee <> n.past_svc_fee
        or o.past_ins <> n.past_ins
        or o.past_user_fee1 <> n.past_user_fee1
        or o.past_user_fee2 <> n.past_user_fee2
        or o.past_user_fee3 <> n.past_user_fee3
        or o.past_user_fee4 <> n.past_user_fee4
        or o.past_user_fee5 <> n.past_user_fee5
        or o.past_user_fee6 <> n.past_user_fee6
        or o.ctd_principal <> n.ctd_principal
        or o.ctd_interest <> n.ctd_interest
        or o.ctd_card_fee <> n.ctd_card_fee
        or o.ctd_ovrlmt_fee <> n.ctd_ovrlmt_fee
        or o.ctd_lpc <> n.ctd_lpc
        or o.ctd_nsf_fee <> n.ctd_nsf_fee
        or o.ctd_svc_fee <> n.ctd_svc_fee
        or o.ctd_txn_fee <> n.ctd_txn_fee
        or o.ctd_ins <> n.ctd_ins
        or o.ctd_user_fee1 <> n.ctd_user_fee1
        or o.ctd_user_fee2 <> n.ctd_user_fee2
        or o.ctd_user_fee3 <> n.ctd_user_fee3
        or o.ctd_user_fee4 <> n.ctd_user_fee4
        or o.ctd_user_fee5 <> n.ctd_user_fee5
        or o.ctd_user_fee6 <> n.ctd_user_fee6
        or o.ctd_amt_db <> n.ctd_amt_db
        or o.ctd_amt_cr <> n.ctd_amt_cr
        or o.ctd_nbr_db <> n.ctd_nbr_db
        or o.ctd_nbr_cr <> n.ctd_nbr_cr
        or o.nodefbnp_int_acru <> n.nodefbnp_int_acru
        or o.beg_defbnp_int_acru <> n.beg_defbnp_int_acru
        or o.ctd_defbnp_int_acru <> n.ctd_defbnp_int_acru
        or o.user_code1 <> n.user_code1
        or o.user_code2 <> n.user_code2
        or o.user_code3 <> n.user_code3
        or o.user_code4 <> n.user_code4
        or o.user_code5 <> n.user_code5
        or o.user_code6 <> n.user_code6
        or o.user_number1 <> n.user_number1
        or o.user_number2 <> n.user_number2
        or o.user_number3 <> n.user_number3
        or o.user_number4 <> n.user_number4
        or o.user_number5 <> n.user_number5
        or o.user_number6 <> n.user_number6
        or o.user_field1 <> n.user_field1
        or o.user_field2 <> n.user_field2
        or o.user_field3 <> n.user_field3
        or o.user_field4 <> n.user_field4
        or o.user_field5 <> n.user_field5
        or o.user_field6 <> n.user_field6
        or o.user_date1 <> n.user_date1
        or o.user_date2 <> n.user_date2
        or o.user_date3 <> n.user_date3
        or o.user_date4 <> n.user_date4
        or o.user_date5 <> n.user_date5
        or o.user_date6 <> n.user_date6
        or o.user_amt1 <> n.user_amt1
        or o.user_amt2 <> n.user_amt2
        or o.user_amt3 <> n.user_amt3
        or o.user_amt4 <> n.user_amt4
        or o.user_amt5 <> n.user_amt5
        or o.user_amt6 <> n.user_amt6
        or o.jpa_version <> n.jpa_version
        or o.past_penalty <> n.past_penalty
        or o.ctd_penalty <> n.ctd_penalty
        or o.past_compound <> n.past_compound
        or o.ctd_compound <> n.ctd_compound
        or o.penalty_acru <> n.penalty_acru
        or o.compound_acru <> n.compound_acru
        or o.interest_rate <> n.interest_rate
        or o.penalty_rate <> n.penalty_rate
        or o.compound_rate <> n.compound_rate
        or o.use_plan_rate <> n.use_plan_rate
        or o.last_pmt_date <> n.last_pmt_date
        or o.term <> n.term
        or o.calc_type <> n.calc_type
        or o.calc_cycle <> n.calc_cycle
        or o.fee_rate <> n.fee_rate
        or o.last_fee_date <> n.last_fee_date
        or o.next_fee_date <> n.next_fee_date
        or o.txn_seq <> n.txn_seq
        or o.first_dd_date <> n.first_dd_date
        or o.consumer_trans_id <> n.consumer_trans_id
        or o.sys_trans_id <> n.sys_trans_id
        or o.buser_field21 <> n.buser_field21
        or o.sub_terminal_type <> n.sub_terminal_type
        or o.sub_merch_id <> n.sub_merch_id
        or o.sub_merch_name <> n.sub_merch_name
        or o.wares_desc <> n.wares_desc
        or o.last_modified_datetime <> n.last_modified_datetime
        or o.original_amt <> n.original_amt
        or o.interest_calc_base <> n.interest_calc_base
        or o.created_datetime <> n.created_datetime
        or o.batchfilename <> n.batchfilename
        or o.seqno <> n.seqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_plan_cl(
            org -- 机构号
        ,plan_id -- 流水号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,logical_card_no -- 逻辑卡号
        ,plan_nbr -- 信用计划号
        ,plan_type -- 信用计划类型
        ,product_cd -- 产品代码
        ,ref_nbr -- 交易参考号
        ,curr_bal -- 当前余额
        ,begin_bal -- 期初余额
        ,dispute_amt -- 争议金额
        ,tot_due_amt -- 最小还款额
        ,plan_add_date -- 记录建立日期
        ,paid_out_date -- 还清日期
        ,past_principal -- 上期本金
        ,past_interest -- 上期利息
        ,past_card_fee -- 上期年费
        ,past_ovrlmt_fee -- 上期超限费
        ,past_lpc -- 上期滞纳金
        ,past_nsf_fee -- 上期资金不足费
        ,past_txn_fee -- 上期交易费
        ,past_svc_fee -- 上期服务费
        ,past_ins -- 上期保险金额
        ,past_user_fee1 -- 上期自定义费用1
        ,past_user_fee2 -- 上期自定义费用2
        ,past_user_fee3 -- 上期自定义费用3
        ,past_user_fee4 -- 上期自定义费用4
        ,past_user_fee5 -- 上期自定义费用5
        ,past_user_fee6 -- 上期自定义费用6
        ,ctd_principal -- 当期本金
        ,ctd_interest -- 当期利息
        ,ctd_card_fee -- 当期年费
        ,ctd_ovrlmt_fee -- 当期超限费
        ,ctd_lpc -- 当期滞纳金
        ,ctd_nsf_fee -- 当期资金不足费
        ,ctd_svc_fee -- 当期服务费
        ,ctd_txn_fee -- 当期交易费
        ,ctd_ins -- 当期保险金额
        ,ctd_user_fee1 -- 当期新增自定义费用1
        ,ctd_user_fee2 -- 当期新增自定义费用2
        ,ctd_user_fee3 -- 当期新增自定义费用3
        ,ctd_user_fee4 -- 当期新增自定义费用4
        ,ctd_user_fee5 -- 当期新增自定义费用5
        ,ctd_user_fee6 -- 当期新增自定义费用6
        ,ctd_amt_db -- 当期借记金额
        ,ctd_amt_cr -- 当期贷记金额
        ,ctd_nbr_db -- 当期借记交易笔数
        ,ctd_nbr_cr -- 当期贷记交易笔数
        ,nodefbnp_int_acru -- 非延迟利息
        ,beg_defbnp_int_acru -- 往期累积延时利息
        ,ctd_defbnp_int_acru -- 当期累积延时利息
        ,user_code1 -- 用户自定义代码1
        ,user_code2 -- 用户自定义代码2
        ,user_code3 -- 用户自定义代码3
        ,user_code4 -- 用户自定义代码4
        ,user_code5 -- 用户自定义代码5
        ,user_code6 -- 用户自定义代码6
        ,user_number1 -- 用户自定义笔数1
        ,user_number2 -- 用户自定义笔数2
        ,user_number3 -- 用户自定义笔数3
        ,user_number4 -- 用户自定义笔数4
        ,user_number5 -- 用户自定义笔数5
        ,user_number6 -- 用户自定义笔数6
        ,user_field1 -- 用户自定义域1
        ,user_field2 -- 用户自定义域2
        ,user_field3 -- 用户自定义域3
        ,user_field4 -- 用户自定义域4
        ,user_field5 -- 用户自定义域5
        ,user_field6 -- 用户自定义域6
        ,user_date1 -- 用户自定义日期1
        ,user_date2 -- 用户自定义日期2
        ,user_date3 -- 用户自定义日期3
        ,user_date4 -- 用户自定义日期4
        ,user_date5 -- 用户自定义日期5
        ,user_date6 -- 用户自定义日期6
        ,user_amt1 -- 用户自定义金额1
        ,user_amt2 -- 用户自定义金额2
        ,user_amt3 -- 用户自定义金额3
        ,user_amt4 -- 用户自定义金额4
        ,user_amt5 -- 用户自定义金额5
        ,user_amt6 -- 昨日贷记卡承诺余额
        ,jpa_version -- 乐观锁版本号
        ,past_penalty -- 往期罚息
        ,ctd_penalty -- 当期罚息
        ,past_compound -- 往期复利
        ,ctd_compound -- 当期复利
        ,penalty_acru -- 罚息累计
        ,compound_acru -- 复利累计
        ,interest_rate -- 基础利率
        ,penalty_rate -- 罚息利率
        ,compound_rate -- 复利利率
        ,use_plan_rate -- 是否使用plan的利率
        ,last_pmt_date -- 上一还款日期
        ,term -- 所在贷款期数
        ,calc_type -- 计费类型
        ,calc_cycle -- 计费周期
        ,fee_rate -- 费率
        ,last_fee_date -- 上一收费日
        ,next_fee_date -- 下一收费日
        ,txn_seq -- 交易流水号
        ,first_dd_date -- 首次约定还款日期
        ,consumer_trans_id -- 业务流水号
        ,sys_trans_id -- 系统调用流水号
        ,buser_field21 -- 系统备用域21
        ,sub_terminal_type -- 终端类型
        ,sub_merch_id -- 二级商户编码
        ,sub_merch_name -- 二级商户名称
        ,wares_desc -- 商品信息
        ,last_modified_datetime -- 修改时间
        ,original_amt -- 原始交易本金
        ,interest_calc_base -- 计息基数
        ,created_datetime -- 创建时间
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_plan_op(
            org -- 机构号
        ,plan_id -- 流水号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,logical_card_no -- 逻辑卡号
        ,plan_nbr -- 信用计划号
        ,plan_type -- 信用计划类型
        ,product_cd -- 产品代码
        ,ref_nbr -- 交易参考号
        ,curr_bal -- 当前余额
        ,begin_bal -- 期初余额
        ,dispute_amt -- 争议金额
        ,tot_due_amt -- 最小还款额
        ,plan_add_date -- 记录建立日期
        ,paid_out_date -- 还清日期
        ,past_principal -- 上期本金
        ,past_interest -- 上期利息
        ,past_card_fee -- 上期年费
        ,past_ovrlmt_fee -- 上期超限费
        ,past_lpc -- 上期滞纳金
        ,past_nsf_fee -- 上期资金不足费
        ,past_txn_fee -- 上期交易费
        ,past_svc_fee -- 上期服务费
        ,past_ins -- 上期保险金额
        ,past_user_fee1 -- 上期自定义费用1
        ,past_user_fee2 -- 上期自定义费用2
        ,past_user_fee3 -- 上期自定义费用3
        ,past_user_fee4 -- 上期自定义费用4
        ,past_user_fee5 -- 上期自定义费用5
        ,past_user_fee6 -- 上期自定义费用6
        ,ctd_principal -- 当期本金
        ,ctd_interest -- 当期利息
        ,ctd_card_fee -- 当期年费
        ,ctd_ovrlmt_fee -- 当期超限费
        ,ctd_lpc -- 当期滞纳金
        ,ctd_nsf_fee -- 当期资金不足费
        ,ctd_svc_fee -- 当期服务费
        ,ctd_txn_fee -- 当期交易费
        ,ctd_ins -- 当期保险金额
        ,ctd_user_fee1 -- 当期新增自定义费用1
        ,ctd_user_fee2 -- 当期新增自定义费用2
        ,ctd_user_fee3 -- 当期新增自定义费用3
        ,ctd_user_fee4 -- 当期新增自定义费用4
        ,ctd_user_fee5 -- 当期新增自定义费用5
        ,ctd_user_fee6 -- 当期新增自定义费用6
        ,ctd_amt_db -- 当期借记金额
        ,ctd_amt_cr -- 当期贷记金额
        ,ctd_nbr_db -- 当期借记交易笔数
        ,ctd_nbr_cr -- 当期贷记交易笔数
        ,nodefbnp_int_acru -- 非延迟利息
        ,beg_defbnp_int_acru -- 往期累积延时利息
        ,ctd_defbnp_int_acru -- 当期累积延时利息
        ,user_code1 -- 用户自定义代码1
        ,user_code2 -- 用户自定义代码2
        ,user_code3 -- 用户自定义代码3
        ,user_code4 -- 用户自定义代码4
        ,user_code5 -- 用户自定义代码5
        ,user_code6 -- 用户自定义代码6
        ,user_number1 -- 用户自定义笔数1
        ,user_number2 -- 用户自定义笔数2
        ,user_number3 -- 用户自定义笔数3
        ,user_number4 -- 用户自定义笔数4
        ,user_number5 -- 用户自定义笔数5
        ,user_number6 -- 用户自定义笔数6
        ,user_field1 -- 用户自定义域1
        ,user_field2 -- 用户自定义域2
        ,user_field3 -- 用户自定义域3
        ,user_field4 -- 用户自定义域4
        ,user_field5 -- 用户自定义域5
        ,user_field6 -- 用户自定义域6
        ,user_date1 -- 用户自定义日期1
        ,user_date2 -- 用户自定义日期2
        ,user_date3 -- 用户自定义日期3
        ,user_date4 -- 用户自定义日期4
        ,user_date5 -- 用户自定义日期5
        ,user_date6 -- 用户自定义日期6
        ,user_amt1 -- 用户自定义金额1
        ,user_amt2 -- 用户自定义金额2
        ,user_amt3 -- 用户自定义金额3
        ,user_amt4 -- 用户自定义金额4
        ,user_amt5 -- 用户自定义金额5
        ,user_amt6 -- 昨日贷记卡承诺余额
        ,jpa_version -- 乐观锁版本号
        ,past_penalty -- 往期罚息
        ,ctd_penalty -- 当期罚息
        ,past_compound -- 往期复利
        ,ctd_compound -- 当期复利
        ,penalty_acru -- 罚息累计
        ,compound_acru -- 复利累计
        ,interest_rate -- 基础利率
        ,penalty_rate -- 罚息利率
        ,compound_rate -- 复利利率
        ,use_plan_rate -- 是否使用plan的利率
        ,last_pmt_date -- 上一还款日期
        ,term -- 所在贷款期数
        ,calc_type -- 计费类型
        ,calc_cycle -- 计费周期
        ,fee_rate -- 费率
        ,last_fee_date -- 上一收费日
        ,next_fee_date -- 下一收费日
        ,txn_seq -- 交易流水号
        ,first_dd_date -- 首次约定还款日期
        ,consumer_trans_id -- 业务流水号
        ,sys_trans_id -- 系统调用流水号
        ,buser_field21 -- 系统备用域21
        ,sub_terminal_type -- 终端类型
        ,sub_merch_id -- 二级商户编码
        ,sub_merch_name -- 二级商户名称
        ,wares_desc -- 商品信息
        ,last_modified_datetime -- 修改时间
        ,original_amt -- 原始交易本金
        ,interest_calc_base -- 计息基数
        ,created_datetime -- 创建时间
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.plan_id -- 流水号
    ,o.acct_no -- 账户编号
    ,o.acct_type -- 账户类型
    ,o.logical_card_no -- 逻辑卡号
    ,o.plan_nbr -- 信用计划号
    ,o.plan_type -- 信用计划类型
    ,o.product_cd -- 产品代码
    ,o.ref_nbr -- 交易参考号
    ,o.curr_bal -- 当前余额
    ,o.begin_bal -- 期初余额
    ,o.dispute_amt -- 争议金额
    ,o.tot_due_amt -- 最小还款额
    ,o.plan_add_date -- 记录建立日期
    ,o.paid_out_date -- 还清日期
    ,o.past_principal -- 上期本金
    ,o.past_interest -- 上期利息
    ,o.past_card_fee -- 上期年费
    ,o.past_ovrlmt_fee -- 上期超限费
    ,o.past_lpc -- 上期滞纳金
    ,o.past_nsf_fee -- 上期资金不足费
    ,o.past_txn_fee -- 上期交易费
    ,o.past_svc_fee -- 上期服务费
    ,o.past_ins -- 上期保险金额
    ,o.past_user_fee1 -- 上期自定义费用1
    ,o.past_user_fee2 -- 上期自定义费用2
    ,o.past_user_fee3 -- 上期自定义费用3
    ,o.past_user_fee4 -- 上期自定义费用4
    ,o.past_user_fee5 -- 上期自定义费用5
    ,o.past_user_fee6 -- 上期自定义费用6
    ,o.ctd_principal -- 当期本金
    ,o.ctd_interest -- 当期利息
    ,o.ctd_card_fee -- 当期年费
    ,o.ctd_ovrlmt_fee -- 当期超限费
    ,o.ctd_lpc -- 当期滞纳金
    ,o.ctd_nsf_fee -- 当期资金不足费
    ,o.ctd_svc_fee -- 当期服务费
    ,o.ctd_txn_fee -- 当期交易费
    ,o.ctd_ins -- 当期保险金额
    ,o.ctd_user_fee1 -- 当期新增自定义费用1
    ,o.ctd_user_fee2 -- 当期新增自定义费用2
    ,o.ctd_user_fee3 -- 当期新增自定义费用3
    ,o.ctd_user_fee4 -- 当期新增自定义费用4
    ,o.ctd_user_fee5 -- 当期新增自定义费用5
    ,o.ctd_user_fee6 -- 当期新增自定义费用6
    ,o.ctd_amt_db -- 当期借记金额
    ,o.ctd_amt_cr -- 当期贷记金额
    ,o.ctd_nbr_db -- 当期借记交易笔数
    ,o.ctd_nbr_cr -- 当期贷记交易笔数
    ,o.nodefbnp_int_acru -- 非延迟利息
    ,o.beg_defbnp_int_acru -- 往期累积延时利息
    ,o.ctd_defbnp_int_acru -- 当期累积延时利息
    ,o.user_code1 -- 用户自定义代码1
    ,o.user_code2 -- 用户自定义代码2
    ,o.user_code3 -- 用户自定义代码3
    ,o.user_code4 -- 用户自定义代码4
    ,o.user_code5 -- 用户自定义代码5
    ,o.user_code6 -- 用户自定义代码6
    ,o.user_number1 -- 用户自定义笔数1
    ,o.user_number2 -- 用户自定义笔数2
    ,o.user_number3 -- 用户自定义笔数3
    ,o.user_number4 -- 用户自定义笔数4
    ,o.user_number5 -- 用户自定义笔数5
    ,o.user_number6 -- 用户自定义笔数6
    ,o.user_field1 -- 用户自定义域1
    ,o.user_field2 -- 用户自定义域2
    ,o.user_field3 -- 用户自定义域3
    ,o.user_field4 -- 用户自定义域4
    ,o.user_field5 -- 用户自定义域5
    ,o.user_field6 -- 用户自定义域6
    ,o.user_date1 -- 用户自定义日期1
    ,o.user_date2 -- 用户自定义日期2
    ,o.user_date3 -- 用户自定义日期3
    ,o.user_date4 -- 用户自定义日期4
    ,o.user_date5 -- 用户自定义日期5
    ,o.user_date6 -- 用户自定义日期6
    ,o.user_amt1 -- 用户自定义金额1
    ,o.user_amt2 -- 用户自定义金额2
    ,o.user_amt3 -- 用户自定义金额3
    ,o.user_amt4 -- 用户自定义金额4
    ,o.user_amt5 -- 用户自定义金额5
    ,o.user_amt6 -- 昨日贷记卡承诺余额
    ,o.jpa_version -- 乐观锁版本号
    ,o.past_penalty -- 往期罚息
    ,o.ctd_penalty -- 当期罚息
    ,o.past_compound -- 往期复利
    ,o.ctd_compound -- 当期复利
    ,o.penalty_acru -- 罚息累计
    ,o.compound_acru -- 复利累计
    ,o.interest_rate -- 基础利率
    ,o.penalty_rate -- 罚息利率
    ,o.compound_rate -- 复利利率
    ,o.use_plan_rate -- 是否使用plan的利率
    ,o.last_pmt_date -- 上一还款日期
    ,o.term -- 所在贷款期数
    ,o.calc_type -- 计费类型
    ,o.calc_cycle -- 计费周期
    ,o.fee_rate -- 费率
    ,o.last_fee_date -- 上一收费日
    ,o.next_fee_date -- 下一收费日
    ,o.txn_seq -- 交易流水号
    ,o.first_dd_date -- 首次约定还款日期
    ,o.consumer_trans_id -- 业务流水号
    ,o.sys_trans_id -- 系统调用流水号
    ,o.buser_field21 -- 系统备用域21
    ,o.sub_terminal_type -- 终端类型
    ,o.sub_merch_id -- 二级商户编码
    ,o.sub_merch_name -- 二级商户名称
    ,o.wares_desc -- 商品信息
    ,o.last_modified_datetime -- 修改时间
    ,o.original_amt -- 原始交易本金
    ,o.interest_calc_base -- 计息基数
    ,o.created_datetime -- 创建时间
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0ntm_plan_bk o
    left join ${iol_schema}.mpcs_a0ntm_plan_op n
        on
            o.plan_id = n.plan_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0ntm_plan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0ntm_plan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0ntm_plan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0ntm_plan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0ntm_plan exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0ntm_plan_cl;
alter table ${iol_schema}.mpcs_a0ntm_plan exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ntm_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_plan_op purge;
drop table ${iol_schema}.mpcs_a0ntm_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ntm_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
