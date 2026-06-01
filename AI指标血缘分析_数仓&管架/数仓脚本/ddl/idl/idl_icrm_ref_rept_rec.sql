/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_rept_rec
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_rept_rec
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_rept_rec purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_rept_rec(
    etl_dt date -- 数据日期
    ,rept_id varchar2(60) -- 报表编号
    ,rela_obj_type varchar2(60) -- 关联对象类型
    ,rela_obj_id varchar2(60) -- 关联对象编号
    ,rept_cali varchar2(60) -- 报表口径
    ,model_id varchar2(60) -- 模型编号
    ,rept_name varchar2(100) -- 报表名称
    ,rept_dt varchar2(20) -- 报表日期
    ,create_tm varchar2(20) -- 创建时间
    ,create_org_id varchar2(60) -- 创建机构编号
    ,creator_id varchar2(60) -- 创建人编号
    ,update_tm varchar2(20) -- 更新时间
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
grant select on ${idl_schema}.icrm_ref_rept_rec to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_rept_rec is '报表记录表';
comment on column ${idl_schema}.icrm_ref_rept_rec.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_rept_rec.rept_id is '报表编号';
comment on column ${idl_schema}.icrm_ref_rept_rec.rela_obj_type is '关联对象类型';
comment on column ${idl_schema}.icrm_ref_rept_rec.rela_obj_id is '关联对象编号';
comment on column ${idl_schema}.icrm_ref_rept_rec.rept_cali is '报表口径';
comment on column ${idl_schema}.icrm_ref_rept_rec.model_id is '模型编号';
comment on column ${idl_schema}.icrm_ref_rept_rec.rept_name is '报表名称';
comment on column ${idl_schema}.icrm_ref_rept_rec.rept_dt is '报表日期';
comment on column ${idl_schema}.icrm_ref_rept_rec.create_tm is '创建时间';
comment on column ${idl_schema}.icrm_ref_rept_rec.create_org_id is '创建机构编号';
comment on column ${idl_schema}.icrm_ref_rept_rec.creator_id is '创建人编号';
comment on column ${idl_schema}.icrm_ref_rept_rec.update_tm is '更新时间';
comment on column ${idl_schema}.icrm_ref_rept_rec.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_rept_rec.etl_timestamp is '数据处理时间';
