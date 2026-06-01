/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_out_acct_indv_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_distr_amt number(30,2) -- 申请放款金额
    ,hqd_centr_out_acct_flg varchar2(10) -- 好企贷集中出账标志
    ,recver_open_bank_name varchar2(500) -- 收款人开户行名称
    ,open_acct_bind_mobile_no varchar2(60) -- 开户绑定手机号码
    ,loan_distr_dt date -- 贷款发放日期
    ,loan_actl_distr_dt date -- 贷款实际发放日期
    ,entr_pay_cfm_status_cd varchar2(30) -- 受托支付确认状态代码
    ,entr_pay_cfm_tm timestamp -- 受托支付确认时间
    ,entr_pay_acct_num_id varchar2(100) -- 受托支付账号编号
    ,self_pay_amt number(30,2) -- 自主支付金额
    ,pay_indent_id varchar2(100) -- 支付订单编号
    ,distr_chn_cd varchar2(30) -- 放款渠道代码
    ,distr_dt date -- 放款日期
    ,distr_advise_sucs_flg varchar2(10) -- 放款通知成功标志
    ,distr_end_dt date -- 放款结束日期
    ,loan_perds number(10) -- 贷款期数
    ,repay_card_type_cd varchar2(30) -- 还款卡类型代码
    ,deflt_repay_day varchar2(10) -- 默认还款日
    ,loan_termnt_dt date -- 贷款终止日期
    ,blon_loan_amort_dt date -- 气球贷摊销日期
    ,input_stamp_tax_flg varchar2(10) -- 录入印花税标志
    ,stamp_tax_tax_acct_id varchar2(100) -- 印花税扣税账户编号
    ,stamp_tax_acct_name varchar2(500) -- 印花税扣税账号名称
    ,stamp_tax_amt number(30,2) -- 印花税金额
    ,prod_chn_idf_cd varchar2(30) -- 产品渠道标识代码
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,file_int_accr_flg varchar2(10) -- 靠档计息标志
    ,due_diligence_flg varchar2(10) -- 尽调标志
    ,outline_vrif_idti_flg varchar2(10) -- 线下核身标志
    ,out_acct_impt_cond_descb varchar2(1000) -- 出账落实条件描述
    ,risk_mgmt_rest_cd varchar2(30) -- 风控结果代码
    ,guar_guar_letter_id varchar2(100) -- 担保保证函编号
    ,group_cust_flg varchar2(10) -- 集团客户标志
    ,group_cust_name varchar2(500) -- 集团客户名称
    ,group_cust_id varchar2(100) -- 集团客户编号
    ,group_cust_aval_open_lmt number(30,8) -- 集团客户可用敞口额度
    ,brwer_and_group_rela_cd varchar2(30) -- 借款人与集团关系代码
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
grant select on ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h is '贷款出账个人贷款附属信息历史';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.appl_distr_amt is '申请放款金额';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.hqd_centr_out_acct_flg is '好企贷集中出账标志';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.open_acct_bind_mobile_no is '开户绑定手机号码';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.loan_distr_dt is '贷款发放日期';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.loan_actl_distr_dt is '贷款实际发放日期';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.entr_pay_cfm_status_cd is '受托支付确认状态代码';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.entr_pay_cfm_tm is '受托支付确认时间';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.entr_pay_acct_num_id is '受托支付账号编号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.self_pay_amt is '自主支付金额';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.pay_indent_id is '支付订单编号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.distr_chn_cd is '放款渠道代码';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.distr_advise_sucs_flg is '放款通知成功标志';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.distr_end_dt is '放款结束日期';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.loan_perds is '贷款期数';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.repay_card_type_cd is '还款卡类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.deflt_repay_day is '默认还款日';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.loan_termnt_dt is '贷款终止日期';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.blon_loan_amort_dt is '气球贷摊销日期';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.input_stamp_tax_flg is '录入印花税标志';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.stamp_tax_tax_acct_id is '印花税扣税账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.stamp_tax_acct_name is '印花税扣税账号名称';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.stamp_tax_amt is '印花税金额';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.prod_chn_idf_cd is '产品渠道标识代码';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.file_int_accr_flg is '靠档计息标志';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.due_diligence_flg is '尽调标志';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.outline_vrif_idti_flg is '线下核身标志';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.out_acct_impt_cond_descb is '出账落实条件描述';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.risk_mgmt_rest_cd is '风控结果代码';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.guar_guar_letter_id is '担保保证函编号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.group_cust_flg is '集团客户标志';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.group_cust_name is '集团客户名称';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.group_cust_id is '集团客户编号';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.group_cust_aval_open_lmt is '集团客户可用敞口额度';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.brwer_and_group_rela_cd is '借款人与集团关系代码';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
