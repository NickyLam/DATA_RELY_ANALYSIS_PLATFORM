/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbclient
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbclient
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbclient purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbclient(
    in_client_no varchar2(30) -- 
    ,client_type varchar2(2) -- 
    ,client_group varchar2(10) -- 
    ,id_type varchar2(3) -- 
    ,id_code varchar2(60) -- 
    ,short_name varchar2(375) -- 
    ,client_name varchar2(375) -- 
    ,address varchar2(512) -- 
    ,post_code varchar2(12) -- 
    ,tel varchar2(45) -- 
    ,fax varchar2(45) -- 
    ,mobile varchar2(45) -- 
    ,email varchar2(256) -- 
    ,sex varchar2(2) -- 
    ,send_freq varchar2(2) -- 
    ,send_mode varchar2(12) -- 
    ,risk_level number(22) -- 
    ,risk_date number(22) -- 
    ,birthday number(22) -- 
    ,id_code_date number(22) -- 
    ,education varchar2(3) -- 
    ,income varchar2(24) -- 
    ,vocation varchar2(10) -- 
    ,nationality varchar2(5) -- 
    ,channels varchar2(75) -- 
    ,prd_types varchar2(75) -- 
    ,client_manager varchar2(48) -- 
    ,open_branch varchar2(80) -- 
    ,status varchar2(2) -- 
    ,modi_date number(22) -- 
    ,modi_time number(22) -- 
    ,modify_info varchar2(15) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbclient to ${iml_schema};
grant select on ${iol_schema}.ifms_tbclient to ${icl_schema};
grant select on ${iol_schema}.ifms_tbclient to ${idl_schema};
grant select on ${iol_schema}.ifms_tbclient to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbclient is '客户信息表*';
comment on column ${iol_schema}.ifms_tbclient.in_client_no is '';
comment on column ${iol_schema}.ifms_tbclient.client_type is '';
comment on column ${iol_schema}.ifms_tbclient.client_group is '';
comment on column ${iol_schema}.ifms_tbclient.id_type is '';
comment on column ${iol_schema}.ifms_tbclient.id_code is '';
comment on column ${iol_schema}.ifms_tbclient.short_name is '';
comment on column ${iol_schema}.ifms_tbclient.client_name is '';
comment on column ${iol_schema}.ifms_tbclient.address is '';
comment on column ${iol_schema}.ifms_tbclient.post_code is '';
comment on column ${iol_schema}.ifms_tbclient.tel is '';
comment on column ${iol_schema}.ifms_tbclient.fax is '';
comment on column ${iol_schema}.ifms_tbclient.mobile is '';
comment on column ${iol_schema}.ifms_tbclient.email is '';
comment on column ${iol_schema}.ifms_tbclient.sex is '';
comment on column ${iol_schema}.ifms_tbclient.send_freq is '';
comment on column ${iol_schema}.ifms_tbclient.send_mode is '';
comment on column ${iol_schema}.ifms_tbclient.risk_level is '';
comment on column ${iol_schema}.ifms_tbclient.risk_date is '';
comment on column ${iol_schema}.ifms_tbclient.birthday is '';
comment on column ${iol_schema}.ifms_tbclient.id_code_date is '';
comment on column ${iol_schema}.ifms_tbclient.education is '';
comment on column ${iol_schema}.ifms_tbclient.income is '';
comment on column ${iol_schema}.ifms_tbclient.vocation is '';
comment on column ${iol_schema}.ifms_tbclient.nationality is '';
comment on column ${iol_schema}.ifms_tbclient.channels is '';
comment on column ${iol_schema}.ifms_tbclient.prd_types is '';
comment on column ${iol_schema}.ifms_tbclient.client_manager is '';
comment on column ${iol_schema}.ifms_tbclient.open_branch is '';
comment on column ${iol_schema}.ifms_tbclient.status is '';
comment on column ${iol_schema}.ifms_tbclient.modi_date is '';
comment on column ${iol_schema}.ifms_tbclient.modi_time is '';
comment on column ${iol_schema}.ifms_tbclient.modify_info is '';
comment on column ${iol_schema}.ifms_tbclient.reserve1 is '';
comment on column ${iol_schema}.ifms_tbclient.reserve2 is '';
comment on column ${iol_schema}.ifms_tbclient.reserve3 is '';
comment on column ${iol_schema}.ifms_tbclient.reserve4 is '';
comment on column ${iol_schema}.ifms_tbclient.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbclient.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbclient.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbclient.etl_timestamp is 'ETL处理时间戳';
