/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_unite_lon_repay_plan_dtl_h_ncbsf1
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
alter table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unite_lon_repay_plan_dtl_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,dubil_id -- 借据编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,repay_plan_amt -- 还款计划金额
    ,loan_repay_pric -- 贷款还款本金
    ,paid_amt -- 已还金额
    ,cust_id -- 客户编号
    ,doc_full_amt_callbk_flg -- 单据全额回收标志
    ,loan_repay_dt -- 贷款还款日期
    ,doc_exp_dt -- 单据到期日期
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,stl_dt -- 结算日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_unite_lon_repay_plan_dtl_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unite_lon_repay_plan_dtl_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unite_lon_repay_plan_dtl_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_ul_acct_schedule_detail-1
insert into ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,dubil_id -- 借据编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,repay_plan_amt -- 还款计划金额
    ,loan_repay_pric -- 贷款还款本金
    ,paid_amt -- 已还金额
    ,cust_id -- 客户编号
    ,doc_full_amt_callbk_flg -- 单据全额回收标志
    ,loan_repay_dt -- 贷款还款日期
    ,doc_exp_dt -- 单据到期日期
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,stl_dt -- 结算日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222630'||P1.CMISLOAN_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SCHED_SEQ_NO -- 还款计划编号
    ,P1.CMISLOAN_NO -- 借据编号
    ,P1.STAGE_NO -- 当前期次
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,P1.SCHED_AMT -- 还款计划金额
    ,P1.PRI_OUTSTANDING -- 贷款还款本金
    ,P1.PAID_AMT -- 已还金额
    ,P1.CLIENT_NO -- 客户编号
    ,decode(trim(P1.FULLY_SETTLED_FLAG),'Y','1','N','0','','-') -- 单据全额回收标志
    ,P1.RECEIPT_DATE -- 贷款还款日期
    ,P1.DUE_DATE -- 单据到期日期
    ,P1.START_DATE -- 起息日期
    ,P1.END_DATE -- 结息日期
    ,P1.FINAL_SETTLE_DATE -- 结算日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_ul_acct_schedule_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_ul_acct_schedule_detail p1
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
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
        into ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,dubil_id -- 借据编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,repay_plan_amt -- 还款计划金额
    ,loan_repay_pric -- 贷款还款本金
    ,paid_amt -- 已还金额
    ,cust_id -- 客户编号
    ,doc_full_amt_callbk_flg -- 单据全额回收标志
    ,loan_repay_dt -- 贷款还款日期
    ,doc_exp_dt -- 单据到期日期
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,stl_dt -- 结算日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,dubil_id -- 借据编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,repay_plan_amt -- 还款计划金额
    ,loan_repay_pric -- 贷款还款本金
    ,paid_amt -- 已还金额
    ,cust_id -- 客户编号
    ,doc_full_amt_callbk_flg -- 单据全额回收标志
    ,loan_repay_dt -- 贷款还款日期
    ,doc_exp_dt -- 单据到期日期
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,stl_dt -- 结算日期
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
    ,nvl(n.repay_plan_id, o.repay_plan_id) as repay_plan_id -- 还款计划编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.curr_pd, o.curr_pd) as curr_pd -- 当前期次
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.repay_plan_amt, o.repay_plan_amt) as repay_plan_amt -- 还款计划金额
    ,nvl(n.loan_repay_pric, o.loan_repay_pric) as loan_repay_pric -- 贷款还款本金
    ,nvl(n.paid_amt, o.paid_amt) as paid_amt -- 已还金额
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.doc_full_amt_callbk_flg, o.doc_full_amt_callbk_flg) as doc_full_amt_callbk_flg -- 单据全额回收标志
    ,nvl(n.loan_repay_dt, o.loan_repay_dt) as loan_repay_dt -- 贷款还款日期
    ,nvl(n.doc_exp_dt, o.doc_exp_dt) as doc_exp_dt -- 单据到期日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.int_set_dt, o.int_set_dt) as int_set_dt -- 结息日期
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.repay_plan_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.repay_plan_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.repay_plan_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.repay_plan_id = n.repay_plan_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.repay_plan_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.repay_plan_id is null
    )
    or (
        o.dubil_id <> n.dubil_id
        or o.curr_pd <> n.curr_pd
        or o.amt_type_cd <> n.amt_type_cd
        or o.repay_plan_amt <> n.repay_plan_amt
        or o.loan_repay_pric <> n.loan_repay_pric
        or o.paid_amt <> n.paid_amt
        or o.cust_id <> n.cust_id
        or o.doc_full_amt_callbk_flg <> n.doc_full_amt_callbk_flg
        or o.loan_repay_dt <> n.loan_repay_dt
        or o.doc_exp_dt <> n.doc_exp_dt
        or o.value_dt <> n.value_dt
        or o.int_set_dt <> n.int_set_dt
        or o.stl_dt <> n.stl_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,dubil_id -- 借据编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,repay_plan_amt -- 还款计划金额
    ,loan_repay_pric -- 贷款还款本金
    ,paid_amt -- 已还金额
    ,cust_id -- 客户编号
    ,doc_full_amt_callbk_flg -- 单据全额回收标志
    ,loan_repay_dt -- 贷款还款日期
    ,doc_exp_dt -- 单据到期日期
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,stl_dt -- 结算日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,dubil_id -- 借据编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,repay_plan_amt -- 还款计划金额
    ,loan_repay_pric -- 贷款还款本金
    ,paid_amt -- 已还金额
    ,cust_id -- 客户编号
    ,doc_full_amt_callbk_flg -- 单据全额回收标志
    ,loan_repay_dt -- 贷款还款日期
    ,doc_exp_dt -- 单据到期日期
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,stl_dt -- 结算日期
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
    ,o.repay_plan_id -- 还款计划编号
    ,o.dubil_id -- 借据编号
    ,o.curr_pd -- 当前期次
    ,o.amt_type_cd -- 金额类型代码
    ,o.repay_plan_amt -- 还款计划金额
    ,o.loan_repay_pric -- 贷款还款本金
    ,o.paid_amt -- 已还金额
    ,o.cust_id -- 客户编号
    ,o.doc_full_amt_callbk_flg -- 单据全额回收标志
    ,o.loan_repay_dt -- 贷款还款日期
    ,o.doc_exp_dt -- 单据到期日期
    ,o.value_dt -- 起息日期
    ,o.int_set_dt -- 结息日期
    ,o.stl_dt -- 结算日期
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
from ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_bk o
    left join ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.repay_plan_id = n.repay_plan_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.repay_plan_id = d.repay_plan_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h;
--alter table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_unite_lon_repay_plan_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_cl;
alter table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_unite_lon_repay_plan_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_unite_lon_repay_plan_dtl_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_unite_lon_repay_plan_dtl_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
