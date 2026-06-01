/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ord
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ord
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ord purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ord(
    totdur number(10,2) -- 
    ,bchkeyinr varchar2(12) -- 
    ,sta varchar2(5) -- 
    ,extkey varchar2(48) -- 
    ,branchinr varchar2(12) -- 
    ,etyextkey varchar2(12) -- 
    ,inr varchar2(12) -- 
    ,inftxt varchar2(396) -- 
    ,cpldattim timestamp -- 
    ,smhinr varchar2(12) -- 
    ,chkflg varchar2(2) -- 
    ,ownusg varchar2(9) -- 
    ,objtyp varchar2(9) -- 
    ,nam varchar2(60) -- 
    ,stadattim timestamp -- 
    ,tardattim timestamp -- 
    ,slacla varchar2(5) -- 
    ,ptainr varchar2(12) -- 
    ,inidattim timestamp -- 
    ,infdsp varchar2(2) -- 
    ,frm varchar2(9) -- 
    ,etgextkey varchar2(12) -- 
    ,sdhflg varchar2(2) -- 
    ,ownusr varchar2(12) -- 
    ,objinr varchar2(12) -- 
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
grant select on ${iol_schema}.isbs_ord to ${iml_schema};
grant select on ${iol_schema}.isbs_ord to ${icl_schema};
grant select on ${iol_schema}.isbs_ord to ${idl_schema};
grant select on ${iol_schema}.isbs_ord to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ord is '交易概要信息';
comment on column ${iol_schema}.isbs_ord.totdur is '';
comment on column ${iol_schema}.isbs_ord.bchkeyinr is '';
comment on column ${iol_schema}.isbs_ord.sta is '';
comment on column ${iol_schema}.isbs_ord.extkey is '';
comment on column ${iol_schema}.isbs_ord.branchinr is '';
comment on column ${iol_schema}.isbs_ord.etyextkey is '';
comment on column ${iol_schema}.isbs_ord.inr is '';
comment on column ${iol_schema}.isbs_ord.inftxt is '';
comment on column ${iol_schema}.isbs_ord.cpldattim is '';
comment on column ${iol_schema}.isbs_ord.smhinr is '';
comment on column ${iol_schema}.isbs_ord.chkflg is '';
comment on column ${iol_schema}.isbs_ord.ownusg is '';
comment on column ${iol_schema}.isbs_ord.objtyp is '';
comment on column ${iol_schema}.isbs_ord.nam is '';
comment on column ${iol_schema}.isbs_ord.stadattim is '';
comment on column ${iol_schema}.isbs_ord.tardattim is '';
comment on column ${iol_schema}.isbs_ord.slacla is '';
comment on column ${iol_schema}.isbs_ord.ptainr is '';
comment on column ${iol_schema}.isbs_ord.inidattim is '';
comment on column ${iol_schema}.isbs_ord.infdsp is '';
comment on column ${iol_schema}.isbs_ord.frm is '';
comment on column ${iol_schema}.isbs_ord.etgextkey is '';
comment on column ${iol_schema}.isbs_ord.sdhflg is '';
comment on column ${iol_schema}.isbs_ord.ownusr is '';
comment on column ${iol_schema}.isbs_ord.objinr is '';
comment on column ${iol_schema}.isbs_ord.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ord.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ord.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ord.etl_timestamp is 'ETL处理时间戳';
