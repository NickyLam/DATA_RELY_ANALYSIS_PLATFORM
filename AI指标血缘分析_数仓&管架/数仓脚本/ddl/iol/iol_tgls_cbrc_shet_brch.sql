/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_shet_brch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_shet_brch
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_shet_brch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_shet_brch(
    shetcd varchar2(16) -- 报表编号
    ,brchcd varchar2(12) -- 机构编号
    ,stacid number(19) -- 账套
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
grant select on ${iol_schema}.tgls_cbrc_shet_brch to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_brch to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_brch to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_brch to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_shet_brch is '报表机构关系表';
comment on column ${iol_schema}.tgls_cbrc_shet_brch.shetcd is '报表编号';
comment on column ${iol_schema}.tgls_cbrc_shet_brch.brchcd is '机构编号';
comment on column ${iol_schema}.tgls_cbrc_shet_brch.stacid is '账套';
comment on column ${iol_schema}.tgls_cbrc_shet_brch.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_cbrc_shet_brch.etl_timestamp is 'ETL处理时间戳';
