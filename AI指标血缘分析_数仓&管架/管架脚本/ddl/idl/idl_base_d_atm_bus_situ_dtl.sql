/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl base_d_atm_bus_situ_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.base_d_atm_bus_situ_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.base_d_atm_bus_situ_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_atm_bus_situ_dtl(
    tran_type varchar2(30) -- 交易类型
    ,cross_bank_idf varchar2(10) -- 跨行标识
    ,tran_tm date -- 交易时间
    ,tran_org_cd varchar2(20) -- 交易机构代码
    ,tran_amt number(38,8) -- 交易金额
    ,proc_termn_id varchar2(20) -- 受理终端编号
    ,cust_id varchar2(30) -- 客户编号
    ,cust_name varchar2(100) -- 客户名称
    ,open_acct_org varchar2(20) -- 开户机构
    ,main_acct_id varchar2(100) -- 主账户编号
    ,expns_acct_id varchar2(100) -- 支出账户编号
    ,depot_acct_id varchar2(100) -- 存入账户编号
    ,city_wide_remote_idf varchar2(10) -- 同城异地标识
    ,dim_class varchar2(100) -- 交易类型分类(管驾用)
    ,dim_class_name varchar2(100) -- 交易类型分类名称(管驾用)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.base_d_atm_bus_situ_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.base_d_atm_bus_situ_dtl is 'ATM业务情况明细';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.tran_type is '交易类型';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.cross_bank_idf is '跨行标识';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.tran_tm is '交易时间';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.tran_org_cd is '交易机构代码';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.tran_amt is '交易金额';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.proc_termn_id is '受理终端编号';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.cust_id is '客户编号';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.cust_name is '客户名称';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.open_acct_org is '开户机构';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.main_acct_id is '主账户编号';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.expns_acct_id is '支出账户编号';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.depot_acct_id is '存入账户编号';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.city_wide_remote_idf is '同城异地标识';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.dim_class is '交易类型分类(管驾用)';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.dim_class_name is '交易类型分类名称(管驾用)';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.base_d_atm_bus_situ_dtl.etl_timestamp is 'ETL处理时间戳';