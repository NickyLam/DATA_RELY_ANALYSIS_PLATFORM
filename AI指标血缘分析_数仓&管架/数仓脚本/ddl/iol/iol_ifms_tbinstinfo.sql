/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinstinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinstinfo
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinstinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinstinfo(
    in_client_no varchar2(30) -- 
    ,inst_type varchar2(2) -- 
    ,repr_name varchar2(375) -- 
    ,repr_id_type varchar2(2) -- 
    ,repr_id_code varchar2(60) -- 
    ,actor_name varchar2(375) -- 
    ,actor_id_type varchar2(2) -- 
    ,actor_id_code varchar2(60) -- 
    ,link_name varchar2(375) -- 
    ,link_id_type varchar2(2) -- 
    ,link_id_code varchar2(48) -- 
    ,reserve1 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbinstinfo to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinstinfo to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinstinfo to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinstinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinstinfo is '机构客户附加信息表';
comment on column ${iol_schema}.ifms_tbinstinfo.in_client_no is '';
comment on column ${iol_schema}.ifms_tbinstinfo.inst_type is '';
comment on column ${iol_schema}.ifms_tbinstinfo.repr_name is '';
comment on column ${iol_schema}.ifms_tbinstinfo.repr_id_type is '';
comment on column ${iol_schema}.ifms_tbinstinfo.repr_id_code is '';
comment on column ${iol_schema}.ifms_tbinstinfo.actor_name is '';
comment on column ${iol_schema}.ifms_tbinstinfo.actor_id_type is '';
comment on column ${iol_schema}.ifms_tbinstinfo.actor_id_code is '';
comment on column ${iol_schema}.ifms_tbinstinfo.link_name is '';
comment on column ${iol_schema}.ifms_tbinstinfo.link_id_type is '';
comment on column ${iol_schema}.ifms_tbinstinfo.link_id_code is '';
comment on column ${iol_schema}.ifms_tbinstinfo.reserve1 is '';
comment on column ${iol_schema}.ifms_tbinstinfo.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbinstinfo.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbinstinfo.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbinstinfo.etl_timestamp is 'ETL处理时间戳';
