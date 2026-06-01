/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_int_org_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_int_org_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_int_org_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_int_org_rela_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,party_org_rela_type_cd varchar2(10) -- 当事人机构关系类型代码
    ,org_id varchar2(100) -- 机构编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_party_int_org_rela_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_int_org_rela_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_int_org_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_int_org_rela_h is '当事人内部机构关系历史';
comment on column ${iml_schema}.pty_party_int_org_rela_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_int_org_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_int_org_rela_h.party_org_rela_type_cd is '当事人机构关系类型代码';
comment on column ${iml_schema}.pty_party_int_org_rela_h.org_id is '机构编号';
comment on column ${iml_schema}.pty_party_int_org_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_int_org_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_int_org_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_int_org_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_int_org_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_int_org_rela_h.etl_timestamp is 'ETL处理时间戳';
