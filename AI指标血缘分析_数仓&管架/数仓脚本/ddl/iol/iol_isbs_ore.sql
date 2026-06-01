/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ore
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ore
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ore purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ore(
    objtyp varchar2(9) -- 
    ,ordinr varchar2(12) -- 
    ,waidur number(10,2) -- 
    ,enddattim timestamp -- 
    ,begdattim timestamp -- 
    ,frm varchar2(12) -- 
    ,typ varchar2(5) -- 
    ,bchkeyinr varchar2(12) -- 
    ,objinr varchar2(12) -- 
    ,etyextkey varchar2(12) -- 
    ,usr varchar2(12) -- 
    ,prcdur number(10,2) -- 
    ,ssninr varchar2(12) -- 
    ,routxt varchar2(60) -- 
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
grant select on ${iol_schema}.isbs_ore to ${iml_schema};
grant select on ${iol_schema}.isbs_ore to ${icl_schema};
grant select on ${iol_schema}.isbs_ore to ${idl_schema};
grant select on ${iol_schema}.isbs_ore to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ore is '交易处理状态信息';
comment on column ${iol_schema}.isbs_ore.objtyp is '';
comment on column ${iol_schema}.isbs_ore.ordinr is '';
comment on column ${iol_schema}.isbs_ore.waidur is '';
comment on column ${iol_schema}.isbs_ore.enddattim is '';
comment on column ${iol_schema}.isbs_ore.begdattim is '';
comment on column ${iol_schema}.isbs_ore.frm is '';
comment on column ${iol_schema}.isbs_ore.typ is '';
comment on column ${iol_schema}.isbs_ore.bchkeyinr is '';
comment on column ${iol_schema}.isbs_ore.objinr is '';
comment on column ${iol_schema}.isbs_ore.etyextkey is '';
comment on column ${iol_schema}.isbs_ore.usr is '';
comment on column ${iol_schema}.isbs_ore.prcdur is '';
comment on column ${iol_schema}.isbs_ore.ssninr is '';
comment on column ${iol_schema}.isbs_ore.routxt is '';
comment on column ${iol_schema}.isbs_ore.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ore.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ore.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ore.etl_timestamp is 'ETL处理时间戳';
