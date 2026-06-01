/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wph_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wph_repay_plan
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wph_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_repay_plan(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,currt_perds number(10) -- 当期期数
    ,pd_status_cd varchar2(30) -- 期次状态代码
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_dt date -- 交易日期
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,grace_dt_term date -- 宽限日期
    ,payoff_dt date -- 结清日期
    ,ovdue_days number(10) -- 贷款逾期天数
    ,rpbl_amt number(30,2) -- 应还金额
    ,rpbl_pric number(30,2) -- 应还本金
    ,rpbl_int number(30,2) -- 应还利息
    ,rpbl_pnlt number(30,2) -- 应还罚息
    ,rpbl_comp_int number(30,2) -- 应还复利
    ,paid_tot_amt number(30,2) -- 实还总金额
    ,paid_pric number(30,2) -- 实还本金
    ,paid_int number(30,2) -- 实还利息
    ,paid_pnlt number(30,2) -- 实还罚息
    ,paid_comp_int number(30,2) -- 实还复利
    ,currt_bal number(30,2) -- 当期余额
    ,currt_pric_bal number(30,2) -- 当期本金余额
    ,currt_int_bal number(30,2) -- 当期利息余额
    ,currt_pnlt_bal number(30,2) -- 当期罚息余额
    ,currt_comp_int_bal number(30,2) -- 当期复利余额
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
grant select on ${iml_schema}.agt_wph_repay_plan to ${icl_schema};
grant select on ${iml_schema}.agt_wph_repay_plan to ${idl_schema};
grant select on ${iml_schema}.agt_wph_repay_plan to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wph_repay_plan is '唯品会还款计划';
comment on column ${iml_schema}.agt_wph_repay_plan.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wph_repay_plan.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wph_repay_plan.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_wph_repay_plan.currt_perds is '当期期数';
comment on column ${iml_schema}.agt_wph_repay_plan.pd_status_cd is '期次状态代码';
comment on column ${iml_schema}.agt_wph_repay_plan.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wph_repay_plan.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wph_repay_plan.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_wph_repay_plan.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_wph_repay_plan.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_wph_repay_plan.grace_dt_term is '宽限日期';
comment on column ${iml_schema}.agt_wph_repay_plan.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_wph_repay_plan.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_wph_repay_plan.rpbl_amt is '应还金额';
comment on column ${iml_schema}.agt_wph_repay_plan.rpbl_pric is '应还本金';
comment on column ${iml_schema}.agt_wph_repay_plan.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_wph_repay_plan.rpbl_pnlt is '应还罚息';
comment on column ${iml_schema}.agt_wph_repay_plan.rpbl_comp_int is '应还复利';
comment on column ${iml_schema}.agt_wph_repay_plan.paid_tot_amt is '实还总金额';
comment on column ${iml_schema}.agt_wph_repay_plan.paid_pric is '实还本金';
comment on column ${iml_schema}.agt_wph_repay_plan.paid_int is '实还利息';
comment on column ${iml_schema}.agt_wph_repay_plan.paid_pnlt is '实还罚息';
comment on column ${iml_schema}.agt_wph_repay_plan.paid_comp_int is '实还复利';
comment on column ${iml_schema}.agt_wph_repay_plan.currt_bal is '当期余额';
comment on column ${iml_schema}.agt_wph_repay_plan.currt_pric_bal is '当期本金余额';
comment on column ${iml_schema}.agt_wph_repay_plan.currt_int_bal is '当期利息余额';
comment on column ${iml_schema}.agt_wph_repay_plan.currt_pnlt_bal is '当期罚息余额';
comment on column ${iml_schema}.agt_wph_repay_plan.currt_comp_int_bal is '当期复利余额';
comment on column ${iml_schema}.agt_wph_repay_plan.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wph_repay_plan.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wph_repay_plan.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wph_repay_plan.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wph_repay_plan.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wph_repay_plan.etl_timestamp is 'ETL处理时间戳';
