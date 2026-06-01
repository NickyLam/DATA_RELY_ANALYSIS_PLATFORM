/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbhisaccreq
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
create table ${iol_schema}.nfss_tbhisaccreq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbhisaccreq
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbhisaccreq_op purge;
drop table ${iol_schema}.nfss_tbhisaccreq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbhisaccreq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbhisaccreq where 0=1;

create table ${iol_schema}.nfss_tbhisaccreq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbhisaccreq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbhisaccreq_cl(
            serial_no -- 
            ,ex_serial -- 
            ,cfm_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,occur_init_date -- 
            ,cfm_date -- 
            ,trans_code -- 
            ,control_flag -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,in_client_no -- 
            ,client_type -- 
            ,id_type -- 
            ,id_code -- 
            ,client_name -- 
            ,short_name -- 
            ,asset_acc -- 
            ,base_acc -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,sex -- 
            ,birthday -- 
            ,address -- 
            ,post_code -- 
            ,mobile -- 
            ,tel -- 
            ,fax -- 
            ,email -- 
            ,send_mode -- 
            ,send_freq -- 
            ,asso_date -- 
            ,frozen_cause -- 
            ,summary -- 
            ,asso_serial -- 
            ,channel -- 
            ,term_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,client_manager -- 
            ,err_code -- 
            ,err_msg -- 
            ,status -- 
            ,deal_mode -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbhisaccreq_op(
            serial_no -- 
            ,ex_serial -- 
            ,cfm_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,occur_init_date -- 
            ,cfm_date -- 
            ,trans_code -- 
            ,control_flag -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,in_client_no -- 
            ,client_type -- 
            ,id_type -- 
            ,id_code -- 
            ,client_name -- 
            ,short_name -- 
            ,asset_acc -- 
            ,base_acc -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,sex -- 
            ,birthday -- 
            ,address -- 
            ,post_code -- 
            ,mobile -- 
            ,tel -- 
            ,fax -- 
            ,email -- 
            ,send_mode -- 
            ,send_freq -- 
            ,asso_date -- 
            ,frozen_cause -- 
            ,summary -- 
            ,asso_serial -- 
            ,channel -- 
            ,term_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,client_manager -- 
            ,err_code -- 
            ,err_msg -- 
            ,status -- 
            ,deal_mode -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.ex_serial, o.ex_serial) as ex_serial -- 
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 
    ,nvl(n.occur_init_date, o.occur_init_date) as occur_init_date -- 
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 
    ,nvl(n.trans_code, o.trans_code) as trans_code -- 
    ,nvl(n.control_flag, o.control_flag) as control_flag -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.id_type, o.id_type) as id_type -- 
    ,nvl(n.id_code, o.id_code) as id_code -- 
    ,nvl(n.client_name, o.client_name) as client_name -- 
    ,nvl(n.short_name, o.short_name) as short_name -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.base_acc, o.base_acc) as base_acc -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.trans_account_type, o.trans_account_type) as trans_account_type -- 
    ,nvl(n.trans_account, o.trans_account) as trans_account -- 
    ,nvl(n.sex, o.sex) as sex -- 
    ,nvl(n.birthday, o.birthday) as birthday -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.post_code, o.post_code) as post_code -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.tel, o.tel) as tel -- 
    ,nvl(n.fax, o.fax) as fax -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.send_mode, o.send_mode) as send_mode -- 
    ,nvl(n.send_freq, o.send_freq) as send_freq -- 
    ,nvl(n.asso_date, o.asso_date) as asso_date -- 
    ,nvl(n.frozen_cause, o.frozen_cause) as frozen_cause -- 
    ,nvl(n.summary, o.summary) as summary -- 
    ,nvl(n.asso_serial, o.asso_serial) as asso_serial -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.term_no, o.term_no) as term_no -- 
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 
    ,nvl(n.auth_oper, o.auth_oper) as auth_oper -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.err_code, o.err_code) as err_code -- 
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.deal_mode, o.deal_mode) as deal_mode -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,case when
            n.serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbhisaccreq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbhisaccreq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_no = n.serial_no
where (
        o.serial_no is null
    )
    or (
        n.serial_no is null
    )
    or (
        o.ex_serial <> n.ex_serial
        or o.cfm_no <> n.cfm_no
        or o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.occur_init_date <> n.occur_init_date
        or o.cfm_date <> n.cfm_date
        or o.trans_code <> n.trans_code
        or o.control_flag <> n.control_flag
        or o.branch_no <> n.branch_no
        or o.open_branch <> n.open_branch
        or o.ta_code <> n.ta_code
        or o.in_client_no <> n.in_client_no
        or o.client_type <> n.client_type
        or o.id_type <> n.id_type
        or o.id_code <> n.id_code
        or o.client_name <> n.client_name
        or o.short_name <> n.short_name
        or o.asset_acc <> n.asset_acc
        or o.base_acc <> n.base_acc
        or o.seller_code <> n.seller_code
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.trans_account_type <> n.trans_account_type
        or o.trans_account <> n.trans_account
        or o.sex <> n.sex
        or o.birthday <> n.birthday
        or o.address <> n.address
        or o.post_code <> n.post_code
        or o.mobile <> n.mobile
        or o.tel <> n.tel
        or o.fax <> n.fax
        or o.email <> n.email
        or o.send_mode <> n.send_mode
        or o.send_freq <> n.send_freq
        or o.asso_date <> n.asso_date
        or o.frozen_cause <> n.frozen_cause
        or o.summary <> n.summary
        or o.asso_serial <> n.asso_serial
        or o.channel <> n.channel
        or o.term_no <> n.term_no
        or o.oper_no <> n.oper_no
        or o.auth_oper <> n.auth_oper
        or o.client_manager <> n.client_manager
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.status <> n.status
        or o.deal_mode <> n.deal_mode
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbhisaccreq_cl(
            serial_no -- 
            ,ex_serial -- 
            ,cfm_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,occur_init_date -- 
            ,cfm_date -- 
            ,trans_code -- 
            ,control_flag -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,in_client_no -- 
            ,client_type -- 
            ,id_type -- 
            ,id_code -- 
            ,client_name -- 
            ,short_name -- 
            ,asset_acc -- 
            ,base_acc -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,sex -- 
            ,birthday -- 
            ,address -- 
            ,post_code -- 
            ,mobile -- 
            ,tel -- 
            ,fax -- 
            ,email -- 
            ,send_mode -- 
            ,send_freq -- 
            ,asso_date -- 
            ,frozen_cause -- 
            ,summary -- 
            ,asso_serial -- 
            ,channel -- 
            ,term_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,client_manager -- 
            ,err_code -- 
            ,err_msg -- 
            ,status -- 
            ,deal_mode -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbhisaccreq_op(
            serial_no -- 
            ,ex_serial -- 
            ,cfm_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,occur_init_date -- 
            ,cfm_date -- 
            ,trans_code -- 
            ,control_flag -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,in_client_no -- 
            ,client_type -- 
            ,id_type -- 
            ,id_code -- 
            ,client_name -- 
            ,short_name -- 
            ,asset_acc -- 
            ,base_acc -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,sex -- 
            ,birthday -- 
            ,address -- 
            ,post_code -- 
            ,mobile -- 
            ,tel -- 
            ,fax -- 
            ,email -- 
            ,send_mode -- 
            ,send_freq -- 
            ,asso_date -- 
            ,frozen_cause -- 
            ,summary -- 
            ,asso_serial -- 
            ,channel -- 
            ,term_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,client_manager -- 
            ,err_code -- 
            ,err_msg -- 
            ,status -- 
            ,deal_mode -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serial_no -- 
    ,o.ex_serial -- 
    ,o.cfm_no -- 
    ,o.trans_date -- 
    ,o.trans_time -- 
    ,o.occur_init_date -- 
    ,o.cfm_date -- 
    ,o.trans_code -- 
    ,o.control_flag -- 
    ,o.branch_no -- 
    ,o.open_branch -- 
    ,o.ta_code -- 
    ,o.in_client_no -- 
    ,o.client_type -- 
    ,o.id_type -- 
    ,o.id_code -- 
    ,o.client_name -- 
    ,o.short_name -- 
    ,o.asset_acc -- 
    ,o.base_acc -- 
    ,o.seller_code -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.bank_acc -- 
    ,o.trans_account_type -- 
    ,o.trans_account -- 
    ,o.sex -- 
    ,o.birthday -- 
    ,o.address -- 
    ,o.post_code -- 
    ,o.mobile -- 
    ,o.tel -- 
    ,o.fax -- 
    ,o.email -- 
    ,o.send_mode -- 
    ,o.send_freq -- 
    ,o.asso_date -- 
    ,o.frozen_cause -- 
    ,o.summary -- 
    ,o.asso_serial -- 
    ,o.channel -- 
    ,o.term_no -- 
    ,o.oper_no -- 
    ,o.auth_oper -- 
    ,o.client_manager -- 
    ,o.err_code -- 
    ,o.err_msg -- 
    ,o.status -- 
    ,o.deal_mode -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
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
from ${iol_schema}.nfss_tbhisaccreq_bk o
    left join ${iol_schema}.nfss_tbhisaccreq_op n
        on
            o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbhisaccreq_cl d
        on
            o.serial_no = d.serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_tbhisaccreq;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_tbhisaccreq') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_tbhisaccreq drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_tbhisaccreq add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_tbhisaccreq exchange partition p_${batch_date} with table ${iol_schema}.nfss_tbhisaccreq_cl;
alter table ${iol_schema}.nfss_tbhisaccreq exchange partition p_20991231 with table ${iol_schema}.nfss_tbhisaccreq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbhisaccreq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbhisaccreq_op purge;
drop table ${iol_schema}.nfss_tbhisaccreq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbhisaccreq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbhisaccreq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
