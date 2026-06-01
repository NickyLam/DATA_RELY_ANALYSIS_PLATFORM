/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_trs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_trs
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_trs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_trs(
    sigidx varchar2(8) -- 
    ,flg varchar2(2) -- 
    ,nam varchar2(60) -- 
    ,etyextkey varchar2(12) -- 
    ,ssninr varchar2(12) -- 
    ,objinr varchar2(12) -- 
    ,inr varchar2(12) -- 
    ,objtyp varchar2(9) -- 
    ,dattim timestamp -- 
    ,usr varchar2(12) -- 
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
grant select on ${iol_schema}.isbs_trs to ${iml_schema};
grant select on ${iol_schema}.isbs_trs to ${icl_schema};
grant select on ${iol_schema}.isbs_trs to ${idl_schema};
grant select on ${iol_schema}.isbs_trs to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_trs is '复核信息';
comment on column ${iol_schema}.isbs_trs.sigidx is '';
comment on column ${iol_schema}.isbs_trs.flg is '';
comment on column ${iol_schema}.isbs_trs.nam is '';
comment on column ${iol_schema}.isbs_trs.etyextkey is '';
comment on column ${iol_schema}.isbs_trs.ssninr is '';
comment on column ${iol_schema}.isbs_trs.objinr is '';
comment on column ${iol_schema}.isbs_trs.inr is '';
comment on column ${iol_schema}.isbs_trs.objtyp is '';
comment on column ${iol_schema}.isbs_trs.dattim is '';
comment on column ${iol_schema}.isbs_trs.usr is '';
comment on column ${iol_schema}.isbs_trs.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_trs.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_trs.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_trs.etl_timestamp is 'ETL处理时间戳';
