/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_etauil
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_etauil
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_etauil purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_etauil(
    etainr varchar2(12) -- 
    ,letstr varchar2(53) -- 
    ,tfsstr varchar2(53) -- 
    ,letloc varchar2(53) -- 
    ,tfsloc varchar2(53) -- 
    ,tfsnam varchar2(53) -- 
    ,letbox varchar2(53) -- 
    ,fthdet varchar2(540) -- 
    ,letzip varchar2(15) -- 
    ,tfsbox varchar2(53) -- 
    ,tfszip varchar2(15) -- 
    ,pobzip varchar2(15) -- 
    ,brdsup varchar2(540) -- 
    ,vatnum varchar2(540) -- 
    ,pobloc varchar2(53) -- 
    ,regoff varchar2(540) -- 
    ,uil varchar2(3) -- 
    ,brddir varchar2(540) -- 
    ,letnam varchar2(53) -- 
    ,etgadr varchar2(540) -- 
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
grant select on ${iol_schema}.isbs_etauil to ${iml_schema};
grant select on ${iol_schema}.isbs_etauil to ${icl_schema};
grant select on ${iol_schema}.isbs_etauil to ${idl_schema};
grant select on ${iol_schema}.isbs_etauil to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_etauil is '不同用户界面语言的实体地址';
comment on column ${iol_schema}.isbs_etauil.etainr is '';
comment on column ${iol_schema}.isbs_etauil.letstr is '';
comment on column ${iol_schema}.isbs_etauil.tfsstr is '';
comment on column ${iol_schema}.isbs_etauil.letloc is '';
comment on column ${iol_schema}.isbs_etauil.tfsloc is '';
comment on column ${iol_schema}.isbs_etauil.tfsnam is '';
comment on column ${iol_schema}.isbs_etauil.letbox is '';
comment on column ${iol_schema}.isbs_etauil.fthdet is '';
comment on column ${iol_schema}.isbs_etauil.letzip is '';
comment on column ${iol_schema}.isbs_etauil.tfsbox is '';
comment on column ${iol_schema}.isbs_etauil.tfszip is '';
comment on column ${iol_schema}.isbs_etauil.pobzip is '';
comment on column ${iol_schema}.isbs_etauil.brdsup is '';
comment on column ${iol_schema}.isbs_etauil.vatnum is '';
comment on column ${iol_schema}.isbs_etauil.pobloc is '';
comment on column ${iol_schema}.isbs_etauil.regoff is '';
comment on column ${iol_schema}.isbs_etauil.uil is '';
comment on column ${iol_schema}.isbs_etauil.brddir is '';
comment on column ${iol_schema}.isbs_etauil.letnam is '';
comment on column ${iol_schema}.isbs_etauil.etgadr is '';
comment on column ${iol_schema}.isbs_etauil.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_etauil.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_etauil.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_etauil.etl_timestamp is 'ETL处理时间戳';
