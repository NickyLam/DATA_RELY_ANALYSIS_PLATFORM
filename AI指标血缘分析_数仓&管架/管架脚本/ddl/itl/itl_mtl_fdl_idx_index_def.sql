/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_fdl_idx_index_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_fdl_idx_index_def
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_fdl_idx_index_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_fdl_idx_index_def(
    index_int_id varchar2(60) -- 指标内部ID
    ,index_num varchar2(60) -- 指标编号
    ,index_name varchar2(100) -- 指标名称
    ,index_desc varchar2(4000) -- 指标描述
    ,index_bclass varchar2(100) -- 指标大类
    ,index_level1_class varchar2(100) -- 指标一级分类
    ,index_level2_class varchar2(100) -- 指标二级分类
    ,index_level3_class varchar2(100) -- 指标三级分类
    ,index_measure varchar2(100) -- 指标度量
    ,index_deriv_measure varchar2(4000) -- 指标衍生度量
    ,data_attr varchar2(100) -- 数值属性
    ,index_dim varchar2(100) -- 指标维度
    ,measure_unit varchar2(100) -- 度量单位
    ,stat_period varchar2(100) -- 统计周期
    ,data_format varchar2(100) -- 数据格式
    ,prod_mode varchar2(100) -- 产生方式
    ,biz_cali varchar2(4000) -- 业务口径
    ,tech_cali varchar2(4000) -- 技术口径
    ,issue_range varchar2(100) -- 发布范围
    ,main_sys varchar2(100) -- 主系统
    ,warn_val varchar2(100) -- 预警值
    ,alarm_val varchar2(100) -- 报警值
    ,owner varchar2(100) -- 所有者
    ,write_person varchar2(100) -- 填写人
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,matn_person varchar2(100) -- 维护人
    ,matn_dt date -- 维护日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_fdl_idx_index_def to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_fdl_idx_index_def is 'FDL_指标_指标定义';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_int_id is '指标内部ID';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_num is '指标编号';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_name is '指标名称';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_desc is '指标描述';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_bclass is '指标大类';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_level1_class is '指标一级分类';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_level2_class is '指标二级分类';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_level3_class is '指标三级分类';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_measure is '指标度量';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_deriv_measure is '指标衍生度量';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.data_attr is '数值属性';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.index_dim is '指标维度';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.measure_unit is '度量单位';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.stat_period is '统计周期';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.data_format is '数据格式';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.prod_mode is '产生方式';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.biz_cali is '业务口径';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.tech_cali is '技术口径';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.issue_range is '发布范围';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.main_sys is '主系统';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.warn_val is '预警值';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.alarm_val is '报警值';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.owner is '所有者';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.write_person is '填写人';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.effect_dt is '生效日期';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.invalid_dt is '失效日期';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.matn_person is '维护人';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.matn_dt is '维护日期';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_fdl_idx_index_def.etl_timestamp is 'ETL处理时间戳';
