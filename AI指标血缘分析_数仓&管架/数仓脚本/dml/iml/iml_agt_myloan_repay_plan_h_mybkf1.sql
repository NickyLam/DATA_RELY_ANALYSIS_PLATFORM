/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_myloan_repay_plan_h_mybkf1
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
alter table ${iml_schema}.agt_myloan_repay_plan_h add partition p_mybkf1 values ('mybkf1')(
        subpartition p_mybkf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mybkf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_myloan_repay_plan_h partition for ('mybkf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_tm purge;
drop table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_op purge;
drop table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,rpbl_int -- 应还利息
    ,rpbl_pric -- 应还本金
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,hxb_pd_id -- 我行期次编号
    ,hxb_loan_begin_dt -- 我行贷款起始日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_myloan_repay_plan_h partition for ('mybkf1')
where 0=1
;

create table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_myloan_repay_plan_h partition for ('mybkf1') where 0=1;

create table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_myloan_repay_plan_h partition for ('mybkf1') where 0=1;

-- 3.1 get new data into table
-- icms_mybk_repay_amort_plan-
insert into ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,rpbl_int -- 应还利息
    ,rpbl_pric -- 应还本金
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,hxb_pd_id -- 我行期次编号
    ,hxb_loan_begin_dt -- 我行贷款起始日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222630'||P1.CONTRACTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTRACTNO -- 借据编号
    ,P1.TERMNO -- 期次号
    ,P1.INTAMT -- 应还利息
    ,P1.PRINAMT -- 应还本金
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTDATE) -- 分期开始日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 分期结束日期
    ,nvl(trim(P1.STATUS),'-') -- 分期状态代码
    ,${iml_schema}.dateformat_max2(P1.CLEARDATE) -- 结清日期
    ,${iml_schema}.dateformat_max2(P1.PRINOVDDATE) -- 本金转逾期日期
    ,${iml_schema}.dateformat_max2(P1.INTOVDDATE) -- 利息转逾期日期
    ,P1.PRINOVDDAYS -- 本金逾期天数
    ,P1.INTOVDDAYS -- 利息逾期天数
    ,P1.PRINBAL -- 本金余额
    ,P1.INTBAL -- 利息余额
    ,P1.OVDPRINPNLTBAL -- 应还逾期本金罚息
    ,P1.OVDINTPNLTBAL -- 应还逾期利息罚息
    ,P1.SELFTERMNO -- 我行期次编号
    ,${iml_schema}.dateformat_min(P1.SELFSTARTDATE) -- 我行贷款起始日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_repay_amort_plan' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybk_repay_amort_plan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,pd_num
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
        into ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,rpbl_int -- 应还利息
    ,rpbl_pric -- 应还本金
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,hxb_pd_id -- 我行期次编号
    ,hxb_loan_begin_dt -- 我行贷款起始日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,rpbl_int -- 应还利息
    ,rpbl_pric -- 应还本金
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,hxb_pd_id -- 我行期次编号
    ,hxb_loan_begin_dt -- 我行贷款起始日期
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
    ,nvl(n.pd_num, o.pd_num) as pd_num -- 期次号
    ,nvl(n.rpbl_int, o.rpbl_int) as rpbl_int -- 应还利息
    ,nvl(n.rpbl_pric, o.rpbl_pric) as rpbl_pric -- 应还本金
    ,nvl(n.inst_start_dt, o.inst_start_dt) as inst_start_dt -- 分期开始日期
    ,nvl(n.inst_end_dt, o.inst_end_dt) as inst_end_dt -- 分期结束日期
    ,nvl(n.inst_status_cd, o.inst_status_cd) as inst_status_cd -- 分期状态代码
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.pric_turn_ovdue_dt, o.pric_turn_ovdue_dt) as pric_turn_ovdue_dt -- 本金转逾期日期
    ,nvl(n.int_turn_ovdue_dt, o.int_turn_ovdue_dt) as int_turn_ovdue_dt -- 利息转逾期日期
    ,nvl(n.pric_ovdue_days, o.pric_ovdue_days) as pric_ovdue_days -- 本金逾期天数
    ,nvl(n.int_ovdue_days, o.int_ovdue_days) as int_ovdue_days -- 利息逾期天数
    ,nvl(n.pric_bal, o.pric_bal) as pric_bal -- 本金余额
    ,nvl(n.int_bal, o.int_bal) as int_bal -- 利息余额
    ,nvl(n.rpbl_ovdue_pric_pnlt, o.rpbl_ovdue_pric_pnlt) as rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,nvl(n.rpbl_ovdue_int_pnlt, o.rpbl_ovdue_int_pnlt) as rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,nvl(n.hxb_pd_id, o.hxb_pd_id) as hxb_pd_id -- 我行期次编号
    ,nvl(n.hxb_loan_begin_dt, o.hxb_loan_begin_dt) as hxb_loan_begin_dt -- 我行贷款起始日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.pd_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.pd_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.pd_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_tm n
    full join (select * from ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.pd_num = n.pd_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.pd_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.pd_num is null
    )
    or (
        o.dubil_id <> n.dubil_id
        or o.rpbl_int <> n.rpbl_int
        or o.rpbl_pric <> n.rpbl_pric
        or o.inst_start_dt <> n.inst_start_dt
        or o.inst_end_dt <> n.inst_end_dt
        or o.inst_status_cd <> n.inst_status_cd
        or o.payoff_dt <> n.payoff_dt
        or o.pric_turn_ovdue_dt <> n.pric_turn_ovdue_dt
        or o.int_turn_ovdue_dt <> n.int_turn_ovdue_dt
        or o.pric_ovdue_days <> n.pric_ovdue_days
        or o.int_ovdue_days <> n.int_ovdue_days
        or o.pric_bal <> n.pric_bal
        or o.int_bal <> n.int_bal
        or o.rpbl_ovdue_pric_pnlt <> n.rpbl_ovdue_pric_pnlt
        or o.rpbl_ovdue_int_pnlt <> n.rpbl_ovdue_int_pnlt
        or o.hxb_pd_id <> n.hxb_pd_id
        or o.hxb_loan_begin_dt <> n.hxb_loan_begin_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,rpbl_int -- 应还利息
    ,rpbl_pric -- 应还本金
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,hxb_pd_id -- 我行期次编号
    ,hxb_loan_begin_dt -- 我行贷款起始日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,pd_num -- 期次号
    ,rpbl_int -- 应还利息
    ,rpbl_pric -- 应还本金
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,inst_status_cd -- 分期状态代码
    ,payoff_dt -- 结清日期
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,hxb_pd_id -- 我行期次编号
    ,hxb_loan_begin_dt -- 我行贷款起始日期
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
    ,o.pd_num -- 期次号
    ,o.rpbl_int -- 应还利息
    ,o.rpbl_pric -- 应还本金
    ,o.inst_start_dt -- 分期开始日期
    ,o.inst_end_dt -- 分期结束日期
    ,o.inst_status_cd -- 分期状态代码
    ,o.payoff_dt -- 结清日期
    ,o.pric_turn_ovdue_dt -- 本金转逾期日期
    ,o.int_turn_ovdue_dt -- 利息转逾期日期
    ,o.pric_ovdue_days -- 本金逾期天数
    ,o.int_ovdue_days -- 利息逾期天数
    ,o.pric_bal -- 本金余额
    ,o.int_bal -- 利息余额
    ,o.rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,o.rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,o.hxb_pd_id -- 我行期次编号
    ,o.hxb_loan_begin_dt -- 我行贷款起始日期
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
from ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_bk o
    left join ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.pd_num = n.pd_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.pd_num = d.pd_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_myloan_repay_plan_h;
--alter table ${iml_schema}.agt_myloan_repay_plan_h truncate partition for ('mybkf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_myloan_repay_plan_h') 
               and substr(subpartition_name,1,8)=upper('p_mybkf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_myloan_repay_plan_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_myloan_repay_plan_h modify partition p_mybkf1 
add subpartition p_mybkf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_myloan_repay_plan_h exchange subpartition p_mybkf1_${batch_date} with table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_cl;
alter table ${iml_schema}.agt_myloan_repay_plan_h exchange subpartition p_mybkf1_20991231 with table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_myloan_repay_plan_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_tm purge;
drop table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_op purge;
drop table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_myloan_repay_plan_h_mybkf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_myloan_repay_plan_h', partname => 'p_mybkf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
