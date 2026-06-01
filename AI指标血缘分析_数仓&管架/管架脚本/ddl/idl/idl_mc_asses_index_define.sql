/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_asses_index_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_asses_index_define
whenever sqlerror continue none;
drop table ${idl_schema}.mc_asses_index_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_asses_index_define(
    module_name varchar2(150) -- 模块名称
    ,belong_cls varchar2(150) -- 所属分类
    ,index_class_f_mcs varchar2(150) -- 指标一级分类
    ,index_class_s_mcs varchar2(150) -- 指标二级分类
    ,index_class_t_mcs varchar2(150) -- 指标三级分类
    ,index_no varchar2(150) -- 取值指标编号
    ,index_name varchar2(150) -- 取值指标名称
    ,index_no_mcs varchar2(150) -- 管驾指标编号
    ,index_name_mcs varchar2(150) -- 管驾指标名称
    ,source_system varchar2(150) -- 来源系统
    ,frequency varchar2(150) -- 指标频度
    ,unit varchar2(150) -- 指标单位
    ,index_state varchar2(150) -- 指标状态
    ,update_dt date -- 更新日期
    ,update_per varchar2(150) -- 更新人
    ,super_index_no_mcs varchar2(150) -- 上级管驾指标编号
    ,super_index_name_mcs varchar2(150) -- 上级管驾指标名称
    ,ind_stat_type varchar2(20) -- 指标统计类型(时点值，累计值。当时点值，取环比，当累计值，取同比)
    ,is_major_ind_diplay varchar2(20) -- 是否主要指标展示
    ,is_imp_ind_diplay varchar2(20) -- 是否重点指标展示
    ,is_deflt varchar2(20) -- 是否默认
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
grant select on ${idl_schema}.mc_asses_index_define to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_asses_index_define is '考核模块指标定义表';
comment on column ${idl_schema}.mc_asses_index_define.module_name is '模块名称';
comment on column ${idl_schema}.mc_asses_index_define.belong_cls is '所属分类';
comment on column ${idl_schema}.mc_asses_index_define.index_class_f_mcs is '指标一级分类';
comment on column ${idl_schema}.mc_asses_index_define.index_class_s_mcs is '指标二级分类';
comment on column ${idl_schema}.mc_asses_index_define.index_class_t_mcs is '指标三级分类';
comment on column ${idl_schema}.mc_asses_index_define.index_no is '取值指标编号';
comment on column ${idl_schema}.mc_asses_index_define.index_name is '取值指标名称';
comment on column ${idl_schema}.mc_asses_index_define.index_no_mcs is '管驾指标编号';
comment on column ${idl_schema}.mc_asses_index_define.index_name_mcs is '管驾指标名称';
comment on column ${idl_schema}.mc_asses_index_define.source_system is '来源系统';
comment on column ${idl_schema}.mc_asses_index_define.frequency is '指标频度';
comment on column ${idl_schema}.mc_asses_index_define.unit is '指标单位';
comment on column ${idl_schema}.mc_asses_index_define.index_state is '指标状态';
comment on column ${idl_schema}.mc_asses_index_define.update_dt is '更新日期';
comment on column ${idl_schema}.mc_asses_index_define.update_per is '更新人';
comment on column ${idl_schema}.mc_asses_index_define.super_index_no_mcs is '上级管驾指标编号';
comment on column ${idl_schema}.mc_asses_index_define.super_index_name_mcs is '上级管驾指标名称';
comment on column ${idl_schema}.mc_asses_index_define.ind_stat_type is '指标统计类型(时点值，累计值。当时点值，取环比，当累计值，取同比)';
comment on column ${idl_schema}.mc_asses_index_define.is_major_ind_diplay is '是否主要指标展示';
comment on column ${idl_schema}.mc_asses_index_define.is_imp_ind_diplay is '是否重点指标展示';
comment on column ${idl_schema}.mc_asses_index_define.is_deflt is '是否默认';
comment on column ${idl_schema}.mc_asses_index_define.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_asses_index_define.etl_timestamp is 'ETL处理时间戳';