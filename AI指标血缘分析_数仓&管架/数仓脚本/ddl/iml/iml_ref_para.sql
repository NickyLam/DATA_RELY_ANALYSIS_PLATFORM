/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_para(
    lp_id varchar2(100) -- 法人编号
    ,curr_cd varchar2(30) -- 币种代码
    ,par_type_id varchar2(100) -- 券别编号
    ,cnt number(10) -- 套数
    ,denom number(30,2) -- 面额
    ,edit_id varchar2(100) -- 版本编号
    ,par_type_name varchar2(500) -- 券别名称
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
grant select on ${iml_schema}.ref_para to ${icl_schema};
grant select on ${iml_schema}.ref_para to ${idl_schema};
grant select on ${iml_schema}.ref_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_para is '劵别参数表';
comment on column ${iml_schema}.ref_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_para.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_para.par_type_id is '券别编号';
comment on column ${iml_schema}.ref_para.cnt is '套数';
comment on column ${iml_schema}.ref_para.denom is '面额';
comment on column ${iml_schema}.ref_para.edit_id is '版本编号';
comment on column ${iml_schema}.ref_para.par_type_name is '券别名称';
comment on column ${iml_schema}.ref_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_para.etl_timestamp is 'ETL处理时间戳';
