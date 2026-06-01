/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_src_dw_agt_loan_ctr_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info(
    loan_contr_id varchar2(60) -- 贷款合同编号
    ,etl_dt_ora date -- 数据日期
    ,blng_pty_id varchar2(60) -- 所属客户编号
    ,prd_id varchar2(60) -- 产品编号
    ,ctr_txt_name varchar2(100) -- 合同文本名称
    ,ccy_cd varchar2(3) -- 币种代码
    ,ctr_amt number(18,2) -- 合同金额
    ,ctr_sign_dt date -- 合同签署日期
    ,ctr_eff_dt date -- 合同生效日期
    ,ctr_expire_dt date -- 合同失效日期
    ,contr_due_dt date -- 合同到期日期
    ,blng_org_id varchar2(30) -- 所属机构编号
    ,mgmt_org_id varchar2(30) -- 管理机构编号
    ,pty_mgr_id varchar2(30) -- 客户经理编号
    ,agt_status_cd varchar2(4) -- 贷款合同状态代码
    ,loan_dir_indu_cd varchar2(5) -- 贷款投向行业代码
    ,loan_dir_zone_cd varchar2(6) -- 贷款投向地区代码
    ,loan_dir_cty_cd varchar2(3) -- 贷款投向国家代码
    ,loan_funds_src_cd varchar2(1) -- 贷款资金来源代码
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,loan_usage_desc varchar2(200) -- 贷款用途描述
    ,occur_typ_cd varchar2(10) -- 发生类型代码
    ,loan_prop_cd varchar2(1) -- 贷款性质代码
    ,loan_typ_cd varchar2(2) -- 贷款类型代码
    ,loan_biz_type_cd varchar2(10) -- 贷款业务种类代码
    ,loan_biz_breed_cd varchar2(30) -- 贷款业务品种代码
    ,loan_contr_guar_mode_cd varchar2(10) -- 担保方式代码
    ,loan_fin_supt_mode_cd varchar2(5) -- 贷款财政扶持方式代码
    ,indu_stru_adj_typ varchar2(1) -- 产业结构调整类型代码
    ,indus_trsit_upgr_ind varchar2(1) -- 工业转型升级标志
    ,cty_rstr_indu_flg varchar2(1) -- 国家限制行业标志
    ,strg_emg_industry_typ_cd varchar2(4) -- 战略新兴产业类型代码
    ,contr_term_unt_cd varchar2(2) -- 合同期限单位代码
    ,ctr_term number -- 合同期限
    ,contr_grace_period_unt_cd varchar2(2) -- 合同宽限期单位代码
    ,contr_grace_period number -- 合同宽限期
    ,crdt_contr_id varchar2(60) -- 授信合同编号
    ,margin_acct_num varchar2(60) -- 保证金账号
    ,margin_ccy_cd varchar2(3) -- 保证金币种代码
    ,margin_amt number(18,2) -- 保证金金额
    ,rate_base_typ_cd varchar2(3) -- 利率基准类型代码
    ,rate_base_val number(18,6) -- 利率基准值
    ,float_rate_flg varchar2(1) -- 浮动利率标志
    ,rate_float_mode_cd varchar2(1) -- 利率浮动方式代码
    ,rate_float_val number(18,6) -- 利率浮动值
    ,exec_rate number(18,6) -- 执行利率
    ,cb_flg varchar2(1) -- 以物抵债标志
    ,laws_flg varchar2(1) -- 诉讼标志
    ,last_stats_norm_flg varchar2(1) -- 延续状态正常标志
    ,regr_flg varchar2(1) -- 重组标志
    ,cms_ast_buy_flg varchar2(1) -- 信贷资产买入标志
    ,cms_ast_tfr_flg varchar2(1) -- 信贷资产转让标志
    ,cms_ast_scrtz_flg varchar2(1) -- 信贷资产证券化标志
    ,syndc_loan_flg varchar2(1) -- 银团贷款标志
    ,lead_bank_flg varchar2(1) -- 牵头行标志
    ,prim_bank_num varchar2(30) -- 主办行行号
    ,ptcp_loan_bank_num varchar2(30) -- 参贷行行号
    ,agent_bank_num varchar2(30) -- 代理行行号
    ,prim_bank_name varchar2(200) -- 主办行行名
    ,ptcp_loan_bank_name varchar2(200) -- 参贷行行名
    ,agent_bank_name varchar2(200) -- 代理行行名
    ,agent_ptcp_loan_flg varchar2(1) -- 代理参贷标志
    ,appl_loan_total_amt number(18,2) -- 申请贷款总额
    ,cmmt_loan_amt number(18,2) -- 承担贷款金额
    ,actl_cmmt_loan_amt number(18,2) -- 实际承担贷款金额
    ,dd_loan_amt number(18,2) -- 已发放贷款金额
    ,dd_cmmt_loan_amt number(18,2) -- 已发放承担贷款金额
    ,cmmt_rema_loan_amt number(18,2) -- 承担剩余贷款金额
    ,mgr_bank_org_cd varchar2(30) -- 经理行银行机构代码
    ,entr_loan_flg varchar2(1) -- 委托贷款标志
    ,entr_pty_csld_id varchar2(60) -- 委托人客户统一编号
    ,entr_pty_name varchar2(100) -- 委托人客户名称
    ,entr_acct varchar2(40) -- 委托账号
    ,entr_acct_typ_cd varchar2(1) -- 委托账户类型代码
    ,entr_acct_open_bk_num varchar2(20) -- 委托账户开户行号
    ,entr_acct_open_bk_name varchar2(200) -- 委托账户开户行名
    ,csner_acct varchar2(40) -- 委托人账号
    ,csner_acct_typ_cd varchar2(1) -- 委托人账户类型代码
    ,entr_amt number(18,2) -- 委托金额
    ,entr_loan_funds_src_cd varchar2(1) -- 委托贷款资金来源代码
    ,actl_entr_loan_amt number(18,2) -- 实际委托贷款金额
    ,entr_loan_usage_cd varchar2(3) -- 委托贷款用途代码
    ,entr_loan_usage_desc varchar2(200) -- 委托贷款用途描述
    ,fee_mode varchar2(200) -- 手续费方式
    ,fee_amt number(18,2) -- 手续费金额
    ,trade_contr_id varchar2(60) -- 贸易合同编号
    ,trade_contr_ccy varchar2(3) -- 贸易合同币种代码
    ,trade_contr_total_amt number(18,2) -- 贸易合同总金额
    ,intl_biz_id varchar2(60) -- 国际业务编号
    ,fin_agt_amt number(18,2) -- 融资协议金额
    ,fin_agt_bal number(18,2) -- 融资协议余额
    ,guar_total_val number(18,2) -- 担保总价值
    ,guar_rate number(11,7) -- 担保率
    ,marg_ratio number(9,2) -- 保证金比例
    ,assoc_aprv_id varchar2(60) -- 关联审批编号
    ,pled_est_val number(18,2) -- 抵押物评估价值
    ,coll_rate number(11,7) -- 抵质押率
    ,coprate_proj_id varchar2(32) -- 合作项目编号
    ,data_src_cd varchar2(4) -- 数据来源代码
    ,del_flg varchar2(1) -- 删除标志
    ,serial_no varchar2(64) -- 业务流水号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rsts_src_dw_agt_loan_ctr_info to ${iml_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_loan_ctr_info to ${icl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_loan_ctr_info to ${idl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_loan_ctr_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info is '数仓_贷款合同信息';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_contr_id is '贷款合同编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.blng_pty_id is '所属客户编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.prd_id is '产品编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ctr_txt_name is '合同文本名称';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ccy_cd is '币种代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ctr_amt is '合同金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ctr_sign_dt is '合同签署日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ctr_eff_dt is '合同生效日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ctr_expire_dt is '合同失效日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.contr_due_dt is '合同到期日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.blng_org_id is '所属机构编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.mgmt_org_id is '管理机构编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.pty_mgr_id is '客户经理编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.agt_status_cd is '贷款合同状态代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_dir_indu_cd is '贷款投向行业代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_dir_zone_cd is '贷款投向地区代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_dir_cty_cd is '贷款投向国家代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_funds_src_cd is '贷款资金来源代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_usage_cd is '贷款用途代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_usage_desc is '贷款用途描述';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.occur_typ_cd is '发生类型代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_prop_cd is '贷款性质代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_typ_cd is '贷款类型代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_biz_type_cd is '贷款业务种类代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_biz_breed_cd is '贷款业务品种代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_contr_guar_mode_cd is '担保方式代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.loan_fin_supt_mode_cd is '贷款财政扶持方式代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.indu_stru_adj_typ is '产业结构调整类型代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.indus_trsit_upgr_ind is '工业转型升级标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.cty_rstr_indu_flg is '国家限制行业标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.strg_emg_industry_typ_cd is '战略新兴产业类型代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.contr_term_unt_cd is '合同期限单位代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ctr_term is '合同期限';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.contr_grace_period_unt_cd is '合同宽限期单位代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.contr_grace_period is '合同宽限期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.crdt_contr_id is '授信合同编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.margin_acct_num is '保证金账号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.margin_ccy_cd is '保证金币种代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.margin_amt is '保证金金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.rate_base_typ_cd is '利率基准类型代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.rate_base_val is '利率基准值';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.float_rate_flg is '浮动利率标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.rate_float_mode_cd is '利率浮动方式代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.rate_float_val is '利率浮动值';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.exec_rate is '执行利率';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.cb_flg is '以物抵债标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.laws_flg is '诉讼标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.last_stats_norm_flg is '延续状态正常标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.regr_flg is '重组标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.cms_ast_buy_flg is '信贷资产买入标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.cms_ast_tfr_flg is '信贷资产转让标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.cms_ast_scrtz_flg is '信贷资产证券化标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.syndc_loan_flg is '银团贷款标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.lead_bank_flg is '牵头行标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.prim_bank_num is '主办行行号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ptcp_loan_bank_num is '参贷行行号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.agent_bank_num is '代理行行号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.prim_bank_name is '主办行行名';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.ptcp_loan_bank_name is '参贷行行名';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.agent_bank_name is '代理行行名';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.agent_ptcp_loan_flg is '代理参贷标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.appl_loan_total_amt is '申请贷款总额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.cmmt_loan_amt is '承担贷款金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.actl_cmmt_loan_amt is '实际承担贷款金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.dd_loan_amt is '已发放贷款金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.dd_cmmt_loan_amt is '已发放承担贷款金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.cmmt_rema_loan_amt is '承担剩余贷款金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.mgr_bank_org_cd is '经理行银行机构代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_loan_flg is '委托贷款标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_pty_csld_id is '委托人客户统一编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_pty_name is '委托人客户名称';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_acct is '委托账号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_acct_typ_cd is '委托账户类型代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_acct_open_bk_num is '委托账户开户行号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_acct_open_bk_name is '委托账户开户行名';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.csner_acct is '委托人账号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.csner_acct_typ_cd is '委托人账户类型代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_amt is '委托金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_loan_funds_src_cd is '委托贷款资金来源代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.actl_entr_loan_amt is '实际委托贷款金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_loan_usage_cd is '委托贷款用途代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.entr_loan_usage_desc is '委托贷款用途描述';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.fee_mode is '手续费方式';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.fee_amt is '手续费金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.trade_contr_id is '贸易合同编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.trade_contr_ccy is '贸易合同币种代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.trade_contr_total_amt is '贸易合同总金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.intl_biz_id is '国际业务编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.fin_agt_amt is '融资协议金额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.fin_agt_bal is '融资协议余额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.guar_total_val is '担保总价值';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.guar_rate is '担保率';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.marg_ratio is '保证金比例';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.assoc_aprv_id is '关联审批编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.pled_est_val is '抵押物评估价值';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.coll_rate is '抵质押率';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.coprate_proj_id is '合作项目编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.del_flg is '删除标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.serial_no is '业务流水号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_ctr_info.etl_timestamp is 'ETL处理时间戳';
