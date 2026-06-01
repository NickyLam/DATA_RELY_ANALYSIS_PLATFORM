/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_pub_cd_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_pub_cd_map
whenever sqlerror continue none;
drop table ${iml_schema}.ref_pub_cd_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_pub_cd_map(
    sorc_sys_cd varchar2(10) -- 源系统代码
    ,subj varchar2(10) -- 主题
    ,src_tab_en_name varchar2(100) -- 源表英文名
    ,src_tab_cn_name varchar2(100) -- 源表中文名
    ,src_field_en_name varchar2(100) -- 源字段英文名
    ,src_field_cn_name varchar2(150) -- 源字段中文名
    ,src_code_val varchar2(60) -- 源代码值
    ,src_code_descb varchar2(1000) -- 源代码描述
    ,target_tab_en_name varchar2(100) -- 目标表英文名
    ,target_tab_cn_name varchar2(100) -- 目标表中文名
    ,target_tab_field_en_name varchar2(100) -- 目标表字段英文名
    ,target_tab_field_cn_name varchar2(100) -- 目标表字段中文名
    ,target_cd_tab_en_name varchar2(60) -- 目标代码表英文名
    ,target_cd_tab_cn_name varchar2(250) -- 目标代码表中文名
    ,target_cd_val varchar2(30) -- 目标代码值
    ,target_cd_descb varchar2(1000) -- 目标代码描述
    ,remark varchar2(150) -- 备注
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_pub_cd_map to ${icl_schema};
grant select on ${iml_schema}.ref_pub_cd_map to ${idl_schema};
grant select on ${iml_schema}.ref_pub_cd_map to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_pub_cd_map is '公共代码映射表';
comment on column ${iml_schema}.ref_pub_cd_map.sorc_sys_cd is '源系统代码';
comment on column ${iml_schema}.ref_pub_cd_map.subj is '主题';
comment on column ${iml_schema}.ref_pub_cd_map.src_tab_en_name is '源表英文名';
comment on column ${iml_schema}.ref_pub_cd_map.src_tab_cn_name is '源表中文名';
comment on column ${iml_schema}.ref_pub_cd_map.src_field_en_name is '源字段英文名';
comment on column ${iml_schema}.ref_pub_cd_map.src_field_cn_name is '源字段中文名';
comment on column ${iml_schema}.ref_pub_cd_map.src_code_val is '源代码值';
comment on column ${iml_schema}.ref_pub_cd_map.src_code_descb is '源代码描述';
comment on column ${iml_schema}.ref_pub_cd_map.target_tab_en_name is '目标表英文名';
comment on column ${iml_schema}.ref_pub_cd_map.target_tab_cn_name is '目标表中文名';
comment on column ${iml_schema}.ref_pub_cd_map.target_tab_field_en_name is '目标表字段英文名';
comment on column ${iml_schema}.ref_pub_cd_map.target_tab_field_cn_name is '目标表字段中文名';
comment on column ${iml_schema}.ref_pub_cd_map.target_cd_tab_en_name is '目标代码表英文名';
comment on column ${iml_schema}.ref_pub_cd_map.target_cd_tab_cn_name is '目标代码表中文名';
comment on column ${iml_schema}.ref_pub_cd_map.target_cd_val is '目标代码值';
comment on column ${iml_schema}.ref_pub_cd_map.target_cd_descb is '目标代码描述';
comment on column ${iml_schema}.ref_pub_cd_map.remark is '备注';
comment on column ${iml_schema}.ref_pub_cd_map.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_pub_cd_map.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_pub_cd_map.job_cd is '任务编码';
comment on column ${iml_schema}.ref_pub_cd_map.etl_timestamp is 'ETL处理时间戳';
