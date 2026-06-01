/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_cny_fori_exch_mdl_p_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_cny_fori_exch_mdl_p_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_cny_fori_exch_mdl_p_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_cny_fori_exch_mdl_p_h(
    curr_cd varchar2(10) -- 币种代码
    ,curr_sym_cd varchar2(10) -- 货币符号代码
    ,convt_cny_exch_rat number(18,8) -- 折人民币汇率
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
grant select on ${iml_schema}.ref_cny_fori_exch_mdl_p_h to ${icl_schema};
grant select on ${iml_schema}.ref_cny_fori_exch_mdl_p_h to ${idl_schema};
grant select on ${iml_schema}.ref_cny_fori_exch_mdl_p_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_cny_fori_exch_mdl_p_h is '对人民币的外管中间价历史表';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.curr_sym_cd is '货币符号代码';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.convt_cny_exch_rat is '折人民币汇率';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_cny_fori_exch_mdl_p_h.etl_timestamp is 'ETL处理时间戳';
