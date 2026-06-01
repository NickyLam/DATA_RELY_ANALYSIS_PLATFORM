/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_tmm_commissioning_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_tmm_commissioning_info
whenever sqlerror continue none;
drop table ${iol_schema}.orws_tmm_commissioning_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_tmm_commissioning_info(
    id number(18,0) -- 
    ,record_id number(18,0) -- 
    ,commissioning_date timestamp -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.orws_tmm_commissioning_info to ${iml_schema};
grant select on ${iol_schema}.orws_tmm_commissioning_info to ${icl_schema};
grant select on ${iol_schema}.orws_tmm_commissioning_info to ${idl_schema};
grant select on ${iol_schema}.orws_tmm_commissioning_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_tmm_commissioning_info is '生产运行任务表';
comment on column ${iol_schema}.orws_tmm_commissioning_info.id is '';
comment on column ${iol_schema}.orws_tmm_commissioning_info.record_id is '';
comment on column ${iol_schema}.orws_tmm_commissioning_info.commissioning_date is '';
comment on column ${iol_schema}.orws_tmm_commissioning_info.start_dt is '开始时间';
comment on column ${iol_schema}.orws_tmm_commissioning_info.end_dt is '结束时间';
comment on column ${iol_schema}.orws_tmm_commissioning_info.id_mark is '增删标志';
comment on column ${iol_schema}.orws_tmm_commissioning_info.etl_timestamp is 'ETL处理时间戳';
