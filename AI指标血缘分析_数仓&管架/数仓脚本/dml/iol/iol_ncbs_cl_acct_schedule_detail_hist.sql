/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_schedule_detail_hist
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_acct_schedule_detail_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_op purge;
drop table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ncbs_cl_acct_schedule_detail_hist where 0=1;

create table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ncbs_cl_acct_schedule_detail_hist where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_op(
        amt_type -- 金额类型
        ,client_no -- 客户编号
        ,internal_key -- 账户内部键值
        ,reference -- 交易参考号
        ,user_id -- 交易柜员编号
        ,company -- 法人
        ,fully_settled_flag -- 单据全额回收标志
        ,invoice_gen_mode -- 单据生成方式
        ,invoice_tran_no -- 通知单号
        ,narrative -- 摘要
        ,sched_seq_no -- 还款计划序号
        ,stage_no -- 期次
        ,tax_type -- 税种
        ,due_date -- 单据到期日
        ,end_date -- 结束日期
        ,final_settle_date -- 最后结算日期
        ,grace_date -- 宽限日
        ,last_change_date -- 最后修改日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,billed_amt -- 出单金额
        ,int_rate -- 出单利率
        ,outstanding -- 单据余额
        ,outstanding_prev -- 上日单据未还金额
        ,paid_amt -- 已还金额
        ,pri_outstanding -- 贷款还款本金金额
        ,sched_amt -- 还款计划金额
        ,tax_amt -- 税金
        ,tax_rate -- 税率
        ,wrn_amt -- 贷款核销本金
        ,outstanding_prev_change_date -- 单据上日余额更新日期
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.amt_type -- 金额类型
    ,n.client_no -- 客户编号
    ,n.internal_key -- 账户内部键值
    ,n.reference -- 交易参考号
    ,n.user_id -- 交易柜员编号
    ,n.company -- 法人
    ,n.fully_settled_flag -- 单据全额回收标志
    ,n.invoice_gen_mode -- 单据生成方式
    ,n.invoice_tran_no -- 通知单号
    ,n.narrative -- 摘要
    ,n.sched_seq_no -- 还款计划序号
    ,n.stage_no -- 期次
    ,n.tax_type -- 税种
    ,n.due_date -- 单据到期日
    ,n.end_date -- 结束日期
    ,n.final_settle_date -- 最后结算日期
    ,n.grace_date -- 宽限日
    ,n.last_change_date -- 最后修改日期
    ,n.start_date -- 开始日期
    ,n.tran_date -- 交易日期
    ,n.tran_timestamp -- 交易时间戳
    ,n.billed_amt -- 出单金额
    ,n.int_rate -- 出单利率
    ,n.outstanding -- 单据余额
    ,n.outstanding_prev -- 上日单据未还金额
    ,n.paid_amt -- 已还金额
    ,n.pri_outstanding -- 贷款还款本金金额
    ,n.sched_amt -- 还款计划金额
    ,n.tax_amt -- 税金
    ,n.tax_rate -- 税率
    ,n.wrn_amt -- 贷款核销本金
    ,n.outstanding_prev_change_date -- 单据上日余额更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_bk o
    right join (select * from ${itl_schema}.ncbs_cl_acct_schedule_detail_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sched_seq_no = n.sched_seq_no
where (
        o.sched_seq_no is null
    )
    or (
        o.amt_type <> n.amt_type
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.fully_settled_flag <> n.fully_settled_flag
        or o.invoice_gen_mode <> n.invoice_gen_mode
        or o.invoice_tran_no <> n.invoice_tran_no
        or o.narrative <> n.narrative
        or o.stage_no <> n.stage_no
        or o.tax_type <> n.tax_type
        or o.due_date <> n.due_date
        or o.end_date <> n.end_date
        or o.final_settle_date <> n.final_settle_date
        or o.grace_date <> n.grace_date
        or o.last_change_date <> n.last_change_date
        or o.start_date <> n.start_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.billed_amt <> n.billed_amt
        or o.int_rate <> n.int_rate
        or o.outstanding <> n.outstanding
        or o.outstanding_prev <> n.outstanding_prev
        or o.paid_amt <> n.paid_amt
        or o.pri_outstanding <> n.pri_outstanding
        or o.sched_amt <> n.sched_amt
        or o.tax_amt <> n.tax_amt
        or o.tax_rate <> n.tax_rate
        or o.wrn_amt <> n.wrn_amt
        or o.outstanding_prev_change_date <> n.outstanding_prev_change_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_cl(
            amt_type -- 金额类型
        ,client_no -- 客户编号
        ,internal_key -- 账户内部键值
        ,reference -- 交易参考号
        ,user_id -- 交易柜员编号
        ,company -- 法人
        ,fully_settled_flag -- 单据全额回收标志
        ,invoice_gen_mode -- 单据生成方式
        ,invoice_tran_no -- 通知单号
        ,narrative -- 摘要
        ,sched_seq_no -- 还款计划序号
        ,stage_no -- 期次
        ,tax_type -- 税种
        ,due_date -- 单据到期日
        ,end_date -- 结束日期
        ,final_settle_date -- 最后结算日期
        ,grace_date -- 宽限日
        ,last_change_date -- 最后修改日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,billed_amt -- 出单金额
        ,int_rate -- 出单利率
        ,outstanding -- 单据余额
        ,outstanding_prev -- 上日单据未还金额
        ,paid_amt -- 已还金额
        ,pri_outstanding -- 贷款还款本金金额
        ,sched_amt -- 还款计划金额
        ,tax_amt -- 税金
        ,tax_rate -- 税率
        ,wrn_amt -- 贷款核销本金
        ,outstanding_prev_change_date -- 单据上日余额更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_op(
            amt_type -- 金额类型
        ,client_no -- 客户编号
        ,internal_key -- 账户内部键值
        ,reference -- 交易参考号
        ,user_id -- 交易柜员编号
        ,company -- 法人
        ,fully_settled_flag -- 单据全额回收标志
        ,invoice_gen_mode -- 单据生成方式
        ,invoice_tran_no -- 通知单号
        ,narrative -- 摘要
        ,sched_seq_no -- 还款计划序号
        ,stage_no -- 期次
        ,tax_type -- 税种
        ,due_date -- 单据到期日
        ,end_date -- 结束日期
        ,final_settle_date -- 最后结算日期
        ,grace_date -- 宽限日
        ,last_change_date -- 最后修改日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,billed_amt -- 出单金额
        ,int_rate -- 出单利率
        ,outstanding -- 单据余额
        ,outstanding_prev -- 上日单据未还金额
        ,paid_amt -- 已还金额
        ,pri_outstanding -- 贷款还款本金金额
        ,sched_amt -- 还款计划金额
        ,tax_amt -- 税金
        ,tax_rate -- 税率
        ,wrn_amt -- 贷款核销本金
        ,outstanding_prev_change_date -- 单据上日余额更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amt_type -- 金额类型
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.fully_settled_flag -- 单据全额回收标志
    ,o.invoice_gen_mode -- 单据生成方式
    ,o.invoice_tran_no -- 通知单号
    ,o.narrative -- 摘要
    ,o.sched_seq_no -- 还款计划序号
    ,o.stage_no -- 期次
    ,o.tax_type -- 税种
    ,o.due_date -- 单据到期日
    ,o.end_date -- 结束日期
    ,o.final_settle_date -- 最后结算日期
    ,o.grace_date -- 宽限日
    ,o.last_change_date -- 最后修改日期
    ,o.start_date -- 开始日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.billed_amt -- 出单金额
    ,o.int_rate -- 出单利率
    ,o.outstanding -- 单据余额
    ,o.outstanding_prev -- 上日单据未还金额
    ,o.paid_amt -- 已还金额
    ,o.pri_outstanding -- 贷款还款本金金额
    ,o.sched_amt -- 还款计划金额
    ,o.tax_amt -- 税金
    ,o.tax_rate -- 税率
    ,o.wrn_amt -- 贷款核销本金
    ,o.outstanding_prev_change_date -- 单据上日余额更新日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_bk o
    left join ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_op n
        on
            o.sched_seq_no = n.sched_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_acct_schedule_detail_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_cl;
alter table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_acct_schedule_detail_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_op purge;
drop table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_acct_schedule_detail_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_acct_schedule_detail_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
