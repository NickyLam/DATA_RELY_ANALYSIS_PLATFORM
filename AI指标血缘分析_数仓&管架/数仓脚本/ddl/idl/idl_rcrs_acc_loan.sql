/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl rcrs_acc_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.rcrs_acc_loan
whenever sqlerror continue none;
drop table ${idl_schema}.rcrs_acc_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.rcrs_acc_loan(
    etl_dt date -- 数据日期   
    ,bill_no varchar2(30) -- 借据号   
    ,cont_no varchar2(30) -- 合同编号   
    ,cn_cont_no varchar2(100) -- 中文合同编号   
    ,prd_pk varchar2(32) -- 产品主键   
    ,biz_type varchar2(20) -- 产品编号   
    ,prd_name varchar2(60) -- 产品名称   
    ,prd_type varchar2(3) -- 产品类型   
    ,cus_id varchar2(30) -- 客户编号   
    ,cus_name varchar2(60) -- 客户名称   
    ,biz_type_sub varchar2(8) -- 业务品种   
    ,account_class varchar2(10) -- 业务品种名称   
    ,loan_account varchar2(32) -- 贷款账号   
    ,loan_form char(1) -- 贷款形式   
    ,loan_nature varchar2(2) -- 贷款性质   
    ,loan_type_ext char(2) -- 关联交易类型   
    ,assure_means_main char(2) -- 主担保方式   
    ,assure_means2 char(2) -- 主担保方式2   
    ,assure_means3 char(2) -- 主担保方式3   
    ,cur_type char(3) -- 币种   
    ,loan_amount number(16,2) -- 借据金额   
    ,loan_balance number(16,2) -- 借据余额   
    ,loan_start_date char(10) -- 贷款起始日   
    ,loan_end_date char(10) -- 贷款终止日   
    ,term_type char(1) -- 期限类型   
    ,orig_expi_date varchar2(10) -- 原到期日期   
    ,ruling_ir number(16,9) -- 基准利率(月)   
    ,floating_rate number(16,9) -- 利率浮动值   
    ,reality_ir_y number(16,9) -- 执行月利率   
    ,overdue_rate number(16,9) -- 逾期利率浮动比   
    ,overdue_ir number(16,9) -- 逾期加月利率   
    ,default_rate number(16,9) -- 挤占挪用利率浮动比例   
    ,default_ir number(16,9) -- 违约月利率   
    ,ci_rate number(16,9) -- 复利加罚率   
    ,ci_ir number(16,9) -- 复利月利率   
    ,rece_int_cumu number(16,2) -- 应收利息累计   
    ,actual_int_cumu number(16,2) -- 实收利息累计   
    ,delay_int_cumu number(16,2) -- 欠息累计   
    ,inner_int_cumu number(16,2) -- 表内欠息   
    ,off_int_cumu number(16,2) -- 表外欠息   
    ,inner_rece_int number(16,2) -- 表内应收   
    ,overdue_rece_int number(16,2) -- 逾期应收   
    ,off_rece_int number(16,2) -- 表外利息应收   
    ,compound_rece_int number(16,2) -- 利息复息应收   
    ,inner_off_rece_int number(16,2) -- 表内转表外利息应收   
    ,inner_actl_int number(16,2) -- 表内实收   
    ,overdue_actl_int number(16,2) -- 逾期实收   
    ,off_actl_int number(16,2) -- 表外利息实收   
    ,compound_actl_int number(16,2) -- 利息复息实收   
    ,inner_off_actl_int number(16,2) -- 表内转表外利息实收   
    ,normal_balance number(16,2) -- 正常贷款余额(元)   
    ,overdue_balance number(16,2) -- 逾期贷款余额(元)   
    ,sluggish_balance number(16,2) -- 呆滞贷款余额(元)   
    ,doubtful_balance number(16,2) -- 呆账贷款余额(元)   
    ,integral_y number(16,2) -- 积数_年   
    ,integral_q number(16,2) -- 积数_季   
    ,integral_m number(16,2) -- 积数_月   
    ,nor_rec_accu number(16,2) -- 正常回收累计   
    ,reo_rec_accu number(16,2) -- 资产重组累计   
    ,peel_rec_accu number(16,2) -- 资产剥离累计   
    ,asset_rec_accu number(16,2) -- 以资抵债累计   
    ,assure_rec_accu number(16,2) -- 担保代偿累计   
    ,cancel_rec_accu number(16,2) -- 核损核销累计   
    ,policy_rec_accu number(16,2) -- 政策性还款累计   
    ,dte_rec_accu number(16,2) -- 债转股累计   
    ,roll_rec_accu number(16,2) -- 转出累计   
    ,max_balance_y number(16,2) -- 本年最高余额   
    ,max_balance_q number(16,2) -- 本季最高余额   
    ,max_balance_m number(16,2) -- 本月最高余额   
    ,mortgage_flg char(1) -- 按揭标识   
    ,repayment_mode char(1) -- 还款方式   
    ,first_disb_date varchar2(10) -- 首次放款日期   
    ,loan_direction varchar2(4) -- 贷款投向   
    ,revolving_times number -- 借新还旧次数   
    ,extension_times number -- 展期次数   
    ,cap_overdue_date varchar2(10) -- 本金逾期起始日期   
    ,int_overdue_date varchar2(10) -- 利息逾期起始日期   
    ,over_times_current number -- 当前逾期期数   
    ,over_times_total number -- 累计逾期期数   
    ,max_times_total number -- 最高逾期期数   
    ,bad_loan_flag char(1) -- 转不良标志   
    ,default_flag char(1) -- 违约标识   
    ,limit_ind char(1) -- 授信额度使用标志   
    ,loan_form4 char(2) -- 四级分类标志   
    ,cla char(2) -- 五级分类结果   
    ,cla_date varchar2(10) -- 五级分类完成日期   
    ,cla_pre char(2) -- 上期五级分类结果   
    ,cla_date_pre varchar2(10) -- 上期五级分类完成日期   
    ,latest_repay_date varchar2(10) -- 最近还款日期   
    ,cus_manager varchar2(20) -- 客户经理   
    ,input_br_id varchar2(20) -- 录入机构   
    ,fina_br_id varchar2(20) -- 账务机构   
    ,main_br_id varchar2(20) -- 主管机构   
    ,settl_date varchar2(10) -- 结清日期   
    ,latest_date varchar2(10) -- 最近修改日期   
    ,account_status varchar2(2) -- 台帐状态   
    ,biz_type_detail varchar2(100) -- 业务品种名称   
    ,int_rate_type varchar2(2) -- 利率类型   
    ,int_rate_inc_opt char(1) -- 利率增量选项   
    ,int_rate_inc number(16,9) -- 利率增量   
    ,fixed_rate number(16,9) -- 固定利率   
    ,prd_userdf_name varchar2(60) -- 产品自定义名称   
    ,prd_userdf_type varchar2(60) -- 产品自定义类别   
    ,syndicated_ind char(1) -- 银团标识   
    ,unpd_int_arr_prn number(16,2) -- 应收利息的罚息(应收未收)   
    ,unpd_arrs_int_bal number(16,2) -- 拖欠本金的罚息(应收未收)   
    ,unpd_arr_prn_bal number(16,2) -- 应收复利(应收未收)   
    ,act_int_arr_prn number(16,2) -- 实收利息的罚息   
    ,act_arrs_int_bal number(16,2) -- 实收拖欠本金的罚息   
    ,act_arr_prn_bal number(16,2) -- 实收复利   
    ,gl_class varchar2(25) -- 科目号   
    ,iscircle char(1) -- 循环贷款标识   
    ,return_date varchar2(2) -- 还款日   
    ,act_write_off_int_rec number(16,2) -- 实收待核销利息   
    ,unpd_write_off_int_rec number(16,2) -- 应收待核销利息   
    ,unpd_prin_bal number(16,2) -- 拖欠本金   
    ,remark varchar2(60) -- 备注   
    ,consign_fund_protocol_no varchar2(32) -- 资金协议号   
    ,psp_task_crt_date varchar2(10) -- 贷后检查任务生成日期   
    ,psp_task_cpt_date varchar2(10) -- 贷后检查任务完成日期   
    ,rsc_task_crt_date varchar2(10) -- 五级分类任务生成日期   
    ,com_scale varchar2(3) -- 企业规模   
    ,cus_type char(3) -- 客户类型   
    ,opt_cus_mgr varchar2(20) -- 托管客户经理   
    ,ten_cla char(2) -- 十级分类结果   
    ,ten_cla_pre char(2) -- 上期十级分类结果   
    ,loan_card_ind char(1) -- 使用农户贷款证标志   
    ,agriculture_type varchar2(5) -- 涉农情况   
    ,agriculture_use char(4) -- 涉农用途   
    ,minor_entrp_range char(1) -- 小企业统计口径(银监)   
    ,government_ind char(1) -- 涉政类型   
    ,government_org_attribute char(4) -- 涉政机构属性   
    ,government_platform char(4) -- 是否为涉政平台   
    ,overdue_type char(1) -- 逾期利率浮动类型   
    ,default_type char(1) -- 挤占利率浮动类型   
    ,ir_exe_type varchar2(2) -- 利率变更生效方式   
    ,guarantora_grp_ind char(1) -- 联保贷款标志   
    ,jz char(1) --    
    ,core_account_status varchar2(2) --    
    ,interest_date varchar2(10) -- 结息日   
    ,join_role varchar2(2) -- 参与角色：01牵头行 02代理行   03参与行   
    ,syndicated_type varchar2(2) -- 银/社团类型： 01银团  02社团   
    ,lead_arranger_ind varchar2(1) -- 是否主办行：1 是 2 否   
    ,machine_cla_result char(2) --    
    ,machine_ten_cla_result char(2) --    
    ,period_ind varchar2(2) --    
    ,period_term number --    
    ,period_type varchar2(3) --    
    ,distance_term number(16) -- 调整间隔期   
    ,proportion_scale number(20,6) -- 增减单位(%)   
    ,devalue_sign varchar2(2) -- 贷款减值标志   
    ,accrue_money number(16,2) -- 计提金额   
    ,cla_cf char(2) -- 五级分类初分结果   
    ,cla_cf_date char(10) -- 五级分类初分日期   
    ,cla_cf_pre char(2) -- 上期五级分类初分结果   
    ,cla_cf_date_pre char(10) -- 上期五级分类初分日期   
    ,ten_cla_cf char(2) -- 十级分类初分结果   
    ,ten_cla_cf_date char(10) -- 十级分类初分日期   
    ,ten_cla_cf_pre char(2) -- 上期十级分类初分结果   
    ,ten_cla_cf_date_pre char(10) -- 上期十级分类初分日期   
    ,rsc_task_crt_date_pre char(10) -- 上期五级任务生成日期   
    ,ten_rsc_task_crt_date char(10) -- 十级分类任务生成日期   
    ,ten_rsc_task_crt_date_pre char(10) -- 上期十级任务生成日期   
    ,ten_cla_date char(10) -- 十级分类完成日期   
    ,ten_cla_date_pre char(10) -- 上期十级分类完成日期   
    ,rsc_model_id varchar2(20) -- 风险分类认定模型   
    ,rsc_model_id_cf varchar2(20) -- 风险分类初分模型编号   
    ,rsc_model_name varchar2(60) -- 风险分类认定模型名称   
    ,rsc_model_name_cf varchar2(60) -- 风险分类初分模型名称   
    ,auto_rate_reason varchar2(500) -- 五级分类初分理由   
    ,auto_ten_rate_reason varchar2(500) -- 十级分类初分理由   
    ,cla_rp char(2) -- 五级分类结果(报表统计)   
    ,ten_cla_rp char(2) -- 十级分类结果(报表统计)   
    ,int_repayment_total number(16,2) --    
    ,cap_repayment_curmonth number(16,2) --    
    ,int_repayment_curmonth number(16,2) --    
    ,inner_int_repayment_total number(16,2) --    
    ,inner_int_curmonth number(16,2) --    
    ,off_int_repayment_total number(16,2) --    
    ,off_int_repayment_curmonth number(16,2) --    
    ,repla_repayment_total number(16,2) --    
    ,repla_repayment_curmonth number(16,2) --    
    ,wrpff_prin_repayment_total number(16,2) --    
    ,wrpff_repayment_curmonth number(16,2) --    
    ,is_company char(1) --    
    ,cla_rp_lastyear char(2) --    
    ,cla_rp_lastmonth char(2) --    
    ,cla_rp_lastquarter char(2) --    
    ,ten_cla_rp_lastyear char(2) --    
    ,ten_cla_rp_lastmonth char(2) --    
    ,ten_cla_rp_lastquarter char(2) --    
    ,cap_overdue_days number -- 本金逾期天数   
    ,int_overdue_days number --    
    ,max_overdue_days number --    
    ,use_dec varchar2(200) -- 借款用途   
    ,loan_balance_lastyear_end number(16,2) --    
    ,repayment_account varchar2(32) --    
    ,precalcintdate varchar2(10) -- 上次结息日期   
    ,tourism_flag char(1) --    
    ,delay_deduct_type varchar2(2) -- 扣款方式   
    ,moweput number(24,7) -- 本月本金累放   
    ,qoweput number(24,7) -- 本季本金累放   
    ,yoweput number(24,7) -- 本年本金累放   
    ,moweaccept number(24,7) -- 本月本金累收   
    ,qoweaccept number(24,7) -- 本季本金累收   
    ,yoweaccept number(24,7) -- 本年本金累收   
    ,mintaccept number(24,7) -- 本月利息累收   
    ,qintaccept number(24,7) -- 本季利息累收   
    ,yintaccept number(24,7) -- 本年利息累收   
    ,mshloudint number(24,7) -- 本月应收利息   
    ,qshloudint number(24,7) -- 本季应收利息   
    ,yshloudint number(24,7) -- 本年应收利息   
    ,pay_way char(1) -- 支付方式   
    ,src_account varchar2(32) -- 公积金贷款账号   
    ,repayment_acc_name varchar2(80) -- 结算账户名称   
    ,ir_floating_term varchar2(2) -- 利率浮动期限   
    ,cancel_date varchar2(10) -- 核销日期   
    ,input_id varchar2(20) -- 登记人   
    ,last_upd_date varchar2(10) --    
    ,cap_repayment_total varchar2(32) --    
    ,enter_account varchar2(32) -- 入账账号   
    ,enter_account_name varchar2(80) -- 入账账户名称   
    ,interest_acc_mode char(1) -- 结息方式   
    ,enter_account_type varchar2(20) -- 入账账户支付工具类型   
    ,repayment_account_type varchar2(20) -- 还款账户支付工具类型   
    ,create_user_id varchar2(20) -- 创建台账用户id   
    ,ir_adjust_mode char(1) -- 利率调整方式   
    ,ten_cla_ind varchar2(2) -- 十级分类人工干预标志   
    ,is_cl varchar2(1) --    
    ,is_balloon char(1) -- 是否选择气球贷   
    ,last_term_amount number(16,2) -- 最后一期保留金额   
    ,cla_fina_update_id varchar2(10) -- 风险分类终审人   
    ,cla_update_reason varchar2(400) -- 最近一次风险分类调整原因   
    ,inner_account varchar2(40) -- 内部账户   
    ,interest number(16,2) -- 利息   
    ,penalty_interest number(16,2) -- 罚息   
    ,recipe number(16,2) -- 复息   
    ,advance_payment number(16,2) -- 垫付费用   
    ,debts_status char(2) -- 呆账核销状态   
    ,off_balance_interest number(16,2) -- 表外利息   
    ,inner_balance_interest number(16,2) -- 表内利息   
    ,asset_three_type_cd varchar2(10) -- 业务模式 AC - AC模式-持有以收取合同现金流 FVOCI - FVOCI模式-既收取合同现金流量又可以出售   
    ,rate_type varchar2(3) -- 利率类型   
    ,zxz_flag varchar2(2) -- 0：待审批，1：有效，2：失效   
    ,start_dt date -- 开始时间   
    ,end_dt date -- 结束时间   
    ,id_mark varchar2(10) -- 增删标志   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.rcrs_acc_loan to ${iel_schema};

-- comment
comment on table ${idl_schema}.rcrs_acc_loan is '贷款台账';
comment on column ${idl_schema}.rcrs_acc_loan.etl_dt is '数据日期';
comment on column ${idl_schema}.rcrs_acc_loan.bill_no is '借据号';
comment on column ${idl_schema}.rcrs_acc_loan.cont_no is '合同编号';
comment on column ${idl_schema}.rcrs_acc_loan.cn_cont_no is '中文合同编号';
comment on column ${idl_schema}.rcrs_acc_loan.prd_pk is '产品主键';
comment on column ${idl_schema}.rcrs_acc_loan.biz_type is '产品编号';
comment on column ${idl_schema}.rcrs_acc_loan.prd_name is '产品名称';
comment on column ${idl_schema}.rcrs_acc_loan.prd_type is '产品类型';
comment on column ${idl_schema}.rcrs_acc_loan.cus_id is '客户编号';
comment on column ${idl_schema}.rcrs_acc_loan.cus_name is '客户名称';
comment on column ${idl_schema}.rcrs_acc_loan.biz_type_sub is '业务品种';
comment on column ${idl_schema}.rcrs_acc_loan.account_class is '业务品种名称';
comment on column ${idl_schema}.rcrs_acc_loan.loan_account is '贷款账号';
comment on column ${idl_schema}.rcrs_acc_loan.loan_form is '贷款形式';
comment on column ${idl_schema}.rcrs_acc_loan.loan_nature is '贷款性质';
comment on column ${idl_schema}.rcrs_acc_loan.loan_type_ext is '关联交易类型';
comment on column ${idl_schema}.rcrs_acc_loan.assure_means_main is '主担保方式';
comment on column ${idl_schema}.rcrs_acc_loan.assure_means2 is '主担保方式2';
comment on column ${idl_schema}.rcrs_acc_loan.assure_means3 is '主担保方式3';
comment on column ${idl_schema}.rcrs_acc_loan.cur_type is '币种';
comment on column ${idl_schema}.rcrs_acc_loan.loan_amount is '借据金额';
comment on column ${idl_schema}.rcrs_acc_loan.loan_balance is '借据余额';
comment on column ${idl_schema}.rcrs_acc_loan.loan_start_date is '贷款起始日';
comment on column ${idl_schema}.rcrs_acc_loan.loan_end_date is '贷款终止日';
comment on column ${idl_schema}.rcrs_acc_loan.term_type is '期限类型';
comment on column ${idl_schema}.rcrs_acc_loan.orig_expi_date is '原到期日期';
comment on column ${idl_schema}.rcrs_acc_loan.ruling_ir is '基准利率(月)';
comment on column ${idl_schema}.rcrs_acc_loan.floating_rate is '利率浮动值';
comment on column ${idl_schema}.rcrs_acc_loan.reality_ir_y is '执行月利率';
comment on column ${idl_schema}.rcrs_acc_loan.overdue_rate is '逾期利率浮动比';
comment on column ${idl_schema}.rcrs_acc_loan.overdue_ir is '逾期加月利率';
comment on column ${idl_schema}.rcrs_acc_loan.default_rate is '挤占挪用利率浮动比例';
comment on column ${idl_schema}.rcrs_acc_loan.default_ir is '违约月利率';
comment on column ${idl_schema}.rcrs_acc_loan.ci_rate is '复利加罚率';
comment on column ${idl_schema}.rcrs_acc_loan.ci_ir is '复利月利率';
comment on column ${idl_schema}.rcrs_acc_loan.rece_int_cumu is '应收利息累计';
comment on column ${idl_schema}.rcrs_acc_loan.actual_int_cumu is '实收利息累计';
comment on column ${idl_schema}.rcrs_acc_loan.delay_int_cumu is '欠息累计';
comment on column ${idl_schema}.rcrs_acc_loan.inner_int_cumu is '表内欠息';
comment on column ${idl_schema}.rcrs_acc_loan.off_int_cumu is '表外欠息';
comment on column ${idl_schema}.rcrs_acc_loan.inner_rece_int is '表内应收';
comment on column ${idl_schema}.rcrs_acc_loan.overdue_rece_int is '逾期应收';
comment on column ${idl_schema}.rcrs_acc_loan.off_rece_int is '表外利息应收';
comment on column ${idl_schema}.rcrs_acc_loan.compound_rece_int is '利息复息应收';
comment on column ${idl_schema}.rcrs_acc_loan.inner_off_rece_int is '表内转表外利息应收';
comment on column ${idl_schema}.rcrs_acc_loan.inner_actl_int is '表内实收';
comment on column ${idl_schema}.rcrs_acc_loan.overdue_actl_int is '逾期实收';
comment on column ${idl_schema}.rcrs_acc_loan.off_actl_int is '表外利息实收';
comment on column ${idl_schema}.rcrs_acc_loan.compound_actl_int is '利息复息实收';
comment on column ${idl_schema}.rcrs_acc_loan.inner_off_actl_int is '表内转表外利息实收';
comment on column ${idl_schema}.rcrs_acc_loan.normal_balance is '正常贷款余额(元)';
comment on column ${idl_schema}.rcrs_acc_loan.overdue_balance is '逾期贷款余额(元)';
comment on column ${idl_schema}.rcrs_acc_loan.sluggish_balance is '呆滞贷款余额(元)';
comment on column ${idl_schema}.rcrs_acc_loan.doubtful_balance is '呆账贷款余额(元)';
comment on column ${idl_schema}.rcrs_acc_loan.integral_y is '积数_年';
comment on column ${idl_schema}.rcrs_acc_loan.integral_q is '积数_季';
comment on column ${idl_schema}.rcrs_acc_loan.integral_m is '积数_月';
comment on column ${idl_schema}.rcrs_acc_loan.nor_rec_accu is '正常回收累计';
comment on column ${idl_schema}.rcrs_acc_loan.reo_rec_accu is '资产重组累计';
comment on column ${idl_schema}.rcrs_acc_loan.peel_rec_accu is '资产剥离累计';
comment on column ${idl_schema}.rcrs_acc_loan.asset_rec_accu is '以资抵债累计';
comment on column ${idl_schema}.rcrs_acc_loan.assure_rec_accu is '担保代偿累计';
comment on column ${idl_schema}.rcrs_acc_loan.cancel_rec_accu is '核损核销累计';
comment on column ${idl_schema}.rcrs_acc_loan.policy_rec_accu is '政策性还款累计';
comment on column ${idl_schema}.rcrs_acc_loan.dte_rec_accu is '债转股累计';
comment on column ${idl_schema}.rcrs_acc_loan.roll_rec_accu is '转出累计';
comment on column ${idl_schema}.rcrs_acc_loan.max_balance_y is '本年最高余额';
comment on column ${idl_schema}.rcrs_acc_loan.max_balance_q is '本季最高余额';
comment on column ${idl_schema}.rcrs_acc_loan.max_balance_m is '本月最高余额';
comment on column ${idl_schema}.rcrs_acc_loan.mortgage_flg is '按揭标识';
comment on column ${idl_schema}.rcrs_acc_loan.repayment_mode is '还款方式';
comment on column ${idl_schema}.rcrs_acc_loan.first_disb_date is '首次放款日期';
comment on column ${idl_schema}.rcrs_acc_loan.loan_direction is '贷款投向';
comment on column ${idl_schema}.rcrs_acc_loan.revolving_times is '借新还旧次数';
comment on column ${idl_schema}.rcrs_acc_loan.extension_times is '展期次数';
comment on column ${idl_schema}.rcrs_acc_loan.cap_overdue_date is '本金逾期起始日期';
comment on column ${idl_schema}.rcrs_acc_loan.int_overdue_date is '利息逾期起始日期';
comment on column ${idl_schema}.rcrs_acc_loan.over_times_current is '当前逾期期数';
comment on column ${idl_schema}.rcrs_acc_loan.over_times_total is '累计逾期期数';
comment on column ${idl_schema}.rcrs_acc_loan.max_times_total is '最高逾期期数';
comment on column ${idl_schema}.rcrs_acc_loan.bad_loan_flag is '转不良标志';
comment on column ${idl_schema}.rcrs_acc_loan.default_flag is '违约标识';
comment on column ${idl_schema}.rcrs_acc_loan.limit_ind is '授信额度使用标志';
comment on column ${idl_schema}.rcrs_acc_loan.loan_form4 is '四级分类标志';
comment on column ${idl_schema}.rcrs_acc_loan.cla is '五级分类结果';
comment on column ${idl_schema}.rcrs_acc_loan.cla_date is '五级分类完成日期';
comment on column ${idl_schema}.rcrs_acc_loan.cla_pre is '上期五级分类结果';
comment on column ${idl_schema}.rcrs_acc_loan.cla_date_pre is '上期五级分类完成日期';
comment on column ${idl_schema}.rcrs_acc_loan.latest_repay_date is '最近还款日期';
comment on column ${idl_schema}.rcrs_acc_loan.cus_manager is '客户经理';
comment on column ${idl_schema}.rcrs_acc_loan.input_br_id is '录入机构';
comment on column ${idl_schema}.rcrs_acc_loan.fina_br_id is '账务机构';
comment on column ${idl_schema}.rcrs_acc_loan.main_br_id is '主管机构';
comment on column ${idl_schema}.rcrs_acc_loan.settl_date is '结清日期';
comment on column ${idl_schema}.rcrs_acc_loan.latest_date is '最近修改日期';
comment on column ${idl_schema}.rcrs_acc_loan.account_status is '台帐状态';
comment on column ${idl_schema}.rcrs_acc_loan.biz_type_detail is '业务品种名称';
comment on column ${idl_schema}.rcrs_acc_loan.int_rate_type is '利率类型';
comment on column ${idl_schema}.rcrs_acc_loan.int_rate_inc_opt is '利率增量选项';
comment on column ${idl_schema}.rcrs_acc_loan.int_rate_inc is '利率增量';
comment on column ${idl_schema}.rcrs_acc_loan.fixed_rate is '固定利率';
comment on column ${idl_schema}.rcrs_acc_loan.prd_userdf_name is '产品自定义名称';
comment on column ${idl_schema}.rcrs_acc_loan.prd_userdf_type is '产品自定义类别';
comment on column ${idl_schema}.rcrs_acc_loan.syndicated_ind is '银团标识';
comment on column ${idl_schema}.rcrs_acc_loan.unpd_int_arr_prn is '应收利息的罚息(应收未收)';
comment on column ${idl_schema}.rcrs_acc_loan.unpd_arrs_int_bal is '拖欠本金的罚息(应收未收)';
comment on column ${idl_schema}.rcrs_acc_loan.unpd_arr_prn_bal is '应收复利(应收未收)';
comment on column ${idl_schema}.rcrs_acc_loan.act_int_arr_prn is '实收利息的罚息';
comment on column ${idl_schema}.rcrs_acc_loan.act_arrs_int_bal is '实收拖欠本金的罚息';
comment on column ${idl_schema}.rcrs_acc_loan.act_arr_prn_bal is '实收复利';
comment on column ${idl_schema}.rcrs_acc_loan.gl_class is '科目号';
comment on column ${idl_schema}.rcrs_acc_loan.iscircle is '循环贷款标识';
comment on column ${idl_schema}.rcrs_acc_loan.return_date is '还款日';
comment on column ${idl_schema}.rcrs_acc_loan.act_write_off_int_rec is '实收待核销利息';
comment on column ${idl_schema}.rcrs_acc_loan.unpd_write_off_int_rec is '应收待核销利息';
comment on column ${idl_schema}.rcrs_acc_loan.unpd_prin_bal is '拖欠本金';
comment on column ${idl_schema}.rcrs_acc_loan.remark is '备注';
comment on column ${idl_schema}.rcrs_acc_loan.consign_fund_protocol_no is '资金协议号';
comment on column ${idl_schema}.rcrs_acc_loan.psp_task_crt_date is '贷后检查任务生成日期';
comment on column ${idl_schema}.rcrs_acc_loan.psp_task_cpt_date is '贷后检查任务完成日期';
comment on column ${idl_schema}.rcrs_acc_loan.rsc_task_crt_date is '五级分类任务生成日期';
comment on column ${idl_schema}.rcrs_acc_loan.com_scale is '企业规模';
comment on column ${idl_schema}.rcrs_acc_loan.cus_type is '客户类型';
comment on column ${idl_schema}.rcrs_acc_loan.opt_cus_mgr is '托管客户经理';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla is '十级分类结果';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_pre is '上期十级分类结果';
comment on column ${idl_schema}.rcrs_acc_loan.loan_card_ind is '使用农户贷款证标志';
comment on column ${idl_schema}.rcrs_acc_loan.agriculture_type is '涉农情况';
comment on column ${idl_schema}.rcrs_acc_loan.agriculture_use is '涉农用途';
comment on column ${idl_schema}.rcrs_acc_loan.minor_entrp_range is '小企业统计口径(银监)';
comment on column ${idl_schema}.rcrs_acc_loan.government_ind is '涉政类型';
comment on column ${idl_schema}.rcrs_acc_loan.government_org_attribute is '涉政机构属性';
comment on column ${idl_schema}.rcrs_acc_loan.government_platform is '是否为涉政平台';
comment on column ${idl_schema}.rcrs_acc_loan.overdue_type is '逾期利率浮动类型';
comment on column ${idl_schema}.rcrs_acc_loan.default_type is '挤占利率浮动类型';
comment on column ${idl_schema}.rcrs_acc_loan.ir_exe_type is '利率变更生效方式';
comment on column ${idl_schema}.rcrs_acc_loan.guarantora_grp_ind is '联保贷款标志';
comment on column ${idl_schema}.rcrs_acc_loan.jz is '';
comment on column ${idl_schema}.rcrs_acc_loan.core_account_status is '';
comment on column ${idl_schema}.rcrs_acc_loan.interest_date is '结息日';
comment on column ${idl_schema}.rcrs_acc_loan.join_role is '参与角色：01牵头行 02代理行   03参与行';
comment on column ${idl_schema}.rcrs_acc_loan.syndicated_type is '银/社团类型： 01银团  02社团';
comment on column ${idl_schema}.rcrs_acc_loan.lead_arranger_ind is '是否主办行：1 是 2 否';
comment on column ${idl_schema}.rcrs_acc_loan.machine_cla_result is '';
comment on column ${idl_schema}.rcrs_acc_loan.machine_ten_cla_result is '';
comment on column ${idl_schema}.rcrs_acc_loan.period_ind is '';
comment on column ${idl_schema}.rcrs_acc_loan.period_term is '';
comment on column ${idl_schema}.rcrs_acc_loan.period_type is '';
comment on column ${idl_schema}.rcrs_acc_loan.distance_term is '调整间隔期';
comment on column ${idl_schema}.rcrs_acc_loan.proportion_scale is '增减单位(%)';
comment on column ${idl_schema}.rcrs_acc_loan.devalue_sign is '贷款减值标志';
comment on column ${idl_schema}.rcrs_acc_loan.accrue_money is '计提金额';
comment on column ${idl_schema}.rcrs_acc_loan.cla_cf is '五级分类初分结果';
comment on column ${idl_schema}.rcrs_acc_loan.cla_cf_date is '五级分类初分日期';
comment on column ${idl_schema}.rcrs_acc_loan.cla_cf_pre is '上期五级分类初分结果';
comment on column ${idl_schema}.rcrs_acc_loan.cla_cf_date_pre is '上期五级分类初分日期';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_cf is '十级分类初分结果';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_cf_date is '十级分类初分日期';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_cf_pre is '上期十级分类初分结果';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_cf_date_pre is '上期十级分类初分日期';
comment on column ${idl_schema}.rcrs_acc_loan.rsc_task_crt_date_pre is '上期五级任务生成日期';
comment on column ${idl_schema}.rcrs_acc_loan.ten_rsc_task_crt_date is '十级分类任务生成日期';
comment on column ${idl_schema}.rcrs_acc_loan.ten_rsc_task_crt_date_pre is '上期十级任务生成日期';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_date is '十级分类完成日期';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_date_pre is '上期十级分类完成日期';
comment on column ${idl_schema}.rcrs_acc_loan.rsc_model_id is '风险分类认定模型';
comment on column ${idl_schema}.rcrs_acc_loan.rsc_model_id_cf is '风险分类初分模型编号';
comment on column ${idl_schema}.rcrs_acc_loan.rsc_model_name is '风险分类认定模型名称';
comment on column ${idl_schema}.rcrs_acc_loan.rsc_model_name_cf is '风险分类初分模型名称';
comment on column ${idl_schema}.rcrs_acc_loan.auto_rate_reason is '五级分类初分理由';
comment on column ${idl_schema}.rcrs_acc_loan.auto_ten_rate_reason is '十级分类初分理由';
comment on column ${idl_schema}.rcrs_acc_loan.cla_rp is '五级分类结果(报表统计)';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_rp is '十级分类结果(报表统计)';
comment on column ${idl_schema}.rcrs_acc_loan.int_repayment_total is '';
comment on column ${idl_schema}.rcrs_acc_loan.cap_repayment_curmonth is '';
comment on column ${idl_schema}.rcrs_acc_loan.int_repayment_curmonth is '';
comment on column ${idl_schema}.rcrs_acc_loan.inner_int_repayment_total is '';
comment on column ${idl_schema}.rcrs_acc_loan.inner_int_curmonth is '';
comment on column ${idl_schema}.rcrs_acc_loan.off_int_repayment_total is '';
comment on column ${idl_schema}.rcrs_acc_loan.off_int_repayment_curmonth is '';
comment on column ${idl_schema}.rcrs_acc_loan.repla_repayment_total is '';
comment on column ${idl_schema}.rcrs_acc_loan.repla_repayment_curmonth is '';
comment on column ${idl_schema}.rcrs_acc_loan.wrpff_prin_repayment_total is '';
comment on column ${idl_schema}.rcrs_acc_loan.wrpff_repayment_curmonth is '';
comment on column ${idl_schema}.rcrs_acc_loan.is_company is '';
comment on column ${idl_schema}.rcrs_acc_loan.cla_rp_lastyear is '';
comment on column ${idl_schema}.rcrs_acc_loan.cla_rp_lastmonth is '';
comment on column ${idl_schema}.rcrs_acc_loan.cla_rp_lastquarter is '';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_rp_lastyear is '';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_rp_lastmonth is '';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_rp_lastquarter is '';
comment on column ${idl_schema}.rcrs_acc_loan.cap_overdue_days is '本金逾期天数';
comment on column ${idl_schema}.rcrs_acc_loan.int_overdue_days is '';
comment on column ${idl_schema}.rcrs_acc_loan.max_overdue_days is '';
comment on column ${idl_schema}.rcrs_acc_loan.use_dec is '借款用途';
comment on column ${idl_schema}.rcrs_acc_loan.loan_balance_lastyear_end is '';
comment on column ${idl_schema}.rcrs_acc_loan.repayment_account is '';
comment on column ${idl_schema}.rcrs_acc_loan.precalcintdate is '上次结息日期';
comment on column ${idl_schema}.rcrs_acc_loan.tourism_flag is '';
comment on column ${idl_schema}.rcrs_acc_loan.delay_deduct_type is '扣款方式';
comment on column ${idl_schema}.rcrs_acc_loan.moweput is '本月本金累放';
comment on column ${idl_schema}.rcrs_acc_loan.qoweput is '本季本金累放';
comment on column ${idl_schema}.rcrs_acc_loan.yoweput is '本年本金累放';
comment on column ${idl_schema}.rcrs_acc_loan.moweaccept is '本月本金累收';
comment on column ${idl_schema}.rcrs_acc_loan.qoweaccept is '本季本金累收';
comment on column ${idl_schema}.rcrs_acc_loan.yoweaccept is '本年本金累收';
comment on column ${idl_schema}.rcrs_acc_loan.mintaccept is '本月利息累收';
comment on column ${idl_schema}.rcrs_acc_loan.qintaccept is '本季利息累收';
comment on column ${idl_schema}.rcrs_acc_loan.yintaccept is '本年利息累收';
comment on column ${idl_schema}.rcrs_acc_loan.mshloudint is '本月应收利息';
comment on column ${idl_schema}.rcrs_acc_loan.qshloudint is '本季应收利息';
comment on column ${idl_schema}.rcrs_acc_loan.yshloudint is '本年应收利息';
comment on column ${idl_schema}.rcrs_acc_loan.pay_way is '支付方式';
comment on column ${idl_schema}.rcrs_acc_loan.src_account is '公积金贷款账号';
comment on column ${idl_schema}.rcrs_acc_loan.repayment_acc_name is '结算账户名称';
comment on column ${idl_schema}.rcrs_acc_loan.ir_floating_term is '利率浮动期限';
comment on column ${idl_schema}.rcrs_acc_loan.cancel_date is '核销日期';
comment on column ${idl_schema}.rcrs_acc_loan.input_id is '登记人';
comment on column ${idl_schema}.rcrs_acc_loan.last_upd_date is '';
comment on column ${idl_schema}.rcrs_acc_loan.cap_repayment_total is '';
comment on column ${idl_schema}.rcrs_acc_loan.enter_account is '入账账号';
comment on column ${idl_schema}.rcrs_acc_loan.enter_account_name is '入账账户名称';
comment on column ${idl_schema}.rcrs_acc_loan.interest_acc_mode is '结息方式';
comment on column ${idl_schema}.rcrs_acc_loan.enter_account_type is '入账账户支付工具类型';
comment on column ${idl_schema}.rcrs_acc_loan.repayment_account_type is '还款账户支付工具类型';
comment on column ${idl_schema}.rcrs_acc_loan.create_user_id is '创建台账用户id';
comment on column ${idl_schema}.rcrs_acc_loan.ir_adjust_mode is '利率调整方式';
comment on column ${idl_schema}.rcrs_acc_loan.ten_cla_ind is '十级分类人工干预标志';
comment on column ${idl_schema}.rcrs_acc_loan.is_cl is '';
comment on column ${idl_schema}.rcrs_acc_loan.is_balloon is '是否选择气球贷';
comment on column ${idl_schema}.rcrs_acc_loan.last_term_amount is '最后一期保留金额';
comment on column ${idl_schema}.rcrs_acc_loan.cla_fina_update_id is '风险分类终审人';
comment on column ${idl_schema}.rcrs_acc_loan.cla_update_reason is '最近一次风险分类调整原因';
comment on column ${idl_schema}.rcrs_acc_loan.inner_account is '内部账户';
comment on column ${idl_schema}.rcrs_acc_loan.interest is '利息';
comment on column ${idl_schema}.rcrs_acc_loan.penalty_interest is '罚息';
comment on column ${idl_schema}.rcrs_acc_loan.recipe is '复息';
comment on column ${idl_schema}.rcrs_acc_loan.advance_payment is '垫付费用';
comment on column ${idl_schema}.rcrs_acc_loan.debts_status is '呆账核销状态';
comment on column ${idl_schema}.rcrs_acc_loan.off_balance_interest is '表外利息';
comment on column ${idl_schema}.rcrs_acc_loan.inner_balance_interest is '表内利息';
comment on column ${idl_schema}.rcrs_acc_loan.asset_three_type_cd is '业务模式 AC - AC模式-持有以收取合同现金流 FVOCI - FVOCI模式-既收取合同现金流量又可以出售';
comment on column ${idl_schema}.rcrs_acc_loan.rate_type is '利率类型';
comment on column ${idl_schema}.rcrs_acc_loan.zxz_flag is '0：待审批，1：有效，2：失效';
comment on column ${idl_schema}.rcrs_acc_loan.start_dt is '开始时间';
comment on column ${idl_schema}.rcrs_acc_loan.end_dt is '结束时间';
comment on column ${idl_schema}.rcrs_acc_loan.id_mark is '增删标志';
comment on column ${idl_schema}.rcrs_acc_loan.etl_timestamp is '数据处理时间';