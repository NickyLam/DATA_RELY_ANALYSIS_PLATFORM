/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tappdcshp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tappdcshp
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tappdcshp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tappdcshp(
    cmtno varchar2(30) -- 
    ,bustype varchar2(8) -- 
    ,servtype varchar2(18) -- 
    ,transdt varchar2(12) -- 
    ,businesstrace varchar2(24) -- 
    ,cshpbillnb varchar2(30) -- 
    ,cshpbilldate varchar2(12) -- 
    ,cshpbillsign varchar2(15) -- 
    ,cshpbillamt varchar2(26) -- 
    ,cshpsignbkno varchar2(21) -- 
    ,cshpapplyacct varchar2(48) -- 
    ,cshpapplynm varchar2(180) -- 
    ,cshpbilltype varchar2(15) -- 
    ,cshprecvacctnm varchar2(180) -- 
    ,cshpcashbkno varchar2(21) -- 
    ,cshpbalance varchar2(26) -- 
    ,cshplastopenbkno varchar2(21) -- 
    ,cshplastacct varchar2(48) -- 
    ,cshplastname varchar2(180) -- 
    ,cshpsettleamt varchar2(26) -- 
    ,cshppaydate varchar2(12) -- 
    ,syscd varchar2(6) -- 
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
grant select on ${iol_schema}.mpcs_a08tappdcshp to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tappdcshp to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tappdcshp to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tappdcshp to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tappdcshp is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cmtno is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.bustype is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.servtype is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.transdt is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.businesstrace is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpbillnb is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpbilldate is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpbillsign is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpbillamt is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpsignbkno is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpapplyacct is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpapplynm is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpbilltype is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshprecvacctnm is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpcashbkno is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpbalance is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshplastopenbkno is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshplastacct is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshplastname is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshpsettleamt is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.cshppaydate is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.syscd is '';
comment on column ${iol_schema}.mpcs_a08tappdcshp.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tappdcshp.etl_timestamp is 'ETL处理时间戳';
