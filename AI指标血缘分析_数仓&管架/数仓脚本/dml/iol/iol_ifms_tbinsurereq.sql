/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbinsurereq
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
create table ${iol_schema}.ifms_tbinsurereq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbinsurereq;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsurereq_op purge;
drop table ${iol_schema}.ifms_tbinsurereq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsurereq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsurereq where 0=1;

create table ${iol_schema}.ifms_tbinsurereq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsurereq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsurereq_cl(
            trans_date -- 
            ,serial_no -- 
            ,bank_no -- 
            ,asso_serial -- 
            ,ta_code -- 
            ,prd_code -- 
            ,insure_no -- 
            ,client_manager -- 
            ,client_no -- 
            ,client_type -- 
            ,trans_code -- 
            ,trans_name -- 
            ,bank_acc -- 
            ,acc_name -- 
            ,voucher_type -- 
            ,voucher_no -- 
            ,voucher_pwd -- 
            ,voucher_date -- 
            ,voucher_note -- 
            ,curr_type -- 
            ,clear_status -- 
            ,check_status -- 
            ,liqu_status -- 
            ,amt -- 
            ,charge -- 
            ,internal_branch -- 
            ,branch_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,term -- 
            ,channel -- 
            ,err_code -- 
            ,err_msg -- 
            ,insure_date -- 
            ,insure_cfm_no -- 
            ,insure_trans_code -- 
            ,targ_err_code -- 
            ,targ_err_msg -- 
            ,host_date -- 
            ,host_serial -- 
            ,host_trans_code -- 
            ,host_err_code -- 
            ,host_err_msg -- 
            ,status -- 
            ,trans_time -- 
            ,offer_charge -- 
            ,insure_print -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsurereq_op(
            trans_date -- 
            ,serial_no -- 
            ,bank_no -- 
            ,asso_serial -- 
            ,ta_code -- 
            ,prd_code -- 
            ,insure_no -- 
            ,client_manager -- 
            ,client_no -- 
            ,client_type -- 
            ,trans_code -- 
            ,trans_name -- 
            ,bank_acc -- 
            ,acc_name -- 
            ,voucher_type -- 
            ,voucher_no -- 
            ,voucher_pwd -- 
            ,voucher_date -- 
            ,voucher_note -- 
            ,curr_type -- 
            ,clear_status -- 
            ,check_status -- 
            ,liqu_status -- 
            ,amt -- 
            ,charge -- 
            ,internal_branch -- 
            ,branch_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,term -- 
            ,channel -- 
            ,err_code -- 
            ,err_msg -- 
            ,insure_date -- 
            ,insure_cfm_no -- 
            ,insure_trans_code -- 
            ,targ_err_code -- 
            ,targ_err_msg -- 
            ,host_date -- 
            ,host_serial -- 
            ,host_trans_code -- 
            ,host_err_code -- 
            ,host_err_msg -- 
            ,status -- 
            ,trans_time -- 
            ,offer_charge -- 
            ,insure_print -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.asso_serial, o.asso_serial) as asso_serial -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.insure_no, o.insure_no) as insure_no -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.trans_code, o.trans_code) as trans_code -- 
    ,nvl(n.trans_name, o.trans_name) as trans_name -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.acc_name, o.acc_name) as acc_name -- 
    ,nvl(n.voucher_type, o.voucher_type) as voucher_type -- 
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 
    ,nvl(n.voucher_pwd, o.voucher_pwd) as voucher_pwd -- 
    ,nvl(n.voucher_date, o.voucher_date) as voucher_date -- 
    ,nvl(n.voucher_note, o.voucher_note) as voucher_note -- 
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 
    ,nvl(n.clear_status, o.clear_status) as clear_status -- 
    ,nvl(n.check_status, o.check_status) as check_status -- 
    ,nvl(n.liqu_status, o.liqu_status) as liqu_status -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.charge, o.charge) as charge -- 
    ,nvl(n.internal_branch, o.internal_branch) as internal_branch -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 
    ,nvl(n.auth_oper, o.auth_oper) as auth_oper -- 
    ,nvl(n.term, o.term) as term -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.err_code, o.err_code) as err_code -- 
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 
    ,nvl(n.insure_date, o.insure_date) as insure_date -- 
    ,nvl(n.insure_cfm_no, o.insure_cfm_no) as insure_cfm_no -- 
    ,nvl(n.insure_trans_code, o.insure_trans_code) as insure_trans_code -- 
    ,nvl(n.targ_err_code, o.targ_err_code) as targ_err_code -- 
    ,nvl(n.targ_err_msg, o.targ_err_msg) as targ_err_msg -- 
    ,nvl(n.host_date, o.host_date) as host_date -- 
    ,nvl(n.host_serial, o.host_serial) as host_serial -- 
    ,nvl(n.host_trans_code, o.host_trans_code) as host_trans_code -- 
    ,nvl(n.host_err_code, o.host_err_code) as host_err_code -- 
    ,nvl(n.host_err_msg, o.host_err_msg) as host_err_msg -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 
    ,nvl(n.offer_charge, o.offer_charge) as offer_charge -- 
    ,nvl(n.insure_print, o.insure_print) as insure_print -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.amt2, o.amt2) as amt2 -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when
            n.trans_date is null
            and n.serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trans_date is null
            and n.serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trans_date is null
            and n.serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbinsurereq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbinsurereq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trans_date = n.trans_date
            and o.serial_no = n.serial_no
where (
        o.trans_date is null
        and o.serial_no is null
    )
    or (
        n.trans_date is null
        and n.serial_no is null
    )
    or (
        o.bank_no <> n.bank_no
        or o.asso_serial <> n.asso_serial
        or o.ta_code <> n.ta_code
        or o.prd_code <> n.prd_code
        or o.insure_no <> n.insure_no
        or o.client_manager <> n.client_manager
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.trans_code <> n.trans_code
        or o.trans_name <> n.trans_name
        or o.bank_acc <> n.bank_acc
        or o.acc_name <> n.acc_name
        or o.voucher_type <> n.voucher_type
        or o.voucher_no <> n.voucher_no
        or o.voucher_pwd <> n.voucher_pwd
        or o.voucher_date <> n.voucher_date
        or o.voucher_note <> n.voucher_note
        or o.curr_type <> n.curr_type
        or o.clear_status <> n.clear_status
        or o.check_status <> n.check_status
        or o.liqu_status <> n.liqu_status
        or o.amt <> n.amt
        or o.charge <> n.charge
        or o.internal_branch <> n.internal_branch
        or o.branch_no <> n.branch_no
        or o.oper_no <> n.oper_no
        or o.auth_oper <> n.auth_oper
        or o.term <> n.term
        or o.channel <> n.channel
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.insure_date <> n.insure_date
        or o.insure_cfm_no <> n.insure_cfm_no
        or o.insure_trans_code <> n.insure_trans_code
        or o.targ_err_code <> n.targ_err_code
        or o.targ_err_msg <> n.targ_err_msg
        or o.host_date <> n.host_date
        or o.host_serial <> n.host_serial
        or o.host_trans_code <> n.host_trans_code
        or o.host_err_code <> n.host_err_code
        or o.host_err_msg <> n.host_err_msg
        or o.status <> n.status
        or o.trans_time <> n.trans_time
        or o.offer_charge <> n.offer_charge
        or o.insure_print <> n.insure_print
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsurereq_cl(
            trans_date -- 
            ,serial_no -- 
            ,bank_no -- 
            ,asso_serial -- 
            ,ta_code -- 
            ,prd_code -- 
            ,insure_no -- 
            ,client_manager -- 
            ,client_no -- 
            ,client_type -- 
            ,trans_code -- 
            ,trans_name -- 
            ,bank_acc -- 
            ,acc_name -- 
            ,voucher_type -- 
            ,voucher_no -- 
            ,voucher_pwd -- 
            ,voucher_date -- 
            ,voucher_note -- 
            ,curr_type -- 
            ,clear_status -- 
            ,check_status -- 
            ,liqu_status -- 
            ,amt -- 
            ,charge -- 
            ,internal_branch -- 
            ,branch_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,term -- 
            ,channel -- 
            ,err_code -- 
            ,err_msg -- 
            ,insure_date -- 
            ,insure_cfm_no -- 
            ,insure_trans_code -- 
            ,targ_err_code -- 
            ,targ_err_msg -- 
            ,host_date -- 
            ,host_serial -- 
            ,host_trans_code -- 
            ,host_err_code -- 
            ,host_err_msg -- 
            ,status -- 
            ,trans_time -- 
            ,offer_charge -- 
            ,insure_print -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsurereq_op(
            trans_date -- 
            ,serial_no -- 
            ,bank_no -- 
            ,asso_serial -- 
            ,ta_code -- 
            ,prd_code -- 
            ,insure_no -- 
            ,client_manager -- 
            ,client_no -- 
            ,client_type -- 
            ,trans_code -- 
            ,trans_name -- 
            ,bank_acc -- 
            ,acc_name -- 
            ,voucher_type -- 
            ,voucher_no -- 
            ,voucher_pwd -- 
            ,voucher_date -- 
            ,voucher_note -- 
            ,curr_type -- 
            ,clear_status -- 
            ,check_status -- 
            ,liqu_status -- 
            ,amt -- 
            ,charge -- 
            ,internal_branch -- 
            ,branch_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,term -- 
            ,channel -- 
            ,err_code -- 
            ,err_msg -- 
            ,insure_date -- 
            ,insure_cfm_no -- 
            ,insure_trans_code -- 
            ,targ_err_code -- 
            ,targ_err_msg -- 
            ,host_date -- 
            ,host_serial -- 
            ,host_trans_code -- 
            ,host_err_code -- 
            ,host_err_msg -- 
            ,status -- 
            ,trans_time -- 
            ,offer_charge -- 
            ,insure_print -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trans_date -- 
    ,o.serial_no -- 
    ,o.bank_no -- 
    ,o.asso_serial -- 
    ,o.ta_code -- 
    ,o.prd_code -- 
    ,o.insure_no -- 
    ,o.client_manager -- 
    ,o.client_no -- 
    ,o.client_type -- 
    ,o.trans_code -- 
    ,o.trans_name -- 
    ,o.bank_acc -- 
    ,o.acc_name -- 
    ,o.voucher_type -- 
    ,o.voucher_no -- 
    ,o.voucher_pwd -- 
    ,o.voucher_date -- 
    ,o.voucher_note -- 
    ,o.curr_type -- 
    ,o.clear_status -- 
    ,o.check_status -- 
    ,o.liqu_status -- 
    ,o.amt -- 
    ,o.charge -- 
    ,o.internal_branch -- 
    ,o.branch_no -- 
    ,o.oper_no -- 
    ,o.auth_oper -- 
    ,o.term -- 
    ,o.channel -- 
    ,o.err_code -- 
    ,o.err_msg -- 
    ,o.insure_date -- 
    ,o.insure_cfm_no -- 
    ,o.insure_trans_code -- 
    ,o.targ_err_code -- 
    ,o.targ_err_msg -- 
    ,o.host_date -- 
    ,o.host_serial -- 
    ,o.host_trans_code -- 
    ,o.host_err_code -- 
    ,o.host_err_msg -- 
    ,o.status -- 
    ,o.trans_time -- 
    ,o.offer_charge -- 
    ,o.insure_print -- 
    ,o.amt1 -- 
    ,o.amt2 -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbinsurereq_bk o
    left join ${iol_schema}.ifms_tbinsurereq_op n
        on
            o.trans_date = n.trans_date
            and o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbinsurereq_cl d
        on
            o.trans_date = d.trans_date
            and o.serial_no = d.serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbinsurereq;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbinsurereq exchange partition p_19000101 with table ${iol_schema}.ifms_tbinsurereq_cl;
alter table ${iol_schema}.ifms_tbinsurereq exchange partition p_20991231 with table ${iol_schema}.ifms_tbinsurereq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbinsurereq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsurereq_op purge;
drop table ${iol_schema}.ifms_tbinsurereq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbinsurereq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbinsurereq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
