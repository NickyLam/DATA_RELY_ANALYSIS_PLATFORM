/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_guar_cont_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_guar_cont_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_guar_cont_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_guar_cont_rela_h(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,guar_cont_id varchar2(60) -- 担保合同编号
    ,guar_type_cd varchar2(10) -- 担保类型代码
    ,loan_stage_cd varchar2(10) -- 贷款阶段代码
    ,guar_amt number(30,2) -- 担保金额
    ,guar_curr_cd varchar2(10) -- 担保币种代码
    ,pm_rat number(30,8) -- 抵质押率
    ,effect_status_cd varchar2(10) -- 生效状态代码
    ,exp_status_cd varchar2(10) -- 到期状态代码
    ,src_sys_cd varchar2(10) -- 来源系统代码
    ,setup_dt date -- 建立日期
    ,strip_line_cd varchar2(10) -- 条线代码
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
grant select on ${iml_schema}.ast_col_guar_cont_rela_h to ${icl_schema};
grant select on ${iml_schema}.ast_col_guar_cont_rela_h to ${idl_schema};
grant select on ${iml_schema}.ast_col_guar_cont_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_guar_cont_rela_h is '押品与担保合同关系历史';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.loan_stage_cd is '贷款阶段代码';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.guar_amt is '担保金额';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.guar_curr_cd is '担保币种代码';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.pm_rat is '抵质押率';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.effect_status_cd is '生效状态代码';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.exp_status_cd is '到期状态代码';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.src_sys_cd is '来源系统代码';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.setup_dt is '建立日期';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.strip_line_cd is '条线代码';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_guar_cont_rela_h.etl_timestamp is 'ETL处理时间戳';
