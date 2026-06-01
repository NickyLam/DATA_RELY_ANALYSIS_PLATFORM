/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_pay_account_info
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
create table ${iol_schema}.bdps_pay_account_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_pay_account_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_pay_account_info_op purge;
drop table ${iol_schema}.bdps_pay_account_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_pay_account_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_pay_account_info where 0=1;

create table ${iol_schema}.bdps_pay_account_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_pay_account_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_pay_account_info_cl(
            id -- 
            ,account_no -- 
            ,txn_type -- 
            ,branch_no -- 
            ,txn_date -- 
            ,seqno -- 
            ,total_amt -- 
            ,send_bank_no -- 
            ,pay_account_no -- 
            ,pay_name -- 
            ,pay_addr -- 
            ,rcv_bank_no -- 
            ,rcv_branch_no -- 
            ,rcv_account_no -- 
            ,rcv_name -- 
            ,rcv_addr -- 
            ,remark -- 
            ,account_flag -- 
            ,account_msg -- 
            ,status -- 
            ,last_upd_time -- 
            ,misc -- 
            ,draft_number -- 
            ,draft_id -- 
            ,virtual_account_no -- 
            ,tran_no -- 
            ,op_no -- 
            ,return_date -- 
            ,trans_seq -- 
            ,snd_brn -- 
            ,entry_no -- 
            ,acctou -- 
            ,audit_status -- 
            ,vostro_account_type -- 
            ,account_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_pay_account_info_op(
            id -- 
            ,account_no -- 
            ,txn_type -- 
            ,branch_no -- 
            ,txn_date -- 
            ,seqno -- 
            ,total_amt -- 
            ,send_bank_no -- 
            ,pay_account_no -- 
            ,pay_name -- 
            ,pay_addr -- 
            ,rcv_bank_no -- 
            ,rcv_branch_no -- 
            ,rcv_account_no -- 
            ,rcv_name -- 
            ,rcv_addr -- 
            ,remark -- 
            ,account_flag -- 
            ,account_msg -- 
            ,status -- 
            ,last_upd_time -- 
            ,misc -- 
            ,draft_number -- 
            ,draft_id -- 
            ,virtual_account_no -- 
            ,tran_no -- 
            ,op_no -- 
            ,return_date -- 
            ,trans_seq -- 
            ,snd_brn -- 
            ,entry_no -- 
            ,acctou -- 
            ,audit_status -- 
            ,vostro_account_type -- 
            ,account_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.account_no, o.account_no) as account_no -- 
    ,nvl(n.txn_type, o.txn_type) as txn_type -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 
    ,nvl(n.seqno, o.seqno) as seqno -- 
    ,nvl(n.total_amt, o.total_amt) as total_amt -- 
    ,nvl(n.send_bank_no, o.send_bank_no) as send_bank_no -- 
    ,nvl(n.pay_account_no, o.pay_account_no) as pay_account_no -- 
    ,nvl(n.pay_name, o.pay_name) as pay_name -- 
    ,nvl(n.pay_addr, o.pay_addr) as pay_addr -- 
    ,nvl(n.rcv_bank_no, o.rcv_bank_no) as rcv_bank_no -- 
    ,nvl(n.rcv_branch_no, o.rcv_branch_no) as rcv_branch_no -- 
    ,nvl(n.rcv_account_no, o.rcv_account_no) as rcv_account_no -- 
    ,nvl(n.rcv_name, o.rcv_name) as rcv_name -- 
    ,nvl(n.rcv_addr, o.rcv_addr) as rcv_addr -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 
    ,nvl(n.account_msg, o.account_msg) as account_msg -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 
    ,nvl(n.virtual_account_no, o.virtual_account_no) as virtual_account_no -- 
    ,nvl(n.tran_no, o.tran_no) as tran_no -- 
    ,nvl(n.op_no, o.op_no) as op_no -- 
    ,nvl(n.return_date, o.return_date) as return_date -- 
    ,nvl(n.trans_seq, o.trans_seq) as trans_seq -- 
    ,nvl(n.snd_brn, o.snd_brn) as snd_brn -- 
    ,nvl(n.entry_no, o.entry_no) as entry_no -- 
    ,nvl(n.acctou, o.acctou) as acctou -- 
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 
    ,nvl(n.vostro_account_type, o.vostro_account_type) as vostro_account_type -- 
    ,nvl(n.account_status, o.account_status) as account_status -- 
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
from (select * from ${iol_schema}.bdps_pay_account_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_pay_account_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.account_no <> n.account_no
        or o.txn_type <> n.txn_type
        or o.branch_no <> n.branch_no
        or o.txn_date <> n.txn_date
        or o.seqno <> n.seqno
        or o.total_amt <> n.total_amt
        or o.send_bank_no <> n.send_bank_no
        or o.pay_account_no <> n.pay_account_no
        or o.pay_name <> n.pay_name
        or o.pay_addr <> n.pay_addr
        or o.rcv_bank_no <> n.rcv_bank_no
        or o.rcv_branch_no <> n.rcv_branch_no
        or o.rcv_account_no <> n.rcv_account_no
        or o.rcv_name <> n.rcv_name
        or o.rcv_addr <> n.rcv_addr
        or o.remark <> n.remark
        or o.account_flag <> n.account_flag
        or o.account_msg <> n.account_msg
        or o.status <> n.status
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.draft_number <> n.draft_number
        or o.draft_id <> n.draft_id
        or o.virtual_account_no <> n.virtual_account_no
        or o.tran_no <> n.tran_no
        or o.op_no <> n.op_no
        or o.return_date <> n.return_date
        or o.trans_seq <> n.trans_seq
        or o.snd_brn <> n.snd_brn
        or o.entry_no <> n.entry_no
        or o.acctou <> n.acctou
        or o.audit_status <> n.audit_status
        or o.vostro_account_type <> n.vostro_account_type
        or o.account_status <> n.account_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_pay_account_info_cl(
            id -- 
            ,account_no -- 
            ,txn_type -- 
            ,branch_no -- 
            ,txn_date -- 
            ,seqno -- 
            ,total_amt -- 
            ,send_bank_no -- 
            ,pay_account_no -- 
            ,pay_name -- 
            ,pay_addr -- 
            ,rcv_bank_no -- 
            ,rcv_branch_no -- 
            ,rcv_account_no -- 
            ,rcv_name -- 
            ,rcv_addr -- 
            ,remark -- 
            ,account_flag -- 
            ,account_msg -- 
            ,status -- 
            ,last_upd_time -- 
            ,misc -- 
            ,draft_number -- 
            ,draft_id -- 
            ,virtual_account_no -- 
            ,tran_no -- 
            ,op_no -- 
            ,return_date -- 
            ,trans_seq -- 
            ,snd_brn -- 
            ,entry_no -- 
            ,acctou -- 
            ,audit_status -- 
            ,vostro_account_type -- 
            ,account_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_pay_account_info_op(
            id -- 
            ,account_no -- 
            ,txn_type -- 
            ,branch_no -- 
            ,txn_date -- 
            ,seqno -- 
            ,total_amt -- 
            ,send_bank_no -- 
            ,pay_account_no -- 
            ,pay_name -- 
            ,pay_addr -- 
            ,rcv_bank_no -- 
            ,rcv_branch_no -- 
            ,rcv_account_no -- 
            ,rcv_name -- 
            ,rcv_addr -- 
            ,remark -- 
            ,account_flag -- 
            ,account_msg -- 
            ,status -- 
            ,last_upd_time -- 
            ,misc -- 
            ,draft_number -- 
            ,draft_id -- 
            ,virtual_account_no -- 
            ,tran_no -- 
            ,op_no -- 
            ,return_date -- 
            ,trans_seq -- 
            ,snd_brn -- 
            ,entry_no -- 
            ,acctou -- 
            ,audit_status -- 
            ,vostro_account_type -- 
            ,account_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.account_no -- 
    ,o.txn_type -- 
    ,o.branch_no -- 
    ,o.txn_date -- 
    ,o.seqno -- 
    ,o.total_amt -- 
    ,o.send_bank_no -- 
    ,o.pay_account_no -- 
    ,o.pay_name -- 
    ,o.pay_addr -- 
    ,o.rcv_bank_no -- 
    ,o.rcv_branch_no -- 
    ,o.rcv_account_no -- 
    ,o.rcv_name -- 
    ,o.rcv_addr -- 
    ,o.remark -- 
    ,o.account_flag -- 
    ,o.account_msg -- 
    ,o.status -- 
    ,o.last_upd_time -- 
    ,o.misc -- 
    ,o.draft_number -- 
    ,o.draft_id -- 
    ,o.virtual_account_no -- 
    ,o.tran_no -- 
    ,o.op_no -- 
    ,o.return_date -- 
    ,o.trans_seq -- 
    ,o.snd_brn -- 
    ,o.entry_no -- 
    ,o.acctou -- 
    ,o.audit_status -- 
    ,o.vostro_account_type -- 
    ,o.account_status -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_pay_account_info_bk o
    left join ${iol_schema}.bdps_pay_account_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_pay_account_info_cl d
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
-- truncate table ${iol_schema}.bdps_pay_account_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_pay_account_info exchange partition p_19000101 with table ${iol_schema}.bdps_pay_account_info_cl;
alter table ${iol_schema}.bdps_pay_account_info exchange partition p_20991231 with table ${iol_schema}.bdps_pay_account_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_pay_account_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_pay_account_info_op purge;
drop table ${iol_schema}.bdps_pay_account_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_pay_account_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_pay_account_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
