/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_fds_tbtatranscfm
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
create table ${iol_schema}.ifms_fds_tbtatranscfm_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_fds_tbtatranscfm;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbtatranscfm_op purge;
drop table ${iol_schema}.ifms_fds_tbtatranscfm_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbtatranscfm_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbtatranscfm where 0=1;

create table ${iol_schema}.ifms_fds_tbtatranscfm_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbtatranscfm where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbtatranscfm_cl(
            busin_code -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,trans_date -- 
            ,serial_no -- 
            ,seller_code -- 
            ,branch_no -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,tot_cfm_amt -- 
            ,tot_cfm_vol -- 
            ,no_cfm_amt -- 
            ,no_cfm_vol -- 
            ,trade_fee -- 
            ,ori_fee -- 
            ,transfer_fee -- 
            ,stamp_tax -- 
            ,back_fee -- 
            ,other_fee1 -- 
            ,interest -- 
            ,interest_tax -- 
            ,interest_share -- 
            ,ori_trade_fee -- 
            ,total_fee -- 
            ,commision -- 
            ,regist_fee -- 
            ,asset_fee -- 
            ,manage_fee -- 
            ,ori_transfer_fee -- 
            ,ori_back_fee -- 
            ,ori_other_fee1 -- 
            ,nav -- 
            ,frozen_amt -- 
            ,unfrozen_amt -- 
            ,status -- 
            ,ta_flag -- 
            ,client_type -- 
            ,in_client_no -- 
            ,gain_income -- 
            ,end_flag -- 
            ,client_income -- 
            ,branch_income -- 
            ,ch_vol -- 
            ,cfm_income -- 
            ,amt -- 
            ,vol -- 
            ,agio -- 
            ,last_vol -- 
            ,last_frozen_vol -- 
            ,targ_prd_code -- 
            ,targ_share_class -- 
            ,targ_asset_acc -- 
            ,targ_seller_code -- 
            ,targ_net_no -- 
            ,div_mode -- 
            ,ori_serial_no -- 
            ,larg_red_flag -- 
            ,frozen_cause -- 
            ,frozen_end_date -- 
            ,out_busin_code -- 
            ,channel -- 
            ,ori_agio -- 
            ,cis_date -- 
            ,back_agio -- 
            ,bank_no -- 
            ,real_flag -- 
            ,err_code -- 
            ,err_msg -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,real_prd_code -- 
            ,targ_real_prd_code -- 
            ,client_manager -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbtatranscfm_op(
            busin_code -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,trans_date -- 
            ,serial_no -- 
            ,seller_code -- 
            ,branch_no -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,tot_cfm_amt -- 
            ,tot_cfm_vol -- 
            ,no_cfm_amt -- 
            ,no_cfm_vol -- 
            ,trade_fee -- 
            ,ori_fee -- 
            ,transfer_fee -- 
            ,stamp_tax -- 
            ,back_fee -- 
            ,other_fee1 -- 
            ,interest -- 
            ,interest_tax -- 
            ,interest_share -- 
            ,ori_trade_fee -- 
            ,total_fee -- 
            ,commision -- 
            ,regist_fee -- 
            ,asset_fee -- 
            ,manage_fee -- 
            ,ori_transfer_fee -- 
            ,ori_back_fee -- 
            ,ori_other_fee1 -- 
            ,nav -- 
            ,frozen_amt -- 
            ,unfrozen_amt -- 
            ,status -- 
            ,ta_flag -- 
            ,client_type -- 
            ,in_client_no -- 
            ,gain_income -- 
            ,end_flag -- 
            ,client_income -- 
            ,branch_income -- 
            ,ch_vol -- 
            ,cfm_income -- 
            ,amt -- 
            ,vol -- 
            ,agio -- 
            ,last_vol -- 
            ,last_frozen_vol -- 
            ,targ_prd_code -- 
            ,targ_share_class -- 
            ,targ_asset_acc -- 
            ,targ_seller_code -- 
            ,targ_net_no -- 
            ,div_mode -- 
            ,ori_serial_no -- 
            ,larg_red_flag -- 
            ,frozen_cause -- 
            ,frozen_end_date -- 
            ,out_busin_code -- 
            ,channel -- 
            ,ori_agio -- 
            ,cis_date -- 
            ,back_agio -- 
            ,bank_no -- 
            ,real_flag -- 
            ,err_code -- 
            ,err_msg -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,real_prd_code -- 
            ,targ_real_prd_code -- 
            ,client_manager -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.busin_code, o.busin_code) as busin_code -- 
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.share_class, o.share_class) as share_class -- 
    ,nvl(n.cfm_amt, o.cfm_amt) as cfm_amt -- 
    ,nvl(n.cfm_vol, o.cfm_vol) as cfm_vol -- 
    ,nvl(n.tot_cfm_amt, o.tot_cfm_amt) as tot_cfm_amt -- 
    ,nvl(n.tot_cfm_vol, o.tot_cfm_vol) as tot_cfm_vol -- 
    ,nvl(n.no_cfm_amt, o.no_cfm_amt) as no_cfm_amt -- 
    ,nvl(n.no_cfm_vol, o.no_cfm_vol) as no_cfm_vol -- 
    ,nvl(n.trade_fee, o.trade_fee) as trade_fee -- 
    ,nvl(n.ori_fee, o.ori_fee) as ori_fee -- 
    ,nvl(n.transfer_fee, o.transfer_fee) as transfer_fee -- 
    ,nvl(n.stamp_tax, o.stamp_tax) as stamp_tax -- 
    ,nvl(n.back_fee, o.back_fee) as back_fee -- 
    ,nvl(n.other_fee1, o.other_fee1) as other_fee1 -- 
    ,nvl(n.interest, o.interest) as interest -- 
    ,nvl(n.interest_tax, o.interest_tax) as interest_tax -- 
    ,nvl(n.interest_share, o.interest_share) as interest_share -- 
    ,nvl(n.ori_trade_fee, o.ori_trade_fee) as ori_trade_fee -- 
    ,nvl(n.total_fee, o.total_fee) as total_fee -- 
    ,nvl(n.commision, o.commision) as commision -- 
    ,nvl(n.regist_fee, o.regist_fee) as regist_fee -- 
    ,nvl(n.asset_fee, o.asset_fee) as asset_fee -- 
    ,nvl(n.manage_fee, o.manage_fee) as manage_fee -- 
    ,nvl(n.ori_transfer_fee, o.ori_transfer_fee) as ori_transfer_fee -- 
    ,nvl(n.ori_back_fee, o.ori_back_fee) as ori_back_fee -- 
    ,nvl(n.ori_other_fee1, o.ori_other_fee1) as ori_other_fee1 -- 
    ,nvl(n.nav, o.nav) as nav -- 
    ,nvl(n.frozen_amt, o.frozen_amt) as frozen_amt -- 
    ,nvl(n.unfrozen_amt, o.unfrozen_amt) as unfrozen_amt -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.ta_flag, o.ta_flag) as ta_flag -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.gain_income, o.gain_income) as gain_income -- 
    ,nvl(n.end_flag, o.end_flag) as end_flag -- 
    ,nvl(n.client_income, o.client_income) as client_income -- 
    ,nvl(n.branch_income, o.branch_income) as branch_income -- 
    ,nvl(n.ch_vol, o.ch_vol) as ch_vol -- 
    ,nvl(n.cfm_income, o.cfm_income) as cfm_income -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.vol, o.vol) as vol -- 
    ,nvl(n.agio, o.agio) as agio -- 
    ,nvl(n.last_vol, o.last_vol) as last_vol -- 
    ,nvl(n.last_frozen_vol, o.last_frozen_vol) as last_frozen_vol -- 
    ,nvl(n.targ_prd_code, o.targ_prd_code) as targ_prd_code -- 
    ,nvl(n.targ_share_class, o.targ_share_class) as targ_share_class -- 
    ,nvl(n.targ_asset_acc, o.targ_asset_acc) as targ_asset_acc -- 
    ,nvl(n.targ_seller_code, o.targ_seller_code) as targ_seller_code -- 
    ,nvl(n.targ_net_no, o.targ_net_no) as targ_net_no -- 
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 
    ,nvl(n.ori_serial_no, o.ori_serial_no) as ori_serial_no -- 
    ,nvl(n.larg_red_flag, o.larg_red_flag) as larg_red_flag -- 
    ,nvl(n.frozen_cause, o.frozen_cause) as frozen_cause -- 
    ,nvl(n.frozen_end_date, o.frozen_end_date) as frozen_end_date -- 
    ,nvl(n.out_busin_code, o.out_busin_code) as out_busin_code -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.ori_agio, o.ori_agio) as ori_agio -- 
    ,nvl(n.cis_date, o.cis_date) as cis_date -- 
    ,nvl(n.back_agio, o.back_agio) as back_agio -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.real_flag, o.real_flag) as real_flag -- 
    ,nvl(n.err_code, o.err_code) as err_code -- 
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.amt2, o.amt2) as amt2 -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 
    ,nvl(n.real_prd_code, o.real_prd_code) as real_prd_code -- 
    ,nvl(n.targ_real_prd_code, o.targ_real_prd_code) as targ_real_prd_code -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,case when
            n.cfm_no is null
            and n.serial_no is null
            and n.seller_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cfm_no is null
            and n.serial_no is null
            and n.seller_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cfm_no is null
            and n.serial_no is null
            and n.seller_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_fds_tbtatranscfm_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_fds_tbtatranscfm where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cfm_no = n.cfm_no
            and o.serial_no = n.serial_no
            and o.seller_code = n.seller_code
where (
        o.cfm_no is null
        and o.serial_no is null
        and o.seller_code is null
    )
    or (
        n.cfm_no is null
        and n.serial_no is null
        and n.seller_code is null
    )
    or (
        o.busin_code <> n.busin_code
        or o.cfm_date <> n.cfm_date
        or o.trans_date <> n.trans_date
        or o.branch_no <> n.branch_no
        or o.asset_acc <> n.asset_acc
        or o.ta_client <> n.ta_client
        or o.prd_code <> n.prd_code
        or o.share_class <> n.share_class
        or o.cfm_amt <> n.cfm_amt
        or o.cfm_vol <> n.cfm_vol
        or o.tot_cfm_amt <> n.tot_cfm_amt
        or o.tot_cfm_vol <> n.tot_cfm_vol
        or o.no_cfm_amt <> n.no_cfm_amt
        or o.no_cfm_vol <> n.no_cfm_vol
        or o.trade_fee <> n.trade_fee
        or o.ori_fee <> n.ori_fee
        or o.transfer_fee <> n.transfer_fee
        or o.stamp_tax <> n.stamp_tax
        or o.back_fee <> n.back_fee
        or o.other_fee1 <> n.other_fee1
        or o.interest <> n.interest
        or o.interest_tax <> n.interest_tax
        or o.interest_share <> n.interest_share
        or o.ori_trade_fee <> n.ori_trade_fee
        or o.total_fee <> n.total_fee
        or o.commision <> n.commision
        or o.regist_fee <> n.regist_fee
        or o.asset_fee <> n.asset_fee
        or o.manage_fee <> n.manage_fee
        or o.ori_transfer_fee <> n.ori_transfer_fee
        or o.ori_back_fee <> n.ori_back_fee
        or o.ori_other_fee1 <> n.ori_other_fee1
        or o.nav <> n.nav
        or o.frozen_amt <> n.frozen_amt
        or o.unfrozen_amt <> n.unfrozen_amt
        or o.status <> n.status
        or o.ta_flag <> n.ta_flag
        or o.client_type <> n.client_type
        or o.in_client_no <> n.in_client_no
        or o.gain_income <> n.gain_income
        or o.end_flag <> n.end_flag
        or o.client_income <> n.client_income
        or o.branch_income <> n.branch_income
        or o.ch_vol <> n.ch_vol
        or o.cfm_income <> n.cfm_income
        or o.amt <> n.amt
        or o.vol <> n.vol
        or o.agio <> n.agio
        or o.last_vol <> n.last_vol
        or o.last_frozen_vol <> n.last_frozen_vol
        or o.targ_prd_code <> n.targ_prd_code
        or o.targ_share_class <> n.targ_share_class
        or o.targ_asset_acc <> n.targ_asset_acc
        or o.targ_seller_code <> n.targ_seller_code
        or o.targ_net_no <> n.targ_net_no
        or o.div_mode <> n.div_mode
        or o.ori_serial_no <> n.ori_serial_no
        or o.larg_red_flag <> n.larg_red_flag
        or o.frozen_cause <> n.frozen_cause
        or o.frozen_end_date <> n.frozen_end_date
        or o.out_busin_code <> n.out_busin_code
        or o.channel <> n.channel
        or o.ori_agio <> n.ori_agio
        or o.cis_date <> n.cis_date
        or o.back_agio <> n.back_agio
        or o.bank_no <> n.bank_no
        or o.real_flag <> n.real_flag
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.real_prd_code <> n.real_prd_code
        or o.targ_real_prd_code <> n.targ_real_prd_code
        or o.client_manager <> n.client_manager
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbtatranscfm_cl(
            busin_code -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,trans_date -- 
            ,serial_no -- 
            ,seller_code -- 
            ,branch_no -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,tot_cfm_amt -- 
            ,tot_cfm_vol -- 
            ,no_cfm_amt -- 
            ,no_cfm_vol -- 
            ,trade_fee -- 
            ,ori_fee -- 
            ,transfer_fee -- 
            ,stamp_tax -- 
            ,back_fee -- 
            ,other_fee1 -- 
            ,interest -- 
            ,interest_tax -- 
            ,interest_share -- 
            ,ori_trade_fee -- 
            ,total_fee -- 
            ,commision -- 
            ,regist_fee -- 
            ,asset_fee -- 
            ,manage_fee -- 
            ,ori_transfer_fee -- 
            ,ori_back_fee -- 
            ,ori_other_fee1 -- 
            ,nav -- 
            ,frozen_amt -- 
            ,unfrozen_amt -- 
            ,status -- 
            ,ta_flag -- 
            ,client_type -- 
            ,in_client_no -- 
            ,gain_income -- 
            ,end_flag -- 
            ,client_income -- 
            ,branch_income -- 
            ,ch_vol -- 
            ,cfm_income -- 
            ,amt -- 
            ,vol -- 
            ,agio -- 
            ,last_vol -- 
            ,last_frozen_vol -- 
            ,targ_prd_code -- 
            ,targ_share_class -- 
            ,targ_asset_acc -- 
            ,targ_seller_code -- 
            ,targ_net_no -- 
            ,div_mode -- 
            ,ori_serial_no -- 
            ,larg_red_flag -- 
            ,frozen_cause -- 
            ,frozen_end_date -- 
            ,out_busin_code -- 
            ,channel -- 
            ,ori_agio -- 
            ,cis_date -- 
            ,back_agio -- 
            ,bank_no -- 
            ,real_flag -- 
            ,err_code -- 
            ,err_msg -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,real_prd_code -- 
            ,targ_real_prd_code -- 
            ,client_manager -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbtatranscfm_op(
            busin_code -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,trans_date -- 
            ,serial_no -- 
            ,seller_code -- 
            ,branch_no -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,tot_cfm_amt -- 
            ,tot_cfm_vol -- 
            ,no_cfm_amt -- 
            ,no_cfm_vol -- 
            ,trade_fee -- 
            ,ori_fee -- 
            ,transfer_fee -- 
            ,stamp_tax -- 
            ,back_fee -- 
            ,other_fee1 -- 
            ,interest -- 
            ,interest_tax -- 
            ,interest_share -- 
            ,ori_trade_fee -- 
            ,total_fee -- 
            ,commision -- 
            ,regist_fee -- 
            ,asset_fee -- 
            ,manage_fee -- 
            ,ori_transfer_fee -- 
            ,ori_back_fee -- 
            ,ori_other_fee1 -- 
            ,nav -- 
            ,frozen_amt -- 
            ,unfrozen_amt -- 
            ,status -- 
            ,ta_flag -- 
            ,client_type -- 
            ,in_client_no -- 
            ,gain_income -- 
            ,end_flag -- 
            ,client_income -- 
            ,branch_income -- 
            ,ch_vol -- 
            ,cfm_income -- 
            ,amt -- 
            ,vol -- 
            ,agio -- 
            ,last_vol -- 
            ,last_frozen_vol -- 
            ,targ_prd_code -- 
            ,targ_share_class -- 
            ,targ_asset_acc -- 
            ,targ_seller_code -- 
            ,targ_net_no -- 
            ,div_mode -- 
            ,ori_serial_no -- 
            ,larg_red_flag -- 
            ,frozen_cause -- 
            ,frozen_end_date -- 
            ,out_busin_code -- 
            ,channel -- 
            ,ori_agio -- 
            ,cis_date -- 
            ,back_agio -- 
            ,bank_no -- 
            ,real_flag -- 
            ,err_code -- 
            ,err_msg -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,real_prd_code -- 
            ,targ_real_prd_code -- 
            ,client_manager -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.busin_code -- 
    ,o.cfm_date -- 
    ,o.cfm_no -- 
    ,o.trans_date -- 
    ,o.serial_no -- 
    ,o.seller_code -- 
    ,o.branch_no -- 
    ,o.asset_acc -- 
    ,o.ta_client -- 
    ,o.prd_code -- 
    ,o.share_class -- 
    ,o.cfm_amt -- 
    ,o.cfm_vol -- 
    ,o.tot_cfm_amt -- 
    ,o.tot_cfm_vol -- 
    ,o.no_cfm_amt -- 
    ,o.no_cfm_vol -- 
    ,o.trade_fee -- 
    ,o.ori_fee -- 
    ,o.transfer_fee -- 
    ,o.stamp_tax -- 
    ,o.back_fee -- 
    ,o.other_fee1 -- 
    ,o.interest -- 
    ,o.interest_tax -- 
    ,o.interest_share -- 
    ,o.ori_trade_fee -- 
    ,o.total_fee -- 
    ,o.commision -- 
    ,o.regist_fee -- 
    ,o.asset_fee -- 
    ,o.manage_fee -- 
    ,o.ori_transfer_fee -- 
    ,o.ori_back_fee -- 
    ,o.ori_other_fee1 -- 
    ,o.nav -- 
    ,o.frozen_amt -- 
    ,o.unfrozen_amt -- 
    ,o.status -- 
    ,o.ta_flag -- 
    ,o.client_type -- 
    ,o.in_client_no -- 
    ,o.gain_income -- 
    ,o.end_flag -- 
    ,o.client_income -- 
    ,o.branch_income -- 
    ,o.ch_vol -- 
    ,o.cfm_income -- 
    ,o.amt -- 
    ,o.vol -- 
    ,o.agio -- 
    ,o.last_vol -- 
    ,o.last_frozen_vol -- 
    ,o.targ_prd_code -- 
    ,o.targ_share_class -- 
    ,o.targ_asset_acc -- 
    ,o.targ_seller_code -- 
    ,o.targ_net_no -- 
    ,o.div_mode -- 
    ,o.ori_serial_no -- 
    ,o.larg_red_flag -- 
    ,o.frozen_cause -- 
    ,o.frozen_end_date -- 
    ,o.out_busin_code -- 
    ,o.channel -- 
    ,o.ori_agio -- 
    ,o.cis_date -- 
    ,o.back_agio -- 
    ,o.bank_no -- 
    ,o.real_flag -- 
    ,o.err_code -- 
    ,o.err_msg -- 
    ,o.amt1 -- 
    ,o.amt2 -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.reserve5 -- 
    ,o.real_prd_code -- 
    ,o.targ_real_prd_code -- 
    ,o.client_manager -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_fds_tbtatranscfm_bk o
    left join ${iol_schema}.ifms_fds_tbtatranscfm_op n
        on
            o.cfm_no = n.cfm_no
            and o.serial_no = n.serial_no
            and o.seller_code = n.seller_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_fds_tbtatranscfm_cl d
        on
            o.cfm_no = d.cfm_no
            and o.serial_no = d.serial_no
            and o.seller_code = d.seller_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_fds_tbtatranscfm;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_fds_tbtatranscfm exchange partition p_19000101 with table ${iol_schema}.ifms_fds_tbtatranscfm_cl;
alter table ${iol_schema}.ifms_fds_tbtatranscfm exchange partition p_20991231 with table ${iol_schema}.ifms_fds_tbtatranscfm_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_fds_tbtatranscfm to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbtatranscfm_op purge;
drop table ${iol_schema}.ifms_fds_tbtatranscfm_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_fds_tbtatranscfm_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_fds_tbtatranscfm',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
