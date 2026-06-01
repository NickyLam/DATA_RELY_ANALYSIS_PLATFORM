/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_cst_limit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_cst_limit
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_cst_limit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_cst_limit(
    ccl_ecifno varchar2(32) -- 企业客户号
    ,ccl_argvalue varchar2(64) -- 属性值
    ,ccl_transdate varchar2(8) -- 交易日期
    ,ccl_amount number(15,2) -- 当前已转金额
    ,ccl_count number(22) -- 次数
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
grant select on ${iol_schema}.tbps_cpr_cst_limit to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_cst_limit to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_cst_limit to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_cst_limit to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_cst_limit is '企业客户限额记录表';
comment on column ${iol_schema}.tbps_cpr_cst_limit.ccl_ecifno is '企业客户号';
comment on column ${iol_schema}.tbps_cpr_cst_limit.ccl_argvalue is '属性值';
comment on column ${iol_schema}.tbps_cpr_cst_limit.ccl_transdate is '交易日期';
comment on column ${iol_schema}.tbps_cpr_cst_limit.ccl_amount is '当前已转金额';
comment on column ${iol_schema}.tbps_cpr_cst_limit.ccl_count is '次数';
comment on column ${iol_schema}.tbps_cpr_cst_limit.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tbps_cpr_cst_limit.etl_timestamp is 'ETL处理时间戳';
