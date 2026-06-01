/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ibank_cap_bal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ibank_cap_bal
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_cap_bal purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_cap_bal(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_cap_acct_id varchar2(60) -- 内部资金账户编号
    ,ext_cap_acct_id varchar2(60) -- 外部资金账户编号
    ,acct_name varchar2(500) -- 账户名称
    ,tran_market_id varchar2(100) -- 交易市场编号
    ,exchg_acct_id varchar2(60) -- 交易所账户编号
    ,open_acct_bank_no varchar2(60) -- 开户银行行号
    ,open_acct_bank_name varchar2(500) -- 开户银行名称
    ,open_acct_dt date -- 开户日期
    ,cntpty_cust_id varchar2(60) -- 交易对手客户编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(250) -- 交易对手名称
    ,intnal_cap_acct_num varchar2(60) -- 内部资金账号
    ,cap_acct_type_cd varchar2(10) -- 资金账户类型代码
    ,intnal_acct_num varchar2(60) -- 内部账号
    ,intnal_acct_name varchar2(375) -- 内部账名称
    ,pay_int_freq varchar2(10) -- 付息频率
    ,prod_type_id varchar2(60) -- 产品类型编号
    ,prod_cls_name varchar2(250) -- 产品分类名称
    ,subj_id varchar2(60) -- 科目编号
    ,int_rat_def_id varchar2(60) -- 利率定义编号
    ,int_rat number(18,8) -- 利率
    ,cap_type_cd varchar2(10) -- 资金类型代码
    ,bal_type_cd varchar2(10) -- 余额类型代码
    ,curr_cd varchar2(10) -- 币种代码
    ,actl_bal number(38,8) -- 实际余额
    ,froz_bal number(38,8) -- 冻结余额
    ,aval_bal number(38,8) -- 可用余额
    ,stl_dt date -- 结算日期
    ,open_dt date -- 开仓日期
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,belong_org_id varchar2(60) -- 所属机构编号
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
grant select on ${icl_schema}.cmm_ibank_cap_bal to ${idl_schema};
grant select on ${icl_schema}.cmm_ibank_cap_bal to ${iel_schema};
grant select on ${icl_schema}.cmm_ibank_cap_bal to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ibank_cap_bal is '同业资金余额';
comment on column ${icl_schema}.cmm_ibank_cap_bal.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ibank_cap_bal.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.intnal_cap_acct_id is '内部资金账户编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.ext_cap_acct_id is '外部资金账户编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_ibank_cap_bal.tran_market_id is '交易市场编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.exchg_acct_id is '交易所账户编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.open_acct_bank_no is '开户银行行号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.open_acct_bank_name is '开户银行名称';
comment on column ${icl_schema}.cmm_ibank_cap_bal.open_acct_dt is '开户日期';
comment on column ${icl_schema}.cmm_ibank_cap_bal.cntpty_cust_id is '交易对手客户编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_ibank_cap_bal.intnal_cap_acct_num is '内部资金账号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.cap_acct_type_cd is '资金账户类型代码';
comment on column ${icl_schema}.cmm_ibank_cap_bal.intnal_acct_num is '内部账号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.intnal_acct_name is '内部账名称';
comment on column ${icl_schema}.cmm_ibank_cap_bal.pay_int_freq is '付息频率';
comment on column ${icl_schema}.cmm_ibank_cap_bal.prod_type_id is '产品类型编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.prod_cls_name is '产品分类名称';
comment on column ${icl_schema}.cmm_ibank_cap_bal.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.int_rat_def_id is '利率定义编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.int_rat is '利率';
comment on column ${icl_schema}.cmm_ibank_cap_bal.cap_type_cd is '资金类型代码';
comment on column ${icl_schema}.cmm_ibank_cap_bal.bal_type_cd is '余额类型代码';
comment on column ${icl_schema}.cmm_ibank_cap_bal.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_ibank_cap_bal.actl_bal is '实际余额';
comment on column ${icl_schema}.cmm_ibank_cap_bal.froz_bal is '冻结余额';
comment on column ${icl_schema}.cmm_ibank_cap_bal.aval_bal is '可用余额';
comment on column ${icl_schema}.cmm_ibank_cap_bal.stl_dt is '结算日期';
comment on column ${icl_schema}.cmm_ibank_cap_bal.open_dt is '开仓日期';
comment on column ${icl_schema}.cmm_ibank_cap_bal.entry_org_id is '记账机构编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_ibank_cap_bal.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ibank_cap_bal.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ibank_cap_bal.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ibank_cap_bal.etl_timestamp is 'ETL处理时间戳';
