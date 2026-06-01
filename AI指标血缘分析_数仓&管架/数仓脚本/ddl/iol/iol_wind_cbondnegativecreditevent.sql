/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondnegativecreditevent
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondnegativecreditevent
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondnegativecreditevent purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondnegativecreditevent(
    object_id varchar2(57) -- 对象ID
    ,s_info_windcode varchar2(60) -- wind代码
    ,acu_date varchar2(12) -- [内部]发生日期
    ,event_type number(9,0) -- 事件类型
    ,s_info_compcode varchar2(60) -- 公司ID
    ,subject_type number(9,0) -- 主体类型代码
    ,event_title varchar2(750) -- 事件标题
    ,event_memo varchar2(4000) -- 事件摘要
    ,event_id varchar2(30) -- 事件id
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
grant select on ${iol_schema}.wind_cbondnegativecreditevent to ${iml_schema};
grant select on ${iol_schema}.wind_cbondnegativecreditevent to ${icl_schema};
grant select on ${iol_schema}.wind_cbondnegativecreditevent to ${idl_schema};
grant select on ${iol_schema}.wind_cbondnegativecreditevent to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondnegativecreditevent is '中国债券负面事件';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.s_info_windcode is 'wind代码';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.acu_date is '[内部]发生日期';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.event_type is '事件类型';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.subject_type is '主体类型代码';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.event_title is '事件标题';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.event_memo is '事件摘要';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.event_id is '事件id';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondnegativecreditevent.etl_timestamp is 'ETL处理时间戳';
