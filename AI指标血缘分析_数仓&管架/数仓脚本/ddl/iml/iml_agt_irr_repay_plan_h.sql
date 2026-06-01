/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_irr_repay_plan_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_irr_repay_plan_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_irr_repay_plan_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_irr_repay_plan_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,repay_plan_id varchar2(100) -- 还款计划编号
    ,cust_id varchar2(100) -- 客户编号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,curr_sub_plan_way_cd varchar2(30) -- 当前子计划方式代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,freq_cd varchar2(30) -- 频率代码
    ,next_proc_dt date -- 下一处理日期
    ,proc_day number(10) -- 处理日
    ,tot_amt number(30,2) -- 总金额
    ,perds number(10) -- 首段期数
    ,prog_intrv_perds number(10) -- 累进间隔期数
    ,prog_amt number(30,2) -- 累进金额
    ,prog_ratio number(18,6) -- 累进比例
    ,int_set_ped_cd varchar2(30) -- 结息周期代码
    ,next_int_set_dt date -- 下一结息日期
    ,int_callbk_day number(10) -- 利息回收日
    ,blon_loan_calc_pd number(10) -- 气球贷计算期次
    ,grace_period_type_cd varchar2(30) -- 宽限期类型代码
    ,grace_days number(10) -- 宽限天数
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio number(18,6) -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point number(18,8) -- 分户级利率浮动点数
    ,agt_chg_way_cd varchar2(30) -- 协议变动方式代码
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
grant select on ${iml_schema}.agt_irr_repay_plan_h to ${icl_schema};
grant select on ${iml_schema}.agt_irr_repay_plan_h to ${idl_schema};
grant select on ${iml_schema}.agt_irr_repay_plan_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_irr_repay_plan_h is '不规则还款计划历史';
comment on column ${iml_schema}.agt_irr_repay_plan_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_irr_repay_plan_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_irr_repay_plan_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_irr_repay_plan_h.repay_plan_id is '还款计划编号';
comment on column ${iml_schema}.agt_irr_repay_plan_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_irr_repay_plan_h.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.agt_irr_repay_plan_h.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.agt_irr_repay_plan_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_irr_repay_plan_h.curr_sub_plan_way_cd is '当前子计划方式代码';
comment on column ${iml_schema}.agt_irr_repay_plan_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_irr_repay_plan_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_irr_repay_plan_h.freq_cd is '频率代码';
comment on column ${iml_schema}.agt_irr_repay_plan_h.next_proc_dt is '下一处理日期';
comment on column ${iml_schema}.agt_irr_repay_plan_h.proc_day is '处理日';
comment on column ${iml_schema}.agt_irr_repay_plan_h.tot_amt is '总金额';
comment on column ${iml_schema}.agt_irr_repay_plan_h.perds is '首段期数';
comment on column ${iml_schema}.agt_irr_repay_plan_h.prog_intrv_perds is '累进间隔期数';
comment on column ${iml_schema}.agt_irr_repay_plan_h.prog_amt is '累进金额';
comment on column ${iml_schema}.agt_irr_repay_plan_h.prog_ratio is '累进比例';
comment on column ${iml_schema}.agt_irr_repay_plan_h.int_set_ped_cd is '结息周期代码';
comment on column ${iml_schema}.agt_irr_repay_plan_h.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_irr_repay_plan_h.int_callbk_day is '利息回收日';
comment on column ${iml_schema}.agt_irr_repay_plan_h.blon_loan_calc_pd is '气球贷计算期次';
comment on column ${iml_schema}.agt_irr_repay_plan_h.grace_period_type_cd is '宽限期类型代码';
comment on column ${iml_schema}.agt_irr_repay_plan_h.grace_days is '宽限天数';
comment on column ${iml_schema}.agt_irr_repay_plan_h.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_irr_repay_plan_h.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_irr_repay_plan_h.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_irr_repay_plan_h.agt_chg_way_cd is '协议变动方式代码';
comment on column ${iml_schema}.agt_irr_repay_plan_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_irr_repay_plan_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_irr_repay_plan_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_irr_repay_plan_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_irr_repay_plan_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_irr_repay_plan_h.etl_timestamp is 'ETL处理时间戳';
