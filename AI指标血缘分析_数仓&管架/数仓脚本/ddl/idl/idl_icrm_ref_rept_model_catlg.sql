/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_rept_model_catlg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_rept_model_catlg
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_rept_model_catlg purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_rept_model_catlg(
    etl_dt date -- 数据日期
    ,model_id varchar2(60) -- 模型编号
    ,model_name varchar2(100) -- 模型名称
    ,model_type varchar2(100) -- 模型类型
    ,model_descb varchar2(250) -- 模型描述
    ,model_abb varchar2(100) -- 模型缩写
    ,model_cls varchar2(100) -- 模型分类
    ,model_attr_1 varchar2(100) -- 模型属性1
    ,model_attr_2 varchar2(100) -- 模型属性2
    ,dsply_method varchar2(250) -- 显示方法
    ,tab_head_descb varchar2(250) -- 表头描述
    ,del_flg varchar2(10) -- 删除标志
    ,remark varchar2(250) -- 备注
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_ref_rept_model_catlg to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_rept_model_catlg is '报表模型目录';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.model_id is '模型编号';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.model_name is '模型名称';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.model_type is '模型类型';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.model_descb is '模型描述';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.model_abb is '模型缩写';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.model_cls is '模型分类';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.model_attr_1 is '模型属性1';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.model_attr_2 is '模型属性2';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.dsply_method is '显示方法';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.tab_head_descb is '表头描述';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.del_flg is '删除标志';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.remark is '备注';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_rept_model_catlg.etl_timestamp is '数据处理时间';
