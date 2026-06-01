/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_teller_post_rela_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_teller_post_rela_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_teller_post_rela_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_teller_post_rela_info(
    post_id varchar2(100) -- 岗位编号
    ,teller_id varchar2(100) -- 柜员编号
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
grant select on ${iml_schema}.pty_teller_post_rela_info to ${icl_schema};
grant select on ${iml_schema}.pty_teller_post_rela_info to ${idl_schema};
grant select on ${iml_schema}.pty_teller_post_rela_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_teller_post_rela_info is '柜员岗位关联信息';
comment on column ${iml_schema}.pty_teller_post_rela_info.post_id is '岗位编号';
comment on column ${iml_schema}.pty_teller_post_rela_info.teller_id is '柜员编号';
comment on column ${iml_schema}.pty_teller_post_rela_info.org_id is '机构编号';
comment on column ${iml_schema}.pty_teller_post_rela_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_teller_post_rela_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_teller_post_rela_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_teller_post_rela_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_teller_post_rela_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_teller_post_rela_info.etl_timestamp is 'ETL处理时间戳';
