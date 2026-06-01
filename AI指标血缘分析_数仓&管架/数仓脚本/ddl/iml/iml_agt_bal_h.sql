/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bal_h(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bal_type_cd varchar2(10) -- 余额类型代码
    ,bal_comb_id varchar2(60) -- 余额组合编号
    ,bal_dir_cd varchar2(15) -- 科目余额方向
    ,curr_cd varchar2(30) -- 币种代码
    ,bal number(38,8) -- 余额
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
grant select on ${iml_schema}.agt_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bal_h is '协议余额历史';
comment on column ${iml_schema}.agt_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bal_h.bal_type_cd is '余额类型代码';
comment on column ${iml_schema}.agt_bal_h.bal_comb_id is '余额组合编号';
comment on column ${iml_schema}.agt_bal_h.bal_dir_cd is '科目余额方向';
comment on column ${iml_schema}.agt_bal_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_bal_h.bal is '余额';
comment on column ${iml_schema}.agt_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bal_h.etl_timestamp is 'ETL处理时间戳';
