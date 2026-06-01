/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_irr_repay_plan_h_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_irr_repay_plan_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_irr_repay_plan_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,repay_plan_id -- 还款计划编号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,evt_cate_id -- 事件类别编号
    ,repay_way_cd -- 还款方式代码
    ,curr_sub_plan_way_cd -- 当前子计划方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,freq_cd -- 频率代码
    ,next_proc_dt -- 下一处理日期
    ,proc_day -- 处理日
    ,tot_amt -- 总金额
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,int_set_ped_cd -- 结息周期代码
    ,next_int_set_dt -- 下一结息日期
    ,int_callbk_day -- 利息回收日
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_days -- 宽限天数
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,agt_chg_way_cd -- 协议变动方式代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_irr_repay_plan_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_irr_repay_plan_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_irr_repay_plan_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_irregular_schedule-1
insert into ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,repay_plan_id -- 还款计划编号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,evt_cate_id -- 事件类别编号
    ,repay_way_cd -- 还款方式代码
    ,curr_sub_plan_way_cd -- 当前子计划方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,freq_cd -- 频率代码
    ,next_proc_dt -- 下一处理日期
    ,proc_day -- 处理日
    ,tot_amt -- 总金额
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,int_set_ped_cd -- 结息周期代码
    ,next_int_set_dt -- 下一结息日期
    ,int_callbk_day -- 利息回收日
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_days -- 宽限天数
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,agt_chg_way_cd -- 协议变动方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.SCHED_SEQ_NO -- 还款计划编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.AMT_TYPE -- 金额类型代码
    ,P1.EVENT_TYPE -- 事件类别编号
    ,P1.SCHED_MODE -- 还款方式代码
    ,P1.SUB_SCHED_MODE -- 当前子计划方式代码
    ,P1.START_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,nvl(trim(P1.PERIOD_FREQ),'-') -- 频率代码
    ,P1.NEXT_DEAL_DATE -- 下一处理日期
    ,NVL(TRIM(P1.DEAL_DAY),0) -- 处理日
    ,P1.TOTAL_AMT -- 总金额
    ,NVL(TRIM(P1.FIR_PERIOD),0) -- 首段期数
    ,NVL(TRIM(P1.MID_PERIOD),0) -- 累进间隔期数
    ,P1.ADD_AMT -- 累进金额
    ,P1.ADD_RATIO -- 累进比例
    ,nvl(trim(P1.INT_PERIOD_FREQ),'-') -- 结息周期代码
    ,P1.INT_NEXT_DEAL_DATE -- 下一结息日期
    ,NVL(TRIM(P1.INT_DEAL_DAY),0) -- 利息回收日
    ,P1.CALC_TIMES -- 气球贷计算期次
    ,nvl(trim(P1.GRACE_TYPE),'-') -- 宽限期类型代码
    ,P1.GRACE_PERIOD -- 宽限天数
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,nvl(trim(P1.AGREE_CHANGE_TYPE),'-') -- 协议变动方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_irregular_schedule' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_irregular_schedule p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
  	                                        ,repay_plan_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,repay_plan_id -- 还款计划编号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,evt_cate_id -- 事件类别编号
    ,repay_way_cd -- 还款方式代码
    ,curr_sub_plan_way_cd -- 当前子计划方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,freq_cd -- 频率代码
    ,next_proc_dt -- 下一处理日期
    ,proc_day -- 处理日
    ,tot_amt -- 总金额
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,int_set_ped_cd -- 结息周期代码
    ,next_int_set_dt -- 下一结息日期
    ,int_callbk_day -- 利息回收日
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_days -- 宽限天数
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,agt_chg_way_cd -- 协议变动方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,repay_plan_id -- 还款计划编号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,evt_cate_id -- 事件类别编号
    ,repay_way_cd -- 还款方式代码
    ,curr_sub_plan_way_cd -- 当前子计划方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,freq_cd -- 频率代码
    ,next_proc_dt -- 下一处理日期
    ,proc_day -- 处理日
    ,tot_amt -- 总金额
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,int_set_ped_cd -- 结息周期代码
    ,next_int_set_dt -- 下一结息日期
    ,int_callbk_day -- 利息回收日
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_days -- 宽限天数
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,agt_chg_way_cd -- 协议变动方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.repay_plan_id, o.repay_plan_id) as repay_plan_id -- 还款计划编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.evt_cate_id, o.evt_cate_id) as evt_cate_id -- 事件类别编号
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.curr_sub_plan_way_cd, o.curr_sub_plan_way_cd) as curr_sub_plan_way_cd -- 当前子计划方式代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.freq_cd, o.freq_cd) as freq_cd -- 频率代码
    ,nvl(n.next_proc_dt, o.next_proc_dt) as next_proc_dt -- 下一处理日期
    ,nvl(n.proc_day, o.proc_day) as proc_day -- 处理日
    ,nvl(n.tot_amt, o.tot_amt) as tot_amt -- 总金额
    ,nvl(n.perds, o.perds) as perds -- 首段期数
    ,nvl(n.prog_intrv_perds, o.prog_intrv_perds) as prog_intrv_perds -- 累进间隔期数
    ,nvl(n.prog_amt, o.prog_amt) as prog_amt -- 累进金额
    ,nvl(n.prog_ratio, o.prog_ratio) as prog_ratio -- 累进比例
    ,nvl(n.int_set_ped_cd, o.int_set_ped_cd) as int_set_ped_cd -- 结息周期代码
    ,nvl(n.next_int_set_dt, o.next_int_set_dt) as next_int_set_dt -- 下一结息日期
    ,nvl(n.int_callbk_day, o.int_callbk_day) as int_callbk_day -- 利息回收日
    ,nvl(n.blon_loan_calc_pd, o.blon_loan_calc_pd) as blon_loan_calc_pd -- 气球贷计算期次
    ,nvl(n.grace_period_type_cd, o.grace_period_type_cd) as grace_period_type_cd -- 宽限期类型代码
    ,nvl(n.grace_days, o.grace_days) as grace_days -- 宽限天数
    ,nvl(n.sub_acct_fix_int_rat, o.sub_acct_fix_int_rat) as sub_acct_fix_int_rat -- 分户级固定利率
    ,nvl(n.sub_acct_int_rat_float_ratio, o.sub_acct_int_rat_float_ratio) as sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,nvl(n.sub_acct_int_rat_float_point, o.sub_acct_int_rat_float_point) as sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,nvl(n.agt_chg_way_cd, o.agt_chg_way_cd) as agt_chg_way_cd -- 协议变动方式代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.repay_plan_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.repay_plan_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.repay_plan_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.repay_plan_id = n.repay_plan_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
        and o.repay_plan_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
        and n.repay_plan_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.amt_type_cd <> n.amt_type_cd
        or o.evt_cate_id <> n.evt_cate_id
        or o.repay_way_cd <> n.repay_way_cd
        or o.curr_sub_plan_way_cd <> n.curr_sub_plan_way_cd
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.freq_cd <> n.freq_cd
        or o.next_proc_dt <> n.next_proc_dt
        or o.proc_day <> n.proc_day
        or o.tot_amt <> n.tot_amt
        or o.perds <> n.perds
        or o.prog_intrv_perds <> n.prog_intrv_perds
        or o.prog_amt <> n.prog_amt
        or o.prog_ratio <> n.prog_ratio
        or o.int_set_ped_cd <> n.int_set_ped_cd
        or o.next_int_set_dt <> n.next_int_set_dt
        or o.int_callbk_day <> n.int_callbk_day
        or o.blon_loan_calc_pd <> n.blon_loan_calc_pd
        or o.grace_period_type_cd <> n.grace_period_type_cd
        or o.grace_days <> n.grace_days
        or o.sub_acct_fix_int_rat <> n.sub_acct_fix_int_rat
        or o.sub_acct_int_rat_float_ratio <> n.sub_acct_int_rat_float_ratio
        or o.sub_acct_int_rat_float_point <> n.sub_acct_int_rat_float_point
        or o.agt_chg_way_cd <> n.agt_chg_way_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,repay_plan_id -- 还款计划编号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,evt_cate_id -- 事件类别编号
    ,repay_way_cd -- 还款方式代码
    ,curr_sub_plan_way_cd -- 当前子计划方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,freq_cd -- 频率代码
    ,next_proc_dt -- 下一处理日期
    ,proc_day -- 处理日
    ,tot_amt -- 总金额
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,int_set_ped_cd -- 结息周期代码
    ,next_int_set_dt -- 下一结息日期
    ,int_callbk_day -- 利息回收日
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_days -- 宽限天数
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,agt_chg_way_cd -- 协议变动方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,repay_plan_id -- 还款计划编号
    ,cust_id -- 客户编号
    ,amt_type_cd -- 金额类型代码
    ,evt_cate_id -- 事件类别编号
    ,repay_way_cd -- 还款方式代码
    ,curr_sub_plan_way_cd -- 当前子计划方式代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,freq_cd -- 频率代码
    ,next_proc_dt -- 下一处理日期
    ,proc_day -- 处理日
    ,tot_amt -- 总金额
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,int_set_ped_cd -- 结息周期代码
    ,next_int_set_dt -- 下一结息日期
    ,int_callbk_day -- 利息回收日
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_days -- 宽限天数
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,agt_chg_way_cd -- 协议变动方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.acct_id -- 账户编号
    ,o.repay_plan_id -- 还款计划编号
    ,o.cust_id -- 客户编号
    ,o.amt_type_cd -- 金额类型代码
    ,o.evt_cate_id -- 事件类别编号
    ,o.repay_way_cd -- 还款方式代码
    ,o.curr_sub_plan_way_cd -- 当前子计划方式代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.freq_cd -- 频率代码
    ,o.next_proc_dt -- 下一处理日期
    ,o.proc_day -- 处理日
    ,o.tot_amt -- 总金额
    ,o.perds -- 首段期数
    ,o.prog_intrv_perds -- 累进间隔期数
    ,o.prog_amt -- 累进金额
    ,o.prog_ratio -- 累进比例
    ,o.int_set_ped_cd -- 结息周期代码
    ,o.next_int_set_dt -- 下一结息日期
    ,o.int_callbk_day -- 利息回收日
    ,o.blon_loan_calc_pd -- 气球贷计算期次
    ,o.grace_period_type_cd -- 宽限期类型代码
    ,o.grace_days -- 宽限天数
    ,o.sub_acct_fix_int_rat -- 分户级固定利率
    ,o.sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,o.sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,o.agt_chg_way_cd -- 协议变动方式代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_bk o
    left join ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.repay_plan_id = n.repay_plan_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
            and o.repay_plan_id = d.repay_plan_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_irr_repay_plan_h;
--alter table ${iml_schema}.agt_irr_repay_plan_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_irr_repay_plan_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_irr_repay_plan_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_irr_repay_plan_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_irr_repay_plan_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_cl;
alter table ${iml_schema}.agt_irr_repay_plan_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_irr_repay_plan_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_irr_repay_plan_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_irr_repay_plan_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
