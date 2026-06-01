/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_event
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_event
whenever sqlerror continue none;
drop table ${iml_schema}.evt_event purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_event(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_event_id varchar2(100) -- 源事件编号
    ,event_type_cd varchar2(10) -- 事件类型代码
    ,event_dt date -- 事件日期
    ,event_tm varchar2(10) -- 事件时间
    ,event_tx_code varchar2(90) -- 事件交易码
    ,event_chn_id varchar2(60) -- 事件渠道编号
    ,event_teller_id varchar2(60) -- 事件柜员编号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_event to ${icl_schema};
grant select on ${iml_schema}.evt_event to ${idl_schema};
grant select on ${iml_schema}.evt_event to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_event is '事件';
comment on column ${iml_schema}.evt_event.evt_id is '事件编号';
comment on column ${iml_schema}.evt_event.lp_id is '法人编号';
comment on column ${iml_schema}.evt_event.src_event_id is '源事件编号';
comment on column ${iml_schema}.evt_event.event_type_cd is '事件类型代码';
comment on column ${iml_schema}.evt_event.event_dt is '事件日期';
comment on column ${iml_schema}.evt_event.event_tm is '事件时间';
comment on column ${iml_schema}.evt_event.event_tx_code is '事件交易码';
comment on column ${iml_schema}.evt_event.event_chn_id is '事件渠道编号';
comment on column ${iml_schema}.evt_event.event_teller_id is '事件柜员编号';
comment on column ${iml_schema}.evt_event.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_event.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_event.job_cd is '任务编码';
comment on column ${iml_schema}.evt_event.etl_timestamp is 'ETL处理时间戳';
