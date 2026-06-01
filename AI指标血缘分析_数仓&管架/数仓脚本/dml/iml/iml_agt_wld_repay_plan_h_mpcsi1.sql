/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_repay_plan_h_mpcsi1
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
alter table ${iml_schema}.agt_wld_repay_plan_h add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_repay_plan_h partition for ('mpcsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_tm purge;
drop table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_op purge;
drop table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_tm nologging
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
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_repay_plan_h partition for ('mpcsi1')
where 0=1
;

create table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_repay_plan_h partition for ('mpcsi1') where 0=1;

create table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_repay_plan_h partition for ('mpcsi1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a0ntm_schedule-
insert into ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_tm(
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
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0ntm_schedule p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
     and substr(p1.batchfilename,3,8) = '${batch_date}'
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_op(
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
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.agt_id -- 协议编号
    ,n.lp_id -- 法人编号
    ,n.intnal_dubil_id -- 内部借据编号
    ,n.repay_plan_id -- 还款计划编号
    ,n.acct_id -- 账户编号
    ,n.acct_type_cd -- 账户类型代码
    ,n.card_no -- 卡号
    ,n.loan_tot_perds -- 贷款总期数
    ,n.curr_perds -- 当前期数
    ,n.loan_pric -- 贷款本金
    ,n.rpbl_pric -- 应还本金
    ,n.rpbl_fee_amt -- 应还费用金额
    ,n.rpbl_int -- 应还利息
    ,n.repaid_pric -- 已偿还本金
    ,n.repaid_int -- 已偿还利息
    ,n.repaid_pnlt -- 已偿还罚息
    ,n.repaid_comp_int -- 已偿还复利
    ,n.repaid_fee -- 已偿还费用
    ,n.reach_money_exp_repay_dt -- 到款到期还款日期
    ,n.grace_dt -- 宽限日期
    ,n.modif_tm -- 修改时间
    ,n.value_dt -- 起息日期
    ,n.batch_doc_name -- 批量文件名称
    ,n.ser_num -- 序列号
    ,n.repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'mpcsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_tm n
    left join (select * from ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
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
        or o.batch_doc_name <> n.batch_doc_name
        or o.ser_num <> n.ser_num
        or o.repay_plan_oper_act_cd <> n.repay_plan_oper_act_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_cl(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_op(
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
    ,o.batch_doc_name -- 批量文件名称
    ,o.ser_num -- 序列号
    ,o.repay_plan_oper_act_cd -- 还款计划操作动作代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_bk o
    left join ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.curr_perds = n.curr_perds
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wld_repay_plan_h;
alter table ${iml_schema}.agt_wld_repay_plan_h truncate partition for ('mpcsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_wld_repay_plan_h exchange subpartition p_mpcsi1_19000101 with table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_cl;
alter table ${iml_schema}.agt_wld_repay_plan_h exchange subpartition p_mpcsi1_20991231 with table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_repay_plan_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_tm purge;
drop table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_op purge;
drop table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wld_repay_plan_h_mpcsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_repay_plan_h', partname => 'p_mpcsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
