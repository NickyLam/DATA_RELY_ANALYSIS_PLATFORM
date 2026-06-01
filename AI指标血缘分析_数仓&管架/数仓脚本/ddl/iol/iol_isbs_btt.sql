/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_btt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_btt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_btt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_btt(
    setinsbt varchar2(1980) -- 
    ,be2ins varchar2(990) -- 
    ,disdoc varchar2(162) -- 
    ,docdisdef varchar2(4000) -- 
    ,comcon varchar2(990) -- 
    ,chaded varchar2(324) -- 
    ,benref varchar2(255) -- 
    ,intdis varchar2(1980) -- 
    ,matper varchar2(99) -- 
    ,inr varchar2(12) -- 
    ,docins varchar2(270) -- 
    ,docdis varchar2(4000) -- 
    ,nartxt77a varchar2(1080) -- 
    ,docdisflg varchar2(2) -- 
    ,chaadd varchar2(324) -- 
    ,be1ins varchar2(990) -- 
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
grant select on ${iol_schema}.isbs_btt to ${iml_schema};
grant select on ${iol_schema}.isbs_btt to ${icl_schema};
grant select on ${iol_schema}.isbs_btt to ${idl_schema};
grant select on ${iol_schema}.isbs_btt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_btt is '转让信用证下单据信息(存放长字节)';
comment on column ${iol_schema}.isbs_btt.setinsbt is '';
comment on column ${iol_schema}.isbs_btt.be2ins is '';
comment on column ${iol_schema}.isbs_btt.disdoc is '';
comment on column ${iol_schema}.isbs_btt.docdisdef is '';
comment on column ${iol_schema}.isbs_btt.comcon is '';
comment on column ${iol_schema}.isbs_btt.chaded is '';
comment on column ${iol_schema}.isbs_btt.benref is '';
comment on column ${iol_schema}.isbs_btt.intdis is '';
comment on column ${iol_schema}.isbs_btt.matper is '';
comment on column ${iol_schema}.isbs_btt.inr is '';
comment on column ${iol_schema}.isbs_btt.docins is '';
comment on column ${iol_schema}.isbs_btt.docdis is '';
comment on column ${iol_schema}.isbs_btt.nartxt77a is '';
comment on column ${iol_schema}.isbs_btt.docdisflg is '';
comment on column ${iol_schema}.isbs_btt.chaadd is '';
comment on column ${iol_schema}.isbs_btt.be1ins is '';
comment on column ${iol_schema}.isbs_btt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_btt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_btt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_btt.etl_timestamp is 'ETL处理时间戳';
