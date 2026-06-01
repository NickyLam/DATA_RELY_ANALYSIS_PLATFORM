/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_processing_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_processing_info
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_processing_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_processing_info(
    warn_id number(22) -- 预警编号
    ,pro_order varchar2(200) -- 分行下发处理单
    ,pro_time varchar2(200) -- 处理日期
    ,pro_people varchar2(200) -- 处理人
    ,resp_day varchar2(200) -- 应反馈日期
    ,result varchar2(200) -- 处理结果
    ,explains varchar2(4000) -- 处理说明
    ,net_feedback varchar2(200) -- 网点反馈
    ,super_vet varchar2(200) -- 待监测员审核
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
grant select on ${iol_schema}.rtis_processing_info to ${iml_schema};
grant select on ${iol_schema}.rtis_processing_info to ${icl_schema};
grant select on ${iol_schema}.rtis_processing_info to ${idl_schema};
grant select on ${iol_schema}.rtis_processing_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_processing_info is '处理信息表';
comment on column ${iol_schema}.rtis_processing_info.warn_id is '预警编号';
comment on column ${iol_schema}.rtis_processing_info.pro_order is '分行下发处理单';
comment on column ${iol_schema}.rtis_processing_info.pro_time is '处理日期';
comment on column ${iol_schema}.rtis_processing_info.pro_people is '处理人';
comment on column ${iol_schema}.rtis_processing_info.resp_day is '应反馈日期';
comment on column ${iol_schema}.rtis_processing_info.result is '处理结果';
comment on column ${iol_schema}.rtis_processing_info.explains is '处理说明';
comment on column ${iol_schema}.rtis_processing_info.net_feedback is '网点反馈';
comment on column ${iol_schema}.rtis_processing_info.super_vet is '待监测员审核';
comment on column ${iol_schema}.rtis_processing_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rtis_processing_info.etl_timestamp is 'ETL处理时间戳';
