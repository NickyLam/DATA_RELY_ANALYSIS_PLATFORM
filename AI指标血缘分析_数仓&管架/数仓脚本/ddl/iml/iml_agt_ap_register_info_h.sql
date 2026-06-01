/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ap_register_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ap_register_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ap_register_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ap_register_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,prop_id varchar2(100) -- 方案编号
    ,prop_name varchar2(1000) -- 方案名称
    ,cust_name varchar2(500) -- 客户名称
    ,disp_type_cd varchar2(1000) -- 处置类型代码
    ,cont_amt number(30,8) -- 合同金额
    ,cont_bal number(30,8) -- 合同余额
    ,fin_acct_recvbl number(30,8) -- 财务应收款
    ,in_bs_int_bal number(30,8) -- 表内利息余额
    ,off_bs_int_bal number(30,8) -- 表外利息余额
    ,cred_rht_amt number(30,8) -- 债权金额
    ,loan_sucs_tran_idf varchar2(60) -- 贷款成功转让标识
    ,tran_amt number(30,8) -- 转让金额
    ,seller_invstg_agent_org_name varchar2(500) -- 卖方尽职调查中介机构名称
    ,buyer_name varchar2(500) -- 买受人名称
    ,suit_stage_law_fee_amt number(30,8) -- 诉讼阶段法律性费用金额
    ,ckwrf_asset_pric_bal number(30,8) -- 账销案存资产本金余额
    ,ckwrf_asset_inbsoverint_bal number(30,8) -- 账销案存资产表内欠息余额
    ,ckwrf_asset_offbsoverint_bal number(30,8) -- 账销案存资产表外欠息余额
    ,prop_descb varchar2(4000) -- 方案描述
    ,risk_asset_comb varchar2(2000) -- 风险资产组合
    ,exec_status_cd varchar2(30) -- 执行状态代码
    ,pkg_dt date -- 封包日期
    ,tran_type_cd varchar2(30) -- 转让类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,modif_post_org_id varchar2(100) -- 变更后机构编号
    ,advc_suit_fee number(30,8) -- 代垫诉讼费
    ,pay_way_cd varchar2(30) -- 付款方式代码
    ,first_pay_amt number(30,8) -- 首付金额
    ,tran_cont_id varchar2(250) -- 转让合同编号
    ,tran_cont_begin_dt date -- 转让合同起始日期
    ,tran_cont_exp_dt date -- 转让合同到期日期
    ,tran_tran_plat varchar2(30) -- 转让交易平台代码
    ,tran_tran_plat_descb varchar2(500) -- 转让交易平台描述
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,cntpty_type_cd varchar2(30) -- 交易对手类型代码
    ,cntpty_open_bank_num varchar2(60) -- 交易对手开户行号
    ,cntpty_open_bank_name varchar2(500) -- 交易对手开户行名称
    ,cntpty_tran_acct_dt date -- 交易对手转账日期
    ,input_flg varchar2(10) -- 补录标志
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,up_date date -- 更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ap_register_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_ap_register_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_ap_register_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ap_register_info_h is '单户资产登记信息历史';
comment on column ${iml_schema}.agt_ap_register_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ap_register_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ap_register_info_h.flow_num is '流水号';
comment on column ${iml_schema}.agt_ap_register_info_h.prop_id is '方案编号';
comment on column ${iml_schema}.agt_ap_register_info_h.prop_name is '方案名称';
comment on column ${iml_schema}.agt_ap_register_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_ap_register_info_h.disp_type_cd is '处置类型代码';
comment on column ${iml_schema}.agt_ap_register_info_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_ap_register_info_h.cont_bal is '合同余额';
comment on column ${iml_schema}.agt_ap_register_info_h.fin_acct_recvbl is '财务应收款';
comment on column ${iml_schema}.agt_ap_register_info_h.in_bs_int_bal is '表内利息余额';
comment on column ${iml_schema}.agt_ap_register_info_h.off_bs_int_bal is '表外利息余额';
comment on column ${iml_schema}.agt_ap_register_info_h.cred_rht_amt is '债权金额';
comment on column ${iml_schema}.agt_ap_register_info_h.loan_sucs_tran_idf is '贷款成功转让标识';
comment on column ${iml_schema}.agt_ap_register_info_h.tran_amt is '转让金额';
comment on column ${iml_schema}.agt_ap_register_info_h.seller_invstg_agent_org_name is '卖方尽职调查中介机构名称';
comment on column ${iml_schema}.agt_ap_register_info_h.buyer_name is '买受人名称';
comment on column ${iml_schema}.agt_ap_register_info_h.suit_stage_law_fee_amt is '诉讼阶段法律性费用金额';
comment on column ${iml_schema}.agt_ap_register_info_h.ckwrf_asset_pric_bal is '账销案存资产本金余额';
comment on column ${iml_schema}.agt_ap_register_info_h.ckwrf_asset_inbsoverint_bal is '账销案存资产表内欠息余额';
comment on column ${iml_schema}.agt_ap_register_info_h.ckwrf_asset_offbsoverint_bal is '账销案存资产表外欠息余额';
comment on column ${iml_schema}.agt_ap_register_info_h.prop_descb is '方案描述';
comment on column ${iml_schema}.agt_ap_register_info_h.risk_asset_comb is '风险资产组合';
comment on column ${iml_schema}.agt_ap_register_info_h.exec_status_cd is '执行状态代码';
comment on column ${iml_schema}.agt_ap_register_info_h.pkg_dt is '封包日期';
comment on column ${iml_schema}.agt_ap_register_info_h.tran_type_cd is '转让类型代码';
comment on column ${iml_schema}.agt_ap_register_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ap_register_info_h.modif_post_org_id is '变更后机构编号';
comment on column ${iml_schema}.agt_ap_register_info_h.advc_suit_fee is '代垫诉讼费';
comment on column ${iml_schema}.agt_ap_register_info_h.pay_way_cd is '付款方式代码';
comment on column ${iml_schema}.agt_ap_register_info_h.first_pay_amt is '首付金额';
comment on column ${iml_schema}.agt_ap_register_info_h.tran_cont_id is '转让合同编号';
comment on column ${iml_schema}.agt_ap_register_info_h.tran_cont_begin_dt is '转让合同起始日期';
comment on column ${iml_schema}.agt_ap_register_info_h.tran_cont_exp_dt is '转让合同到期日期';
comment on column ${iml_schema}.agt_ap_register_info_h.tran_tran_plat is '转让交易平台代码';
comment on column ${iml_schema}.agt_ap_register_info_h.tran_tran_plat_descb is '转让交易平台描述';
comment on column ${iml_schema}.agt_ap_register_info_h.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.agt_ap_register_info_h.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.agt_ap_register_info_h.cntpty_type_cd is '交易对手类型代码';
comment on column ${iml_schema}.agt_ap_register_info_h.cntpty_open_bank_num is '交易对手开户行号';
comment on column ${iml_schema}.agt_ap_register_info_h.cntpty_open_bank_name is '交易对手开户行名称';
comment on column ${iml_schema}.agt_ap_register_info_h.cntpty_tran_acct_dt is '交易对手转账日期';
comment on column ${iml_schema}.agt_ap_register_info_h.input_flg is '补录标志';
comment on column ${iml_schema}.agt_ap_register_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_ap_register_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_ap_register_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_ap_register_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_ap_register_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_ap_register_info_h.up_date is '更新日期';
comment on column ${iml_schema}.agt_ap_register_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ap_register_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ap_register_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ap_register_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ap_register_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ap_register_info_h.etl_timestamp is 'ETL处理时间戳';
