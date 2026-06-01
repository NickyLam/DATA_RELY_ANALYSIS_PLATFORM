/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbhissquare
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
create table ${iol_schema}.ifms_tbhissquare_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbhissquare
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbhissquare_op purge;
drop table ${iol_schema}.ifms_tbhissquare_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhissquare_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbhissquare where 0=1;

create table ${iol_schema}.ifms_tbhissquare_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbhissquare where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbhissquare_cl(
            square_no -- 
            ,seq_no -- 
            ,trans_date -- 
            ,clear_date -- 
            ,square_date -- 
            ,old_square_date -- 
            ,serial_no -- 
            ,asso_serial -- 
            ,from_flag -- 
            ,trans_code -- 
            ,busin_code -- 
            ,client_type -- 
            ,in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,bank_acc_kind -- 
            ,channel -- 
            ,oper_no -- 
            ,term_no -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,prd_code -- 
            ,liqu_dir -- 
            ,amt -- 
            ,curr_type -- 
            ,cash_flag -- 
            ,unfrozen_amt -- 
            ,host_trans_code -- 
            ,host_date -- 
            ,host_serial -- 
            ,frozen_amt -- 
            ,check_status -- 
            ,distrib_flag -- 
            ,amt_flag -- 
            ,cost_income_flag -- 
            ,cfm_vol -- 
            ,cost -- 
            ,cfm_income -- 
            ,vol_cumulate -- 
            ,prd_account -- 
            ,prd_account_kind -- 
            ,summary -- 
            ,status -- 
            ,old_square_no -- 
            ,err_code -- 
            ,err_msg -- 
            ,deal_status -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbhissquare_op(
            square_no -- 
            ,seq_no -- 
            ,trans_date -- 
            ,clear_date -- 
            ,square_date -- 
            ,old_square_date -- 
            ,serial_no -- 
            ,asso_serial -- 
            ,from_flag -- 
            ,trans_code -- 
            ,busin_code -- 
            ,client_type -- 
            ,in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,bank_acc_kind -- 
            ,channel -- 
            ,oper_no -- 
            ,term_no -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,prd_code -- 
            ,liqu_dir -- 
            ,amt -- 
            ,curr_type -- 
            ,cash_flag -- 
            ,unfrozen_amt -- 
            ,host_trans_code -- 
            ,host_date -- 
            ,host_serial -- 
            ,frozen_amt -- 
            ,check_status -- 
            ,distrib_flag -- 
            ,amt_flag -- 
            ,cost_income_flag -- 
            ,cfm_vol -- 
            ,cost -- 
            ,cfm_income -- 
            ,vol_cumulate -- 
            ,prd_account -- 
            ,prd_account_kind -- 
            ,summary -- 
            ,status -- 
            ,old_square_no -- 
            ,err_code -- 
            ,err_msg -- 
            ,deal_status -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.square_no, o.square_no) as square_no -- 
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.clear_date, o.clear_date) as clear_date -- 
    ,nvl(n.square_date, o.square_date) as square_date -- 
    ,nvl(n.old_square_date, o.old_square_date) as old_square_date -- 
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.asso_serial, o.asso_serial) as asso_serial -- 
    ,nvl(n.from_flag, o.from_flag) as from_flag -- 
    ,nvl(n.trans_code, o.trans_code) as trans_code -- 
    ,nvl(n.busin_code, o.busin_code) as busin_code -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.bank_acc_kind, o.bank_acc_kind) as bank_acc_kind -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 
    ,nvl(n.term_no, o.term_no) as term_no -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.liqu_dir, o.liqu_dir) as liqu_dir -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 
    ,nvl(n.unfrozen_amt, o.unfrozen_amt) as unfrozen_amt -- 
    ,nvl(n.host_trans_code, o.host_trans_code) as host_trans_code -- 
    ,nvl(n.host_date, o.host_date) as host_date -- 
    ,nvl(n.host_serial, o.host_serial) as host_serial -- 
    ,nvl(n.frozen_amt, o.frozen_amt) as frozen_amt -- 
    ,nvl(n.check_status, o.check_status) as check_status -- 
    ,nvl(n.distrib_flag, o.distrib_flag) as distrib_flag -- 
    ,nvl(n.amt_flag, o.amt_flag) as amt_flag -- 
    ,nvl(n.cost_income_flag, o.cost_income_flag) as cost_income_flag -- 
    ,nvl(n.cfm_vol, o.cfm_vol) as cfm_vol -- 
    ,nvl(n.cost, o.cost) as cost -- 
    ,nvl(n.cfm_income, o.cfm_income) as cfm_income -- 
    ,nvl(n.vol_cumulate, o.vol_cumulate) as vol_cumulate -- 
    ,nvl(n.prd_account, o.prd_account) as prd_account -- 
    ,nvl(n.prd_account_kind, o.prd_account_kind) as prd_account_kind -- 
    ,nvl(n.summary, o.summary) as summary -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.old_square_no, o.old_square_no) as old_square_no -- 
    ,nvl(n.err_code, o.err_code) as err_code -- 
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.amt2, o.amt2) as amt2 -- 
    ,nvl(n.amt3, o.amt3) as amt3 -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 
    ,case when
            n.square_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.square_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.square_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbhissquare_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbhissquare where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.square_no = n.square_no
where (
        o.square_no is null
    )
    or (
        n.square_no is null
    )
    or (
        o.seq_no <> n.seq_no
        or o.trans_date <> n.trans_date
        or o.clear_date <> n.clear_date
        or o.square_date <> n.square_date
        or o.old_square_date <> n.old_square_date
        or o.serial_no <> n.serial_no
        or o.asso_serial <> n.asso_serial
        or o.from_flag <> n.from_flag
        or o.trans_code <> n.trans_code
        or o.busin_code <> n.busin_code
        or o.client_type <> n.client_type
        or o.in_client_no <> n.in_client_no
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.bank_acc_kind <> n.bank_acc_kind
        or o.channel <> n.channel
        or o.oper_no <> n.oper_no
        or o.term_no <> n.term_no
        or o.branch_no <> n.branch_no
        or o.open_branch <> n.open_branch
        or o.ta_code <> n.ta_code
        or o.prd_code <> n.prd_code
        or o.liqu_dir <> n.liqu_dir
        or o.amt <> n.amt
        or o.curr_type <> n.curr_type
        or o.cash_flag <> n.cash_flag
        or o.unfrozen_amt <> n.unfrozen_amt
        or o.host_trans_code <> n.host_trans_code
        or o.host_date <> n.host_date
        or o.host_serial <> n.host_serial
        or o.frozen_amt <> n.frozen_amt
        or o.check_status <> n.check_status
        or o.distrib_flag <> n.distrib_flag
        or o.amt_flag <> n.amt_flag
        or o.cost_income_flag <> n.cost_income_flag
        or o.cfm_vol <> n.cfm_vol
        or o.cost <> n.cost
        or o.cfm_income <> n.cfm_income
        or o.vol_cumulate <> n.vol_cumulate
        or o.prd_account <> n.prd_account
        or o.prd_account_kind <> n.prd_account_kind
        or o.summary <> n.summary
        or o.status <> n.status
        or o.old_square_no <> n.old_square_no
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.deal_status <> n.deal_status
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbhissquare_cl(
            square_no -- 
            ,seq_no -- 
            ,trans_date -- 
            ,clear_date -- 
            ,square_date -- 
            ,old_square_date -- 
            ,serial_no -- 
            ,asso_serial -- 
            ,from_flag -- 
            ,trans_code -- 
            ,busin_code -- 
            ,client_type -- 
            ,in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,bank_acc_kind -- 
            ,channel -- 
            ,oper_no -- 
            ,term_no -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,prd_code -- 
            ,liqu_dir -- 
            ,amt -- 
            ,curr_type -- 
            ,cash_flag -- 
            ,unfrozen_amt -- 
            ,host_trans_code -- 
            ,host_date -- 
            ,host_serial -- 
            ,frozen_amt -- 
            ,check_status -- 
            ,distrib_flag -- 
            ,amt_flag -- 
            ,cost_income_flag -- 
            ,cfm_vol -- 
            ,cost -- 
            ,cfm_income -- 
            ,vol_cumulate -- 
            ,prd_account -- 
            ,prd_account_kind -- 
            ,summary -- 
            ,status -- 
            ,old_square_no -- 
            ,err_code -- 
            ,err_msg -- 
            ,deal_status -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbhissquare_op(
            square_no -- 
            ,seq_no -- 
            ,trans_date -- 
            ,clear_date -- 
            ,square_date -- 
            ,old_square_date -- 
            ,serial_no -- 
            ,asso_serial -- 
            ,from_flag -- 
            ,trans_code -- 
            ,busin_code -- 
            ,client_type -- 
            ,in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,bank_acc_kind -- 
            ,channel -- 
            ,oper_no -- 
            ,term_no -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,prd_code -- 
            ,liqu_dir -- 
            ,amt -- 
            ,curr_type -- 
            ,cash_flag -- 
            ,unfrozen_amt -- 
            ,host_trans_code -- 
            ,host_date -- 
            ,host_serial -- 
            ,frozen_amt -- 
            ,check_status -- 
            ,distrib_flag -- 
            ,amt_flag -- 
            ,cost_income_flag -- 
            ,cfm_vol -- 
            ,cost -- 
            ,cfm_income -- 
            ,vol_cumulate -- 
            ,prd_account -- 
            ,prd_account_kind -- 
            ,summary -- 
            ,status -- 
            ,old_square_no -- 
            ,err_code -- 
            ,err_msg -- 
            ,deal_status -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.square_no -- 
    ,o.seq_no -- 
    ,o.trans_date -- 
    ,o.clear_date -- 
    ,o.square_date -- 
    ,o.old_square_date -- 
    ,o.serial_no -- 
    ,o.asso_serial -- 
    ,o.from_flag -- 
    ,o.trans_code -- 
    ,o.busin_code -- 
    ,o.client_type -- 
    ,o.in_client_no -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.bank_acc -- 
    ,o.bank_acc_kind -- 
    ,o.channel -- 
    ,o.oper_no -- 
    ,o.term_no -- 
    ,o.branch_no -- 
    ,o.open_branch -- 
    ,o.ta_code -- 
    ,o.prd_code -- 
    ,o.liqu_dir -- 
    ,o.amt -- 
    ,o.curr_type -- 
    ,o.cash_flag -- 
    ,o.unfrozen_amt -- 
    ,o.host_trans_code -- 
    ,o.host_date -- 
    ,o.host_serial -- 
    ,o.frozen_amt -- 
    ,o.check_status -- 
    ,o.distrib_flag -- 
    ,o.amt_flag -- 
    ,o.cost_income_flag -- 
    ,o.cfm_vol -- 
    ,o.cost -- 
    ,o.cfm_income -- 
    ,o.vol_cumulate -- 
    ,o.prd_account -- 
    ,o.prd_account_kind -- 
    ,o.summary -- 
    ,o.status -- 
    ,o.old_square_no -- 
    ,o.err_code -- 
    ,o.err_msg -- 
    ,o.deal_status -- 
    ,o.amt1 -- 
    ,o.amt2 -- 
    ,o.amt3 -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.reserve5 -- 
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
from ${iol_schema}.ifms_tbhissquare_bk o
    left join ${iol_schema}.ifms_tbhissquare_op n
        on
            o.square_no = n.square_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbhissquare_cl d
        on
            o.square_no = d.square_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbhissquare;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbhissquare') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbhissquare drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbhissquare add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbhissquare exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbhissquare_cl;
alter table ${iol_schema}.ifms_tbhissquare exchange partition p_20991231 with table ${iol_schema}.ifms_tbhissquare_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbhissquare to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbhissquare_op purge;
drop table ${iol_schema}.ifms_tbhissquare_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbhissquare_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbhissquare',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
