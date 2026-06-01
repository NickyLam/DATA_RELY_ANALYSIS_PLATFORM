/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_account
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
create table ${iol_schema}.mpcs_a0ntm_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ntm_account
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_account_op purge;
drop table ${iol_schema}.mpcs_a0ntm_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_account_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0ntm_account where 0=1;

create table ${iol_schema}.mpcs_a0ntm_account_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0ntm_account where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mpcs_a0ntm_account_op(
        org -- 机构号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,cust_id -- 客户编号
        ,cust_limit_id -- 客户额度ID
        ,product_cd -- 产品代码
        ,default_logical_card_no -- 默认逻辑卡号
        ,curr_cd -- 币种
        ,credit_limit -- 授信额度
        ,temp_limit -- 临时额度
        ,temp_limit_begin_date -- 临时额度开始日期
        ,temp_limit_end_date -- 临时额度结束日期
        ,cash_limit_rt -- 取现额度比例
        ,ovrlmt_rate -- 授权超限比例
        ,loan_limit_rt -- 额度内分期额度比例
        ,curr_bal -- 当前余额
        ,cash_bal -- 取现余额
        ,principal_bal -- 本金余额
        ,loan_bal -- 额度内分期余额
        ,dispute_amt -- 争议金额
        ,begin_bal -- 上一到期日余额
        ,pmt_due_day_bal -- 到期还款日余额
        ,qual_grace_bal -- 全部应还款额
        ,grace_days_full_ind -- 是否已全额还款
        ,point_begin_bal -- 期初积分余额
        ,ctd_earned_points -- 当期新增积分
        ,ctd_disb_points -- 当期兑换积分
        ,ctd_adj_points -- 当期调整积分
        ,point_bal -- 积分余额
        ,setup_date -- 创建日期
        ,dorment_date -- 账户睡眠日期
        ,reinstate_date -- 账户恢复活动日期
        ,ovrlmt_date -- 超限日期
        ,ovrlmt_nbr_of_cyc -- 连续超限账期
        ,name -- 姓名
        ,gender -- 性别
        ,owning_branch -- 发卡网点
        ,mobile_no -- 移动电话
        ,corp_name -- 公司名称
        ,billing_cycle -- 还款日
        ,stmt_flag -- 账单标志
        ,stmt_mail_addr_ind -- 账单寄送地址标志
        ,stmt_media_type -- 账单介质类型
        ,stmt_country_cd -- 账单地址国家代码
        ,stmt_state -- 账单地址省份
        ,stmt_city -- 账单地址城市
        ,stmt_district -- 账单地址行政区
        ,stmt_address -- 账单地址
        ,stmt_zip -- 账单地址邮政编码
        ,email -- 电子邮箱
        ,buser_field21 -- 系统备用域21
        ,age_cd -- 拖欠月数
        ,user_field22 -- 系统备用域22
        ,unmatch_db -- 未入账借记金额
        ,unmatch_cash -- 未匹配取现金额
        ,unmatch_cr -- 未入账贷记金额
        ,dd_ind -- 约定还款类型
        ,dd_bank_name -- 约定还款银行名称
        ,dd_bank_branch -- 约定还款开户行号
        ,dd_bank_acct_no -- 约定还款扣款账号
        ,dd_bank_acct_name -- 约定还款扣款账户姓名
        ,last_dd_amt -- 上期约定还款金额
        ,last_dd_date -- 上期约定还款日期
        ,dual_billing_flag -- 本币溢缴款还外币指示
        ,last_pmt_amt -- 上笔还款金额
        ,last_pmt_date -- 上个还款日期
        ,last_stmt_date -- 上个到期还款日期
        ,last_pmt_due_date -- 上个到期还款日期
        ,last_aging_date -- 上个逾期月数提升日期
        ,collect_date -- 入催日期
        ,collect_out_date -- 出催收队列日期
        ,next_stmt_date -- 下个到期还款日期
        ,pmt_due_date -- 到期还款日期
        ,dd_date -- 约定还款日期
        ,grace_date -- 宽限日期
        ,dlbl_date -- 本币还外币日期
        ,closed_date -- 最终销户日期
        ,first_stmt_date -- 首个到期还款日期
        ,cancel_date -- 销户日期
        ,charge_off_date -- 转呆账日期
        ,first_purchase_date -- 首次消费日期
        ,first_purchase_amt -- 首次消费金额
        ,tot_due_amt -- 最小还款额
        ,curr_due_amt -- 当期最小还款额
        ,past_due_amt1 -- 上个月最小还款额
        ,past_due_amt2 -- 上2个月最小还款额
        ,past_due_amt3 -- 上3个月最小还款额
        ,past_due_amt4 -- 上4个月最小还款额
        ,past_due_amt5 -- 上5个月最小还款额
        ,past_due_amt6 -- 上6个月最小还款额
        ,past_due_amt7 -- 上7个月最小还款额
        ,past_due_amt8 -- 上8个月最小还款额
        ,ctd_cash_amt -- 当期取现金额
        ,ctd_cash_cnt -- 当期取现笔数
        ,ctd_retail_amt -- 当期消费金额
        ,ctd_retail_cnt -- 当期消费笔数
        ,ctd_payment_amt -- 当期还款金额
        ,ctd_payment_cnt -- 当期还款笔数
        ,ctd_db_adj_amt -- 当期借记调整金额
        ,ctd_db_adj_cnt -- 当期借记调整笔数
        ,ctd_cr_adj_amt -- 当期贷记调整金额
        ,ctd_cr_adj_cnt -- 当期贷记调整笔数
        ,ctd_fee_amt -- 当期费用金额
        ,ctd_fee_cnt -- 当期费用笔数
        ,ctd_interest_amt -- 当期利息金额
        ,ctd_interest_cnt -- 当期利息笔数
        ,ctd_refund_amt -- 当期退货金额
        ,ctd_refund_cnt -- 当期退货笔数
        ,ctd_hi_ovrlmt_amt -- 当期最高超限金额
        ,mtd_retail_amt -- 本月消费金额
        ,mtd_retail_cnt -- 本月消费笔数
        ,mtd_cash_amt -- 本月取现金额
        ,mtd_cash_cnt -- 本月取现笔数
        ,mtd_refund_amt -- 本月退货金额
        ,mtd_refund_cnt -- 本月退货笔数
        ,ytd_retail_amt -- 本年消费金额
        ,ytd_retail_cnt -- 本年消费笔数
        ,ytd_cash_amt -- 本年取现金额
        ,ytd_cash_cnt -- 本年取现笔数
        ,ytd_refund_amt -- 本年退货金额
        ,ytd_refund_cnt -- 本年退货笔数
        ,ytd_ovrlmt_fee_amt -- 本年超限费收取金额
        ,ytd_ovrlmt_fee_cnt -- 本年超限费收取笔数
        ,ytd_lpc_amt -- 本年滞纳金收取金额
        ,ytd_lpc_cnt -- 本年滞纳金收取笔数
        ,ltd_retail_amt -- 历史消费金额
        ,ltd_retail_cnt -- 历史消费笔数
        ,ltd_cash_amt -- 历史取现金额
        ,ltd_cash_cnt -- 历史取现笔数
        ,ltd_refund_amt -- 历史退货金额
        ,ltd_refund_cnt -- 历史退货笔数
        ,ltd_highest_principal -- 历史最高本金欠款
        ,ltd_highest_cr_bal -- 历史最高溢缴款
        ,ltd_highest_bal -- 历史最高余额
        ,buser_field23 -- 系统备用域23
        ,buser_field24 -- 系统备用域24
        ,buser_field25 -- 系统备用域25
        ,buser_field26 -- 系统备用域26
        ,buser_field27 -- 系统备用域27
        ,waive_ovlfee_ind -- 是否免除超限费
        ,waive_cardfee_ind -- 是否免除年费
        ,waive_latefee_ind -- 是否免除滞纳金
        ,waive_svcfee_ind -- 是否免除服务费
        ,user_code1 -- 用户自定义代码1
        ,user_code2 -- 用户自定义代码2
        ,user_code3 -- 用户自定义代码3
        ,user_code4 -- 用户自定义代码4
        ,user_code5 -- 用户自定义代码5
        ,user_code6 -- 用户自定义代码6
        ,user_date1 -- 用户自定义日期1
        ,user_date2 -- 上次调额日期
        ,user_date3 -- 用户自定义日期3
        ,user_date4 -- 用户自定义日期4
        ,user_date5 -- 用户自定义日期5
        ,user_date6 -- 用户自定义日期6
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
        ,user_amt1 -- 用户自定义金额1
        ,user_amt2 -- 用户自定义金额2
        ,user_amt3 -- 用户自定义金额3
        ,user_amt4 -- 用户自定义金额4
        ,user_amt5 -- 用户自定义金额5
        ,user_amt6 -- 昨日贷记卡承诺余额
        ,jpa_version -- 乐观锁版本号
        ,mtd_payment_amt -- 当月还款金额
        ,mtd_payment_cnt -- 当月还款笔数
        ,ytd_payment_amt -- 当年还款金额
        ,ytd_payment_cnt -- 当年还款笔数
        ,ltd_payment_amt -- 历史还款金额
        ,ltd_payment_cnt -- 历史还款笔数
        ,sms_ind -- 短信发送标识
        ,user_sms_amt -- 个性化动账短信发送阈值
        ,ytd_cycle_chag_cnt -- 本年度账单日修改次数
        ,last_post_date -- 上个批量处理日期
        ,last_modified_datetime -- 修改时间
        ,lock_date -- 自动锁定日
        ,last_sync_date -- 上一次入账的批量日期
        ,created_datetime -- 创建时间
        ,delay_bal -- 账户逾期金额
        ,ext_1 -- 扩展字段
        ,bank_group_id -- 银团编号
        ,bank_proportion -- 银行出资比例
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.org -- 机构号
    ,n.acct_no -- 账户编号
    ,n.acct_type -- 账户类型
    ,n.cust_id -- 客户编号
    ,n.cust_limit_id -- 客户额度ID
    ,n.product_cd -- 产品代码
    ,n.default_logical_card_no -- 默认逻辑卡号
    ,n.curr_cd -- 币种
    ,n.credit_limit -- 授信额度
    ,n.temp_limit -- 临时额度
    ,n.temp_limit_begin_date -- 临时额度开始日期
    ,n.temp_limit_end_date -- 临时额度结束日期
    ,n.cash_limit_rt -- 取现额度比例
    ,n.ovrlmt_rate -- 授权超限比例
    ,n.loan_limit_rt -- 额度内分期额度比例
    ,n.curr_bal -- 当前余额
    ,n.cash_bal -- 取现余额
    ,n.principal_bal -- 本金余额
    ,n.loan_bal -- 额度内分期余额
    ,n.dispute_amt -- 争议金额
    ,n.begin_bal -- 上一到期日余额
    ,n.pmt_due_day_bal -- 到期还款日余额
    ,n.qual_grace_bal -- 全部应还款额
    ,n.grace_days_full_ind -- 是否已全额还款
    ,n.point_begin_bal -- 期初积分余额
    ,n.ctd_earned_points -- 当期新增积分
    ,n.ctd_disb_points -- 当期兑换积分
    ,n.ctd_adj_points -- 当期调整积分
    ,n.point_bal -- 积分余额
    ,n.setup_date -- 创建日期
    ,n.dorment_date -- 账户睡眠日期
    ,n.reinstate_date -- 账户恢复活动日期
    ,n.ovrlmt_date -- 超限日期
    ,n.ovrlmt_nbr_of_cyc -- 连续超限账期
    ,n.name -- 姓名
    ,n.gender -- 性别
    ,n.owning_branch -- 发卡网点
    ,n.mobile_no -- 移动电话
    ,n.corp_name -- 公司名称
    ,n.billing_cycle -- 还款日
    ,n.stmt_flag -- 账单标志
    ,n.stmt_mail_addr_ind -- 账单寄送地址标志
    ,n.stmt_media_type -- 账单介质类型
    ,n.stmt_country_cd -- 账单地址国家代码
    ,n.stmt_state -- 账单地址省份
    ,n.stmt_city -- 账单地址城市
    ,n.stmt_district -- 账单地址行政区
    ,n.stmt_address -- 账单地址
    ,n.stmt_zip -- 账单地址邮政编码
    ,n.email -- 电子邮箱
    ,n.buser_field21 -- 系统备用域21
    ,n.age_cd -- 拖欠月数
    ,n.user_field22 -- 系统备用域22
    ,n.unmatch_db -- 未入账借记金额
    ,n.unmatch_cash -- 未匹配取现金额
    ,n.unmatch_cr -- 未入账贷记金额
    ,n.dd_ind -- 约定还款类型
    ,n.dd_bank_name -- 约定还款银行名称
    ,n.dd_bank_branch -- 约定还款开户行号
    ,n.dd_bank_acct_no -- 约定还款扣款账号
    ,n.dd_bank_acct_name -- 约定还款扣款账户姓名
    ,n.last_dd_amt -- 上期约定还款金额
    ,n.last_dd_date -- 上期约定还款日期
    ,n.dual_billing_flag -- 本币溢缴款还外币指示
    ,n.last_pmt_amt -- 上笔还款金额
    ,n.last_pmt_date -- 上个还款日期
    ,n.last_stmt_date -- 上个到期还款日期
    ,n.last_pmt_due_date -- 上个到期还款日期
    ,n.last_aging_date -- 上个逾期月数提升日期
    ,n.collect_date -- 入催日期
    ,n.collect_out_date -- 出催收队列日期
    ,n.next_stmt_date -- 下个到期还款日期
    ,n.pmt_due_date -- 到期还款日期
    ,n.dd_date -- 约定还款日期
    ,n.grace_date -- 宽限日期
    ,n.dlbl_date -- 本币还外币日期
    ,n.closed_date -- 最终销户日期
    ,n.first_stmt_date -- 首个到期还款日期
    ,n.cancel_date -- 销户日期
    ,n.charge_off_date -- 转呆账日期
    ,n.first_purchase_date -- 首次消费日期
    ,n.first_purchase_amt -- 首次消费金额
    ,n.tot_due_amt -- 最小还款额
    ,n.curr_due_amt -- 当期最小还款额
    ,n.past_due_amt1 -- 上个月最小还款额
    ,n.past_due_amt2 -- 上2个月最小还款额
    ,n.past_due_amt3 -- 上3个月最小还款额
    ,n.past_due_amt4 -- 上4个月最小还款额
    ,n.past_due_amt5 -- 上5个月最小还款额
    ,n.past_due_amt6 -- 上6个月最小还款额
    ,n.past_due_amt7 -- 上7个月最小还款额
    ,n.past_due_amt8 -- 上8个月最小还款额
    ,n.ctd_cash_amt -- 当期取现金额
    ,n.ctd_cash_cnt -- 当期取现笔数
    ,n.ctd_retail_amt -- 当期消费金额
    ,n.ctd_retail_cnt -- 当期消费笔数
    ,n.ctd_payment_amt -- 当期还款金额
    ,n.ctd_payment_cnt -- 当期还款笔数
    ,n.ctd_db_adj_amt -- 当期借记调整金额
    ,n.ctd_db_adj_cnt -- 当期借记调整笔数
    ,n.ctd_cr_adj_amt -- 当期贷记调整金额
    ,n.ctd_cr_adj_cnt -- 当期贷记调整笔数
    ,n.ctd_fee_amt -- 当期费用金额
    ,n.ctd_fee_cnt -- 当期费用笔数
    ,n.ctd_interest_amt -- 当期利息金额
    ,n.ctd_interest_cnt -- 当期利息笔数
    ,n.ctd_refund_amt -- 当期退货金额
    ,n.ctd_refund_cnt -- 当期退货笔数
    ,n.ctd_hi_ovrlmt_amt -- 当期最高超限金额
    ,n.mtd_retail_amt -- 本月消费金额
    ,n.mtd_retail_cnt -- 本月消费笔数
    ,n.mtd_cash_amt -- 本月取现金额
    ,n.mtd_cash_cnt -- 本月取现笔数
    ,n.mtd_refund_amt -- 本月退货金额
    ,n.mtd_refund_cnt -- 本月退货笔数
    ,n.ytd_retail_amt -- 本年消费金额
    ,n.ytd_retail_cnt -- 本年消费笔数
    ,n.ytd_cash_amt -- 本年取现金额
    ,n.ytd_cash_cnt -- 本年取现笔数
    ,n.ytd_refund_amt -- 本年退货金额
    ,n.ytd_refund_cnt -- 本年退货笔数
    ,n.ytd_ovrlmt_fee_amt -- 本年超限费收取金额
    ,n.ytd_ovrlmt_fee_cnt -- 本年超限费收取笔数
    ,n.ytd_lpc_amt -- 本年滞纳金收取金额
    ,n.ytd_lpc_cnt -- 本年滞纳金收取笔数
    ,n.ltd_retail_amt -- 历史消费金额
    ,n.ltd_retail_cnt -- 历史消费笔数
    ,n.ltd_cash_amt -- 历史取现金额
    ,n.ltd_cash_cnt -- 历史取现笔数
    ,n.ltd_refund_amt -- 历史退货金额
    ,n.ltd_refund_cnt -- 历史退货笔数
    ,n.ltd_highest_principal -- 历史最高本金欠款
    ,n.ltd_highest_cr_bal -- 历史最高溢缴款
    ,n.ltd_highest_bal -- 历史最高余额
    ,n.buser_field23 -- 系统备用域23
    ,n.buser_field24 -- 系统备用域24
    ,n.buser_field25 -- 系统备用域25
    ,n.buser_field26 -- 系统备用域26
    ,n.buser_field27 -- 系统备用域27
    ,n.waive_ovlfee_ind -- 是否免除超限费
    ,n.waive_cardfee_ind -- 是否免除年费
    ,n.waive_latefee_ind -- 是否免除滞纳金
    ,n.waive_svcfee_ind -- 是否免除服务费
    ,n.user_code1 -- 用户自定义代码1
    ,n.user_code2 -- 用户自定义代码2
    ,n.user_code3 -- 用户自定义代码3
    ,n.user_code4 -- 用户自定义代码4
    ,n.user_code5 -- 用户自定义代码5
    ,n.user_code6 -- 用户自定义代码6
    ,n.user_date1 -- 用户自定义日期1
    ,n.user_date2 -- 上次调额日期
    ,n.user_date3 -- 用户自定义日期3
    ,n.user_date4 -- 用户自定义日期4
    ,n.user_date5 -- 用户自定义日期5
    ,n.user_date6 -- 用户自定义日期6
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
    ,n.user_amt1 -- 用户自定义金额1
    ,n.user_amt2 -- 用户自定义金额2
    ,n.user_amt3 -- 用户自定义金额3
    ,n.user_amt4 -- 用户自定义金额4
    ,n.user_amt5 -- 用户自定义金额5
    ,n.user_amt6 -- 昨日贷记卡承诺余额
    ,n.jpa_version -- 乐观锁版本号
    ,n.mtd_payment_amt -- 当月还款金额
    ,n.mtd_payment_cnt -- 当月还款笔数
    ,n.ytd_payment_amt -- 当年还款金额
    ,n.ytd_payment_cnt -- 当年还款笔数
    ,n.ltd_payment_amt -- 历史还款金额
    ,n.ltd_payment_cnt -- 历史还款笔数
    ,n.sms_ind -- 短信发送标识
    ,n.user_sms_amt -- 个性化动账短信发送阈值
    ,n.ytd_cycle_chag_cnt -- 本年度账单日修改次数
    ,n.last_post_date -- 上个批量处理日期
    ,n.last_modified_datetime -- 修改时间
    ,n.lock_date -- 自动锁定日
    ,n.last_sync_date -- 上一次入账的批量日期
    ,n.created_datetime -- 创建时间
    ,n.delay_bal -- 账户逾期金额
    ,n.ext_1 -- 扩展字段
    ,n.bank_group_id -- 银团编号
    ,n.bank_proportion -- 银行出资比例
    ,n.batchfilename -- 批量文件名
    ,n.seqno -- 序列号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0ntm_account_bk o
    right join (select * from ${itl_schema}.mpcs_a0ntm_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acct_no = n.acct_no
            and o.acct_type = n.acct_type
where (
        o.acct_no is null
        and o.acct_type is null
    )
    or (
        o.org <> n.org
        or o.cust_id <> n.cust_id
        or o.cust_limit_id <> n.cust_limit_id
        or o.product_cd <> n.product_cd
        or o.default_logical_card_no <> n.default_logical_card_no
        or o.curr_cd <> n.curr_cd
        or o.credit_limit <> n.credit_limit
        or o.temp_limit <> n.temp_limit
        or o.temp_limit_begin_date <> n.temp_limit_begin_date
        or o.temp_limit_end_date <> n.temp_limit_end_date
        or o.cash_limit_rt <> n.cash_limit_rt
        or o.ovrlmt_rate <> n.ovrlmt_rate
        or o.loan_limit_rt <> n.loan_limit_rt
        or o.curr_bal <> n.curr_bal
        or o.cash_bal <> n.cash_bal
        or o.principal_bal <> n.principal_bal
        or o.loan_bal <> n.loan_bal
        or o.dispute_amt <> n.dispute_amt
        or o.begin_bal <> n.begin_bal
        or o.pmt_due_day_bal <> n.pmt_due_day_bal
        or o.qual_grace_bal <> n.qual_grace_bal
        or o.grace_days_full_ind <> n.grace_days_full_ind
        or o.point_begin_bal <> n.point_begin_bal
        or o.ctd_earned_points <> n.ctd_earned_points
        or o.ctd_disb_points <> n.ctd_disb_points
        or o.ctd_adj_points <> n.ctd_adj_points
        or o.point_bal <> n.point_bal
        or o.setup_date <> n.setup_date
        or o.dorment_date <> n.dorment_date
        or o.reinstate_date <> n.reinstate_date
        or o.ovrlmt_date <> n.ovrlmt_date
        or o.ovrlmt_nbr_of_cyc <> n.ovrlmt_nbr_of_cyc
        or o.name <> n.name
        or o.gender <> n.gender
        or o.owning_branch <> n.owning_branch
        or o.mobile_no <> n.mobile_no
        or o.corp_name <> n.corp_name
        or o.billing_cycle <> n.billing_cycle
        or o.stmt_flag <> n.stmt_flag
        or o.stmt_mail_addr_ind <> n.stmt_mail_addr_ind
        or o.stmt_media_type <> n.stmt_media_type
        or o.stmt_country_cd <> n.stmt_country_cd
        or o.stmt_state <> n.stmt_state
        or o.stmt_city <> n.stmt_city
        or o.stmt_district <> n.stmt_district
        or o.stmt_address <> n.stmt_address
        or o.stmt_zip <> n.stmt_zip
        or o.email <> n.email
        or o.buser_field21 <> n.buser_field21
        or o.age_cd <> n.age_cd
        or o.user_field22 <> n.user_field22
        or o.unmatch_db <> n.unmatch_db
        or o.unmatch_cash <> n.unmatch_cash
        or o.unmatch_cr <> n.unmatch_cr
        or o.dd_ind <> n.dd_ind
        or o.dd_bank_name <> n.dd_bank_name
        or o.dd_bank_branch <> n.dd_bank_branch
        or o.dd_bank_acct_no <> n.dd_bank_acct_no
        or o.dd_bank_acct_name <> n.dd_bank_acct_name
        or o.last_dd_amt <> n.last_dd_amt
        or o.last_dd_date <> n.last_dd_date
        or o.dual_billing_flag <> n.dual_billing_flag
        or o.last_pmt_amt <> n.last_pmt_amt
        or o.last_pmt_date <> n.last_pmt_date
        or o.last_stmt_date <> n.last_stmt_date
        or o.last_pmt_due_date <> n.last_pmt_due_date
        or o.last_aging_date <> n.last_aging_date
        or o.collect_date <> n.collect_date
        or o.collect_out_date <> n.collect_out_date
        or o.next_stmt_date <> n.next_stmt_date
        or o.pmt_due_date <> n.pmt_due_date
        or o.dd_date <> n.dd_date
        or o.grace_date <> n.grace_date
        or o.dlbl_date <> n.dlbl_date
        or o.closed_date <> n.closed_date
        or o.first_stmt_date <> n.first_stmt_date
        or o.cancel_date <> n.cancel_date
        or o.charge_off_date <> n.charge_off_date
        or o.first_purchase_date <> n.first_purchase_date
        or o.first_purchase_amt <> n.first_purchase_amt
        or o.tot_due_amt <> n.tot_due_amt
        or o.curr_due_amt <> n.curr_due_amt
        or o.past_due_amt1 <> n.past_due_amt1
        or o.past_due_amt2 <> n.past_due_amt2
        or o.past_due_amt3 <> n.past_due_amt3
        or o.past_due_amt4 <> n.past_due_amt4
        or o.past_due_amt5 <> n.past_due_amt5
        or o.past_due_amt6 <> n.past_due_amt6
        or o.past_due_amt7 <> n.past_due_amt7
        or o.past_due_amt8 <> n.past_due_amt8
        or o.ctd_cash_amt <> n.ctd_cash_amt
        or o.ctd_cash_cnt <> n.ctd_cash_cnt
        or o.ctd_retail_amt <> n.ctd_retail_amt
        or o.ctd_retail_cnt <> n.ctd_retail_cnt
        or o.ctd_payment_amt <> n.ctd_payment_amt
        or o.ctd_payment_cnt <> n.ctd_payment_cnt
        or o.ctd_db_adj_amt <> n.ctd_db_adj_amt
        or o.ctd_db_adj_cnt <> n.ctd_db_adj_cnt
        or o.ctd_cr_adj_amt <> n.ctd_cr_adj_amt
        or o.ctd_cr_adj_cnt <> n.ctd_cr_adj_cnt
        or o.ctd_fee_amt <> n.ctd_fee_amt
        or o.ctd_fee_cnt <> n.ctd_fee_cnt
        or o.ctd_interest_amt <> n.ctd_interest_amt
        or o.ctd_interest_cnt <> n.ctd_interest_cnt
        or o.ctd_refund_amt <> n.ctd_refund_amt
        or o.ctd_refund_cnt <> n.ctd_refund_cnt
        or o.ctd_hi_ovrlmt_amt <> n.ctd_hi_ovrlmt_amt
        or o.mtd_retail_amt <> n.mtd_retail_amt
        or o.mtd_retail_cnt <> n.mtd_retail_cnt
        or o.mtd_cash_amt <> n.mtd_cash_amt
        or o.mtd_cash_cnt <> n.mtd_cash_cnt
        or o.mtd_refund_amt <> n.mtd_refund_amt
        or o.mtd_refund_cnt <> n.mtd_refund_cnt
        or o.ytd_retail_amt <> n.ytd_retail_amt
        or o.ytd_retail_cnt <> n.ytd_retail_cnt
        or o.ytd_cash_amt <> n.ytd_cash_amt
        or o.ytd_cash_cnt <> n.ytd_cash_cnt
        or o.ytd_refund_amt <> n.ytd_refund_amt
        or o.ytd_refund_cnt <> n.ytd_refund_cnt
        or o.ytd_ovrlmt_fee_amt <> n.ytd_ovrlmt_fee_amt
        or o.ytd_ovrlmt_fee_cnt <> n.ytd_ovrlmt_fee_cnt
        or o.ytd_lpc_amt <> n.ytd_lpc_amt
        or o.ytd_lpc_cnt <> n.ytd_lpc_cnt
        or o.ltd_retail_amt <> n.ltd_retail_amt
        or o.ltd_retail_cnt <> n.ltd_retail_cnt
        or o.ltd_cash_amt <> n.ltd_cash_amt
        or o.ltd_cash_cnt <> n.ltd_cash_cnt
        or o.ltd_refund_amt <> n.ltd_refund_amt
        or o.ltd_refund_cnt <> n.ltd_refund_cnt
        or o.ltd_highest_principal <> n.ltd_highest_principal
        or o.ltd_highest_cr_bal <> n.ltd_highest_cr_bal
        or o.ltd_highest_bal <> n.ltd_highest_bal
        or o.buser_field23 <> n.buser_field23
        or o.buser_field24 <> n.buser_field24
        or o.buser_field25 <> n.buser_field25
        or o.buser_field26 <> n.buser_field26
        or o.buser_field27 <> n.buser_field27
        or o.waive_ovlfee_ind <> n.waive_ovlfee_ind
        or o.waive_cardfee_ind <> n.waive_cardfee_ind
        or o.waive_latefee_ind <> n.waive_latefee_ind
        or o.waive_svcfee_ind <> n.waive_svcfee_ind
        or o.user_code1 <> n.user_code1
        or o.user_code2 <> n.user_code2
        or o.user_code3 <> n.user_code3
        or o.user_code4 <> n.user_code4
        or o.user_code5 <> n.user_code5
        or o.user_code6 <> n.user_code6
        or o.user_date1 <> n.user_date1
        or o.user_date2 <> n.user_date2
        or o.user_date3 <> n.user_date3
        or o.user_date4 <> n.user_date4
        or o.user_date5 <> n.user_date5
        or o.user_date6 <> n.user_date6
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
        or o.user_amt1 <> n.user_amt1
        or o.user_amt2 <> n.user_amt2
        or o.user_amt3 <> n.user_amt3
        or o.user_amt4 <> n.user_amt4
        or o.user_amt5 <> n.user_amt5
        or o.user_amt6 <> n.user_amt6
        or o.jpa_version <> n.jpa_version
        or o.mtd_payment_amt <> n.mtd_payment_amt
        or o.mtd_payment_cnt <> n.mtd_payment_cnt
        or o.ytd_payment_amt <> n.ytd_payment_amt
        or o.ytd_payment_cnt <> n.ytd_payment_cnt
        or o.ltd_payment_amt <> n.ltd_payment_amt
        or o.ltd_payment_cnt <> n.ltd_payment_cnt
        or o.sms_ind <> n.sms_ind
        or o.user_sms_amt <> n.user_sms_amt
        or o.ytd_cycle_chag_cnt <> n.ytd_cycle_chag_cnt
        or o.last_post_date <> n.last_post_date
        or o.last_modified_datetime <> n.last_modified_datetime
        or o.lock_date <> n.lock_date
        or o.last_sync_date <> n.last_sync_date
        or o.created_datetime <> n.created_datetime
        or o.delay_bal <> n.delay_bal
        or o.ext_1 <> n.ext_1
        or o.bank_group_id <> n.bank_group_id
        or o.bank_proportion <> n.bank_proportion
        or o.batchfilename <> n.batchfilename
        or o.seqno <> n.seqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_account_cl(
            org -- 机构号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,cust_id -- 客户编号
        ,cust_limit_id -- 客户额度ID
        ,product_cd -- 产品代码
        ,default_logical_card_no -- 默认逻辑卡号
        ,curr_cd -- 币种
        ,credit_limit -- 授信额度
        ,temp_limit -- 临时额度
        ,temp_limit_begin_date -- 临时额度开始日期
        ,temp_limit_end_date -- 临时额度结束日期
        ,cash_limit_rt -- 取现额度比例
        ,ovrlmt_rate -- 授权超限比例
        ,loan_limit_rt -- 额度内分期额度比例
        ,curr_bal -- 当前余额
        ,cash_bal -- 取现余额
        ,principal_bal -- 本金余额
        ,loan_bal -- 额度内分期余额
        ,dispute_amt -- 争议金额
        ,begin_bal -- 上一到期日余额
        ,pmt_due_day_bal -- 到期还款日余额
        ,qual_grace_bal -- 全部应还款额
        ,grace_days_full_ind -- 是否已全额还款
        ,point_begin_bal -- 期初积分余额
        ,ctd_earned_points -- 当期新增积分
        ,ctd_disb_points -- 当期兑换积分
        ,ctd_adj_points -- 当期调整积分
        ,point_bal -- 积分余额
        ,setup_date -- 创建日期
        ,dorment_date -- 账户睡眠日期
        ,reinstate_date -- 账户恢复活动日期
        ,ovrlmt_date -- 超限日期
        ,ovrlmt_nbr_of_cyc -- 连续超限账期
        ,name -- 姓名
        ,gender -- 性别
        ,owning_branch -- 发卡网点
        ,mobile_no -- 移动电话
        ,corp_name -- 公司名称
        ,billing_cycle -- 还款日
        ,stmt_flag -- 账单标志
        ,stmt_mail_addr_ind -- 账单寄送地址标志
        ,stmt_media_type -- 账单介质类型
        ,stmt_country_cd -- 账单地址国家代码
        ,stmt_state -- 账单地址省份
        ,stmt_city -- 账单地址城市
        ,stmt_district -- 账单地址行政区
        ,stmt_address -- 账单地址
        ,stmt_zip -- 账单地址邮政编码
        ,email -- 电子邮箱
        ,buser_field21 -- 系统备用域21
        ,age_cd -- 拖欠月数
        ,user_field22 -- 系统备用域22
        ,unmatch_db -- 未入账借记金额
        ,unmatch_cash -- 未匹配取现金额
        ,unmatch_cr -- 未入账贷记金额
        ,dd_ind -- 约定还款类型
        ,dd_bank_name -- 约定还款银行名称
        ,dd_bank_branch -- 约定还款开户行号
        ,dd_bank_acct_no -- 约定还款扣款账号
        ,dd_bank_acct_name -- 约定还款扣款账户姓名
        ,last_dd_amt -- 上期约定还款金额
        ,last_dd_date -- 上期约定还款日期
        ,dual_billing_flag -- 本币溢缴款还外币指示
        ,last_pmt_amt -- 上笔还款金额
        ,last_pmt_date -- 上个还款日期
        ,last_stmt_date -- 上个到期还款日期
        ,last_pmt_due_date -- 上个到期还款日期
        ,last_aging_date -- 上个逾期月数提升日期
        ,collect_date -- 入催日期
        ,collect_out_date -- 出催收队列日期
        ,next_stmt_date -- 下个到期还款日期
        ,pmt_due_date -- 到期还款日期
        ,dd_date -- 约定还款日期
        ,grace_date -- 宽限日期
        ,dlbl_date -- 本币还外币日期
        ,closed_date -- 最终销户日期
        ,first_stmt_date -- 首个到期还款日期
        ,cancel_date -- 销户日期
        ,charge_off_date -- 转呆账日期
        ,first_purchase_date -- 首次消费日期
        ,first_purchase_amt -- 首次消费金额
        ,tot_due_amt -- 最小还款额
        ,curr_due_amt -- 当期最小还款额
        ,past_due_amt1 -- 上个月最小还款额
        ,past_due_amt2 -- 上2个月最小还款额
        ,past_due_amt3 -- 上3个月最小还款额
        ,past_due_amt4 -- 上4个月最小还款额
        ,past_due_amt5 -- 上5个月最小还款额
        ,past_due_amt6 -- 上6个月最小还款额
        ,past_due_amt7 -- 上7个月最小还款额
        ,past_due_amt8 -- 上8个月最小还款额
        ,ctd_cash_amt -- 当期取现金额
        ,ctd_cash_cnt -- 当期取现笔数
        ,ctd_retail_amt -- 当期消费金额
        ,ctd_retail_cnt -- 当期消费笔数
        ,ctd_payment_amt -- 当期还款金额
        ,ctd_payment_cnt -- 当期还款笔数
        ,ctd_db_adj_amt -- 当期借记调整金额
        ,ctd_db_adj_cnt -- 当期借记调整笔数
        ,ctd_cr_adj_amt -- 当期贷记调整金额
        ,ctd_cr_adj_cnt -- 当期贷记调整笔数
        ,ctd_fee_amt -- 当期费用金额
        ,ctd_fee_cnt -- 当期费用笔数
        ,ctd_interest_amt -- 当期利息金额
        ,ctd_interest_cnt -- 当期利息笔数
        ,ctd_refund_amt -- 当期退货金额
        ,ctd_refund_cnt -- 当期退货笔数
        ,ctd_hi_ovrlmt_amt -- 当期最高超限金额
        ,mtd_retail_amt -- 本月消费金额
        ,mtd_retail_cnt -- 本月消费笔数
        ,mtd_cash_amt -- 本月取现金额
        ,mtd_cash_cnt -- 本月取现笔数
        ,mtd_refund_amt -- 本月退货金额
        ,mtd_refund_cnt -- 本月退货笔数
        ,ytd_retail_amt -- 本年消费金额
        ,ytd_retail_cnt -- 本年消费笔数
        ,ytd_cash_amt -- 本年取现金额
        ,ytd_cash_cnt -- 本年取现笔数
        ,ytd_refund_amt -- 本年退货金额
        ,ytd_refund_cnt -- 本年退货笔数
        ,ytd_ovrlmt_fee_amt -- 本年超限费收取金额
        ,ytd_ovrlmt_fee_cnt -- 本年超限费收取笔数
        ,ytd_lpc_amt -- 本年滞纳金收取金额
        ,ytd_lpc_cnt -- 本年滞纳金收取笔数
        ,ltd_retail_amt -- 历史消费金额
        ,ltd_retail_cnt -- 历史消费笔数
        ,ltd_cash_amt -- 历史取现金额
        ,ltd_cash_cnt -- 历史取现笔数
        ,ltd_refund_amt -- 历史退货金额
        ,ltd_refund_cnt -- 历史退货笔数
        ,ltd_highest_principal -- 历史最高本金欠款
        ,ltd_highest_cr_bal -- 历史最高溢缴款
        ,ltd_highest_bal -- 历史最高余额
        ,buser_field23 -- 系统备用域23
        ,buser_field24 -- 系统备用域24
        ,buser_field25 -- 系统备用域25
        ,buser_field26 -- 系统备用域26
        ,buser_field27 -- 系统备用域27
        ,waive_ovlfee_ind -- 是否免除超限费
        ,waive_cardfee_ind -- 是否免除年费
        ,waive_latefee_ind -- 是否免除滞纳金
        ,waive_svcfee_ind -- 是否免除服务费
        ,user_code1 -- 用户自定义代码1
        ,user_code2 -- 用户自定义代码2
        ,user_code3 -- 用户自定义代码3
        ,user_code4 -- 用户自定义代码4
        ,user_code5 -- 用户自定义代码5
        ,user_code6 -- 用户自定义代码6
        ,user_date1 -- 用户自定义日期1
        ,user_date2 -- 上次调额日期
        ,user_date3 -- 用户自定义日期3
        ,user_date4 -- 用户自定义日期4
        ,user_date5 -- 用户自定义日期5
        ,user_date6 -- 用户自定义日期6
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
        ,user_amt1 -- 用户自定义金额1
        ,user_amt2 -- 用户自定义金额2
        ,user_amt3 -- 用户自定义金额3
        ,user_amt4 -- 用户自定义金额4
        ,user_amt5 -- 用户自定义金额5
        ,user_amt6 -- 昨日贷记卡承诺余额
        ,jpa_version -- 乐观锁版本号
        ,mtd_payment_amt -- 当月还款金额
        ,mtd_payment_cnt -- 当月还款笔数
        ,ytd_payment_amt -- 当年还款金额
        ,ytd_payment_cnt -- 当年还款笔数
        ,ltd_payment_amt -- 历史还款金额
        ,ltd_payment_cnt -- 历史还款笔数
        ,sms_ind -- 短信发送标识
        ,user_sms_amt -- 个性化动账短信发送阈值
        ,ytd_cycle_chag_cnt -- 本年度账单日修改次数
        ,last_post_date -- 上个批量处理日期
        ,last_modified_datetime -- 修改时间
        ,lock_date -- 自动锁定日
        ,last_sync_date -- 上一次入账的批量日期
        ,created_datetime -- 创建时间
        ,delay_bal -- 账户逾期金额
        ,ext_1 -- 扩展字段
        ,bank_group_id -- 银团编号
        ,bank_proportion -- 银行出资比例
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_account_op(
            org -- 机构号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,cust_id -- 客户编号
        ,cust_limit_id -- 客户额度ID
        ,product_cd -- 产品代码
        ,default_logical_card_no -- 默认逻辑卡号
        ,curr_cd -- 币种
        ,credit_limit -- 授信额度
        ,temp_limit -- 临时额度
        ,temp_limit_begin_date -- 临时额度开始日期
        ,temp_limit_end_date -- 临时额度结束日期
        ,cash_limit_rt -- 取现额度比例
        ,ovrlmt_rate -- 授权超限比例
        ,loan_limit_rt -- 额度内分期额度比例
        ,curr_bal -- 当前余额
        ,cash_bal -- 取现余额
        ,principal_bal -- 本金余额
        ,loan_bal -- 额度内分期余额
        ,dispute_amt -- 争议金额
        ,begin_bal -- 上一到期日余额
        ,pmt_due_day_bal -- 到期还款日余额
        ,qual_grace_bal -- 全部应还款额
        ,grace_days_full_ind -- 是否已全额还款
        ,point_begin_bal -- 期初积分余额
        ,ctd_earned_points -- 当期新增积分
        ,ctd_disb_points -- 当期兑换积分
        ,ctd_adj_points -- 当期调整积分
        ,point_bal -- 积分余额
        ,setup_date -- 创建日期
        ,dorment_date -- 账户睡眠日期
        ,reinstate_date -- 账户恢复活动日期
        ,ovrlmt_date -- 超限日期
        ,ovrlmt_nbr_of_cyc -- 连续超限账期
        ,name -- 姓名
        ,gender -- 性别
        ,owning_branch -- 发卡网点
        ,mobile_no -- 移动电话
        ,corp_name -- 公司名称
        ,billing_cycle -- 还款日
        ,stmt_flag -- 账单标志
        ,stmt_mail_addr_ind -- 账单寄送地址标志
        ,stmt_media_type -- 账单介质类型
        ,stmt_country_cd -- 账单地址国家代码
        ,stmt_state -- 账单地址省份
        ,stmt_city -- 账单地址城市
        ,stmt_district -- 账单地址行政区
        ,stmt_address -- 账单地址
        ,stmt_zip -- 账单地址邮政编码
        ,email -- 电子邮箱
        ,buser_field21 -- 系统备用域21
        ,age_cd -- 拖欠月数
        ,user_field22 -- 系统备用域22
        ,unmatch_db -- 未入账借记金额
        ,unmatch_cash -- 未匹配取现金额
        ,unmatch_cr -- 未入账贷记金额
        ,dd_ind -- 约定还款类型
        ,dd_bank_name -- 约定还款银行名称
        ,dd_bank_branch -- 约定还款开户行号
        ,dd_bank_acct_no -- 约定还款扣款账号
        ,dd_bank_acct_name -- 约定还款扣款账户姓名
        ,last_dd_amt -- 上期约定还款金额
        ,last_dd_date -- 上期约定还款日期
        ,dual_billing_flag -- 本币溢缴款还外币指示
        ,last_pmt_amt -- 上笔还款金额
        ,last_pmt_date -- 上个还款日期
        ,last_stmt_date -- 上个到期还款日期
        ,last_pmt_due_date -- 上个到期还款日期
        ,last_aging_date -- 上个逾期月数提升日期
        ,collect_date -- 入催日期
        ,collect_out_date -- 出催收队列日期
        ,next_stmt_date -- 下个到期还款日期
        ,pmt_due_date -- 到期还款日期
        ,dd_date -- 约定还款日期
        ,grace_date -- 宽限日期
        ,dlbl_date -- 本币还外币日期
        ,closed_date -- 最终销户日期
        ,first_stmt_date -- 首个到期还款日期
        ,cancel_date -- 销户日期
        ,charge_off_date -- 转呆账日期
        ,first_purchase_date -- 首次消费日期
        ,first_purchase_amt -- 首次消费金额
        ,tot_due_amt -- 最小还款额
        ,curr_due_amt -- 当期最小还款额
        ,past_due_amt1 -- 上个月最小还款额
        ,past_due_amt2 -- 上2个月最小还款额
        ,past_due_amt3 -- 上3个月最小还款额
        ,past_due_amt4 -- 上4个月最小还款额
        ,past_due_amt5 -- 上5个月最小还款额
        ,past_due_amt6 -- 上6个月最小还款额
        ,past_due_amt7 -- 上7个月最小还款额
        ,past_due_amt8 -- 上8个月最小还款额
        ,ctd_cash_amt -- 当期取现金额
        ,ctd_cash_cnt -- 当期取现笔数
        ,ctd_retail_amt -- 当期消费金额
        ,ctd_retail_cnt -- 当期消费笔数
        ,ctd_payment_amt -- 当期还款金额
        ,ctd_payment_cnt -- 当期还款笔数
        ,ctd_db_adj_amt -- 当期借记调整金额
        ,ctd_db_adj_cnt -- 当期借记调整笔数
        ,ctd_cr_adj_amt -- 当期贷记调整金额
        ,ctd_cr_adj_cnt -- 当期贷记调整笔数
        ,ctd_fee_amt -- 当期费用金额
        ,ctd_fee_cnt -- 当期费用笔数
        ,ctd_interest_amt -- 当期利息金额
        ,ctd_interest_cnt -- 当期利息笔数
        ,ctd_refund_amt -- 当期退货金额
        ,ctd_refund_cnt -- 当期退货笔数
        ,ctd_hi_ovrlmt_amt -- 当期最高超限金额
        ,mtd_retail_amt -- 本月消费金额
        ,mtd_retail_cnt -- 本月消费笔数
        ,mtd_cash_amt -- 本月取现金额
        ,mtd_cash_cnt -- 本月取现笔数
        ,mtd_refund_amt -- 本月退货金额
        ,mtd_refund_cnt -- 本月退货笔数
        ,ytd_retail_amt -- 本年消费金额
        ,ytd_retail_cnt -- 本年消费笔数
        ,ytd_cash_amt -- 本年取现金额
        ,ytd_cash_cnt -- 本年取现笔数
        ,ytd_refund_amt -- 本年退货金额
        ,ytd_refund_cnt -- 本年退货笔数
        ,ytd_ovrlmt_fee_amt -- 本年超限费收取金额
        ,ytd_ovrlmt_fee_cnt -- 本年超限费收取笔数
        ,ytd_lpc_amt -- 本年滞纳金收取金额
        ,ytd_lpc_cnt -- 本年滞纳金收取笔数
        ,ltd_retail_amt -- 历史消费金额
        ,ltd_retail_cnt -- 历史消费笔数
        ,ltd_cash_amt -- 历史取现金额
        ,ltd_cash_cnt -- 历史取现笔数
        ,ltd_refund_amt -- 历史退货金额
        ,ltd_refund_cnt -- 历史退货笔数
        ,ltd_highest_principal -- 历史最高本金欠款
        ,ltd_highest_cr_bal -- 历史最高溢缴款
        ,ltd_highest_bal -- 历史最高余额
        ,buser_field23 -- 系统备用域23
        ,buser_field24 -- 系统备用域24
        ,buser_field25 -- 系统备用域25
        ,buser_field26 -- 系统备用域26
        ,buser_field27 -- 系统备用域27
        ,waive_ovlfee_ind -- 是否免除超限费
        ,waive_cardfee_ind -- 是否免除年费
        ,waive_latefee_ind -- 是否免除滞纳金
        ,waive_svcfee_ind -- 是否免除服务费
        ,user_code1 -- 用户自定义代码1
        ,user_code2 -- 用户自定义代码2
        ,user_code3 -- 用户自定义代码3
        ,user_code4 -- 用户自定义代码4
        ,user_code5 -- 用户自定义代码5
        ,user_code6 -- 用户自定义代码6
        ,user_date1 -- 用户自定义日期1
        ,user_date2 -- 上次调额日期
        ,user_date3 -- 用户自定义日期3
        ,user_date4 -- 用户自定义日期4
        ,user_date5 -- 用户自定义日期5
        ,user_date6 -- 用户自定义日期6
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
        ,user_amt1 -- 用户自定义金额1
        ,user_amt2 -- 用户自定义金额2
        ,user_amt3 -- 用户自定义金额3
        ,user_amt4 -- 用户自定义金额4
        ,user_amt5 -- 用户自定义金额5
        ,user_amt6 -- 昨日贷记卡承诺余额
        ,jpa_version -- 乐观锁版本号
        ,mtd_payment_amt -- 当月还款金额
        ,mtd_payment_cnt -- 当月还款笔数
        ,ytd_payment_amt -- 当年还款金额
        ,ytd_payment_cnt -- 当年还款笔数
        ,ltd_payment_amt -- 历史还款金额
        ,ltd_payment_cnt -- 历史还款笔数
        ,sms_ind -- 短信发送标识
        ,user_sms_amt -- 个性化动账短信发送阈值
        ,ytd_cycle_chag_cnt -- 本年度账单日修改次数
        ,last_post_date -- 上个批量处理日期
        ,last_modified_datetime -- 修改时间
        ,lock_date -- 自动锁定日
        ,last_sync_date -- 上一次入账的批量日期
        ,created_datetime -- 创建时间
        ,delay_bal -- 账户逾期金额
        ,ext_1 -- 扩展字段
        ,bank_group_id -- 银团编号
        ,bank_proportion -- 银行出资比例
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.acct_no -- 账户编号
    ,o.acct_type -- 账户类型
    ,o.cust_id -- 客户编号
    ,o.cust_limit_id -- 客户额度ID
    ,o.product_cd -- 产品代码
    ,o.default_logical_card_no -- 默认逻辑卡号
    ,o.curr_cd -- 币种
    ,o.credit_limit -- 授信额度
    ,o.temp_limit -- 临时额度
    ,o.temp_limit_begin_date -- 临时额度开始日期
    ,o.temp_limit_end_date -- 临时额度结束日期
    ,o.cash_limit_rt -- 取现额度比例
    ,o.ovrlmt_rate -- 授权超限比例
    ,o.loan_limit_rt -- 额度内分期额度比例
    ,o.curr_bal -- 当前余额
    ,o.cash_bal -- 取现余额
    ,o.principal_bal -- 本金余额
    ,o.loan_bal -- 额度内分期余额
    ,o.dispute_amt -- 争议金额
    ,o.begin_bal -- 上一到期日余额
    ,o.pmt_due_day_bal -- 到期还款日余额
    ,o.qual_grace_bal -- 全部应还款额
    ,o.grace_days_full_ind -- 是否已全额还款
    ,o.point_begin_bal -- 期初积分余额
    ,o.ctd_earned_points -- 当期新增积分
    ,o.ctd_disb_points -- 当期兑换积分
    ,o.ctd_adj_points -- 当期调整积分
    ,o.point_bal -- 积分余额
    ,o.setup_date -- 创建日期
    ,o.dorment_date -- 账户睡眠日期
    ,o.reinstate_date -- 账户恢复活动日期
    ,o.ovrlmt_date -- 超限日期
    ,o.ovrlmt_nbr_of_cyc -- 连续超限账期
    ,o.name -- 姓名
    ,o.gender -- 性别
    ,o.owning_branch -- 发卡网点
    ,o.mobile_no -- 移动电话
    ,o.corp_name -- 公司名称
    ,o.billing_cycle -- 还款日
    ,o.stmt_flag -- 账单标志
    ,o.stmt_mail_addr_ind -- 账单寄送地址标志
    ,o.stmt_media_type -- 账单介质类型
    ,o.stmt_country_cd -- 账单地址国家代码
    ,o.stmt_state -- 账单地址省份
    ,o.stmt_city -- 账单地址城市
    ,o.stmt_district -- 账单地址行政区
    ,o.stmt_address -- 账单地址
    ,o.stmt_zip -- 账单地址邮政编码
    ,o.email -- 电子邮箱
    ,o.buser_field21 -- 系统备用域21
    ,o.age_cd -- 拖欠月数
    ,o.user_field22 -- 系统备用域22
    ,o.unmatch_db -- 未入账借记金额
    ,o.unmatch_cash -- 未匹配取现金额
    ,o.unmatch_cr -- 未入账贷记金额
    ,o.dd_ind -- 约定还款类型
    ,o.dd_bank_name -- 约定还款银行名称
    ,o.dd_bank_branch -- 约定还款开户行号
    ,o.dd_bank_acct_no -- 约定还款扣款账号
    ,o.dd_bank_acct_name -- 约定还款扣款账户姓名
    ,o.last_dd_amt -- 上期约定还款金额
    ,o.last_dd_date -- 上期约定还款日期
    ,o.dual_billing_flag -- 本币溢缴款还外币指示
    ,o.last_pmt_amt -- 上笔还款金额
    ,o.last_pmt_date -- 上个还款日期
    ,o.last_stmt_date -- 上个到期还款日期
    ,o.last_pmt_due_date -- 上个到期还款日期
    ,o.last_aging_date -- 上个逾期月数提升日期
    ,o.collect_date -- 入催日期
    ,o.collect_out_date -- 出催收队列日期
    ,o.next_stmt_date -- 下个到期还款日期
    ,o.pmt_due_date -- 到期还款日期
    ,o.dd_date -- 约定还款日期
    ,o.grace_date -- 宽限日期
    ,o.dlbl_date -- 本币还外币日期
    ,o.closed_date -- 最终销户日期
    ,o.first_stmt_date -- 首个到期还款日期
    ,o.cancel_date -- 销户日期
    ,o.charge_off_date -- 转呆账日期
    ,o.first_purchase_date -- 首次消费日期
    ,o.first_purchase_amt -- 首次消费金额
    ,o.tot_due_amt -- 最小还款额
    ,o.curr_due_amt -- 当期最小还款额
    ,o.past_due_amt1 -- 上个月最小还款额
    ,o.past_due_amt2 -- 上2个月最小还款额
    ,o.past_due_amt3 -- 上3个月最小还款额
    ,o.past_due_amt4 -- 上4个月最小还款额
    ,o.past_due_amt5 -- 上5个月最小还款额
    ,o.past_due_amt6 -- 上6个月最小还款额
    ,o.past_due_amt7 -- 上7个月最小还款额
    ,o.past_due_amt8 -- 上8个月最小还款额
    ,o.ctd_cash_amt -- 当期取现金额
    ,o.ctd_cash_cnt -- 当期取现笔数
    ,o.ctd_retail_amt -- 当期消费金额
    ,o.ctd_retail_cnt -- 当期消费笔数
    ,o.ctd_payment_amt -- 当期还款金额
    ,o.ctd_payment_cnt -- 当期还款笔数
    ,o.ctd_db_adj_amt -- 当期借记调整金额
    ,o.ctd_db_adj_cnt -- 当期借记调整笔数
    ,o.ctd_cr_adj_amt -- 当期贷记调整金额
    ,o.ctd_cr_adj_cnt -- 当期贷记调整笔数
    ,o.ctd_fee_amt -- 当期费用金额
    ,o.ctd_fee_cnt -- 当期费用笔数
    ,o.ctd_interest_amt -- 当期利息金额
    ,o.ctd_interest_cnt -- 当期利息笔数
    ,o.ctd_refund_amt -- 当期退货金额
    ,o.ctd_refund_cnt -- 当期退货笔数
    ,o.ctd_hi_ovrlmt_amt -- 当期最高超限金额
    ,o.mtd_retail_amt -- 本月消费金额
    ,o.mtd_retail_cnt -- 本月消费笔数
    ,o.mtd_cash_amt -- 本月取现金额
    ,o.mtd_cash_cnt -- 本月取现笔数
    ,o.mtd_refund_amt -- 本月退货金额
    ,o.mtd_refund_cnt -- 本月退货笔数
    ,o.ytd_retail_amt -- 本年消费金额
    ,o.ytd_retail_cnt -- 本年消费笔数
    ,o.ytd_cash_amt -- 本年取现金额
    ,o.ytd_cash_cnt -- 本年取现笔数
    ,o.ytd_refund_amt -- 本年退货金额
    ,o.ytd_refund_cnt -- 本年退货笔数
    ,o.ytd_ovrlmt_fee_amt -- 本年超限费收取金额
    ,o.ytd_ovrlmt_fee_cnt -- 本年超限费收取笔数
    ,o.ytd_lpc_amt -- 本年滞纳金收取金额
    ,o.ytd_lpc_cnt -- 本年滞纳金收取笔数
    ,o.ltd_retail_amt -- 历史消费金额
    ,o.ltd_retail_cnt -- 历史消费笔数
    ,o.ltd_cash_amt -- 历史取现金额
    ,o.ltd_cash_cnt -- 历史取现笔数
    ,o.ltd_refund_amt -- 历史退货金额
    ,o.ltd_refund_cnt -- 历史退货笔数
    ,o.ltd_highest_principal -- 历史最高本金欠款
    ,o.ltd_highest_cr_bal -- 历史最高溢缴款
    ,o.ltd_highest_bal -- 历史最高余额
    ,o.buser_field23 -- 系统备用域23
    ,o.buser_field24 -- 系统备用域24
    ,o.buser_field25 -- 系统备用域25
    ,o.buser_field26 -- 系统备用域26
    ,o.buser_field27 -- 系统备用域27
    ,o.waive_ovlfee_ind -- 是否免除超限费
    ,o.waive_cardfee_ind -- 是否免除年费
    ,o.waive_latefee_ind -- 是否免除滞纳金
    ,o.waive_svcfee_ind -- 是否免除服务费
    ,o.user_code1 -- 用户自定义代码1
    ,o.user_code2 -- 用户自定义代码2
    ,o.user_code3 -- 用户自定义代码3
    ,o.user_code4 -- 用户自定义代码4
    ,o.user_code5 -- 用户自定义代码5
    ,o.user_code6 -- 用户自定义代码6
    ,o.user_date1 -- 用户自定义日期1
    ,o.user_date2 -- 上次调额日期
    ,o.user_date3 -- 用户自定义日期3
    ,o.user_date4 -- 用户自定义日期4
    ,o.user_date5 -- 用户自定义日期5
    ,o.user_date6 -- 用户自定义日期6
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
    ,o.user_amt1 -- 用户自定义金额1
    ,o.user_amt2 -- 用户自定义金额2
    ,o.user_amt3 -- 用户自定义金额3
    ,o.user_amt4 -- 用户自定义金额4
    ,o.user_amt5 -- 用户自定义金额5
    ,o.user_amt6 -- 昨日贷记卡承诺余额
    ,o.jpa_version -- 乐观锁版本号
    ,o.mtd_payment_amt -- 当月还款金额
    ,o.mtd_payment_cnt -- 当月还款笔数
    ,o.ytd_payment_amt -- 当年还款金额
    ,o.ytd_payment_cnt -- 当年还款笔数
    ,o.ltd_payment_amt -- 历史还款金额
    ,o.ltd_payment_cnt -- 历史还款笔数
    ,o.sms_ind -- 短信发送标识
    ,o.user_sms_amt -- 个性化动账短信发送阈值
    ,o.ytd_cycle_chag_cnt -- 本年度账单日修改次数
    ,o.last_post_date -- 上个批量处理日期
    ,o.last_modified_datetime -- 修改时间
    ,o.lock_date -- 自动锁定日
    ,o.last_sync_date -- 上一次入账的批量日期
    ,o.created_datetime -- 创建时间
    ,o.delay_bal -- 账户逾期金额
    ,o.ext_1 -- 扩展字段
    ,o.bank_group_id -- 银团编号
    ,o.bank_proportion -- 银行出资比例
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
from ${iol_schema}.mpcs_a0ntm_account_bk o
    left join ${iol_schema}.mpcs_a0ntm_account_op n
        on
            o.acct_no = n.acct_no
            and o.acct_type = n.acct_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0ntm_account;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0ntm_account') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0ntm_account drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0ntm_account add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0ntm_account exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0ntm_account_cl;
alter table ${iol_schema}.mpcs_a0ntm_account exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ntm_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_account_op purge;
drop table ${iol_schema}.mpcs_a0ntm_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ntm_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
