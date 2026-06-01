/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbhomegroup
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbhomegroup
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbhomegroup purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhomegroup(
    home_id varchar2(48) -- 
    ,bank_acc varchar2(48) -- 
    ,client_no varchar2(48) -- 
    ,client_name varchar2(150) -- 
    ,id_type varchar2(2) -- 
    ,id_code varchar2(45) -- 
    ,mobile varchar2(45) -- 
    ,open_branch varchar2(24) -- 
    ,status varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbhomegroup to ${iml_schema};
grant select on ${iol_schema}.ifms_tbhomegroup to ${icl_schema};
grant select on ${iol_schema}.ifms_tbhomegroup to ${idl_schema};
grant select on ${iol_schema}.ifms_tbhomegroup to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbhomegroup is '家庭成员信息';
comment on column ${iol_schema}.ifms_tbhomegroup.home_id is '';
comment on column ${iol_schema}.ifms_tbhomegroup.bank_acc is '';
comment on column ${iol_schema}.ifms_tbhomegroup.client_no is '';
comment on column ${iol_schema}.ifms_tbhomegroup.client_name is '';
comment on column ${iol_schema}.ifms_tbhomegroup.id_type is '';
comment on column ${iol_schema}.ifms_tbhomegroup.id_code is '';
comment on column ${iol_schema}.ifms_tbhomegroup.mobile is '';
comment on column ${iol_schema}.ifms_tbhomegroup.open_branch is '';
comment on column ${iol_schema}.ifms_tbhomegroup.status is '';
comment on column ${iol_schema}.ifms_tbhomegroup.reserve1 is '';
comment on column ${iol_schema}.ifms_tbhomegroup.reserve2 is '';
comment on column ${iol_schema}.ifms_tbhomegroup.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbhomegroup.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbhomegroup.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbhomegroup.etl_timestamp is 'ETL处理时间戳';
