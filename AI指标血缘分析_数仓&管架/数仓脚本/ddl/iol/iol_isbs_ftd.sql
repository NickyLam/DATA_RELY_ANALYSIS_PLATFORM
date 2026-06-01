/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ftd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ftd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ftd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ftd(
    nam varchar2(60) -- 
    ,inr varchar2(12) -- 
    ,ownref varchar2(24) -- 
    ,valdat date -- 
    ,rat number(12,6) -- 
    ,cnfdat date -- 
    ,branchinr varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,fttyp varchar2(3) -- 
    ,zjtyp varchar2(3) -- 
    ,zjtyp1 varchar2(3) -- 
    ,cntfra varchar2(11) -- 
    ,usr varchar2(12) -- 
    ,ownusr varchar2(12) -- 
    ,clsdat date -- 
    ,bchkeyinr varchar2(12) -- 
    ,matdat date -- 
    ,opndat date -- 
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
grant select on ${iol_schema}.isbs_ftd to ${iml_schema};
grant select on ${iol_schema}.isbs_ftd to ${icl_schema};
grant select on ${iol_schema}.isbs_ftd to ${idl_schema};
grant select on ${iol_schema}.isbs_ftd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ftd is '资金定存拆借及头寸调拨业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_ftd.nam is '';
comment on column ${iol_schema}.isbs_ftd.inr is '';
comment on column ${iol_schema}.isbs_ftd.ownref is '';
comment on column ${iol_schema}.isbs_ftd.valdat is '';
comment on column ${iol_schema}.isbs_ftd.rat is '';
comment on column ${iol_schema}.isbs_ftd.cnfdat is '';
comment on column ${iol_schema}.isbs_ftd.branchinr is '';
comment on column ${iol_schema}.isbs_ftd.ver is '';
comment on column ${iol_schema}.isbs_ftd.fttyp is '';
comment on column ${iol_schema}.isbs_ftd.zjtyp is '';
comment on column ${iol_schema}.isbs_ftd.zjtyp1 is '';
comment on column ${iol_schema}.isbs_ftd.cntfra is '';
comment on column ${iol_schema}.isbs_ftd.usr is '';
comment on column ${iol_schema}.isbs_ftd.ownusr is '';
comment on column ${iol_schema}.isbs_ftd.clsdat is '';
comment on column ${iol_schema}.isbs_ftd.bchkeyinr is '';
comment on column ${iol_schema}.isbs_ftd.matdat is '';
comment on column ${iol_schema}.isbs_ftd.opndat is '';
comment on column ${iol_schema}.isbs_ftd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ftd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ftd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ftd.etl_timestamp is 'ETL处理时间戳';
