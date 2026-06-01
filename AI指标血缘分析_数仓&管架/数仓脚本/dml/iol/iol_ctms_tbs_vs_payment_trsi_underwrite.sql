/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_payment_trsi_underwrite
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
create table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite where 0=1;

create table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_cl(
            cpty_id -- 
            ,settledate -- 
            ,generatedate -- 
            ,releasedate -- 
            ,actiontype -- 
            ,dealtype -- 
            ,buztype -- 
            ,assettype -- 
            ,keepfolder_id -- 
            ,payment_id_prev -- 
            ,sequence -- 
            ,eventtype -- 
            ,deal_id -- 
            ,deal_tablename -- 
            ,dealsconfirm_id -- 
            ,aspclient_id -- 
            ,payment_id -- 
            ,cpty_datasymbol_id -- 
            ,cpty_lastmodified -- 
            ,cpty_g_mgr_bank -- 
            ,cpty_g_stl_date -- 
            ,cpty_g_ba_no -- 
            ,cpty_g_ba_bank -- 
            ,cpty_g_ba_name -- 
            ,cpty_g_ca_bank_ex -- 
            ,cpty_g_ca_no -- 
            ,cpty_g_ca_bank -- 
            ,cpty_g_ca_name -- 
            ,cpty_g_bond_total_amt -- 
            ,cpty_g_bond_amt -- 
            ,cpty_g_bond_name -- 
            ,cpty_g_bond_id -- 
            ,cpty_g_cash_amt -- 
            ,cpty_bond_acc_no -- 
            ,cpty_bond_acc_bank -- 
            ,cpty_bond_acc_name -- 
            ,cpty_cash_acc_bank_ex -- 
            ,cpty_cash_acc_no -- 
            ,cpty_cash_acc_bank -- 
            ,cpty_cash_acc_cname -- 
            ,cpty_cash_acc_ename -- 
            ,cpty_bs -- 
            ,cpty_serial_number -- 
            ,self_datasymbol_id -- 
            ,self_lastmodified -- 
            ,self_g_mgr_bank -- 
            ,self_g_stl_date -- 
            ,self_g_ba_no -- 
            ,self_g_ba_bank -- 
            ,self_g_ba_name -- 
            ,self_g_ca_bank_ex -- 
            ,self_g_ca_no -- 
            ,self_g_ca_bank -- 
            ,self_g_ca_name -- 
            ,self_g_bond_total_amt -- 
            ,self_g_bond_amt -- 
            ,self_g_bond_name -- 
            ,self_g_bond_id -- 
            ,self_g_cash_amt -- 
            ,self_bond_acc_no -- 
            ,self_bond_acc_bank -- 
            ,self_bond_acc_name -- 
            ,self_cash_acc_bank_ex -- 
            ,self_cash_acc_no -- 
            ,self_cash_acc_bank -- 
            ,self_cash_acc_cname -- 
            ,self_cash_acc_ename -- 
            ,self_bs -- 
            ,self_serial_number -- 
            ,bs -- 
            ,serial_number -- 
            ,note -- 
            ,act_advance_amount -- 
            ,act_settlemethod -- 
            ,settlemethod -- 
            ,users_id_modifier -- 
            ,lastmodified -- 
            ,pstatus -- 
            ,act_quantity -- 
            ,act_securitycode -- 
            ,act_settleamount -- 
            ,act_settlecurrency -- 
            ,act_settledate -- 
            ,quantity -- 
            ,securitycode -- 
            ,settleamount -- 
            ,settlecurrency -- 
            ,payreceivetype -- 
            ,cpty_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_op(
            cpty_id -- 
            ,settledate -- 
            ,generatedate -- 
            ,releasedate -- 
            ,actiontype -- 
            ,dealtype -- 
            ,buztype -- 
            ,assettype -- 
            ,keepfolder_id -- 
            ,payment_id_prev -- 
            ,sequence -- 
            ,eventtype -- 
            ,deal_id -- 
            ,deal_tablename -- 
            ,dealsconfirm_id -- 
            ,aspclient_id -- 
            ,payment_id -- 
            ,cpty_datasymbol_id -- 
            ,cpty_lastmodified -- 
            ,cpty_g_mgr_bank -- 
            ,cpty_g_stl_date -- 
            ,cpty_g_ba_no -- 
            ,cpty_g_ba_bank -- 
            ,cpty_g_ba_name -- 
            ,cpty_g_ca_bank_ex -- 
            ,cpty_g_ca_no -- 
            ,cpty_g_ca_bank -- 
            ,cpty_g_ca_name -- 
            ,cpty_g_bond_total_amt -- 
            ,cpty_g_bond_amt -- 
            ,cpty_g_bond_name -- 
            ,cpty_g_bond_id -- 
            ,cpty_g_cash_amt -- 
            ,cpty_bond_acc_no -- 
            ,cpty_bond_acc_bank -- 
            ,cpty_bond_acc_name -- 
            ,cpty_cash_acc_bank_ex -- 
            ,cpty_cash_acc_no -- 
            ,cpty_cash_acc_bank -- 
            ,cpty_cash_acc_cname -- 
            ,cpty_cash_acc_ename -- 
            ,cpty_bs -- 
            ,cpty_serial_number -- 
            ,self_datasymbol_id -- 
            ,self_lastmodified -- 
            ,self_g_mgr_bank -- 
            ,self_g_stl_date -- 
            ,self_g_ba_no -- 
            ,self_g_ba_bank -- 
            ,self_g_ba_name -- 
            ,self_g_ca_bank_ex -- 
            ,self_g_ca_no -- 
            ,self_g_ca_bank -- 
            ,self_g_ca_name -- 
            ,self_g_bond_total_amt -- 
            ,self_g_bond_amt -- 
            ,self_g_bond_name -- 
            ,self_g_bond_id -- 
            ,self_g_cash_amt -- 
            ,self_bond_acc_no -- 
            ,self_bond_acc_bank -- 
            ,self_bond_acc_name -- 
            ,self_cash_acc_bank_ex -- 
            ,self_cash_acc_no -- 
            ,self_cash_acc_bank -- 
            ,self_cash_acc_cname -- 
            ,self_cash_acc_ename -- 
            ,self_bs -- 
            ,self_serial_number -- 
            ,bs -- 
            ,serial_number -- 
            ,note -- 
            ,act_advance_amount -- 
            ,act_settlemethod -- 
            ,settlemethod -- 
            ,users_id_modifier -- 
            ,lastmodified -- 
            ,pstatus -- 
            ,act_quantity -- 
            ,act_securitycode -- 
            ,act_settleamount -- 
            ,act_settlecurrency -- 
            ,act_settledate -- 
            ,quantity -- 
            ,securitycode -- 
            ,settleamount -- 
            ,settlecurrency -- 
            ,payreceivetype -- 
            ,cpty_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cpty_id, o.cpty_id) as cpty_id -- 
    ,nvl(n.settledate, o.settledate) as settledate -- 
    ,nvl(n.generatedate, o.generatedate) as generatedate -- 
    ,nvl(n.releasedate, o.releasedate) as releasedate -- 
    ,nvl(n.actiontype, o.actiontype) as actiontype -- 
    ,nvl(n.dealtype, o.dealtype) as dealtype -- 
    ,nvl(n.buztype, o.buztype) as buztype -- 
    ,nvl(n.assettype, o.assettype) as assettype -- 
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 
    ,nvl(n.payment_id_prev, o.payment_id_prev) as payment_id_prev -- 
    ,nvl(n.sequence, o.sequence) as sequence -- 
    ,nvl(n.eventtype, o.eventtype) as eventtype -- 
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 
    ,nvl(n.dealsconfirm_id, o.dealsconfirm_id) as dealsconfirm_id -- 
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 
    ,nvl(n.payment_id, o.payment_id) as payment_id -- 
    ,nvl(n.cpty_datasymbol_id, o.cpty_datasymbol_id) as cpty_datasymbol_id -- 
    ,nvl(n.cpty_lastmodified, o.cpty_lastmodified) as cpty_lastmodified -- 
    ,nvl(n.cpty_g_mgr_bank, o.cpty_g_mgr_bank) as cpty_g_mgr_bank -- 
    ,nvl(n.cpty_g_stl_date, o.cpty_g_stl_date) as cpty_g_stl_date -- 
    ,nvl(n.cpty_g_ba_no, o.cpty_g_ba_no) as cpty_g_ba_no -- 
    ,nvl(n.cpty_g_ba_bank, o.cpty_g_ba_bank) as cpty_g_ba_bank -- 
    ,nvl(n.cpty_g_ba_name, o.cpty_g_ba_name) as cpty_g_ba_name -- 
    ,nvl(n.cpty_g_ca_bank_ex, o.cpty_g_ca_bank_ex) as cpty_g_ca_bank_ex -- 
    ,nvl(n.cpty_g_ca_no, o.cpty_g_ca_no) as cpty_g_ca_no -- 
    ,nvl(n.cpty_g_ca_bank, o.cpty_g_ca_bank) as cpty_g_ca_bank -- 
    ,nvl(n.cpty_g_ca_name, o.cpty_g_ca_name) as cpty_g_ca_name -- 
    ,nvl(n.cpty_g_bond_total_amt, o.cpty_g_bond_total_amt) as cpty_g_bond_total_amt -- 
    ,nvl(n.cpty_g_bond_amt, o.cpty_g_bond_amt) as cpty_g_bond_amt -- 
    ,nvl(n.cpty_g_bond_name, o.cpty_g_bond_name) as cpty_g_bond_name -- 
    ,nvl(n.cpty_g_bond_id, o.cpty_g_bond_id) as cpty_g_bond_id -- 
    ,nvl(n.cpty_g_cash_amt, o.cpty_g_cash_amt) as cpty_g_cash_amt -- 
    ,nvl(n.cpty_bond_acc_no, o.cpty_bond_acc_no) as cpty_bond_acc_no -- 
    ,nvl(n.cpty_bond_acc_bank, o.cpty_bond_acc_bank) as cpty_bond_acc_bank -- 
    ,nvl(n.cpty_bond_acc_name, o.cpty_bond_acc_name) as cpty_bond_acc_name -- 
    ,nvl(n.cpty_cash_acc_bank_ex, o.cpty_cash_acc_bank_ex) as cpty_cash_acc_bank_ex -- 
    ,nvl(n.cpty_cash_acc_no, o.cpty_cash_acc_no) as cpty_cash_acc_no -- 
    ,nvl(n.cpty_cash_acc_bank, o.cpty_cash_acc_bank) as cpty_cash_acc_bank -- 
    ,nvl(n.cpty_cash_acc_cname, o.cpty_cash_acc_cname) as cpty_cash_acc_cname -- 
    ,nvl(n.cpty_cash_acc_ename, o.cpty_cash_acc_ename) as cpty_cash_acc_ename -- 
    ,nvl(n.cpty_bs, o.cpty_bs) as cpty_bs -- 
    ,nvl(n.cpty_serial_number, o.cpty_serial_number) as cpty_serial_number -- 
    ,nvl(n.self_datasymbol_id, o.self_datasymbol_id) as self_datasymbol_id -- 
    ,nvl(n.self_lastmodified, o.self_lastmodified) as self_lastmodified -- 
    ,nvl(n.self_g_mgr_bank, o.self_g_mgr_bank) as self_g_mgr_bank -- 
    ,nvl(n.self_g_stl_date, o.self_g_stl_date) as self_g_stl_date -- 
    ,nvl(n.self_g_ba_no, o.self_g_ba_no) as self_g_ba_no -- 
    ,nvl(n.self_g_ba_bank, o.self_g_ba_bank) as self_g_ba_bank -- 
    ,nvl(n.self_g_ba_name, o.self_g_ba_name) as self_g_ba_name -- 
    ,nvl(n.self_g_ca_bank_ex, o.self_g_ca_bank_ex) as self_g_ca_bank_ex -- 
    ,nvl(n.self_g_ca_no, o.self_g_ca_no) as self_g_ca_no -- 
    ,nvl(n.self_g_ca_bank, o.self_g_ca_bank) as self_g_ca_bank -- 
    ,nvl(n.self_g_ca_name, o.self_g_ca_name) as self_g_ca_name -- 
    ,nvl(n.self_g_bond_total_amt, o.self_g_bond_total_amt) as self_g_bond_total_amt -- 
    ,nvl(n.self_g_bond_amt, o.self_g_bond_amt) as self_g_bond_amt -- 
    ,nvl(n.self_g_bond_name, o.self_g_bond_name) as self_g_bond_name -- 
    ,nvl(n.self_g_bond_id, o.self_g_bond_id) as self_g_bond_id -- 
    ,nvl(n.self_g_cash_amt, o.self_g_cash_amt) as self_g_cash_amt -- 
    ,nvl(n.self_bond_acc_no, o.self_bond_acc_no) as self_bond_acc_no -- 
    ,nvl(n.self_bond_acc_bank, o.self_bond_acc_bank) as self_bond_acc_bank -- 
    ,nvl(n.self_bond_acc_name, o.self_bond_acc_name) as self_bond_acc_name -- 
    ,nvl(n.self_cash_acc_bank_ex, o.self_cash_acc_bank_ex) as self_cash_acc_bank_ex -- 
    ,nvl(n.self_cash_acc_no, o.self_cash_acc_no) as self_cash_acc_no -- 
    ,nvl(n.self_cash_acc_bank, o.self_cash_acc_bank) as self_cash_acc_bank -- 
    ,nvl(n.self_cash_acc_cname, o.self_cash_acc_cname) as self_cash_acc_cname -- 
    ,nvl(n.self_cash_acc_ename, o.self_cash_acc_ename) as self_cash_acc_ename -- 
    ,nvl(n.self_bs, o.self_bs) as self_bs -- 
    ,nvl(n.self_serial_number, o.self_serial_number) as self_serial_number -- 
    ,nvl(n.bs, o.bs) as bs -- 
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 
    ,nvl(n.note, o.note) as note -- 
    ,nvl(n.act_advance_amount, o.act_advance_amount) as act_advance_amount -- 
    ,nvl(n.act_settlemethod, o.act_settlemethod) as act_settlemethod -- 
    ,nvl(n.settlemethod, o.settlemethod) as settlemethod -- 
    ,nvl(n.users_id_modifier, o.users_id_modifier) as users_id_modifier -- 
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 
    ,nvl(n.pstatus, o.pstatus) as pstatus -- 
    ,nvl(n.act_quantity, o.act_quantity) as act_quantity -- 
    ,nvl(n.act_securitycode, o.act_securitycode) as act_securitycode -- 
    ,nvl(n.act_settleamount, o.act_settleamount) as act_settleamount -- 
    ,nvl(n.act_settlecurrency, o.act_settlecurrency) as act_settlecurrency -- 
    ,nvl(n.act_settledate, o.act_settledate) as act_settledate -- 
    ,nvl(n.quantity, o.quantity) as quantity -- 
    ,nvl(n.securitycode, o.securitycode) as securitycode -- 
    ,nvl(n.settleamount, o.settleamount) as settleamount -- 
    ,nvl(n.settlecurrency, o.settlecurrency) as settlecurrency -- 
    ,nvl(n.payreceivetype, o.payreceivetype) as payreceivetype -- 
    ,nvl(n.cpty_name, o.cpty_name) as cpty_name -- 
    ,case when
            n.payment_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.payment_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.payment_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_payment_trsi_underwrite where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.payment_id = n.payment_id
where (
        o.payment_id is null
    )
    or (
        n.payment_id is null
    )
    or (
        o.cpty_id <> n.cpty_id
        or o.settledate <> n.settledate
        or o.generatedate <> n.generatedate
        or o.releasedate <> n.releasedate
        or o.actiontype <> n.actiontype
        or o.dealtype <> n.dealtype
        or o.buztype <> n.buztype
        or o.assettype <> n.assettype
        or o.keepfolder_id <> n.keepfolder_id
        or o.payment_id_prev <> n.payment_id_prev
        or o.sequence <> n.sequence
        or o.eventtype <> n.eventtype
        or o.deal_id <> n.deal_id
        or o.deal_tablename <> n.deal_tablename
        or o.dealsconfirm_id <> n.dealsconfirm_id
        or o.aspclient_id <> n.aspclient_id
        or o.cpty_datasymbol_id <> n.cpty_datasymbol_id
        or o.cpty_lastmodified <> n.cpty_lastmodified
        or o.cpty_g_mgr_bank <> n.cpty_g_mgr_bank
        or o.cpty_g_stl_date <> n.cpty_g_stl_date
        or o.cpty_g_ba_no <> n.cpty_g_ba_no
        or o.cpty_g_ba_bank <> n.cpty_g_ba_bank
        or o.cpty_g_ba_name <> n.cpty_g_ba_name
        or o.cpty_g_ca_bank_ex <> n.cpty_g_ca_bank_ex
        or o.cpty_g_ca_no <> n.cpty_g_ca_no
        or o.cpty_g_ca_bank <> n.cpty_g_ca_bank
        or o.cpty_g_ca_name <> n.cpty_g_ca_name
        or o.cpty_g_bond_total_amt <> n.cpty_g_bond_total_amt
        or o.cpty_g_bond_amt <> n.cpty_g_bond_amt
        or o.cpty_g_bond_name <> n.cpty_g_bond_name
        or o.cpty_g_bond_id <> n.cpty_g_bond_id
        or o.cpty_g_cash_amt <> n.cpty_g_cash_amt
        or o.cpty_bond_acc_no <> n.cpty_bond_acc_no
        or o.cpty_bond_acc_bank <> n.cpty_bond_acc_bank
        or o.cpty_bond_acc_name <> n.cpty_bond_acc_name
        or o.cpty_cash_acc_bank_ex <> n.cpty_cash_acc_bank_ex
        or o.cpty_cash_acc_no <> n.cpty_cash_acc_no
        or o.cpty_cash_acc_bank <> n.cpty_cash_acc_bank
        or o.cpty_cash_acc_cname <> n.cpty_cash_acc_cname
        or o.cpty_cash_acc_ename <> n.cpty_cash_acc_ename
        or o.cpty_bs <> n.cpty_bs
        or o.cpty_serial_number <> n.cpty_serial_number
        or o.self_datasymbol_id <> n.self_datasymbol_id
        or o.self_lastmodified <> n.self_lastmodified
        or o.self_g_mgr_bank <> n.self_g_mgr_bank
        or o.self_g_stl_date <> n.self_g_stl_date
        or o.self_g_ba_no <> n.self_g_ba_no
        or o.self_g_ba_bank <> n.self_g_ba_bank
        or o.self_g_ba_name <> n.self_g_ba_name
        or o.self_g_ca_bank_ex <> n.self_g_ca_bank_ex
        or o.self_g_ca_no <> n.self_g_ca_no
        or o.self_g_ca_bank <> n.self_g_ca_bank
        or o.self_g_ca_name <> n.self_g_ca_name
        or o.self_g_bond_total_amt <> n.self_g_bond_total_amt
        or o.self_g_bond_amt <> n.self_g_bond_amt
        or o.self_g_bond_name <> n.self_g_bond_name
        or o.self_g_bond_id <> n.self_g_bond_id
        or o.self_g_cash_amt <> n.self_g_cash_amt
        or o.self_bond_acc_no <> n.self_bond_acc_no
        or o.self_bond_acc_bank <> n.self_bond_acc_bank
        or o.self_bond_acc_name <> n.self_bond_acc_name
        or o.self_cash_acc_bank_ex <> n.self_cash_acc_bank_ex
        or o.self_cash_acc_no <> n.self_cash_acc_no
        or o.self_cash_acc_bank <> n.self_cash_acc_bank
        or o.self_cash_acc_cname <> n.self_cash_acc_cname
        or o.self_cash_acc_ename <> n.self_cash_acc_ename
        or o.self_bs <> n.self_bs
        or o.self_serial_number <> n.self_serial_number
        or o.bs <> n.bs
        or o.serial_number <> n.serial_number
        or o.note <> n.note
        or o.act_advance_amount <> n.act_advance_amount
        or o.act_settlemethod <> n.act_settlemethod
        or o.settlemethod <> n.settlemethod
        or o.users_id_modifier <> n.users_id_modifier
        or o.lastmodified <> n.lastmodified
        or o.pstatus <> n.pstatus
        or o.act_quantity <> n.act_quantity
        or o.act_securitycode <> n.act_securitycode
        or o.act_settleamount <> n.act_settleamount
        or o.act_settlecurrency <> n.act_settlecurrency
        or o.act_settledate <> n.act_settledate
        or o.quantity <> n.quantity
        or o.securitycode <> n.securitycode
        or o.settleamount <> n.settleamount
        or o.settlecurrency <> n.settlecurrency
        or o.payreceivetype <> n.payreceivetype
        or o.cpty_name <> n.cpty_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_cl(
            cpty_id -- 
            ,settledate -- 
            ,generatedate -- 
            ,releasedate -- 
            ,actiontype -- 
            ,dealtype -- 
            ,buztype -- 
            ,assettype -- 
            ,keepfolder_id -- 
            ,payment_id_prev -- 
            ,sequence -- 
            ,eventtype -- 
            ,deal_id -- 
            ,deal_tablename -- 
            ,dealsconfirm_id -- 
            ,aspclient_id -- 
            ,payment_id -- 
            ,cpty_datasymbol_id -- 
            ,cpty_lastmodified -- 
            ,cpty_g_mgr_bank -- 
            ,cpty_g_stl_date -- 
            ,cpty_g_ba_no -- 
            ,cpty_g_ba_bank -- 
            ,cpty_g_ba_name -- 
            ,cpty_g_ca_bank_ex -- 
            ,cpty_g_ca_no -- 
            ,cpty_g_ca_bank -- 
            ,cpty_g_ca_name -- 
            ,cpty_g_bond_total_amt -- 
            ,cpty_g_bond_amt -- 
            ,cpty_g_bond_name -- 
            ,cpty_g_bond_id -- 
            ,cpty_g_cash_amt -- 
            ,cpty_bond_acc_no -- 
            ,cpty_bond_acc_bank -- 
            ,cpty_bond_acc_name -- 
            ,cpty_cash_acc_bank_ex -- 
            ,cpty_cash_acc_no -- 
            ,cpty_cash_acc_bank -- 
            ,cpty_cash_acc_cname -- 
            ,cpty_cash_acc_ename -- 
            ,cpty_bs -- 
            ,cpty_serial_number -- 
            ,self_datasymbol_id -- 
            ,self_lastmodified -- 
            ,self_g_mgr_bank -- 
            ,self_g_stl_date -- 
            ,self_g_ba_no -- 
            ,self_g_ba_bank -- 
            ,self_g_ba_name -- 
            ,self_g_ca_bank_ex -- 
            ,self_g_ca_no -- 
            ,self_g_ca_bank -- 
            ,self_g_ca_name -- 
            ,self_g_bond_total_amt -- 
            ,self_g_bond_amt -- 
            ,self_g_bond_name -- 
            ,self_g_bond_id -- 
            ,self_g_cash_amt -- 
            ,self_bond_acc_no -- 
            ,self_bond_acc_bank -- 
            ,self_bond_acc_name -- 
            ,self_cash_acc_bank_ex -- 
            ,self_cash_acc_no -- 
            ,self_cash_acc_bank -- 
            ,self_cash_acc_cname -- 
            ,self_cash_acc_ename -- 
            ,self_bs -- 
            ,self_serial_number -- 
            ,bs -- 
            ,serial_number -- 
            ,note -- 
            ,act_advance_amount -- 
            ,act_settlemethod -- 
            ,settlemethod -- 
            ,users_id_modifier -- 
            ,lastmodified -- 
            ,pstatus -- 
            ,act_quantity -- 
            ,act_securitycode -- 
            ,act_settleamount -- 
            ,act_settlecurrency -- 
            ,act_settledate -- 
            ,quantity -- 
            ,securitycode -- 
            ,settleamount -- 
            ,settlecurrency -- 
            ,payreceivetype -- 
            ,cpty_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_op(
            cpty_id -- 
            ,settledate -- 
            ,generatedate -- 
            ,releasedate -- 
            ,actiontype -- 
            ,dealtype -- 
            ,buztype -- 
            ,assettype -- 
            ,keepfolder_id -- 
            ,payment_id_prev -- 
            ,sequence -- 
            ,eventtype -- 
            ,deal_id -- 
            ,deal_tablename -- 
            ,dealsconfirm_id -- 
            ,aspclient_id -- 
            ,payment_id -- 
            ,cpty_datasymbol_id -- 
            ,cpty_lastmodified -- 
            ,cpty_g_mgr_bank -- 
            ,cpty_g_stl_date -- 
            ,cpty_g_ba_no -- 
            ,cpty_g_ba_bank -- 
            ,cpty_g_ba_name -- 
            ,cpty_g_ca_bank_ex -- 
            ,cpty_g_ca_no -- 
            ,cpty_g_ca_bank -- 
            ,cpty_g_ca_name -- 
            ,cpty_g_bond_total_amt -- 
            ,cpty_g_bond_amt -- 
            ,cpty_g_bond_name -- 
            ,cpty_g_bond_id -- 
            ,cpty_g_cash_amt -- 
            ,cpty_bond_acc_no -- 
            ,cpty_bond_acc_bank -- 
            ,cpty_bond_acc_name -- 
            ,cpty_cash_acc_bank_ex -- 
            ,cpty_cash_acc_no -- 
            ,cpty_cash_acc_bank -- 
            ,cpty_cash_acc_cname -- 
            ,cpty_cash_acc_ename -- 
            ,cpty_bs -- 
            ,cpty_serial_number -- 
            ,self_datasymbol_id -- 
            ,self_lastmodified -- 
            ,self_g_mgr_bank -- 
            ,self_g_stl_date -- 
            ,self_g_ba_no -- 
            ,self_g_ba_bank -- 
            ,self_g_ba_name -- 
            ,self_g_ca_bank_ex -- 
            ,self_g_ca_no -- 
            ,self_g_ca_bank -- 
            ,self_g_ca_name -- 
            ,self_g_bond_total_amt -- 
            ,self_g_bond_amt -- 
            ,self_g_bond_name -- 
            ,self_g_bond_id -- 
            ,self_g_cash_amt -- 
            ,self_bond_acc_no -- 
            ,self_bond_acc_bank -- 
            ,self_bond_acc_name -- 
            ,self_cash_acc_bank_ex -- 
            ,self_cash_acc_no -- 
            ,self_cash_acc_bank -- 
            ,self_cash_acc_cname -- 
            ,self_cash_acc_ename -- 
            ,self_bs -- 
            ,self_serial_number -- 
            ,bs -- 
            ,serial_number -- 
            ,note -- 
            ,act_advance_amount -- 
            ,act_settlemethod -- 
            ,settlemethod -- 
            ,users_id_modifier -- 
            ,lastmodified -- 
            ,pstatus -- 
            ,act_quantity -- 
            ,act_securitycode -- 
            ,act_settleamount -- 
            ,act_settlecurrency -- 
            ,act_settledate -- 
            ,quantity -- 
            ,securitycode -- 
            ,settleamount -- 
            ,settlecurrency -- 
            ,payreceivetype -- 
            ,cpty_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cpty_id -- 
    ,o.settledate -- 
    ,o.generatedate -- 
    ,o.releasedate -- 
    ,o.actiontype -- 
    ,o.dealtype -- 
    ,o.buztype -- 
    ,o.assettype -- 
    ,o.keepfolder_id -- 
    ,o.payment_id_prev -- 
    ,o.sequence -- 
    ,o.eventtype -- 
    ,o.deal_id -- 
    ,o.deal_tablename -- 
    ,o.dealsconfirm_id -- 
    ,o.aspclient_id -- 
    ,o.payment_id -- 
    ,o.cpty_datasymbol_id -- 
    ,o.cpty_lastmodified -- 
    ,o.cpty_g_mgr_bank -- 
    ,o.cpty_g_stl_date -- 
    ,o.cpty_g_ba_no -- 
    ,o.cpty_g_ba_bank -- 
    ,o.cpty_g_ba_name -- 
    ,o.cpty_g_ca_bank_ex -- 
    ,o.cpty_g_ca_no -- 
    ,o.cpty_g_ca_bank -- 
    ,o.cpty_g_ca_name -- 
    ,o.cpty_g_bond_total_amt -- 
    ,o.cpty_g_bond_amt -- 
    ,o.cpty_g_bond_name -- 
    ,o.cpty_g_bond_id -- 
    ,o.cpty_g_cash_amt -- 
    ,o.cpty_bond_acc_no -- 
    ,o.cpty_bond_acc_bank -- 
    ,o.cpty_bond_acc_name -- 
    ,o.cpty_cash_acc_bank_ex -- 
    ,o.cpty_cash_acc_no -- 
    ,o.cpty_cash_acc_bank -- 
    ,o.cpty_cash_acc_cname -- 
    ,o.cpty_cash_acc_ename -- 
    ,o.cpty_bs -- 
    ,o.cpty_serial_number -- 
    ,o.self_datasymbol_id -- 
    ,o.self_lastmodified -- 
    ,o.self_g_mgr_bank -- 
    ,o.self_g_stl_date -- 
    ,o.self_g_ba_no -- 
    ,o.self_g_ba_bank -- 
    ,o.self_g_ba_name -- 
    ,o.self_g_ca_bank_ex -- 
    ,o.self_g_ca_no -- 
    ,o.self_g_ca_bank -- 
    ,o.self_g_ca_name -- 
    ,o.self_g_bond_total_amt -- 
    ,o.self_g_bond_amt -- 
    ,o.self_g_bond_name -- 
    ,o.self_g_bond_id -- 
    ,o.self_g_cash_amt -- 
    ,o.self_bond_acc_no -- 
    ,o.self_bond_acc_bank -- 
    ,o.self_bond_acc_name -- 
    ,o.self_cash_acc_bank_ex -- 
    ,o.self_cash_acc_no -- 
    ,o.self_cash_acc_bank -- 
    ,o.self_cash_acc_cname -- 
    ,o.self_cash_acc_ename -- 
    ,o.self_bs -- 
    ,o.self_serial_number -- 
    ,o.bs -- 
    ,o.serial_number -- 
    ,o.note -- 
    ,o.act_advance_amount -- 
    ,o.act_settlemethod -- 
    ,o.settlemethod -- 
    ,o.users_id_modifier -- 
    ,o.lastmodified -- 
    ,o.pstatus -- 
    ,o.act_quantity -- 
    ,o.act_securitycode -- 
    ,o.act_settleamount -- 
    ,o.act_settlecurrency -- 
    ,o.act_settledate -- 
    ,o.quantity -- 
    ,o.securitycode -- 
    ,o.settleamount -- 
    ,o.settlecurrency -- 
    ,o.payreceivetype -- 
    ,o.cpty_name -- 
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
from ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_bk o
    left join ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_op n
        on
            o.payment_id = n.payment_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_cl d
        on
            o.payment_id = d.payment_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_tbs_vs_payment_trsi_underwrite') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite exchange partition p_${batch_date} with table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_cl;
alter table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_payment_trsi_underwrite',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
