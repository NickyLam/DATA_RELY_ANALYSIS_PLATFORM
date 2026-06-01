/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_agt_loan_cont_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_agt_loan_cont_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_agt_loan_cont_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_agt_loan_cont_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_agt_loan_cont_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,cont_id  -- 合同编号
    ,rela_apprv_flow_num  -- 相关批准流水号
    ,happ_dt  -- 发生日期
    ,party_id  -- 当事人编号
    ,bus_breed_id  -- 业务品种编号
    ,bus_sub_type_cd  -- 业务子类型代码
    ,happ_type_cd  -- 发生类型代码
    ,lmt_circl_flg  -- 额度循环标志
    ,bank_fin_tot  -- 银行融资总额
    ,bill_qtty  -- 票据数量
    ,curr_cd  -- 币种代码
    ,cont_amt  -- 合同金额
    ,tenor_mon  -- 期限月
    ,base_rat  -- 基准利率
    ,int_rat_type_cd  -- 利率类型代码
    ,int_rat_flo_val  -- 利率浮动值
    ,exec_int_rat  -- 执行利率
    ,charge_way_cd  -- 收费方式代码
    ,comm_fee_ratio  -- 手续费比例
    ,comm_fee_amt  -- 手续费金额
    ,margin_ratio  -- 保证金比例
    ,margin_curr_cd  -- 保证金币种代码
    ,margin_amt  -- 保证金金额
    ,margin_acct_id  -- 保证金账户编号
    ,pnlt_int_rat  -- 罚息利率
    ,draw_way_cd  -- 提款方式代码
    ,init_lc_tenor_type_cd  -- 原信用证期限类型代码
    ,loan_dir_indus_cd  -- 贷款投向行业代码
    ,loan_usage_descb  -- 贷款用途描述
    ,repay_src_descb  -- 还款来源描述
    ,distr_dt  -- 发放日期
    ,exp_dt  -- 到期日期
    ,trdpty_cust_name1  -- 第三方客户名称1
    ,trdpty_cust_name2  -- 第三方客户名称2
    ,trdpty_acct_id  -- 第三方账户编号
    ,rela_trade_cont_id  -- 相关贸易合同编号
    ,trade_cont_amt  -- 贸易合同金额
    ,lc_id  -- 信用证编号
    ,main_guar_way_cd  -- 主担保方式代码
    ,guar_way_cd1  -- 担保方式代码1
    ,guar_way_cd2  -- 担保方式代码2
    ,other_guar_way_flg  -- 其他担保方式标志
    ,major_guartor_name  -- 主要担保人名称
    ,major_guartor_id  -- 主要担保人编号
    ,low_risk_bus_flg  -- 低风险业务标志
    ,remote_loan_flg  -- 异地贷款标志
    ,appl_way_cd  -- 申请方式代码
    ,distrd_loan_amt  -- 已发放贷款金额
    ,curr_bal  -- 当前余额
    ,nomal_bal  -- 正常余额
    ,ovdue_bal  -- 逾期余额
    ,idle_bal  -- 呆滞余额
    ,bad_debt_bal  -- 呆账余额
    ,in_bs_over_int_bal  -- 表内欠息余额
    ,off_bs_over_int_bal  -- 表外欠息余额
    ,pric_pnlt  -- 本金罚息
    ,int_pnlt  -- 利息罚息
    ,level5_cls_cd  -- 五级分类代码
    ,termnt_dt  -- 终止日期
    ,mgmt_org_id  -- 管理机构编号
    ,mgmt_teller_id  -- 管理柜员编号
    ,oper_org_id  -- 经办机构编号
    ,oper_teller_id  -- 经办柜员编号
    ,oper_dt  -- 经办日期
    ,rgst_org_id  -- 登记机构编号
    ,rgst_teller_id  -- 登记柜员编号
    ,rgst_dt  -- 登记日期
    ,modif_dt  -- 变更日期
    ,cap_src_cd  -- 资金来源代码
    ,circl_flg  -- 循环标志
    ,lmt_froz_flg  -- 额度冻结标志
    ,actl_text_cont_id  -- 实际文本合同编号
    ,stl_acct_id  -- 结算账户编号
    ,loan_enter_acct_acct_id  -- 贷款入账账户编号
    ,int_rat_adj_way_cd  -- 利率调整方式代码
    ,tenor  -- 期限
    ,distr_org_id  -- 放款机构编号
    ,temp_store_flg  -- 暂存标志
    ,froz_flg  -- 冻结标志
    ,expos_bal  -- 敞口余额
    ,turn_crdt_flg  -- 转授信标志
    ,mode_pay_cd  -- 支付方式代码
    ,level11_cls_cd  -- 十一级分类代码
    ,guar_type_cd  -- 担保类型代码
    ,crdt_type_cd  -- 授信类型代码
    ,valid_flg  -- 有效标志
    ,cont_type_cd  -- 合同类型代码
    ,loan_insure_flg  -- 贷款保险标志
    ,ic_way_cd  -- 期供方式代码
    ,repay_ped_cd  -- 还款周期代码
    ,int_rat_exec_way_cd  -- 利率执行方式代码
    ,loan_other_usage_descb  -- 贷款其他用途描述
    ,sup_chain_fin_mode_bus_flg  -- 供应链金融模式业务标志
    ,imp_proj_loan_flg  -- 重点项目贷款标志
    ,surp_indus_cd  -- 过剩行业代码
    ,cty_lmt_indus_flg  -- 国家限制行业标志
    ,gover_crdt_flg  -- 政府授信标志
    ,cdb_crdt_flg  -- 国开行授信标志
    ,fix_asset_crdt_flg  -- 固定资产授信标志
    ,discnt_bf_revw_flg  -- 先贴后查标志
    ,pnlt_flg  -- 罚息标志
    ,loan_fin_supt_way_cd  -- 贷款财政扶持方式代码
    ,agt_pay_int_flg  -- 协议付息标志
    ,negot_int_rat  -- 押汇利率
    ,negot_amt  -- 押汇金额
    ,loan_distr_status_cd  -- 贷款发放状态代码
    ,termnt_cont_rs_rgst_dt  -- 终止合同原因登记日期
    ,rela_cont_flow_num  -- 相关合同流水号
    ,lc_amt  -- 信用证金额
    ,loan_src_cd  -- 贷款来源代码
    ,cont_invalid_dt  -- 合同失效日期
    ,backup_effect_flg  -- 备份生效标志
    ,crdt_cont_id  -- 授信合同编号
    ,matn_flg  -- 维护标志
    ,risk_type_cd  -- 风险类型代码
    ,syn_loan_distr_amt  -- 银团贷款发放金额
    ,actl_fin_ps_id  -- 实际融资人编号
    ,invest_way_cd  -- 投资方式代码
    ,dir_ind_fund_flg  -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg  -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg  -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg  -- 消费服务类融资标志
    ,stl_dep_flg  -- 结算性存款标志
    ,cota_opt_choice_flg  -- 含有回售选择权标志
    ,septbl_flg  -- 可分离标志
    ,tran_asset_name  -- 交易资产名称
    ,crdt_bus_flow_type_cd  -- 授信业务流程类型代码
    ,batch_data_src_cd  -- 批量数据来源代码
    ,crdt_rg_cd  -- 授信区域代码
    ,estate_fin_flg  -- 房地产融资标志
    ,invo_gover_class_fin_flg1  -- 涉及政府类融资标志1
    ,consm_serv_class_fin_flg1  -- 消费服务类融资标志1
    ,br_build_ifin_flg  -- 一带一路建设投融资标志
    ,green_crdt_fin_flg  -- 绿色信贷融资标志
    ,onl_bus_flg  -- 线上业务标志
    ,class_crdt_flg  -- 类信贷标志
    ,lmt_use_latest_dt  -- 额度使用最迟日期
    ,lmt_under_bus_latest_exp_dt  -- 额度项下业务最迟到期日期
    ,lmt_cont_id  -- 额度合同编号
    ,trade_cont_curr  -- 贸易合同币种
    ,other_cond_request  -- 其他条件和要求
    ,secd_repay_acct_id  -- 第二还款帐户编号
    ,use_prod_cd  -- 使用产品代码
    ,discnt_int_buyer_bear_ratio  -- 贴现利息买方承担比例
    ,discnt_int_applit_pay_ratio  -- 贴现利息申请人支付比例
    ,major_loan_cls_cd  -- 专业贷款分类代码
    ,risk_expose_cls  -- 风险暴露分类
    ,qual_centr_cntpty_flg  -- 合格中央交易对手标志
    ,mgmt_mode_cd  -- 管理模式代码
    ,tran_market_type_cd  -- 交易市场类型代码
    ,incre_crdt_way_cd  -- 增信方式代码
    ,bill_uniq_idf  -- 票据唯一标识
    ,is_sup_chain_fin_bus_flg  -- 是否为供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd  -- 供应链金融业务产品分类代码
    ,unify_repay_day  -- 统一还款日
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.cont_id,chr(13),''),chr(10),'')  -- 合同编号
    ,replace(replace(t1.rela_apprv_flow_num,chr(13),''),chr(10),'')  -- 相关批准流水号
    ,t1.happ_dt  -- 发生日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'')  -- 业务品种编号
    ,replace(replace(t1.bus_sub_type_cd,chr(13),''),chr(10),'')  -- 业务子类型代码
    ,replace(replace(t1.happ_type_cd,chr(13),''),chr(10),'')  -- 发生类型代码
    ,replace(replace(t1.lmt_circl_flg,chr(13),''),chr(10),'')  -- 额度循环标志
    ,t1.bank_fin_tot  -- 银行融资总额
    ,t1.bill_qtty  -- 票据数量
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.cont_amt  -- 合同金额
    ,t1.tenor_mon  -- 期限月
    ,t1.base_rat  -- 基准利率
    ,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'')  -- 利率类型代码
    ,t1.int_rat_flo_val  -- 利率浮动值
    ,t1.exec_int_rat  -- 执行利率
    ,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'')  -- 收费方式代码
    ,t1.comm_fee_ratio  -- 手续费比例
    ,t1.comm_fee_amt  -- 手续费金额
    ,t1.margin_ratio  -- 保证金比例
    ,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'')  -- 保证金币种代码
    ,t1.margin_amt  -- 保证金金额
    ,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'')  -- 保证金账户编号
    ,t1.pnlt_int_rat  -- 罚息利率
    ,replace(replace(t1.draw_way_cd,chr(13),''),chr(10),'')  -- 提款方式代码
    ,replace(replace(t1.init_lc_tenor_type_cd,chr(13),''),chr(10),'')  -- 原信用证期限类型代码
    ,replace(replace(t1.loan_dir_indus_cd,chr(13),''),chr(10),'')  -- 贷款投向行业代码
    ,replace(replace(t1.loan_usage_descb,chr(13),''),chr(10),'')  -- 贷款用途描述
    ,replace(replace(t1.repay_src_descb,chr(13),''),chr(10),'')  -- 还款来源描述
    ,t1.distr_dt  -- 发放日期
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.trdpty_cust_name1,chr(13),''),chr(10),'')  -- 第三方客户名称1
    ,replace(replace(t1.trdpty_cust_name2,chr(13),''),chr(10),'')  -- 第三方客户名称2
    ,replace(replace(t1.trdpty_acct_id,chr(13),''),chr(10),'')  -- 第三方账户编号
    ,replace(replace(t1.rela_trade_cont_id,chr(13),''),chr(10),'')  -- 相关贸易合同编号
    ,t1.trade_cont_amt  -- 贸易合同金额
    ,replace(replace(t1.lc_id,chr(13),''),chr(10),'')  -- 信用证编号
    ,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'')  -- 主担保方式代码
    ,replace(replace(t1.guar_way_cd1,chr(13),''),chr(10),'')  -- 担保方式代码1
    ,replace(replace(t1.guar_way_cd2,chr(13),''),chr(10),'')  -- 担保方式代码2
    ,replace(replace(t1.other_guar_way_flg,chr(13),''),chr(10),'')  -- 其他担保方式标志
    ,replace(replace(t1.major_guartor_name,chr(13),''),chr(10),'')  -- 主要担保人名称
    ,replace(replace(t1.major_guartor_id,chr(13),''),chr(10),'')  -- 主要担保人编号
    ,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'')  -- 低风险业务标志
    ,replace(replace(t1.remote_loan_flg,chr(13),''),chr(10),'')  -- 异地贷款标志
    ,replace(replace(t1.appl_way_cd,chr(13),''),chr(10),'')  -- 申请方式代码
    ,t1.distrd_loan_amt  -- 已发放贷款金额
    ,t1.curr_bal  -- 当前余额
    ,t1.nomal_bal  -- 正常余额
    ,t1.ovdue_bal  -- 逾期余额
    ,t1.idle_bal  -- 呆滞余额
    ,t1.bad_debt_bal  -- 呆账余额
    ,t1.in_bs_over_int_bal  -- 表内欠息余额
    ,t1.off_bs_over_int_bal  -- 表外欠息余额
    ,t1.pric_pnlt  -- 本金罚息
    ,t1.int_pnlt  -- 利息罚息
    ,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'')  -- 五级分类代码
    ,t1.termnt_dt  -- 终止日期
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,replace(replace(t1.mgmt_teller_id,chr(13),''),chr(10),'')  -- 管理柜员编号
    ,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'')  -- 经办机构编号
    ,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'')  -- 经办柜员编号
    ,t1.oper_dt  -- 经办日期
    ,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'')  -- 登记机构编号
    ,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'')  -- 登记柜员编号
    ,t1.rgst_dt  -- 登记日期
    ,t1.modif_dt  -- 变更日期
    ,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'')  -- 资金来源代码
    ,replace(replace(t1.circl_flg,chr(13),''),chr(10),'')  -- 循环标志
    ,replace(replace(t1.lmt_froz_flg,chr(13),''),chr(10),'')  -- 额度冻结标志
    ,replace(replace(t1.actl_text_cont_id,chr(13),''),chr(10),'')  -- 实际文本合同编号
    ,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'')  -- 结算账户编号
    ,replace(replace(t1.loan_enter_acct_acct_id,chr(13),''),chr(10),'')  -- 贷款入账账户编号
    ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'')  -- 利率调整方式代码
    ,t1.tenor  -- 期限
    ,replace(replace(t1.distr_org_id,chr(13),''),chr(10),'')  -- 放款机构编号
    ,replace(replace(t1.temp_store_flg,chr(13),''),chr(10),'')  -- 暂存标志
    ,replace(replace(t1.froz_flg,chr(13),''),chr(10),'')  -- 冻结标志
    ,t1.expos_bal  -- 敞口余额
    ,replace(replace(t1.turn_crdt_flg,chr(13),''),chr(10),'')  -- 转授信标志
    ,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'')  -- 支付方式代码
    ,replace(replace(t1.level11_cls_cd,chr(13),''),chr(10),'')  -- 十一级分类代码
    ,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'')  -- 担保类型代码
    ,replace(replace(t1.crdt_type_cd,chr(13),''),chr(10),'')  -- 授信类型代码
    ,replace(replace(t1.valid_flg,chr(13),''),chr(10),'')  -- 有效标志
    ,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'')  -- 合同类型代码
    ,replace(replace(t1.loan_insure_flg,chr(13),''),chr(10),'')  -- 贷款保险标志
    ,replace(replace(t1.ic_way_cd,chr(13),''),chr(10),'')  -- 期供方式代码
    ,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'')  -- 还款周期代码
    ,replace(replace(t1.int_rat_exec_way_cd,chr(13),''),chr(10),'')  -- 利率执行方式代码
    ,replace(replace(t1.loan_other_usage_descb,chr(13),''),chr(10),'')  -- 贷款其他用途描述
    ,replace(replace(t1.sup_chain_fin_mode_bus_flg,chr(13),''),chr(10),'')  -- 供应链金融模式业务标志
    ,replace(replace(t1.imp_proj_loan_flg,chr(13),''),chr(10),'')  -- 重点项目贷款标志
    ,replace(replace(t1.surp_indus_cd,chr(13),''),chr(10),'')  -- 过剩行业代码
    ,replace(replace(t1.cty_lmt_indus_flg,chr(13),''),chr(10),'')  -- 国家限制行业标志
    ,replace(replace(t1.gover_crdt_flg,chr(13),''),chr(10),'')  -- 政府授信标志
    ,replace(replace(t1.cdb_crdt_flg,chr(13),''),chr(10),'')  -- 国开行授信标志
    ,replace(replace(t1.fix_asset_crdt_flg,chr(13),''),chr(10),'')  -- 固定资产授信标志
    ,replace(replace(t1.discnt_bf_revw_flg,chr(13),''),chr(10),'')  -- 先贴后查标志
    ,replace(replace(t1.pnlt_flg,chr(13),''),chr(10),'')  -- 罚息标志
    ,replace(replace(t1.loan_fin_supt_way_cd,chr(13),''),chr(10),'')  -- 贷款财政扶持方式代码
    ,replace(replace(t1.agt_pay_int_flg,chr(13),''),chr(10),'')  -- 协议付息标志
    ,t1.negot_int_rat  -- 押汇利率
    ,t1.negot_amt  -- 押汇金额
    ,replace(replace(t1.loan_distr_status_cd,chr(13),''),chr(10),'')  -- 贷款发放状态代码
    ,t1.termnt_cont_rs_rgst_dt  -- 终止合同原因登记日期
    ,replace(replace(t1.rela_cont_flow_num,chr(13),''),chr(10),'')  -- 相关合同流水号
    ,t1.lc_amt  -- 信用证金额
    ,replace(replace(t1.loan_src_cd,chr(13),''),chr(10),'')  -- 贷款来源代码
    ,t1.cont_invalid_dt  -- 合同失效日期
    ,replace(replace(t1.backup_effect_flg,chr(13),''),chr(10),'')  -- 备份生效标志
    ,replace(replace(t1.crdt_cont_id,chr(13),''),chr(10),'')  -- 授信合同编号
    ,replace(replace(t1.matn_flg,chr(13),''),chr(10),'')  -- 维护标志
    ,replace(replace(t1.risk_type_cd,chr(13),''),chr(10),'')  -- 风险类型代码
    ,t1.syn_loan_distr_amt  -- 银团贷款发放金额
    ,replace(replace(t1.actl_fin_ps_id,chr(13),''),chr(10),'')  -- 实际融资人编号
    ,replace(replace(t1.invest_way_cd,chr(13),''),chr(10),'')  -- 投资方式代码
    ,replace(replace(t1.dir_ind_fund_flg,chr(13),''),chr(10),'')  -- 投向产业基金标志
    ,replace(replace(t1.dir_makti_debt_eqty_flg,chr(13),''),chr(10),'')  -- 投向市场化债转股标志
    ,replace(replace(t1.invo_gover_class_fin_flg,chr(13),''),chr(10),'')  -- 涉及政府类融资标志
    ,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'')  -- 消费服务类融资标志
    ,replace(replace(t1.stl_dep_flg,chr(13),''),chr(10),'')  -- 结算性存款标志
    ,replace(replace(t1.cota_opt_choice_flg,chr(13),''),chr(10),'')  -- 含有回售选择权标志
    ,replace(replace(t1.septbl_flg,chr(13),''),chr(10),'')  -- 可分离标志
    ,replace(replace(t1.tran_asset_name,chr(13),''),chr(10),'')  -- 交易资产名称
    ,replace(replace(t1.crdt_bus_flow_type_cd,chr(13),''),chr(10),'')  -- 授信业务流程类型代码
    ,replace(replace(t1.batch_data_src_cd,chr(13),''),chr(10),'')  -- 批量数据来源代码
    ,replace(replace(t1.crdt_rg_cd,chr(13),''),chr(10),'')  -- 授信区域代码
    ,replace(replace(t1.estate_fin_flg,chr(13),''),chr(10),'')  -- 房地产融资标志
    ,replace(replace(t1.invo_gover_class_fin_flg1,chr(13),''),chr(10),'')  -- 涉及政府类融资标志1
    ,replace(replace(t1.consm_serv_class_fin_flg1,chr(13),''),chr(10),'')  -- 消费服务类融资标志1
    ,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'')  -- 一带一路建设投融资标志
    ,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'')  -- 绿色信贷融资标志
    ,replace(replace(t1.onl_bus_flg,chr(13),''),chr(10),'')  -- 线上业务标志
    ,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'')  -- 类信贷标志
    ,t1.lmt_use_latest_dt  -- 额度使用最迟日期
    ,t1.lmt_under_bus_latest_exp_dt  -- 额度项下业务最迟到期日期
    ,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'')  -- 额度合同编号
    ,replace(replace(t1.trade_cont_curr,chr(13),''),chr(10),'')  -- 贸易合同币种
    ,replace(replace(t1.other_cond_request,chr(13),''),chr(10),'')  -- 其他条件和要求
    ,replace(replace(t1.secd_repay_acct_id,chr(13),''),chr(10),'')  -- 第二还款帐户编号
    ,replace(replace(t1.use_prod_cd,chr(13),''),chr(10),'')  -- 使用产品代码
    ,t1.discnt_int_buyer_bear_ratio  -- 贴现利息买方承担比例
    ,t1.discnt_int_applit_pay_ratio  -- 贴现利息申请人支付比例
    ,replace(replace(t1.major_loan_cls_cd,chr(13),''),chr(10),'')  -- 专业贷款分类代码
    ,replace(replace(t1.risk_expose_cls,chr(13),''),chr(10),'')  -- 风险暴露分类
    ,replace(replace(t1.qual_centr_cntpty_flg,chr(13),''),chr(10),'')  -- 合格中央交易对手标志
    ,replace(replace(t1.mgmt_mode_cd,chr(13),''),chr(10),'')  -- 管理模式代码
    ,replace(replace(t1.tran_market_type_cd,chr(13),''),chr(10),'')  -- 交易市场类型代码
    ,replace(replace(t1.incre_crdt_way_cd,chr(13),''),chr(10),'')  -- 增信方式代码
    ,replace(replace(t1.bill_uniq_idf,chr(13),''),chr(10),'')  -- 票据唯一标识
    ,replace(replace(t1.is_sup_chain_fin_bus_flg,chr(13),''),chr(10),'')  -- 是否为供应链金融业务标志
    ,replace(replace(t1.sup_chain_fin_bus_prod_cls_cd,chr(13),''),chr(10),'')  -- 供应链金融业务产品分类代码
    ,replace(replace(t1.unify_repay_day,chr(13),''),chr(10),'')  -- 统一还款日
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.agt_loan_cont_info t1    --公司贷款合同信息
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_agt_loan_cont_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);