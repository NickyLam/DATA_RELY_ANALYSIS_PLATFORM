/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_trm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_trm
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_trm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_trm(
    trmtyp varchar2(9) -- 
    ,acttrmcod varchar2(15) -- 
    ,nam varchar2(60) -- 
    ,trmcod varchar2(6) -- 
    ,num varchar2(11) -- 
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
grant select on ${iol_schema}.isbs_trm to ${iml_schema};
grant select on ${iol_schema}.isbs_trm to ${icl_schema};
grant select on ${iol_schema}.isbs_trm to ${idl_schema};
grant select on ${iol_schema}.isbs_trm to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_trm is '科目类型';
comment on column ${iol_schema}.isbs_trm.trmtyp is '';
comment on column ${iol_schema}.isbs_trm.acttrmcod is '';
comment on column ${iol_schema}.isbs_trm.nam is '';
comment on column ${iol_schema}.isbs_trm.trmcod is '';
comment on column ${iol_schema}.isbs_trm.num is '';
comment on column ${iol_schema}.isbs_trm.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_trm.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_trm.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_trm.etl_timestamp is 'ETL处理时间戳';
