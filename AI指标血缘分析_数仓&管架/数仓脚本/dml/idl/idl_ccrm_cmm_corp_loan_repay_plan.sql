/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ccrm_cmm_corp_loan_repay_plan
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.ccrm_cmm_corp_loan_repay_plan drop partition p_${last_date};
alter table ${idl_schema}.ccrm_cmm_corp_loan_repay_plan drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ccrm_cmm_corp_loan_repay_plan add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ccrm_cmm_corp_loan_repay_plan (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,dubil_id  -- 借据编号
    ,acct_id  -- 账户编号
    ,cust_id  -- 客户编号
    ,tot_perds  -- 总期数
    ,repay_perds  -- 还款期数
    ,repay_sub_perds  -- 还款子期数
    ,value_dt  -- 起息日期
    ,repaybl_dt  -- 应还款日期
    ,exec_status_flg  -- 执行状态标志
    ,ovdue_flg  -- 逾期标志
    ,irr_repay_plan_flg  -- 不规则还款计划标志
    ,repay_flg  -- 偿还标志
    ,is_int_set_flg  -- 是否结息标志
    ,repay_cate_cd  -- 还款类别代码
    ,repay_way_cd  -- 还款方式代码
    ,curr_cd  -- 币种代码
    ,exec_int_rat  -- 执行利率
    ,acru_nomal_pric  -- 应计正常本金
    ,curr_issue_recvbl_pric  -- 本期应收本金
    ,curr_issue_int_recvbl  -- 本期应收利息
    ,curr_issue_recvbl_fee  -- 本期应收费用
    ,curr_issue_int_sub_amt  -- 本期贴息金额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.dubil_id,chr(13),''),chr(10),'')  -- 借据编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,t1.tot_perds  -- 总期数
    ,t1.repay_perds  -- 还款期数
    ,t1.repay_sub_perds  -- 还款子期数
    ,t1.value_dt  -- 起息日期
    ,t1.repaybl_dt  -- 应还款日期
    ,replace(replace(t1.exec_status_flg,chr(13),''),chr(10),'')  -- 执行状态标志
    ,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'')  -- 逾期标志
    ,replace(replace(t1.irr_repay_plan_flg,chr(13),''),chr(10),'')  -- 不规则还款计划标志
    ,replace(replace(t1.repay_flg,chr(13),''),chr(10),'')  -- 偿还标志
    ,replace(replace(t1.is_int_set_flg,chr(13),''),chr(10),'')  -- 是否结息标志
    ,replace(replace(t1.repay_cate_cd,chr(13),''),chr(10),'')  -- 还款类别代码
    ,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'')  -- 还款方式代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.exec_int_rat  -- 执行利率
    ,t1.acru_nomal_pric  -- 应计正常本金
    ,t1.curr_issue_recvbl_pric  -- 本期应收本金
    ,t1.curr_issue_int_recvbl  -- 本期应收利息
    ,t1.curr_issue_recvbl_fee  -- 本期应收费用
    ,t1.curr_issue_int_sub_amt  -- 本期贴息金额
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_corp_loan_repay_plan t1    --对公贷款还款计划
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ccrm_cmm_corp_loan_repay_plan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);