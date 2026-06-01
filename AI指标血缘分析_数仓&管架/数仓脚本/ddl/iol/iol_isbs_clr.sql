/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_clr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_clr
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_clr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_clr(
    credat date -- 
    ,amt number(18,3) -- 
    ,ownref varchar2(24) -- 
    ,trntyp varchar2(2) -- 
    ,opndat date -- 
    ,bchkeyinr varchar2(12) -- 
    ,sta varchar2(2) -- 
    ,srcinr varchar2(12) -- 
    ,sndptyinr varchar2(12) -- 
    ,ownusr varchar2(12) -- 
    ,cur varchar2(5) -- 
    ,smhinr varchar2(12) -- 
    ,nam varchar2(60) -- 
    ,selconfrm varchar2(18) -- 
    ,errmsg varchar2(246) -- 
    ,clsdat date -- 
    ,inr varchar2(12) -- 
    ,srctyp varchar2(5) -- 
    ,selconref varchar2(30) -- 
    ,bussec varchar2(5) -- 
    ,ver varchar2(6) -- 
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
grant select on ${iol_schema}.isbs_clr to ${iml_schema};
grant select on ${iol_schema}.isbs_clr to ${icl_schema};
grant select on ${iol_schema}.isbs_clr to ${idl_schema};
grant select on ${iol_schema}.isbs_clr to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_clr is '清算业务表，有数据';
comment on column ${iol_schema}.isbs_clr.credat is '';
comment on column ${iol_schema}.isbs_clr.amt is '';
comment on column ${iol_schema}.isbs_clr.ownref is '';
comment on column ${iol_schema}.isbs_clr.trntyp is '';
comment on column ${iol_schema}.isbs_clr.opndat is '';
comment on column ${iol_schema}.isbs_clr.bchkeyinr is '';
comment on column ${iol_schema}.isbs_clr.sta is '';
comment on column ${iol_schema}.isbs_clr.srcinr is '';
comment on column ${iol_schema}.isbs_clr.sndptyinr is '';
comment on column ${iol_schema}.isbs_clr.ownusr is '';
comment on column ${iol_schema}.isbs_clr.cur is '';
comment on column ${iol_schema}.isbs_clr.smhinr is '';
comment on column ${iol_schema}.isbs_clr.nam is '';
comment on column ${iol_schema}.isbs_clr.selconfrm is '';
comment on column ${iol_schema}.isbs_clr.errmsg is '';
comment on column ${iol_schema}.isbs_clr.clsdat is '';
comment on column ${iol_schema}.isbs_clr.inr is '';
comment on column ${iol_schema}.isbs_clr.srctyp is '';
comment on column ${iol_schema}.isbs_clr.selconref is '';
comment on column ${iol_schema}.isbs_clr.bussec is '';
comment on column ${iol_schema}.isbs_clr.ver is '';
comment on column ${iol_schema}.isbs_clr.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_clr.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_clr.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_clr.etl_timestamp is 'ETL处理时间戳';
