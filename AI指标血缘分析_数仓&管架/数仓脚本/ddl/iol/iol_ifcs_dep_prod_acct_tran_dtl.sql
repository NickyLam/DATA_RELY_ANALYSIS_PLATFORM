/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_dep_prod_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_dep_prod_acct_tran_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_dep_prod_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_dep_prod_acct_tran_dtl(
    tran_flow_num varchar2(90) -- 交易流水号
    ,acct_id varchar2(90) -- 账户编号
    ,dep_prod_sub_acct_id varchar2(15) -- 存款子户编号
    ,cust_id varchar2(90) -- 客户编号
    ,ext_prod_id varchar2(150) -- 外部产品代码
    ,tran_dt varchar2(30) -- 交易日期
    ,tran_tm varchar2(32) -- 交易时间
    ,tran_type_cd varchar2(30) -- 交易类型
    ,tran_chn_cd varchar2(90) -- 交易渠道编号
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_org_id varchar2(30) -- 交易机构编号
    ,call_sys_id varchar2(90) -- 调用系统编号
    ,debit_crdt_dir_cd varchar2(3) -- 借贷方向
    ,tran_amt number(18,2) -- 交易金额
    ,cntpty_acct_id varchar2(90) -- 交易对手方账号
    ,cntpty_name varchar2(150) -- 交易对手方账名
    ,cntpty_org_id varchar2(30) -- 交易对手方机构编号
    ,rec_bal number(18,2) -- 存单余额
    ,provi_flg varchar2(3) -- 计提标志
    ,provi_tm varchar2(32) -- 计提时间
    ,ext_flow_num varchar2(90) -- 外部流水号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifcs_dep_prod_acct_tran_dtl to ${iml_schema};
grant select on ${iol_schema}.ifcs_dep_prod_acct_tran_dtl to ${icl_schema};
grant select on ${iol_schema}.ifcs_dep_prod_acct_tran_dtl to ${idl_schema};
grant select on ${iol_schema}.ifcs_dep_prod_acct_tran_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_dep_prod_acct_tran_dtl is '账户交易明细表';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.acct_id is '账户编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.dep_prod_sub_acct_id is '存款子户编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.cust_id is '客户编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.ext_prod_id is '外部产品代码';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.tran_dt is '交易日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.tran_tm is '交易时间';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.tran_type_cd is '交易类型';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.tran_chn_cd is '交易渠道编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.tran_status_cd is '交易状态代码';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.call_sys_id is '调用系统编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.debit_crdt_dir_cd is '借贷方向';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.tran_amt is '交易金额';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.cntpty_acct_id is '交易对手方账号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.cntpty_name is '交易对手方账名';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.cntpty_org_id is '交易对手方机构编号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.rec_bal is '存单余额';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.provi_flg is '计提标志';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.provi_tm is '计提时间';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.ext_flow_num is '外部流水号';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_dep_prod_acct_tran_dtl.etl_timestamp is 'ETL处理时间戳';
