/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_cmm_lc_doc_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_cmm_lc_doc_info
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_cmm_lc_doc_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_cmm_lc_doc_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,doc_agt_id varchar2(60) -- 单据协议编号
    ,doc_id varchar2(60) -- 单据编号
    ,lc_acct_id varchar2(60) -- 信用证账户编号
    ,commer_inv_no varchar2(60) -- 商业发票号码
    ,subj_id varchar2(60) -- 科目编号
    ,mx_lc_flg varchar2(10) -- 进出口信用证标志
    ,arrive_bill_flg varchar2(10) -- 到单标志
    ,acpt_flg varchar2(10) -- 承兑标志
    ,send_bill_dt date -- 寄单日期
    ,issue_dt date -- 开证日期
    ,wrtoff_dt date -- 注销日期
    ,acpt_dt date -- 承兑日期
    ,arrive_bill_dt date -- 到单日期
    ,pay_dt date -- 付款日期
    ,payer_id varchar2(60) -- 付款人编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,oper_org_id varchar2(60) -- 经办机构编号
    ,pay_org_id varchar2(60) -- 付款机构编号
    ,sign_org_id varchar2(60) -- 签署机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,payer_name varchar2(200) -- 付款人名称
    ,doc_type_cd varchar2(10) -- 单据类型代码
    ,doc_status_cd varchar2(10) -- 单据状态代码
    ,curr_cd varchar2(10) -- 币种代码
    ,overs_deduct_amt number(30,2) -- 国外扣费金额
    ,pay_amt number(30,2) -- 付款金额
    ,lc_bal number(30,2) -- 信用证余额
    ,cl_curr_lc_bal number(30,2) -- 折本币信用证余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_cmm_lc_doc_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_cmm_lc_doc_info is '信用证单据信息';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.doc_agt_id is '单据协议编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.doc_id is '单据编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.lc_acct_id is '信用证账户编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.commer_inv_no is '商业发票号码';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.subj_id is '科目编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.mx_lc_flg is '进出口信用证标志';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.arrive_bill_flg is '到单标志';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.acpt_flg is '承兑标志';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.send_bill_dt is '寄单日期';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.issue_dt is '开证日期';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.wrtoff_dt is '注销日期';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.acpt_dt is '承兑日期';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.arrive_bill_dt is '到单日期';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.pay_dt is '付款日期';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.payer_id is '付款人编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.oper_org_id is '经办机构编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.pay_org_id is '付款机构编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.sign_org_id is '签署机构编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.acct_instit_id is '账务机构编号';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.payer_name is '付款人名称';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.doc_type_cd is '单据类型代码';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.doc_status_cd is '单据状态代码';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.overs_deduct_amt is '国外扣费金额';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.pay_amt is '付款金额';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.lc_bal is '信用证余额';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.cl_curr_lc_bal is '折本币信用证余额';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_cmm_lc_doc_info.etl_timestamp is '数据处理时间';
