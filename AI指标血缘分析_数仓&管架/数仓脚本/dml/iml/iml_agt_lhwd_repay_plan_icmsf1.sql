/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lhwd_repay_plan_icmsf1
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
alter table ${iml_schema}.agt_lhwd_repay_plan add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_repay_plan partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,partner_dubil_id -- 合作方借据编号
    ,curr_perds -- 当前期数
    ,currt_status_cd -- 当期状态代码
    ,curr_cd -- 币种代码
    ,repay_dt -- 还款日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,int_accr_end_dt -- 计息结束日期
    ,rpbl_pric -- 应还本金
    ,pric_bal -- 本金余额
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,derate_comp_int -- 减免复利
    ,int_bal -- 利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复利余额
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lhwd_repay_plan partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_repay_plan partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_repay_plan partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_lhwd_repayment_plan_info-1
insert into ${iml_schema}.agt_lhwd_repay_plan_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,partner_dubil_id -- 合作方借据编号
    ,curr_perds -- 当前期数
    ,currt_status_cd -- 当期状态代码
    ,curr_cd -- 币种代码
    ,repay_dt -- 还款日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,int_accr_end_dt -- 计息结束日期
    ,rpbl_pric -- 应还本金
    ,pric_bal -- 本金余额
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,derate_comp_int -- 减免复利
    ,int_bal -- 利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复利余额
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300076'||P2.HXBDSERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P2.HXBDSERIALNO -- 借据编号
    ,P1.LOANID -- 合作方借据编号
    ,to_number(nvl(trim(P1.TERMNO),'0')) -- 当前期数
    ,nvl(trim(P1.TERMSTATUS),'0') -- 当期状态代码
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,${iml_schema}.dateformat_max2(P1.CURDATE) -- 还款日期
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 起始日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 到期日期
    ,${iml_schema}.dateformat_max2(P1.CLEARDATE) -- 结清日期
    ,${iml_schema}.dateformat_max2(P1.WITHDRAWENDDATE) -- 计息结束日期
    ,P1.NORMALSUM -- 应还本金
    ,P1.PRINBAL -- 本金余额
    ,P1.INTTOTAL -- 应收利息
    ,P1.PNLTINTTOTAL -- 应收罚息
    ,P1.PNLTODIAMT -- 应收复利
    ,P1.PRINREPAY -- 实还本金
    ,P1.INTREPAY -- 实还利息
    ,P1.PNLTINTREPAY -- 实还罚息
    ,P1.PNLTODIAMTPAY -- 实还复利
    ,P1.INTDISCOUNT -- 减免利息
    ,P1.PNLTINTDISCOUNT -- 减免罚息
    ,P1.PNLTODIDISCOUNT -- 减免复利
    ,P1.INTBAL -- 利息余额
    ,P1.PNLTINTBAL -- 罚息余额
    ,P1.PNLTODIBAL -- 复利余额
    ,to_number(nvl(P1.DAYSOVD,'0')) -- 本金逾期天数
    ,to_number(nvl(P1.INTDAYSOVD,'0')) -- 利息逾期天数
    ,P1.DAYSOVDT -- 本金转逾期日期
    ,P1.INTDAYSOVDT -- 利息转逾期日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lhwd_repayment_plan_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
 from ${iol_schema}.icms_lhwd_repayment_plan_info p1
 inner join ${iol_schema}.icms_lhwd_business_duebill_his p2 on p1.loanid = p2.serialno 
  and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lhwd_repay_plan_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dubil_id
  	                                        ,partner_dubil_id
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
        into ${iml_schema}.agt_lhwd_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,partner_dubil_id -- 合作方借据编号
    ,curr_perds -- 当前期数
    ,currt_status_cd -- 当期状态代码
    ,curr_cd -- 币种代码
    ,repay_dt -- 还款日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,int_accr_end_dt -- 计息结束日期
    ,rpbl_pric -- 应还本金
    ,pric_bal -- 本金余额
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,derate_comp_int -- 减免复利
    ,int_bal -- 利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复利余额
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lhwd_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,partner_dubil_id -- 合作方借据编号
    ,curr_perds -- 当前期数
    ,currt_status_cd -- 当期状态代码
    ,curr_cd -- 币种代码
    ,repay_dt -- 还款日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,int_accr_end_dt -- 计息结束日期
    ,rpbl_pric -- 应还本金
    ,pric_bal -- 本金余额
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,derate_comp_int -- 减免复利
    ,int_bal -- 利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复利余额
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
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
    ,nvl(n.partner_dubil_id, o.partner_dubil_id) as partner_dubil_id -- 合作方借据编号
    ,nvl(n.curr_perds, o.curr_perds) as curr_perds -- 当前期数
    ,nvl(n.currt_status_cd, o.currt_status_cd) as currt_status_cd -- 当期状态代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.repay_dt, o.repay_dt) as repay_dt -- 还款日期
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.int_accr_end_dt, o.int_accr_end_dt) as int_accr_end_dt -- 计息结束日期
    ,nvl(n.rpbl_pric, o.rpbl_pric) as rpbl_pric -- 应还本金
    ,nvl(n.pric_bal, o.pric_bal) as pric_bal -- 本金余额
    ,nvl(n.int_recvbl, o.int_recvbl) as int_recvbl -- 应收利息
    ,nvl(n.recvbl_pnlt, o.recvbl_pnlt) as recvbl_pnlt -- 应收罚息
    ,nvl(n.recvbl_comp_int, o.recvbl_comp_int) as recvbl_comp_int -- 应收复利
    ,nvl(n.paid_pric, o.paid_pric) as paid_pric -- 实还本金
    ,nvl(n.paid_int, o.paid_int) as paid_int -- 实还利息
    ,nvl(n.paid_pnlt, o.paid_pnlt) as paid_pnlt -- 实还罚息
    ,nvl(n.paid_comp_int, o.paid_comp_int) as paid_comp_int -- 实还复利
    ,nvl(n.derate_int, o.derate_int) as derate_int -- 减免利息
    ,nvl(n.derate_pnlt, o.derate_pnlt) as derate_pnlt -- 减免罚息
    ,nvl(n.derate_comp_int, o.derate_comp_int) as derate_comp_int -- 减免复利
    ,nvl(n.int_bal, o.int_bal) as int_bal -- 利息余额
    ,nvl(n.pnlt_bal, o.pnlt_bal) as pnlt_bal -- 罚息余额
    ,nvl(n.comp_int_bal, o.comp_int_bal) as comp_int_bal -- 复利余额
    ,nvl(n.pric_ovdue_days, o.pric_ovdue_days) as pric_ovdue_days -- 本金逾期天数
    ,nvl(n.int_ovdue_days, o.int_ovdue_days) as int_ovdue_days -- 利息逾期天数
    ,nvl(n.pric_turn_ovdue_dt, o.pric_turn_ovdue_dt) as pric_turn_ovdue_dt -- 本金转逾期日期
    ,nvl(n.int_turn_ovdue_dt, o.int_turn_ovdue_dt) as int_turn_ovdue_dt -- 利息转逾期日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.partner_dubil_id is null
            and n.curr_perds is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.partner_dubil_id is null
            and n.curr_perds is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.partner_dubil_id is null
            and n.curr_perds is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lhwd_repay_plan_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lhwd_repay_plan_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.partner_dubil_id = n.partner_dubil_id
            and o.curr_perds = n.curr_perds
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dubil_id is null
        and o.partner_dubil_id is null
        and o.curr_perds is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dubil_id is null
        and n.partner_dubil_id is null
        and n.curr_perds is null
    )
    or (
        o.currt_status_cd <> n.currt_status_cd
        or o.curr_cd <> n.curr_cd
        or o.repay_dt <> n.repay_dt
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.payoff_dt <> n.payoff_dt
        or o.int_accr_end_dt <> n.int_accr_end_dt
        or o.rpbl_pric <> n.rpbl_pric
        or o.pric_bal <> n.pric_bal
        or o.int_recvbl <> n.int_recvbl
        or o.recvbl_pnlt <> n.recvbl_pnlt
        or o.recvbl_comp_int <> n.recvbl_comp_int
        or o.paid_pric <> n.paid_pric
        or o.paid_int <> n.paid_int
        or o.paid_pnlt <> n.paid_pnlt
        or o.paid_comp_int <> n.paid_comp_int
        or o.derate_int <> n.derate_int
        or o.derate_pnlt <> n.derate_pnlt
        or o.derate_comp_int <> n.derate_comp_int
        or o.int_bal <> n.int_bal
        or o.pnlt_bal <> n.pnlt_bal
        or o.comp_int_bal <> n.comp_int_bal
        or o.pric_ovdue_days <> n.pric_ovdue_days
        or o.int_ovdue_days <> n.int_ovdue_days
        or o.pric_turn_ovdue_dt <> n.pric_turn_ovdue_dt
        or o.int_turn_ovdue_dt <> n.int_turn_ovdue_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lhwd_repay_plan_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,partner_dubil_id -- 合作方借据编号
    ,curr_perds -- 当前期数
    ,currt_status_cd -- 当期状态代码
    ,curr_cd -- 币种代码
    ,repay_dt -- 还款日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,int_accr_end_dt -- 计息结束日期
    ,rpbl_pric -- 应还本金
    ,pric_bal -- 本金余额
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,derate_comp_int -- 减免复利
    ,int_bal -- 利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复利余额
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lhwd_repay_plan_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,partner_dubil_id -- 合作方借据编号
    ,curr_perds -- 当前期数
    ,currt_status_cd -- 当期状态代码
    ,curr_cd -- 币种代码
    ,repay_dt -- 还款日期
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,int_accr_end_dt -- 计息结束日期
    ,rpbl_pric -- 应还本金
    ,pric_bal -- 本金余额
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复利
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,derate_comp_int -- 减免复利
    ,int_bal -- 利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复利余额
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,pric_turn_ovdue_dt -- 本金转逾期日期
    ,int_turn_ovdue_dt -- 利息转逾期日期
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
    ,o.partner_dubil_id -- 合作方借据编号
    ,o.curr_perds -- 当前期数
    ,o.currt_status_cd -- 当期状态代码
    ,o.curr_cd -- 币种代码
    ,o.repay_dt -- 还款日期
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.payoff_dt -- 结清日期
    ,o.int_accr_end_dt -- 计息结束日期
    ,o.rpbl_pric -- 应还本金
    ,o.pric_bal -- 本金余额
    ,o.int_recvbl -- 应收利息
    ,o.recvbl_pnlt -- 应收罚息
    ,o.recvbl_comp_int -- 应收复利
    ,o.paid_pric -- 实还本金
    ,o.paid_int -- 实还利息
    ,o.paid_pnlt -- 实还罚息
    ,o.paid_comp_int -- 实还复利
    ,o.derate_int -- 减免利息
    ,o.derate_pnlt -- 减免罚息
    ,o.derate_comp_int -- 减免复利
    ,o.int_bal -- 利息余额
    ,o.pnlt_bal -- 罚息余额
    ,o.comp_int_bal -- 复利余额
    ,o.pric_ovdue_days -- 本金逾期天数
    ,o.int_ovdue_days -- 利息逾期天数
    ,o.pric_turn_ovdue_dt -- 本金转逾期日期
    ,o.int_turn_ovdue_dt -- 利息转逾期日期
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
from ${iml_schema}.agt_lhwd_repay_plan_icmsf1_bk o
    left join ${iml_schema}.agt_lhwd_repay_plan_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.partner_dubil_id = n.partner_dubil_id
            and o.curr_perds = n.curr_perds
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lhwd_repay_plan_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dubil_id = d.dubil_id
            and o.partner_dubil_id = d.partner_dubil_id
            and o.curr_perds = d.curr_perds
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lhwd_repay_plan;
--alter table ${iml_schema}.agt_lhwd_repay_plan truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lhwd_repay_plan') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lhwd_repay_plan drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lhwd_repay_plan modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lhwd_repay_plan exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_cl;
alter table ${iml_schema}.agt_lhwd_repay_plan exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lhwd_repay_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_tm purge;
drop table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_op purge;
drop table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lhwd_repay_plan_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lhwd_repay_plan', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
