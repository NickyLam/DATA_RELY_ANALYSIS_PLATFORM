/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_accept_unused_restitution
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
create table ${iol_schema}.bdms_bms_accept_unused_restitution_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_accept_unused_restitution
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_accept_unused_restitution_op purge;
drop table ${iol_schema}.bdms_bms_accept_unused_restitution_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_accept_unused_restitution_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_accept_unused_restitution where 0=1;

create table ${iol_schema}.bdms_bms_accept_unused_restitution_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_accept_unused_restitution where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_accept_unused_restitution_cl(
            id -- ID
            ,accept_id -- 承兑明细ID
            ,draft_id -- 清单ID
            ,branch_no -- 交易机构编号
            ,withdraw_reason -- 退回原因
            ,withdraw_date -- 退回日期
            ,operator_no -- 操作员
            ,status -- 操作状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,account_status -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,txn_date -- 申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_accept_unused_restitution_op(
            id -- ID
            ,accept_id -- 承兑明细ID
            ,draft_id -- 清单ID
            ,branch_no -- 交易机构编号
            ,withdraw_reason -- 退回原因
            ,withdraw_date -- 退回日期
            ,operator_no -- 操作员
            ,status -- 操作状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,account_status -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,txn_date -- 申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.accept_id, o.accept_id) as accept_id -- 承兑明细ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 清单ID
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 交易机构编号
    ,nvl(n.withdraw_reason, o.withdraw_reason) as withdraw_reason -- 退回原因
    ,nvl(n.withdraw_date, o.withdraw_date) as withdraw_date -- 退回日期
    ,nvl(n.operator_no, o.operator_no) as operator_no -- 操作员
    ,nvl(n.status, o.status) as status -- 操作状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后操作员编号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后操作日期
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 申请日期
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_accept_unused_restitution_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_accept_unused_restitution where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.accept_id <> n.accept_id
        or o.draft_id <> n.draft_id
        or o.branch_no <> n.branch_no
        or o.withdraw_reason <> n.withdraw_reason
        or o.withdraw_date <> n.withdraw_date
        or o.operator_no <> n.operator_no
        or o.status <> n.status
        or o.account_status <> n.account_status
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.txn_date <> n.txn_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_accept_unused_restitution_cl(
            id -- ID
            ,accept_id -- 承兑明细ID
            ,draft_id -- 清单ID
            ,branch_no -- 交易机构编号
            ,withdraw_reason -- 退回原因
            ,withdraw_date -- 退回日期
            ,operator_no -- 操作员
            ,status -- 操作状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,account_status -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,txn_date -- 申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_accept_unused_restitution_op(
            id -- ID
            ,accept_id -- 承兑明细ID
            ,draft_id -- 清单ID
            ,branch_no -- 交易机构编号
            ,withdraw_reason -- 退回原因
            ,withdraw_date -- 退回日期
            ,operator_no -- 操作员
            ,status -- 操作状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,account_status -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,txn_date -- 申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.accept_id -- 承兑明细ID
    ,o.draft_id -- 清单ID
    ,o.branch_no -- 交易机构编号
    ,o.withdraw_reason -- 退回原因
    ,o.withdraw_date -- 退回日期
    ,o.operator_no -- 操作员
    ,o.status -- 操作状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,o.account_status -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.last_operator_no -- 最后操作员编号
    ,o.last_txn_date -- 最后操作日期
    ,o.txn_date -- 申请日期
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
from ${iol_schema}.bdms_bms_accept_unused_restitution_bk o
    left join ${iol_schema}.bdms_bms_accept_unused_restitution_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_accept_unused_restitution_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_accept_unused_restitution;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_accept_unused_restitution') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_accept_unused_restitution drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_accept_unused_restitution add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_accept_unused_restitution exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_accept_unused_restitution_cl;
alter table ${iol_schema}.bdms_bms_accept_unused_restitution exchange partition p_20991231 with table ${iol_schema}.bdms_bms_accept_unused_restitution_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_accept_unused_restitution to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_accept_unused_restitution_op purge;
drop table ${iol_schema}.bdms_bms_accept_unused_restitution_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_accept_unused_restitution_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_accept_unused_restitution',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
