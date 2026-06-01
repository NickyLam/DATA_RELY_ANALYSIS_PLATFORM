/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_account
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_account(
    org varchar2(18) -- 机构号
    ,acct_no number(20,0) -- 账户编号
    ,acct_type varchar2(2) -- 账户类型
    ,cust_id number(20,0) -- 客户编号
    ,cust_limit_id number(20,0) -- 客户额度id
    ,product_cd varchar2(9) -- 产品代码
    ,default_logical_card_no varchar2(29) -- 默认逻辑卡号
    ,curr_cd varchar2(5) -- 币种
    ,credit_limit number(13,0) -- 授信额度
    ,temp_limit number(13,0) -- 临时额度
    ,temp_limit_begin_date date -- 临时额度开始日期
    ,temp_limit_end_date date -- 临时额度结束日期
    ,cash_limit_rt number(19,6) -- 取现额度比例
    ,ovrlmt_rate number(19,6) -- 授权超限比例
    ,loan_limit_rt number(19,6) -- 额度内分期额度比例
    ,curr_bal number(19,6) -- 当前余额
    ,cash_bal number(19,6) -- 取现余额
    ,principal_bal number(15,2) -- 本金余额
    ,loan_bal number(19,6) -- 额度内分期余额
    ,dispute_amt number(19,6) -- 争议金额
    ,begin_bal number(15,2) -- 上一到期日余额
    ,pmt_due_day_bal number(15,2) -- 到期还款日余额
    ,qual_grace_bal number(19,6) -- 全部应还款额
    ,grace_days_full_ind varchar2(90) -- 是否已全额还款
    ,point_begin_bal number(30,0) -- 期初积分余额
    ,ctd_earned_points number(30,0) -- 当期新增积分
    ,ctd_disb_points number(30,0) -- 当期兑换积分
    ,ctd_adj_points number(30,0) -- 当期调整积分
    ,point_bal number(30,0) -- 积分余额
    ,setup_date date -- 创建日期
    ,dorment_date date -- 账户睡眠日期
    ,reinstate_date date -- 账户恢复活动日期
    ,ovrlmt_date date -- 超限日期
    ,ovrlmt_nbr_of_cyc number(22) -- 连续超限账期
    ,name varchar2(120) -- 姓名
    ,gender varchar2(2) -- 性别
    ,owning_branch varchar2(14) -- 发卡网点
    ,mobile_no varchar2(30) -- 移动电话
    ,corp_name varchar2(300) -- 公司名称
    ,billing_cycle varchar2(3) -- 还款日
    ,stmt_flag varchar2(90) -- 账单标志
    ,stmt_mail_addr_ind varchar2(90) -- 账单寄送地址标志
    ,stmt_media_type varchar2(90) -- 账单介质类型
    ,stmt_country_cd varchar2(90) -- 账单地址国家代码
    ,stmt_state varchar2(300) -- 账单地址省份
    ,stmt_city varchar2(300) -- 账单地址城市
    ,stmt_district varchar2(300) -- 账单地址行政区
    ,stmt_address varchar2(300) -- 账单地址
    ,stmt_zip varchar2(300) -- 账单地址邮政编码
    ,email varchar2(300) -- 电子邮箱
    ,buser_field21 varchar2(300) -- 系统备用域21
    ,age_cd varchar2(2) -- 拖欠月数
    ,user_field22 varchar2(2) -- 系统备用域22
    ,unmatch_db number(15,2) -- 未入账借记金额
    ,unmatch_cash number(19,6) -- 未匹配取现金额
    ,unmatch_cr number(15,2) -- 未入账贷记金额
    ,dd_ind varchar2(2) -- 约定还款类型
    ,dd_bank_name varchar2(120) -- 约定还款银行名称
    ,dd_bank_branch varchar2(21) -- 约定还款开户行号
    ,dd_bank_acct_no varchar2(60) -- 约定还款扣款账号
    ,dd_bank_acct_name varchar2(120) -- 约定还款扣款账户姓名
    ,last_dd_amt number(15,2) -- 上期约定还款金额
    ,last_dd_date date -- 上期约定还款日期
    ,dual_billing_flag varchar2(90) -- 本币溢缴款还外币指示
    ,last_pmt_amt number(15,2) -- 上笔还款金额
    ,last_pmt_date date -- 上个还款日期
    ,last_stmt_date date -- 上个到期还款日期
    ,last_pmt_due_date date -- 上个到期还款日期
    ,last_aging_date date -- 上个逾期月数提升日期
    ,collect_date date -- 入催日期
    ,collect_out_date date -- 出催收队列日期
    ,next_stmt_date date -- 下个到期还款日期
    ,pmt_due_date date -- 到期还款日期
    ,dd_date date -- 约定还款日期
    ,grace_date date -- 宽限日期
    ,dlbl_date date -- 本币还外币日期
    ,closed_date date -- 最终销户日期
    ,first_stmt_date date -- 首个到期还款日期
    ,cancel_date date -- 销户日期
    ,charge_off_date date -- 转呆账日期
    ,first_purchase_date date -- 首次消费日期
    ,first_purchase_amt number(19,6) -- 首次消费金额
    ,tot_due_amt number(19,6) -- 最小还款额
    ,curr_due_amt number(19,6) -- 当期最小还款额
    ,past_due_amt1 number(19,6) -- 上个月最小还款额
    ,past_due_amt2 number(19,6) -- 上2个月最小还款额
    ,past_due_amt3 number(19,6) -- 上3个月最小还款额
    ,past_due_amt4 number(19,6) -- 上4个月最小还款额
    ,past_due_amt5 number(19,6) -- 上5个月最小还款额
    ,past_due_amt6 number(19,6) -- 上6个月最小还款额
    ,past_due_amt7 number(19,6) -- 上7个月最小还款额
    ,past_due_amt8 number(19,6) -- 上8个月最小还款额
    ,ctd_cash_amt number(19,6) -- 当期取现金额
    ,ctd_cash_cnt number(22) -- 当期取现笔数
    ,ctd_retail_amt number(15,2) -- 当期消费金额
    ,ctd_retail_cnt number(22) -- 当期消费笔数
    ,ctd_payment_amt number(15,2) -- 当期还款金额
    ,ctd_payment_cnt number(22) -- 当期还款笔数
    ,ctd_db_adj_amt number(15,2) -- 当期借记调整金额
    ,ctd_db_adj_cnt number(22) -- 当期借记调整笔数
    ,ctd_cr_adj_amt number(15,2) -- 当期贷记调整金额
    ,ctd_cr_adj_cnt number(22) -- 当期贷记调整笔数
    ,ctd_fee_amt number(15,2) -- 当期费用金额
    ,ctd_fee_cnt number(22) -- 当期费用笔数
    ,ctd_interest_amt number(15,2) -- 当期利息金额
    ,ctd_interest_cnt number(22) -- 当期利息笔数
    ,ctd_refund_amt number(19,6) -- 当期退货金额
    ,ctd_refund_cnt number(22) -- 当期退货笔数
    ,ctd_hi_ovrlmt_amt number(19,6) -- 当期最高超限金额
    ,mtd_retail_amt number(15,2) -- 本月消费金额
    ,mtd_retail_cnt number(22) -- 本月消费笔数
    ,mtd_cash_amt number(19,6) -- 本月取现金额
    ,mtd_cash_cnt number(22) -- 本月取现笔数
    ,mtd_refund_amt number(19,6) -- 本月退货金额
    ,mtd_refund_cnt number(22) -- 本月退货笔数
    ,ytd_retail_amt number(15,2) -- 本年消费金额
    ,ytd_retail_cnt number(22) -- 本年消费笔数
    ,ytd_cash_amt number(19,6) -- 本年取现金额
    ,ytd_cash_cnt number(22) -- 本年取现笔数
    ,ytd_refund_amt number(19,6) -- 本年退货金额
    ,ytd_refund_cnt number(22) -- 本年退货笔数
    ,ytd_ovrlmt_fee_amt number(19,6) -- 本年超限费收取金额
    ,ytd_ovrlmt_fee_cnt number(22) -- 本年超限费收取笔数
    ,ytd_lpc_amt number(19,6) -- 本年滞纳金收取金额
    ,ytd_lpc_cnt number(22) -- 本年滞纳金收取笔数
    ,ltd_retail_amt number(19,6) -- 历史消费金额
    ,ltd_retail_cnt number(22) -- 历史消费笔数
    ,ltd_cash_amt number(19,6) -- 历史取现金额
    ,ltd_cash_cnt number(22) -- 历史取现笔数
    ,ltd_refund_amt number(19,6) -- 历史退货金额
    ,ltd_refund_cnt number(22) -- 历史退货笔数
    ,ltd_highest_principal number(19,6) -- 历史最高本金欠款
    ,ltd_highest_cr_bal number(19,6) -- 历史最高溢缴款
    ,ltd_highest_bal number(19,6) -- 历史最高余额
    ,buser_field23 number(22) -- 系统备用域23
    ,buser_field24 varchar2(90) -- 系统备用域24
    ,buser_field25 varchar2(90) -- 系统备用域25
    ,buser_field26 varchar2(90) -- 系统备用域26
    ,buser_field27 varchar2(90) -- 系统备用域27
    ,waive_ovlfee_ind varchar2(90) -- 是否免除超限费
    ,waive_cardfee_ind varchar2(90) -- 是否免除年费
    ,waive_latefee_ind varchar2(90) -- 是否免除滞纳金
    ,waive_svcfee_ind varchar2(2) -- 是否免除服务费
    ,user_code1 varchar2(90) -- 用户自定义代码1
    ,user_code2 varchar2(90) -- 用户自定义代码2
    ,user_code3 varchar2(90) -- 用户自定义代码3
    ,user_code4 varchar2(90) -- 用户自定义代码4
    ,user_code5 varchar2(90) -- 用户自定义代码5
    ,user_code6 varchar2(90) -- 用户自定义代码6
    ,user_date1 date -- 用户自定义日期1
    ,user_date2 date -- 上次调额日期
    ,user_date3 date -- 用户自定义日期3
    ,user_date4 date -- 用户自定义日期4
    ,user_date5 date -- 用户自定义日期5
    ,user_date6 date -- 用户自定义日期6
    ,user_number1 number(22) -- 用户自定义笔数1
    ,user_number2 number(22) -- 用户自定义笔数2
    ,user_number3 number(22) -- 用户自定义笔数3
    ,user_number4 number(22) -- 用户自定义笔数4
    ,user_number5 number(22) -- 用户自定义笔数5
    ,user_number6 number(22) -- 用户自定义笔数6
    ,user_field1 varchar2(90) -- 用户自定义域1
    ,user_field2 varchar2(90) -- 用户自定义域2
    ,user_field3 varchar2(90) -- 用户自定义域3
    ,user_field4 varchar2(90) -- 用户自定义域4
    ,user_field5 varchar2(90) -- 用户自定义域5
    ,user_field6 varchar2(90) -- 用户自定义域6
    ,user_amt1 number(19,6) -- 用户自定义金额1
    ,user_amt2 number(19,6) -- 用户自定义金额2
    ,user_amt3 number(19,6) -- 用户自定义金额3
    ,user_amt4 number(19,6) -- 用户自定义金额4
    ,user_amt5 number(19,6) -- 用户自定义金额5
    ,user_amt6 number(19,6) -- 昨日贷记卡承诺余额
    ,jpa_version number(22) -- 乐观锁版本号
    ,mtd_payment_amt number(15,2) -- 当月还款金额
    ,mtd_payment_cnt number(22) -- 当月还款笔数
    ,ytd_payment_amt number(15,2) -- 当年还款金额
    ,ytd_payment_cnt number(22) -- 当年还款笔数
    ,ltd_payment_amt number(15,2) -- 历史还款金额
    ,ltd_payment_cnt number(22) -- 历史还款笔数
    ,sms_ind varchar2(90) -- 短信发送标识
    ,user_sms_amt number(19,6) -- 个性化动账短信发送阈值
    ,ytd_cycle_chag_cnt number(22) -- 本年度账单日修改次数
    ,last_post_date date -- 上个批量处理日期
    ,last_modified_datetime date -- 修改时间
    ,lock_date date -- 自动锁定日
    ,last_sync_date date -- 上一次入账的批量日期
    ,created_datetime date -- 创建时间
    ,delay_bal number(19,6) -- 账户逾期金额
    ,ext_1 varchar2(90) -- 扩展字段
    ,bank_group_id varchar2(8) -- 银团编号
    ,bank_proportion number(5,2) -- 银行出资比例
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a0ntm_account to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_account to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_account to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_account is '账户信息表-核心批量';
comment on column ${iol_schema}.mpcs_a0ntm_account.org is '机构号';
comment on column ${iol_schema}.mpcs_a0ntm_account.acct_no is '账户编号';
comment on column ${iol_schema}.mpcs_a0ntm_account.acct_type is '账户类型';
comment on column ${iol_schema}.mpcs_a0ntm_account.cust_id is '客户编号';
comment on column ${iol_schema}.mpcs_a0ntm_account.cust_limit_id is '客户额度id';
comment on column ${iol_schema}.mpcs_a0ntm_account.product_cd is '产品代码';
comment on column ${iol_schema}.mpcs_a0ntm_account.default_logical_card_no is '默认逻辑卡号';
comment on column ${iol_schema}.mpcs_a0ntm_account.curr_cd is '币种';
comment on column ${iol_schema}.mpcs_a0ntm_account.credit_limit is '授信额度';
comment on column ${iol_schema}.mpcs_a0ntm_account.temp_limit is '临时额度';
comment on column ${iol_schema}.mpcs_a0ntm_account.temp_limit_begin_date is '临时额度开始日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.temp_limit_end_date is '临时额度结束日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.cash_limit_rt is '取现额度比例';
comment on column ${iol_schema}.mpcs_a0ntm_account.ovrlmt_rate is '授权超限比例';
comment on column ${iol_schema}.mpcs_a0ntm_account.loan_limit_rt is '额度内分期额度比例';
comment on column ${iol_schema}.mpcs_a0ntm_account.curr_bal is '当前余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.cash_bal is '取现余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.principal_bal is '本金余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.loan_bal is '额度内分期余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.dispute_amt is '争议金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.begin_bal is '上一到期日余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.pmt_due_day_bal is '到期还款日余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.qual_grace_bal is '全部应还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.grace_days_full_ind is '是否已全额还款';
comment on column ${iol_schema}.mpcs_a0ntm_account.point_begin_bal is '期初积分余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_earned_points is '当期新增积分';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_disb_points is '当期兑换积分';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_adj_points is '当期调整积分';
comment on column ${iol_schema}.mpcs_a0ntm_account.point_bal is '积分余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.setup_date is '创建日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.dorment_date is '账户睡眠日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.reinstate_date is '账户恢复活动日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.ovrlmt_date is '超限日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.ovrlmt_nbr_of_cyc is '连续超限账期';
comment on column ${iol_schema}.mpcs_a0ntm_account.name is '姓名';
comment on column ${iol_schema}.mpcs_a0ntm_account.gender is '性别';
comment on column ${iol_schema}.mpcs_a0ntm_account.owning_branch is '发卡网点';
comment on column ${iol_schema}.mpcs_a0ntm_account.mobile_no is '移动电话';
comment on column ${iol_schema}.mpcs_a0ntm_account.corp_name is '公司名称';
comment on column ${iol_schema}.mpcs_a0ntm_account.billing_cycle is '还款日';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_flag is '账单标志';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_mail_addr_ind is '账单寄送地址标志';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_media_type is '账单介质类型';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_country_cd is '账单地址国家代码';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_state is '账单地址省份';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_city is '账单地址城市';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_district is '账单地址行政区';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_address is '账单地址';
comment on column ${iol_schema}.mpcs_a0ntm_account.stmt_zip is '账单地址邮政编码';
comment on column ${iol_schema}.mpcs_a0ntm_account.email is '电子邮箱';
comment on column ${iol_schema}.mpcs_a0ntm_account.buser_field21 is '系统备用域21';
comment on column ${iol_schema}.mpcs_a0ntm_account.age_cd is '拖欠月数';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_field22 is '系统备用域22';
comment on column ${iol_schema}.mpcs_a0ntm_account.unmatch_db is '未入账借记金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.unmatch_cash is '未匹配取现金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.unmatch_cr is '未入账贷记金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.dd_ind is '约定还款类型';
comment on column ${iol_schema}.mpcs_a0ntm_account.dd_bank_name is '约定还款银行名称';
comment on column ${iol_schema}.mpcs_a0ntm_account.dd_bank_branch is '约定还款开户行号';
comment on column ${iol_schema}.mpcs_a0ntm_account.dd_bank_acct_no is '约定还款扣款账号';
comment on column ${iol_schema}.mpcs_a0ntm_account.dd_bank_acct_name is '约定还款扣款账户姓名';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_dd_amt is '上期约定还款金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_dd_date is '上期约定还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.dual_billing_flag is '本币溢缴款还外币指示';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_pmt_amt is '上笔还款金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_pmt_date is '上个还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_stmt_date is '上个到期还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_pmt_due_date is '上个到期还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_aging_date is '上个逾期月数提升日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.collect_date is '入催日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.collect_out_date is '出催收队列日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.next_stmt_date is '下个到期还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.pmt_due_date is '到期还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.dd_date is '约定还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.grace_date is '宽限日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.dlbl_date is '本币还外币日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.closed_date is '最终销户日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.first_stmt_date is '首个到期还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.cancel_date is '销户日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.charge_off_date is '转呆账日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.first_purchase_date is '首次消费日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.first_purchase_amt is '首次消费金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.tot_due_amt is '最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.curr_due_amt is '当期最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.past_due_amt1 is '上个月最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.past_due_amt2 is '上2个月最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.past_due_amt3 is '上3个月最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.past_due_amt4 is '上4个月最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.past_due_amt5 is '上5个月最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.past_due_amt6 is '上6个月最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.past_due_amt7 is '上7个月最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.past_due_amt8 is '上8个月最小还款额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_cash_amt is '当期取现金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_cash_cnt is '当期取现笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_retail_amt is '当期消费金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_retail_cnt is '当期消费笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_payment_amt is '当期还款金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_payment_cnt is '当期还款笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_db_adj_amt is '当期借记调整金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_db_adj_cnt is '当期借记调整笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_cr_adj_amt is '当期贷记调整金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_cr_adj_cnt is '当期贷记调整笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_fee_amt is '当期费用金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_fee_cnt is '当期费用笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_interest_amt is '当期利息金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_interest_cnt is '当期利息笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_refund_amt is '当期退货金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_refund_cnt is '当期退货笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ctd_hi_ovrlmt_amt is '当期最高超限金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.mtd_retail_amt is '本月消费金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.mtd_retail_cnt is '本月消费笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.mtd_cash_amt is '本月取现金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.mtd_cash_cnt is '本月取现笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.mtd_refund_amt is '本月退货金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.mtd_refund_cnt is '本月退货笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_retail_amt is '本年消费金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_retail_cnt is '本年消费笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_cash_amt is '本年取现金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_cash_cnt is '本年取现笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_refund_amt is '本年退货金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_refund_cnt is '本年退货笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_ovrlmt_fee_amt is '本年超限费收取金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_ovrlmt_fee_cnt is '本年超限费收取笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_lpc_amt is '本年滞纳金收取金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_lpc_cnt is '本年滞纳金收取笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_retail_amt is '历史消费金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_retail_cnt is '历史消费笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_cash_amt is '历史取现金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_cash_cnt is '历史取现笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_refund_amt is '历史退货金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_refund_cnt is '历史退货笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_highest_principal is '历史最高本金欠款';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_highest_cr_bal is '历史最高溢缴款';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_highest_bal is '历史最高余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.buser_field23 is '系统备用域23';
comment on column ${iol_schema}.mpcs_a0ntm_account.buser_field24 is '系统备用域24';
comment on column ${iol_schema}.mpcs_a0ntm_account.buser_field25 is '系统备用域25';
comment on column ${iol_schema}.mpcs_a0ntm_account.buser_field26 is '系统备用域26';
comment on column ${iol_schema}.mpcs_a0ntm_account.buser_field27 is '系统备用域27';
comment on column ${iol_schema}.mpcs_a0ntm_account.waive_ovlfee_ind is '是否免除超限费';
comment on column ${iol_schema}.mpcs_a0ntm_account.waive_cardfee_ind is '是否免除年费';
comment on column ${iol_schema}.mpcs_a0ntm_account.waive_latefee_ind is '是否免除滞纳金';
comment on column ${iol_schema}.mpcs_a0ntm_account.waive_svcfee_ind is '是否免除服务费';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_code1 is '用户自定义代码1';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_code2 is '用户自定义代码2';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_code3 is '用户自定义代码3';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_code4 is '用户自定义代码4';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_code5 is '用户自定义代码5';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_code6 is '用户自定义代码6';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_date1 is '用户自定义日期1';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_date2 is '上次调额日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_date3 is '用户自定义日期3';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_date4 is '用户自定义日期4';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_date5 is '用户自定义日期5';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_date6 is '用户自定义日期6';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_number1 is '用户自定义笔数1';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_number2 is '用户自定义笔数2';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_number3 is '用户自定义笔数3';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_number4 is '用户自定义笔数4';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_number5 is '用户自定义笔数5';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_number6 is '用户自定义笔数6';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_field1 is '用户自定义域1';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_field2 is '用户自定义域2';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_field3 is '用户自定义域3';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_field4 is '用户自定义域4';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_field5 is '用户自定义域5';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_field6 is '用户自定义域6';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_amt1 is '用户自定义金额1';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_amt2 is '用户自定义金额2';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_amt3 is '用户自定义金额3';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_amt4 is '用户自定义金额4';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_amt5 is '用户自定义金额5';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_amt6 is '昨日贷记卡承诺余额';
comment on column ${iol_schema}.mpcs_a0ntm_account.jpa_version is '乐观锁版本号';
comment on column ${iol_schema}.mpcs_a0ntm_account.mtd_payment_amt is '当月还款金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.mtd_payment_cnt is '当月还款笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_payment_amt is '当年还款金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_payment_cnt is '当年还款笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_payment_amt is '历史还款金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ltd_payment_cnt is '历史还款笔数';
comment on column ${iol_schema}.mpcs_a0ntm_account.sms_ind is '短信发送标识';
comment on column ${iol_schema}.mpcs_a0ntm_account.user_sms_amt is '个性化动账短信发送阈值';
comment on column ${iol_schema}.mpcs_a0ntm_account.ytd_cycle_chag_cnt is '本年度账单日修改次数';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_post_date is '上个批量处理日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_modified_datetime is '修改时间';
comment on column ${iol_schema}.mpcs_a0ntm_account.lock_date is '自动锁定日';
comment on column ${iol_schema}.mpcs_a0ntm_account.last_sync_date is '上一次入账的批量日期';
comment on column ${iol_schema}.mpcs_a0ntm_account.created_datetime is '创建时间';
comment on column ${iol_schema}.mpcs_a0ntm_account.delay_bal is '账户逾期金额';
comment on column ${iol_schema}.mpcs_a0ntm_account.ext_1 is '扩展字段';
comment on column ${iol_schema}.mpcs_a0ntm_account.bank_group_id is '银团编号';
comment on column ${iol_schema}.mpcs_a0ntm_account.bank_proportion is '银行出资比例';
comment on column ${iol_schema}.mpcs_a0ntm_account.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_account.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_account.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ntm_account.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ntm_account.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ntm_account.etl_timestamp is 'ETL处理时间戳';
