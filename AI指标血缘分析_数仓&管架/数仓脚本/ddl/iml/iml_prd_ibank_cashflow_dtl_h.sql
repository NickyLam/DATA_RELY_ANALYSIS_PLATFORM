/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ibank_cashflow_dtl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ibank_cashflow_dtl_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ibank_cashflow_dtl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_cashflow_dtl_h(
    fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,task_group_id varchar2(60) -- 任务组编号
    ,cashflow_id varchar2(60) -- 现金流编号
    ,int_rat_flow_id varchar2(60) -- 利率流编号
    ,pricing_envir_id varchar2(60) -- 定价环境编号
    ,cfm_cashflow_flg number(38,6) -- 确定现金流标志
    ,calc_dt date -- 计算日期
    ,int_accr_start_dt date -- 计息开始日期
    ,int_accr_end_dt date -- 计息结束日期
    ,pay_dt date -- 支付日期
    ,pay_amt number(38,6) -- 支付金额
    ,disct_rat number(38,6) -- 折现率
    ,pric_amt number(38,6) -- 本金金额
    ,pre_pric_amt number(38,6) -- 预测本金金额
    ,int_amt number(38,6) -- 利息金额
    ,pre_int_amt number(38,6) -- 预测利息金额
    ,pay_bf_pric number(38,6) -- 支付前本金
    ,pay_post_pric number(38,6) -- 支付后本金
    ,option_premium number(38,6) -- 期权费
    ,pre_option_premium number(38,6) -- 预测期权费
    ,curr_cd varchar2(30) -- 币种代码
    ,stl_curr_cd varchar2(30) -- 结算币种代码
    ,accu_pd number(38,6) -- 累积违约概率
    ,real_fin_instm_id varchar2(60) -- 真实金融工具编号
    ,src_update_tm date -- 源更新时间
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
grant select on ${iml_schema}.prd_ibank_cashflow_dtl_h to ${icl_schema};
grant select on ${iml_schema}.prd_ibank_cashflow_dtl_h to ${idl_schema};
grant select on ${iml_schema}.prd_ibank_cashflow_dtl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ibank_cashflow_dtl_h is '同业现金流明细历史';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.task_group_id is '任务组编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.cashflow_id is '现金流编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.int_rat_flow_id is '利率流编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pricing_envir_id is '定价环境编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.cfm_cashflow_flg is '确定现金流标志';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.calc_dt is '计算日期';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.int_accr_start_dt is '计息开始日期';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.int_accr_end_dt is '计息结束日期';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pay_dt is '支付日期';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pay_amt is '支付金额';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.disct_rat is '折现率';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pric_amt is '本金金额';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pre_pric_amt is '预测本金金额';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.int_amt is '利息金额';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pre_int_amt is '预测利息金额';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pay_bf_pric is '支付前本金';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pay_post_pric is '支付后本金';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.option_premium is '期权费';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.pre_option_premium is '预测期权费';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.stl_curr_cd is '结算币种代码';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.accu_pd is '累积违约概率';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.real_fin_instm_id is '真实金融工具编号';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.src_update_tm is '源更新时间';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ibank_cashflow_dtl_h.etl_timestamp is 'ETL处理时间戳';
