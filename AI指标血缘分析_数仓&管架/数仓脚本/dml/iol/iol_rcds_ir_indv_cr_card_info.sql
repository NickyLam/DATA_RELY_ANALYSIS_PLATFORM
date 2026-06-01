/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_indv_cr_card_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rcds_ir_indv_cr_card_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_indv_cr_card_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_indv_cr_card_info_op purge;
drop table ${iol_schema}.rcds_ir_indv_cr_card_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_indv_cr_card_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_indv_cr_card_info where 0=1;

create table ${iol_schema}.rcds_ir_indv_cr_card_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_indv_cr_card_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_indv_cr_card_info_cl(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,mon_payable_amt -- 最低应还款总额
            ,cr_card_desc -- 贷记卡描述
            ,acct_status_cd -- 贷记卡账户状态
            ,mon_repay_amt -- 本月实还总金额
            ,used_lmt -- 已用额度
            ,shr_crdt_lmt -- 授信共享额度
            ,cr_card_issue_dt -- 开户日期
            ,crdt_lmt -- 授信额度
            ,last_two_year_repay_rec -- 24期还款状态
            ,indvcr_card_info_seq_num -- 个人贷记卡信息序号
            ,last_two_year_repay_rec_align -- 
            ,end_date -- 
            ,curr_ovdue_amt -- 当前逾期金额
            ,last_6_mon_avg_usage_lmt -- 最近6个月平均使用额度
            ,last_five_year_repay_rec -- 60期还款状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_indv_cr_card_info_op(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,mon_payable_amt -- 最低应还款总额
            ,cr_card_desc -- 贷记卡描述
            ,acct_status_cd -- 贷记卡账户状态
            ,mon_repay_amt -- 本月实还总金额
            ,used_lmt -- 已用额度
            ,shr_crdt_lmt -- 授信共享额度
            ,cr_card_issue_dt -- 开户日期
            ,crdt_lmt -- 授信额度
            ,last_two_year_repay_rec -- 24期还款状态
            ,indvcr_card_info_seq_num -- 个人贷记卡信息序号
            ,last_two_year_repay_rec_align -- 
            ,end_date -- 
            ,curr_ovdue_amt -- 当前逾期金额
            ,last_6_mon_avg_usage_lmt -- 最近6个月平均使用额度
            ,last_five_year_repay_rec -- 60期还款状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_id, o.key_id) as key_id -- 主键
    ,nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.mon_payable_amt, o.mon_payable_amt) as mon_payable_amt -- 最低应还款总额
    ,nvl(n.cr_card_desc, o.cr_card_desc) as cr_card_desc -- 贷记卡描述
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 贷记卡账户状态
    ,nvl(n.mon_repay_amt, o.mon_repay_amt) as mon_repay_amt -- 本月实还总金额
    ,nvl(n.used_lmt, o.used_lmt) as used_lmt -- 已用额度
    ,nvl(n.shr_crdt_lmt, o.shr_crdt_lmt) as shr_crdt_lmt -- 授信共享额度
    ,nvl(n.cr_card_issue_dt, o.cr_card_issue_dt) as cr_card_issue_dt -- 开户日期
    ,nvl(n.crdt_lmt, o.crdt_lmt) as crdt_lmt -- 授信额度
    ,nvl(n.last_two_year_repay_rec, o.last_two_year_repay_rec) as last_two_year_repay_rec -- 24期还款状态
    ,nvl(n.indvcr_card_info_seq_num, o.indvcr_card_info_seq_num) as indvcr_card_info_seq_num -- 个人贷记卡信息序号
    ,nvl(n.last_two_year_repay_rec_align, o.last_two_year_repay_rec_align) as last_two_year_repay_rec_align -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,nvl(n.curr_ovdue_amt, o.curr_ovdue_amt) as curr_ovdue_amt -- 当前逾期金额
    ,nvl(n.last_6_mon_avg_usage_lmt, o.last_6_mon_avg_usage_lmt) as last_6_mon_avg_usage_lmt -- 最近6个月平均使用额度
    ,nvl(n.last_five_year_repay_rec, o.last_five_year_repay_rec) as last_five_year_repay_rec -- 60期还款状态
    ,case when
            n.key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_indv_cr_card_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_indv_cr_card_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_id = n.key_id
where (
        o.key_id is null
    )
    or (
        n.key_id is null
    )
    or (
        o.grade_key_id <> n.grade_key_id
        or o.data_time <> n.data_time
        or o.mon_payable_amt <> n.mon_payable_amt
        or o.cr_card_desc <> n.cr_card_desc
        or o.acct_status_cd <> n.acct_status_cd
        or o.mon_repay_amt <> n.mon_repay_amt
        or o.used_lmt <> n.used_lmt
        or o.shr_crdt_lmt <> n.shr_crdt_lmt
        or o.cr_card_issue_dt <> n.cr_card_issue_dt
        or o.crdt_lmt <> n.crdt_lmt
        or o.last_two_year_repay_rec <> n.last_two_year_repay_rec
        or o.indvcr_card_info_seq_num <> n.indvcr_card_info_seq_num
        or o.last_two_year_repay_rec_align <> n.last_two_year_repay_rec_align
        or o.end_date <> n.end_date
        or o.curr_ovdue_amt <> n.curr_ovdue_amt
        or o.last_6_mon_avg_usage_lmt <> n.last_6_mon_avg_usage_lmt
        or o.last_five_year_repay_rec <> n.last_five_year_repay_rec
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_indv_cr_card_info_cl(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,mon_payable_amt -- 最低应还款总额
            ,cr_card_desc -- 贷记卡描述
            ,acct_status_cd -- 贷记卡账户状态
            ,mon_repay_amt -- 本月实还总金额
            ,used_lmt -- 已用额度
            ,shr_crdt_lmt -- 授信共享额度
            ,cr_card_issue_dt -- 开户日期
            ,crdt_lmt -- 授信额度
            ,last_two_year_repay_rec -- 24期还款状态
            ,indvcr_card_info_seq_num -- 个人贷记卡信息序号
            ,last_two_year_repay_rec_align -- 
            ,end_date -- 
            ,curr_ovdue_amt -- 当前逾期金额
            ,last_6_mon_avg_usage_lmt -- 最近6个月平均使用额度
            ,last_five_year_repay_rec -- 60期还款状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_indv_cr_card_info_op(
            key_id -- 主键
            ,grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,mon_payable_amt -- 最低应还款总额
            ,cr_card_desc -- 贷记卡描述
            ,acct_status_cd -- 贷记卡账户状态
            ,mon_repay_amt -- 本月实还总金额
            ,used_lmt -- 已用额度
            ,shr_crdt_lmt -- 授信共享额度
            ,cr_card_issue_dt -- 开户日期
            ,crdt_lmt -- 授信额度
            ,last_two_year_repay_rec -- 24期还款状态
            ,indvcr_card_info_seq_num -- 个人贷记卡信息序号
            ,last_two_year_repay_rec_align -- 
            ,end_date -- 
            ,curr_ovdue_amt -- 当前逾期金额
            ,last_6_mon_avg_usage_lmt -- 最近6个月平均使用额度
            ,last_five_year_repay_rec -- 60期还款状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_id -- 主键
    ,o.grade_key_id -- 申请评分流水号
    ,o.data_time -- 数据记录时间
    ,o.mon_payable_amt -- 最低应还款总额
    ,o.cr_card_desc -- 贷记卡描述
    ,o.acct_status_cd -- 贷记卡账户状态
    ,o.mon_repay_amt -- 本月实还总金额
    ,o.used_lmt -- 已用额度
    ,o.shr_crdt_lmt -- 授信共享额度
    ,o.cr_card_issue_dt -- 开户日期
    ,o.crdt_lmt -- 授信额度
    ,o.last_two_year_repay_rec -- 24期还款状态
    ,o.indvcr_card_info_seq_num -- 个人贷记卡信息序号
    ,o.last_two_year_repay_rec_align -- 
    ,o.end_date -- 
    ,o.curr_ovdue_amt -- 当前逾期金额
    ,o.last_6_mon_avg_usage_lmt -- 最近6个月平均使用额度
    ,o.last_five_year_repay_rec -- 60期还款状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_indv_cr_card_info_bk o
    left join ${iol_schema}.rcds_ir_indv_cr_card_info_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_indv_cr_card_info_cl d
        on
            o.key_id = d.key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_indv_cr_card_info;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_indv_cr_card_info exchange partition p_19000101 with table ${iol_schema}.rcds_ir_indv_cr_card_info_cl;
alter table ${iol_schema}.rcds_ir_indv_cr_card_info exchange partition p_20991231 with table ${iol_schema}.rcds_ir_indv_cr_card_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_indv_cr_card_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_indv_cr_card_info_op purge;
drop table ${iol_schema}.rcds_ir_indv_cr_card_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_indv_cr_card_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_indv_cr_card_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
