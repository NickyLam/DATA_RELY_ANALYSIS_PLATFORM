/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_asyn_genealogy2
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_asyn_genealogy2
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_asyn_genealogy2 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_asyn_genealogy2(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,nodes varchar2(4000) -- nodes
    ,links varchar2(4000) -- links
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
grant select on ${iol_schema}.uxds_f_asyn_genealogy2 to ${iml_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2 to ${icl_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2 to ${idl_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2 to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_asyn_genealogy2 is '外数图谱';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2.nodes is 'nodes';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2.links is 'links';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2.etl_timestamp is 'ETL处理时间戳';
