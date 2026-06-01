/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_agt_loan_cont_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_agt_loan_cont_info
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_agt_loan_cont_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_agt_loan_cont_info(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,rela_apprv_flow_num varchar2(60) -- 相关批准流水号
    ,happ_dt date -- 发生日期
    ,party_id varchar2(60) -- 当事人编号
    ,bus_breed_id varchar2(60) -- 业务品种编号
    ,bus_sub_type_cd varchar2(10) -- 业务子类型代码
    ,happ_type_cd varchar2(10) -- 发生类型代码
    ,lmt_circl_flg varchar2(10) -- 额度循环标志
    ,bank_fin_tot number(30,2) -- 银行融资总额
    ,bill_qtty number(10) -- 票据数量
    ,curr_cd varchar2(10) -- 币种代码
    ,cont_amt number(30,2) -- 合同金额
    ,tenor_mon number(10) -- 期限月
    ,base_rat number(18,6) -- 基准利率
    ,int_rat_type_cd varchar2(10) -- 利率类型代码
    ,int_rat_flo_val number(18,6) -- 利率浮动值
    ,exec_int_rat number(18,6) -- 执行利率
    ,charge_way_cd varchar2(10) -- 收费方式代码
    ,comm_fee_ratio number(18,6) -- 手续费比例
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,margin_ratio number(18,6) -- 保证金比例
    ,margin_curr_cd varchar2(10) -- 保证金币种代码
    ,margin_amt number(30,2) -- 保证金金额
    ,margin_acct_id varchar2(60) -- 保证金账户编号
    ,pnlt_int_rat number(18,6) -- 罚息利率
    ,draw_way_cd varchar2(10) -- 提款方式代码
    ,init_lc_tenor_type_cd varchar2(10) -- 原信用证期限类型代码
    ,loan_dir_indus_cd varchar2(10) -- 贷款投向行业代码
    ,loan_usage_descb varchar2(2000) -- 贷款用途描述
    ,repay_src_descb varchar2(200) -- 还款来源描述
    ,distr_dt date -- 发放日期
    ,exp_dt date -- 到期日期
    ,trdpty_cust_name1 varchar2(250) -- 第三方客户名称1
    ,trdpty_cust_name2 varchar2(250) -- 第三方客户名称2
    ,trdpty_acct_id varchar2(60) -- 第三方账户编号
    ,rela_trade_cont_id varchar2(60) -- 相关贸易合同编号
    ,trade_cont_amt number(30,2) -- 贸易合同金额
    ,lc_id varchar2(60) -- 信用证编号
    ,main_guar_way_cd varchar2(10) -- 主担保方式代码
    ,guar_way_cd1 varchar2(10) -- 担保方式代码1
    ,guar_way_cd2 varchar2(10) -- 担保方式代码2
    ,other_guar_way_flg varchar2(10) -- 其他担保方式标志
    ,major_guartor_name varchar2(250) -- 主要担保人名称
    ,major_guartor_id varchar2(60) -- 主要担保人编号
    ,low_risk_bus_flg varchar2(10) -- 低风险业务标志
    ,remote_loan_flg varchar2(10) -- 异地贷款标志
    ,appl_way_cd varchar2(60) -- 申请方式代码
    ,distrd_loan_amt number(30,2) -- 已发放贷款金额
    ,curr_bal number(30,2) -- 当前余额
    ,nomal_bal number(30,2) -- 正常余额
    ,ovdue_bal number(30,2) -- 逾期余额
    ,idle_bal number(30,2) -- 呆滞余额
    ,bad_debt_bal number(30,2) -- 呆账余额
    ,in_bs_over_int_bal number(30,2) -- 表内欠息余额
    ,off_bs_over_int_bal number(30,2) -- 表外欠息余额
    ,pric_pnlt number(30,2) -- 本金罚息
    ,int_pnlt number(30,2) -- 利息罚息
    ,level5_cls_cd varchar2(10) -- 五级分类代码
    ,termnt_dt date -- 终止日期
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,mgmt_teller_id varchar2(60) -- 管理柜员编号
    ,oper_org_id varchar2(60) -- 经办机构编号
    ,oper_teller_id varchar2(60) -- 经办柜员编号
    ,oper_dt date -- 经办日期
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,modif_dt date -- 变更日期
    ,cap_src_cd varchar2(10) -- 资金来源代码
    ,circl_flg varchar2(10) -- 循环标志
    ,lmt_froz_flg varchar2(10) -- 额度冻结标志
    ,actl_text_cont_id varchar2(60) -- 实际文本合同编号
    ,stl_acct_id varchar2(60) -- 结算账户编号
    ,loan_enter_acct_acct_id varchar2(60) -- 贷款入账账户编号
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,tenor number(10) -- 期限
    ,distr_org_id varchar2(60) -- 放款机构编号
    ,temp_store_flg varchar2(10) -- 暂存标志
    ,froz_flg varchar2(10) -- 冻结标志
    ,expos_bal number(30,2) -- 敞口余额
    ,turn_crdt_flg varchar2(10) -- 转授信标志
    ,mode_pay_cd varchar2(10) -- 支付方式代码
    ,level11_cls_cd varchar2(10) -- 十一级分类代码
    ,guar_type_cd varchar2(10) -- 担保类型代码
    ,crdt_type_cd varchar2(10) -- 授信类型代码
    ,valid_flg varchar2(10) -- 有效标志
    ,cont_type_cd varchar2(10) -- 合同类型代码
    ,loan_insure_flg varchar2(10) -- 贷款保险标志
    ,ic_way_cd varchar2(10) -- 期供方式代码
    ,repay_ped_cd varchar2(10) -- 还款周期代码
    ,int_rat_exec_way_cd varchar2(10) -- 利率执行方式代码
    ,loan_other_usage_descb varchar2(200) -- 贷款其他用途描述
    ,sup_chain_fin_mode_bus_flg varchar2(10) -- 供应链金融模式业务标志
    ,imp_proj_loan_flg varchar2(10) -- 重点项目贷款标志
    ,surp_indus_cd varchar2(10) -- 过剩行业代码
    ,cty_lmt_indus_flg varchar2(10) -- 国家限制行业标志
    ,gover_crdt_flg varchar2(10) -- 政府授信标志
    ,cdb_crdt_flg varchar2(10) -- 国开行授信标志
    ,fix_asset_crdt_flg varchar2(10) -- 固定资产授信标志
    ,discnt_bf_revw_flg varchar2(10) -- 先贴后查标志
    ,pnlt_flg varchar2(10) -- 罚息标志
    ,loan_fin_supt_way_cd varchar2(10) -- 贷款财政扶持方式代码
    ,agt_pay_int_flg varchar2(10) -- 协议付息标志
    ,negot_int_rat number(18,6) -- 押汇利率
    ,negot_amt number(30,2) -- 押汇金额
    ,loan_distr_status_cd varchar2(10) -- 贷款发放状态代码
    ,termnt_cont_rs_rgst_dt date -- 终止合同原因登记日期
    ,rela_cont_flow_num varchar2(60) -- 相关合同流水号
    ,lc_amt number(30,2) -- 信用证金额
    ,loan_src_cd varchar2(10) -- 贷款来源代码
    ,cont_invalid_dt date -- 合同失效日期
    ,backup_effect_flg varchar2(10) -- 备份生效标志
    ,crdt_cont_id varchar2(60) -- 授信合同编号
    ,matn_flg varchar2(10) -- 维护标志
    ,risk_type_cd varchar2(60) -- 风险类型代码
    ,syn_loan_distr_amt number(30,2) -- 银团贷款发放金额
    ,actl_fin_ps_id varchar2(60) -- 实际融资人编号
    ,invest_way_cd varchar2(10) -- 投资方式代码
    ,dir_ind_fund_flg varchar2(10) -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg varchar2(10) -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg varchar2(10) -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg varchar2(10) -- 消费服务类融资标志
    ,stl_dep_flg varchar2(10) -- 结算性存款标志
    ,cota_opt_choice_flg varchar2(10) -- 含有回售选择权标志
    ,septbl_flg varchar2(10) -- 可分离标志
    ,tran_asset_name varchar2(250) -- 交易资产名称
    ,crdt_bus_flow_type_cd varchar2(10) -- 授信业务流程类型代码
    ,batch_data_src_cd varchar2(10) -- 批量数据来源代码
    ,crdt_rg_cd varchar2(10) -- 授信区域代码
    ,estate_fin_flg varchar2(10) -- 房地产融资标志
    ,invo_gover_class_fin_flg1 varchar2(10) -- 涉及政府类融资标志1
    ,consm_serv_class_fin_flg1 varchar2(10) -- 消费服务类融资标志1
    ,br_build_ifin_flg varchar2(10) -- 一带一路建设投融资标志
    ,green_crdt_fin_flg varchar2(10) -- 绿色信贷融资标志
    ,onl_bus_flg varchar2(10) -- 线上业务标志
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,lmt_use_latest_dt date -- 额度使用最迟日期
    ,lmt_under_bus_latest_exp_dt date -- 额度项下业务最迟到期日期
    ,lmt_cont_id varchar2(60) -- 额度合同编号
    ,trade_cont_curr varchar2(10) -- 贸易合同币种
    ,other_cond_request varchar2(4000) -- 其他条件和要求
    ,secd_repay_acct_id varchar2(60) -- 第二还款帐户编号
    ,use_prod_cd varchar2(10) -- 使用产品代码
    ,discnt_int_buyer_bear_ratio number(18,6) -- 贴现利息买方承担比例
    ,discnt_int_applit_pay_ratio number(18,6) -- 贴现利息申请人支付比例
    ,major_loan_cls_cd varchar2(10) -- 专业贷款分类代码
    ,risk_expose_cls varchar2(100) -- 风险暴露分类
    ,qual_centr_cntpty_flg varchar2(10) -- 合格中央交易对手标志
    ,mgmt_mode_cd varchar2(10) -- 管理模式代码
    ,tran_market_type_cd varchar2(10) -- 交易市场类型代码
    ,incre_crdt_way_cd varchar2(10) -- 增信方式代码
    ,bill_uniq_idf varchar2(60) -- 票据唯一标识
    ,is_sup_chain_fin_bus_flg varchar2(10) -- 是否为供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd varchar2(10) -- 供应链金融业务产品分类代码
    ,unify_repay_day varchar2(10) -- 统一还款日
    ,job_cd varchar2(10) -- 任务代码
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
grant select on ${idl_schema}.icrm_agt_loan_cont_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_agt_loan_cont_info is '公司贷款合同信息';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.agt_id is '协议编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.cont_id is '合同编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.rela_apprv_flow_num is '相关批准流水号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.happ_dt is '发生日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.party_id is '当事人编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.bus_breed_id is '业务品种编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.bus_sub_type_cd is '业务子类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.happ_type_cd is '发生类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.lmt_circl_flg is '额度循环标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.bank_fin_tot is '银行融资总额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.bill_qtty is '票据数量';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.cont_amt is '合同金额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.tenor_mon is '期限月';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.base_rat is '基准利率';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.int_rat_type_cd is '利率类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.int_rat_flo_val is '利率浮动值';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.exec_int_rat is '执行利率';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.charge_way_cd is '收费方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.comm_fee_ratio is '手续费比例';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.comm_fee_amt is '手续费金额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.margin_ratio is '保证金比例';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.margin_curr_cd is '保证金币种代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.margin_amt is '保证金金额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.margin_acct_id is '保证金账户编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.pnlt_int_rat is '罚息利率';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.draw_way_cd is '提款方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.init_lc_tenor_type_cd is '原信用证期限类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.loan_dir_indus_cd is '贷款投向行业代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.loan_usage_descb is '贷款用途描述';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.repay_src_descb is '还款来源描述';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.distr_dt is '发放日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.trdpty_cust_name1 is '第三方客户名称1';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.trdpty_cust_name2 is '第三方客户名称2';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.trdpty_acct_id is '第三方账户编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.rela_trade_cont_id is '相关贸易合同编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.trade_cont_amt is '贸易合同金额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.lc_id is '信用证编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.main_guar_way_cd is '主担保方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.guar_way_cd1 is '担保方式代码1';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.guar_way_cd2 is '担保方式代码2';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.other_guar_way_flg is '其他担保方式标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.major_guartor_name is '主要担保人名称';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.major_guartor_id is '主要担保人编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.low_risk_bus_flg is '低风险业务标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.remote_loan_flg is '异地贷款标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.appl_way_cd is '申请方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.distrd_loan_amt is '已发放贷款金额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.curr_bal is '当前余额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.nomal_bal is '正常余额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.ovdue_bal is '逾期余额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.idle_bal is '呆滞余额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.bad_debt_bal is '呆账余额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.in_bs_over_int_bal is '表内欠息余额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.off_bs_over_int_bal is '表外欠息余额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.pric_pnlt is '本金罚息';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.int_pnlt is '利息罚息';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.level5_cls_cd is '五级分类代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.termnt_dt is '终止日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.mgmt_org_id is '管理机构编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.mgmt_teller_id is '管理柜员编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.oper_org_id is '经办机构编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.oper_teller_id is '经办柜员编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.oper_dt is '经办日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.rgst_teller_id is '登记柜员编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.rgst_dt is '登记日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.modif_dt is '变更日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.cap_src_cd is '资金来源代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.circl_flg is '循环标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.lmt_froz_flg is '额度冻结标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.actl_text_cont_id is '实际文本合同编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.stl_acct_id is '结算账户编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.loan_enter_acct_acct_id is '贷款入账账户编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.tenor is '期限';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.distr_org_id is '放款机构编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.temp_store_flg is '暂存标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.froz_flg is '冻结标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.expos_bal is '敞口余额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.turn_crdt_flg is '转授信标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.mode_pay_cd is '支付方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.level11_cls_cd is '十一级分类代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.guar_type_cd is '担保类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.crdt_type_cd is '授信类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.valid_flg is '有效标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.cont_type_cd is '合同类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.loan_insure_flg is '贷款保险标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.ic_way_cd is '期供方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.repay_ped_cd is '还款周期代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.int_rat_exec_way_cd is '利率执行方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.loan_other_usage_descb is '贷款其他用途描述';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.sup_chain_fin_mode_bus_flg is '供应链金融模式业务标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.imp_proj_loan_flg is '重点项目贷款标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.surp_indus_cd is '过剩行业代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.cty_lmt_indus_flg is '国家限制行业标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.gover_crdt_flg is '政府授信标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.cdb_crdt_flg is '国开行授信标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.fix_asset_crdt_flg is '固定资产授信标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.discnt_bf_revw_flg is '先贴后查标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.pnlt_flg is '罚息标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.loan_fin_supt_way_cd is '贷款财政扶持方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.agt_pay_int_flg is '协议付息标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.negot_int_rat is '押汇利率';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.negot_amt is '押汇金额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.loan_distr_status_cd is '贷款发放状态代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.termnt_cont_rs_rgst_dt is '终止合同原因登记日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.rela_cont_flow_num is '相关合同流水号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.lc_amt is '信用证金额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.loan_src_cd is '贷款来源代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.cont_invalid_dt is '合同失效日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.backup_effect_flg is '备份生效标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.crdt_cont_id is '授信合同编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.matn_flg is '维护标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.risk_type_cd is '风险类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.syn_loan_distr_amt is '银团贷款发放金额';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.actl_fin_ps_id is '实际融资人编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.invest_way_cd is '投资方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.dir_ind_fund_flg is '投向产业基金标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.dir_makti_debt_eqty_flg is '投向市场化债转股标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.invo_gover_class_fin_flg is '涉及政府类融资标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.stl_dep_flg is '结算性存款标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.cota_opt_choice_flg is '含有回售选择权标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.septbl_flg is '可分离标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.tran_asset_name is '交易资产名称';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.crdt_bus_flow_type_cd is '授信业务流程类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.batch_data_src_cd is '批量数据来源代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.crdt_rg_cd is '授信区域代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.estate_fin_flg is '房地产融资标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.invo_gover_class_fin_flg1 is '涉及政府类融资标志1';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.consm_serv_class_fin_flg1 is '消费服务类融资标志1';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.onl_bus_flg is '线上业务标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.class_crdt_flg is '类信贷标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.lmt_use_latest_dt is '额度使用最迟日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.lmt_under_bus_latest_exp_dt is '额度项下业务最迟到期日期';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.lmt_cont_id is '额度合同编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.trade_cont_curr is '贸易合同币种';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.other_cond_request is '其他条件和要求';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.secd_repay_acct_id is '第二还款帐户编号';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.use_prod_cd is '使用产品代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.discnt_int_buyer_bear_ratio is '贴现利息买方承担比例';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.discnt_int_applit_pay_ratio is '贴现利息申请人支付比例';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.major_loan_cls_cd is '专业贷款分类代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.risk_expose_cls is '风险暴露分类';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.qual_centr_cntpty_flg is '合格中央交易对手标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.mgmt_mode_cd is '管理模式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.tran_market_type_cd is '交易市场类型代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.incre_crdt_way_cd is '增信方式代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.bill_uniq_idf is '票据唯一标识';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.is_sup_chain_fin_bus_flg is '是否为供应链金融业务标志';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.sup_chain_fin_bus_prod_cls_cd is '供应链金融业务产品分类代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.unify_repay_day is '统一还款日';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_agt_loan_cont_info.etl_timestamp is '数据处理时间';
