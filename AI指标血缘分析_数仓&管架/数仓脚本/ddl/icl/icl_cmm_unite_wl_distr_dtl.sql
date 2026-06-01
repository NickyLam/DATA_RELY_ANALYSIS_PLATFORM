/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_unite_wl_distr_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_unite_wl_distr_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_wl_distr_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_distr_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(500) -- 客户姓名
    ,cust_cert_type_cd varchar2(10) -- 客户证件类型代码
    ,cust_cert_no varchar2(100) -- 客户证件号码
    ,crdt_id varchar2(100) -- 授信编号
    ,loan_appl_form_num varchar2(100) -- 贷款申请单号
    ,distr_flow_num varchar2(100) -- 放款流水号
    ,prod_id varchar2(100) -- 产品编号
    ,loan_contr_no varchar2(100) -- 贷款合同号
    ,loan_status_cd varchar2(10) -- 贷款状态代码
    ,loan_usage varchar2(500) -- 贷款用途
    ,curr_cd varchar2(10) -- 币种代码
    ,distr_amt number(30,2) -- 放款金额
    ,appl_dt date -- 申请日期
    ,distr_dt date -- 放款日期
    ,loan_pd_cnt number(10,0) -- 贷款期次数
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,grace_period_days number(10,0) -- 宽限期天数
    ,int_rat_type_cd varchar2(10) -- 利率类型代码
    ,loan_day_int_rat number(18,8) -- 贷款日利率
    ,pric_repay_freq number(10,0) -- 本金还款频率
    ,int_repay_freq number(10,0) -- 利息还款频率
    ,guar_type_cd varchar2(10) -- 担保类型代码
    ,recvbl_num varchar2(100) -- 收款帐号
    ,recvbl_num_type_cd varchar2(10) -- 收款帐号类型代码
	,recvbl_num_bank_num varchar2(100) -- 收款帐号银行行号
    ,recvbl_num_bank_name varchar2(500) -- 收款帐号银行行名
    ,repay_num varchar2(100) -- 还款帐号
    ,repay_num_type_cd varchar2(10) -- 还款帐号类型代码
    ,intnal_carr_idf varchar2(10) -- 内部结转标识
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
grant select on ${icl_schema}.cmm_unite_wl_distr_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_unite_wl_distr_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_unite_wl_distr_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_unite_wl_distr_dtl is '联合网贷放款明细';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.cust_name is '客户姓名';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.cust_cert_type_cd is '客户证件类型代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.cust_cert_no is '客户证件号码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.crdt_id is '授信编号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.loan_appl_form_num is '贷款申请单号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.distr_flow_num is '放款流水号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.loan_contr_no is '贷款合同号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.loan_status_cd is '贷款状态代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.loan_usage is '贷款用途';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.distr_amt is '放款金额';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.appl_dt is '申请日期';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.distr_dt is '放款日期';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.loan_pd_cnt is '贷款期次数';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.repay_way_cd is '还款方式代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.grace_period_days is '宽限期天数';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.int_rat_type_cd is '利率类型代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.loan_day_int_rat is '贷款日利率';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.pric_repay_freq is '本金还款频率';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.int_repay_freq is '利息还款频率';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.guar_type_cd is '担保类型代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.recvbl_num is '收款帐号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.recvbl_num_type_cd is '收款帐号类型代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.recvbl_num_bank_num is '收款帐号银行行号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.recvbl_num_bank_name is '收款帐号银行行名';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.repay_num is '还款帐号';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.repay_num_type_cd is '还款帐号类型代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.intnal_carr_idf is '内部结转标识';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_unite_wl_distr_dtl.etl_timestamp is 'ETL处理时间戳';
