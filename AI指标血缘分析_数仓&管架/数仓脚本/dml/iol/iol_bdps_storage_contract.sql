/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_storage_contract
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
create table ${iol_schema}.bdps_storage_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_storage_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_storage_contract_op purge;
drop table ${iol_schema}.bdps_storage_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_storage_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_storage_contract where 0=1;

create table ${iol_schema}.bdps_storage_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_storage_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_storage_contract_cl(
            id -- 
            ,storage_protocol_no -- 
            ,contract_type -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,branch_id -- 
            ,operator_id -- 
            ,app_cust_id -- 
            ,txn_date -- 
            ,bail_acct_no -- 
            ,contract_status -- 
            ,audit_status -- 
            ,logic_check_status -- 
            ,credit_check_status -- 
            ,manager_id -- 
            ,depart_id -- 
            ,appno -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id_opt -- 
            ,ebank_oper_no -- 
            ,ebank_oper_name -- 
            ,gbba_cust_oper_nm -- 
            ,gbba_cust_oper_idtyp -- 
            ,gbba_cust_oper_idnum -- 
            ,gbba_cust_oper_com -- 
            ,gbba_endorse_com -- 
            ,ref_txn_type -- 
            ,draft_src_type -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_storage_contract_op(
            id -- 
            ,storage_protocol_no -- 
            ,contract_type -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,branch_id -- 
            ,operator_id -- 
            ,app_cust_id -- 
            ,txn_date -- 
            ,bail_acct_no -- 
            ,contract_status -- 
            ,audit_status -- 
            ,logic_check_status -- 
            ,credit_check_status -- 
            ,manager_id -- 
            ,depart_id -- 
            ,appno -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id_opt -- 
            ,ebank_oper_no -- 
            ,ebank_oper_name -- 
            ,gbba_cust_oper_nm -- 
            ,gbba_cust_oper_idtyp -- 
            ,gbba_cust_oper_idnum -- 
            ,gbba_cust_oper_com -- 
            ,gbba_endorse_com -- 
            ,ref_txn_type -- 
            ,draft_src_type -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.storage_protocol_no, o.storage_protocol_no) as storage_protocol_no -- 
    ,nvl(n.contract_type, o.contract_type) as contract_type -- 
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 
    ,nvl(n.operator_id, o.operator_id) as operator_id -- 
    ,nvl(n.app_cust_id, o.app_cust_id) as app_cust_id -- 
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 
    ,nvl(n.bail_acct_no, o.bail_acct_no) as bail_acct_no -- 
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 
    ,nvl(n.logic_check_status, o.logic_check_status) as logic_check_status -- 
    ,nvl(n.credit_check_status, o.credit_check_status) as credit_check_status -- 
    ,nvl(n.manager_id, o.manager_id) as manager_id -- 
    ,nvl(n.depart_id, o.depart_id) as depart_id -- 
    ,nvl(n.appno, o.appno) as appno -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.branch_id_opt, o.branch_id_opt) as branch_id_opt -- 
    ,nvl(n.ebank_oper_no, o.ebank_oper_no) as ebank_oper_no -- 
    ,nvl(n.ebank_oper_name, o.ebank_oper_name) as ebank_oper_name -- 
    ,nvl(n.gbba_cust_oper_nm, o.gbba_cust_oper_nm) as gbba_cust_oper_nm -- 
    ,nvl(n.gbba_cust_oper_idtyp, o.gbba_cust_oper_idtyp) as gbba_cust_oper_idtyp -- 
    ,nvl(n.gbba_cust_oper_idnum, o.gbba_cust_oper_idnum) as gbba_cust_oper_idnum -- 
    ,nvl(n.gbba_cust_oper_com, o.gbba_cust_oper_com) as gbba_cust_oper_com -- 
    ,nvl(n.gbba_endorse_com, o.gbba_endorse_com) as gbba_endorse_com -- 
    ,nvl(n.ref_txn_type, o.ref_txn_type) as ref_txn_type -- 
    ,nvl(n.draft_src_type, o.draft_src_type) as draft_src_type -- 
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
from (select * from ${iol_schema}.bdps_storage_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_storage_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.storage_protocol_no <> n.storage_protocol_no
        or o.contract_type <> n.contract_type
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.branch_id <> n.branch_id
        or o.operator_id <> n.operator_id
        or o.app_cust_id <> n.app_cust_id
        or o.txn_date <> n.txn_date
        or o.bail_acct_no <> n.bail_acct_no
        or o.contract_status <> n.contract_status
        or o.audit_status <> n.audit_status
        or o.logic_check_status <> n.logic_check_status
        or o.credit_check_status <> n.credit_check_status
        or o.manager_id <> n.manager_id
        or o.depart_id <> n.depart_id
        or o.appno <> n.appno
        or o.misc <> n.misc
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.branch_id_opt <> n.branch_id_opt
        or o.ebank_oper_no <> n.ebank_oper_no
        or o.ebank_oper_name <> n.ebank_oper_name
        or o.gbba_cust_oper_nm <> n.gbba_cust_oper_nm
        or o.gbba_cust_oper_idtyp <> n.gbba_cust_oper_idtyp
        or o.gbba_cust_oper_idnum <> n.gbba_cust_oper_idnum
        or o.gbba_cust_oper_com <> n.gbba_cust_oper_com
        or o.gbba_endorse_com <> n.gbba_endorse_com
        or o.ref_txn_type <> n.ref_txn_type
        or o.draft_src_type <> n.draft_src_type
        or o.bsnssq <> n.bsnssq
        or o.transq <> n.transq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_storage_contract_cl(
            id -- 
            ,storage_protocol_no -- 
            ,contract_type -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,branch_id -- 
            ,operator_id -- 
            ,app_cust_id -- 
            ,txn_date -- 
            ,bail_acct_no -- 
            ,contract_status -- 
            ,audit_status -- 
            ,logic_check_status -- 
            ,credit_check_status -- 
            ,manager_id -- 
            ,depart_id -- 
            ,appno -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id_opt -- 
            ,ebank_oper_no -- 
            ,ebank_oper_name -- 
            ,gbba_cust_oper_nm -- 
            ,gbba_cust_oper_idtyp -- 
            ,gbba_cust_oper_idnum -- 
            ,gbba_cust_oper_com -- 
            ,gbba_endorse_com -- 
            ,ref_txn_type -- 
            ,draft_src_type -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_storage_contract_op(
            id -- 
            ,storage_protocol_no -- 
            ,contract_type -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,branch_id -- 
            ,operator_id -- 
            ,app_cust_id -- 
            ,txn_date -- 
            ,bail_acct_no -- 
            ,contract_status -- 
            ,audit_status -- 
            ,logic_check_status -- 
            ,credit_check_status -- 
            ,manager_id -- 
            ,depart_id -- 
            ,appno -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id_opt -- 
            ,ebank_oper_no -- 
            ,ebank_oper_name -- 
            ,gbba_cust_oper_nm -- 
            ,gbba_cust_oper_idtyp -- 
            ,gbba_cust_oper_idnum -- 
            ,gbba_cust_oper_com -- 
            ,gbba_endorse_com -- 
            ,ref_txn_type -- 
            ,draft_src_type -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.storage_protocol_no -- 
    ,o.contract_type -- 
    ,o.draft_attr -- 
    ,o.draft_type -- 
    ,o.branch_id -- 
    ,o.operator_id -- 
    ,o.app_cust_id -- 
    ,o.txn_date -- 
    ,o.bail_acct_no -- 
    ,o.contract_status -- 
    ,o.audit_status -- 
    ,o.logic_check_status -- 
    ,o.credit_check_status -- 
    ,o.manager_id -- 
    ,o.depart_id -- 
    ,o.appno -- 
    ,o.misc -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.branch_id_opt -- 
    ,o.ebank_oper_no -- 
    ,o.ebank_oper_name -- 
    ,o.gbba_cust_oper_nm -- 
    ,o.gbba_cust_oper_idtyp -- 
    ,o.gbba_cust_oper_idnum -- 
    ,o.gbba_cust_oper_com -- 
    ,o.gbba_endorse_com -- 
    ,o.ref_txn_type -- 
    ,o.draft_src_type -- 
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
from ${iol_schema}.bdps_storage_contract_bk o
    left join ${iol_schema}.bdps_storage_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_storage_contract_cl d
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
--truncate table ${iol_schema}.bdps_storage_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_storage_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_storage_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_storage_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_storage_contract exchange partition p_${batch_date} with table ${iol_schema}.bdps_storage_contract_cl;
alter table ${iol_schema}.bdps_storage_contract exchange partition p_20991231 with table ${iol_schema}.bdps_storage_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_storage_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_storage_contract_op purge;
drop table ${iol_schema}.bdps_storage_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_storage_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_storage_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
