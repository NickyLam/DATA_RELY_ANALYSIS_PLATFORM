/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ltt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ltt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ltt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ltt(
    preperdef varchar2(216) -- 
    ,inr varchar2(12) -- 
    ,avbwthtxt varchar2(216) -- 
    ,mixdet varchar2(216) -- 
    ,rmbcha varchar2(324) -- 
    ,addamtcov varchar2(216) -- 
    ,insbnk varchar2(1188) -- 
    ,feetxt varchar2(324) -- 
    ,preperflg varchar2(2) -- 
    ,shpper varchar2(594) -- 
    ,ver varchar2(6) -- 
    ,dftat varchar2(162) -- 
    ,defdet varchar2(216) -- 
    ,preper varchar2(216) -- 
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
grant select on ${iol_schema}.isbs_ltt to ${iml_schema};
grant select on ${iol_schema}.isbs_ltt to ${icl_schema};
grant select on ${iol_schema}.isbs_ltt to ${idl_schema};
grant select on ${iol_schema}.isbs_ltt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ltt is '转让信用证业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_ltt.preperdef is '';
comment on column ${iol_schema}.isbs_ltt.inr is '';
comment on column ${iol_schema}.isbs_ltt.avbwthtxt is '';
comment on column ${iol_schema}.isbs_ltt.mixdet is '';
comment on column ${iol_schema}.isbs_ltt.rmbcha is '';
comment on column ${iol_schema}.isbs_ltt.addamtcov is '';
comment on column ${iol_schema}.isbs_ltt.insbnk is '';
comment on column ${iol_schema}.isbs_ltt.feetxt is '';
comment on column ${iol_schema}.isbs_ltt.preperflg is '';
comment on column ${iol_schema}.isbs_ltt.shpper is '';
comment on column ${iol_schema}.isbs_ltt.ver is '';
comment on column ${iol_schema}.isbs_ltt.dftat is '';
comment on column ${iol_schema}.isbs_ltt.defdet is '';
comment on column ${iol_schema}.isbs_ltt.preper is '';
comment on column ${iol_schema}.isbs_ltt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ltt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ltt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ltt.etl_timestamp is 'ETL处理时间戳';
