/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharesalessegment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharesalessegment
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharesalessegment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharesalessegment(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,report_period varchar2(12) -- 报告期
    ,crncy_code varchar2(15) -- 货币代码
    ,s_segment_itemcode number(9,0) -- 项目类别
    ,s_segment_item varchar2(150) -- 主营业务项目
    ,s_segment_sales number(20,4) -- 主营业务收入(元)
    ,s_segment_profit number(20,4) -- 主营业务利润(元)
    ,s_segment_cost number(20,4) -- 主营业务成本(元)
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
grant select on ${iol_schema}.wind_asharesalessegment to ${iml_schema};
grant select on ${iol_schema}.wind_asharesalessegment to ${icl_schema};
grant select on ${iol_schema}.wind_asharesalessegment to ${idl_schema};
grant select on ${iol_schema}.wind_asharesalessegment to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharesalessegment is '中国A股主营业务构成';
comment on column ${iol_schema}.wind_asharesalessegment.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharesalessegment.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_asharesalessegment.report_period is '报告期';
comment on column ${iol_schema}.wind_asharesalessegment.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_asharesalessegment.s_segment_itemcode is '项目类别';
comment on column ${iol_schema}.wind_asharesalessegment.s_segment_item is '主营业务项目';
comment on column ${iol_schema}.wind_asharesalessegment.s_segment_sales is '主营业务收入(元)';
comment on column ${iol_schema}.wind_asharesalessegment.s_segment_profit is '主营业务利润(元)';
comment on column ${iol_schema}.wind_asharesalessegment.s_segment_cost is '主营业务成本(元)';
comment on column ${iol_schema}.wind_asharesalessegment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharesalessegment.etl_timestamp is 'ETL处理时间戳';
