/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_send_collection_batch
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
create table ${iol_schema}.bdps_send_collection_batch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_send_collection_batch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_send_collection_batch_op purge;
drop table ${iol_schema}.bdps_send_collection_batch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_send_collection_batch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_send_collection_batch where 0=1;

create table ${iol_schema}.bdps_send_collection_batch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_send_collection_batch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_send_collection_batch_cl(
            id -- 
            ,branch_id -- 
            ,src_type -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,collection_date -- 
            ,ubank_no -- 
            ,ems_no -- 
            ,status -- 
            ,sttlm_mk -- 
            ,account_status -- 
            ,audit_status -- 
            ,appno -- 
            ,operator_id -- 
            ,txn_date -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id_opt -- 
            ,ebank_apply -- 
            ,traceno -- 
            ,is_collztn -- 
            ,contract_type -- 
            ,ubank_address -- 
            ,ubank_name -- 
            ,out_storage_no -- 
            ,ems_from_name -- 
            ,ems_from_tele_no -- 
            ,ems_contents -- 
            ,bail_account_id -- 回款账户ID
            ,cust_id -- 客户ID
            ,recepit_bank_address -- 
            ,recepit_bank -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_send_collection_batch_op(
            id -- 
            ,branch_id -- 
            ,src_type -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,collection_date -- 
            ,ubank_no -- 
            ,ems_no -- 
            ,status -- 
            ,sttlm_mk -- 
            ,account_status -- 
            ,audit_status -- 
            ,appno -- 
            ,operator_id -- 
            ,txn_date -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id_opt -- 
            ,ebank_apply -- 
            ,traceno -- 
            ,is_collztn -- 
            ,contract_type -- 
            ,ubank_address -- 
            ,ubank_name -- 
            ,out_storage_no -- 
            ,ems_from_name -- 
            ,ems_from_tele_no -- 
            ,ems_contents -- 
            ,bail_account_id -- 回款账户ID
            ,cust_id -- 客户ID
            ,recepit_bank_address -- 
            ,recepit_bank -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 
    ,nvl(n.src_type, o.src_type) as src_type -- 
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 
    ,nvl(n.collection_date, o.collection_date) as collection_date -- 
    ,nvl(n.ubank_no, o.ubank_no) as ubank_no -- 
    ,nvl(n.ems_no, o.ems_no) as ems_no -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.sttlm_mk, o.sttlm_mk) as sttlm_mk -- 
    ,nvl(n.account_status, o.account_status) as account_status -- 
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 
    ,nvl(n.appno, o.appno) as appno -- 
    ,nvl(n.operator_id, o.operator_id) as operator_id -- 
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.branch_id_opt, o.branch_id_opt) as branch_id_opt -- 
    ,nvl(n.ebank_apply, o.ebank_apply) as ebank_apply -- 
    ,nvl(n.traceno, o.traceno) as traceno -- 
    ,nvl(n.is_collztn, o.is_collztn) as is_collztn -- 
    ,nvl(n.contract_type, o.contract_type) as contract_type -- 
    ,nvl(n.ubank_address, o.ubank_address) as ubank_address -- 
    ,nvl(n.ubank_name, o.ubank_name) as ubank_name -- 
    ,nvl(n.out_storage_no, o.out_storage_no) as out_storage_no -- 
    ,nvl(n.ems_from_name, o.ems_from_name) as ems_from_name -- 
    ,nvl(n.ems_from_tele_no, o.ems_from_tele_no) as ems_from_tele_no -- 
    ,nvl(n.ems_contents, o.ems_contents) as ems_contents -- 
    ,nvl(n.bail_account_id, o.bail_account_id) as bail_account_id -- 回款账户ID
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户ID
    ,nvl(n.recepit_bank_address, o.recepit_bank_address) as recepit_bank_address -- 
    ,nvl(n.recepit_bank, o.recepit_bank) as recepit_bank -- 
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 全局流水号
    ,nvl(n.transq, o.transq) as transq -- 业务流水号
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
from (select * from ${iol_schema}.bdps_send_collection_batch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_send_collection_batch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.branch_id <> n.branch_id
        or o.src_type <> n.src_type
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.collection_date <> n.collection_date
        or o.ubank_no <> n.ubank_no
        or o.ems_no <> n.ems_no
        or o.status <> n.status
        or o.sttlm_mk <> n.sttlm_mk
        or o.account_status <> n.account_status
        or o.audit_status <> n.audit_status
        or o.appno <> n.appno
        or o.operator_id <> n.operator_id
        or o.txn_date <> n.txn_date
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.branch_id_opt <> n.branch_id_opt
        or o.ebank_apply <> n.ebank_apply
        or o.traceno <> n.traceno
        or o.is_collztn <> n.is_collztn
        or o.contract_type <> n.contract_type
        or o.ubank_address <> n.ubank_address
        or o.ubank_name <> n.ubank_name
        or o.out_storage_no <> n.out_storage_no
        or o.ems_from_name <> n.ems_from_name
        or o.ems_from_tele_no <> n.ems_from_tele_no
        or o.ems_contents <> n.ems_contents
        or o.bail_account_id <> n.bail_account_id
        or o.cust_id <> n.cust_id
        or o.recepit_bank_address <> n.recepit_bank_address
        or o.recepit_bank <> n.recepit_bank
        or o.bsnssq <> n.bsnssq
        or o.transq <> n.transq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_send_collection_batch_cl(
            id -- 
            ,branch_id -- 
            ,src_type -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,collection_date -- 
            ,ubank_no -- 
            ,ems_no -- 
            ,status -- 
            ,sttlm_mk -- 
            ,account_status -- 
            ,audit_status -- 
            ,appno -- 
            ,operator_id -- 
            ,txn_date -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id_opt -- 
            ,ebank_apply -- 
            ,traceno -- 
            ,is_collztn -- 
            ,contract_type -- 
            ,ubank_address -- 
            ,ubank_name -- 
            ,out_storage_no -- 
            ,ems_from_name -- 
            ,ems_from_tele_no -- 
            ,ems_contents -- 
            ,bail_account_id -- 回款账户ID
            ,cust_id -- 客户ID
            ,recepit_bank_address -- 
            ,recepit_bank -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_send_collection_batch_op(
            id -- 
            ,branch_id -- 
            ,src_type -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,collection_date -- 
            ,ubank_no -- 
            ,ems_no -- 
            ,status -- 
            ,sttlm_mk -- 
            ,account_status -- 
            ,audit_status -- 
            ,appno -- 
            ,operator_id -- 
            ,txn_date -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id_opt -- 
            ,ebank_apply -- 
            ,traceno -- 
            ,is_collztn -- 
            ,contract_type -- 
            ,ubank_address -- 
            ,ubank_name -- 
            ,out_storage_no -- 
            ,ems_from_name -- 
            ,ems_from_tele_no -- 
            ,ems_contents -- 
            ,bail_account_id -- 回款账户ID
            ,cust_id -- 客户ID
            ,recepit_bank_address -- 
            ,recepit_bank -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.branch_id -- 
    ,o.src_type -- 
    ,o.draft_attr -- 
    ,o.draft_type -- 
    ,o.collection_date -- 
    ,o.ubank_no -- 
    ,o.ems_no -- 
    ,o.status -- 
    ,o.sttlm_mk -- 
    ,o.account_status -- 
    ,o.audit_status -- 
    ,o.appno -- 
    ,o.operator_id -- 
    ,o.txn_date -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.branch_id_opt -- 
    ,o.ebank_apply -- 
    ,o.traceno -- 
    ,o.is_collztn -- 
    ,o.contract_type -- 
    ,o.ubank_address -- 
    ,o.ubank_name -- 
    ,o.out_storage_no -- 
    ,o.ems_from_name -- 
    ,o.ems_from_tele_no -- 
    ,o.ems_contents -- 
    ,o.bail_account_id -- 回款账户ID
    ,o.cust_id -- 客户ID
    ,o.recepit_bank_address -- 
    ,o.recepit_bank -- 
    ,o.bsnssq -- 全局流水号
    ,o.transq -- 业务流水号
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
from ${iol_schema}.bdps_send_collection_batch_bk o
    left join ${iol_schema}.bdps_send_collection_batch_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_send_collection_batch_cl d
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
--truncate table ${iol_schema}.bdps_send_collection_batch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_send_collection_batch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_send_collection_batch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_send_collection_batch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_send_collection_batch exchange partition p_${batch_date} with table ${iol_schema}.bdps_send_collection_batch_cl;
alter table ${iol_schema}.bdps_send_collection_batch exchange partition p_20991231 with table ${iol_schema}.bdps_send_collection_batch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_send_collection_batch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_send_collection_batch_op purge;
drop table ${iol_schema}.bdps_send_collection_batch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_send_collection_batch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_send_collection_batch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
