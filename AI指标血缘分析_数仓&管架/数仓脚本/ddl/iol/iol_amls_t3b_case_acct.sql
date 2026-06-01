/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t3b_case_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t3b_case_acct
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t3b_case_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t3b_case_acct(
    is_del varchar2(2) -- 是否排除
    ,acct_id varchar2(96) -- 账户编号
    ,stat_dt date -- 数据日期
    ,cust_id varchar2(48) -- 客户编号
    ,fetr_id varchar2(18) -- 特征编号
    ,case_id varchar2(96) -- 案例编号
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
grant select on ${iol_schema}.amls_t3b_case_acct to ${iml_schema};
grant select on ${iol_schema}.amls_t3b_case_acct to ${icl_schema};
grant select on ${iol_schema}.amls_t3b_case_acct to ${idl_schema};
grant select on ${iol_schema}.amls_t3b_case_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t3b_case_acct is '可疑案例账户关系表';
comment on column ${iol_schema}.amls_t3b_case_acct.is_del is '是否排除';
comment on column ${iol_schema}.amls_t3b_case_acct.acct_id is '账户编号';
comment on column ${iol_schema}.amls_t3b_case_acct.stat_dt is '数据日期';
comment on column ${iol_schema}.amls_t3b_case_acct.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t3b_case_acct.fetr_id is '特征编号';
comment on column ${iol_schema}.amls_t3b_case_acct.case_id is '案例编号';
comment on column ${iol_schema}.amls_t3b_case_acct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t3b_case_acct.etl_timestamp is 'ETL处理时间戳';
