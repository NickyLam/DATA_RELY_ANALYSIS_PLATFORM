/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_industry_eco_index_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_industry_eco_index_data
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_industry_eco_index_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_industry_eco_index_data(
    seq number(28,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录通讯到用户端时间
    ,indicator_id varchar2(60) -- 指标id@关联到industry_eco_index_basic_info.indicator_id
    ,indicator_name varchar2(384) -- 指标名称
    ,tm varchar2(30) -- 时间
    ,numerical_value varchar2(300) -- 数值
    ,isvalid number(10) -- 是否有效
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
grant select on ${iol_schema}.uxds_industry_eco_index_data to ${iml_schema};
grant select on ${iol_schema}.uxds_industry_eco_index_data to ${icl_schema};
grant select on ${iol_schema}.uxds_industry_eco_index_data to ${idl_schema};
grant select on ${iol_schema}.uxds_industry_eco_index_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_industry_eco_index_data is '行业经济指标数据';
comment on column ${iol_schema}.uxds_industry_eco_index_data.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_industry_eco_index_data.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_industry_eco_index_data.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_industry_eco_index_data.rtime is '记录通讯到用户端时间';
comment on column ${iol_schema}.uxds_industry_eco_index_data.indicator_id is '指标id@关联到industry_eco_index_basic_info.indicator_id';
comment on column ${iol_schema}.uxds_industry_eco_index_data.indicator_name is '指标名称';
comment on column ${iol_schema}.uxds_industry_eco_index_data.tm is '时间';
comment on column ${iol_schema}.uxds_industry_eco_index_data.numerical_value is '数值';
comment on column ${iol_schema}.uxds_industry_eco_index_data.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_industry_eco_index_data.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_industry_eco_index_data.etl_timestamp is 'ETL处理时间戳';
