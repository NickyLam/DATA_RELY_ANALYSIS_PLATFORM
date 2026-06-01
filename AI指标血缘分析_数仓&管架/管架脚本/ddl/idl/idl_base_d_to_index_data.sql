/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl base_d_to_index_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.base_d_to_index_data
whenever sqlerror continue none;
drop table ${idl_schema}.base_d_to_index_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_to_index_data(
    index_no varchar2(30) -- 指标编号
    ,org_no varchar2(60) -- 指标主体号
    ,super_org_no varchar2(6) -- 上级机构号
    ,bu_type varchar2(30) -- 分类
    ,index_value number(38,8) -- 指标值
    ,source_sys varchar2(60) -- 来源基础表
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)

partition by list(etl_dt)
subpartition by list(source_sys)
(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
    (
        subpartition p_19000101_d values ('BASE_D_TO_INDEX_DATA')
    )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.base_d_to_index_data to ${iel_schema};

-- comment
comment on table ${idl_schema}.base_d_to_index_data is '基础数据生成指标数据表';
comment on column ${idl_schema}.base_d_to_index_data.index_no is '指标编号';
comment on column ${idl_schema}.base_d_to_index_data.org_no is '指标主体号';
comment on column ${idl_schema}.base_d_to_index_data.super_org_no is '上级机构号';
comment on column ${idl_schema}.base_d_to_index_data.bu_type is '分类';
comment on column ${idl_schema}.base_d_to_index_data.index_value is '指标值';
comment on column ${idl_schema}.base_d_to_index_data.source_sys is '来源基础表';
comment on column ${idl_schema}.base_d_to_index_data.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.base_d_to_index_data.etl_timestamp is 'ETL处理时间戳';