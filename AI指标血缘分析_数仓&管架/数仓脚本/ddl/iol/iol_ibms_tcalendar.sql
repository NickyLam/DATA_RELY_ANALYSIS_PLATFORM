/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tcalendar
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tcalendar
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tcalendar purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tcalendar(
    cal_code varchar2(30) -- 交易日历内部代码
    ,cal_name varchar2(75) -- 交易日历名称
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
grant select on ${iol_schema}.ibms_tcalendar to ${iml_schema};
grant select on ${iol_schema}.ibms_tcalendar to ${icl_schema};
grant select on ${iol_schema}.ibms_tcalendar to ${idl_schema};
grant select on ${iol_schema}.ibms_tcalendar to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tcalendar is '交易日历定义表';
comment on column ${iol_schema}.ibms_tcalendar.cal_code is '交易日历内部代码';
comment on column ${iol_schema}.ibms_tcalendar.cal_name is '交易日历名称';
comment on column ${iol_schema}.ibms_tcalendar.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tcalendar.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tcalendar.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tcalendar.etl_timestamp is 'ETL处理时间戳';
