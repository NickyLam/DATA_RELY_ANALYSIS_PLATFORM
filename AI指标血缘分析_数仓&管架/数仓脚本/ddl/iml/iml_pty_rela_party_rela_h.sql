/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_rela_party_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_rela_party_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_rela_party_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_rela_party_rela_h(
    rela_party_id varchar2(60) -- 关联方编号
    ,lp_id varchar2(60) -- 法人编号
    ,rela_party_super_id varchar2(60) -- 关联方上级编号
    ,effect_dt timestamp -- 生效日期
    ,invalid_dt timestamp -- 失效日期
    ,incid_rela_cd varchar2(60) -- 关联关系代码
    ,final_update_tm timestamp -- 最后更新时间
    ,final_update_affair_tm timestamp -- 最后更新事务时间
    ,create_tm timestamp -- 创建时间
    ,create_affair_tm timestamp -- 创建事务时间
    ,and_up_level_mgers_rela_cd varchar2(60) -- 与上层管理方关系代码
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
grant select on ${iml_schema}.pty_rela_party_rela_h to ${icl_schema};
grant select on ${iml_schema}.pty_rela_party_rela_h to ${idl_schema};
grant select on ${iml_schema}.pty_rela_party_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_rela_party_rela_h is '关联方关系历史';
comment on column ${iml_schema}.pty_rela_party_rela_h.rela_party_id is '关联方编号';
comment on column ${iml_schema}.pty_rela_party_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_rela_party_rela_h.rela_party_super_id is '关联方上级编号';
comment on column ${iml_schema}.pty_rela_party_rela_h.effect_dt is '生效日期';
comment on column ${iml_schema}.pty_rela_party_rela_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.pty_rela_party_rela_h.incid_rela_cd is '关联关系代码';
comment on column ${iml_schema}.pty_rela_party_rela_h.final_update_tm is '最后更新时间';
comment on column ${iml_schema}.pty_rela_party_rela_h.final_update_affair_tm is '最后更新事务时间';
comment on column ${iml_schema}.pty_rela_party_rela_h.create_tm is '创建时间';
comment on column ${iml_schema}.pty_rela_party_rela_h.create_affair_tm is '创建事务时间';
comment on column ${iml_schema}.pty_rela_party_rela_h.and_up_level_mgers_rela_cd is '与上层管理方关系代码';
comment on column ${iml_schema}.pty_rela_party_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_rela_party_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_rela_party_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_rela_party_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_rela_party_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_rela_party_rela_h.etl_timestamp is 'ETL处理时间戳';
