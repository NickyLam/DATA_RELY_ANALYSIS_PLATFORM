/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_sppi_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_sppi_config
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_sppi_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_sppi_config(
    tradeclass varchar2(150) -- 业务模式
    ,tradeclassname varchar2(150) -- 业务模式名称
    ,testresult varchar2(30) -- 测试结果
    ,testresultname varchar2(30) -- 测试结果名称
    ,i9class varchar2(150) -- i9分类
    ,i9classname varchar2(150) -- i9分类名称
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
grant select on ${iol_schema}.ibms_ttrd_sppi_config to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_sppi_config to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_sppi_config to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_sppi_config to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_sppi_config is 'SPPI使用配置表';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.tradeclass is '业务模式';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.tradeclassname is '业务模式名称';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.testresult is '测试结果';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.testresultname is '测试结果名称';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.i9class is 'i9分类';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.i9classname is 'i9分类名称';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_sppi_config.etl_timestamp is 'ETL处理时间戳';
