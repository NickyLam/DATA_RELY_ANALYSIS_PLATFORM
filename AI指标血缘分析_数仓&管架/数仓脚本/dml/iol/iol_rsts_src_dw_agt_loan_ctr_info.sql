/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_src_dw_agt_loan_ctr_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info_ex purge;
alter table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_src_dw_agt_loan_ctr_info where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_src_dw_agt_loan_ctr_info_ex(
    loan_contr_id -- 贷款合同编号
    ,etl_dt_ora -- 数据日期
    ,blng_pty_id -- 所属客户编号
    ,prd_id -- 产品编号
    ,ctr_txt_name -- 合同文本名称
    ,ccy_cd -- 币种代码
    ,ctr_amt -- 合同金额
    ,ctr_sign_dt -- 合同签署日期
    ,ctr_eff_dt -- 合同生效日期
    ,ctr_expire_dt -- 合同失效日期
    ,contr_due_dt -- 合同到期日期
    ,blng_org_id -- 所属机构编号
    ,mgmt_org_id -- 管理机构编号
    ,pty_mgr_id -- 客户经理编号
    ,agt_status_cd -- 贷款合同状态代码
    ,loan_dir_indu_cd -- 贷款投向行业代码
    ,loan_dir_zone_cd -- 贷款投向地区代码
    ,loan_dir_cty_cd -- 贷款投向国家代码
    ,loan_funds_src_cd -- 贷款资金来源代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_usage_desc -- 贷款用途描述
    ,occur_typ_cd -- 发生类型代码
    ,loan_prop_cd -- 贷款性质代码
    ,loan_typ_cd -- 贷款类型代码
    ,loan_biz_type_cd -- 贷款业务种类代码
    ,loan_biz_breed_cd -- 贷款业务品种代码
    ,loan_contr_guar_mode_cd -- 担保方式代码
    ,loan_fin_supt_mode_cd -- 贷款财政扶持方式代码
    ,indu_stru_adj_typ -- 产业结构调整类型代码
    ,indus_trsit_upgr_ind -- 工业转型升级标志
    ,cty_rstr_indu_flg -- 国家限制行业标志
    ,strg_emg_industry_typ_cd -- 战略新兴产业类型代码
    ,contr_term_unt_cd -- 合同期限单位代码
    ,ctr_term -- 合同期限
    ,contr_grace_period_unt_cd -- 合同宽限期单位代码
    ,contr_grace_period -- 合同宽限期
    ,crdt_contr_id -- 授信合同编号
    ,margin_acct_num -- 保证金账号
    ,margin_ccy_cd -- 保证金币种代码
    ,margin_amt -- 保证金金额
    ,rate_base_typ_cd -- 利率基准类型代码
    ,rate_base_val -- 利率基准值
    ,float_rate_flg -- 浮动利率标志
    ,rate_float_mode_cd -- 利率浮动方式代码
    ,rate_float_val -- 利率浮动值
    ,exec_rate -- 执行利率
    ,cb_flg -- 以物抵债标志
    ,laws_flg -- 诉讼标志
    ,last_stats_norm_flg -- 延续状态正常标志
    ,regr_flg -- 重组标志
    ,cms_ast_buy_flg -- 信贷资产买入标志
    ,cms_ast_tfr_flg -- 信贷资产转让标志
    ,cms_ast_scrtz_flg -- 信贷资产证券化标志
    ,syndc_loan_flg -- 银团贷款标志
    ,lead_bank_flg -- 牵头行标志
    ,prim_bank_num -- 主办行行号
    ,ptcp_loan_bank_num -- 参贷行行号
    ,agent_bank_num -- 代理行行号
    ,prim_bank_name -- 主办行行名
    ,ptcp_loan_bank_name -- 参贷行行名
    ,agent_bank_name -- 代理行行名
    ,agent_ptcp_loan_flg -- 代理参贷标志
    ,appl_loan_total_amt -- 申请贷款总额
    ,cmmt_loan_amt -- 承担贷款金额
    ,actl_cmmt_loan_amt -- 实际承担贷款金额
    ,dd_loan_amt -- 已发放贷款金额
    ,dd_cmmt_loan_amt -- 已发放承担贷款金额
    ,cmmt_rema_loan_amt -- 承担剩余贷款金额
    ,mgr_bank_org_cd -- 经理行银行机构代码
    ,entr_loan_flg -- 委托贷款标志
    ,entr_pty_csld_id -- 委托人客户统一编号
    ,entr_pty_name -- 委托人客户名称
    ,entr_acct -- 委托账号
    ,entr_acct_typ_cd -- 委托账户类型代码
    ,entr_acct_open_bk_num -- 委托账户开户行号
    ,entr_acct_open_bk_name -- 委托账户开户行名
    ,csner_acct -- 委托人账号
    ,csner_acct_typ_cd -- 委托人账户类型代码
    ,entr_amt -- 委托金额
    ,entr_loan_funds_src_cd -- 委托贷款资金来源代码
    ,actl_entr_loan_amt -- 实际委托贷款金额
    ,entr_loan_usage_cd -- 委托贷款用途代码
    ,entr_loan_usage_desc -- 委托贷款用途描述
    ,fee_mode -- 手续费方式
    ,fee_amt -- 手续费金额
    ,trade_contr_id -- 贸易合同编号
    ,trade_contr_ccy -- 贸易合同币种代码
    ,trade_contr_total_amt -- 贸易合同总金额
    ,intl_biz_id -- 国际业务编号
    ,fin_agt_amt -- 融资协议金额
    ,fin_agt_bal -- 融资协议余额
    ,guar_total_val -- 担保总价值
    ,guar_rate -- 担保率
    ,marg_ratio -- 保证金比例
    ,assoc_aprv_id -- 关联审批编号
    ,pled_est_val -- 抵押物评估价值
    ,coll_rate -- 抵质押率
    ,coprate_proj_id -- 合作项目编号
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,serial_no -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    loan_contr_id -- 贷款合同编号
    ,etl_dt_ora -- 数据日期
    ,blng_pty_id -- 所属客户编号
    ,prd_id -- 产品编号
    ,ctr_txt_name -- 合同文本名称
    ,ccy_cd -- 币种代码
    ,ctr_amt -- 合同金额
    ,ctr_sign_dt -- 合同签署日期
    ,ctr_eff_dt -- 合同生效日期
    ,ctr_expire_dt -- 合同失效日期
    ,contr_due_dt -- 合同到期日期
    ,blng_org_id -- 所属机构编号
    ,mgmt_org_id -- 管理机构编号
    ,pty_mgr_id -- 客户经理编号
    ,agt_status_cd -- 贷款合同状态代码
    ,loan_dir_indu_cd -- 贷款投向行业代码
    ,loan_dir_zone_cd -- 贷款投向地区代码
    ,loan_dir_cty_cd -- 贷款投向国家代码
    ,loan_funds_src_cd -- 贷款资金来源代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_usage_desc -- 贷款用途描述
    ,occur_typ_cd -- 发生类型代码
    ,loan_prop_cd -- 贷款性质代码
    ,loan_typ_cd -- 贷款类型代码
    ,loan_biz_type_cd -- 贷款业务种类代码
    ,loan_biz_breed_cd -- 贷款业务品种代码
    ,loan_contr_guar_mode_cd -- 担保方式代码
    ,loan_fin_supt_mode_cd -- 贷款财政扶持方式代码
    ,indu_stru_adj_typ -- 产业结构调整类型代码
    ,indus_trsit_upgr_ind -- 工业转型升级标志
    ,cty_rstr_indu_flg -- 国家限制行业标志
    ,strg_emg_industry_typ_cd -- 战略新兴产业类型代码
    ,contr_term_unt_cd -- 合同期限单位代码
    ,ctr_term -- 合同期限
    ,contr_grace_period_unt_cd -- 合同宽限期单位代码
    ,contr_grace_period -- 合同宽限期
    ,crdt_contr_id -- 授信合同编号
    ,margin_acct_num -- 保证金账号
    ,margin_ccy_cd -- 保证金币种代码
    ,margin_amt -- 保证金金额
    ,rate_base_typ_cd -- 利率基准类型代码
    ,rate_base_val -- 利率基准值
    ,float_rate_flg -- 浮动利率标志
    ,rate_float_mode_cd -- 利率浮动方式代码
    ,rate_float_val -- 利率浮动值
    ,exec_rate -- 执行利率
    ,cb_flg -- 以物抵债标志
    ,laws_flg -- 诉讼标志
    ,last_stats_norm_flg -- 延续状态正常标志
    ,regr_flg -- 重组标志
    ,cms_ast_buy_flg -- 信贷资产买入标志
    ,cms_ast_tfr_flg -- 信贷资产转让标志
    ,cms_ast_scrtz_flg -- 信贷资产证券化标志
    ,syndc_loan_flg -- 银团贷款标志
    ,lead_bank_flg -- 牵头行标志
    ,prim_bank_num -- 主办行行号
    ,ptcp_loan_bank_num -- 参贷行行号
    ,agent_bank_num -- 代理行行号
    ,prim_bank_name -- 主办行行名
    ,ptcp_loan_bank_name -- 参贷行行名
    ,agent_bank_name -- 代理行行名
    ,agent_ptcp_loan_flg -- 代理参贷标志
    ,appl_loan_total_amt -- 申请贷款总额
    ,cmmt_loan_amt -- 承担贷款金额
    ,actl_cmmt_loan_amt -- 实际承担贷款金额
    ,dd_loan_amt -- 已发放贷款金额
    ,dd_cmmt_loan_amt -- 已发放承担贷款金额
    ,cmmt_rema_loan_amt -- 承担剩余贷款金额
    ,mgr_bank_org_cd -- 经理行银行机构代码
    ,entr_loan_flg -- 委托贷款标志
    ,entr_pty_csld_id -- 委托人客户统一编号
    ,entr_pty_name -- 委托人客户名称
    ,entr_acct -- 委托账号
    ,entr_acct_typ_cd -- 委托账户类型代码
    ,entr_acct_open_bk_num -- 委托账户开户行号
    ,entr_acct_open_bk_name -- 委托账户开户行名
    ,csner_acct -- 委托人账号
    ,csner_acct_typ_cd -- 委托人账户类型代码
    ,entr_amt -- 委托金额
    ,entr_loan_funds_src_cd -- 委托贷款资金来源代码
    ,actl_entr_loan_amt -- 实际委托贷款金额
    ,entr_loan_usage_cd -- 委托贷款用途代码
    ,entr_loan_usage_desc -- 委托贷款用途描述
    ,fee_mode -- 手续费方式
    ,fee_amt -- 手续费金额
    ,trade_contr_id -- 贸易合同编号
    ,trade_contr_ccy -- 贸易合同币种代码
    ,trade_contr_total_amt -- 贸易合同总金额
    ,intl_biz_id -- 国际业务编号
    ,fin_agt_amt -- 融资协议金额
    ,fin_agt_bal -- 融资协议余额
    ,guar_total_val -- 担保总价值
    ,guar_rate -- 担保率
    ,marg_ratio -- 保证金比例
    ,assoc_aprv_id -- 关联审批编号
    ,pled_est_val -- 抵押物评估价值
    ,coll_rate -- 抵质押率
    ,coprate_proj_id -- 合作项目编号
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,serial_no -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_src_dw_agt_loan_ctr_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info exchange partition p_${batch_date} with table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_src_dw_agt_loan_ctr_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_src_dw_agt_loan_ctr_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_src_dw_agt_loan_ctr_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);