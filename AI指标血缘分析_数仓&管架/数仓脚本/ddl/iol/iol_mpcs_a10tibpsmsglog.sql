/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a10tibpsmsglog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a10tibpsmsglog
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a10tibpsmsglog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a10tibpsmsglog(
    inoutflag varchar2(2) -- 
    ,status varchar2(2) -- 
    ,intrace varchar2(24) -- 
    ,printflag varchar2(2) -- 
    ,node varchar2(15) -- 
    ,operno1 varchar2(15) -- 
    ,operno2 varchar2(15) -- 
    ,msgoutbank varchar2(18) -- 
    ,msginbank varchar2(18) -- 
    ,msgtime varchar2(21) -- 
    ,msgid varchar2(42) -- 
    ,content varchar2(3072) -- 
    ,dealdate varchar2(12) -- 
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
grant select on ${iol_schema}.mpcs_a10tibpsmsglog to ${iml_schema};
grant select on ${iol_schema}.mpcs_a10tibpsmsglog to ${icl_schema};
grant select on ${iol_schema}.mpcs_a10tibpsmsglog to ${idl_schema};
grant select on ${iol_schema}.mpcs_a10tibpsmsglog to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a10tibpsmsglog is '自由格式登记表';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.inoutflag is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.status is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.intrace is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.printflag is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.node is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.operno1 is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.operno2 is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.msgoutbank is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.msginbank is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.msgtime is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.msgid is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.content is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.dealdate is '';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a10tibpsmsglog.etl_timestamp is 'ETL处理时间戳';
