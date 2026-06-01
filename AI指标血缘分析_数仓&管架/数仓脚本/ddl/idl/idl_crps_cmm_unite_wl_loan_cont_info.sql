/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_loan_cont_info
CreateDate: 20250620
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.crps_cmm_unite_wl_loan_cont_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.crps_cmm_unite_wl_loan_cont_info(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,cont_id varchar2(100) --合同编号
,crdt_appl_flow_num varchar2(100) --授信申请流水号
,cust_id varchar2(100) --客户编号
,cust_name varchar2(500) --客户名称
,std_prod_id varchar2(100) --标准产品编号
,crdt_type_cd varchar2(10) --授信类型代码
,appl_type_cd varchar2(100) --申请类型代码
,curr_cd varchar2(30) --币种代码
,base_rat_type_cd varchar2(30) --基准利率类型代码
,int_rat_adj_way_cd varchar2(30) --利率调整方式代码
,cont_status_cd varchar2(60) --合同状态代码
,apv_status_cd varchar2(100) --审批状态代码
,guar_way_cd varchar2(30) --担保方式代码
,repay_way_cd varchar2(30) --还款方式代码
,loan_usage_type_cd varchar2(30) --贷款用途类型代码
,recvbl_acct_name varchar2(300) --收款账户名称
,recvbl_acct_open_org_id varchar2(100) --收款账户开户机构编号
,exec_int_rat number(18,8) --执行利率
,cont_bal number(30,8) --合同余额
,cont_amt number(30,8) --合同金额
,distr_amt number(30,8) --放款金额
,tenor varchar2(60) --期限
,begin_dt date --起始日期
,exp_dt date --到期日期
,sign_dt date --签订日期
,distr_dt date --放款日期
,termnt_dt date --终止日期
,spec_repay_day date --指定还款日
,operr_id varchar2(100) --经办人编号
,oper_org_id varchar2(100) --经办机构编号
,oper_dt date --经办日期
,rgstrat_id varchar2(100) --登记人编号
,rgst_org_id varchar2(100) --登记机构编号
,rgst_dt date --登记日期
,update_id varchar2(100) --更新人编号
,update_org_id varchar2(100) --更新机构编号
,update_dt date --更新日期
,high_tech_property_flg varchar2(10) --投向高技术产业标志
,digit_econ_core_type_cd varchar2(30) --投向数字经济核心产业类型代码
,lmt_cont_id varchar2(100) --额度合同编号
,dir_indus_cd varchar2(30) --行业投向代码
,lmt_or_encrge_indus_cd varchar2(10) -- 限制或鼓励行业代码
,sup_chain_fin_bus_prod_cls_cd varchar2(10) -- 供应链金融业务产品分类代码
,guar_proj_loan_type_cd varchar2(10) -- 保障性安居工程贷款类型代码
,buid_bus_guar_loan_type_cd varchar2(30) -- 创业担保贷款类型代码
,estate_loan_type_cd varchar2(10) -- 房地产贷款类型代码
,strate_new_indus_type_cd varchar2(30) -- 战略性新兴产业类型代码
,agclt_loan_main_type_cd varchar2(30) -- 涉农贷款主体类型代码
,agclt_loan_dir_cd varchar2(30) -- 涉农贷款投向代码
,loan_fin_supt_way_cd varchar2(60) -- 贷款财政扶持方式代码
,surp_indus_cd varchar2(10) -- 过剩行业代码
,adv_man_indu_flg varchar2(10) -- 先进制造业标志
,green_crdt_fin_flg varchar2(10) -- 绿色信贷融资标志
,cty_lmt_indus_flg varchar2(10) -- 国家限制行业标志
,high_tech_serv_loan_flg varchar2(10) -- 高技术服务业贷款标志
,sci_tech_inovt_corp_flg varchar2(10) -- 科创企业标志
,sci_tech_corp_flg varchar2(10) -- 科技型企业标志
,high_new_tech_corp_flg varchar2(10) -- 高新技术企业标志
,spe_soph_unq_new_med_side_enter_flg varchar2(10) -- 专精特新中小企业标志
,spe_soph_unq_new_lte_gnt_corp_flg varchar2(10) -- 专精特新小巨人企业标志
,provi_for_aged_property_flg varchar2(10) -- 养老产业标志
,indu_corp_tech_rem_ugd_flg varchar2(30) -- 工业转型升级标识
,three_old_tf_or_city_update_proj_flg varchar2(30) -- 三旧改造或城市更新项目标志
,br_build_ifin_flg varchar2(10) -- 一带一路建设投融资标志
,sup_chain_fin_bus_flg varchar2(60) -- 供应链金融业务标志
,buid_bus_guar_loan_flg varchar2(10) -- 创业担保贷款标志
,county_loan_flg varchar2(10) -- 县城区贷款标志
,overs_loan_flg varchar2(10) -- 境外贷款标志
,ppp_proj_flg varchar2(10) -- 投向政府和社会资本合作项目标志
,cul_property_flg varchar2(10) -- 文化产业标志
,new_distr_flg varchar2(10) -- 新机制发放贷款标志
,agclt_flg varchar2(10) -- 涉农标志
,seed_loan_flg varchar2(10) -- 种业振兴贷款标志
,proj_fin_flg varchar2(10) -- 项目融资标志

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_cmm_unite_wl_loan_cont_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_cmm_unite_wl_loan_cont_info is '联合网贷贷款合同信息';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.etl_dt is '数据日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.lp_id is '法人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.cont_id is '合同编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.crdt_appl_flow_num is '授信申请流水号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.cust_id is '客户编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.cust_name is '客户名称';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.crdt_type_cd is '授信类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.appl_type_cd is '申请类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.curr_cd is '币种代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.base_rat_type_cd is '基准利率类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.cont_status_cd is '合同状态代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.apv_status_cd is '审批状态代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.guar_way_cd is '担保方式代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.repay_way_cd is '还款方式代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.loan_usage_type_cd is '贷款用途类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.recvbl_acct_name is '收款账户名称';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.recvbl_acct_open_org_id is '收款账户开户机构编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.exec_int_rat is '执行利率';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.cont_bal is '合同余额';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.cont_amt is '合同金额';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.distr_amt is '放款金额';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.tenor is '期限';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.begin_dt is '起始日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.exp_dt is '到期日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.sign_dt is '签订日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.distr_dt is '放款日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.termnt_dt is '终止日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.spec_repay_day is '指定还款日';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.operr_id is '经办人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.oper_org_id is '经办机构编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.oper_dt is '经办日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.rgstrat_id is '登记人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.rgst_dt is '登记日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.update_id is '更新人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.update_org_id is '更新机构编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.update_dt is '更新日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.high_tech_property_flg is '投向高技术产业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.digit_econ_core_type_cd is '投向数字经济核心产业类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.lmt_cont_id is '额度合同编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.dir_indus_cd is '行业投向代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.lmt_or_encrge_indus_cd is '限制或鼓励行业代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.sup_chain_fin_bus_prod_cls_cd is '供应链金融业务产品分类代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.guar_proj_loan_type_cd is '保障性安居工程贷款类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.buid_bus_guar_loan_type_cd is '创业担保贷款类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.estate_loan_type_cd is '房地产贷款类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.strate_new_indus_type_cd is '战略性新兴产业类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.agclt_loan_main_type_cd is '涉农贷款主体类型代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.agclt_loan_dir_cd is '涉农贷款投向代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.loan_fin_supt_way_cd is '贷款财政扶持方式代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.surp_indus_cd is '过剩行业代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.adv_man_indu_flg is '先进制造业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.cty_lmt_indus_flg is '国家限制行业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.high_tech_serv_loan_flg is '高技术服务业贷款标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.sci_tech_inovt_corp_flg is '科创企业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.sci_tech_corp_flg is '科技型企业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.spe_soph_unq_new_med_side_enter_flg is '专精特新中小企业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.spe_soph_unq_new_lte_gnt_corp_flg is '专精特新小巨人企业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.provi_for_aged_property_flg is '养老产业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.indu_corp_tech_rem_ugd_flg is '工业转型升级标识';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.three_old_tf_or_city_update_proj_flg is '三旧改造或城市更新项目标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.sup_chain_fin_bus_flg is '供应链金融业务标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.buid_bus_guar_loan_flg is '创业担保贷款标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.county_loan_flg is '县城区贷款标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.overs_loan_flg is '境外贷款标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.ppp_proj_flg is '投向政府和社会资本合作项目标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.cul_property_flg is '文化产业标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.new_distr_flg is '新机制发放贷款标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.agclt_flg is '涉农标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.seed_loan_flg is '种业振兴贷款标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_cont_info.proj_fin_flg is '项目融资标志';

