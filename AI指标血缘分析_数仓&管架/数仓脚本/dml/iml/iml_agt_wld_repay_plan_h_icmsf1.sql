/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_repay_plan_h_icmsf1
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
alter table ${iml_schema}.agt_wld_repay_plan_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_repay_plan_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_op purge;
drop table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,card_no -- 卡号
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,loan_pric -- 贷款本金
    ,rpbl_pric -- 应还本金
    ,rpbl_fee_amt -- 应还费用金额
    ,rpbl_int -- 应还利息
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_pnlt -- 已偿还罚息
    ,repaid_comp_int -- 已偿还复利
    ,repaid_fee -- 已偿还费用
    ,reach_money_exp_repay_dt -- 到款到期还款日期
    ,grace_dt -- 宽限日期
    ,modif_tm -- 修改时间
    ,value_dt -- 起息日期
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_repay_plan_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_repay_plan_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_repay_plan_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_wld_tm_schedule-1
insert into ${iml_schema}.agt_wld_repay_plan_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,card_no -- 卡号
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,loan_pric -- 贷款本金
    ,rpbl_pric -- 应还本金
    ,rpbl_fee_amt -- 应还费用金额
    ,rpbl_int -- 应还利息
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_pnlt -- 已偿还罚息
    ,repaid_comp_int -- 已偿还复利
    ,repaid_fee -- 已偿还费用
    ,reach_money_exp_repay_dt -- 到款到期还款日期
    ,grace_dt -- 宽限日期
    ,modif_tm -- 修改时间
    ,value_dt -- 起息日期
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222651'||TO_CHAR(P1.LOANID)||P1.SCHEDULEID||P1.LOANID -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.LOANID) -- 内部借据编号
    ,TO_CHAR(P1.SCHEDULEID) -- 还款计划编号
    ,TO_CHAR(P1.ACCTNO) -- 账户编号
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 账户类型代码
    ,P1.LOGICALCARDNO -- 卡号
    ,P1.LOANINITTERM -- 贷款总期数
    ,P1.CURRTERM -- 当前期数
    ,P1.LOANINITPRIN -- 贷款本金
    ,P1.LOANTERMPRIN -- 应还本金
    ,P1.LOANTERMFEE1 -- 应还费用金额
    ,P1.LOANTERMINTEGEREREST -- 应还利息
    ,P1.PRINPAID -- 已偿还本金
    ,P1.INTEGERPAID -- 已偿还利息
    ,P1.PENALTYPAID -- 已偿还罚息
    ,P1.COMPOUNDPAID -- 已偿还复利
    ,P1.FEEPAID -- 已偿还费用
    ,P1.LOANPMTDUEDATE -- 到款到期还款日期
    ,P1.LOANGRACEDATE -- 宽限日期
    ,${iml_schema}.TIMEFORMAT_MAX2(P1.LASTMODIFIEDDATETIME) -- 修改时间
    ,P1.STARTDATE -- 起息日期
    ,NVL(TRIM(P1.SCHEDULEACTION),'-') -- 还款计划操作动作代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wld_tm_schedule' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wld_tm_schedule p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wld_repay_plan_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,curr_perds
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
        into ${iml_schema}.agt_wld_repay_plan_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,card_no -- 卡号
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,loan_pric -- 贷款本金
    ,rpbl_pric -- 应还本金
    ,rpbl_fee_amt -- 应还费用金额
    ,rpbl_int -- 应还利息
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_pnlt -- 已偿还罚息
    ,repaid_comp_int -- 已偿还复利
    ,repaid_fee -- 已偿还费用
    ,reach_money_exp_repay_dt -- 到款到期还款日期
    ,grace_dt -- 宽限日期
    ,modif_tm -- 修改时间
    ,value_dt -- 起息日期
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_repay_plan_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,card_no -- 卡号
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,loan_pric -- 贷款本金
    ,rpbl_pric -- 应还本金
    ,rpbl_fee_amt -- 应还费用金额
    ,rpbl_int -- 应还利息
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_pnlt -- 已偿还罚息
    ,repaid_comp_int -- 已偿还复利
    ,repaid_fee -- 已偿还费用
    ,reach_money_exp_repay_dt -- 到款到期还款日期
    ,grace_dt -- 宽限日期
    ,modif_tm -- 修改时间
    ,value_dt -- 起息日期
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
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
    ,nvl(n.intnal_dubil_id, o.intnal_dubil_id) as intnal_dubil_id -- 内部借据编号
    ,nvl(n.repay_plan_id, o.repay_plan_id) as repay_plan_id -- 还款计划编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.loan_tot_perds, o.loan_tot_perds) as loan_tot_perds -- 贷款总期数
    ,nvl(n.curr_perds, o.curr_perds) as curr_perds -- 当前期数
    ,nvl(n.loan_pric, o.loan_pric) as loan_pric -- 贷款本金
    ,nvl(n.rpbl_pric, o.rpbl_pric) as rpbl_pric -- 应还本金
    ,nvl(n.rpbl_fee_amt, o.rpbl_fee_amt) as rpbl_fee_amt -- 应还费用金额
    ,nvl(n.rpbl_int, o.rpbl_int) as rpbl_int -- 应还利息
    ,nvl(n.repaid_pric, o.repaid_pric) as repaid_pric -- 已偿还本金
    ,nvl(n.repaid_int, o.repaid_int) as repaid_int -- 已偿还利息
    ,nvl(n.repaid_pnlt, o.repaid_pnlt) as repaid_pnlt -- 已偿还罚息
    ,nvl(n.repaid_comp_int, o.repaid_comp_int) as repaid_comp_int -- 已偿还复利
    ,nvl(n.repaid_fee, o.repaid_fee) as repaid_fee -- 已偿还费用
    ,nvl(n.reach_money_exp_repay_dt, o.reach_money_exp_repay_dt) as reach_money_exp_repay_dt -- 到款到期还款日期
    ,nvl(n.grace_dt, o.grace_dt) as grace_dt -- 宽限日期
    ,nvl(n.modif_tm, o.modif_tm) as modif_tm -- 修改时间
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.repay_plan_oper_act_cd, o.repay_plan_oper_act_cd) as repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.curr_perds is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.curr_perds is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.curr_perds is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_repay_plan_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wld_repay_plan_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.curr_perds = n.curr_perds
where (
        o.agt_id is null
        and o.lp_id is null
        and o.curr_perds is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.curr_perds is null
    )
    or (
        o.intnal_dubil_id <> n.intnal_dubil_id
        or o.repay_plan_id <> n.repay_plan_id
        or o.acct_id <> n.acct_id
        or o.acct_type_cd <> n.acct_type_cd
        or o.card_no <> n.card_no
        or o.loan_tot_perds <> n.loan_tot_perds
        or o.loan_pric <> n.loan_pric
        or o.rpbl_pric <> n.rpbl_pric
        or o.rpbl_fee_amt <> n.rpbl_fee_amt
        or o.rpbl_int <> n.rpbl_int
        or o.repaid_pric <> n.repaid_pric
        or o.repaid_int <> n.repaid_int
        or o.repaid_pnlt <> n.repaid_pnlt
        or o.repaid_comp_int <> n.repaid_comp_int
        or o.repaid_fee <> n.repaid_fee
        or o.reach_money_exp_repay_dt <> n.reach_money_exp_repay_dt
        or o.grace_dt <> n.grace_dt
        or o.modif_tm <> n.modif_tm
        or o.value_dt <> n.value_dt
        or o.repay_plan_oper_act_cd <> n.repay_plan_oper_act_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wld_repay_plan_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,card_no -- 卡号
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,loan_pric -- 贷款本金
    ,rpbl_pric -- 应还本金
    ,rpbl_fee_amt -- 应还费用金额
    ,rpbl_int -- 应还利息
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_pnlt -- 已偿还罚息
    ,repaid_comp_int -- 已偿还复利
    ,repaid_fee -- 已偿还费用
    ,reach_money_exp_repay_dt -- 到款到期还款日期
    ,grace_dt -- 宽限日期
    ,modif_tm -- 修改时间
    ,value_dt -- 起息日期
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_repay_plan_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 内部借据编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,card_no -- 卡号
    ,loan_tot_perds -- 贷款总期数
    ,curr_perds -- 当前期数
    ,loan_pric -- 贷款本金
    ,rpbl_pric -- 应还本金
    ,rpbl_fee_amt -- 应还费用金额
    ,rpbl_int -- 应还利息
    ,repaid_pric -- 已偿还本金
    ,repaid_int -- 已偿还利息
    ,repaid_pnlt -- 已偿还罚息
    ,repaid_comp_int -- 已偿还复利
    ,repaid_fee -- 已偿还费用
    ,reach_money_exp_repay_dt -- 到款到期还款日期
    ,grace_dt -- 宽限日期
    ,modif_tm -- 修改时间
    ,value_dt -- 起息日期
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
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
    ,o.intnal_dubil_id -- 内部借据编号
    ,o.repay_plan_id -- 还款计划编号
    ,o.acct_id -- 账户编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.card_no -- 卡号
    ,o.loan_tot_perds -- 贷款总期数
    ,o.curr_perds -- 当前期数
    ,o.loan_pric -- 贷款本金
    ,o.rpbl_pric -- 应还本金
    ,o.rpbl_fee_amt -- 应还费用金额
    ,o.rpbl_int -- 应还利息
    ,o.repaid_pric -- 已偿还本金
    ,o.repaid_int -- 已偿还利息
    ,o.repaid_pnlt -- 已偿还罚息
    ,o.repaid_comp_int -- 已偿还复利
    ,o.repaid_fee -- 已偿还费用
    ,o.reach_money_exp_repay_dt -- 到款到期还款日期
    ,o.grace_dt -- 宽限日期
    ,o.modif_tm -- 修改时间
    ,o.value_dt -- 起息日期
    ,o.repay_plan_oper_act_cd -- 还款计划操作动作代码
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
from ${iml_schema}.agt_wld_repay_plan_h_icmsf1_bk o
    left join ${iml_schema}.agt_wld_repay_plan_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.curr_perds = n.curr_perds
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wld_repay_plan_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.curr_perds = d.curr_perds
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wld_repay_plan_h;
--alter table ${iml_schema}.agt_wld_repay_plan_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wld_repay_plan_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wld_repay_plan_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_wld_repay_plan_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wld_repay_plan_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_cl;
alter table ${iml_schema}.agt_wld_repay_plan_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_repay_plan_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_op purge;
drop table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wld_repay_plan_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_repay_plan_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
