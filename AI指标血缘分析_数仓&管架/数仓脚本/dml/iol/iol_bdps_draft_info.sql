/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_draft_info
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
create table ${iol_schema}.bdps_draft_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_draft_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_draft_info_op purge;
drop table ${iol_schema}.bdps_draft_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_draft_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_draft_info where 0=1;

create table ${iol_schema}.bdps_draft_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_draft_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_draft_info_cl(
            id -- 
            ,draft_number -- 
            ,src_type -- 
            ,end_or_sement_mk -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,remit_date -- 
            ,maturity_date -- 
            ,remitter_cmonid -- 
            ,remitter_name -- 
            ,remitter_account -- 
            ,remitter_bank_no -- 
            ,remitter_bank_name -- 
            ,df_drwr_cdtratgs -- 
            ,df_drwr_cdtratgsagcy -- 
            ,df_drwr_cdtratgduedt -- 
            ,acceptor -- 
            ,acceptor_bank_no -- 
            ,acceptor_actno -- 
            ,acceptor_bank_name -- 
            ,payee_name -- 
            ,payee_account -- 
            ,payee_bank_no -- 
            ,payee_bank_name -- 
            ,face_amount -- 
            ,drft_remark -- 
            ,drawer_bank_flag -- 
            ,belong_branch_id -- 
            ,store_status -- 
            ,status -- 
            ,tmp_status -- 
            ,collztn_status -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,rebb_front_hander -- 
            ,rebb_front_hander2 -- 
            ,rebb_front_hander3 -- 
            ,is_xz -- 
            ,xz_info -- 
            ,cust_oper_nm -- 
            ,cust_oper_idtyp -- 
            ,cust_oper_idnum -- 
            ,cust_oper_com -- 
            ,cust_oper_date -- 
            ,ebank_oper_date -- 
            ,ebank_oper_no -- 
            ,ebank_oper_name -- 
            ,owner_cust_id -- 
            ,credit_cust_no -- 
            ,is_same_city -- 
            ,gbba_endorse_com -- 
            ,cust_account_no -- 
            ,ref_txn_type -- 
            ,deposit_limit -- 
            ,delay_flag -- 
            ,is_virtual_draft -- 
            ,is_risk_draft -- 
            ,risk_reason -- 
            ,isclear -- 是否结清，0未结清；1已结清
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_draft_info_op(
            id -- 
            ,draft_number -- 
            ,src_type -- 
            ,end_or_sement_mk -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,remit_date -- 
            ,maturity_date -- 
            ,remitter_cmonid -- 
            ,remitter_name -- 
            ,remitter_account -- 
            ,remitter_bank_no -- 
            ,remitter_bank_name -- 
            ,df_drwr_cdtratgs -- 
            ,df_drwr_cdtratgsagcy -- 
            ,df_drwr_cdtratgduedt -- 
            ,acceptor -- 
            ,acceptor_bank_no -- 
            ,acceptor_actno -- 
            ,acceptor_bank_name -- 
            ,payee_name -- 
            ,payee_account -- 
            ,payee_bank_no -- 
            ,payee_bank_name -- 
            ,face_amount -- 
            ,drft_remark -- 
            ,drawer_bank_flag -- 
            ,belong_branch_id -- 
            ,store_status -- 
            ,status -- 
            ,tmp_status -- 
            ,collztn_status -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,rebb_front_hander -- 
            ,rebb_front_hander2 -- 
            ,rebb_front_hander3 -- 
            ,is_xz -- 
            ,xz_info -- 
            ,cust_oper_nm -- 
            ,cust_oper_idtyp -- 
            ,cust_oper_idnum -- 
            ,cust_oper_com -- 
            ,cust_oper_date -- 
            ,ebank_oper_date -- 
            ,ebank_oper_no -- 
            ,ebank_oper_name -- 
            ,owner_cust_id -- 
            ,credit_cust_no -- 
            ,is_same_city -- 
            ,gbba_endorse_com -- 
            ,cust_account_no -- 
            ,ref_txn_type -- 
            ,deposit_limit -- 
            ,delay_flag -- 
            ,is_virtual_draft -- 
            ,is_risk_draft -- 
            ,risk_reason -- 
            ,isclear -- 是否结清，0未结清；1已结清
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 
    ,nvl(n.src_type, o.src_type) as src_type -- 
    ,nvl(n.end_or_sement_mk, o.end_or_sement_mk) as end_or_sement_mk -- 
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 
    ,nvl(n.remitter_cmonid, o.remitter_cmonid) as remitter_cmonid -- 
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 
    ,nvl(n.df_drwr_cdtratgs, o.df_drwr_cdtratgs) as df_drwr_cdtratgs -- 
    ,nvl(n.df_drwr_cdtratgsagcy, o.df_drwr_cdtratgsagcy) as df_drwr_cdtratgsagcy -- 
    ,nvl(n.df_drwr_cdtratgduedt, o.df_drwr_cdtratgduedt) as df_drwr_cdtratgduedt -- 
    ,nvl(n.acceptor, o.acceptor) as acceptor -- 
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 
    ,nvl(n.acceptor_actno, o.acceptor_actno) as acceptor_actno -- 
    ,nvl(n.acceptor_bank_name, o.acceptor_bank_name) as acceptor_bank_name -- 
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 
    ,nvl(n.face_amount, o.face_amount) as face_amount -- 
    ,nvl(n.drft_remark, o.drft_remark) as drft_remark -- 
    ,nvl(n.drawer_bank_flag, o.drawer_bank_flag) as drawer_bank_flag -- 
    ,nvl(n.belong_branch_id, o.belong_branch_id) as belong_branch_id -- 
    ,nvl(n.store_status, o.store_status) as store_status -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.tmp_status, o.tmp_status) as tmp_status -- 
    ,nvl(n.collztn_status, o.collztn_status) as collztn_status -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.rebb_front_hander, o.rebb_front_hander) as rebb_front_hander -- 
    ,nvl(n.rebb_front_hander2, o.rebb_front_hander2) as rebb_front_hander2 -- 
    ,nvl(n.rebb_front_hander3, o.rebb_front_hander3) as rebb_front_hander3 -- 
    ,nvl(n.is_xz, o.is_xz) as is_xz -- 
    ,nvl(n.xz_info, o.xz_info) as xz_info -- 
    ,nvl(n.cust_oper_nm, o.cust_oper_nm) as cust_oper_nm -- 
    ,nvl(n.cust_oper_idtyp, o.cust_oper_idtyp) as cust_oper_idtyp -- 
    ,nvl(n.cust_oper_idnum, o.cust_oper_idnum) as cust_oper_idnum -- 
    ,nvl(n.cust_oper_com, o.cust_oper_com) as cust_oper_com -- 
    ,nvl(n.cust_oper_date, o.cust_oper_date) as cust_oper_date -- 
    ,nvl(n.ebank_oper_date, o.ebank_oper_date) as ebank_oper_date -- 
    ,nvl(n.ebank_oper_no, o.ebank_oper_no) as ebank_oper_no -- 
    ,nvl(n.ebank_oper_name, o.ebank_oper_name) as ebank_oper_name -- 
    ,nvl(n.owner_cust_id, o.owner_cust_id) as owner_cust_id -- 
    ,nvl(n.credit_cust_no, o.credit_cust_no) as credit_cust_no -- 
    ,nvl(n.is_same_city, o.is_same_city) as is_same_city -- 
    ,nvl(n.gbba_endorse_com, o.gbba_endorse_com) as gbba_endorse_com -- 
    ,nvl(n.cust_account_no, o.cust_account_no) as cust_account_no -- 
    ,nvl(n.ref_txn_type, o.ref_txn_type) as ref_txn_type -- 
    ,nvl(n.deposit_limit, o.deposit_limit) as deposit_limit -- 
    ,nvl(n.delay_flag, o.delay_flag) as delay_flag -- 
    ,nvl(n.is_virtual_draft, o.is_virtual_draft) as is_virtual_draft -- 
    ,nvl(n.is_risk_draft, o.is_risk_draft) as is_risk_draft -- 
    ,nvl(n.risk_reason, o.risk_reason) as risk_reason -- 
    ,nvl(n.isclear, o.isclear) as isclear -- 是否结清，0未结清；1已结清
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
from (select * from ${iol_schema}.bdps_draft_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_draft_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.draft_number <> n.draft_number
        or o.src_type <> n.src_type
        or o.end_or_sement_mk <> n.end_or_sement_mk
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.remitter_cmonid <> n.remitter_cmonid
        or o.remitter_name <> n.remitter_name
        or o.remitter_account <> n.remitter_account
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.df_drwr_cdtratgs <> n.df_drwr_cdtratgs
        or o.df_drwr_cdtratgsagcy <> n.df_drwr_cdtratgsagcy
        or o.df_drwr_cdtratgduedt <> n.df_drwr_cdtratgduedt
        or o.acceptor <> n.acceptor
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_actno <> n.acceptor_actno
        or o.acceptor_bank_name <> n.acceptor_bank_name
        or o.payee_name <> n.payee_name
        or o.payee_account <> n.payee_account
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.face_amount <> n.face_amount
        or o.drft_remark <> n.drft_remark
        or o.drawer_bank_flag <> n.drawer_bank_flag
        or o.belong_branch_id <> n.belong_branch_id
        or o.store_status <> n.store_status
        or o.status <> n.status
        or o.tmp_status <> n.tmp_status
        or o.collztn_status <> n.collztn_status
        or o.misc <> n.misc
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.rebb_front_hander <> n.rebb_front_hander
        or o.rebb_front_hander2 <> n.rebb_front_hander2
        or o.rebb_front_hander3 <> n.rebb_front_hander3
        or o.is_xz <> n.is_xz
        or o.xz_info <> n.xz_info
        or o.cust_oper_nm <> n.cust_oper_nm
        or o.cust_oper_idtyp <> n.cust_oper_idtyp
        or o.cust_oper_idnum <> n.cust_oper_idnum
        or o.cust_oper_com <> n.cust_oper_com
        or o.cust_oper_date <> n.cust_oper_date
        or o.ebank_oper_date <> n.ebank_oper_date
        or o.ebank_oper_no <> n.ebank_oper_no
        or o.ebank_oper_name <> n.ebank_oper_name
        or o.owner_cust_id <> n.owner_cust_id
        or o.credit_cust_no <> n.credit_cust_no
        or o.is_same_city <> n.is_same_city
        or o.gbba_endorse_com <> n.gbba_endorse_com
        or o.cust_account_no <> n.cust_account_no
        or o.ref_txn_type <> n.ref_txn_type
        or o.deposit_limit <> n.deposit_limit
        or o.delay_flag <> n.delay_flag
        or o.is_virtual_draft <> n.is_virtual_draft
        or o.is_risk_draft <> n.is_risk_draft
        or o.risk_reason <> n.risk_reason
        or o.isclear <> n.isclear
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_draft_info_cl(
            id -- 
            ,draft_number -- 
            ,src_type -- 
            ,end_or_sement_mk -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,remit_date -- 
            ,maturity_date -- 
            ,remitter_cmonid -- 
            ,remitter_name -- 
            ,remitter_account -- 
            ,remitter_bank_no -- 
            ,remitter_bank_name -- 
            ,df_drwr_cdtratgs -- 
            ,df_drwr_cdtratgsagcy -- 
            ,df_drwr_cdtratgduedt -- 
            ,acceptor -- 
            ,acceptor_bank_no -- 
            ,acceptor_actno -- 
            ,acceptor_bank_name -- 
            ,payee_name -- 
            ,payee_account -- 
            ,payee_bank_no -- 
            ,payee_bank_name -- 
            ,face_amount -- 
            ,drft_remark -- 
            ,drawer_bank_flag -- 
            ,belong_branch_id -- 
            ,store_status -- 
            ,status -- 
            ,tmp_status -- 
            ,collztn_status -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,rebb_front_hander -- 
            ,rebb_front_hander2 -- 
            ,rebb_front_hander3 -- 
            ,is_xz -- 
            ,xz_info -- 
            ,cust_oper_nm -- 
            ,cust_oper_idtyp -- 
            ,cust_oper_idnum -- 
            ,cust_oper_com -- 
            ,cust_oper_date -- 
            ,ebank_oper_date -- 
            ,ebank_oper_no -- 
            ,ebank_oper_name -- 
            ,owner_cust_id -- 
            ,credit_cust_no -- 
            ,is_same_city -- 
            ,gbba_endorse_com -- 
            ,cust_account_no -- 
            ,ref_txn_type -- 
            ,deposit_limit -- 
            ,delay_flag -- 
            ,is_virtual_draft -- 
            ,is_risk_draft -- 
            ,risk_reason -- 
            ,isclear -- 是否结清，0未结清；1已结清
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_draft_info_op(
            id -- 
            ,draft_number -- 
            ,src_type -- 
            ,end_or_sement_mk -- 
            ,draft_attr -- 
            ,draft_type -- 
            ,remit_date -- 
            ,maturity_date -- 
            ,remitter_cmonid -- 
            ,remitter_name -- 
            ,remitter_account -- 
            ,remitter_bank_no -- 
            ,remitter_bank_name -- 
            ,df_drwr_cdtratgs -- 
            ,df_drwr_cdtratgsagcy -- 
            ,df_drwr_cdtratgduedt -- 
            ,acceptor -- 
            ,acceptor_bank_no -- 
            ,acceptor_actno -- 
            ,acceptor_bank_name -- 
            ,payee_name -- 
            ,payee_account -- 
            ,payee_bank_no -- 
            ,payee_bank_name -- 
            ,face_amount -- 
            ,drft_remark -- 
            ,drawer_bank_flag -- 
            ,belong_branch_id -- 
            ,store_status -- 
            ,status -- 
            ,tmp_status -- 
            ,collztn_status -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,rebb_front_hander -- 
            ,rebb_front_hander2 -- 
            ,rebb_front_hander3 -- 
            ,is_xz -- 
            ,xz_info -- 
            ,cust_oper_nm -- 
            ,cust_oper_idtyp -- 
            ,cust_oper_idnum -- 
            ,cust_oper_com -- 
            ,cust_oper_date -- 
            ,ebank_oper_date -- 
            ,ebank_oper_no -- 
            ,ebank_oper_name -- 
            ,owner_cust_id -- 
            ,credit_cust_no -- 
            ,is_same_city -- 
            ,gbba_endorse_com -- 
            ,cust_account_no -- 
            ,ref_txn_type -- 
            ,deposit_limit -- 
            ,delay_flag -- 
            ,is_virtual_draft -- 
            ,is_risk_draft -- 
            ,risk_reason -- 
            ,isclear -- 是否结清，0未结清；1已结清
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.draft_number -- 
    ,o.src_type -- 
    ,o.end_or_sement_mk -- 
    ,o.draft_attr -- 
    ,o.draft_type -- 
    ,o.remit_date -- 
    ,o.maturity_date -- 
    ,o.remitter_cmonid -- 
    ,o.remitter_name -- 
    ,o.remitter_account -- 
    ,o.remitter_bank_no -- 
    ,o.remitter_bank_name -- 
    ,o.df_drwr_cdtratgs -- 
    ,o.df_drwr_cdtratgsagcy -- 
    ,o.df_drwr_cdtratgduedt -- 
    ,o.acceptor -- 
    ,o.acceptor_bank_no -- 
    ,o.acceptor_actno -- 
    ,o.acceptor_bank_name -- 
    ,o.payee_name -- 
    ,o.payee_account -- 
    ,o.payee_bank_no -- 
    ,o.payee_bank_name -- 
    ,o.face_amount -- 
    ,o.drft_remark -- 
    ,o.drawer_bank_flag -- 
    ,o.belong_branch_id -- 
    ,o.store_status -- 
    ,o.status -- 
    ,o.tmp_status -- 
    ,o.collztn_status -- 
    ,o.misc -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.rebb_front_hander -- 
    ,o.rebb_front_hander2 -- 
    ,o.rebb_front_hander3 -- 
    ,o.is_xz -- 
    ,o.xz_info -- 
    ,o.cust_oper_nm -- 
    ,o.cust_oper_idtyp -- 
    ,o.cust_oper_idnum -- 
    ,o.cust_oper_com -- 
    ,o.cust_oper_date -- 
    ,o.ebank_oper_date -- 
    ,o.ebank_oper_no -- 
    ,o.ebank_oper_name -- 
    ,o.owner_cust_id -- 
    ,o.credit_cust_no -- 
    ,o.is_same_city -- 
    ,o.gbba_endorse_com -- 
    ,o.cust_account_no -- 
    ,o.ref_txn_type -- 
    ,o.deposit_limit -- 
    ,o.delay_flag -- 
    ,o.is_virtual_draft -- 
    ,o.is_risk_draft -- 
    ,o.risk_reason -- 
    ,o.isclear -- 是否结清，0未结清；1已结清
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_draft_info_bk o
    left join ${iol_schema}.bdps_draft_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_draft_info_cl d
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
-- truncate table ${iol_schema}.bdps_draft_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_draft_info exchange partition p_19000101 with table ${iol_schema}.bdps_draft_info_cl;
alter table ${iol_schema}.bdps_draft_info exchange partition p_20991231 with table ${iol_schema}.bdps_draft_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_draft_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_draft_info_op purge;
drop table ${iol_schema}.bdps_draft_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_draft_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_draft_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
