/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_rating_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_rating_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_rating_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_rating_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,sorc_sys_cd varchar2(10) -- 源系统代码
    ,party_rating_type_cd varchar2(10) -- 当事人评级类型代码
    ,seq_num varchar2(60) -- 序号
    ,rating_org_id varchar2(60) -- 评级机构编号
    ,rating_org_name varchar2(300) -- 评级机构名称
    ,rating_dt date -- 评级日期
    ,rating_score_val number(10) -- 评级分值
    ,rating_effect_dt date -- 评级生效日期
    ,rating_invalid_dt date -- 评级失效日期
    ,rating_result_cd varchar2(10) -- 评级结果代码
    ,irs_task_flow_num varchar2(60) -- 内评系统任务流水号
    ,rating_level_cd varchar2(100) -- 评级等级代码
    ,lmt number(30,2) -- 限额
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
grant select on ${iml_schema}.pty_party_rating_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_rating_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_rating_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_rating_h is '当事人评级历史';
comment on column ${iml_schema}.pty_party_rating_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_rating_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_rating_h.sorc_sys_cd is '源系统代码';
comment on column ${iml_schema}.pty_party_rating_h.party_rating_type_cd is '当事人评级类型代码';
comment on column ${iml_schema}.pty_party_rating_h.seq_num is '序号';
comment on column ${iml_schema}.pty_party_rating_h.rating_org_id is '评级机构编号';
comment on column ${iml_schema}.pty_party_rating_h.rating_org_name is '评级机构名称';
comment on column ${iml_schema}.pty_party_rating_h.rating_dt is '评级日期';
comment on column ${iml_schema}.pty_party_rating_h.rating_score_val is '评级分值';
comment on column ${iml_schema}.pty_party_rating_h.rating_effect_dt is '评级生效日期';
comment on column ${iml_schema}.pty_party_rating_h.rating_invalid_dt is '评级失效日期';
comment on column ${iml_schema}.pty_party_rating_h.rating_result_cd is '评级结果代码';
comment on column ${iml_schema}.pty_party_rating_h.irs_task_flow_num is '内评系统任务流水号';
comment on column ${iml_schema}.pty_party_rating_h.rating_level_cd is '评级等级代码';
comment on column ${iml_schema}.pty_party_rating_h.lmt is '限额';
comment on column ${iml_schema}.pty_party_rating_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_rating_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_rating_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_rating_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_rating_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_rating_h.etl_timestamp is 'ETL处理时间戳';
