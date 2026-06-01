/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_branch_amend_amt_transfer
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
create table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_branch_amend_amt_transfer
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_op purge;
drop table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_branch_amend_amt_transfer where 0=1;

create table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_branch_amend_amt_transfer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_cl(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,invoice_tran_no -- 通知单号
            ,stage_no -- 期次
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,old_branch -- 变更前机构
            ,original_int -- 原计提利息
            ,outstanding -- 单据余额
            ,over_amount -- 贷款剩余金额
            ,rec_outstanding -- 回收剩余单据金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_op(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,invoice_tran_no -- 通知单号
            ,stage_no -- 期次
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,old_branch -- 变更前机构
            ,original_int -- 原计提利息
            ,outstanding -- 单据余额
            ,over_amount -- 贷款剩余金额
            ,rec_outstanding -- 回收剩余单据金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.invoice_tran_no, o.invoice_tran_no) as invoice_tran_no -- 通知单号
    ,nvl(n.stage_no, o.stage_no) as stage_no -- 期次
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.old_branch, o.old_branch) as old_branch -- 变更前机构
    ,nvl(n.original_int, o.original_int) as original_int -- 原计提利息
    ,nvl(n.outstanding, o.outstanding) as outstanding -- 单据余额
    ,nvl(n.over_amount, o.over_amount) as over_amount -- 贷款剩余金额
    ,nvl(n.rec_outstanding, o.rec_outstanding) as rec_outstanding -- 回收剩余单据金额
    ,case when
            n.internal_key is null
            and n.invoice_tran_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.invoice_tran_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.invoice_tran_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_branch_amend_amt_transfer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.invoice_tran_no = n.invoice_tran_no
where (
        o.internal_key is null
        and o.invoice_tran_no is null
    )
    or (
        n.internal_key is null
        and n.invoice_tran_no is null
    )
    or (
        o.amt_type <> n.amt_type
        or o.client_no <> n.client_no
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.stage_no <> n.stage_no
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.old_branch <> n.old_branch
        or o.original_int <> n.original_int
        or o.outstanding <> n.outstanding
        or o.over_amount <> n.over_amount
        or o.rec_outstanding <> n.rec_outstanding
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_cl(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,invoice_tran_no -- 通知单号
            ,stage_no -- 期次
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,old_branch -- 变更前机构
            ,original_int -- 原计提利息
            ,outstanding -- 单据余额
            ,over_amount -- 贷款剩余金额
            ,rec_outstanding -- 回收剩余单据金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_op(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,invoice_tran_no -- 通知单号
            ,stage_no -- 期次
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,old_branch -- 变更前机构
            ,original_int -- 原计提利息
            ,outstanding -- 单据余额
            ,over_amount -- 贷款剩余金额
            ,rec_outstanding -- 回收剩余单据金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amt_type -- 金额类型
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.invoice_tran_no -- 通知单号
    ,o.stage_no -- 期次
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.old_branch -- 变更前机构
    ,o.original_int -- 原计提利息
    ,o.outstanding -- 单据余额
    ,o.over_amount -- 贷款剩余金额
    ,o.rec_outstanding -- 回收剩余单据金额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_bk o
    left join ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_op n
        on
            o.internal_key = n.internal_key
            and o.invoice_tran_no = n.invoice_tran_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_cl d
        on
            o.internal_key = d.internal_key
            and o.invoice_tran_no = d.invoice_tran_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_branch_amend_amt_transfer') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_cl;
alter table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_branch_amend_amt_transfer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_op purge;
drop table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_branch_amend_amt_transfer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_branch_amend_amt_transfer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
