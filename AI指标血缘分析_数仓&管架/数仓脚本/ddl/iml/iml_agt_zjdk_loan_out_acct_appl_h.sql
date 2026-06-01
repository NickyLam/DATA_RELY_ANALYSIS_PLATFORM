/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_zjdk_loan_out_acct_appl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h(
    appl_id varchar2(250) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_dt date -- 申请日期
    ,cfm_dt date -- 确认日期
    ,exp_dt date -- 到期日期
    ,prod_id varchar2(100) -- 产品编号
    ,loan_year_int_rat number(30,8) -- 贷款年利率
    ,mon_tenor number(10) -- 月期限
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_ped_corp_cd varchar2(30) -- 还款周期单位代码
    ,loan_tot_perds number(10) -- 贷款总期数
    ,grace_days number(10) -- 宽限天数
    ,intnal_dubil_id varchar2(100) -- 借据编号
    ,crdt_id varchar2(100) -- 授信编号
    ,mercht_id varchar2(100) -- 商户编号
    ,mercht_app_id varchar2(100) -- 商户应用编号
    ,distr_flow_num varchar2(100) -- 放款流水号
    ,distr_pay_indent_id varchar2(100) -- 放款支付订单编号
    ,distr_init_dt date -- 放款发起日期
    ,distr_cmplt_dt date -- 放款完成日期
    ,distr_sucs_flg varchar2(30) -- 放款状态代码
    ,distr_tot_amt number(30,8) -- 放款总金额
    ,curr_cd varchar2(30) -- 币种代码
    ,distr_bank_card_num varchar2(100) -- 放款银行卡号
    ,distr_acct_name varchar2(500) -- 放款账户名称
    ,distr_bank_card_type_cd varchar2(30) -- 放款银行卡类型代码
    ,distr_acct_rsrv_mobile_no varchar2(100) -- 放款账户预留手机号码
    ,distr_ibank_no varchar2(100) -- 放款联行号
    ,plat_distr_indent_id varchar2(100) -- 平台放款订单编号
    ,distr_tran_sucs_dt date -- 放款交易成功日期
    ,cont_id varchar2(100) -- 合同编号
    ,fin_dt date -- 财务日期
    ,header varchar2(100) -- 牵头方
    ,partner varchar2(100) -- 合作方
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_type_cd varchar2(60) -- 证件类型代码
    ,cert_no varchar2(250) -- 证件号码
    ,cntpty_acct_type_cd varchar2(30) -- 交易对手账户类型代码
    ,cntpty_open_acct_bank_name varchar2(500) -- 交易对手开户银行名称
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_bank_card_type_cd varchar2(100) -- 交易对手银行卡类型代码
    ,plat_indent_id varchar2(100) -- 平台订单编号
    ,remark varchar2(4000) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_zjdk_loan_out_acct_appl_h to ${icl_schema};
grant select on ${iml_schema}.agt_zjdk_loan_out_acct_appl_h to ${idl_schema};
grant select on ${iml_schema}.agt_zjdk_loan_out_acct_appl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h is '字节小微贷出账申请历史';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cfm_dt is '确认日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.loan_year_int_rat is '贷款年利率';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.repay_ped_corp_cd is '还款周期单位代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.loan_tot_perds is '贷款总期数';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.grace_days is '宽限天数';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.intnal_dubil_id is '借据编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.crdt_id is '授信编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.mercht_app_id is '商户应用编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_flow_num is '放款流水号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_pay_indent_id is '放款支付订单编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_init_dt is '放款发起日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_cmplt_dt is '放款完成日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_sucs_flg is '放款状态代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_tot_amt is '放款总金额';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_bank_card_num is '放款银行卡号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_acct_name is '放款账户名称';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_bank_card_type_cd is '放款银行卡类型代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_acct_rsrv_mobile_no is '放款账户预留手机号码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_ibank_no is '放款联行号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.plat_distr_indent_id is '平台放款订单编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.distr_tran_sucs_dt is '放款交易成功日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.fin_dt is '财务日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.header is '牵头方';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.partner is '合作方';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cntpty_acct_type_cd is '交易对手账户类型代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cntpty_open_acct_bank_name is '交易对手开户银行名称';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.cntpty_bank_card_type_cd is '交易对手银行卡类型代码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.plat_indent_id is '平台订单编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.remark is '备注';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_zjdk_loan_out_acct_appl_h.etl_timestamp is 'ETL处理时间戳';
