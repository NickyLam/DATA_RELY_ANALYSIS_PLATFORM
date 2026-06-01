/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_dep_acct_tran_dtl_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_timestamp timestamp(6) -- 交易时间戳
    ,acct_bill_flow_num varchar2(60) -- 账单流水号
    ,ova_flow_num varchar2(60) -- 全局流水号
    ,src_tran_flow_num varchar2(60) -- 源交易流水号
    ,src_seq_no varchar2(100) -- 源交易序号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,dep_sub_acct_id varchar2(60) -- 存款分户编号
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,sub_acct_id varchar2(60) -- 子户编号
    ,tran_memo_descb varchar2(500) -- 附言
    ,tran_kind_cd varchar2(30) -- 交易类型代码
    ,debit_crdt_dir_cd varchar2(10) -- 借贷方向代码
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,cntpty_acct_id varchar2(60) -- 交易对手账户编号
    ,cntpty_acct_name varchar2(1000) -- 交易对手账户名称
    ,cntpty_acct_open_bank_cd varchar2(60) -- 交易对手账户开户行代码
    ,cntpty_open_bank_name varchar2(1000) -- 交易对手账户开户行名称
    ,cntpty_subj_id varchar2(60) -- 交易对手科目编号
    ,cntpty_subj_name varchar2(250) -- 交易对手科目名称
    ,tran_curr_cd varchar2(10) -- 交易币种代码
    ,tran_amt number(30,2) -- 交易金额
	,lev_tax_rebate_tran_flg varchar2(10) --离境退税交易标志
    ,src_sys_id varchar2(10) -- 系统来源标识
    ,tran_remark varchar2(1000)  -- 交易备注
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
grant select on ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info to ${idl_schema};
grant select on ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info to ${iel_schema};
grant select on ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info is '存款账户交易明细补充信息';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.tran_flow_num is '交易流水号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.tran_timestamp is '交易时间戳';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.acct_bill_flow_num is '账单流水号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.ova_flow_num is '全局流水号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.src_tran_flow_num is '源交易流水号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.src_seq_no is '源交易序号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cust_name is '客户名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.dep_sub_acct_id is '存款分户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.sub_acct_id is '子户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.tran_memo_descb is '附言';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.tran_kind_cd is '交易类型代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cntpty_acct_id is '交易对手账户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cntpty_acct_name is '交易对手账户名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cntpty_acct_open_bank_cd is '交易对手账户开户行代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cntpty_open_bank_name is '交易对手账户开户行名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cntpty_subj_id is '交易对手科目编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.cntpty_subj_name is '交易对手科目名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.tran_curr_cd is '交易币种代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.lev_tax_rebate_tran_flg is '离境退税交易标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.src_sys_id is '系统来源标识';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info.etl_timestamp is 'ETL处理时间戳';
