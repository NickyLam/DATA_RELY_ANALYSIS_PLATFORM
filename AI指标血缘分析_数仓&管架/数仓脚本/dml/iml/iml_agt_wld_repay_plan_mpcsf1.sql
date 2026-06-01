/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_repay_plan_mpcsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wld_repay_plan_mpcsf1_tm purge;
drop table ${iml_schema}.agt_wld_repay_plan_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_wld_repay_plan add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wld_repay_plan modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;


alter table ${iml_schema}.agt_wld_repay_plan_his modify partition p_mpcsi1 
    drop subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wld_repay_plan_his add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${year_start} values (to_date('${year_start}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wld_repay_plan_his modify partition p_mpcsi1
    add subpartition p_mpcsi1_${year_start} values (to_date('${year_start}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
--手工sql bk表仅取非往年结清借据的还款计划
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_repay_plan_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select t1.*
from ${iml_schema}.agt_wld_repay_plan t1
   inner join iol.mpcs_a0ntm_loan t2
     on t2.loan_id=t1.intnal_dubil_id
    and t2.start_dt<to_date('${batch_date}', 'yyyymmdd')
    and t2.end_dt>=to_date('${batch_date}', 'yyyymmdd')
where t1.create_dt < to_date('${batch_date}','yyyymmdd')
 and t1.job_cd='mpcsf1'
 and (t2.PAID_OUT_DATE >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy') or t2.PAID_OUT_DATE = to_date('00010101','yyyymmdd'))
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_repay_plan_mpcsf1_tm
compress ${option_switch} for query high
as
select
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
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_repay_plan
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_wld_repay_plan_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_wld_repay_plan partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a0ntm_schedule-
insert into ${iml_schema}.agt_wld_repay_plan_mpcsf1_tm(
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
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222651'||TO_CHAR(P1.LOAN_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LOAN_ID -- 内部借据编号
    ,TO_CHAR(P1.SCHEDULE_ID) -- 还款计划编号
    ,TO_CHAR(P1.ACCT_NO) -- 账户编号
    ,NVL(TRIM(P1.ACCT_TYPE),'-') -- 账户类型代码
    ,P1.LOGICAL_CARD_NO -- 卡号
    ,P1.LOAN_INIT_TERM -- 贷款总期数
    ,P1.CURR_TERM -- 当前期数
    ,P1.LOAN_INIT_PRIN -- 贷款本金
    ,P1.LOAN_TERM_PRIN -- 应还本金
    ,P1.LOAN_TERM_FEE1 -- 应还费用金额
    ,P1.LOAN_TERM_INTEREST -- 应还利息
    ,P1.PRIN_PAID -- 已偿还本金
    ,P1.INT_PAID -- 已偿还利息
    ,P1.PENALTY_PAID -- 已偿还罚息
    ,P1.COMPOUND_PAID -- 已偿还复利
    ,P1.FEE_PAID -- 已偿还费用
    ,P1.LOAN_PMT_DUE_DATE -- 到款到期还款日期
    ,P1.LOAN_GRACE_DATE -- 宽限日期
    ,to_timestamp(to_char(P1.LAST_MODIFIED_DATETIME,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS.ff6') -- 修改时间
    ,P1.START_DATE -- 起息日期
    ,P1.BATCHFILENAME -- 批量文件名称
    ,P1.SEQNO -- 序列号
    ,NVL(TRIM(P1.SCHEDULE_ACTION),'-') -- 还款计划操作动作代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0ntm_schedule' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0ntm_schedule p1
   inner join iol.mpcs_a0ntm_loan p2
     on p2.loan_id=p1.loan_id
    and p2.start_dt<=to_date('${batch_date}', 'yyyymmdd')
    and p2.end_dt>to_date('${batch_date}', 'yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
 and  (p2.PAID_OUT_DATE >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy') or p2.PAID_OUT_DATE = to_date('00010101','yyyymmdd'))
 and p1.isztdata <> '2' 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wld_repay_plan_mpcsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,repay_plan_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_wld_repay_plan_mpcsf1_ex(
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
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
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
    ,nvl(n.batch_doc_name, o.batch_doc_name) as batch_doc_name -- 批量文件名称
    ,nvl(n.ser_num, o.ser_num) as ser_num -- 序列号
    ,nvl(n.repay_plan_oper_act_cd, o.repay_plan_oper_act_cd) as repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.lp_id is null
                and o.repay_plan_id is null
                and o.curr_perds is null
            ) or (
                o.agt_id <> n.agt_id
                or o.intnal_dubil_id <> n.intnal_dubil_id
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
                or o.batch_doc_name <> n.batch_doc_name
                or o.ser_num <> n.ser_num
                or o.repay_plan_oper_act_cd <> n.repay_plan_oper_act_cd
            ) or (
                 case when (
                           n.lp_id is null
                           and n.repay_plan_id is null
                           and n.curr_perds is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.lp_id is null
                and n.repay_plan_id is null
                and n.curr_perds is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_repay_plan_mpcsf1_tm n
    full join ${iml_schema}.agt_wld_repay_plan_mpcsf1_bk o
        on
            o.lp_id = n.lp_id
            and o.repay_plan_id = n.repay_plan_id
            and o.curr_perds = n.curr_perds
;
commit;

--往往年结清借据的还款计划已初始化，后续每年的0101执行下列脚本，加工往年结清借据的还款计划
insert /*+append*/ into iml.agt_wld_repay_plan_his(
    AGT_ID
   ,LP_ID
   ,INTNAL_DUBIL_ID
   ,REPAY_PLAN_ID
   ,ACCT_ID
   ,ACCT_TYPE_CD
   ,CARD_NO
   ,LOAN_TOT_PERDS
   ,CURR_PERDS
   ,LOAN_PRIC
   ,RPBL_PRIC
   ,RPBL_FEE_AMT
   ,RPBL_INT
   ,REPAID_PRIC
   ,REPAID_INT
   ,REPAID_PNLT
   ,REPAID_COMP_INT
   ,REPAID_FEE
   ,REACH_MONEY_EXP_REPAY_DT
   ,GRACE_DT
   ,MODIF_TM
   ,VALUE_DT
   ,BATCH_DOC_NAME
   ,SER_NUM
   ,REPAY_PLAN_OPER_ACT_CD
   ,ETL_DT
   ,ID_MARK
   ,SRC_TABLE_NAME
   ,JOB_CD
   ,ETL_TIMESTAMP
)
select 
    '222651'||TO_CHAR(T1.LOAN_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,T1.LOAN_ID -- 内部借据编号
    ,TO_CHAR(T1.SCHEDULE_ID) -- 还款计划编号
    ,TO_CHAR(T1.ACCT_NO) -- 账户编号
    ,NVL(TRIM(T1.ACCT_TYPE),'-') -- 账户类型代码
    ,T1.LOGICAL_CARD_NO -- 卡号
    ,T1.LOAN_INIT_TERM -- 贷款总期数
    ,T1.CURR_TERM -- 当前期数
    ,T1.LOAN_INIT_PRIN -- 贷款本金
    ,T1.LOAN_TERM_PRIN -- 应还本金
    ,T1.LOAN_TERM_FEE1 -- 应还费用金额
    ,T1.LOAN_TERM_INTEREST -- 应还利息
    ,T1.PRIN_PAID -- 已偿还本金
    ,T1.INT_PAID -- 已偿还利息
    ,T1.PENALTY_PAID -- 已偿还罚息
    ,T1.COMPOUND_PAID -- 已偿还复利
    ,T1.FEE_PAID -- 已偿还费用
    ,T1.LOAN_PMT_DUE_DATE -- 到款到期还款日期
    ,T1.LOAN_GRACE_DATE -- 宽限日期
    ,to_timestamp(to_char(T1.LAST_MODIFIED_DATETIME,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS.ff6') -- 修改时间
    ,T1.START_DATE -- 起息日期
    ,T1.BATCHFILENAME -- 批量文件名称
    ,T1.SEQNO -- 序列号
    ,NVL(TRIM(T1.SCHEDULE_ACTION),'-') -- 还款计划操作动作代码
    ,to_date('${year_start}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'I' --增删标志
    ,'mpcs_a0ntm_schedule' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0ntm_schedule t1
   inner join iol.mpcs_a0ntm_loan t2
     on t2.loan_id=t1.loan_id
    and t2.start_dt<=to_date('${batch_date}', 'yyyymmdd')
    and t2.end_dt>to_date('${batch_date}', 'yyyymmdd')
where t1.start_dt<=to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt>to_date('${batch_date}', 'yyyymmdd')
 and ${batch_date}=${year_start}
 and t2.paid_out_date between to_date('${last_year_start}','yyyymmdd') and to_date('${year_start}','yyyymmdd')-1
 and t1.isztdata <> '2' 
 ;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wld_repay_plan truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_wld_repay_plan exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_wld_repay_plan_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_wld_repay_plan drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_repay_plan to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wld_repay_plan_mpcsf1_tm purge;
drop table ${iml_schema}.agt_wld_repay_plan_mpcsf1_ex purge;
drop table ${iml_schema}.agt_wld_repay_plan_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_repay_plan', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);