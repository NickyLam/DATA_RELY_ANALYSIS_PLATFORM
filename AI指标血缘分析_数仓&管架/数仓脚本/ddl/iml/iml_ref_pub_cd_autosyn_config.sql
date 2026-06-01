/*
Purpose:    公共代码自动同步配置表
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_pub_cd_autosyn_config
CreateDate: 20221026
FileType:   DDL
Logs:       曹永茂 20221023 新建脚本
*/

prompt creating table ${iml_schema}.ref_pub_cd_autosyn_config
whenever sqlerror continue none;
drop table ${iml_schema}.ref_pub_cd_autosyn_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_pub_cd_autosyn_config(
     cd_id varchar2(60) -- 代码编号
    ,cd_tab_en_name varchar2(60) -- 代码表英文名称
    ,cd_tab_cn_descb varchar2(250) -- 代码表中文描述
    ,data_std_flg varchar2(60) -- 数据标准标志
    ,quote_data_std varchar2(60) -- 引用数据标准
    ,src_sys_cd varchar2(100) -- 码值系统代码
    ,src_table_en_name varchar2(100) -- 码值来源表英文名
    ,src_table_cn_name varchar2(100) -- 码值来源表中文名
    ,src_cd_field_en_name varchar2(100) -- 码值来源字段英文名   
    ,src_descb_field_en_name varchar2(100) -- 码值描述来源字段英文名      
    ,src_parent_field_en_name varchar2(100) -- 父级代码来源字段英文名
    ,table_type varchar2(60) -- 表类型
    ,spec_cond varchar2(100) -- 特殊筛选条件
    ,valid_flg varchar2(100) -- 有效标志
    ,update_dt date -- 更新日期
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;
-- grant
grant select on ${iml_schema}.ref_pub_cd_autosyn_config to ${iol_schema};
grant select on ${iml_schema}.ref_pub_cd_autosyn_config to ${icl_schema};
grant select on ${iml_schema}.ref_pub_cd_autosyn_config to ${idl_schema};
grant select on ${iml_schema}.ref_pub_cd_autosyn_config to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_pub_cd_autosyn_config is '公共代码自动同步配置表';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.cd_id is '代码编号';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.cd_tab_en_name is '代码表英文名称';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.cd_tab_cn_descb is '代码表中文描述';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.data_std_flg is '数据标准标志';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.quote_data_std is '引用数据标准';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.src_sys_cd is '码值系统代码';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.src_table_en_name is '码值来源表英文名';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.src_table_cn_name is '码值来源表中文名';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.src_cd_field_en_name is '码值来源字段英文名';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.src_descb_field_en_name is '码值描述来源字段英文名';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.src_parent_field_en_name is '父级代码来源字段英文名';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.table_type is '表类型';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.spec_cond is '特殊筛选条件';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.valid_flg is '有效标志';
comment on column ${iml_schema}.ref_pub_cd_autosyn_config.update_dt is '更新日期';


