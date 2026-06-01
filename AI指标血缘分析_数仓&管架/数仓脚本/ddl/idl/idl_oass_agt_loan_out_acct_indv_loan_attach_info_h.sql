/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_loan_out_acct_indv_loan_attach_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h(
etl_dt date --数据日期
,lp_id varchar2(100) --法人编号
,appl_distr_amt number(30,2) --申请放款金额
,risk_mgmt_rest_cd varchar2(30) --风控结果代码
,repay_card_type_cd varchar2(30) --还款卡类型代码
,recver_open_bank_name varchar2(500) --收款人开户行名称
,loan_distr_dt date --贷款发放日期
,loan_perds number(10,0) --贷款期数
,loan_actl_distr_dt date --贷款实际发放日期
,deflt_repay_day varchar2(10) --默认还款日
,loan_termnt_dt date --贷款终止日期
,input_stamp_tax_flg varchar2(10) --录入印花税标志
,stamp_tax_tax_acct_id varchar2(100) --印花税扣税账户编号
,stamp_tax_acct_name varchar2(500) --印花税扣税账号名称
,stamp_tax_amt number(30,2) --印花税金额
,open_acct_bind_mobile_no varchar2(60) --开户绑定手机号码
,out_acct_impt_cond_descb varchar2(1000) --出账落实条件描述
,entr_pay_cfm_status_cd varchar2(30) --受托支付确认状态代码
,entr_pay_cfm_tm timestamp(6) --受托支付确认时间
,self_pay_amt number(30,2) --自主支付金额
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,appl_id varchar2(100) --申请编号
,out_acct_flow_num varchar2(100) --出账流水号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h is '贷款出账个人贷款附属信息历史';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.appl_distr_amt is '申请放款金额';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.risk_mgmt_rest_cd is '风控结果代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.repay_card_type_cd is '还款卡类型代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.recver_open_bank_name is '收款人开户行名称';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.loan_distr_dt is '贷款发放日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.loan_perds is '贷款期数';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.loan_actl_distr_dt is '贷款实际发放日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.deflt_repay_day is '默认还款日';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.loan_termnt_dt is '贷款终止日期';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.input_stamp_tax_flg is '录入印花税标志';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.stamp_tax_tax_acct_id is '印花税扣税账户编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.stamp_tax_acct_name is '印花税扣税账号名称';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.stamp_tax_amt is '印花税金额';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.open_acct_bind_mobile_no is '开户绑定手机号码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.out_acct_impt_cond_descb is '出账落实条件描述';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.entr_pay_cfm_status_cd is '受托支付确认状态代码';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.entr_pay_cfm_tm is '受托支付确认时间';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.self_pay_amt is '自主支付金额';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.appl_id is '申请编号';
comment on column ${idl_schema}.oass_agt_loan_out_acct_indv_loan_attach_info_h.out_acct_flow_num is '出账流水号';

