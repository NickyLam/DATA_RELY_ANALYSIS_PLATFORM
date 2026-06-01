/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ptl_capacct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ptl_capacct_info
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ptl_capacct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_capacct_info(
    portfolio_id varchar2(64) -- 账套代码
    ,acct_no varchar2(100) -- 账户账号，存网点账号
    ,ccy varchar2(100) -- 币种
    ,acct_type varchar2(100) -- 资金账户类型
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_ptl_capacct_info to ${iml_schema};
grant select on ${iol_schema}.fams_ptl_capacct_info to ${icl_schema};
grant select on ${iol_schema}.fams_ptl_capacct_info to ${idl_schema};
grant select on ${iol_schema}.fams_ptl_capacct_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ptl_capacct_info is '资金账户';
comment on column ${iol_schema}.fams_ptl_capacct_info.portfolio_id is '账套代码';
comment on column ${iol_schema}.fams_ptl_capacct_info.acct_no is '账户账号，存网点账号';
comment on column ${iol_schema}.fams_ptl_capacct_info.ccy is '币种';
comment on column ${iol_schema}.fams_ptl_capacct_info.acct_type is '资金账户类型';
comment on column ${iol_schema}.fams_ptl_capacct_info.create_user is '创建人';
comment on column ${iol_schema}.fams_ptl_capacct_info.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ptl_capacct_info.create_time is '创建时间';
comment on column ${iol_schema}.fams_ptl_capacct_info.update_user is '更新人';
comment on column ${iol_schema}.fams_ptl_capacct_info.update_time is '更新时间';
comment on column ${iol_schema}.fams_ptl_capacct_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_ptl_capacct_info.etl_timestamp is 'ETL处理时间戳';
