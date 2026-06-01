/*
Purpose:    应用集市层-抽数脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_corp_loan_dubil_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_corp_loan_dubil_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_corp_loan_dubil_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_corp_loan_dubil_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,dubil_id  -- 借据编号
    ,cont_id  -- 合同编号
    ,std_prod_id  -- 标准产品编号
    ,out_acct_flow_num  -- 出账流水号
    ,rela_dubil_id  -- 关联借据编号
    ,bill_num  -- 票据号码
    ,cust_id  -- 客户编号
    ,host_cust_id  -- 主机客户编号
    ,distr_acct_num  -- 放款账号
    ,repay_num  -- 还款账号
    ,secd_repay_num  -- 第二还款账号
    ,stl_acct_num  -- 结算帐号
    ,manu_cont_id  -- 人工合同编号
    ,crdt_lmt_agt_id  -- 授信额度协议编号
    ,advc_flg  -- 垫款标志
    ,pre_recv_int_flg  -- 预收息标志
    ,attach_rgst_dubil_flg  -- 补登借据标志
    ,matn_flg  -- 维护标志
    ,wrt_off_flg  -- 核销标志
    ,comp_int_flg  -- 复息标志
    ,stop_accr_int_flg  -- 停息标志
    ,sign_crdt_cont_flg  -- 签署授信合同标志
    ,pric_auto_rtn_flg  -- 本金自动归还标志
    ,int_auto_rtn_flg  -- 利息自动归还标志
    ,crdt_distr_repay_plan_flg  -- 信贷发放还款计划标志
    ,bus_breed_id  -- 业务品种编号
    ,dubil_status_cd  -- 借据状态代码
    ,loan_happ_type_cd  -- 贷款发生类型代码
    ,mode_pay_cd  -- 支付方式代码
    ,curr_cd  -- 币种代码
    ,int_accr_way_cd  -- 计息方式代码
    ,loan_type_cd  -- 贷款类型代码
    ,loan_level4_cls_cd  -- 贷款四级分类代码
    ,loan_level5_cls_cd  -- 贷款五级分类代码
    ,loan_level10_cls_cd  -- 贷款十级分类代码
    ,loan_level12_cls_cd  -- 贷款十二级分类代码
    ,repay_way_cd  -- 还款方式代码
    ,dir_indus_cd  -- 投向行业代码
    ,guar_way_cd  -- 担保方式代码
    ,loan_kind_cd  -- 贷款种类代码
    ,wrtoff_type_cd  -- 注销类型代码
    ,loan_tenor_type_cd  -- 贷款期限类型代码
    ,loan_tenor_seg_cd  -- 贷款期限分段代码
    ,bill_kind_cd  -- 票据种类代码
    ,bill_med_cd  -- 票据介质代码
    ,belong_bus_strip_line_cd  -- 所属业务条线代码
    ,data_src_flg  -- 数据来源标志
    ,int_rat_adj_way_cd  -- 利率调整类型代码
    ,col_int_type_cd  -- 收息类型代码
    ,int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq  -- 利率调整周期频率
    ,inst_loan_repay_way_cd  -- 分期贷款还款方式代码
    ,money_use_type_cd  -- 款项使用类型代码
    ,org_id  -- 机构编号
    ,oper_org_id  -- 经办机构编号
    ,oper_teller_id  -- 经办柜员编号
    ,rgst_org_id  -- 登记机构编号
    ,rgst_teller_id  -- 登记柜员编号
    ,attach_rgst_check_teller_id  -- 补登复核柜员编号
    ,benefc_name  -- 受益人名称
    ,bnft_bk_no  -- 受益行行号
    ,bnft_bk_name  -- 受益行行名
    ,acpt_bank_no  -- 承兑行行号
    ,acpt_bank_name  -- 承兑行名称
    ,margin_acct_num  -- 保证金账号
    ,margin_curr_cd  -- 保证金币种代码
    ,margin_amt  -- 保证金金额
    ,margin_ratio  -- 保证金比例
    ,dubil_wrtoff_flow_num  -- 借据注销流水号
    ,dubil_open_flow_num  -- 借据开立流水号
    ,dubil_open_dt  -- 借据开立日期
    ,distr_dt  -- 放款日期
    ,apot_exp_dt  -- 约定到期日期
    ,exec_exp_dt  -- 执行到期日期
    ,next_int_set_dt  -- 下次结息日期
    ,loan_cls_dt  -- 贷款分类日期
    ,next_term_rpp_dt  -- 下一期还本日期
    ,next_term_repay_int_dt  -- 下一期还息日期
    ,payoff_dt  -- 结清日期
    ,ovdue_dt  -- 逾期日期
    ,over_int_dt  -- 欠息日期
    ,ovdue_days  -- 逾期天数
    ,over_int_days  -- 欠息天数
    ,loan_ped  -- 贷款周期
    ,inst_loan_tot_perds  -- 分期贷款总期数
    ,surp_perds  -- 剩余期数
    ,acm_debt_perds  -- 累计欠款期数
    ,exec_int_rat  -- 执行利率
    ,ovdue_int_rat  -- 逾期利率
    ,comm_fee_fee_rat  -- 手续费费率
    ,next_term_rpp_amt  -- 下一期还本金额
    ,next_term_repay_int_amt  -- 下一期还息金额
    ,repay_num_bal  -- 还款账号余额
    ,repay_num_aval_bal  -- 还款账号可用余额
    ,eh_issue_deduct_amt  -- 每期扣款金额
    ,ovdue_int  -- 逾期利息
    ,dubil_amt  -- 借据金额
    ,dubil_bal  -- 借据余额
    ,nomal_pric  -- 正常本金
    ,ovdue_pric  -- 逾期本金
    ,idle_pric  -- 呆滞本金
    ,bad_debt_pric  -- 呆账本金
    ,in_bs_over_int_bal  -- 表内欠息余额
    ,off_bs_over_int_bal  -- 表外欠息余额
    ,pric_pnlt  -- 本金罚息
    ,int_pnlt  -- 利息罚息
    ,cap_ratio  -- 资本占有比例
    ,intnl_trad_fin_rela_id_2  -- 国际贸易融资业务关联编号2
    ,asset_thd_cls_cd  -- 资产三分类代码
    ,pbc_inc_loan_flg  -- 人行普惠贷款标志
    ,refac_loan_status_cd  -- 支小再贷款状态代码
    ,crdtc_subm_bus_breed_cd  -- 征信报送业务品种代码
    ,crdtc_subm_bus_breed_descb  -- 征信报送业务品种描述
    ,base_rat  -- 基准利率
    ,edu_hea_flg  -- 文教健康标志
    ,file_int_accr_flg  -- 靠档计息标志
    ,refac_loan_batch_pkg_id  -- 支小再贷款批次包编号
    ,refac_loan_batch_exp_dt  -- 支小再贷款批次到期日期
    ,refac_loan_use_int_rat  -- 支小再贷款使用利率
    ,level5_cls_idtfy_dt  -- 五级分类认定日期
    ,entr_pay_amt  -- 委托支付金额
    ,bill_id  -- 票据编号
    ,bill_uniq_mark_id  -- 票据唯一标示编号
    ,overs_loan_flg  -- 境外贷款标志
    ,margin_sub_acct_num  -- 保证金子户号
    ,recvbl_acct_name  -- 收款账户名称
    ,recvbl_bank_name  -- 收款银行名称
    ,acct_instit_id  -- 账务机构编号
    ,comp_amt  -- 代偿金额
    ,ibank_asset_uniq_idf_id  -- 同业资产唯一标识编号
    ,rela_bus_id  -- 关联业务编号
    ,regroup_loan_flg  -- 重组贷款标志
	,regroup_loan_type_cd  -- 重组贷款类型代码
	,int_rat_float_type_cd  -- 利率浮动类型代码
	,acct_b_cate_cd  -- 账簿类别代码
	,dubil_sell_status_cd  -- 借据卖出状态代码
	,tran_org_id  -- 交易机构编号
	,lc_open_bank_id  -- 信用证开户行编号
	,repl_old_bond_flg -- 置换旧债标志
	,rgst_dt -- 登记日期 	
	,update_dt -- 更新日期
	,agent_present_flg  --代理交单标志
	,prob_asset_flg  --问题资产标志
	,cdd_flg  --超短贷标志
    ,sub_prod_id  --子产品编号
,inpwn_type_cd  --质押类型代码
,green_crdt_cls_new  --绿色信贷分类_新版代码
,suit_fee_bal  --诉讼费余额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id  -- 借据编号
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id  -- 合同编号
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id  -- 标准产品编号
    ,replace(replace(t.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num  -- 出账流水号
    ,replace(replace(t.rela_dubil_id,chr(13),''),chr(10),'') as rela_dubil_id  -- 关联借据编号
    ,replace(replace(t.bill_num,chr(13),''),chr(10),'') as bill_num  -- 票据号码
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.host_cust_id,chr(13),''),chr(10),'') as host_cust_id  -- 主机客户编号
    ,replace(replace(t.distr_acct_num,chr(13),''),chr(10),'') as distr_acct_num  -- 放款账号
    ,replace(replace(t.repay_num,chr(13),''),chr(10),'') as repay_num  -- 还款账号
    ,replace(replace(t.secd_repay_num,chr(13),''),chr(10),'') as secd_repay_num  -- 第二还款账号
    ,replace(replace(t.stl_acct_num,chr(13),''),chr(10),'') as stl_acct_num  -- 结算帐号
    ,replace(replace(t.manu_cont_id,chr(13),''),chr(10),'') as manu_cont_id  -- 人工合同编号
    ,replace(replace(t.crdt_lmt_agt_id,chr(13),''),chr(10),'') as crdt_lmt_agt_id  -- 授信额度协议编号
    ,replace(replace(t.advc_flg,chr(13),''),chr(10),'') as advc_flg  -- 垫款标志
    ,replace(replace(t.pre_recv_int_flg,chr(13),''),chr(10),'') as pre_recv_int_flg  -- 预收息标志
    ,replace(replace(t.attach_rgst_dubil_flg,chr(13),''),chr(10),'') as attach_rgst_dubil_flg  -- 补登借据标志
    ,replace(replace(t.matn_flg,chr(13),''),chr(10),'') as matn_flg  -- 维护标志
    ,replace(replace(t.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg  -- 核销标志
    ,replace(replace(t.comp_int_flg,chr(13),''),chr(10),'') as comp_int_flg  -- 复息标志
    ,replace(replace(t.stop_accr_int_flg,chr(13),''),chr(10),'') as stop_accr_int_flg  -- 停息标志
    ,replace(replace(t.sign_crdt_cont_flg,chr(13),''),chr(10),'') as sign_crdt_cont_flg  -- 签署授信合同标志
    ,replace(replace(t.pric_auto_rtn_flg,chr(13),''),chr(10),'') as pric_auto_rtn_flg  -- 本金自动归还标志
    ,replace(replace(t.int_auto_rtn_flg,chr(13),''),chr(10),'') as int_auto_rtn_flg  -- 利息自动归还标志
    ,replace(replace(t.crdt_distr_repay_plan_flg,chr(13),''),chr(10),'') as crdt_distr_repay_plan_flg  -- 信贷发放还款计划标志
    ,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id  -- 业务品种编号
    ,replace(replace(t.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd  -- 借据状态代码
    ,replace(replace(t.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd  -- 贷款发生类型代码
    ,replace(replace(t.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd  -- 支付方式代码
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,replace(replace(t.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd  -- 计息方式代码
    ,replace(replace(t.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd  -- 贷款类型代码
    ,replace(replace(t.loan_level4_cls_cd,chr(13),''),chr(10),'') as loan_level4_cls_cd  -- 贷款四级分类代码
    ,replace(replace(t.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd  -- 贷款五级分类代码
    ,replace(replace(t.loan_level10_cls_cd,chr(13),''),chr(10),'') as loan_level10_cls_cd  -- 贷款十级分类代码
    ,replace(replace(t.loan_level12_cls_cd,chr(13),''),chr(10),'') as loan_level12_cls_cd  -- 贷款十二级分类代码
    ,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd  -- 还款方式代码
    ,replace(replace(t.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd  -- 投向行业代码
    ,replace(replace(t.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd  -- 担保方式代码
    ,replace(replace(t.loan_kind_cd,chr(13),''),chr(10),'') as loan_kind_cd  -- 贷款种类代码
    ,replace(replace(t.wrtoff_type_cd,chr(13),''),chr(10),'') as wrtoff_type_cd  -- 注销类型代码
    ,replace(replace(t.loan_tenor_type_cd,chr(13),''),chr(10),'') as loan_tenor_type_cd  -- 贷款期限类型代码
    ,replace(replace(t.loan_tenor_seg_cd,chr(13),''),chr(10),'') as loan_tenor_seg_cd  -- 贷款期限分段代码
    ,replace(replace(t.bill_kind_cd,chr(13),''),chr(10),'') as bill_kind_cd  -- 票据种类代码
    ,replace(replace(t.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd  -- 票据介质代码
    ,replace(replace(t.belong_bus_strip_line_cd,chr(13),''),chr(10),'') as belong_bus_strip_line_cd  -- 所属业务条线代码
    ,replace(replace(t.data_src_flg,chr(13),''),chr(10),'') as data_src_flg  -- 数据来源标志
    ,replace(replace(t.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd  -- 利率调整类型代码
    ,replace(replace(t.col_int_type_cd,chr(13),''),chr(10),'') as col_int_type_cd  -- 收息类型代码
    ,replace(replace(t.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,t.int_rat_adj_ped_freq as int_rat_adj_ped_freq  -- 利率调整周期频率
    ,replace(replace(t.inst_loan_repay_way_cd,chr(13),''),chr(10),'') as inst_loan_repay_way_cd  -- 分期贷款还款方式代码
    ,replace(replace(t.money_use_type_cd,chr(13),''),chr(10),'') as money_use_type_cd  -- 款项使用类型代码
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id  -- 机构编号
    ,replace(replace(t.oper_org_id,chr(13),''),chr(10),'') as oper_org_id  -- 经办机构编号
    ,replace(replace(t.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id  -- 经办柜员编号
    ,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id  -- 登记机构编号
    ,replace(replace(t.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id  -- 登记柜员编号
    ,replace(replace(t.attach_rgst_check_teller_id,chr(13),''),chr(10),'') as attach_rgst_check_teller_id  -- 补登复核柜员编号
    ,replace(replace(t.benefc_name,chr(13),''),chr(10),'') as benefc_name  -- 受益人名称
    ,replace(replace(t.bnft_bk_no,chr(13),''),chr(10),'') as bnft_bk_no  -- 受益行行号
    ,replace(replace(t.bnft_bk_name,chr(13),''),chr(10),'') as bnft_bk_name  -- 受益行行名
    ,replace(replace(t.acpt_bank_no,chr(13),''),chr(10),'') as acpt_bank_no  -- 承兑行行号
    ,replace(replace(t.acpt_bank_name,chr(13),''),chr(10),'') as acpt_bank_name  -- 承兑行名称
    ,replace(replace(t.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num  -- 保证金账号
    ,replace(replace(t.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd  -- 保证金币种代码
    ,t.margin_amt as margin_amt  -- 保证金金额
    ,t.margin_ratio as margin_ratio  -- 保证金比例
    ,replace(replace(t.dubil_wrtoff_flow_num,chr(13),''),chr(10),'') as dubil_wrtoff_flow_num  -- 借据注销流水号
    ,replace(replace(t.dubil_open_flow_num,chr(13),''),chr(10),'') as dubil_open_flow_num  -- 借据开立流水号
    ,t.dubil_open_dt as dubil_open_dt  -- 借据开立日期
    ,t.distr_dt as distr_dt  -- 放款日期
    ,t.apot_exp_dt as apot_exp_dt  -- 约定到期日期
    ,t.exec_exp_dt as exec_exp_dt  -- 执行到期日期
    ,t.next_int_set_dt as next_int_set_dt  -- 下次结息日期
    ,t.loan_cls_dt as loan_cls_dt  -- 贷款分类日期
    ,t.next_term_rpp_dt as next_term_rpp_dt  -- 下一期还本日期
    ,t.next_term_repay_int_dt as next_term_repay_int_dt  -- 下一期还息日期
    ,t.payoff_dt as payoff_dt  -- 结清日期
    ,t.ovdue_dt as ovdue_dt  -- 逾期日期
    ,t.over_int_dt as over_int_dt  -- 欠息日期
    ,t.ovdue_days as ovdue_days  -- 逾期天数
    ,t.over_int_days as over_int_days  -- 欠息天数
    ,t.loan_ped as loan_ped  -- 贷款周期
    ,t.inst_loan_tot_perds as inst_loan_tot_perds  -- 分期贷款总期数
    ,t.surp_perds as surp_perds  -- 剩余期数
    ,t.acm_debt_perds as acm_debt_perds  -- 累计欠款期数
    ,t.exec_int_rat as exec_int_rat  -- 执行利率
    ,t.ovdue_int_rat as ovdue_int_rat  -- 逾期利率
    ,t.comm_fee_fee_rat as comm_fee_fee_rat  -- 手续费费率
    ,t.next_term_rpp_amt as next_term_rpp_amt  -- 下一期还本金额
    ,t.next_term_repay_int_amt as next_term_repay_int_amt  -- 下一期还息金额
    ,t.repay_num_bal as repay_num_bal  -- 还款账号余额
    ,t.repay_num_aval_bal as repay_num_aval_bal  -- 还款账号可用余额
    ,t.eh_issue_deduct_amt as eh_issue_deduct_amt  -- 每期扣款金额
    ,t.ovdue_int as ovdue_int  -- 逾期利息
    ,t.dubil_amt as dubil_amt  -- 借据金额
    ,t.dubil_bal as dubil_bal  -- 借据余额
    ,t.nomal_pric as nomal_pric  -- 正常本金
    ,t.ovdue_pric as ovdue_pric  -- 逾期本金
    ,t.idle_pric as idle_pric  -- 呆滞本金
    ,t.bad_debt_pric as bad_debt_pric  -- 呆账本金
    ,t.in_bs_over_int_bal as in_bs_over_int_bal  -- 表内欠息余额
    ,t.off_bs_over_int_bal as off_bs_over_int_bal  -- 表外欠息余额
    ,t.pric_pnlt as pric_pnlt  -- 本金罚息
    ,t.int_pnlt as int_pnlt  -- 利息罚息
    ,replace(replace(t.cap_ratio,chr(13),''),chr(10),'') as cap_ratio  -- 资本占有比例
    ,replace(replace(t.intnl_trad_fin_rela_id_2,chr(13),''),chr(10),'') as intnl_trad_fin_rela_id_2  -- 国际贸易融资业务关联编号2
    ,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd  -- 资产三分类代码
    ,replace(replace(t.pbc_inc_loan_flg,chr(13),''),chr(10),'') as pbc_inc_loan_flg  -- 人行普惠贷款标志
    ,replace(replace(t.refac_loan_status_cd,chr(13),''),chr(10),'') as refac_loan_status_cd  -- 支小再贷款状态代码
    ,replace(replace(t.crdtc_subm_bus_breed_cd,chr(13),''),chr(10),'') as crdtc_subm_bus_breed_cd  -- 征信报送业务品种代码
    ,replace(replace(t.crdtc_subm_bus_breed_descb,chr(13),''),chr(10),'') as crdtc_subm_bus_breed_descb  -- 征信报送业务品种描述
    ,t.base_rat as base_rat  -- 基准利率
    ,replace(replace(t.edu_hea_flg,chr(13),''),chr(10),'') as edu_hea_flg  -- 文教健康标志
    ,replace(replace(t.file_int_accr_flg,chr(13),''),chr(10),'') as file_int_accr_flg  -- 靠档计息标志
    ,replace(replace(t.refac_loan_batch_pkg_id,chr(13),''),chr(10),'') as refac_loan_batch_pkg_id  -- 支小再贷款批次包编号
    ,t.refac_loan_batch_exp_dt as refac_loan_batch_exp_dt  -- 支小再贷款批次到期日期
    ,t.refac_loan_use_int_rat as refac_loan_use_int_rat  -- 支小再贷款使用利率
    ,t.level5_cls_idtfy_dt as level5_cls_idtfy_dt  -- 五级分类认定日期
    ,t.entr_pay_amt as entr_pay_amt  -- 委托支付金额
    ,replace(replace(t.bill_id,chr(13),''),chr(10),'') as bill_id  -- 票据编号
    ,replace(replace(t.bill_uniq_mark_id,chr(13),''),chr(10),'') as bill_uniq_mark_id  -- 票据唯一标示编号
    ,replace(replace(t.overs_loan_flg,chr(13),''),chr(10),'') as overs_loan_flg  -- 境外贷款标志
    ,replace(replace(t.margin_sub_acct_num,chr(13),''),chr(10),'') as margin_sub_acct_num  -- 保证金子户号
    ,replace(replace(t.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name  -- 收款账户名称
    ,replace(replace(t.recvbl_bank_name,chr(13),''),chr(10),'') as recvbl_bank_name  -- 收款银行名称
    ,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id  -- 账务机构编号
    ,t.comp_amt as comp_amt -- 代偿金额
    ,replace(replace(t.ibank_asset_uniq_idf_id,chr(13),''),chr(10),'') as ibank_asset_uniq_idf_id  -- 账务机构编号
    ,replace(replace(t.rela_bus_id,chr(13),''),chr(10),'') as rela_bus_id  -- 关联业务编号
    ,replace(replace(t.regroup_loan_flg,chr(13),''),chr(10),'') as regroup_loan_flg  -- 重组贷款标志
	,replace(replace(t.regroup_loan_type_cd,chr(13),''),chr(10),'') as regroup_loan_type_cd  -- 重组贷款类型代码
	,replace(replace(t.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd  -- 利率浮动类型代码
	,replace(replace(t.acct_b_cate_cd,chr(13),''),chr(10),'') as acct_b_cate_cd  -- 账簿类别代码
	,replace(replace(t.dubil_sell_status_cd,chr(13),''),chr(10),'') as dubil_sell_status_cd  -- 借据卖出状态代码
	,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id  -- 交易机构编号
	,replace(replace(t.lc_open_bank_id,chr(13),''),chr(10),'') as lc_open_bank_id  -- 信用证开户行编号
	,replace(replace(t.repl_old_bond_flg,chr(13),''),chr(10),'') as repl_old_bond_flg -- 置换旧债标志
	,t.rgst_dt as rgst_dt -- 登记日期 	
	,t.update_dt as update_dt -- 更新日期
	,replace(replace(t.agent_present_flg,chr(13),''),chr(10),'') as agent_present_flg -- 代理交单标志
	,replace(replace(t.prob_asset_flg,chr(13),''),chr(10),'') as prob_asset_flg -- 问题资产标志
	,replace(replace(t.cdd_flg,chr(13),''),chr(10),'') as cdd_flg -- 超短贷标志
,replace(replace(t.sub_prod_id,chr(13),''),chr(10),'') as sub_prod_id --子产品编号
,replace(replace(t.inpwn_type_cd,chr(13),''),chr(10),'') as inpwn_type_cd --质押类型代码
,replace(replace(t.green_crdt_cls_new,chr(13),''),chr(10),'') as green_crdt_cls_new --绿色信贷分类_新版代码
,t.suit_fee_bal as suit_fee_bal --诉讼费余额
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_corp_loan_dubil_info t--对公贷款借据信息
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.cmm_corp_loan_dubil_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_corp_loan_dubil_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);