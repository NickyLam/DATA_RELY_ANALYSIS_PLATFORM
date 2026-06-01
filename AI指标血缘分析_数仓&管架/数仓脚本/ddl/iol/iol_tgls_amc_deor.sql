/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_deor
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_deor
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_deor purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_deor(
    stacid number(19) -- 账套标记
    ,busicd varchar2(20) -- 业务类型
    ,systid varchar2(8) -- 系统来源
    ,eventp varchar2(30) -- 交易场景
    ,dealtp varchar2(1) -- 批处理类型
    ,sortno number -- 处理顺序
    ,valide varchar2(1) -- 启用标识
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
grant select on ${iol_schema}.tgls_amc_deor to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_deor to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_deor to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_deor to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_deor is '交易处理顺序表';
comment on column ${iol_schema}.tgls_amc_deor.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amc_deor.busicd is '业务类型';
comment on column ${iol_schema}.tgls_amc_deor.systid is '系统来源';
comment on column ${iol_schema}.tgls_amc_deor.eventp is '交易场景';
comment on column ${iol_schema}.tgls_amc_deor.dealtp is '批处理类型';
comment on column ${iol_schema}.tgls_amc_deor.sortno is '处理顺序';
comment on column ${iol_schema}.tgls_amc_deor.valide is '启用标识';
comment on column ${iol_schema}.tgls_amc_deor.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_deor.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_deor.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_deor.etl_timestamp is 'ETL处理时间戳';
