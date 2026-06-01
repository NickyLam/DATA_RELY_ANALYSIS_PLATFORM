/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_jd_repay_plan_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_jd_repay_plan_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_jd_repay_plan_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_jd_repay_plan_h(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,jd_prod_cd varchar2(60) -- 京东产品代码
    ,cust_lmt_id varchar2(60) -- 客户额度编号
    ,dubil_id varchar2(60) -- 借据编号
    ,inst_odd_no varchar2(60) -- 分期单号
    ,repay_perds number(10) -- 还款期数
    ,init_repay_perds number(10) -- 原还款期数
    ,pric_exp_dt date -- 本金到期日期
    ,rpbl_pric_bal number(30,8) -- 应还本金
    ,int_exp_dt date -- 利息到期日期
    ,rpbl_int_bal number(30,8) -- 应还利息
    ,repay_tot_perds number(10) -- 还款总期数
    ,rpbl_pnlt_bal number(30,8) -- 应还罚息
    ,inst_exec_int_rat number(30,8) -- 执行利率
    ,perds_type_cd varchar2(10) -- 期数类型代码
    ,ovdue_days number(22) -- 贷款逾期天数
    ,last_day_ovdue_days number(10) -- 前一天逾期天数
    ,last_day_ovdue_status_cd varchar2(10) -- 前一天逾期状态代码
    ,curr_ovdue_days number(10) -- 当前逾期天数
    ,curr_ovdue_status_cd varchar2(10) -- 当前逾期状态代码
    ,repay_modif_status_cd varchar2(10) -- 还款变更状态代码
    ,penalty number(30,8) -- 违约金
    ,prod_id varchar2(60) -- 产品编号
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
grant select on ${iml_schema}.agt_jd_repay_plan_h to ${icl_schema};
grant select on ${iml_schema}.agt_jd_repay_plan_h to ${idl_schema};
grant select on ${iml_schema}.agt_jd_repay_plan_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_jd_repay_plan_h is '京东还款计划历史';
comment on column ${iml_schema}.agt_jd_repay_plan_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_jd_repay_plan_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_jd_repay_plan_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_jd_repay_plan_h.jd_prod_cd is '京东产品代码';
comment on column ${iml_schema}.agt_jd_repay_plan_h.cust_lmt_id is '客户额度编号';
comment on column ${iml_schema}.agt_jd_repay_plan_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_jd_repay_plan_h.inst_odd_no is '分期单号';
comment on column ${iml_schema}.agt_jd_repay_plan_h.repay_perds is '还款期数';
comment on column ${iml_schema}.agt_jd_repay_plan_h.init_repay_perds is '原还款期数';
comment on column ${iml_schema}.agt_jd_repay_plan_h.pric_exp_dt is '本金到期日期';
comment on column ${iml_schema}.agt_jd_repay_plan_h.rpbl_pric_bal is '应还本金';
comment on column ${iml_schema}.agt_jd_repay_plan_h.int_exp_dt is '利息到期日期';
comment on column ${iml_schema}.agt_jd_repay_plan_h.rpbl_int_bal is '应还利息';
comment on column ${iml_schema}.agt_jd_repay_plan_h.repay_tot_perds is '还款总期数';
comment on column ${iml_schema}.agt_jd_repay_plan_h.rpbl_pnlt_bal is '应还罚息';
comment on column ${iml_schema}.agt_jd_repay_plan_h.inst_exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_jd_repay_plan_h.perds_type_cd is '期数类型代码';
comment on column ${iml_schema}.agt_jd_repay_plan_h.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_jd_repay_plan_h.last_day_ovdue_days is '前一天逾期天数';
comment on column ${iml_schema}.agt_jd_repay_plan_h.last_day_ovdue_status_cd is '前一天逾期状态代码';
comment on column ${iml_schema}.agt_jd_repay_plan_h.curr_ovdue_days is '当前逾期天数';
comment on column ${iml_schema}.agt_jd_repay_plan_h.curr_ovdue_status_cd is '当前逾期状态代码';
comment on column ${iml_schema}.agt_jd_repay_plan_h.repay_modif_status_cd is '还款变更状态代码';
comment on column ${iml_schema}.agt_jd_repay_plan_h.penalty is '违约金';
comment on column ${iml_schema}.agt_jd_repay_plan_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_jd_repay_plan_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_jd_repay_plan_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_jd_repay_plan_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_jd_repay_plan_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_jd_repay_plan_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_jd_repay_plan_h.etl_timestamp is 'ETL处理时间戳';
