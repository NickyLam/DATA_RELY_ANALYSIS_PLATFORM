/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tappdbphpyw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tappdbphpyw
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tappdbphpyw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tappdbphpyw(
    cmtno varchar2(30) -- 
    ,bustype varchar2(9) -- 
    ,servtype varchar2(18) -- 
    ,transdt varchar2(12) -- 
    ,businesstrace varchar2(24) -- 
    ,bphpbilldate varchar2(12) -- 
    ,bphpbillamt varchar2(26) -- 
    ,bphpapplyacct varchar2(48) -- 
    ,bphpapplyname varchar2(180) -- 
    ,bphpsettleamt varchar2(26) -- 
    ,bphpbalance varchar2(26) -- 
    ,bphpbilltype varchar2(6) -- 
    ,bphpbillnb varchar2(48) -- 
    ,syscd varchar2(6) -- 
    ,syhpflag varchar2(2) -- 
    ,billduedate varchar2(12) -- 
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
grant select on ${iol_schema}.mpcs_a08tappdbphpyw to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tappdbphpyw to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tappdbphpyw to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tappdbphpyw to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tappdbphpyw is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.cmtno is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bustype is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.servtype is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.transdt is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.businesstrace is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bphpbilldate is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bphpbillamt is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bphpapplyacct is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bphpapplyname is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bphpsettleamt is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bphpbalance is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bphpbilltype is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.bphpbillnb is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.syscd is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.syhpflag is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.billduedate is '';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tappdbphpyw.etl_timestamp is 'ETL处理时间戳';
