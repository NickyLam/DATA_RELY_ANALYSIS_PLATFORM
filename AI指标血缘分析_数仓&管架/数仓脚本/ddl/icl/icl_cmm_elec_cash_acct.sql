/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_elec_cash_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_elec_cash_acct
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_elec_cash_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_elec_cash_acct(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_acct_card_no varchar2(60) -- 客户账户卡号
    ,cust_acct_sub_acct_id varchar2(60) -- 账户子账号
    ,acct_name varchar2(100) -- 账户名称
    ,cust_id varchar2(60) -- 客户编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,subj_id varchar2(60) -- 科目编号
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,curr_cd varchar2(10) -- 币种代码
    ,open_acct_dt date -- 开户日期
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_flow_num varchar2(60) -- 销户流水号
    ,acct_bal_uplmi number(30,2) -- 账户余额上限
    ,sig_tran_lmt number(30,2) -- 单笔交易限额
    ,acm_load_amt number(30,2) -- 累计圈存金额
    ,currt_bal number(30,2) -- 当期余额
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
grant select on ${icl_schema}.cmm_elec_cash_acct to ${idl_schema};
grant select on ${icl_schema}.cmm_elec_cash_acct to ${iel_schema};
grant select on ${icl_schema}.cmm_elec_cash_acct to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_elec_cash_acct is '电子现金账户信息';
comment on column ${icl_schema}.cmm_elec_cash_acct.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_elec_cash_acct.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_elec_cash_acct.cust_acct_card_no is '客户账户卡号';
comment on column ${icl_schema}.cmm_elec_cash_acct.cust_acct_sub_acct_id is '账户子账号';
comment on column ${icl_schema}.cmm_elec_cash_acct.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_elec_cash_acct.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_elec_cash_acct.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_elec_cash_acct.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_elec_cash_acct.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_elec_cash_acct.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_elec_cash_acct.open_acct_dt is '开户日期';
comment on column ${icl_schema}.cmm_elec_cash_acct.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_elec_cash_acct.clos_acct_dt is '销户日期';
comment on column ${icl_schema}.cmm_elec_cash_acct.clos_acct_flow_num is '销户流水号';
comment on column ${icl_schema}.cmm_elec_cash_acct.acct_bal_uplmi is '账户余额上限';
comment on column ${icl_schema}.cmm_elec_cash_acct.sig_tran_lmt is '单笔交易限额';
comment on column ${icl_schema}.cmm_elec_cash_acct.acm_load_amt is '累计圈存金额';
comment on column ${icl_schema}.cmm_elec_cash_acct.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_elec_cash_acct.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_elec_cash_acct.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_elec_cash_acct.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_elec_cash_acct.etl_timestamp is 'ETL处理时间戳';
