/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_loan_dubil_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_loan_dubil_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_dubil_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_dubil_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cont_id varchar2(60) -- 合同编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,sub_prod_id varchar2(60) -- 子产品编号
	  ,sub_prod_name varchar2(60) -- 子产品名称
    ,out_acct_flow_num varchar2(60) -- 出账流水号
    ,rela_dubil_id varchar2(60) -- 关联借据编号
    ,rela_bus_id varchar2(60) -- 关联业务编号
    ,intnl_trad_fin_rela_id_2 varchar2(100) -- 国际贸易融资业务关联编号2
    ,bill_num varchar2(60) -- 票据号码
    ,bill_id varchar2(60) -- 票据编号
    ,bill_uniq_mark_id varchar2(60) -- 票据唯一标示编号
    ,ibank_asset_uniq_idf_id varchar2(100) -- 同业资产唯一标识编号
    ,cust_id varchar2(60) -- 客户编号
    ,host_cust_id varchar2(60) -- 主机客户编号
    ,distr_acct_num varchar2(60) -- 放款账号
    ,repay_num varchar2(250) -- 还款账号
    ,secd_repay_num varchar2(60) -- 第二还款账号
    ,stl_acct_num varchar2(250) -- 结算帐号
    ,manu_cont_id varchar2(500) -- 人工合同编号
    ,crdt_lmt_agt_id varchar2(60) -- 授信额度协议编号
    ,advc_flg varchar2(10) -- 垫款标志
    ,pre_recv_int_flg varchar2(10) -- 预收息标志
    ,attach_rgst_dubil_flg varchar2(10) -- 补登借据标志
    ,matn_flg varchar2(10) -- 维护标志
    ,wrt_off_flg varchar2(10) -- 核销标志
    ,comp_int_flg varchar2(10) -- 复息标志
    ,stop_accr_int_flg varchar2(10) -- 停息标志
    ,sign_crdt_cont_flg varchar2(10) -- 签署授信合同标志
    ,pric_auto_rtn_flg varchar2(10) -- 本金自动归还标志
    ,int_auto_rtn_flg varchar2(10) -- 利息自动归还标志
    ,crdt_distr_repay_plan_flg varchar2(10) -- 信贷发放还款计划标志
    ,edu_hea_flg varchar2(10) -- 文教健康标志
    ,pbc_inc_loan_flg varchar2(10) -- 人行普惠贷款标志
    ,file_int_accr_flg varchar2(10) -- 靠档计息标志
    ,overs_loan_flg varchar2(10) -- 境外贷款标志
    ,repl_old_bond_flg varchar2(10) -- 置换旧债标志
    ,bus_breed_id varchar2(60) -- 业务品种编号
    ,dubil_status_cd varchar2(60) -- 借据状态代码
    ,refac_loan_status_cd varchar2(10) -- 支小再贷款状态代码
    ,spcl_refac_idf_cd varchar2(30) -- 专项再贷款标识代码
    ,loan_happ_type_cd varchar2(10) -- 贷款发生类型代码
    ,mode_pay_cd varchar2(10) -- 支付方式代码
    ,curr_cd varchar2(10) -- 币种代码
    ,int_accr_way_cd varchar2(10) -- 计息方式代码
    ,loan_type_cd varchar2(10) -- 贷款类型代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,loan_level4_cls_cd varchar2(10) -- 贷款四级分类代码
    ,loan_level5_cls_cd varchar2(10) -- 贷款五级分类代码
    ,loan_level10_cls_cd varchar2(10) -- 贷款十级分类代码
    ,loan_level12_cls_cd varchar2(10) -- 贷款十二级分类代码
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,dir_indus_cd varchar2(10) -- 贷款投向行业代码
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,loan_kind_cd varchar2(10) -- 贷款种类代码
    ,wrtoff_type_cd varchar2(10) -- 注销类型代码
    ,loan_tenor_type_cd varchar2(10) -- 贷款期限类型代码
    ,loan_tenor_seg_cd varchar2(10) -- 贷款期限分段代码
    ,bill_kind_cd varchar2(10) -- 票据种类代码
    ,bill_med_cd varchar2(10) -- 票据介质代码
    ,belong_bus_strip_line_cd varchar2(30) -- 所属业务条线代码
    ,data_src_flg varchar2(10) -- 数据来源标志
    ,regroup_loan_flg varchar2(10) -- 重组贷款标志
    ,agent_present_flg varchar2(10) -- 代理交单标志
    ,prob_asset_flg varchar2(10) -- 问题资产标志
    ,cdd_flg varchar2(10) -- 超短贷标志
    ,regroup_loan_type_cd varchar2(30) -- 重组贷款类型代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整类型代码
    ,int_rat_float_type_cd varchar2(60) -- 利率浮动类型代码
    ,col_int_type_cd varchar2(30) -- 收息类型代码
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq number(10,0) -- 利率调整周期频率
    ,inst_loan_repay_way_cd varchar2(10) -- 分期贷款还款方式代码
    ,money_use_type_cd varchar2(10) -- 款项使用类型代码
    ,crdtc_subm_bus_breed_cd varchar2(10) -- 征信报送业务品种代码
    ,crdtc_subm_bus_breed_descb varchar2(1000) -- 征信报送业务品种描述
    ,loan_use_remark varchar2(1000) -- 贷款使用备注
    ,acct_b_cate_cd varchar2(60) -- 账簿类别代码
    ,dubil_sell_status_cd varchar2(30) -- 借据卖出状态代码
	  ,inpwn_type_cd varchar2(30) -- 质押类型代码
	  ,green_crdt_cust_flg varchar2(10) -- 绿色信贷客户标志
    ,green_crdt_cls_cd varchar2(10) -- 绿色信贷分类_旧版代码
    ,green_crdt_cls_new varchar2(10) -- 绿色信贷分类_新版代码
    ,payoff_type_cd varchar2(60) --结清类型代码
    ,org_id varchar2(60) -- 机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,oper_org_id varchar2(60) -- 经办机构编号
    ,oper_teller_id varchar2(60) -- 经办柜员编号
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,attach_rgst_check_teller_id varchar2(60) -- 补登复核柜员编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,benefc_name varchar2(100) -- 受益人名称
    ,bnft_bk_no varchar2(60) -- 受益行行号
    ,bnft_bk_name varchar2(250) -- 受益行行名
    ,acpt_bank_no varchar2(60) -- 承兑行行号
    ,acpt_bank_name varchar2(250) -- 承兑行名称
    ,lc_open_bank_id varchar2(250) -- 信用证开户行编号
	  ,lc_open_bank_name varchar2(500) -- 信用证开证行名称
    ,margin_acct_num varchar2(60) -- 保证金账号
    ,margin_sub_acct_num varchar2(60) -- 保证金子户号
    ,margin_curr_cd varchar2(10) -- 保证金币种代码
    ,margin_amt number(30,2) -- 保证金金额
    ,margin_ratio number(18,6) -- 保证金比例
    ,refac_loan_batch_pkg_id varchar2(100) -- 支小再贷款批次包编号
    ,refac_loan_batch_exp_dt date -- 支小再贷款批次到期日期
    ,refac_loan_use_int_rat number(18,9) -- 支小再贷款使用利率
    ,dubil_wrtoff_flow_num varchar2(60) -- 借据注销流水号
    ,dubil_open_flow_num varchar2(60) -- 借据开立流水号
    ,dubil_open_dt date -- 借据开立日期
    ,distr_dt date -- 放款日期
    ,apot_exp_dt date -- 约定到期日期
    ,exec_exp_dt date -- 执行到期日期
    ,next_int_set_dt date -- 下次结息日期
    ,loan_cls_dt date -- 贷款分类日期
    ,level5_cls_idtfy_dt date -- 五级分类认定日期
    ,next_term_rpp_dt date -- 下一期还本日期
    ,next_term_repay_int_dt date -- 下一期还息日期
    ,payoff_dt date -- 结清日期
    ,ovdue_dt date -- 逾期日期
    ,over_int_dt date -- 欠息日期
    ,ovdue_days number(10,0) -- 贷款逾期天数
    ,over_int_days number(10,0) -- 欠息天数
    ,loan_ped number(24,6) -- 贷款周期
    ,inst_loan_tot_perds number(10,0) -- 贷款期数
    ,surp_perds number(10,0) -- 剩余期数
    ,acm_debt_perds number(10,0) -- 累计欠款期数
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,comm_fee_fee_rat number(18,8) -- 手续费费率
    ,next_term_rpp_amt number(30,2) -- 下一期还本金额
    ,next_term_repay_int_amt number(30,2) -- 下一期还息金额
    ,repay_num_bal number(30,2) -- 还款账号余额
    ,repay_num_aval_bal number(30,2) -- 还款账号可用余额
    ,eh_issue_deduct_amt number(30,2) -- 每期扣款金额
    ,entr_pay_amt number(30,2) -- 委托支付金额
    ,comp_amt number(30,6) -- 代偿金额
    ,prft_cut_amt number(24,6) -- 分润金额
    ,suit_fee_bal number(30,6) -- 诉讼费余额
	  ,accpt_bil_comm_fee_amt number(30,8) --承兑汇票手续费金额
    ,ovdue_int number(30,2) -- 逾期利息
    ,dubil_amt number(30,2) -- 借据金额
    ,dubil_bal number(30,2) -- 借据余额
    ,nomal_pric number(30,2) -- 正常本金
    ,ovdue_pric number(30,2) -- 逾期本金
    ,idle_pric number(30,2) -- 呆滞本金
    ,bad_debt_pric number(30,2) -- 呆账本金
    ,in_bs_over_int_bal number(30,2) -- 表内欠息余额
    ,off_bs_over_int_bal number(30,2) -- 表外欠息余额
    ,pric_pnlt number(30,2) -- 本金罚息
    ,int_pnlt number(30,2) -- 利息罚息
    ,cap_ratio varchar2(100) -- 资本占有比例
    ,recvbl_acct_name varchar2(250) -- 收款账户名称
    ,recvbl_bank_name varchar2(250) -- 收款银行名称
    ,update_dt date -- 更新日期
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
grant select on ${icl_schema}.cmm_corp_loan_dubil_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_loan_dubil_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_loan_dubil_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_loan_dubil_info is '对公贷款借据信息';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.sub_prod_id is '子产品编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.sub_prod_name is '子产品名称';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.out_acct_flow_num is '出账流水号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.rela_dubil_id is '关联借据编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.rela_bus_id is '关联业务编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.intnl_trad_fin_rela_id_2 is '国际贸易融资业务关联编号2';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bill_num is '票据号码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bill_id is '票据编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bill_uniq_mark_id is '票据唯一标示编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.ibank_asset_uniq_idf_id is '同业资产唯一标识编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.host_cust_id is '主机客户编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.distr_acct_num is '放款账号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.repay_num is '还款账号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.secd_repay_num is '第二还款账号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.stl_acct_num is '结算帐号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.manu_cont_id is '人工合同编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.crdt_lmt_agt_id is '授信额度协议编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.advc_flg is '垫款标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.pre_recv_int_flg is '预收息标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.attach_rgst_dubil_flg is '补登借据标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.matn_flg is '维护标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.wrt_off_flg is '核销标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.comp_int_flg is '复息标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.stop_accr_int_flg is '停息标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.sign_crdt_cont_flg is '签署授信合同标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.pric_auto_rtn_flg is '本金自动归还标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.int_auto_rtn_flg is '利息自动归还标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.crdt_distr_repay_plan_flg is '信贷发放还款计划标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.edu_hea_flg is '文教健康标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.pbc_inc_loan_flg is '人行普惠贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.file_int_accr_flg is '靠档计息标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.overs_loan_flg is '境外贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.repl_old_bond_flg is '置换旧债标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.agent_present_flg is '代理交单标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.prob_asset_flg is '问题资产标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.cdd_flg is '超短贷标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bus_breed_id is '业务品种编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dubil_status_cd is '借据状态代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.refac_loan_status_cd is '支小再贷款状态代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.spcl_refac_idf_cd is '专项再贷款标识代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_happ_type_cd is '贷款发生类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.mode_pay_cd is '支付方式代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.int_accr_way_cd is '计息方式代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_type_cd is '贷款类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_level4_cls_cd is '贷款四级分类代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_level10_cls_cd is '贷款十级分类代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_level12_cls_cd is '贷款十二级分类代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.repay_way_cd is '还款方式代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dir_indus_cd is '贷款投向行业代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_kind_cd is '贷款种类代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.wrtoff_type_cd is '注销类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_tenor_type_cd is '贷款期限类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_tenor_seg_cd is '贷款期限分段代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bill_kind_cd is '票据种类代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bill_med_cd is '票据介质代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.belong_bus_strip_line_cd is '所属业务条线代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.data_src_flg is '数据来源标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.regroup_loan_flg is '重组贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.regroup_loan_type_cd is '重组贷款类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.int_rat_adj_way_cd is '利率调整类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.int_rat_float_type_cd is '利率浮动类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.col_int_type_cd is '收息类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.inst_loan_repay_way_cd is '分期贷款还款方式代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.money_use_type_cd is '款项使用类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.crdtc_subm_bus_breed_cd is '征信报送业务品种代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.crdtc_subm_bus_breed_descb is '征信报送业务品种描述';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_use_remark is '贷款使用备注';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.acct_b_cate_cd is '账簿类别代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dubil_sell_status_cd is '借据卖出状态代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.inpwn_type_cd is '质押类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.green_crdt_cust_flg is '绿色信贷客户标志';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.green_crdt_cls_cd is '绿色信贷分类_旧版代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.green_crdt_cls_new is '绿色信贷分类_新版代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.payoff_type_cd is '结清类型代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.org_id is '机构编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.oper_org_id is '经办机构编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.oper_teller_id is '经办柜员编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.rgst_org_id is '登记机构编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.rgst_teller_id is '登记柜员编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.rgst_dt is '登记日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.attach_rgst_check_teller_id is '补登复核柜员编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.benefc_name is '受益人名称';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bnft_bk_no is '受益行行号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bnft_bk_name is '受益行行名';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.acpt_bank_no is '承兑行行号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.acpt_bank_name is '承兑行名称';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.lc_open_bank_id is '信用证开户行编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.lc_open_bank_name is '信用证开证行名称';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.margin_acct_num is '保证金账号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.margin_sub_acct_num is '保证金子户号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.margin_curr_cd is '保证金币种代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.margin_amt is '保证金金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.margin_ratio is '保证金比例';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.refac_loan_batch_pkg_id is '支小再贷款批次包编号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.refac_loan_batch_exp_dt is '支小再贷款批次到期日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.refac_loan_use_int_rat is '支小再贷款使用利率';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dubil_wrtoff_flow_num is '借据注销流水号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dubil_open_flow_num is '借据开立流水号';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dubil_open_dt is '借据开立日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.distr_dt is '放款日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.apot_exp_dt is '约定到期日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.exec_exp_dt is '执行到期日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.next_int_set_dt is '下次结息日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_cls_dt is '贷款分类日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.level5_cls_idtfy_dt is '五级分类认定日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.next_term_rpp_dt is '下一期还本日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.next_term_repay_int_dt is '下一期还息日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.payoff_dt is '结清日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.ovdue_dt is '逾期日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.over_int_dt is '欠息日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.ovdue_days is '贷款逾期天数';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.over_int_days is '欠息天数';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.loan_ped is '贷款周期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.inst_loan_tot_perds is '贷款期数';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.surp_perds is '剩余期数';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.acm_debt_perds is '累计欠款期数';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.ovdue_int_rat is '逾期利率';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.comm_fee_fee_rat is '手续费费率';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.next_term_rpp_amt is '下一期还本金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.next_term_repay_int_amt is '下一期还息金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.repay_num_bal is '还款账号余额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.repay_num_aval_bal is '还款账号可用余额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.eh_issue_deduct_amt is '每期扣款金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.entr_pay_amt is '委托支付金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.comp_amt is '代偿金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.prft_cut_amt is '分润金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.suit_fee_bal is '诉讼费余额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.accpt_bil_comm_fee_amt is '承兑汇票手续费金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.ovdue_int is '逾期利息';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dubil_amt is '借据金额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.dubil_bal is '借据余额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.nomal_pric is '正常本金';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.ovdue_pric is '逾期本金';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.idle_pric is '呆滞本金';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.bad_debt_pric is '呆账本金';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.in_bs_over_int_bal is '表内欠息余额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.off_bs_over_int_bal is '表外欠息余额';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.pric_pnlt is '本金罚息';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.int_pnlt is '利息罚息';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.cap_ratio is '资本占有比例';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.recvbl_acct_name is '收款账户名称';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.recvbl_bank_name is '收款银行名称';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.update_dt is '更新日期';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_loan_dubil_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_loan_dubil_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_loan_dubil_info.etl_timestamp is 'ETL处理时间戳';
