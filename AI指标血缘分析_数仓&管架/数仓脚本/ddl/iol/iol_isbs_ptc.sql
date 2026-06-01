/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ptc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ptc
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ptc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ptc(
    telfax varchar2(30) -- 
    ,gen varchar2(15) -- 
    ,eml varchar2(120) -- 
    ,legrep varchar2(30) -- 
    ,etgextkey varchar2(12) -- 
    ,telmob varchar2(30) -- 
    ,ver varchar2(6) -- 
    ,telfac varchar2(30) -- 
    ,ptyinr varchar2(12) -- 
    ,biddat date -- 
    ,teloff varchar2(30) -- 
    ,dep varchar2(53) -- 
    ,ptainr varchar2(12) -- 
    ,eno varchar2(5) -- 
    ,inr varchar2(12) -- 
    ,signup varchar2(2) -- 
    ,nam varchar2(53) -- 
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
grant select on ${iol_schema}.isbs_ptc to ${iml_schema};
grant select on ${iol_schema}.isbs_ptc to ${icl_schema};
grant select on ${iol_schema}.isbs_ptc to ${idl_schema};
grant select on ${iol_schema}.isbs_ptc to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ptc is '具体联系人信息';
comment on column ${iol_schema}.isbs_ptc.telfax is '';
comment on column ${iol_schema}.isbs_ptc.gen is '';
comment on column ${iol_schema}.isbs_ptc.eml is '';
comment on column ${iol_schema}.isbs_ptc.legrep is '';
comment on column ${iol_schema}.isbs_ptc.etgextkey is '';
comment on column ${iol_schema}.isbs_ptc.telmob is '';
comment on column ${iol_schema}.isbs_ptc.ver is '';
comment on column ${iol_schema}.isbs_ptc.telfac is '';
comment on column ${iol_schema}.isbs_ptc.ptyinr is '';
comment on column ${iol_schema}.isbs_ptc.biddat is '';
comment on column ${iol_schema}.isbs_ptc.teloff is '';
comment on column ${iol_schema}.isbs_ptc.dep is '';
comment on column ${iol_schema}.isbs_ptc.ptainr is '';
comment on column ${iol_schema}.isbs_ptc.eno is '';
comment on column ${iol_schema}.isbs_ptc.inr is '';
comment on column ${iol_schema}.isbs_ptc.signup is '';
comment on column ${iol_schema}.isbs_ptc.nam is '';
comment on column ${iol_schema}.isbs_ptc.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ptc.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ptc.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ptc.etl_timestamp is 'ETL处理时间戳';
