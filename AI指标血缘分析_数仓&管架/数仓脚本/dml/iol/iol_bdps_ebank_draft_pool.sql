/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_ebank_draft_pool
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
create table ${iol_schema}.bdps_ebank_draft_pool_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_ebank_draft_pool;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_ebank_draft_pool_op purge;
drop table ${iol_schema}.bdps_ebank_draft_pool_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_ebank_draft_pool_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_ebank_draft_pool where 0=1;

create table ${iol_schema}.bdps_ebank_draft_pool_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_ebank_draft_pool where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_ebank_draft_pool_cl(
            id -- 
            ,txn_type -- 
            ,ref_detail_id -- 
            ,detail_table -- 
            ,draft_id -- 
            ,draft_number -- 
            ,lock_flag -- 
            ,app_status -- 
            ,app_date -- 
            ,check_date -- 
            ,ebank_seq_no -- 
            ,cust_org_code -- 
            ,reason -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id -- 
            ,cust_no -- 
            ,int_tm -- 
            ,gbba_endorse_com -- 
            ,cust_oper_no -- 
            ,cust_oper_nm -- 
            ,cust_oper_sex -- 
            ,cust_oper_idtyp -- 
            ,cust_oper_idnum -- 
            ,cust_oper_idval -- 
            ,misc -- 
            ,chn_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_ebank_draft_pool_op(
            id -- 
            ,txn_type -- 
            ,ref_detail_id -- 
            ,detail_table -- 
            ,draft_id -- 
            ,draft_number -- 
            ,lock_flag -- 
            ,app_status -- 
            ,app_date -- 
            ,check_date -- 
            ,ebank_seq_no -- 
            ,cust_org_code -- 
            ,reason -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id -- 
            ,cust_no -- 
            ,int_tm -- 
            ,gbba_endorse_com -- 
            ,cust_oper_no -- 
            ,cust_oper_nm -- 
            ,cust_oper_sex -- 
            ,cust_oper_idtyp -- 
            ,cust_oper_idnum -- 
            ,cust_oper_idval -- 
            ,misc -- 
            ,chn_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.txn_type, o.txn_type) as txn_type -- 
    ,nvl(n.ref_detail_id, o.ref_detail_id) as ref_detail_id -- 
    ,nvl(n.detail_table, o.detail_table) as detail_table -- 
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 
    ,nvl(n.lock_flag, o.lock_flag) as lock_flag -- 
    ,nvl(n.app_status, o.app_status) as app_status -- 
    ,nvl(n.app_date, o.app_date) as app_date -- 
    ,nvl(n.check_date, o.check_date) as check_date -- 
    ,nvl(n.ebank_seq_no, o.ebank_seq_no) as ebank_seq_no -- 
    ,nvl(n.cust_org_code, o.cust_org_code) as cust_org_code -- 
    ,nvl(n.reason, o.reason) as reason -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 
    ,nvl(n.int_tm, o.int_tm) as int_tm -- 
    ,nvl(n.gbba_endorse_com, o.gbba_endorse_com) as gbba_endorse_com -- 
    ,nvl(n.cust_oper_no, o.cust_oper_no) as cust_oper_no -- 
    ,nvl(n.cust_oper_nm, o.cust_oper_nm) as cust_oper_nm -- 
    ,nvl(n.cust_oper_sex, o.cust_oper_sex) as cust_oper_sex -- 
    ,nvl(n.cust_oper_idtyp, o.cust_oper_idtyp) as cust_oper_idtyp -- 
    ,nvl(n.cust_oper_idnum, o.cust_oper_idnum) as cust_oper_idnum -- 
    ,nvl(n.cust_oper_idval, o.cust_oper_idval) as cust_oper_idval -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.chn_flag, o.chn_flag) as chn_flag -- 
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
from (select * from ${iol_schema}.bdps_ebank_draft_pool_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_ebank_draft_pool where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.txn_type <> n.txn_type
        or o.ref_detail_id <> n.ref_detail_id
        or o.detail_table <> n.detail_table
        or o.draft_id <> n.draft_id
        or o.draft_number <> n.draft_number
        or o.lock_flag <> n.lock_flag
        or o.app_status <> n.app_status
        or o.app_date <> n.app_date
        or o.check_date <> n.check_date
        or o.ebank_seq_no <> n.ebank_seq_no
        or o.cust_org_code <> n.cust_org_code
        or o.reason <> n.reason
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.branch_id <> n.branch_id
        or o.cust_no <> n.cust_no
        or o.int_tm <> n.int_tm
        or o.gbba_endorse_com <> n.gbba_endorse_com
        or o.cust_oper_no <> n.cust_oper_no
        or o.cust_oper_nm <> n.cust_oper_nm
        or o.cust_oper_sex <> n.cust_oper_sex
        or o.cust_oper_idtyp <> n.cust_oper_idtyp
        or o.cust_oper_idnum <> n.cust_oper_idnum
        or o.cust_oper_idval <> n.cust_oper_idval
        or o.misc <> n.misc
        or o.chn_flag <> n.chn_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_ebank_draft_pool_cl(
            id -- 
            ,txn_type -- 
            ,ref_detail_id -- 
            ,detail_table -- 
            ,draft_id -- 
            ,draft_number -- 
            ,lock_flag -- 
            ,app_status -- 
            ,app_date -- 
            ,check_date -- 
            ,ebank_seq_no -- 
            ,cust_org_code -- 
            ,reason -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id -- 
            ,cust_no -- 
            ,int_tm -- 
            ,gbba_endorse_com -- 
            ,cust_oper_no -- 
            ,cust_oper_nm -- 
            ,cust_oper_sex -- 
            ,cust_oper_idtyp -- 
            ,cust_oper_idnum -- 
            ,cust_oper_idval -- 
            ,misc -- 
            ,chn_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_ebank_draft_pool_op(
            id -- 
            ,txn_type -- 
            ,ref_detail_id -- 
            ,detail_table -- 
            ,draft_id -- 
            ,draft_number -- 
            ,lock_flag -- 
            ,app_status -- 
            ,app_date -- 
            ,check_date -- 
            ,ebank_seq_no -- 
            ,cust_org_code -- 
            ,reason -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,branch_id -- 
            ,cust_no -- 
            ,int_tm -- 
            ,gbba_endorse_com -- 
            ,cust_oper_no -- 
            ,cust_oper_nm -- 
            ,cust_oper_sex -- 
            ,cust_oper_idtyp -- 
            ,cust_oper_idnum -- 
            ,cust_oper_idval -- 
            ,misc -- 
            ,chn_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.txn_type -- 
    ,o.ref_detail_id -- 
    ,o.detail_table -- 
    ,o.draft_id -- 
    ,o.draft_number -- 
    ,o.lock_flag -- 
    ,o.app_status -- 
    ,o.app_date -- 
    ,o.check_date -- 
    ,o.ebank_seq_no -- 
    ,o.cust_org_code -- 
    ,o.reason -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.branch_id -- 
    ,o.cust_no -- 
    ,o.int_tm -- 
    ,o.gbba_endorse_com -- 
    ,o.cust_oper_no -- 
    ,o.cust_oper_nm -- 
    ,o.cust_oper_sex -- 
    ,o.cust_oper_idtyp -- 
    ,o.cust_oper_idnum -- 
    ,o.cust_oper_idval -- 
    ,o.misc -- 
    ,o.chn_flag -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_ebank_draft_pool_bk o
    left join ${iol_schema}.bdps_ebank_draft_pool_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_ebank_draft_pool_cl d
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
-- truncate table ${iol_schema}.bdps_ebank_draft_pool;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_ebank_draft_pool exchange partition p_19000101 with table ${iol_schema}.bdps_ebank_draft_pool_cl;
alter table ${iol_schema}.bdps_ebank_draft_pool exchange partition p_20991231 with table ${iol_schema}.bdps_ebank_draft_pool_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_ebank_draft_pool to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_ebank_draft_pool_op purge;
drop table ${iol_schema}.bdps_ebank_draft_pool_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_ebank_draft_pool_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_ebank_draft_pool',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
