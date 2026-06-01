/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tappdgkzjdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tappdgkzjdetail
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tappdgkzjdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tappdgkzjdetail(
    cmtno varchar2(30) -- 
    ,bustype varchar2(8) -- 
    ,servtype varchar2(18) -- 
    ,transdt varchar2(12) -- 
    ,businesstrace varchar2(24) -- 
    ,flownumber varchar2(30) -- 
    ,gktypecode varchar2(18) -- 
    ,gksubjectcode varchar2(30) -- 
    ,gkdtlamount varchar2(26) -- 
    ,gkaccrualcode varchar2(18) -- 
    ,gkaccrualamount varchar2(26) -- 
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
grant select on ${iol_schema}.mpcs_a08tappdgkzjdetail to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tappdgkzjdetail to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tappdgkzjdetail to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tappdgkzjdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tappdgkzjdetail is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.cmtno is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.bustype is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.servtype is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.transdt is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.businesstrace is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.flownumber is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.gktypecode is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.gksubjectcode is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.gkdtlamount is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.gkaccrualcode is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.gkaccrualamount is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.syscd is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tappdgkzjdetail.etl_timestamp is 'ETL处理时间戳';
