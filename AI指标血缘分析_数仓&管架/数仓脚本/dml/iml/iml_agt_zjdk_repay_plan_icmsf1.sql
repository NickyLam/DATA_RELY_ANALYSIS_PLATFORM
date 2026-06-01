/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_zjdk_repay_plan_icmsf1
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
alter table ${iml_schema}.agt_zjdk_repay_plan add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_repay_plan partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 借据编号
    ,tenor -- 期限
    ,fin_dt -- 财务日期
    ,plat_indent_id -- 平台订单编号
    ,ZJDK_PROD_ID -- 字节产品编号
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,curr_issue_status_cd -- 本期状态代码
    ,rpbl_pric -- 应还本金
    ,paid_pric -- 已还本金
    ,plan_int -- 计划利息
    ,rpbl_int -- 应还利息
    ,paid_int -- 已还利息
    ,derate_int -- 减免利息
    ,int_bal -- 利息余额
    ,rpbl_pnlt -- 应还罚息
    ,paid_pnlt -- 已还罚息
    ,derate_pnlt -- 减免罚息
    ,pnlt_bal -- 罚息余额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_zjdk_repay_plan partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_repay_plan partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_repay_plan partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zjbk_repayment_plan_info-1
insert into ${iml_schema}.agt_zjdk_repay_plan_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 借据编号
    ,tenor -- 期限
    ,fin_dt -- 财务日期
    ,plat_indent_id -- 平台订单编号
    ,ZJDK_PROD_ID -- 字节产品编号
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,curr_issue_status_cd -- 本期状态代码
    ,rpbl_pric -- 应还本金
    ,paid_pric -- 已还本金
    ,plan_int -- 计划利息
    ,rpbl_int -- 应还利息
    ,paid_int -- 已还利息
    ,derate_int -- 减免利息
    ,int_bal -- 利息余额
    ,rpbl_pnlt -- 应还罚息
    ,paid_pnlt -- 已还罚息
    ,derate_pnlt -- 减免罚息
    ,pnlt_bal -- 罚息余额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300061'||P1.LOANID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LOANID -- 借据编号
    ,to_number(nvl(trim(P1.TERMNO),'0')) -- 期限
    ,${iml_schema}.dateformat_max2(P1.CURDATE) -- 财务日期
    ,P1.OUTLOANCHANNELNO -- 平台订单编号
    ,P1.PRODUCTNO -- 字节产品编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 起始日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 到期日期
    ,${iml_schema}.dateformat_max2(P1.CLEARDATE) -- 结清日期
    ,to_number(nvl((replace(replace(P1.DAYSOVD,chr(13),''),chr(10),'')),'0')) -- 贷款逾期天数
    ,nvl(trim(P1.TERMSTATUS),'-') -- 本期状态代码
    ,to_number(nvl(trim(P1.PRINTOTAL),'0')) -- 应还本金
    ,to_number(nvl(trim(P1.PRINREPAY),'0')) -- 已还本金
    ,to_number(nvl(trim(P1.INTPLAN),'0')) -- 计划利息
    ,to_number(nvl(trim(P1.INTTOTAL),'0')) -- 应还利息
    ,to_number(nvl(trim(P1.INTREPAY),'0')) -- 已还利息
    ,to_number(nvl(trim(P1.INTDISCOUNT),'0')) -- 减免利息
    ,to_number(nvl(trim(P1.INTBAL),'0')) -- 利息余额
    ,to_number(nvl(trim(P1.PNLTINTTOTAL),'0')) -- 应还罚息
    ,to_number(nvl(trim(P1.PNLTINTREPAY),'0')) -- 已还罚息
    ,to_number(nvl(trim(P1.PNLTINTDISCOUNT),'0')) -- 减免罚息
    ,to_number(nvl(trim(P1.PNLTINTBAL),'0')) -- 罚息余额
    ,to_number(nvl(trim(P1.PREPMTFEEREPAY),'0')) -- 已还提前还款手续费
    ,P1.DAILYINT -- 当日计提利息
    ,P1.DAILYPNLTINT -- 当日计提罚息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zjbk_repayment_plan_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_repayment_plan_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_zjdk_repay_plan_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,intnal_dubil_id
  	                                        ,tenor
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
        into ${iml_schema}.agt_zjdk_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 借据编号
    ,tenor -- 期限
    ,fin_dt -- 财务日期
    ,plat_indent_id -- 平台订单编号
    ,ZJDK_PROD_ID -- 字节产品编号
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,curr_issue_status_cd -- 本期状态代码
    ,rpbl_pric -- 应还本金
    ,paid_pric -- 已还本金
    ,plan_int -- 计划利息
    ,rpbl_int -- 应还利息
    ,paid_int -- 已还利息
    ,derate_int -- 减免利息
    ,int_bal -- 利息余额
    ,rpbl_pnlt -- 应还罚息
    ,paid_pnlt -- 已还罚息
    ,derate_pnlt -- 减免罚息
    ,pnlt_bal -- 罚息余额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_zjdk_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 借据编号
    ,tenor -- 期限
    ,fin_dt -- 财务日期
    ,plat_indent_id -- 平台订单编号
    ,ZJDK_PROD_ID -- 字节产品编号
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,curr_issue_status_cd -- 本期状态代码
    ,rpbl_pric -- 应还本金
    ,paid_pric -- 已还本金
    ,plan_int -- 计划利息
    ,rpbl_int -- 应还利息
    ,paid_int -- 已还利息
    ,derate_int -- 减免利息
    ,int_bal -- 利息余额
    ,rpbl_pnlt -- 应还罚息
    ,paid_pnlt -- 已还罚息
    ,derate_pnlt -- 减免罚息
    ,pnlt_bal -- 罚息余额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
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
    ,nvl(n.intnal_dubil_id, o.intnal_dubil_id) as intnal_dubil_id -- 借据编号
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.fin_dt, o.fin_dt) as fin_dt -- 财务日期
    ,nvl(n.plat_indent_id, o.plat_indent_id) as plat_indent_id -- 平台订单编号
    ,nvl(n.ZJDK_PROD_ID, o.ZJDK_PROD_ID) as ZJDK_PROD_ID -- 字节产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 贷款逾期天数
    ,nvl(n.curr_issue_status_cd, o.curr_issue_status_cd) as curr_issue_status_cd -- 本期状态代码
    ,nvl(n.rpbl_pric, o.rpbl_pric) as rpbl_pric -- 应还本金
    ,nvl(n.paid_pric, o.paid_pric) as paid_pric -- 已还本金
    ,nvl(n.plan_int, o.plan_int) as plan_int -- 计划利息
    ,nvl(n.rpbl_int, o.rpbl_int) as rpbl_int -- 应还利息
    ,nvl(n.paid_int, o.paid_int) as paid_int -- 已还利息
    ,nvl(n.derate_int, o.derate_int) as derate_int -- 减免利息
    ,nvl(n.int_bal, o.int_bal) as int_bal -- 利息余额
    ,nvl(n.rpbl_pnlt, o.rpbl_pnlt) as rpbl_pnlt -- 应还罚息
    ,nvl(n.paid_pnlt, o.paid_pnlt) as paid_pnlt -- 已还罚息
    ,nvl(n.derate_pnlt, o.derate_pnlt) as derate_pnlt -- 减免罚息
    ,nvl(n.pnlt_bal, o.pnlt_bal) as pnlt_bal -- 罚息余额
    ,nvl(n.paid_adv_repay_comm_fee, o.paid_adv_repay_comm_fee) as paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,nvl(n.td_provi_int, o.td_provi_int) as td_provi_int -- 当日计提利息
    ,nvl(n.td_provi_pnlt, o.td_provi_pnlt) as td_provi_pnlt -- 当日计提罚息
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.intnal_dubil_id is null
            and n.tenor is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.intnal_dubil_id is null
            and n.tenor is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.intnal_dubil_id is null
            and n.tenor is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_zjdk_repay_plan_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_zjdk_repay_plan_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.intnal_dubil_id = n.intnal_dubil_id
            and o.tenor = n.tenor
where (
        o.agt_id is null
        and o.lp_id is null
        and o.intnal_dubil_id is null
        and o.tenor is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.intnal_dubil_id is null
        and n.tenor is null
    )
    or (
        o.fin_dt <> n.fin_dt
        or o.plat_indent_id <> n.plat_indent_id
        or o.ZJDK_PROD_ID <> n.ZJDK_PROD_ID
        or o.curr_cd <> n.curr_cd
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.payoff_dt <> n.payoff_dt
        or o.ovdue_days <> n.ovdue_days
        or o.curr_issue_status_cd <> n.curr_issue_status_cd
        or o.rpbl_pric <> n.rpbl_pric
        or o.paid_pric <> n.paid_pric
        or o.plan_int <> n.plan_int
        or o.rpbl_int <> n.rpbl_int
        or o.paid_int <> n.paid_int
        or o.derate_int <> n.derate_int
        or o.int_bal <> n.int_bal
        or o.rpbl_pnlt <> n.rpbl_pnlt
        or o.paid_pnlt <> n.paid_pnlt
        or o.derate_pnlt <> n.derate_pnlt
        or o.pnlt_bal <> n.pnlt_bal
        or o.paid_adv_repay_comm_fee <> n.paid_adv_repay_comm_fee
        or o.td_provi_int <> n.td_provi_int
        or o.td_provi_pnlt <> n.td_provi_pnlt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_zjdk_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 借据编号
    ,tenor -- 期限
    ,fin_dt -- 财务日期
    ,plat_indent_id -- 平台订单编号
    ,ZJDK_PROD_ID -- 字节产品编号
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,curr_issue_status_cd -- 本期状态代码
    ,rpbl_pric -- 应还本金
    ,paid_pric -- 已还本金
    ,plan_int -- 计划利息
    ,rpbl_int -- 应还利息
    ,paid_int -- 已还利息
    ,derate_int -- 减免利息
    ,int_bal -- 利息余额
    ,rpbl_pnlt -- 应还罚息
    ,paid_pnlt -- 已还罚息
    ,derate_pnlt -- 减免罚息
    ,pnlt_bal -- 罚息余额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_zjdk_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_dubil_id -- 借据编号
    ,tenor -- 期限
    ,fin_dt -- 财务日期
    ,plat_indent_id -- 平台订单编号
    ,ZJDK_PROD_ID -- 字节产品编号
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,ovdue_days -- 贷款逾期天数
    ,curr_issue_status_cd -- 本期状态代码
    ,rpbl_pric -- 应还本金
    ,paid_pric -- 已还本金
    ,plan_int -- 计划利息
    ,rpbl_int -- 应还利息
    ,paid_int -- 已还利息
    ,derate_int -- 减免利息
    ,int_bal -- 利息余额
    ,rpbl_pnlt -- 应还罚息
    ,paid_pnlt -- 已还罚息
    ,derate_pnlt -- 减免罚息
    ,pnlt_bal -- 罚息余额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
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
    ,o.intnal_dubil_id -- 借据编号
    ,o.tenor -- 期限
    ,o.fin_dt -- 财务日期
    ,o.plat_indent_id -- 平台订单编号
    ,o.ZJDK_PROD_ID -- 字节产品编号
    ,o.curr_cd -- 币种代码
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.payoff_dt -- 结清日期
    ,o.ovdue_days -- 贷款逾期天数
    ,o.curr_issue_status_cd -- 本期状态代码
    ,o.rpbl_pric -- 应还本金
    ,o.paid_pric -- 已还本金
    ,o.plan_int -- 计划利息
    ,o.rpbl_int -- 应还利息
    ,o.paid_int -- 已还利息
    ,o.derate_int -- 减免利息
    ,o.int_bal -- 利息余额
    ,o.rpbl_pnlt -- 应还罚息
    ,o.paid_pnlt -- 已还罚息
    ,o.derate_pnlt -- 减免罚息
    ,o.pnlt_bal -- 罚息余额
    ,o.paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,o.td_provi_int -- 当日计提利息
    ,o.td_provi_pnlt -- 当日计提罚息
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
from ${iml_schema}.agt_zjdk_repay_plan_icmsf1_bk o
    left join ${iml_schema}.agt_zjdk_repay_plan_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.intnal_dubil_id = n.intnal_dubil_id
            and o.tenor = n.tenor
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_zjdk_repay_plan_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.intnal_dubil_id = d.intnal_dubil_id
            and o.tenor = d.tenor
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_zjdk_repay_plan;
--alter table ${iml_schema}.agt_zjdk_repay_plan truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_zjdk_repay_plan') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_zjdk_repay_plan drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_zjdk_repay_plan modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_zjdk_repay_plan exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_cl;
alter table ${iml_schema}.agt_zjdk_repay_plan exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_zjdk_repay_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_zjdk_repay_plan_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_zjdk_repay_plan', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
