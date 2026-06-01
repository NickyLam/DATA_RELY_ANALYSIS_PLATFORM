/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_fdl_idx_index_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_fdl_idx_index_def
whenever sqlerror continue none;
drop table ${msl_schema}.msl_fdl_idx_index_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_fdl_idx_index_def(
    index_int_id VARCHAR2(60)
    ,index_num VARCHAR2(60)
    ,index_name VARCHAR2(100)
    ,index_desc VARCHAR2(4000)
    ,index_bclass VARCHAR2(100)
    ,index_level1_class VARCHAR2(100)
    ,index_level2_class VARCHAR2(100)
    ,index_level3_class VARCHAR2(100)
    ,index_measure VARCHAR2(100)
    ,index_deriv_measure VARCHAR2(4000)
    ,data_attr VARCHAR2(100)
    ,index_dim VARCHAR2(100)
    ,measure_unit VARCHAR2(100)
    ,stat_period VARCHAR2(100)
    ,data_format VARCHAR2(100)
    ,prod_mode VARCHAR2(100)
    ,biz_cali VARCHAR2(4000)
    ,tech_cali VARCHAR2(4000)
    ,issue_range VARCHAR2(100)
    ,main_sys VARCHAR2(100)
    ,warn_val VARCHAR2(100)
    ,alarm_val VARCHAR2(100)
    ,owner VARCHAR2(100)
    ,write_person VARCHAR2(100)
    ,effect_dt DATE
    ,invalid_dt DATE
    ,matn_person VARCHAR2(100)
    ,matn_dt DATE
    ,etl_dt DATE
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_fdl_idx_index_def to itl;

-- comment
comment on table ${msl_schema}.msl_fdl_idx_index_def is 'FDL_指标_指标定义';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_int_id is '指标内部ID';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_num is '指标编号';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_name is '指标名称';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_desc is '指标描述';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_bclass is '指标大类';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_level1_class is '指标一级分类';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_level2_class is '指标二级分类';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_level3_class is '指标三级分类';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_measure is '指标度量';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_deriv_measure is '指标衍生度量';
comment on column ${msl_schema}.msl_fdl_idx_index_def.data_attr is '数值属性';
comment on column ${msl_schema}.msl_fdl_idx_index_def.index_dim is '指标维度';
comment on column ${msl_schema}.msl_fdl_idx_index_def.measure_unit is '度量单位';
comment on column ${msl_schema}.msl_fdl_idx_index_def.stat_period is '统计周期';
comment on column ${msl_schema}.msl_fdl_idx_index_def.data_format is '数据格式';
comment on column ${msl_schema}.msl_fdl_idx_index_def.prod_mode is '产生方式';
comment on column ${msl_schema}.msl_fdl_idx_index_def.biz_cali is '业务口径';
comment on column ${msl_schema}.msl_fdl_idx_index_def.tech_cali is '技术口径';
comment on column ${msl_schema}.msl_fdl_idx_index_def.issue_range is '发布范围';
comment on column ${msl_schema}.msl_fdl_idx_index_def.main_sys is '主系统';
comment on column ${msl_schema}.msl_fdl_idx_index_def.warn_val is '预警值';
comment on column ${msl_schema}.msl_fdl_idx_index_def.alarm_val is '报警值';
comment on column ${msl_schema}.msl_fdl_idx_index_def.owner is '所有者';
comment on column ${msl_schema}.msl_fdl_idx_index_def.write_person is '填写人';
comment on column ${msl_schema}.msl_fdl_idx_index_def.effect_dt is '生效日期';
comment on column ${msl_schema}.msl_fdl_idx_index_def.invalid_dt is '失效日期';
comment on column ${msl_schema}.msl_fdl_idx_index_def.matn_person is '维护人';
comment on column ${msl_schema}.msl_fdl_idx_index_def.matn_dt is '维护日期';
comment on column ${msl_schema}.msl_fdl_idx_index_def.etl_dt is '数据日期';
