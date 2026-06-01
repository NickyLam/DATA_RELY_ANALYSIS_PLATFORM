/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tappdgkzj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tappdgkzj
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tappdgkzj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tappdgkzj(
    cmtno varchar2(30) -- 
    ,bustype varchar2(9) -- 
    ,servtype varchar2(18) -- 
    ,transdt varchar2(12) -- 
    ,businesstrace varchar2(24) -- 
    ,flownumber varchar2(30) -- 
    ,fsamount varchar2(26) -- 
    ,reportcode varchar2(15) -- 
    ,receivecode varchar2(15) -- 
    ,reportforms varchar2(12) -- 
    ,reportnumber varchar2(15) -- 
    ,gkdjbudgetlevel varchar2(6) -- 
    ,gkdjindicator varchar2(6) -- 
    ,gkdjbudgettype varchar2(6) -- 
    ,gkdjnboftxs varchar2(12) -- 
    ,appenddatadtltab varchar2(45) -- 
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
grant select on ${iol_schema}.mpcs_a08tappdgkzj to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tappdgkzj to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tappdgkzj to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tappdgkzj to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tappdgkzj is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.cmtno is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.bustype is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.servtype is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.transdt is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.businesstrace is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.flownumber is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.fsamount is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.reportcode is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.receivecode is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.reportforms is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.reportnumber is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.gkdjbudgetlevel is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.gkdjindicator is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.gkdjbudgettype is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.gkdjnboftxs is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.appenddatadtltab is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.syscd is '';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tappdgkzj.etl_timestamp is 'ETL处理时间戳';
