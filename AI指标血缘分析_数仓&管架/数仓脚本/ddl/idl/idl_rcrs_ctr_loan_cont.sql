/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl rcrs_ctr_loan_cont
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.rcrs_ctr_loan_cont
whenever sqlerror continue none;
drop table ${idl_schema}.rcrs_ctr_loan_cont purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.rcrs_ctr_loan_cont(
    etl_dt date -- ETL处理日期   
    ,cont_no varchar2(30) -- 合同编号   
    ,serno varchar2(40) -- 业务流水号   
    ,cont_type varchar2(1) -- 合同类型   
    ,prd_pk varchar2(32) -- 产品主键   
    ,biz_type varchar2(20) -- 业务品种   
    ,prd_name varchar2(60) -- 产品名称   
    ,app_form varchar2(60) -- 表单类型   
    ,cust_no varchar2(30) -- 客户编号   
    ,cust_name varchar2(60) -- 客户名称   
    ,biz_type_sub varchar2(8) -- 业务品种细分   
    ,biz_type_detail varchar2(100) -- 业务品种分类名称   
    ,loan_form varchar2(1) -- 贷款形式   
    ,loan_nature varchar2(2) -- 贷款性质   
    ,loan_kind_ca varchar2(2) -- 企业贷款种类   
    ,loan_type_ext varchar2(2) -- 关联交易类型   
    ,loan_type_ext2 varchar2(100) -- 关联交易描述   
    ,currency_type varchar2(3) -- 币种   
    ,approval_amt number(16,2) -- 审批金额   
    ,cont_amt number(16,2) -- 合同金额   
    ,total_issue_amt number(16,2) -- 累计发放金额   
    ,total_recyle_amt number(16,2) -- 累计回收金额   
    ,avail_amt number(16,2) -- 合同可用余额   
    ,term_time_type varchar2(3) -- 期限时间类型   
    ,loan_term number(22,0) -- 贷款期限   
    ,loan_start_date varchar2(10) -- 贷款起始日期   
    ,loan_end_date varchar2(10) -- 贷款终止日期   
    ,ruling_ir number(16,9) -- 基准利率   
    ,cal_floating_rate number(10,6) -- 利率浮动比   
    ,reality_ir_y number(16,9) -- 执行利率（年）   
    ,overdue_rate number(10,4) -- 逾期利率浮动比例   
    ,overdue_ir number(16,9) -- 逾期月利率   
    ,default_rate number(10,4) -- 逾期利率浮动比例   
    ,default_ir number(16,9) -- 挤占挪用利率浮动比例   
    ,ci_rate number(10,4) -- 复利加罚率   
    ,ci_ir number(16,9) -- 复利月利率   
    ,ir_adjust_mode varchar2(1) -- 利率调整方式   
    ,interest_acc_mode varchar2(1) -- 结息方式   
    ,chargeoff_ind varchar2(1) -- 出帐方式   
    ,discont_ind varchar2(1) -- 是否贴息   
    ,discount_id varchar2(25) -- 贴息方编号   
    ,mortgage_flg varchar2(1) -- 按揭标识   
    ,repayment_mode varchar2(1) -- 还款方式   
    ,repayment_period varchar2(2) -- 还款频率   
    ,assure_means_main varchar2(2) -- 主担保方式   
    ,assure_means2 varchar2(2) -- 主担保方式2   
    ,assure_means3 varchar2(2) -- 主担保方式3   
    ,loan_direction varchar2(4) -- 贷款投向   
    ,direction_name varchar2(200) -- 投向名称   
    ,agriculture_type varchar2(2) -- 涉农情况   
    ,agriculture_use varchar2(4) -- 涉农用途   
    ,minor_entrp_range varchar2(1) -- 小企业统计口径(银监)   
    ,loan_use_type varchar2(2) -- 借款用途类型   
    ,use_dec varchar2(200) -- 用途说明   
    ,repayment_src_dec varchar2(200) -- 还款来源   
    ,limit_ind varchar2(1) -- 授信额度使用标志   
    ,guarantora_grp_ind varchar2(1) -- 联保贷款标志   
    ,copartner_ind varchar2(1) -- 市场合作方标志   
    ,loan_card_ind varchar2(1) -- 使用农户贷款证标志   
    ,entrust_ind varchar2(1) -- 委托方贷款标识   
    ,loan_type1 varchar2(6) -- 借款分类1   
    ,loan_type2 varchar2(6) -- 借款分类2   
    ,loan_type3 varchar2(6) -- 借款分类3   
    ,loan_type4 varchar2(6) -- 借款分类4   
    ,loan_type5 varchar2(6) -- 借款分类5   
    ,loan_type6 varchar2(6) -- 借款分类6   
    ,final_endorse_br_id varchar2(20) -- 最终审批机构   
    ,final_endorse_date varchar2(20) -- 最终审批日期   
    ,final_endorse_id varchar2(20) -- 最终审批人   
    ,sign_date varchar2(10) -- 合同签订日期   
    ,change_date varchar2(10) -- 合同变更日期   
    ,cont_state varchar2(3) -- 合同状态   
    ,input_id varchar2(20) -- 托管人（申请人）   
    ,cust_mgr varchar2(20) -- 客户经理   
    ,input_br_id varchar2(20) -- 受理机构   
    ,main_br_id varchar2(20) -- 主管机构   
    ,fina_br_id varchar2(20) -- 账务机构   
    ,old_bill_no varchar2(30) -- 原借据号   
    ,cla_result varchar2(20) -- 风险分类初分结果   
    ,cla_suggestion varchar2(500) -- 风险分类初分意见   
    ,ir_exe_type varchar2(2) -- 利率变更生效方式   
    ,responsible_man varchar2(80) -- 责任人   
    ,government_ind varchar2(1) -- 涉政类型   
    ,government_org_attribute varchar2(4) -- 政机构属性   
    ,government_platform varchar2(4) -- 是否为涉政平台   
    ,int_rate_type varchar2(2) -- 利率类型   
    ,int_rate_inc_opt varchar2(1) -- 率增量选项   
    ,int_rate_inc number(16,9) -- 利率增量   
    ,fixed_rate number(16,9) -- 固定利率   
    ,prd_userdf_type varchar2(60) -- 产品自定义类型   
    ,prd_userdf_name varchar2(60) -- 产品自定义名称   
    ,consign_loan_bgl_acct_no varchar2(16) -- 委托贷款BGL帐号   
    ,funds_src varchar2(2) -- 资金来源   
    ,chargeoff_manage varchar2(20) -- 出帐负责人   
    ,enter_account varchar2(32) -- 入账账号   
    ,enter_account_name varchar2(80) -- 入账账户名称   
    ,repayment_account varchar2(32) -- 还款账号   
    ,repayment_acc_name varchar2(80) -- 还款账户名称   
    ,prd_type varchar2(3) -- 产品类别   
    ,ispaf varchar2(1) -- 是否住房公积金贷款   
    ,cosurety_cont_no varchar2(30) -- 联保协议编号   
    ,lead_arranger_ind varchar2(1) -- 牵头行标志   
    ,cn_cont_no varchar2(100) -- 中文合同编号   
    ,fldvalue01 varchar2(250) -- 备注1   
    ,fldvalue02 varchar2(250) -- 备注2   
    ,disaster_type varchar2(1) -- 救灾类型   
    ,carve_out_type varchar2(1) -- 创业贷款   
    ,farm_card_type varchar2(1) -- 农户发放形式   
    ,overdue_type varchar2(1) -- 逾期利率浮动类型   
    ,default_type varchar2(1) -- 挤占利率浮动类型   
    ,spe_loan_type2 varchar2(1) -- 特色贷款类型   
    ,repay_interest_mode varchar2(2) -- 提前还款部分本金的利息计收方式   
    ,repay_principal_rate number(16,9) -- 提前还款本金的比例   
    ,add_interest_date number(22,0) -- 加收利息时间（月）   
    ,cus_area varchar2(20) -- 客户所属片区   
    ,syndicated_ind varchar2(1) -- 银/社团标识   
    ,syndicated_type varchar2(2) -- 银/社团类型   
    ,join_role varchar2(2) -- 参与角色   
    ,syndicated_proxy_id varchar2(20) -- 代理行机构号   
    ,government_financing varchar2(1) -- 是否政府融资平台   
    ,gover_fina_su_relat varchar2(1) -- 政府融资平台隶属关系   
    ,gover_fina_attribute varchar2(1) -- 政府融资平台属性   
    ,gover_fina_type varchar2(1) -- 政府融资平台类型   
    ,gover_fina_direction varchar2(2) -- 政府融资平台投向   
    ,gover_fina_repay_src_dec varchar2(1) -- 政府融资平台还款来源   
    ,domain_policy_type varchar2(1) -- 产业政策类型   
    ,old_cont_state varchar2(3) --    
    ,cap_overdue_date varchar2(10) -- 本金最早逾期日期   
    ,int_overdue_date varchar2(10) -- 利息最早逾期日期   
    ,if_gw varchar2(1) -- 是否绿色通道   
    ,check_finger varchar2(1) -- 指纹检查状态   
    ,tourism_flag varchar2(1) -- 旅游业贷款   
    ,biz_type_ext varchar2(20) -- 业务类型   
    ,biz_type_ext2 varchar2(20) -- 贷款科目   
    ,proj_type varchar2(2) -- 项目类型   
    ,syndicated_amt number(16,2) -- 银团总金额   
    ,lmt_serno varchar2(32) -- 授信协议编号   
    ,item_id varchar2(32) -- 授信台帐编号   
    ,is_risk varchar2(1) -- 是否低风险（1-是，2-否）   
    ,print_cont_no varchar2(32) -- 打印合同号   
    ,last_upd_date varchar2(10) --    
    ,loan_mode varchar2(1) -- 发放方式 一次发放,多次发放   
    ,is_loan_anytime varchar2(1) -- 是否随借随还   
    ,rate_select_type varchar2(1) -- 利率选取日期种类 1-按起息日  2-按合同签订日   
    ,is_stage_repay varchar2(1) -- 是否允许阶段性还款   
    ,int_cal_type varchar2(1) -- 利息计算基础 1-贷款金额  2-贷款余额   
    ,pay_type varchar2(1) -- 贷款资金支付方式 1-贷款人受托支付 2-借款人自主支付   
    ,is_prj_cooperate varchar2(4) -- 是否使用合作商额度   
    ,prj_cooperate_serno varchar2(40) -- 合作商协议编号   
    ,repayment_interval varchar2(2) -- 还款间隔   
    ,repayment_date_confirm varchar2(1) -- 还款日确定   
    ,is_bank_rel varchar2(1) -- 是否与贵行存在关联关系   
    ,input_date varchar2(10) -- 贷款申请日期   
    ,intent_cop varchar2(32) -- 意向类合作商   
    ,is_intent_cop varchar2(1) -- 是否引入意向类合作商   
    ,enter_account_type varchar2(20) -- 入账账户支付工具类型   
    ,repayment_account_type varchar2(20) -- 还款账户支付工具类型   
    ,old_loan_amount number(16,2) -- 原借据金额   
    ,old_loan_balance number(16,2) -- 原借据余额   
    ,return_date varchar2(2) -- 还款日   
    ,creation_date varchar2(10) -- 合同生成日期   
    ,is_pub_com varchar2(5) -- 是否引入公职贷单位   
    ,pub_com varchar2(30) -- 公职贷单位编号   
    ,is_cl varchar2(1) --    
    ,pf_serno varchar2(48) -- 批复流水号   
    ,cop_acc_no varchar2(32) -- 合作商台账编号   
    ,cop_prj_type varchar2(3) -- 合作商项目类型   
    ,cop_cus_type varchar2(3) -- 合作商类型   
    ,opt_type varchar2(2) -- 随借随还状态   
    ,is_balloon varchar2(1) -- 是否选择气球贷   
    ,last_term_percent number(2,2) -- 最后一期还本金额比例   
    ,avg_mortagage_rate number(16,4) -- 平均抵质押率(%)   
    ,total_max_mortagage_amt number(16,2) -- 抵质押担保总额(元)   
    ,remove_avail_amt number(16,2) -- 押品抽取的金额   
    ,is_sign varchar2(1) -- 抽取标志   
    ,amt_use_type varchar2(1) -- 额度透支类型（0-优先使用账户余额,1-优先使用额度）   
    ,trigg_amt number(16,2) -- 透支触发阀值   
    ,basic_ccr_amt number(16,2) -- 基础评分卡授信额度   
    ,bill_term varchar2(3) -- 单笔放款期限（3-3个月,6-6个月,9-9个月,12-12个月）   
    ,reality_ir_d number(16,9) -- 执行日利率   
    ,cont_amt_chg_limit number(16,2) -- 调整额度上限   
    ,relate_no varchar2(40) -- 关联业务编号,组合贷时使用（申请流水号或借款合同号）   
    ,cancel_time varchar2(30) -- 合同注销时间   
    ,floor_num varchar2(2) -- 住房套数   
    ,is_jg_account varchar2(2) -- 是否在我行开立监管账户   
    ,rate_type varchar2(3) --    
    ,sld_seq_num varchar2(12) --    
    ,cltrl_contr_link_loc varchar2(200) --    
    ,cltrl_contr_sign_dt varchar2(10) --    
    ,start_dt date -- 开始时间   
    ,end_dt date -- 结束时间   
    ,id_mark varchar2(10) -- 增删标志   
    ,etl_timestamp timestamp  --数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.rcrs_ctr_loan_cont to ${iel_schema};

-- comment
comment on table ${idl_schema}.rcrs_ctr_loan_cont is '贷款合同信息表';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cont_no is '合同编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.serno is '业务流水号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cont_type is '合同类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.prd_pk is '产品主键';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.biz_type is '业务品种';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.prd_name is '产品名称';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.app_form is '表单类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cust_no is '客户编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cust_name is '客户名称';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.biz_type_sub is '业务品种细分';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.biz_type_detail is '业务品种分类名称';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_form is '贷款形式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_nature is '贷款性质';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_kind_ca is '企业贷款种类';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_type_ext is '关联交易类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_type_ext2 is '关联交易描述';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.currency_type is '币种';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.approval_amt is '审批金额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cont_amt is '合同金额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.total_issue_amt is '累计发放金额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.total_recyle_amt is '累计回收金额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.avail_amt is '合同可用余额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.term_time_type is '期限时间类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_term is '贷款期限';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_start_date is '贷款起始日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_end_date is '贷款终止日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.ruling_ir is '基准利率';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cal_floating_rate is '利率浮动比';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.reality_ir_y is '执行利率（年）';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.overdue_rate is '逾期利率浮动比例';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.overdue_ir is '逾期月利率';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.default_rate is '逾期利率浮动比例';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.default_ir is '挤占挪用利率浮动比例';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.ci_rate is '复利加罚率';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.ci_ir is '复利月利率';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.ir_adjust_mode is '利率调整方式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.interest_acc_mode is '结息方式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.chargeoff_ind is '出帐方式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.discont_ind is '是否贴息';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.discount_id is '贴息方编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.mortgage_flg is '按揭标识';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repayment_mode is '还款方式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repayment_period is '还款频率';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.assure_means_main is '主担保方式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.assure_means2 is '主担保方式2';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.assure_means3 is '主担保方式3';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_direction is '贷款投向';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.direction_name is '投向名称';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.agriculture_type is '涉农情况';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.agriculture_use is '涉农用途';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.minor_entrp_range is '小企业统计口径(银监)';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_use_type is '借款用途类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.use_dec is '用途说明';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repayment_src_dec is '还款来源';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.limit_ind is '授信额度使用标志';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.guarantora_grp_ind is '联保贷款标志';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.copartner_ind is '市场合作方标志';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_card_ind is '使用农户贷款证标志';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.entrust_ind is '委托方贷款标识';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_type1 is '借款分类1';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_type2 is '借款分类2';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_type3 is '借款分类3';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_type4 is '借款分类4';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_type5 is '借款分类5';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_type6 is '借款分类6';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.final_endorse_br_id is '最终审批机构';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.final_endorse_date is '最终审批日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.final_endorse_id is '最终审批人';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.sign_date is '合同签订日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.change_date is '合同变更日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cont_state is '合同状态';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.input_id is '托管人（申请人）';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cust_mgr is '客户经理';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.input_br_id is '受理机构';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.main_br_id is '主管机构';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.fina_br_id is '账务机构';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.old_bill_no is '原借据号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cla_result is '风险分类初分结果';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cla_suggestion is '风险分类初分意见';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.ir_exe_type is '利率变更生效方式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.responsible_man is '责任人';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.government_ind is '涉政类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.government_org_attribute is '政机构属性';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.government_platform is '是否为涉政平台';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.int_rate_type is '利率类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.int_rate_inc_opt is '率增量选项';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.int_rate_inc is '利率增量';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.fixed_rate is '固定利率';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.prd_userdf_type is '产品自定义类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.prd_userdf_name is '产品自定义名称';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.consign_loan_bgl_acct_no is '委托贷款BGL帐号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.funds_src is '资金来源';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.chargeoff_manage is '出帐负责人';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.enter_account is '入账账号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.enter_account_name is '入账账户名称';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repayment_account is '还款账号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repayment_acc_name is '还款账户名称';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.prd_type is '产品类别';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.ispaf is '是否住房公积金贷款';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cosurety_cont_no is '联保协议编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.lead_arranger_ind is '牵头行标志';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cn_cont_no is '中文合同编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.fldvalue01 is '备注1';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.fldvalue02 is '备注2';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.disaster_type is '救灾类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.carve_out_type is '创业贷款';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.farm_card_type is '农户发放形式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.overdue_type is '逾期利率浮动类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.default_type is '挤占利率浮动类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.spe_loan_type2 is '特色贷款类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repay_interest_mode is '提前还款部分本金的利息计收方式';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repay_principal_rate is '提前还款本金的比例';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.add_interest_date is '加收利息时间（月）';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cus_area is '客户所属片区';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.syndicated_ind is '银/社团标识';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.syndicated_type is '银/社团类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.join_role is '参与角色';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.syndicated_proxy_id is '代理行机构号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.government_financing is '是否政府融资平台';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.gover_fina_su_relat is '政府融资平台隶属关系';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.gover_fina_attribute is '政府融资平台属性';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.gover_fina_type is '政府融资平台类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.gover_fina_direction is '政府融资平台投向';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.gover_fina_repay_src_dec is '政府融资平台还款来源';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.domain_policy_type is '产业政策类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.old_cont_state is '';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cap_overdue_date is '本金最早逾期日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.int_overdue_date is '利息最早逾期日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.if_gw is '是否绿色通道';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.check_finger is '指纹检查状态';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.tourism_flag is '旅游业贷款';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.biz_type_ext is '业务类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.biz_type_ext2 is '贷款科目';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.proj_type is '项目类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.syndicated_amt is '银团总金额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.lmt_serno is '授信协议编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.item_id is '授信台帐编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_risk is '是否低风险（1-是，2-否）';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.print_cont_no is '打印合同号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.last_upd_date is '';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.loan_mode is '发放方式 一次发放,多次发放';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_loan_anytime is '是否随借随还';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.rate_select_type is '利率选取日期种类 1-按起息日  2-按合同签订日';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_stage_repay is '是否允许阶段性还款';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.int_cal_type is '利息计算基础 1-贷款金额  2-贷款余额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.pay_type is '贷款资金支付方式 1-贷款人受托支付 2-借款人自主支付';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_prj_cooperate is '是否使用合作商额度';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.prj_cooperate_serno is '合作商协议编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repayment_interval is '还款间隔';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repayment_date_confirm is '还款日确定';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_bank_rel is '是否与贵行存在关联关系';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.input_date is '贷款申请日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.intent_cop is '意向类合作商';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_intent_cop is '是否引入意向类合作商';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.enter_account_type is '入账账户支付工具类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.repayment_account_type is '还款账户支付工具类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.old_loan_amount is '原借据金额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.old_loan_balance is '原借据余额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.return_date is '还款日';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.creation_date is '合同生成日期';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_pub_com is '是否引入公职贷单位';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.pub_com is '公职贷单位编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_cl is '';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.pf_serno is '批复流水号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cop_acc_no is '合作商台账编号';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cop_prj_type is '合作商项目类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cop_cus_type is '合作商类型';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.opt_type is '随借随还状态';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_balloon is '是否选择气球贷';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.last_term_percent is '最后一期还本金额比例';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.avg_mortagage_rate is '平均抵质押率(%)';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.total_max_mortagage_amt is '抵质押担保总额(元)';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.remove_avail_amt is '押品抽取的金额';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_sign is '抽取标志';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.amt_use_type is '额度透支类型（0-优先使用账户余额,1-优先使用额度）';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.trigg_amt is '透支触发阀值';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.basic_ccr_amt is '基础评分卡授信额度';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.bill_term is '单笔放款期限（3-3个月,6-6个月,9-9个月,12-12个月）';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.reality_ir_d is '执行日利率';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cont_amt_chg_limit is '调整额度上限';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.relate_no is '关联业务编号,组合贷时使用（申请流水号或借款合同号）';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cancel_time is '合同注销时间';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.floor_num is '住房套数';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.is_jg_account is '是否在我行开立监管账户';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.rate_type is '';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.sld_seq_num is '';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cltrl_contr_link_loc is '';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.cltrl_contr_sign_dt is '';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.start_dt is '开始时间';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.end_dt is '结束时间';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.id_mark is '增删标志';
comment on column ${idl_schema}.rcrs_ctr_loan_cont.etl_timestamp is '数据处理时间';