/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml org_intnal_org_status_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.org_intnal_org_status_h
whenever sqlerror continue none;
drop table ${iml_schema}.org_intnal_org_status_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.org_intnal_org_status_h(
    org_id varchar2(60) -- 机构编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_org_status_type_cd varchar2(10) -- 内部机构状态类型代码
    ,org_status_cd varchar2(10) -- 机构状态代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.org_intnal_org_status_h to ${icl_schema};
grant select on ${iml_schema}.org_intnal_org_status_h to ${idl_schema};
grant select on ${iml_schema}.org_intnal_org_status_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.org_intnal_org_status_h is '内部机构状态历史';
comment on column ${iml_schema}.org_intnal_org_status_h.org_id is '机构编号';
comment on column ${iml_schema}.org_intnal_org_status_h.lp_id is '法人编号';
comment on column ${iml_schema}.org_intnal_org_status_h.intnal_org_status_type_cd is '内部机构状态类型代码';
comment on column ${iml_schema}.org_intnal_org_status_h.org_status_cd is '机构状态代码';
comment on column ${iml_schema}.org_intnal_org_status_h.start_dt is '开始时间';
comment on column ${iml_schema}.org_intnal_org_status_h.end_dt is '结束时间';
comment on column ${iml_schema}.org_intnal_org_status_h.id_mark is '增删标志';
comment on column ${iml_schema}.org_intnal_org_status_h.src_table_name is '源表名称';
comment on column ${iml_schema}.org_intnal_org_status_h.job_cd is '任务编码';
comment on column ${iml_schema}.org_intnal_org_status_h.etl_timestamp is 'ETL处理时间戳';
