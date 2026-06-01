/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefetsbach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefetsbach
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefetsbach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefetsbach(
    bachdt varchar2(12) -- 
    ,bachsq varchar2(12) -- 
    ,bachtm varchar2(12) -- 
    ,iotype varchar2(2) -- 
    ,bachtp varchar2(3) -- 
    ,transt varchar2(2) -- 
    ,filena varchar2(120) -- 
    ,txndate varchar2(12) -- 
    ,bankdt varchar2(12) -- 
    ,bankno varchar2(18) -- 
    ,bachno varchar2(6) -- 
    ,bankcd varchar2(18) -- 
    ,tolcnt number(22) -- 
    ,tolamt number(18,2) -- 
    ,succnt number(22) -- 
    ,sucamt number(18,2) -- 
    ,failct number(22) -- 
    ,failam number(18,2) -- 
    ,magbrn varchar2(15) -- 
    ,brchno varchar2(15) -- 
    ,userid varchar2(15) -- 
    ,auttlr varchar2(15) -- 
    ,msgcode varchar2(12) -- 
    ,msgtext varchar2(150) -- 
    ,obthdt varchar2(12) -- 
    ,obthsq varchar2(12) -- 
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
grant select on ${iol_schema}.mpcs_a49tefetsbach to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefetsbach to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefetsbach to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefetsbach to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefetsbach is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.bachdt is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.bachsq is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.bachtm is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.iotype is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.bachtp is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.transt is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.filena is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.txndate is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.bankdt is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.bankno is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.bachno is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.bankcd is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.tolcnt is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.tolamt is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.succnt is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.sucamt is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.failct is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.failam is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.magbrn is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.brchno is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.userid is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.auttlr is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.msgcode is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.msgtext is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.obthdt is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.obthsq is '';
comment on column ${iol_schema}.mpcs_a49tefetsbach.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefetsbach.etl_timestamp is 'ETL处理时间戳';
