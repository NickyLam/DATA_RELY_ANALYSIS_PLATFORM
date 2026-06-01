/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_repay_plan
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.crps_cmm_unite_wl_repay_plan drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_repay_plan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_repay_plan partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,dubil_id  -- 借据编号
    ,cust_id  -- 客户编号
    ,prod_id  -- 产品编号
    ,tot_perds  -- 总期数
    ,repay_perds  -- 还款期数
    ,repay_sub_perds  -- 还款子期数
    ,value_dt  -- 起息日期
    ,repaybl_dt  -- 应还款日期
    ,payoff_dt  -- 结清日期
    ,pric_turn_ovdue_dt  -- 本金转逾期日期
    ,int_turn_ovdue_dt  -- 利息转逾期日期
    ,inst_status_cd  -- 分期状态代码
    ,ovdue_flg  -- 逾期标志
    ,repay_flg  -- 偿还标志
    ,curr_cd  -- 币种代码
    ,pric_ovdue_days  -- 本金逾期天数
    ,int_ovdue_days  -- 利息逾期天数
    ,curr_issue_recvbl_pric  -- 本期应收本金
    ,curr_issue_int_recvbl  -- 本期应收利息
    ,curr_issue_recvbl_pric_bal  -- 本期应收本金余额
    ,curr_issue_int_recvbl_bal  -- 本期应收利息余额
    ,curr_issue_ovdue_pric_pnlt  -- 本期逾期本金罚息
    ,curr_issue_ovdue_int_pnlt  -- 本期逾期利息罚息
    ,init_tot_perds  -- 原始总期数
    ,init_repay_perds  -- 原始还款期数
    ,init_value_dt  -- 原始起息日期
    ,grace_dt  -- 宽限日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id  -- 借据编号
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id  -- 产品编号
    ,t.tot_perds as tot_perds  -- 总期数
    ,t.repay_perds as repay_perds  -- 还款期数
    ,t.repay_sub_perds as repay_sub_perds  -- 还款子期数
    ,t.value_dt as value_dt  -- 起息日期
    ,t.repaybl_dt as repaybl_dt  -- 应还款日期
    ,t.payoff_dt as payoff_dt  -- 结清日期
    ,t.pric_turn_ovdue_dt as pric_turn_ovdue_dt  -- 本金转逾期日期
    ,t.int_turn_ovdue_dt as int_turn_ovdue_dt  -- 利息转逾期日期
    ,replace(replace(t.inst_status_cd,chr(13),''),chr(10),'') as inst_status_cd  -- 分期状态代码
    ,replace(replace(t.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg  -- 逾期标志
    ,replace(replace(t.repay_flg,chr(13),''),chr(10),'') as repay_flg  -- 偿还标志
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,t.pric_ovdue_days as pric_ovdue_days  -- 本金逾期天数
    ,t.int_ovdue_days as int_ovdue_days  -- 利息逾期天数
    ,t.curr_issue_recvbl_pric as curr_issue_recvbl_pric  -- 本期应收本金
    ,t.curr_issue_int_recvbl as curr_issue_int_recvbl  -- 本期应收利息
    ,t.curr_issue_recvbl_pric_bal as curr_issue_recvbl_pric_bal  -- 本期应收本金余额
    ,t.curr_issue_int_recvbl_bal as curr_issue_int_recvbl_bal  -- 本期应收利息余额
    ,t.curr_issue_ovdue_pric_pnlt as curr_issue_ovdue_pric_pnlt  -- 本期逾期本金罚息
    ,t.curr_issue_ovdue_int_pnlt as curr_issue_ovdue_int_pnlt  -- 本期逾期利息罚息
    ,t.init_tot_perds as init_tot_perds  -- 原始总期数
    ,t.init_repay_perds as init_repay_perds  -- 原始还款期数
    ,t.init_value_dt as init_value_dt  -- 原始起息日期
    ,t.grace_dt as grace_dt  -- 宽限日期    
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_unite_wl_repay_plan t--联合网贷还款计划
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.crps_cmm_unite_wl_repay_plan to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_repay_plan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);