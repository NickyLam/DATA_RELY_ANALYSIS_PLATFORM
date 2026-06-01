/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_log_ivr_comm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_log_ivr_comm
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_log_ivr_comm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_ivr_comm(
    id number -- 
    ,ivrchan_no number -- 
    ,cti_connection_id varchar2(50) -- 
    ,receive_no varchar2(15) -- 
    ,trunk_id varchar2(6) -- 
    ,call_time date -- 
    ,holder_type varchar2(4) -- 
    ,holder_no varchar2(30) -- 
    ,paper_id varchar2(18) -- 
    ,paper_type varchar2(10) -- 
    ,menu_no varchar2(500) -- 
    ,update_date date -- 
    ,status varchar2(4) -- 
    ,version number -- 
    ,menu_no_cn varchar2(1024) -- 
    ,call_in_time date -- 
    ,cust_name varchar2(50) -- 
    ,is_to_agent varchar2(4) -- 0挂机  1转人工
    ,skill_group varchar2(10) -- 技能组编码
    ,skill_group_name varchar2(50) -- 技能组
    ,language varchar2(10) -- cn中文,en英文
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
grant select on ${iol_schema}.ccdb_log_ivr_comm to ${iml_schema};
grant select on ${iol_schema}.ccdb_log_ivr_comm to ${icl_schema};
grant select on ${iol_schema}.ccdb_log_ivr_comm to ${idl_schema};
grant select on ${iol_schema}.ccdb_log_ivr_comm to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccdb_log_ivr_comm is 'log_ivr呼叫流水表';
comment on column ${iol_schema}.ccdb_log_ivr_comm.id is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.ivrchan_no is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.cti_connection_id is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.receive_no is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.trunk_id is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.call_time is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.holder_type is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.holder_no is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.paper_id is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.paper_type is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.menu_no is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.update_date is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.status is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.version is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.menu_no_cn is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.call_in_time is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.cust_name is '';
comment on column ${iol_schema}.ccdb_log_ivr_comm.is_to_agent is '0挂机  1转人工';
comment on column ${iol_schema}.ccdb_log_ivr_comm.skill_group is '技能组编码';
comment on column ${iol_schema}.ccdb_log_ivr_comm.skill_group_name is '技能组';
comment on column ${iol_schema}.ccdb_log_ivr_comm.language is 'cn中文,en英文';
comment on column ${iol_schema}.ccdb_log_ivr_comm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ccdb_log_ivr_comm.etl_timestamp is 'ETL处理时间戳';
