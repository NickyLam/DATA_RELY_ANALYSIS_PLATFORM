/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_retl_loan_dubil_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_retl_loan_dubil_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_dubil_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_dubil_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cont_id varchar2(60) -- 合同编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,sub_prod_id varchar2(60) -- 子产品编号
	,sub_prod_name varchar2(60) -- 子产品名称
    ,out_acct_flow_num varchar2(60) -- 出账流水号
    ,bus_breed_id varchar2(60) -- 业务品种编号
    ,bus_breed_name varchar2(500) -- 业务品种名称
    ,crdtc_subm_bus_breed_cd varchar2(10) -- 征信报送业务品种代码
    ,crdtc_subm_bus_breed_descb varchar2(1000) -- 征信报送业务品种描述
    ,cust_id varchar2(60) -- 客户编号
    ,repay_num varchar2(250) -- 还款账号
    ,enter_acct_num varchar2(60) -- 入账账号
    ,mortg_flg varchar2(10) -- 按揭标志
    ,npl_flg varchar2(10) -- 不良贷款标志
    ,deflt_flg varchar2(10) -- 违约标志
    ,crdt_lmt_use_flg varchar2(10) -- 授信额度使用标志
    ,gro_lend_flg varchar2(10) -- 联保贷款标志
    ,blon_loan_flg varchar2(10) -- 气球贷标志
    ,level10_cls_manu_med_flg varchar2(10) -- 十级分类人工干预标志
    ,insure_comp_flg varchar2(10) -- 保险代偿标志
    ,pbc_inc_loan_flg varchar2(10) -- 人行普惠贷款标志
    ,white_list_cust_flg varchar2(10) -- 白户标志
    ,farm_flg varchar2(10) -- 农户标志
    ,wrt_off_flg varchar2(10) -- 核销标志
    ,prob_asset_flg varchar2(10) -- 问题资产标志
    ,provi_for_aged_property_flg varchar2(10) -- 养老产业标志
    ,due_diligence_flg varchar2(10) --尽调标志
	  ,outline_vrif_idti_flg varchar2(10) --线下核身标志
    ,regroup_loan_flg varchar2(10) -- 重组贷款标志
    ,regroup_loan_type_cd varchar2(30) -- 重组贷款类型代码
    ,prod_type_cd varchar2(10) -- 产品类型代码
    ,loan_happ_type_cd varchar2(30) -- 贷款发生类型代码
    ,loan_type_cd varchar2(10) -- 贷款类型代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,sub_guar_way_cd varchar2(10) -- 子担保方式代码
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,dir_indus_cd varchar2(10) -- 贷款投向行业代码
    ,dubil_status_cd varchar2(60) -- 借据状态代码
    ,refac_loan_status_cd varchar2(10) -- 支小再贷款状态代码
    ,spcl_refac_idf_cd varchar2(30) -- 专项再贷款标识代码
    ,comp_int_calc_way_cd varchar2(30) -- 复利计算方式代码
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq number(10,0) -- 利率调整周期频率
    ,loan_level4_cls_cd varchar2(10) -- 贷款四级分类代码
    ,loan_level5_cls_cd varchar2(10) -- 贷款五级分类代码
    ,loan_level10_cls_cd varchar2(10) -- 贷款十级分类代码
    ,loan_level12_cls_cd varchar2(10) -- 贷款十二级分类代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_float_type_cd varchar2(60) -- 利率浮动类型代码
    ,ovdue_int_rat_adj_way varchar2(10) -- 逾期利率调整方式
    ,int_rat_adj_effect_way varchar2(10) -- 利率调整生效方式
    ,int_rat_float_tenor_cd varchar2(10) -- 利率浮动期限代码
    ,enter_acct_pt_type_cd varchar2(10) -- 入账账户支付工具类型代码
    ,repay_acct_pt_type_cd varchar2(10) -- 还款账户支付工具类型代码
    ,deduct_way_cd varchar2(10) -- 扣款方式代码
    ,mode_pay_cd varchar2(10) -- 支付方式代码
    ,curr_cd varchar2(10) -- 币种代码
    ,cust_char_cd varchar2(10) -- 客户性质代码
    ,cust_crdt_tot number(30,6) -- 授信总额度
    ,loan_type_descb varchar2(500) -- 贷款类型描述
    ,enter_acct_name varchar2(200) -- 入账账户名称
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,trust_cust_mgr varchar2(60) -- 托管客户经理
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,dubil_open_dt date -- 借据开立日期
    ,dubil_exp_dt date -- 借据到期日期
    ,fir_distr_dt date -- 首次放款日期
    ,recnt_repay_dt date -- 最近还款日期
    ,repay_day varchar2(10) -- 还款日
    ,payoff_dt date -- 结清日期
    ,exec_exp_dt date -- 执行到期日期
    ,pric_ovdue_dt date -- 本金逾期日期
    ,int_ovdue_dt date -- 利息逾期日期
    ,loan_level5_cls_dt date -- 贷款五级分类日期
    ,loan_level10_cls_dt date -- 贷款十级分类日期
    ,last_level5_cls_modif_dt date -- 上次五级分类变更日期
    ,last_risk_rgst_adj_rs varchar2(750) -- 上次风险登记调整原因
    ,risk_rgst_apver_id varchar2(60) -- 风险登记审批人编号
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,ovdue_int_rat_flo_val number(18,6) -- 逾期利率浮动值
    ,int_rat_flo_val number(18,6) -- 利率浮动值
    ,pric_ovdue_days number(10,0) -- 本金逾期天数
    ,int_ovdue_days number(10,0) -- 利息逾期天数
    ,grace_days number(10,0) -- 宽限天数
    ,grace_period_start_dt date -- 宽限期开始日期
    ,grace_period_exp_dt date -- 宽限期到期日期
    ,final_ped_resv_amt number(30,2) -- 最后一期保留金额
    ,suit_fee_bal number(30,6) -- 诉讼费余额
    ,dubil_amt number(30,2) -- 借据金额
    ,dubil_bal number(30,2) -- 借据余额
    ,ovdue_bal number(30,2) -- 逾期余额
    ,comp_amt number(30,8) -- 代偿金额
    ,prft_cut_amt number(24,6) -- 分润金额
    ,refac_loan_batch_pkg_id varchar2(100) -- 支小再贷款批次包编号
    ,refac_loan_batch_exp_dt date -- 支小再贷款批次到期日期
    ,refac_loan_use_int_rat number(18,9) -- 支小再贷款使用利率
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_retl_loan_dubil_info to ${idl_schema};
grant select on ${icl_schema}.cmm_retl_loan_dubil_info to ${iel_schema};
grant select on ${icl_schema}.cmm_retl_loan_dubil_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_retl_loan_dubil_info is '零售贷款借据信息';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.sub_prod_id is '子产品编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.sub_prod_name is '子产品名称';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.out_acct_flow_num is '出账流水号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.bus_breed_id is '业务品种编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.bus_breed_name is '业务品种名称';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.crdtc_subm_bus_breed_cd is '征信报送业务品种代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.crdtc_subm_bus_breed_descb is '征信报送业务品种描述';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.repay_num is '还款账号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.enter_acct_num is '入账账号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.mortg_flg is '按揭标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.npl_flg is '不良贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.deflt_flg is '违约标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.crdt_lmt_use_flg is '授信额度使用标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.gro_lend_flg is '联保贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.blon_loan_flg is '气球贷标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.level10_cls_manu_med_flg is '十级分类人工干预标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.insure_comp_flg is '保险代偿标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.pbc_inc_loan_flg is '人行普惠贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.white_list_cust_flg is '白户标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.farm_flg is '农户标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.wrt_off_flg is '核销标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.provi_for_aged_property_flg is '养老产业标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.due_diligence_flg is '尽调标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.outline_vrif_idti_flg is '线下核身标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.prob_asset_flg is '问题资产标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.regroup_loan_flg is '重组贷款标志';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.regroup_loan_type_cd is '重组贷款类型代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.prod_type_cd is '产品类型代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_happ_type_cd is '贷款发生类型代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_type_cd is '贷款类型代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.sub_guar_way_cd is '子担保方式代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.repay_way_cd is '还款方式代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.dir_indus_cd is '贷款投向行业代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.dubil_status_cd is '借据状态代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.refac_loan_status_cd is '支小再贷款状态代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.spcl_refac_idf_cd is '专项再贷款标识代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.comp_int_calc_way_cd is '复利计算方式代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_level4_cls_cd is '贷款四级分类代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_level10_cls_cd is '贷款十级分类代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_level12_cls_cd is '贷款十二级分类代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_rat_float_type_cd is '利率浮动类型代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.ovdue_int_rat_adj_way is '逾期利率调整方式';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_rat_adj_effect_way is '利率调整生效方式';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_rat_float_tenor_cd is '利率浮动期限代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.enter_acct_pt_type_cd is '入账账户支付工具类型代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.repay_acct_pt_type_cd is '还款账户支付工具类型代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.deduct_way_cd is '扣款方式代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.mode_pay_cd is '支付方式代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.cust_char_cd is '客户性质代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.cust_crdt_tot is '授信总额度';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_type_descb is '贷款类型描述';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.enter_acct_name is '入账账户名称';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.trust_cust_mgr is '托管客户经理';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.rgst_teller_id is '登记柜员编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.rgst_org_id is '登记机构编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.dubil_open_dt is '借据开立日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.dubil_exp_dt is '借据到期日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.fir_distr_dt is '首次放款日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.recnt_repay_dt is '最近还款日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.repay_day is '还款日';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.payoff_dt is '结清日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.exec_exp_dt is '执行到期日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.pric_ovdue_dt is '本金逾期日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_ovdue_dt is '利息逾期日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_level5_cls_dt is '贷款五级分类日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.loan_level10_cls_dt is '贷款十级分类日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.last_level5_cls_modif_dt is '上次五级分类变更日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.last_risk_rgst_adj_rs is '上次风险登记调整原因';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.risk_rgst_apver_id is '风险登记审批人编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.ovdue_int_rat is '逾期利率';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_rat_flo_val is '利率浮动值';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.pric_ovdue_days is '本金逾期天数';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.int_ovdue_days is '利息逾期天数';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.grace_days is '宽限天数';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.grace_period_start_dt is '宽限期开始日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.grace_period_exp_dt is '宽限期到期日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.final_ped_resv_amt is '最后一期保留金额';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.suit_fee_bal is '诉讼费余额';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.dubil_amt is '借据金额';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.dubil_bal is '借据余额';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.ovdue_bal is '逾期余额';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.comp_amt is '代偿金额';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.prft_cut_amt is '分润金额';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.refac_loan_batch_pkg_id is '支小再贷款批次包编号';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.refac_loan_batch_exp_dt is '支小再贷款批次到期日期';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.refac_loan_use_int_rat is '支小再贷款使用利率';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_retl_loan_dubil_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_retl_loan_dubil_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_retl_loan_dubil_info.etl_timestamp is 'ETL处理时间戳';
