/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ul_acct_schedule_detail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_ul_acct_schedule_detail_ex purge;
alter table ${iol_schema}.ncbs_ul_acct_schedule_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_ul_acct_schedule_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_ul_acct_schedule_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ul_acct_schedule_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_ul_acct_schedule_detail_ex(
    sched_seq_no -- 还款计划序号|还款计划序号
    ,batch_no -- 批次号|批次号
    ,cmisloan_no -- 客户借据编号|客户借据编号
    ,client_no -- 客户编号|客户编号
    ,stage_no -- 期次|期次
    ,amt_type -- 金额类型|金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金,pf-净本金,int-利息,odi-复利,odp-罚息,fee-费用,uni-非本金,all-本加息,ds-前收息金额,prf-提前结清手续费
    ,start_date -- 开始日期|开始日期
    ,receipt_date -- 贷款还款日期|贷款还款日期
    ,end_date -- 结束日期|结束日期
    ,sched_amt -- 还款计划金额|还款计划金额
    ,paid_amt -- 已还金额|已还金额
    ,pri_outstanding -- 贷款还款本金金额|贷款还款本金金额
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,due_date -- 单据到期日|单据到期日
    ,tran_date -- 交易日期|交易日期
    ,final_settle_date -- 最后结算日期|最后结算日期
    ,fully_settled_flag -- 单据全额回收标志|单据全额回收标志
    ,last_change_date -- 最后修改日期|最后修改日期
    ,company -- 法人|法人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sched_seq_no -- 还款计划序号|还款计划序号
    ,batch_no -- 批次号|批次号
    ,cmisloan_no -- 客户借据编号|客户借据编号
    ,client_no -- 客户编号|客户编号
    ,stage_no -- 期次|期次
    ,amt_type -- 金额类型|金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金,pf-净本金,int-利息,odi-复利,odp-罚息,fee-费用,uni-非本金,all-本加息,ds-前收息金额,prf-提前结清手续费
    ,start_date -- 开始日期|开始日期
    ,receipt_date -- 贷款还款日期|贷款还款日期
    ,end_date -- 结束日期|结束日期
    ,sched_amt -- 还款计划金额|还款计划金额
    ,paid_amt -- 已还金额|已还金额
    ,pri_outstanding -- 贷款还款本金金额|贷款还款本金金额
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,due_date -- 单据到期日|单据到期日
    ,tran_date -- 交易日期|交易日期
    ,final_settle_date -- 最后结算日期|最后结算日期
    ,fully_settled_flag -- 单据全额回收标志|单据全额回收标志
    ,last_change_date -- 最后修改日期|最后修改日期
    ,company -- 法人|法人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_ul_acct_schedule_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_ul_acct_schedule_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ul_acct_schedule_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ul_acct_schedule_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_ul_acct_schedule_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ul_acct_schedule_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);