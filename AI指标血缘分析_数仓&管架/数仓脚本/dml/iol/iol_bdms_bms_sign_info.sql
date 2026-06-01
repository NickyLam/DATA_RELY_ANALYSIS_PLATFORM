/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_sign_info
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
create table ${iol_schema}.bdms_bms_sign_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_sign_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_sign_info_op purge;
drop table ${iol_schema}.bdms_bms_sign_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_sign_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_sign_info where 0=1;

create table ${iol_schema}.bdms_bms_sign_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_sign_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_sign_info_cl(
            id -- ID
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,sign_type -- 签约类型
            ,sign_account -- 签约账号
            ,sign_branch -- 签约机构
            ,sign_date -- 签约日期
            ,status -- 有效标识： 0 无效 1 有效
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,top_branch_no -- 总行机构号
            ,one_key_flag -- 是否开通一键多功能： 0 否 1 是
            ,auto_accept_sign_flag -- 是否开通自动承兑签收
            ,cancel_date -- 解约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_sign_info_op(
            id -- ID
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,sign_type -- 签约类型
            ,sign_account -- 签约账号
            ,sign_branch -- 签约机构
            ,sign_date -- 签约日期
            ,status -- 有效标识： 0 无效 1 有效
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,top_branch_no -- 总行机构号
            ,one_key_flag -- 是否开通一键多功能： 0 否 1 是
            ,auto_accept_sign_flag -- 是否开通自动承兑签收
            ,cancel_date -- 解约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.sign_type, o.sign_type) as sign_type -- 签约类型
    ,nvl(n.sign_account, o.sign_account) as sign_account -- 签约账号
    ,nvl(n.sign_branch, o.sign_branch) as sign_branch -- 签约机构
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签约日期
    ,nvl(n.status, o.status) as status -- 有效标识： 0 无效 1 有效
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后操作员编号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后操作日期
    ,nvl(n.dualcontrol_lockstatus, o.dualcontrol_lockstatus) as dualcontrol_lockstatus -- 双岗复核锁标记
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.one_key_flag, o.one_key_flag) as one_key_flag -- 是否开通一键多功能： 0 否 1 是
    ,nvl(n.auto_accept_sign_flag, o.auto_accept_sign_flag) as auto_accept_sign_flag -- 是否开通自动承兑签收
    ,nvl(n.cancel_date, o.cancel_date) as cancel_date -- 解约日期
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
from (select * from ${iol_schema}.bdms_bms_sign_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_sign_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.sign_type <> n.sign_type
        or o.sign_account <> n.sign_account
        or o.sign_branch <> n.sign_branch
        or o.sign_date <> n.sign_date
        or o.status <> n.status
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.dualcontrol_lockstatus <> n.dualcontrol_lockstatus
        or o.top_branch_no <> n.top_branch_no
        or o.one_key_flag <> n.one_key_flag
        or o.auto_accept_sign_flag <> n.auto_accept_sign_flag
        or o.cancel_date <> n.cancel_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_sign_info_cl(
            id -- ID
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,sign_type -- 签约类型
            ,sign_account -- 签约账号
            ,sign_branch -- 签约机构
            ,sign_date -- 签约日期
            ,status -- 有效标识： 0 无效 1 有效
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,top_branch_no -- 总行机构号
            ,one_key_flag -- 是否开通一键多功能： 0 否 1 是
            ,auto_accept_sign_flag -- 是否开通自动承兑签收
            ,cancel_date -- 解约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_sign_info_op(
            id -- ID
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,sign_type -- 签约类型
            ,sign_account -- 签约账号
            ,sign_branch -- 签约机构
            ,sign_date -- 签约日期
            ,status -- 有效标识： 0 无效 1 有效
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,top_branch_no -- 总行机构号
            ,one_key_flag -- 是否开通一键多功能： 0 否 1 是
            ,auto_accept_sign_flag -- 是否开通自动承兑签收
            ,cancel_date -- 解约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.cust_no -- 客户号
    ,o.cust_name -- 客户名称
    ,o.sign_type -- 签约类型
    ,o.sign_account -- 签约账号
    ,o.sign_branch -- 签约机构
    ,o.sign_date -- 签约日期
    ,o.status -- 有效标识： 0 无效 1 有效
    ,o.last_operator_no -- 最后操作员编号
    ,o.last_txn_date -- 最后操作日期
    ,o.dualcontrol_lockstatus -- 双岗复核锁标记
    ,o.top_branch_no -- 总行机构号
    ,o.one_key_flag -- 是否开通一键多功能： 0 否 1 是
    ,o.auto_accept_sign_flag -- 是否开通自动承兑签收
    ,o.cancel_date -- 解约日期
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
from ${iol_schema}.bdms_bms_sign_info_bk o
    left join ${iol_schema}.bdms_bms_sign_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_sign_info_cl d
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
--truncate table ${iol_schema}.bdms_bms_sign_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_sign_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_sign_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_sign_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_sign_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_sign_info_cl;
alter table ${iol_schema}.bdms_bms_sign_info exchange partition p_20991231 with table ${iol_schema}.bdms_bms_sign_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_sign_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_sign_info_op purge;
drop table ${iol_schema}.bdms_bms_sign_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_sign_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_sign_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
