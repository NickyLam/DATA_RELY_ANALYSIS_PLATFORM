/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_tro
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_tro
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_tro purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_tro(
    trninr varchar2(12) -- 
    ,inr varchar2(12) -- 
    ,lstflg varchar2(2) -- 
    ,objinr varchar2(12) -- 
    ,prvinr varchar2(12) -- 
    ,objtyp varchar2(9) -- 
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
grant select on ${iol_schema}.isbs_tro to ${iml_schema};
grant select on ${iol_schema}.isbs_tro to ${icl_schema};
grant select on ${iol_schema}.isbs_tro to ${idl_schema};
grant select on ${iol_schema}.isbs_tro to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_tro is '交易关联信息';
comment on column ${iol_schema}.isbs_tro.trninr is '';
comment on column ${iol_schema}.isbs_tro.inr is '';
comment on column ${iol_schema}.isbs_tro.lstflg is '';
comment on column ${iol_schema}.isbs_tro.objinr is '';
comment on column ${iol_schema}.isbs_tro.prvinr is '';
comment on column ${iol_schema}.isbs_tro.objtyp is '';
comment on column ${iol_schema}.isbs_tro.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_tro.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_tro.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_tro.etl_timestamp is 'ETL处理时间戳';
