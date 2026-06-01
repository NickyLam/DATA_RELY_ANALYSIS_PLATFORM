/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_agt_ext_cap_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_agt_ext_cap_acct
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_agt_ext_cap_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_agt_ext_cap_acct(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_name varchar2(100) -- 账户名称
    ,tran_market_id varchar2(60) -- 交易市场编号
    ,exchg_acct_id varchar2(60) -- 交易所账户编号
    ,curr_cd varchar2(10) -- 币种代码
    ,open_acct_bank_no varchar2(60) -- 开户银行行号
    ,open_acct_bank_name varchar2(100) -- 开户银行名称
    ,open_acct_dt date -- 开户日期
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(100) -- 交易对手名称
    ,intnal_cap_acct_num varchar2(60) -- 内部资金账号
    ,cap_acct_type_cd varchar2(100) -- 资金账户类型代码
    ,intnal_acct_num varchar2(60) -- 内部账号
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,intnal_acct_name varchar2(100) -- 内部账名称
    ,src_pay_int_ped_cd varchar2(10) -- 源付息周期代码
    ,pay_int_ped_corp_cd varchar2(10) -- 付息周期单位代码
    ,pay_int_ped_freq varchar2(10) -- 付息周期频率
    ,int_rat_def_id varchar2(60) -- 利率定义编号
    ,cap_type_cd varchar2(10) -- 资金类型代码
    ,pay_mon number(18,0) -- 支付月份
    ,pay_days number(18,0) -- 支付天数
    ,int_rat number(18,8) -- 利率
    ,clos_acct_dt date -- 销户日期
    ,prod_type_id varchar2(60) -- 产品类型编号
    ,prod_cls_name varchar2(100) -- 产品分类名称
    ,subj_id varchar2(60) -- 科目编号
    ,swift_cd varchar2(30) -- SWIFT代码
    ,belong_org_id varchar2(60) -- 所属机构编号
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
grant select on ${idl_schema}.icrm_agt_ext_cap_acct to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_agt_ext_cap_acct is '外部资金账户';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.agt_id is '协议编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.acct_id is '账户编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.acct_name is '账户名称';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.tran_market_id is '交易市场编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.exchg_acct_id is '交易所账户编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.open_acct_bank_no is '开户银行行号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.open_acct_bank_name is '开户银行名称';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.open_acct_dt is '开户日期';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.cntpty_id is '交易对手编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.cntpty_name is '交易对手名称';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.intnal_cap_acct_num is '内部资金账号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.cap_acct_type_cd is '资金账户类型代码';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.intnal_acct_num is '内部账号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.entry_org_id is '记账机构编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.intnal_acct_name is '内部账名称';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.src_pay_int_ped_cd is '源付息周期代码';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.pay_int_ped_corp_cd is '付息周期单位代码';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.pay_int_ped_freq is '付息周期频率';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.int_rat_def_id is '利率定义编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.cap_type_cd is '资金类型代码';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.pay_mon is '支付月份';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.pay_days is '支付天数';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.int_rat is '利率';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.clos_acct_dt is '销户日期';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.prod_type_id is '产品类型编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.prod_cls_name is '产品分类名称';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.subj_id is '科目编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.swift_cd is 'SWIFT代码';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_agt_ext_cap_acct.etl_timestamp is '数据处理时间';
