/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tets202bach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tets202bach
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tets202bach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tets202bach(
    bachdt varchar2(12) -- 
    ,bachsq varchar2(12) -- 
    ,bachtm varchar2(12) -- 
    ,bachtp varchar2(3) -- 
    ,filena varchar2(120) -- 
    ,txndate varchar2(12) -- 
    ,bankno varchar2(18) -- 
    ,tolcnt number(22) -- 
    ,tolamt number(18,2) -- 
    ,logact varchar2(15) -- 
    ,logadt varchar2(12) -- 
    ,sdfile varchar2(18) -- 
    ,rvfile varchar2(18) -- 
    ,magbrn varchar2(15) -- 
    ,brchno varchar2(15) -- 
    ,userid varchar2(15) -- 
    ,status varchar2(2) -- 
    ,errmsg varchar2(768) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a49tets202bach to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tets202bach to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tets202bach to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tets202bach to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tets202bach is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.bachdt is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.bachsq is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.bachtm is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.bachtp is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.filena is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.txndate is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.bankno is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.tolcnt is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.tolamt is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.logact is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.logadt is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.sdfile is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.rvfile is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.magbrn is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.brchno is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.userid is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.status is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.errmsg is '';
comment on column ${iol_schema}.mpcs_a49tets202bach.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tets202bach.etl_timestamp is 'ETL处理时间戳';
