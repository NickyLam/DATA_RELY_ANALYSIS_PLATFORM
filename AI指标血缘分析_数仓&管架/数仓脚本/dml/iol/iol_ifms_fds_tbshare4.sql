/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_fds_tbshare4
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
create table ${iol_schema}.ifms_fds_tbshare4_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_fds_tbshare4;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbshare4_op purge;
drop table ${iol_schema}.ifms_fds_tbshare4_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbshare4_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbshare4 where 0=1;

create table ${iol_schema}.ifms_fds_tbshare4_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbshare4 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbshare4_cl(
            in_client_no -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,ta_client -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,contract_no -- 
            ,last_date -- 
            ,tot_vol -- 
            ,frozen_vol -- 
            ,long_frozen_vol -- 
            ,group_vol -- 
            ,div_mode -- 
            ,old_div_mode -- 
            ,div_rate -- 
            ,ystdy_tot_vol -- 
            ,open_branch -- 
            ,client_type -- 
            ,append_flag -- 
            ,other_frozen -- 
            ,income -- 
            ,income_rate -- 
            ,cost -- 
            ,tot_income -- 
            ,income_onway -- 
            ,income_frozen -- 
            ,income_new -- 
            ,manage_agio -- 
            ,tot_manage_fee -- 
            ,manage_fee -- 
            ,manage_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,real_prd_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbshare4_op(
            in_client_no -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,ta_client -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,contract_no -- 
            ,last_date -- 
            ,tot_vol -- 
            ,frozen_vol -- 
            ,long_frozen_vol -- 
            ,group_vol -- 
            ,div_mode -- 
            ,old_div_mode -- 
            ,div_rate -- 
            ,ystdy_tot_vol -- 
            ,open_branch -- 
            ,client_type -- 
            ,append_flag -- 
            ,other_frozen -- 
            ,income -- 
            ,income_rate -- 
            ,cost -- 
            ,tot_income -- 
            ,income_onway -- 
            ,income_frozen -- 
            ,income_new -- 
            ,manage_agio -- 
            ,tot_manage_fee -- 
            ,manage_fee -- 
            ,manage_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,real_prd_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 
    ,nvl(n.trans_account_type, o.trans_account_type) as trans_account_type -- 
    ,nvl(n.trans_account, o.trans_account) as trans_account -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 
    ,nvl(n.last_date, o.last_date) as last_date -- 
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 
    ,nvl(n.frozen_vol, o.frozen_vol) as frozen_vol -- 
    ,nvl(n.long_frozen_vol, o.long_frozen_vol) as long_frozen_vol -- 
    ,nvl(n.group_vol, o.group_vol) as group_vol -- 
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 
    ,nvl(n.old_div_mode, o.old_div_mode) as old_div_mode -- 
    ,nvl(n.div_rate, o.div_rate) as div_rate -- 
    ,nvl(n.ystdy_tot_vol, o.ystdy_tot_vol) as ystdy_tot_vol -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.append_flag, o.append_flag) as append_flag -- 
    ,nvl(n.other_frozen, o.other_frozen) as other_frozen -- 
    ,nvl(n.income, o.income) as income -- 
    ,nvl(n.income_rate, o.income_rate) as income_rate -- 
    ,nvl(n.cost, o.cost) as cost -- 
    ,nvl(n.tot_income, o.tot_income) as tot_income -- 
    ,nvl(n.income_onway, o.income_onway) as income_onway -- 
    ,nvl(n.income_frozen, o.income_frozen) as income_frozen -- 
    ,nvl(n.income_new, o.income_new) as income_new -- 
    ,nvl(n.manage_agio, o.manage_agio) as manage_agio -- 
    ,nvl(n.tot_manage_fee, o.tot_manage_fee) as tot_manage_fee -- 
    ,nvl(n.manage_fee, o.manage_fee) as manage_fee -- 
    ,nvl(n.manage_date, o.manage_date) as manage_date -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 
    ,nvl(n.real_prd_code, o.real_prd_code) as real_prd_code -- 
    ,case when
            n.in_client_no is null
            and n.seller_code is null
            and n.bank_no is null
            and n.ta_client is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
            and n.seller_code is null
            and n.bank_no is null
            and n.ta_client is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
            and n.seller_code is null
            and n.bank_no is null
            and n.ta_client is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_fds_tbshare4_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_fds_tbshare4 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
            and o.seller_code = n.seller_code
            and o.bank_no = n.bank_no
            and o.ta_client = n.ta_client
            and o.prd_code = n.prd_code
where (
        o.in_client_no is null
        and o.seller_code is null
        and o.bank_no is null
        and o.ta_client is null
        and o.prd_code is null
    )
    or (
        n.in_client_no is null
        and n.seller_code is null
        and n.bank_no is null
        and n.ta_client is null
        and n.prd_code is null
    )
    or (
        o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.cash_flag <> n.cash_flag
        or o.trans_account_type <> n.trans_account_type
        or o.trans_account <> n.trans_account
        or o.ta_code <> n.ta_code
        or o.asset_acc <> n.asset_acc
        or o.contract_no <> n.contract_no
        or o.last_date <> n.last_date
        or o.tot_vol <> n.tot_vol
        or o.frozen_vol <> n.frozen_vol
        or o.long_frozen_vol <> n.long_frozen_vol
        or o.group_vol <> n.group_vol
        or o.div_mode <> n.div_mode
        or o.old_div_mode <> n.old_div_mode
        or o.div_rate <> n.div_rate
        or o.ystdy_tot_vol <> n.ystdy_tot_vol
        or o.open_branch <> n.open_branch
        or o.client_type <> n.client_type
        or o.append_flag <> n.append_flag
        or o.other_frozen <> n.other_frozen
        or o.income <> n.income
        or o.income_rate <> n.income_rate
        or o.cost <> n.cost
        or o.tot_income <> n.tot_income
        or o.income_onway <> n.income_onway
        or o.income_frozen <> n.income_frozen
        or o.income_new <> n.income_new
        or o.manage_agio <> n.manage_agio
        or o.tot_manage_fee <> n.tot_manage_fee
        or o.manage_fee <> n.manage_fee
        or o.manage_date <> n.manage_date
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.real_prd_code <> n.real_prd_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbshare4_cl(
            in_client_no -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,ta_client -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,contract_no -- 
            ,last_date -- 
            ,tot_vol -- 
            ,frozen_vol -- 
            ,long_frozen_vol -- 
            ,group_vol -- 
            ,div_mode -- 
            ,old_div_mode -- 
            ,div_rate -- 
            ,ystdy_tot_vol -- 
            ,open_branch -- 
            ,client_type -- 
            ,append_flag -- 
            ,other_frozen -- 
            ,income -- 
            ,income_rate -- 
            ,cost -- 
            ,tot_income -- 
            ,income_onway -- 
            ,income_frozen -- 
            ,income_new -- 
            ,manage_agio -- 
            ,tot_manage_fee -- 
            ,manage_fee -- 
            ,manage_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,real_prd_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbshare4_op(
            in_client_no -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,ta_client -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,contract_no -- 
            ,last_date -- 
            ,tot_vol -- 
            ,frozen_vol -- 
            ,long_frozen_vol -- 
            ,group_vol -- 
            ,div_mode -- 
            ,old_div_mode -- 
            ,div_rate -- 
            ,ystdy_tot_vol -- 
            ,open_branch -- 
            ,client_type -- 
            ,append_flag -- 
            ,other_frozen -- 
            ,income -- 
            ,income_rate -- 
            ,cost -- 
            ,tot_income -- 
            ,income_onway -- 
            ,income_frozen -- 
            ,income_new -- 
            ,manage_agio -- 
            ,tot_manage_fee -- 
            ,manage_fee -- 
            ,manage_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,real_prd_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 
    ,o.seller_code -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.bank_acc -- 
    ,o.ta_client -- 
    ,o.cash_flag -- 
    ,o.trans_account_type -- 
    ,o.trans_account -- 
    ,o.ta_code -- 
    ,o.asset_acc -- 
    ,o.prd_code -- 
    ,o.contract_no -- 
    ,o.last_date -- 
    ,o.tot_vol -- 
    ,o.frozen_vol -- 
    ,o.long_frozen_vol -- 
    ,o.group_vol -- 
    ,o.div_mode -- 
    ,o.old_div_mode -- 
    ,o.div_rate -- 
    ,o.ystdy_tot_vol -- 
    ,o.open_branch -- 
    ,o.client_type -- 
    ,o.append_flag -- 
    ,o.other_frozen -- 
    ,o.income -- 
    ,o.income_rate -- 
    ,o.cost -- 
    ,o.tot_income -- 
    ,o.income_onway -- 
    ,o.income_frozen -- 
    ,o.income_new -- 
    ,o.manage_agio -- 
    ,o.tot_manage_fee -- 
    ,o.manage_fee -- 
    ,o.manage_date -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.reserve5 -- 
    ,o.real_prd_code -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_fds_tbshare4_bk o
    left join ${iol_schema}.ifms_fds_tbshare4_op n
        on
            o.in_client_no = n.in_client_no
            and o.seller_code = n.seller_code
            and o.bank_no = n.bank_no
            and o.ta_client = n.ta_client
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_fds_tbshare4_cl d
        on
            o.in_client_no = d.in_client_no
            and o.seller_code = d.seller_code
            and o.bank_no = d.bank_no
            and o.ta_client = d.ta_client
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_fds_tbshare4;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_fds_tbshare4 exchange partition p_19000101 with table ${iol_schema}.ifms_fds_tbshare4_cl;
alter table ${iol_schema}.ifms_fds_tbshare4 exchange partition p_20991231 with table ${iol_schema}.ifms_fds_tbshare4_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_fds_tbshare4 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbshare4_op purge;
drop table ${iol_schema}.ifms_fds_tbshare4_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_fds_tbshare4_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_fds_tbshare4',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
