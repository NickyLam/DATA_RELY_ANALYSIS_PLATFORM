/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_schedule
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
/*
whenever sqlerror continue none ;
create table ${iol_schema}.mpcs_a0ntm_schedule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ntm_schedule where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');
*/

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_schedule_op purge;
drop table ${iol_schema}.mpcs_a0ntm_schedule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_schedule_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0ntm_schedule where 0=1;

create table ${iol_schema}.mpcs_a0ntm_schedule_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0ntm_schedule where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mpcs_a0ntm_schedule_op(
        schedule_id -- 分配表ID
        ,loan_id -- 贷款计划ID
        ,org -- 机构号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,logical_card_no -- 逻辑卡号
        ,card_no -- 卡号
        ,loan_init_prin -- 贷款总本金
        ,loan_init_term -- 贷款总期数
        ,curr_term -- 当前期数
        ,loan_term_prin -- 应还本金
        ,loan_term_fee1 -- 应还费用
        ,loan_term_interest -- 应还利息
        ,loan_pmt_due_date -- 到款到期还款日期
        ,loan_grace_date -- 宽限日
        ,last_modified_datetime -- 修改时间
        ,start_date -- 起息日
        ,schedule_action -- 还款计划操作动作
        ,prin_paid -- 已偿还本金
        ,int_paid -- 已偿还利息
        ,penalty_paid -- 已偿还罚息
        ,compound_paid -- 已偿还复利
        ,fee_paid -- 已偿还费用
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,isztdata -- 归属数据(1 中台;2 信贷)
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.schedule_id -- 分配表ID
    ,n.loan_id -- 贷款计划ID
    ,n.org -- 机构号
    ,n.acct_no -- 账户编号
    ,n.acct_type -- 账户类型
    ,n.logical_card_no -- 逻辑卡号
    ,n.card_no -- 卡号
    ,n.loan_init_prin -- 贷款总本金
    ,n.loan_init_term -- 贷款总期数
    ,n.curr_term -- 当前期数
    ,n.loan_term_prin -- 应还本金
    ,n.loan_term_fee1 -- 应还费用
    ,n.loan_term_interest -- 应还利息
    ,n.loan_pmt_due_date -- 到款到期还款日期
    ,n.loan_grace_date -- 宽限日
    ,n.last_modified_datetime -- 修改时间
    ,n.start_date -- 起息日
    ,n.schedule_action -- 还款计划操作动作
    ,n.prin_paid -- 已偿还本金
    ,n.int_paid -- 已偿还利息
    ,n.penalty_paid -- 已偿还罚息
    ,n.compound_paid -- 已偿还复利
    ,n.fee_paid -- 已偿还费用
    ,n.batchfilename -- 批量文件名
    ,n.seqno -- 序列号
    ,n.isztdata -- 归属数据(1 中台;2 信贷)
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0ntm_schedule where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.mpcs_a0ntm_schedule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.schedule_id = n.schedule_id
where (
        o.schedule_id is null
    )
    or (
        o.loan_id <> n.loan_id
        or o.org <> n.org
        or o.acct_no <> n.acct_no
        or o.acct_type <> n.acct_type
        or o.logical_card_no <> n.logical_card_no
        or o.card_no <> n.card_no
        or o.loan_init_prin <> n.loan_init_prin
        or o.loan_init_term <> n.loan_init_term
        or o.curr_term <> n.curr_term
        or o.loan_term_prin <> n.loan_term_prin
        or o.loan_term_fee1 <> n.loan_term_fee1
        or o.loan_term_interest <> n.loan_term_interest
        or o.loan_pmt_due_date <> n.loan_pmt_due_date
        or o.loan_grace_date <> n.loan_grace_date
        or o.last_modified_datetime <> n.last_modified_datetime
        or o.start_date <> n.start_date
        or o.schedule_action <> n.schedule_action
        or o.prin_paid <> n.prin_paid
        or o.int_paid <> n.int_paid
        or o.penalty_paid <> n.penalty_paid
        or o.compound_paid <> n.compound_paid
        or o.fee_paid <> n.fee_paid
        or o.batchfilename <> n.batchfilename
        or o.seqno <> n.seqno
        or o.isztdata <> n.isztdata
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_schedule_cl(
            schedule_id -- 分配表ID
        ,loan_id -- 贷款计划ID
        ,org -- 机构号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,logical_card_no -- 逻辑卡号
        ,card_no -- 卡号
        ,loan_init_prin -- 贷款总本金
        ,loan_init_term -- 贷款总期数
        ,curr_term -- 当前期数
        ,loan_term_prin -- 应还本金
        ,loan_term_fee1 -- 应还费用
        ,loan_term_interest -- 应还利息
        ,loan_pmt_due_date -- 到款到期还款日期
        ,loan_grace_date -- 宽限日
        ,last_modified_datetime -- 修改时间
        ,start_date -- 起息日
        ,schedule_action -- 还款计划操作动作
        ,prin_paid -- 已偿还本金
        ,int_paid -- 已偿还利息
        ,penalty_paid -- 已偿还罚息
        ,compound_paid -- 已偿还复利
        ,fee_paid -- 已偿还费用
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,isztdata -- 归属数据(1 中台;2 信贷)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_schedule_op(
            schedule_id -- 分配表ID
        ,loan_id -- 贷款计划ID
        ,org -- 机构号
        ,acct_no -- 账户编号
        ,acct_type -- 账户类型
        ,logical_card_no -- 逻辑卡号
        ,card_no -- 卡号
        ,loan_init_prin -- 贷款总本金
        ,loan_init_term -- 贷款总期数
        ,curr_term -- 当前期数
        ,loan_term_prin -- 应还本金
        ,loan_term_fee1 -- 应还费用
        ,loan_term_interest -- 应还利息
        ,loan_pmt_due_date -- 到款到期还款日期
        ,loan_grace_date -- 宽限日
        ,last_modified_datetime -- 修改时间
        ,start_date -- 起息日
        ,schedule_action -- 还款计划操作动作
        ,prin_paid -- 已偿还本金
        ,int_paid -- 已偿还利息
        ,penalty_paid -- 已偿还罚息
        ,compound_paid -- 已偿还复利
        ,fee_paid -- 已偿还费用
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,isztdata -- 归属数据(1 中台;2 信贷)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.schedule_id -- 分配表ID
    ,o.loan_id -- 贷款计划ID
    ,o.org -- 机构号
    ,o.acct_no -- 账户编号
    ,o.acct_type -- 账户类型
    ,o.logical_card_no -- 逻辑卡号
    ,o.card_no -- 卡号
    ,o.loan_init_prin -- 贷款总本金
    ,o.loan_init_term -- 贷款总期数
    ,o.curr_term -- 当前期数
    ,o.loan_term_prin -- 应还本金
    ,o.loan_term_fee1 -- 应还费用
    ,o.loan_term_interest -- 应还利息
    ,o.loan_pmt_due_date -- 到款到期还款日期
    ,o.loan_grace_date -- 宽限日
    ,o.last_modified_datetime -- 修改时间
    ,o.start_date -- 起息日
    ,o.schedule_action -- 还款计划操作动作
    ,o.prin_paid -- 已偿还本金
    ,o.int_paid -- 已偿还利息
    ,o.penalty_paid -- 已偿还罚息
    ,o.compound_paid -- 已偿还复利
    ,o.fee_paid -- 已偿还费用
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
    ,o.isztdata -- 归属数据(1 中台;2 信贷)
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
from (select * from ${iol_schema}.mpcs_a0ntm_schedule where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    left join ${iol_schema}.mpcs_a0ntm_schedule_op n
        on
            o.schedule_id = n.schedule_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0ntm_schedule;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0ntm_schedule') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0ntm_schedule drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0ntm_schedule add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0ntm_schedule exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0ntm_schedule_cl;
alter table ${iol_schema}.mpcs_a0ntm_schedule exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ntm_schedule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_schedule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_schedule_op purge;
drop table ${iol_schema}.mpcs_a0ntm_schedule_cl purge;
/*
whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ntm_schedule_bk purge;
*/
-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_schedule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
