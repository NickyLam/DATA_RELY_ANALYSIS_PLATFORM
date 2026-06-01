/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_event_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_event_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_event_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_event_type(
    company varchar2(20) -- 法人
    ,event_class varchar2(10) -- 事件分类
    ,event_desc varchar2(100) -- 事件描述
    ,event_type varchar2(20) -- 事件类型
    ,process_method varchar2(1) -- 指标处理方式
    ,standard_flag varchar2(1) -- 是否标准模板
    ,status varchar2(1) -- 状态
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_mb_event_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_event_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_event_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_event_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_event_type is '事件类型定义表';
comment on column ${iol_schema}.ncbs_mb_event_type.company is '法人';
comment on column ${iol_schema}.ncbs_mb_event_type.event_class is '事件分类';
comment on column ${iol_schema}.ncbs_mb_event_type.event_desc is '事件描述';
comment on column ${iol_schema}.ncbs_mb_event_type.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_mb_event_type.process_method is '指标处理方式';
comment on column ${iol_schema}.ncbs_mb_event_type.standard_flag is '是否标准模板';
comment on column ${iol_schema}.ncbs_mb_event_type.status is '状态';
comment on column ${iol_schema}.ncbs_mb_event_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_event_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_event_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_event_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_event_type.etl_timestamp is 'ETL处理时间戳';
