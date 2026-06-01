/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wph_repay_plan_icmsf1
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
alter table ${iml_schema}.agt_wph_repay_plan add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wph_repay_plan_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_repay_plan partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wph_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_wph_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_wph_repay_plan_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_repay_plan_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,currt_perds -- 当期期数
    ,pd_status_cd -- 期次状态代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dt -- 交易日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,rpbl_amt -- 应还金额
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,rpbl_pnlt -- 应还罚息
    ,rpbl_comp_int -- 应还复利
    ,paid_tot_amt -- 实还总金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,currt_bal -- 当期余额
    ,currt_pric_bal -- 当期本金余额
    ,currt_int_bal -- 当期利息余额
    ,currt_pnlt_bal -- 当期罚息余额
    ,currt_comp_int_bal -- 当期复利余额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wph_repay_plan partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wph_repay_plan_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_repay_plan partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wph_repay_plan_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_repay_plan partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_wph_payment_sched-1
insert into ${iml_schema}.agt_wph_repay_plan_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,currt_perds -- 当期期数
    ,pd_status_cd -- 期次状态代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dt -- 交易日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,rpbl_amt -- 应还金额
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,rpbl_pnlt -- 应还罚息
    ,rpbl_comp_int -- 应还复利
    ,paid_tot_amt -- 实还总金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,currt_bal -- 当期余额
    ,currt_pric_bal -- 当期本金余额
    ,currt_int_bal -- 当期利息余额
    ,currt_pnlt_bal -- 当期罚息余额
    ,currt_comp_int_bal -- 当期复利余额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300070'||P1.INTERNALKEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNALKEY -- 借据编号
    ,P1.STAGENO -- 当期期数
    ,P1.PERIODSTATUS -- 期次状态代码
    ,P1.PRODTYPE -- 产品编号
    ,P1.CCY -- 币种代码
    ,${iml_schema}.dateformat_max2(P1.TRANDATE) -- 交易日期
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 起始日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 到期日期
    ,${iml_schema}.dateformat_max2(P1.GRACEPERIODDATE) -- 宽限日期
    ,${iml_schema}.dateformat_max2(P1.SETTLEDATE) -- 结清日期
    ,P1.PERDUEDAY -- 贷款逾期天数
    ,P1.SCHEDAMT -- 应还金额
    ,P1.PRIAMT -- 应还本金
    ,P1.INTAMT -- 应还利息
    ,P1.ODPAMT -- 应还罚息
    ,P1.ODIAMT -- 应还复利
    ,P1.SCHEDPAID -- 实还总金额
    ,P1.PRIPAID -- 实还本金
    ,P1.INTPAID -- 实还利息
    ,P1.ODPPAID -- 实还罚息
    ,P1.ODIPAID -- 实还复利
    ,P1.SCHEDBAL -- 当期余额
    ,P1.PRIBAL -- 当期本金余额
    ,P1.INTBAL -- 当期利息余额
    ,P1.ODPBAL -- 当期罚息余额
    ,P1.ODIBAL -- 当期复利余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wph_payment_sched' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wph_payment_sched p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wph_repay_plan_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dubil_id
  	                                        ,currt_perds
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
        into ${iml_schema}.agt_wph_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,currt_perds -- 当期期数
    ,pd_status_cd -- 期次状态代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dt -- 交易日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,rpbl_amt -- 应还金额
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,rpbl_pnlt -- 应还罚息
    ,rpbl_comp_int -- 应还复利
    ,paid_tot_amt -- 实还总金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,currt_bal -- 当期余额
    ,currt_pric_bal -- 当期本金余额
    ,currt_int_bal -- 当期利息余额
    ,currt_pnlt_bal -- 当期罚息余额
    ,currt_comp_int_bal -- 当期复利余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wph_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,currt_perds -- 当期期数
    ,pd_status_cd -- 期次状态代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dt -- 交易日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,rpbl_amt -- 应还金额
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,rpbl_pnlt -- 应还罚息
    ,rpbl_comp_int -- 应还复利
    ,paid_tot_amt -- 实还总金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,currt_bal -- 当期余额
    ,currt_pric_bal -- 当期本金余额
    ,currt_int_bal -- 当期利息余额
    ,currt_pnlt_bal -- 当期罚息余额
    ,currt_comp_int_bal -- 当期复利余额
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
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.currt_perds, o.currt_perds) as currt_perds -- 当期期数
    ,nvl(n.pd_status_cd, o.pd_status_cd) as pd_status_cd -- 期次状态代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.grace_dt_term, o.grace_dt_term) as grace_dt_term -- 宽限日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 贷款逾期天数
    ,nvl(n.rpbl_amt, o.rpbl_amt) as rpbl_amt -- 应还金额
    ,nvl(n.rpbl_pric, o.rpbl_pric) as rpbl_pric -- 应还本金
    ,nvl(n.rpbl_int, o.rpbl_int) as rpbl_int -- 应还利息
    ,nvl(n.rpbl_pnlt, o.rpbl_pnlt) as rpbl_pnlt -- 应还罚息
    ,nvl(n.rpbl_comp_int, o.rpbl_comp_int) as rpbl_comp_int -- 应还复利
    ,nvl(n.paid_tot_amt, o.paid_tot_amt) as paid_tot_amt -- 实还总金额
    ,nvl(n.paid_pric, o.paid_pric) as paid_pric -- 实还本金
    ,nvl(n.paid_int, o.paid_int) as paid_int -- 实还利息
    ,nvl(n.paid_pnlt, o.paid_pnlt) as paid_pnlt -- 实还罚息
    ,nvl(n.paid_comp_int, o.paid_comp_int) as paid_comp_int -- 实还复利
    ,nvl(n.currt_bal, o.currt_bal) as currt_bal -- 当期余额
    ,nvl(n.currt_pric_bal, o.currt_pric_bal) as currt_pric_bal -- 当期本金余额
    ,nvl(n.currt_int_bal, o.currt_int_bal) as currt_int_bal -- 当期利息余额
    ,nvl(n.currt_pnlt_bal, o.currt_pnlt_bal) as currt_pnlt_bal -- 当期罚息余额
    ,nvl(n.currt_comp_int_bal, o.currt_comp_int_bal) as currt_comp_int_bal -- 当期复利余额
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.currt_perds is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.currt_perds is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.currt_perds is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wph_repay_plan_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wph_repay_plan_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.currt_perds = n.currt_perds
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dubil_id is null
        and o.currt_perds is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dubil_id is null
        and n.currt_perds is null
    )
    or (
        o.pd_status_cd <> n.pd_status_cd
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.tran_dt <> n.tran_dt
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.grace_dt_term <> n.grace_dt_term
        or o.payoff_dt <> n.payoff_dt
        or o.ovdue_days <> n.ovdue_days
        or o.rpbl_amt <> n.rpbl_amt
        or o.rpbl_pric <> n.rpbl_pric
        or o.rpbl_int <> n.rpbl_int
        or o.rpbl_pnlt <> n.rpbl_pnlt
        or o.rpbl_comp_int <> n.rpbl_comp_int
        or o.paid_tot_amt <> n.paid_tot_amt
        or o.paid_pric <> n.paid_pric
        or o.paid_int <> n.paid_int
        or o.paid_pnlt <> n.paid_pnlt
        or o.paid_comp_int <> n.paid_comp_int
        or o.currt_bal <> n.currt_bal
        or o.currt_pric_bal <> n.currt_pric_bal
        or o.currt_int_bal <> n.currt_int_bal
        or o.currt_pnlt_bal <> n.currt_pnlt_bal
        or o.currt_comp_int_bal <> n.currt_comp_int_bal
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wph_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,currt_perds -- 当期期数
    ,pd_status_cd -- 期次状态代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dt -- 交易日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,rpbl_amt -- 应还金额
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,rpbl_pnlt -- 应还罚息
    ,rpbl_comp_int -- 应还复利
    ,paid_tot_amt -- 实还总金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,currt_bal -- 当期余额
    ,currt_pric_bal -- 当期本金余额
    ,currt_int_bal -- 当期利息余额
    ,currt_pnlt_bal -- 当期罚息余额
    ,currt_comp_int_bal -- 当期复利余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wph_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,currt_perds -- 当期期数
    ,pd_status_cd -- 期次状态代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dt -- 交易日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,grace_dt_term -- 宽限日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,rpbl_amt -- 应还金额
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,rpbl_pnlt -- 应还罚息
    ,rpbl_comp_int -- 应还复利
    ,paid_tot_amt -- 实还总金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,currt_bal -- 当期余额
    ,currt_pric_bal -- 当期本金余额
    ,currt_int_bal -- 当期利息余额
    ,currt_pnlt_bal -- 当期罚息余额
    ,currt_comp_int_bal -- 当期复利余额
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
    ,o.dubil_id -- 借据编号
    ,o.currt_perds -- 当期期数
    ,o.pd_status_cd -- 期次状态代码
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.tran_dt -- 交易日期
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.grace_dt_term -- 宽限日期
    ,o.payoff_dt -- 结清日期
    ,o.ovdue_days -- 贷款逾期天数
    ,o.rpbl_amt -- 应还金额
    ,o.rpbl_pric -- 应还本金
    ,o.rpbl_int -- 应还利息
    ,o.rpbl_pnlt -- 应还罚息
    ,o.rpbl_comp_int -- 应还复利
    ,o.paid_tot_amt -- 实还总金额
    ,o.paid_pric -- 实还本金
    ,o.paid_int -- 实还利息
    ,o.paid_pnlt -- 实还罚息
    ,o.paid_comp_int -- 实还复利
    ,o.currt_bal -- 当期余额
    ,o.currt_pric_bal -- 当期本金余额
    ,o.currt_int_bal -- 当期利息余额
    ,o.currt_pnlt_bal -- 当期罚息余额
    ,o.currt_comp_int_bal -- 当期复利余额
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
from ${iml_schema}.agt_wph_repay_plan_icmsf1_bk o
    left join ${iml_schema}.agt_wph_repay_plan_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.currt_perds = n.currt_perds
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wph_repay_plan_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dubil_id = d.dubil_id
            and o.currt_perds = d.currt_perds
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wph_repay_plan;
--alter table ${iml_schema}.agt_wph_repay_plan truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wph_repay_plan') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wph_repay_plan drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wph_repay_plan modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wph_repay_plan exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wph_repay_plan_icmsf1_cl;
alter table ${iml_schema}.agt_wph_repay_plan exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wph_repay_plan_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wph_repay_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wph_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_wph_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_wph_repay_plan_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wph_repay_plan_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wph_repay_plan', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
