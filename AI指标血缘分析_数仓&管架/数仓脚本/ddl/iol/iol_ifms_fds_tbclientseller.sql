/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_fds_tbclientseller
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_fds_tbclientseller
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_fds_tbclientseller purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbclientseller(
    in_client_no varchar2(30) -- 
    ,bank_no varchar2(14) -- 
    ,client_no varchar2(36) -- 
    ,seller_code varchar2(14) -- 
    ,open_date number(22,0) -- 
    ,close_date number(22,0) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,client_group varchar2(2) -- 
    ,address varchar2(375) -- 
    ,post_code varchar2(9) -- 
    ,tel varchar2(36) -- 
    ,fax varchar2(36) -- 
    ,mobile varchar2(36) -- 
    ,email varchar2(60) -- 
    ,send_freq varchar2(2) -- 
    ,send_mode varchar2(12) -- 
    ,education varchar2(3) -- 
    ,income varchar2(12) -- 
    ,vocation varchar2(3) -- 
    ,nationality varchar2(5) -- 
    ,channels varchar2(75) -- 
    ,prd_types varchar2(75) -- 
    ,client_manager varchar2(48) -- 
    ,open_branch varchar2(24) -- 
    ,modi_date number(22,0) -- 
    ,modi_time number(22,0) -- 
    ,modify_info varchar2(15) -- 
    ,ta_client varchar2(30) -- 
    ,status varchar2(2) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,ta_client2 varchar2(30) -- 
    ,status2 varchar2(2) -- 
    ,investor_type varchar2(3) -- 
    ,other_id_type_name varchar2(150) -- 
    ,last_modify_date number(22,0) -- 
    ,spv_branch varchar2(9) -- 
    ,other_branch varchar2(90) -- 
    ,qua_investor_type varchar2(2) -- 
    ,region_code varchar2(24) -- 
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
grant select on ${iol_schema}.ifms_fds_tbclientseller to ${iml_schema};
grant select on ${iol_schema}.ifms_fds_tbclientseller to ${icl_schema};
grant select on ${iol_schema}.ifms_fds_tbclientseller to ${idl_schema};
grant select on ${iol_schema}.ifms_fds_tbclientseller to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_fds_tbclientseller is '客户销售商信息';
comment on column ${iol_schema}.ifms_fds_tbclientseller.in_client_no is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.bank_no is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.client_no is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.seller_code is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.open_date is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.close_date is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.reserve1 is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.reserve2 is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.client_group is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.address is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.post_code is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.tel is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.fax is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.mobile is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.email is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.send_freq is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.send_mode is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.education is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.income is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.vocation is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.nationality is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.channels is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.prd_types is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.client_manager is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.open_branch is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.modi_date is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.modi_time is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.modify_info is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.ta_client is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.status is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.reserve3 is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.reserve4 is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.ta_client2 is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.status2 is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.investor_type is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.other_id_type_name is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.last_modify_date is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.spv_branch is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.other_branch is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.qua_investor_type is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.region_code is '';
comment on column ${iol_schema}.ifms_fds_tbclientseller.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_fds_tbclientseller.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_fds_tbclientseller.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_fds_tbclientseller.etl_timestamp is 'ETL处理时间戳';
