/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_int_accr_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_int_accr_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.prd_int_accr_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_int_accr_dtl(
    fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,task_group_id varchar2(100) -- 任务组编号
    ,cashflow_id varchar2(100) -- 现金流编号
    ,int_rat_flow_id varchar2(100) -- 利率流编号
    ,int_accr_dtl_id varchar2(100) -- 计息明细编号
    ,pricing_envir_id varchar2(100) -- 定价环境编号
    ,lp_id varchar2(60) -- 法人编号
    ,int_accr_start_dt date -- 计息开始日期
    ,int_accr_end_dt date -- 计息结束日期
    ,set_int_dt date -- 定息日期
    ,actl_int_rat number(38,6) -- 实际利率
    ,int_accr_year_cnt number(38,16) -- 计息年数
    ,int_accr_intrv_int_rat number(38,6) -- 计息区间利率
    ,spd number(38,6) -- 利差
    ,int_rat_uplmi number(38,6) -- 利率上限
    ,int_rat_lolmi number(38,6) -- 利率下限
    ,base_rat_mult number(38,6) -- 基准利率倍数
    ,actl_fin_instm_id varchar2(100) -- 实际金融工具编号
    ,pay_int_dt date -- 付息日期
    ,int_accr_intrv_int number(38,6) -- 计息区间利息
    ,int_accr_intrv_pric number(38,6) -- 计息区间本金
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
grant select on ${iml_schema}.prd_int_accr_dtl to ${icl_schema};
grant select on ${iml_schema}.prd_int_accr_dtl to ${idl_schema};
grant select on ${iml_schema}.prd_int_accr_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_int_accr_dtl is '计息明细表';
comment on column ${iml_schema}.prd_int_accr_dtl.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_int_accr_dtl.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_int_accr_dtl.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_int_accr_dtl.task_group_id is '任务组编号';
comment on column ${iml_schema}.prd_int_accr_dtl.cashflow_id is '现金流编号';
comment on column ${iml_schema}.prd_int_accr_dtl.int_rat_flow_id is '利率流编号';
comment on column ${iml_schema}.prd_int_accr_dtl.int_accr_dtl_id is '计息明细编号';
comment on column ${iml_schema}.prd_int_accr_dtl.pricing_envir_id is '定价环境编号';
comment on column ${iml_schema}.prd_int_accr_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.prd_int_accr_dtl.int_accr_start_dt is '计息开始日期';
comment on column ${iml_schema}.prd_int_accr_dtl.int_accr_end_dt is '计息结束日期';
comment on column ${iml_schema}.prd_int_accr_dtl.set_int_dt is '定息日期';
comment on column ${iml_schema}.prd_int_accr_dtl.actl_int_rat is '实际利率';
comment on column ${iml_schema}.prd_int_accr_dtl.int_accr_year_cnt is '计息年数';
comment on column ${iml_schema}.prd_int_accr_dtl.int_accr_intrv_int_rat is '计息区间利率';
comment on column ${iml_schema}.prd_int_accr_dtl.spd is '利差';
comment on column ${iml_schema}.prd_int_accr_dtl.int_rat_uplmi is '利率上限';
comment on column ${iml_schema}.prd_int_accr_dtl.int_rat_lolmi is '利率下限';
comment on column ${iml_schema}.prd_int_accr_dtl.base_rat_mult is '基准利率倍数';
comment on column ${iml_schema}.prd_int_accr_dtl.actl_fin_instm_id is '实际金融工具编号';
comment on column ${iml_schema}.prd_int_accr_dtl.pay_int_dt is '付息日期';
comment on column ${iml_schema}.prd_int_accr_dtl.int_accr_intrv_int is '计息区间利息';
comment on column ${iml_schema}.prd_int_accr_dtl.int_accr_intrv_pric is '计息区间本金';
comment on column ${iml_schema}.prd_int_accr_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.prd_int_accr_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.prd_int_accr_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.prd_int_accr_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_int_accr_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.prd_int_accr_dtl.etl_timestamp is 'ETL处理时间戳';
