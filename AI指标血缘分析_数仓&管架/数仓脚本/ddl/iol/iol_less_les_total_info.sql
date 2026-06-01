/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol less_les_total_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.less_les_total_info
whenever sqlerror continue none;
drop table ${iol_schema}.less_les_total_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.less_les_total_info(
    datadate varchar2(8) -- 数据日期
    ,seqitem number(22) -- 序号
    ,projectno varchar2(200) -- 项目
    ,sumexpse number(38,6) -- 合计
    ,unexemptriskexpse number(38,6) -- 其中：不可豁免风险暴露
    ,afcomnriskexpse number(38,6) -- 一般风险暴露
    ,afspecriskexpse number(38,6) -- 特定风险暴露
    ,aftradeacctriskexpse number(38,6) -- 交易账簿风险暴露
    ,aftradecpcrdtriskexpse number(38,6) -- 交易对手信用风险暴露
    ,afptentriskexpse number(38,6) -- 潜在风险暴露
    ,afothriskexpse number(38,6) -- 其他风险暴露
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
grant select on ${iol_schema}.less_les_total_info to ${iml_schema};
grant select on ${iol_schema}.less_les_total_info to ${icl_schema};
grant select on ${iol_schema}.less_les_total_info to ${idl_schema};
grant select on ${iol_schema}.less_les_total_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.less_les_total_info is '大额风险暴露总体情况表';
comment on column ${iol_schema}.less_les_total_info.datadate is '数据日期';
comment on column ${iol_schema}.less_les_total_info.seqitem is '序号';
comment on column ${iol_schema}.less_les_total_info.projectno is '项目';
comment on column ${iol_schema}.less_les_total_info.sumexpse is '合计';
comment on column ${iol_schema}.less_les_total_info.unexemptriskexpse is '其中：不可豁免风险暴露';
comment on column ${iol_schema}.less_les_total_info.afcomnriskexpse is '一般风险暴露';
comment on column ${iol_schema}.less_les_total_info.afspecriskexpse is '特定风险暴露';
comment on column ${iol_schema}.less_les_total_info.aftradeacctriskexpse is '交易账簿风险暴露';
comment on column ${iol_schema}.less_les_total_info.aftradecpcrdtriskexpse is '交易对手信用风险暴露';
comment on column ${iol_schema}.less_les_total_info.afptentriskexpse is '潜在风险暴露';
comment on column ${iol_schema}.less_les_total_info.afothriskexpse is '其他风险暴露';
comment on column ${iol_schema}.less_les_total_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.less_les_total_info.etl_timestamp is 'ETL处理时间戳';
