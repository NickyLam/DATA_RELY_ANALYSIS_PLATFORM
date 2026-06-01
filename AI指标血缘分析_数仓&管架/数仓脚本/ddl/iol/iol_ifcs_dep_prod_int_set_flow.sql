/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_dep_prod_int_set_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_dep_prod_int_set_flow
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_dep_prod_int_set_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_dep_prod_int_set_flow(
    tran_flow_num varchar2(90) -- 交易流水号
    ,tran_dt varchar2(30) -- 交易日期
    ,tran_tm varchar2(32) -- 交易时间
    ,tran_type_cd varchar2(30) -- 交易类型
    ,acct_id varchar2(90) -- 账户编号
    ,dep_prod_sub_acct_id varchar2(15) -- 存款子户编号
    ,stl_pric number(30,2) -- 结算本金
    ,exec_int_rat number(18,8) -- 执行利率
    ,int number(30,2) -- 本次利息
    ,tran_status_cd varchar2(30) -- 交易处理状态代码
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
grant select on ${iol_schema}.ifcs_dep_prod_int_set_flow to ${iml_schema};
grant select on ${iol_schema}.ifcs_dep_prod_int_set_flow to ${icl_schema};
grant select on ${iol_schema}.ifcs_dep_prod_int_set_flow to ${idl_schema};
grant select on ${iol_schema}.ifcs_dep_prod_int_set_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_dep_prod_int_set_flow is '产品结息明细表';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.tran_flow_num is '交易流水号';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.tran_dt is '交易日期';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.tran_tm is '交易时间';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.tran_type_cd is '交易类型';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.acct_id is '账户编号';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.dep_prod_sub_acct_id is '存款子户编号';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.stl_pric is '结算本金';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.exec_int_rat is '执行利率';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.int is '本次利息';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.tran_status_cd is '交易处理状态代码';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_dep_prod_int_set_flow.etl_timestamp is 'ETL处理时间戳';
