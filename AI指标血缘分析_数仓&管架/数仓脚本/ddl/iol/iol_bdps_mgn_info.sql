/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_mgn_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_mgn_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_mgn_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_mgn_info(
    id number(22) -- 
    ,mgn_no varchar2(30) -- 
    ,mgn_name varchar2(45) -- 
    ,branch_id number(22) -- 
    ,depart_id number(22) -- 
    ,status varchar2(2) -- 
    ,dualcontrol_lockstatus varchar2(2) -- 
    ,last_upd_time varchar2(21) -- 
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
grant select on ${iol_schema}.bdps_mgn_info to ${iml_schema};
grant select on ${iol_schema}.bdps_mgn_info to ${icl_schema};
grant select on ${iol_schema}.bdps_mgn_info to ${idl_schema};
grant select on ${iol_schema}.bdps_mgn_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_mgn_info is '客户经理表';
comment on column ${iol_schema}.bdps_mgn_info.id is '';
comment on column ${iol_schema}.bdps_mgn_info.mgn_no is '';
comment on column ${iol_schema}.bdps_mgn_info.mgn_name is '';
comment on column ${iol_schema}.bdps_mgn_info.branch_id is '';
comment on column ${iol_schema}.bdps_mgn_info.depart_id is '';
comment on column ${iol_schema}.bdps_mgn_info.status is '';
comment on column ${iol_schema}.bdps_mgn_info.dualcontrol_lockstatus is '';
comment on column ${iol_schema}.bdps_mgn_info.last_upd_time is '';
comment on column ${iol_schema}.bdps_mgn_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_mgn_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_mgn_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_mgn_info.etl_timestamp is 'ETL处理时间戳';
