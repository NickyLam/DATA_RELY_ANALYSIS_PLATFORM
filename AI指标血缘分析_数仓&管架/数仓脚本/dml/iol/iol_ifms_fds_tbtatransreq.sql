/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_fds_tbtatransreq
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
create table ${iol_schema}.ifms_fds_tbtatransreq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_fds_tbtatransreq;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbtatransreq_op purge;
drop table ${iol_schema}.ifms_fds_tbtatransreq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbtatransreq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbtatransreq where 0=1;

create table ${iol_schema}.ifms_fds_tbtatransreq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbtatransreq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbtatransreq_cl(
            trans_date -- 
            ,busin_code -- 
            ,trans_time -- 
            ,serial_no -- 
            ,seller_code -- 
            ,branch_no -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,amt -- 
            ,vol -- 
            ,tot_fee -- 
            ,targ_prd_code -- 
            ,targ_share_class -- 
            ,targ_asset_acc -- 
            ,targ_ta_client -- 
            ,targ_seller_code -- 
            ,targ_net_no -- 
            ,ori_cfm_date -- 
            ,ori_serial_no -- 
            ,ori_cfm_no -- 
            ,larg_red_flag -- 
            ,hope_date -- 
            ,agio -- 
            ,div_mode -- 
            ,frozen_cause -- 
            ,frozen_end_date -- 
            ,frozen_law_no -- 
            ,unfroze_law_no -- 
            ,ta_flag -- 
            ,out_busin_code -- 
            ,man_flag -- 
            ,client_type -- 
            ,in_client_no -- 
            ,last_cfm_date -- 
            ,status -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,ori_agio -- 
            ,cfm_rate -- 
            ,rule_agio -- 
            ,broker -- 
            ,nodeal_flag -- 
            ,price -- 
            ,targ_price -- 
            ,ch_vol -- 
            ,channel -- 
            ,transfer_cause -- 
            ,first_cfm_date -- 
            ,income -- 
            ,back_agio -- 
            ,bank_no -- 
            ,client_rate -- 
            ,client_group -- 
            ,red_mode -- 
            ,manager_agio -- 
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
            ,ta_code -- 
            ,client_risk -- 
            ,risk_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbtatransreq_op(
            trans_date -- 
            ,busin_code -- 
            ,trans_time -- 
            ,serial_no -- 
            ,seller_code -- 
            ,branch_no -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,amt -- 
            ,vol -- 
            ,tot_fee -- 
            ,targ_prd_code -- 
            ,targ_share_class -- 
            ,targ_asset_acc -- 
            ,targ_ta_client -- 
            ,targ_seller_code -- 
            ,targ_net_no -- 
            ,ori_cfm_date -- 
            ,ori_serial_no -- 
            ,ori_cfm_no -- 
            ,larg_red_flag -- 
            ,hope_date -- 
            ,agio -- 
            ,div_mode -- 
            ,frozen_cause -- 
            ,frozen_end_date -- 
            ,frozen_law_no -- 
            ,unfroze_law_no -- 
            ,ta_flag -- 
            ,out_busin_code -- 
            ,man_flag -- 
            ,client_type -- 
            ,in_client_no -- 
            ,last_cfm_date -- 
            ,status -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,ori_agio -- 
            ,cfm_rate -- 
            ,rule_agio -- 
            ,broker -- 
            ,nodeal_flag -- 
            ,price -- 
            ,targ_price -- 
            ,ch_vol -- 
            ,channel -- 
            ,transfer_cause -- 
            ,first_cfm_date -- 
            ,income -- 
            ,back_agio -- 
            ,bank_no -- 
            ,client_rate -- 
            ,client_group -- 
            ,red_mode -- 
            ,manager_agio -- 
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
            ,ta_code -- 
            ,client_risk -- 
            ,risk_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.busin_code, o.busin_code) as busin_code -- 
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.share_class, o.share_class) as share_class -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.vol, o.vol) as vol -- 
    ,nvl(n.tot_fee, o.tot_fee) as tot_fee -- 
    ,nvl(n.targ_prd_code, o.targ_prd_code) as targ_prd_code -- 
    ,nvl(n.targ_share_class, o.targ_share_class) as targ_share_class -- 
    ,nvl(n.targ_asset_acc, o.targ_asset_acc) as targ_asset_acc -- 
    ,nvl(n.targ_ta_client, o.targ_ta_client) as targ_ta_client -- 
    ,nvl(n.targ_seller_code, o.targ_seller_code) as targ_seller_code -- 
    ,nvl(n.targ_net_no, o.targ_net_no) as targ_net_no -- 
    ,nvl(n.ori_cfm_date, o.ori_cfm_date) as ori_cfm_date -- 
    ,nvl(n.ori_serial_no, o.ori_serial_no) as ori_serial_no -- 
    ,nvl(n.ori_cfm_no, o.ori_cfm_no) as ori_cfm_no -- 
    ,nvl(n.larg_red_flag, o.larg_red_flag) as larg_red_flag -- 
    ,nvl(n.hope_date, o.hope_date) as hope_date -- 
    ,nvl(n.agio, o.agio) as agio -- 
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 
    ,nvl(n.frozen_cause, o.frozen_cause) as frozen_cause -- 
    ,nvl(n.frozen_end_date, o.frozen_end_date) as frozen_end_date -- 
    ,nvl(n.frozen_law_no, o.frozen_law_no) as frozen_law_no -- 
    ,nvl(n.unfroze_law_no, o.unfroze_law_no) as unfroze_law_no -- 
    ,nvl(n.ta_flag, o.ta_flag) as ta_flag -- 
    ,nvl(n.out_busin_code, o.out_busin_code) as out_busin_code -- 
    ,nvl(n.man_flag, o.man_flag) as man_flag -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.last_cfm_date, o.last_cfm_date) as last_cfm_date -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.cfm_amt, o.cfm_amt) as cfm_amt -- 
    ,nvl(n.cfm_vol, o.cfm_vol) as cfm_vol -- 
    ,nvl(n.ori_agio, o.ori_agio) as ori_agio -- 
    ,nvl(n.cfm_rate, o.cfm_rate) as cfm_rate -- 
    ,nvl(n.rule_agio, o.rule_agio) as rule_agio -- 
    ,nvl(n.broker, o.broker) as broker -- 
    ,nvl(n.nodeal_flag, o.nodeal_flag) as nodeal_flag -- 
    ,nvl(n.price, o.price) as price -- 
    ,nvl(n.targ_price, o.targ_price) as targ_price -- 
    ,nvl(n.ch_vol, o.ch_vol) as ch_vol -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.transfer_cause, o.transfer_cause) as transfer_cause -- 
    ,nvl(n.first_cfm_date, o.first_cfm_date) as first_cfm_date -- 
    ,nvl(n.income, o.income) as income -- 
    ,nvl(n.back_agio, o.back_agio) as back_agio -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_rate, o.client_rate) as client_rate -- 
    ,nvl(n.client_group, o.client_group) as client_group -- 
    ,nvl(n.red_mode, o.red_mode) as red_mode -- 
    ,nvl(n.manager_agio, o.manager_agio) as manager_agio -- 
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
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.client_risk, o.client_risk) as client_risk -- 
    ,nvl(n.risk_date, o.risk_date) as risk_date -- 
    ,case when
            n.serial_no is null
            and n.seller_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serial_no is null
            and n.seller_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serial_no is null
            and n.seller_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_fds_tbtatransreq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_fds_tbtatransreq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_no = n.serial_no
            and o.seller_code = n.seller_code
where (
        o.serial_no is null
        and o.seller_code is null
    )
    or (
        n.serial_no is null
        and n.seller_code is null
    )
    or (
        o.trans_date <> n.trans_date
        or o.busin_code <> n.busin_code
        or o.trans_time <> n.trans_time
        or o.branch_no <> n.branch_no
        or o.asset_acc <> n.asset_acc
        or o.ta_client <> n.ta_client
        or o.prd_code <> n.prd_code
        or o.share_class <> n.share_class
        or o.amt <> n.amt
        or o.vol <> n.vol
        or o.tot_fee <> n.tot_fee
        or o.targ_prd_code <> n.targ_prd_code
        or o.targ_share_class <> n.targ_share_class
        or o.targ_asset_acc <> n.targ_asset_acc
        or o.targ_ta_client <> n.targ_ta_client
        or o.targ_seller_code <> n.targ_seller_code
        or o.targ_net_no <> n.targ_net_no
        or o.ori_cfm_date <> n.ori_cfm_date
        or o.ori_serial_no <> n.ori_serial_no
        or o.ori_cfm_no <> n.ori_cfm_no
        or o.larg_red_flag <> n.larg_red_flag
        or o.hope_date <> n.hope_date
        or o.agio <> n.agio
        or o.div_mode <> n.div_mode
        or o.frozen_cause <> n.frozen_cause
        or o.frozen_end_date <> n.frozen_end_date
        or o.frozen_law_no <> n.frozen_law_no
        or o.unfroze_law_no <> n.unfroze_law_no
        or o.ta_flag <> n.ta_flag
        or o.out_busin_code <> n.out_busin_code
        or o.man_flag <> n.man_flag
        or o.client_type <> n.client_type
        or o.in_client_no <> n.in_client_no
        or o.last_cfm_date <> n.last_cfm_date
        or o.status <> n.status
        or o.cfm_amt <> n.cfm_amt
        or o.cfm_vol <> n.cfm_vol
        or o.ori_agio <> n.ori_agio
        or o.cfm_rate <> n.cfm_rate
        or o.rule_agio <> n.rule_agio
        or o.broker <> n.broker
        or o.nodeal_flag <> n.nodeal_flag
        or o.price <> n.price
        or o.targ_price <> n.targ_price
        or o.ch_vol <> n.ch_vol
        or o.channel <> n.channel
        or o.transfer_cause <> n.transfer_cause
        or o.first_cfm_date <> n.first_cfm_date
        or o.income <> n.income
        or o.back_agio <> n.back_agio
        or o.bank_no <> n.bank_no
        or o.client_rate <> n.client_rate
        or o.client_group <> n.client_group
        or o.red_mode <> n.red_mode
        or o.manager_agio <> n.manager_agio
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
        or o.ta_code <> n.ta_code
        or o.client_risk <> n.client_risk
        or o.risk_date <> n.risk_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbtatransreq_cl(
            trans_date -- 
            ,busin_code -- 
            ,trans_time -- 
            ,serial_no -- 
            ,seller_code -- 
            ,branch_no -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,amt -- 
            ,vol -- 
            ,tot_fee -- 
            ,targ_prd_code -- 
            ,targ_share_class -- 
            ,targ_asset_acc -- 
            ,targ_ta_client -- 
            ,targ_seller_code -- 
            ,targ_net_no -- 
            ,ori_cfm_date -- 
            ,ori_serial_no -- 
            ,ori_cfm_no -- 
            ,larg_red_flag -- 
            ,hope_date -- 
            ,agio -- 
            ,div_mode -- 
            ,frozen_cause -- 
            ,frozen_end_date -- 
            ,frozen_law_no -- 
            ,unfroze_law_no -- 
            ,ta_flag -- 
            ,out_busin_code -- 
            ,man_flag -- 
            ,client_type -- 
            ,in_client_no -- 
            ,last_cfm_date -- 
            ,status -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,ori_agio -- 
            ,cfm_rate -- 
            ,rule_agio -- 
            ,broker -- 
            ,nodeal_flag -- 
            ,price -- 
            ,targ_price -- 
            ,ch_vol -- 
            ,channel -- 
            ,transfer_cause -- 
            ,first_cfm_date -- 
            ,income -- 
            ,back_agio -- 
            ,bank_no -- 
            ,client_rate -- 
            ,client_group -- 
            ,red_mode -- 
            ,manager_agio -- 
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
            ,ta_code -- 
            ,client_risk -- 
            ,risk_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbtatransreq_op(
            trans_date -- 
            ,busin_code -- 
            ,trans_time -- 
            ,serial_no -- 
            ,seller_code -- 
            ,branch_no -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,amt -- 
            ,vol -- 
            ,tot_fee -- 
            ,targ_prd_code -- 
            ,targ_share_class -- 
            ,targ_asset_acc -- 
            ,targ_ta_client -- 
            ,targ_seller_code -- 
            ,targ_net_no -- 
            ,ori_cfm_date -- 
            ,ori_serial_no -- 
            ,ori_cfm_no -- 
            ,larg_red_flag -- 
            ,hope_date -- 
            ,agio -- 
            ,div_mode -- 
            ,frozen_cause -- 
            ,frozen_end_date -- 
            ,frozen_law_no -- 
            ,unfroze_law_no -- 
            ,ta_flag -- 
            ,out_busin_code -- 
            ,man_flag -- 
            ,client_type -- 
            ,in_client_no -- 
            ,last_cfm_date -- 
            ,status -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,ori_agio -- 
            ,cfm_rate -- 
            ,rule_agio -- 
            ,broker -- 
            ,nodeal_flag -- 
            ,price -- 
            ,targ_price -- 
            ,ch_vol -- 
            ,channel -- 
            ,transfer_cause -- 
            ,first_cfm_date -- 
            ,income -- 
            ,back_agio -- 
            ,bank_no -- 
            ,client_rate -- 
            ,client_group -- 
            ,red_mode -- 
            ,manager_agio -- 
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
            ,ta_code -- 
            ,client_risk -- 
            ,risk_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trans_date -- 
    ,o.busin_code -- 
    ,o.trans_time -- 
    ,o.serial_no -- 
    ,o.seller_code -- 
    ,o.branch_no -- 
    ,o.asset_acc -- 
    ,o.ta_client -- 
    ,o.prd_code -- 
    ,o.share_class -- 
    ,o.amt -- 
    ,o.vol -- 
    ,o.tot_fee -- 
    ,o.targ_prd_code -- 
    ,o.targ_share_class -- 
    ,o.targ_asset_acc -- 
    ,o.targ_ta_client -- 
    ,o.targ_seller_code -- 
    ,o.targ_net_no -- 
    ,o.ori_cfm_date -- 
    ,o.ori_serial_no -- 
    ,o.ori_cfm_no -- 
    ,o.larg_red_flag -- 
    ,o.hope_date -- 
    ,o.agio -- 
    ,o.div_mode -- 
    ,o.frozen_cause -- 
    ,o.frozen_end_date -- 
    ,o.frozen_law_no -- 
    ,o.unfroze_law_no -- 
    ,o.ta_flag -- 
    ,o.out_busin_code -- 
    ,o.man_flag -- 
    ,o.client_type -- 
    ,o.in_client_no -- 
    ,o.last_cfm_date -- 
    ,o.status -- 
    ,o.cfm_amt -- 
    ,o.cfm_vol -- 
    ,o.ori_agio -- 
    ,o.cfm_rate -- 
    ,o.rule_agio -- 
    ,o.broker -- 
    ,o.nodeal_flag -- 
    ,o.price -- 
    ,o.targ_price -- 
    ,o.ch_vol -- 
    ,o.channel -- 
    ,o.transfer_cause -- 
    ,o.first_cfm_date -- 
    ,o.income -- 
    ,o.back_agio -- 
    ,o.bank_no -- 
    ,o.client_rate -- 
    ,o.client_group -- 
    ,o.red_mode -- 
    ,o.manager_agio -- 
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
    ,o.ta_code -- 
    ,o.client_risk -- 
    ,o.risk_date -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_fds_tbtatransreq_bk o
    left join ${iol_schema}.ifms_fds_tbtatransreq_op n
        on
            o.serial_no = n.serial_no
            and o.seller_code = n.seller_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_fds_tbtatransreq_cl d
        on
            o.serial_no = d.serial_no
            and o.seller_code = d.seller_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_fds_tbtatransreq;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_fds_tbtatransreq exchange partition p_19000101 with table ${iol_schema}.ifms_fds_tbtatransreq_cl;
alter table ${iol_schema}.ifms_fds_tbtatransreq exchange partition p_20991231 with table ${iol_schema}.ifms_fds_tbtatransreq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_fds_tbtatransreq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbtatransreq_op purge;
drop table ${iol_schema}.ifms_fds_tbtatransreq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_fds_tbtatransreq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_fds_tbtatransreq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
