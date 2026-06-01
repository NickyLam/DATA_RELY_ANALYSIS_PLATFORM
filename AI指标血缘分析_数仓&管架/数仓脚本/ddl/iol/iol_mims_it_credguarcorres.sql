/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_it_credguarcorres
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_it_credguarcorres
whenever sqlerror continue none;
drop table ${iol_schema}.mims_it_credguarcorres purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_it_credguarcorres(
    credno varchar2(60) -- 
    ,guarno varchar2(48) -- 
    ,guartype varchar2(30) -- 
    ,guarrate number(16,2) -- 
    ,guarorder varchar2(2) -- 
    ,guarperiod number(22) -- 
    ,datasourceflag varchar2(2) -- 
    ,barsign varchar2(2) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mims_it_credguarcorres to ${iml_schema};
grant select on ${iol_schema}.mims_it_credguarcorres to ${icl_schema};
grant select on ${iol_schema}.mims_it_credguarcorres to ${idl_schema};
grant select on ${iol_schema}.mims_it_credguarcorres to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_it_credguarcorres is '借据与押品对应表';
comment on column ${iol_schema}.mims_it_credguarcorres.credno is '';
comment on column ${iol_schema}.mims_it_credguarcorres.guarno is '';
comment on column ${iol_schema}.mims_it_credguarcorres.guartype is '';
comment on column ${iol_schema}.mims_it_credguarcorres.guarrate is '';
comment on column ${iol_schema}.mims_it_credguarcorres.guarorder is '';
comment on column ${iol_schema}.mims_it_credguarcorres.guarperiod is '';
comment on column ${iol_schema}.mims_it_credguarcorres.datasourceflag is '';
comment on column ${iol_schema}.mims_it_credguarcorres.barsign is '';
comment on column ${iol_schema}.mims_it_credguarcorres.start_dt is '开始时间';
comment on column ${iol_schema}.mims_it_credguarcorres.end_dt is '结束时间';
comment on column ${iol_schema}.mims_it_credguarcorres.id_mark is '增删标志';
comment on column ${iol_schema}.mims_it_credguarcorres.etl_timestamp is 'ETL处理时间戳';
