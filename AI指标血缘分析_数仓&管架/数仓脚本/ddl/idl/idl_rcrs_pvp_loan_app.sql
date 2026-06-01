/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl rcrs_pvp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.rcrs_pvp_loan_app
whenever sqlerror continue none;
drop table ${idl_schema}.rcrs_pvp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.rcrs_pvp_loan_app(
    etl_dt date -- ETL处理日期   
    ,serno varchar2(32) -- 业务流水号   
    ,prd_pk varchar2(32) -- 产品主键   
    ,biz_type varchar2(20) -- 产品编号   
    ,prd_name varchar2(60) -- 产品名称   
    ,prd_type varchar2(3) -- 产品类型   
    ,app_form varchar2(60) -- 表单类型   
    ,cont_no varchar2(30) -- 合同编号   
    ,bill_no varchar2(30) -- 借据编号   
    ,funds_src varchar2(2) -- 资金来源   
    ,account_class varchar2(20) -- 科目号   
    ,credit_class varchar2(100) -- 信用科目号   
    ,assure_class varchar2(10) -- 保证科目号   
    ,pledge_class varchar2(100) -- 抵押科目号   
    ,impawn_class varchar2(10) -- 质押科目号   
    ,cus_id varchar2(30) -- 客户号   
    ,cus_name varchar2(60) -- 客户名称   
    ,cur_type varchar2(3) -- 币种   
    ,con_amount number(16,2) -- 合同金额   
    ,avail_amt number(16,2) -- 合同可用余额   
    ,loan_amount number(16,2) -- 出账金额   
    ,loan_start_date varchar2(10) -- 贷款起始日   
    ,loan_end_date varchar2(10) -- 贷款终止日   
    ,ruling_ir number(16,9) -- 基准利率(月)   
    ,floating_rate number(16,9) -- 利率浮动值   
    ,reality_ir_y number(16,9) -- 执行利率(月)   
    ,overdue_rate number(16,9) -- 逾期利率浮动比例   
    ,overdue_ir number(16,9) -- 逾期加罚月利率   
    ,default_rate number(16,9) -- 挤占挪用利率浮动比例   
    ,default_ir number(16,9) -- 违约月利率   
    ,ci_rate number(16,9) -- 复利加罚率   
    ,ci_ir number(16,9) -- 复利月利率   
    ,assure_means_main varchar2(2) -- 主担保方式   
    ,assure_means2 varchar2(2) -- 担保方式2   
    ,assure_means3 varchar2(2) -- 担保方式3   
    ,enter_account varchar2(32) -- 入账账号   
    ,enter_account_name varchar2(80) -- 入账账户名称   
    ,repayment_account varchar2(32) -- 还款账号   
    ,repayment_acc_name varchar2(80) -- 还款账户名称   
    ,mortgage_flg varchar2(1) -- 按揭标识   
    ,repayment_mode varchar2(1) -- 还款方式   
    ,interest_acc_mode varchar2(1) -- 结息周期   
    ,ir_adjust_mode varchar2(1) -- 利率调整方式   
    ,delay_deduct_type varchar2(2) -- 扣款方式   
    ,loan_direction varchar2(4) -- 贷款投向   
    ,direction_name varchar2(200) -- 投向名称   
    ,loan_form varchar2(1) -- 贷款形式   
    ,loan_nature varchar2(2) -- 贷款性质   
    ,loan_kind_ca varchar2(2) -- 贷款种类(征信)   
    ,biz_type_sub varchar2(8) -- 业务品种   
    ,loan_use_type varchar2(2) -- 借款用途类型   
    ,loan_type_ext varchar2(2) -- 关联交易类型   
    ,delay_days number -- 宽限天数   
    ,discont_ind varchar2(1) -- 是否贴息   
    ,discont_id varchar2(30) -- 贴息方编号   
    ,discont_type varchar2(2) -- 贴息方式   
    ,discont_acc varchar2(32) -- 贴息账号   
    ,discont_acc_name varchar2(60) -- 贴息账户名称   
    ,discount_rate number(10,4) -- 贴息比率   
    ,discount_amount number(16,2) -- 贴息金额   
    ,discont_acc2 varchar2(32) -- 贴息账号2   
    ,discont_acc_name2 varchar2(60) -- 贴息账户名称2   
    ,discount_rate2 number(10,4) -- 贴息比率2   
    ,discount_amount2 number(16,2) -- 贴息金额2   
    ,discont_acc3 varchar2(32) -- 贴息账号3   
    ,discont_acc_name3 varchar2(60) -- 贴息账户名称3   
    ,discount_rate3 number(10,4) -- 贴息比率3   
    ,discount_amount3 number(16,2) -- 贴息金额3   
    ,ass_acc varchar2(32) -- 担保方扣款账号(消费贷款)   
    ,ass_acc_name varchar2(60) -- 担保方扣款账号户名(消费贷款)   
    ,ass_sec_acc varchar2(32) -- 保证金账号   
    ,ass_sec_acc_name varchar2(60) -- 保证金账号户名   
    ,limit_ind varchar2(1) -- 授信额度使用标志   
    ,pay_way varchar2(1) -- 支付方式   
    ,benifit_acc varchar2(32) -- 受益人账号   
    ,benifit_amount number(16,2) -- 受益金额   
    ,benifit_bank_id varchar2(12) -- 受益人开户行行号   
    ,benifit_bank varchar2(60) -- 受益人开户行行名   
    ,benifit_name varchar2(60) -- 受益人名称   
    ,transfer_amount number(16,2) -- 转账金额   
    ,cash_amount number(16,2) -- 自主支付金额   
    ,proc_fee_amount number(16,2) -- 手续费金额   
    ,transfer_dec varchar2(255) -- 转账用途   
    ,chargeoff_ind varchar2(1) -- 授信额度使用标志   
    ,chargeoff_dec varchar2(200) -- 出账落实条件说明   
    ,dd_workflow_id varchar2(32) -- 放款流程   
    ,approve_status varchar2(3) -- 审批状态   
    ,input_id varchar2(20) -- 登记(受理人)   
    ,examinant_id varchar2(20) -- 审查人   
    ,investigator_id varchar2(20) -- 调查人   
    ,cus_manager varchar2(20) -- 客户经理   
    ,apply_date varchar2(10) -- 申请日期   
    ,input_date varchar2(10) -- 受理日期   
    ,input_br_id varchar2(20) -- 受理机构   
    ,investigator_br_id varchar2(20) -- 调查机构   
    ,fina_br_id varchar2(16) -- 账务机构   
    ,main_br_id varchar2(20) -- 主管机构   
    ,own_system varchar2(1) -- 所属系统   
    ,chargeoff_status varchar2(1) -- 出账状态   
    ,src_account varchar2(32) -- 来源账号   
    ,src_account_name varchar2(80) -- 来源账户名称   
    ,biz_type_detail varchar2(100) -- 业务品种名称   
    ,ir_exe_type varchar2(2) -- 利率变更生效方式   
    ,int_rate_type varchar2(1) -- 利率类型   
    ,int_rate_inc_opt varchar2(1) -- 利率增量选项   
    ,int_rate_inc number(16,9) -- 利率增量   
    ,fixed_rate number(16,9) -- 固定利率   
    ,prd_userdf_name varchar2(60) -- 产品自定义名称   
    ,prd_userdf_type varchar2(60) -- 产品自定义类别   
    ,return_date varchar2(2) -- 还款日   
    ,chargeoff_manage varchar2(20) -- 出帐负责人   
    ,consign_fund_protocol_no varchar2(32) -- 资金协议编号   
    ,ispaf varchar2(1) -- 是否住房公积金贷款   
    ,distribution_day varchar2(2) -- 分配日   
    ,money_origin_id varchar2(1) -- 分配方式   
    ,overdue_type varchar2(1) -- 逾期利率浮动类型   
    ,default_type varchar2(1) -- 挤占利率浮动类型   
    ,ass_sec_acc_bal number(16,2) -- 保证金账户余额   
    ,ass_sec_amt number(16,2) -- 本笔保证金金额   
    ,ass_sec_dep_date varchar2(10) -- 本笔保证金存入日期   
    ,repayment_account1 varchar2(32) -- 还款账号1   
    ,repayment_acc_name1 varchar2(32) -- 还款账号1   
    ,cus_area varchar2(20) -- 客户所属片区   
    ,loan_card_ind varchar2(1) -- 使用农户贷款证标志   
    ,agriculture_type varchar2(2) -- 涉农情况   
    ,agriculture_use varchar2(4) -- 涉农用途   
    ,minor_entrp_range varchar2(1) -- 小企业统计口径(银监)   
    ,government_ind varchar2(1) -- 涉政类型   
    ,government_org_attribute varchar2(4) -- 涉政机构属性   
    ,government_platform varchar2(4) -- 是否为涉政平台   
    ,ass_sec_ind varchar2(1) -- 是否需存入保证金   
    ,guarantora_grp_ind varchar2(1) -- 联保贷款标志   
    ,loan_fund_whither varchar2(1) -- 贷款款项去向   
    ,interest_date varchar2(10) -- 结息日   
    ,cn_cont_no varchar2(100) -- 主合同号   
    ,syndicated_proxy_id varchar2(20) -- 代理社机构码   
    ,sec_money_ac varchar2(32) -- 基础保证金账号   
    ,sec_money_ac_name varchar2(60) -- 基础保证金账户名称   
    ,sec_money_init number(16,2) -- 基础保证金起存金额   
    ,sec_money_rate number(10,4) -- 业务保证金比例   
    ,freeze_no varchar2(32) -- 冻结编号   
    ,freeze_name varchar2(60) -- 冻结账户名称   
    ,freeze_amt number(16,2) -- 冻结止付金额   
    ,farm_card_type varchar2(1) -- 贷款发放形式   
    ,check_finger varchar2(1) -- 指纹检查状态   
    ,loan_term number(22,0) -- 贷款期限   
    ,term_time_type varchar2(3) -- 贷款时间类型   
    ,due_day varchar2(10) -- 还款日期   
    ,pay_distance varchar2(10) -- 还款间隔   
    ,old_bill_no varchar2(32) -- 原借据编号   
    ,is_risk varchar2(1) -- 是否低风险（1-是，2-否）   
    ,invst_concl varchar2(350) -- 调查人意见   
    ,security_money_ind_zy varchar2(10) -- 是否录入保证金（专业担保公司）   
    ,security_money_ac_no_zy varchar2(32) -- 保证金账号（专业担保公司）   
    ,security_money_child_acc_no_zy varchar2(64) -- 保证金子账号（专业担保公司）   
    ,security_money_amt_zy number(16,9) -- 业务保证金金额（专业担保公司）   
    ,security_money_ac_name_zy varchar2(32) -- 保证金账户名（专业担保公司）   
    ,adv_rpay_flg varchar2(1) -- 是否允许提前还款   
    ,made_rpay_plan varchar2(1) -- 是否定制还款计划   
    ,enter_account_type varchar2(20) -- 入账账户支付工具类型   
    ,repayment_account_type varchar2(20) -- 还款账户支付工具类型   
    ,businum varchar2(40) -- 委托支付编号   
    ,trade_serno varchar2(100) -- 贷款开户贷款产品流水号   
    ,repayment_date_confirm varchar2(1) -- 还款日确定   
    ,auth_review varchar2(2000) -- 放款审核岗审批意见   
    ,is_cl varchar2(1) --    
    ,is_loan_anytime varchar2(1) -- 合同是否随借随还标识   
    ,is_balloon varchar2(1) -- 是否选择气球贷   
    ,last_term_amount number(16,2) -- 最后一期保留金额   
    ,last_term_percent number(2,2) -- 最后一期还本金额比例   
    ,tax_amount number(16,2) -- 印花税   
    ,tax_account varchar2(32) -- 印花税扣税账户   
    ,tax_account_name varchar2(80) -- 印花税扣税账户名称   
    ,tax_account_type varchar2(20) -- 印花税扣税账户支付工具类型   
    ,is_record_tax varchar2(1) -- 是否录入印花税   
    ,rate_type varchar2(3) -- 利率类型 1 基准利率 2 lpr   
    ,loan_rel_date varchar2(10) -- 贷款实际发放日   
    ,start_dt date -- 开始时间   
    ,end_dt date -- 结束时间   
    ,id_mark varchar2(10) -- 增删标志  
    ,etl_timestamp TIMESTAMP --数据处理时间 
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.rcrs_pvp_loan_app to ${iel_schema};

-- comment
comment on table ${idl_schema}.rcrs_pvp_loan_app is '出账申请信息表';
comment on column ${idl_schema}.rcrs_pvp_loan_app.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.rcrs_pvp_loan_app.serno is '业务流水号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.prd_pk is '产品主键';
comment on column ${idl_schema}.rcrs_pvp_loan_app.biz_type is '产品编号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.prd_name is '产品名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.prd_type is '产品类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.app_form is '表单类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.cont_no is '合同编号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.bill_no is '借据编号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.funds_src is '资金来源';
comment on column ${idl_schema}.rcrs_pvp_loan_app.account_class is '科目号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.credit_class is '信用科目号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.assure_class is '保证科目号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.pledge_class is '抵押科目号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.impawn_class is '质押科目号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.cus_id is '客户号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.cus_name is '客户名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.cur_type is '币种';
comment on column ${idl_schema}.rcrs_pvp_loan_app.con_amount is '合同金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.avail_amt is '合同可用余额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_amount is '出账金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_start_date is '贷款起始日';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_end_date is '贷款终止日';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ruling_ir is '基准利率(月)';
comment on column ${idl_schema}.rcrs_pvp_loan_app.floating_rate is '利率浮动值';
comment on column ${idl_schema}.rcrs_pvp_loan_app.reality_ir_y is '执行利率(月)';
comment on column ${idl_schema}.rcrs_pvp_loan_app.overdue_rate is '逾期利率浮动比例';
comment on column ${idl_schema}.rcrs_pvp_loan_app.overdue_ir is '逾期加罚月利率';
comment on column ${idl_schema}.rcrs_pvp_loan_app.default_rate is '挤占挪用利率浮动比例';
comment on column ${idl_schema}.rcrs_pvp_loan_app.default_ir is '违约月利率';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ci_rate is '复利加罚率';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ci_ir is '复利月利率';
comment on column ${idl_schema}.rcrs_pvp_loan_app.assure_means_main is '主担保方式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.assure_means2 is '担保方式2';
comment on column ${idl_schema}.rcrs_pvp_loan_app.assure_means3 is '担保方式3';
comment on column ${idl_schema}.rcrs_pvp_loan_app.enter_account is '入账账号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.enter_account_name is '入账账户名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.repayment_account is '还款账号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.repayment_acc_name is '还款账户名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.mortgage_flg is '按揭标识';
comment on column ${idl_schema}.rcrs_pvp_loan_app.repayment_mode is '还款方式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.interest_acc_mode is '结息周期';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ir_adjust_mode is '利率调整方式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.delay_deduct_type is '扣款方式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_direction is '贷款投向';
comment on column ${idl_schema}.rcrs_pvp_loan_app.direction_name is '投向名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_form is '贷款形式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_nature is '贷款性质';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_kind_ca is '贷款种类(征信)';
comment on column ${idl_schema}.rcrs_pvp_loan_app.biz_type_sub is '业务品种';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_use_type is '借款用途类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_type_ext is '关联交易类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.delay_days is '宽限天数';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_ind is '是否贴息';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_id is '贴息方编号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_type is '贴息方式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_acc is '贴息账号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_acc_name is '贴息账户名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discount_rate is '贴息比率';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discount_amount is '贴息金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_acc2 is '贴息账号2';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_acc_name2 is '贴息账户名称2';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discount_rate2 is '贴息比率2';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discount_amount2 is '贴息金额2';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_acc3 is '贴息账号3';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discont_acc_name3 is '贴息账户名称3';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discount_rate3 is '贴息比率3';
comment on column ${idl_schema}.rcrs_pvp_loan_app.discount_amount3 is '贴息金额3';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ass_acc is '担保方扣款账号(消费贷款)';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ass_acc_name is '担保方扣款账号户名(消费贷款)';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ass_sec_acc is '保证金账号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ass_sec_acc_name is '保证金账号户名';
comment on column ${idl_schema}.rcrs_pvp_loan_app.limit_ind is '授信额度使用标志';
comment on column ${idl_schema}.rcrs_pvp_loan_app.pay_way is '支付方式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.benifit_acc is '受益人账号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.benifit_amount is '受益金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.benifit_bank_id is '受益人开户行行号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.benifit_bank is '受益人开户行行名';
comment on column ${idl_schema}.rcrs_pvp_loan_app.benifit_name is '受益人名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.transfer_amount is '转账金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.cash_amount is '自主支付金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.proc_fee_amount is '手续费金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.transfer_dec is '转账用途';
comment on column ${idl_schema}.rcrs_pvp_loan_app.chargeoff_ind is '授信额度使用标志';
comment on column ${idl_schema}.rcrs_pvp_loan_app.chargeoff_dec is '出账落实条件说明';
comment on column ${idl_schema}.rcrs_pvp_loan_app.dd_workflow_id is '放款流程';
comment on column ${idl_schema}.rcrs_pvp_loan_app.approve_status is '审批状态';
comment on column ${idl_schema}.rcrs_pvp_loan_app.input_id is '登记(受理人)';
comment on column ${idl_schema}.rcrs_pvp_loan_app.examinant_id is '审查人';
comment on column ${idl_schema}.rcrs_pvp_loan_app.investigator_id is '调查人';
comment on column ${idl_schema}.rcrs_pvp_loan_app.cus_manager is '客户经理';
comment on column ${idl_schema}.rcrs_pvp_loan_app.apply_date is '申请日期';
comment on column ${idl_schema}.rcrs_pvp_loan_app.input_date is '受理日期';
comment on column ${idl_schema}.rcrs_pvp_loan_app.input_br_id is '受理机构';
comment on column ${idl_schema}.rcrs_pvp_loan_app.investigator_br_id is '调查机构';
comment on column ${idl_schema}.rcrs_pvp_loan_app.fina_br_id is '账务机构';
comment on column ${idl_schema}.rcrs_pvp_loan_app.main_br_id is '主管机构';
comment on column ${idl_schema}.rcrs_pvp_loan_app.own_system is '所属系统';
comment on column ${idl_schema}.rcrs_pvp_loan_app.chargeoff_status is '出账状态';
comment on column ${idl_schema}.rcrs_pvp_loan_app.src_account is '来源账号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.src_account_name is '来源账户名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.biz_type_detail is '业务品种名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ir_exe_type is '利率变更生效方式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.int_rate_type is '利率类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.int_rate_inc_opt is '利率增量选项';
comment on column ${idl_schema}.rcrs_pvp_loan_app.int_rate_inc is '利率增量';
comment on column ${idl_schema}.rcrs_pvp_loan_app.fixed_rate is '固定利率';
comment on column ${idl_schema}.rcrs_pvp_loan_app.prd_userdf_name is '产品自定义名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.prd_userdf_type is '产品自定义类别';
comment on column ${idl_schema}.rcrs_pvp_loan_app.return_date is '还款日';
comment on column ${idl_schema}.rcrs_pvp_loan_app.chargeoff_manage is '出帐负责人';
comment on column ${idl_schema}.rcrs_pvp_loan_app.consign_fund_protocol_no is '资金协议编号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ispaf is '是否住房公积金贷款';
comment on column ${idl_schema}.rcrs_pvp_loan_app.distribution_day is '分配日';
comment on column ${idl_schema}.rcrs_pvp_loan_app.money_origin_id is '分配方式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.overdue_type is '逾期利率浮动类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.default_type is '挤占利率浮动类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ass_sec_acc_bal is '保证金账户余额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ass_sec_amt is '本笔保证金金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ass_sec_dep_date is '本笔保证金存入日期';
comment on column ${idl_schema}.rcrs_pvp_loan_app.repayment_account1 is '还款账号1';
comment on column ${idl_schema}.rcrs_pvp_loan_app.repayment_acc_name1 is '还款账号1';
comment on column ${idl_schema}.rcrs_pvp_loan_app.cus_area is '客户所属片区';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_card_ind is '使用农户贷款证标志';
comment on column ${idl_schema}.rcrs_pvp_loan_app.agriculture_type is '涉农情况';
comment on column ${idl_schema}.rcrs_pvp_loan_app.agriculture_use is '涉农用途';
comment on column ${idl_schema}.rcrs_pvp_loan_app.minor_entrp_range is '小企业统计口径(银监)';
comment on column ${idl_schema}.rcrs_pvp_loan_app.government_ind is '涉政类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.government_org_attribute is '涉政机构属性';
comment on column ${idl_schema}.rcrs_pvp_loan_app.government_platform is '是否为涉政平台';
comment on column ${idl_schema}.rcrs_pvp_loan_app.ass_sec_ind is '是否需存入保证金';
comment on column ${idl_schema}.rcrs_pvp_loan_app.guarantora_grp_ind is '联保贷款标志';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_fund_whither is '贷款款项去向';
comment on column ${idl_schema}.rcrs_pvp_loan_app.interest_date is '结息日';
comment on column ${idl_schema}.rcrs_pvp_loan_app.cn_cont_no is '主合同号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.syndicated_proxy_id is '代理社机构码';
comment on column ${idl_schema}.rcrs_pvp_loan_app.sec_money_ac is '基础保证金账号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.sec_money_ac_name is '基础保证金账户名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.sec_money_init is '基础保证金起存金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.sec_money_rate is '业务保证金比例';
comment on column ${idl_schema}.rcrs_pvp_loan_app.freeze_no is '冻结编号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.freeze_name is '冻结账户名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.freeze_amt is '冻结止付金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.farm_card_type is '贷款发放形式';
comment on column ${idl_schema}.rcrs_pvp_loan_app.check_finger is '指纹检查状态';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_term is '贷款期限';
comment on column ${idl_schema}.rcrs_pvp_loan_app.term_time_type is '贷款时间类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.due_day is '还款日期';
comment on column ${idl_schema}.rcrs_pvp_loan_app.pay_distance is '还款间隔';
comment on column ${idl_schema}.rcrs_pvp_loan_app.old_bill_no is '原借据编号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.is_risk is '是否低风险（1-是，2-否）';
comment on column ${idl_schema}.rcrs_pvp_loan_app.invst_concl is '调查人意见';
comment on column ${idl_schema}.rcrs_pvp_loan_app.security_money_ind_zy is '是否录入保证金（专业担保公司）';
comment on column ${idl_schema}.rcrs_pvp_loan_app.security_money_ac_no_zy is '保证金账号（专业担保公司）';
comment on column ${idl_schema}.rcrs_pvp_loan_app.security_money_child_acc_no_zy is '保证金子账号（专业担保公司）';
comment on column ${idl_schema}.rcrs_pvp_loan_app.security_money_amt_zy is '业务保证金金额（专业担保公司）';
comment on column ${idl_schema}.rcrs_pvp_loan_app.security_money_ac_name_zy is '保证金账户名（专业担保公司）';
comment on column ${idl_schema}.rcrs_pvp_loan_app.adv_rpay_flg is '是否允许提前还款';
comment on column ${idl_schema}.rcrs_pvp_loan_app.made_rpay_plan is '是否定制还款计划';
comment on column ${idl_schema}.rcrs_pvp_loan_app.enter_account_type is '入账账户支付工具类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.repayment_account_type is '还款账户支付工具类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.businum is '委托支付编号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.trade_serno is '贷款开户贷款产品流水号';
comment on column ${idl_schema}.rcrs_pvp_loan_app.repayment_date_confirm is '还款日确定';
comment on column ${idl_schema}.rcrs_pvp_loan_app.auth_review is '放款审核岗审批意见';
comment on column ${idl_schema}.rcrs_pvp_loan_app.is_cl is '';
comment on column ${idl_schema}.rcrs_pvp_loan_app.is_loan_anytime is '合同是否随借随还标识';
comment on column ${idl_schema}.rcrs_pvp_loan_app.is_balloon is '是否选择气球贷';
comment on column ${idl_schema}.rcrs_pvp_loan_app.last_term_amount is '最后一期保留金额';
comment on column ${idl_schema}.rcrs_pvp_loan_app.last_term_percent is '最后一期还本金额比例';
comment on column ${idl_schema}.rcrs_pvp_loan_app.tax_amount is '印花税';
comment on column ${idl_schema}.rcrs_pvp_loan_app.tax_account is '印花税扣税账户';
comment on column ${idl_schema}.rcrs_pvp_loan_app.tax_account_name is '印花税扣税账户名称';
comment on column ${idl_schema}.rcrs_pvp_loan_app.tax_account_type is '印花税扣税账户支付工具类型';
comment on column ${idl_schema}.rcrs_pvp_loan_app.is_record_tax is '是否录入印花税';
comment on column ${idl_schema}.rcrs_pvp_loan_app.rate_type is '利率类型 1 基准利率 2 lpr';
comment on column ${idl_schema}.rcrs_pvp_loan_app.loan_rel_date is '贷款实际发放日';
comment on column ${idl_schema}.rcrs_pvp_loan_app.start_dt is '开始时间';
comment on column ${idl_schema}.rcrs_pvp_loan_app.end_dt is '结束时间';
comment on column ${idl_schema}.rcrs_pvp_loan_app.id_mark is '增删标志';
comment on column ${idl_schema}.rcrs_pvp_loan_app.etl_timestamp is '数据处理时间';