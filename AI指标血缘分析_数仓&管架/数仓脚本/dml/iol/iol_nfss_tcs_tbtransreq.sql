/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tcs_tbtransreq
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
create table ${iol_schema}.nfss_tcs_tbtransreq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tcs_tbtransreq;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbtransreq_op purge;
drop table ${iol_schema}.nfss_tcs_tbtransreq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbtransreq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tcs_tbtransreq where 0=1;

create table ${iol_schema}.nfss_tcs_tbtransreq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tcs_tbtransreq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tcs_tbtransreq_cl(
            serial_no -- 
            ,ex_serial -- 
            ,contract_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,occur_init_date -- 
            ,seller_code -- 
            ,trans_code -- 
            ,control_flag -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,in_client_no -- 
            ,client_type -- 
            ,id_type -- 
            ,id_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,channel -- 
            ,term_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,prd_code -- 
            ,curr_type -- 
            ,prd_type -- 
            ,share_class -- 
            ,asso_date -- 
            ,asso_serial -- 
            ,asso_serial2 -- 
            ,asso_serial3 -- 
            ,amt -- 
            ,manage_charge -- 
            ,manage_charge2 -- 
            ,agio -- 
            ,client_group -- 
            ,liqu_status -- 
            ,ori_channel -- 
            ,ori_branch_no -- 
            ,vol -- 
            ,larg_red_flag -- 
            ,red_mode -- 
            ,prd_price -- 
            ,amt_ratio -- 
            ,div_mode -- 
            ,div_rate -- 
            ,frozen_cause -- 
            ,transfer_cause -- 
            ,conv_dir -- 
            ,targ_prd_code -- 
            ,targ_seller_code -- 
            ,targ_asset_acc -- 
            ,targ_branch -- 
            ,targ_bank_acc -- 
            ,client_risk -- 
            ,product_risk -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,cfm_vol -- 
            ,to_host_serial -- 
            ,host_check_date -- 
            ,ori_host_chk_date -- 
            ,host_trans_code -- 
            ,host_date -- 
            ,host_serial -- 
            ,monitor_flag -- 
            ,client_manager -- 
            ,err_code -- 
            ,err_msg -- 
            ,status -- 
            ,deal_mode -- 
            ,summary -- 
            ,debit_account -- 
            ,fee_account -- 
            ,amt1 -- 
            ,amt2 -- 
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
        into ${iol_schema}.nfss_tcs_tbtransreq_op(
            serial_no -- 
            ,ex_serial -- 
            ,contract_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,occur_init_date -- 
            ,seller_code -- 
            ,trans_code -- 
            ,control_flag -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,in_client_no -- 
            ,client_type -- 
            ,id_type -- 
            ,id_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,channel -- 
            ,term_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,prd_code -- 
            ,curr_type -- 
            ,prd_type -- 
            ,share_class -- 
            ,asso_date -- 
            ,asso_serial -- 
            ,asso_serial2 -- 
            ,asso_serial3 -- 
            ,amt -- 
            ,manage_charge -- 
            ,manage_charge2 -- 
            ,agio -- 
            ,client_group -- 
            ,liqu_status -- 
            ,ori_channel -- 
            ,ori_branch_no -- 
            ,vol -- 
            ,larg_red_flag -- 
            ,red_mode -- 
            ,prd_price -- 
            ,amt_ratio -- 
            ,div_mode -- 
            ,div_rate -- 
            ,frozen_cause -- 
            ,transfer_cause -- 
            ,conv_dir -- 
            ,targ_prd_code -- 
            ,targ_seller_code -- 
            ,targ_asset_acc -- 
            ,targ_branch -- 
            ,targ_bank_acc -- 
            ,client_risk -- 
            ,product_risk -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,cfm_vol -- 
            ,to_host_serial -- 
            ,host_check_date -- 
            ,ori_host_chk_date -- 
            ,host_trans_code -- 
            ,host_date -- 
            ,host_serial -- 
            ,monitor_flag -- 
            ,client_manager -- 
            ,err_code -- 
            ,err_msg -- 
            ,status -- 
            ,deal_mode -- 
            ,summary -- 
            ,debit_account -- 
            ,fee_account -- 
            ,amt1 -- 
            ,amt2 -- 
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
    nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.ex_serial, o.ex_serial) as ex_serial -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 
    ,nvl(n.occur_init_date, o.occur_init_date) as occur_init_date -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.trans_code, o.trans_code) as trans_code -- 
    ,nvl(n.control_flag, o.control_flag) as control_flag -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.id_type, o.id_type) as id_type -- 
    ,nvl(n.id_code, o.id_code) as id_code -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 
    ,nvl(n.trans_account_type, o.trans_account_type) as trans_account_type -- 
    ,nvl(n.trans_account, o.trans_account) as trans_account -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.term_no, o.term_no) as term_no -- 
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 
    ,nvl(n.auth_oper, o.auth_oper) as auth_oper -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 
    ,nvl(n.share_class, o.share_class) as share_class -- 
    ,nvl(n.asso_date, o.asso_date) as asso_date -- 
    ,nvl(n.asso_serial, o.asso_serial) as asso_serial -- 
    ,nvl(n.asso_serial2, o.asso_serial2) as asso_serial2 -- 
    ,nvl(n.asso_serial3, o.asso_serial3) as asso_serial3 -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.manage_charge, o.manage_charge) as manage_charge -- 
    ,nvl(n.manage_charge2, o.manage_charge2) as manage_charge2 -- 
    ,nvl(n.agio, o.agio) as agio -- 
    ,nvl(n.client_group, o.client_group) as client_group -- 
    ,nvl(n.liqu_status, o.liqu_status) as liqu_status -- 
    ,nvl(n.ori_channel, o.ori_channel) as ori_channel -- 
    ,nvl(n.ori_branch_no, o.ori_branch_no) as ori_branch_no -- 
    ,nvl(n.vol, o.vol) as vol -- 
    ,nvl(n.larg_red_flag, o.larg_red_flag) as larg_red_flag -- 
    ,nvl(n.red_mode, o.red_mode) as red_mode -- 
    ,nvl(n.prd_price, o.prd_price) as prd_price -- 
    ,nvl(n.amt_ratio, o.amt_ratio) as amt_ratio -- 
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 
    ,nvl(n.div_rate, o.div_rate) as div_rate -- 
    ,nvl(n.frozen_cause, o.frozen_cause) as frozen_cause -- 
    ,nvl(n.transfer_cause, o.transfer_cause) as transfer_cause -- 
    ,nvl(n.conv_dir, o.conv_dir) as conv_dir -- 
    ,nvl(n.targ_prd_code, o.targ_prd_code) as targ_prd_code -- 
    ,nvl(n.targ_seller_code, o.targ_seller_code) as targ_seller_code -- 
    ,nvl(n.targ_asset_acc, o.targ_asset_acc) as targ_asset_acc -- 
    ,nvl(n.targ_branch, o.targ_branch) as targ_branch -- 
    ,nvl(n.targ_bank_acc, o.targ_bank_acc) as targ_bank_acc -- 
    ,nvl(n.client_risk, o.client_risk) as client_risk -- 
    ,nvl(n.product_risk, o.product_risk) as product_risk -- 
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- 
    ,nvl(n.cfm_vol, o.cfm_vol) as cfm_vol -- 
    ,nvl(n.to_host_serial, o.to_host_serial) as to_host_serial -- 
    ,nvl(n.host_check_date, o.host_check_date) as host_check_date -- 
    ,nvl(n.ori_host_chk_date, o.ori_host_chk_date) as ori_host_chk_date -- 
    ,nvl(n.host_trans_code, o.host_trans_code) as host_trans_code -- 
    ,nvl(n.host_date, o.host_date) as host_date -- 
    ,nvl(n.host_serial, o.host_serial) as host_serial -- 
    ,nvl(n.monitor_flag, o.monitor_flag) as monitor_flag -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.err_code, o.err_code) as err_code -- 
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.deal_mode, o.deal_mode) as deal_mode -- 
    ,nvl(n.summary, o.summary) as summary -- 
    ,nvl(n.debit_account, o.debit_account) as debit_account -- 
    ,nvl(n.fee_account, o.fee_account) as fee_account -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.amt2, o.amt2) as amt2 -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 
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
from (select * from ${iol_schema}.nfss_tcs_tbtransreq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tcs_tbtransreq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.contract_no <> n.contract_no
        or o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.occur_init_date <> n.occur_init_date
        or o.seller_code <> n.seller_code
        or o.trans_code <> n.trans_code
        or o.control_flag <> n.control_flag
        or o.branch_no <> n.branch_no
        or o.open_branch <> n.open_branch
        or o.ta_code <> n.ta_code
        or o.asset_acc <> n.asset_acc
        or o.in_client_no <> n.in_client_no
        or o.client_type <> n.client_type
        or o.id_type <> n.id_type
        or o.id_code <> n.id_code
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.cash_flag <> n.cash_flag
        or o.trans_account_type <> n.trans_account_type
        or o.trans_account <> n.trans_account
        or o.channel <> n.channel
        or o.term_no <> n.term_no
        or o.oper_no <> n.oper_no
        or o.auth_oper <> n.auth_oper
        or o.prd_code <> n.prd_code
        or o.curr_type <> n.curr_type
        or o.prd_type <> n.prd_type
        or o.share_class <> n.share_class
        or o.asso_date <> n.asso_date
        or o.asso_serial <> n.asso_serial
        or o.asso_serial2 <> n.asso_serial2
        or o.asso_serial3 <> n.asso_serial3
        or o.amt <> n.amt
        or o.manage_charge <> n.manage_charge
        or o.manage_charge2 <> n.manage_charge2
        or o.agio <> n.agio
        or o.client_group <> n.client_group
        or o.liqu_status <> n.liqu_status
        or o.ori_channel <> n.ori_channel
        or o.ori_branch_no <> n.ori_branch_no
        or o.vol <> n.vol
        or o.larg_red_flag <> n.larg_red_flag
        or o.red_mode <> n.red_mode
        or o.prd_price <> n.prd_price
        or o.amt_ratio <> n.amt_ratio
        or o.div_mode <> n.div_mode
        or o.div_rate <> n.div_rate
        or o.frozen_cause <> n.frozen_cause
        or o.transfer_cause <> n.transfer_cause
        or o.conv_dir <> n.conv_dir
        or o.targ_prd_code <> n.targ_prd_code
        or o.targ_seller_code <> n.targ_seller_code
        or o.targ_asset_acc <> n.targ_asset_acc
        or o.targ_branch <> n.targ_branch
        or o.targ_bank_acc <> n.targ_bank_acc
        or o.client_risk <> n.client_risk
        or o.product_risk <> n.product_risk
        or o.cfm_date <> n.cfm_date
        or o.cfm_no <> n.cfm_no
        or o.cfm_vol <> n.cfm_vol
        or o.to_host_serial <> n.to_host_serial
        or o.host_check_date <> n.host_check_date
        or o.ori_host_chk_date <> n.ori_host_chk_date
        or o.host_trans_code <> n.host_trans_code
        or o.host_date <> n.host_date
        or o.host_serial <> n.host_serial
        or o.monitor_flag <> n.monitor_flag
        or o.client_manager <> n.client_manager
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.status <> n.status
        or o.deal_mode <> n.deal_mode
        or o.summary <> n.summary
        or o.debit_account <> n.debit_account
        or o.fee_account <> n.fee_account
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
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
        into ${iol_schema}.nfss_tcs_tbtransreq_cl(
            serial_no -- 
            ,ex_serial -- 
            ,contract_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,occur_init_date -- 
            ,seller_code -- 
            ,trans_code -- 
            ,control_flag -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,in_client_no -- 
            ,client_type -- 
            ,id_type -- 
            ,id_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,channel -- 
            ,term_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,prd_code -- 
            ,curr_type -- 
            ,prd_type -- 
            ,share_class -- 
            ,asso_date -- 
            ,asso_serial -- 
            ,asso_serial2 -- 
            ,asso_serial3 -- 
            ,amt -- 
            ,manage_charge -- 
            ,manage_charge2 -- 
            ,agio -- 
            ,client_group -- 
            ,liqu_status -- 
            ,ori_channel -- 
            ,ori_branch_no -- 
            ,vol -- 
            ,larg_red_flag -- 
            ,red_mode -- 
            ,prd_price -- 
            ,amt_ratio -- 
            ,div_mode -- 
            ,div_rate -- 
            ,frozen_cause -- 
            ,transfer_cause -- 
            ,conv_dir -- 
            ,targ_prd_code -- 
            ,targ_seller_code -- 
            ,targ_asset_acc -- 
            ,targ_branch -- 
            ,targ_bank_acc -- 
            ,client_risk -- 
            ,product_risk -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,cfm_vol -- 
            ,to_host_serial -- 
            ,host_check_date -- 
            ,ori_host_chk_date -- 
            ,host_trans_code -- 
            ,host_date -- 
            ,host_serial -- 
            ,monitor_flag -- 
            ,client_manager -- 
            ,err_code -- 
            ,err_msg -- 
            ,status -- 
            ,deal_mode -- 
            ,summary -- 
            ,debit_account -- 
            ,fee_account -- 
            ,amt1 -- 
            ,amt2 -- 
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
        into ${iol_schema}.nfss_tcs_tbtransreq_op(
            serial_no -- 
            ,ex_serial -- 
            ,contract_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,occur_init_date -- 
            ,seller_code -- 
            ,trans_code -- 
            ,control_flag -- 
            ,branch_no -- 
            ,open_branch -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,in_client_no -- 
            ,client_type -- 
            ,id_type -- 
            ,id_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,channel -- 
            ,term_no -- 
            ,oper_no -- 
            ,auth_oper -- 
            ,prd_code -- 
            ,curr_type -- 
            ,prd_type -- 
            ,share_class -- 
            ,asso_date -- 
            ,asso_serial -- 
            ,asso_serial2 -- 
            ,asso_serial3 -- 
            ,amt -- 
            ,manage_charge -- 
            ,manage_charge2 -- 
            ,agio -- 
            ,client_group -- 
            ,liqu_status -- 
            ,ori_channel -- 
            ,ori_branch_no -- 
            ,vol -- 
            ,larg_red_flag -- 
            ,red_mode -- 
            ,prd_price -- 
            ,amt_ratio -- 
            ,div_mode -- 
            ,div_rate -- 
            ,frozen_cause -- 
            ,transfer_cause -- 
            ,conv_dir -- 
            ,targ_prd_code -- 
            ,targ_seller_code -- 
            ,targ_asset_acc -- 
            ,targ_branch -- 
            ,targ_bank_acc -- 
            ,client_risk -- 
            ,product_risk -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,cfm_vol -- 
            ,to_host_serial -- 
            ,host_check_date -- 
            ,ori_host_chk_date -- 
            ,host_trans_code -- 
            ,host_date -- 
            ,host_serial -- 
            ,monitor_flag -- 
            ,client_manager -- 
            ,err_code -- 
            ,err_msg -- 
            ,status -- 
            ,deal_mode -- 
            ,summary -- 
            ,debit_account -- 
            ,fee_account -- 
            ,amt1 -- 
            ,amt2 -- 
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
    o.serial_no -- 
    ,o.ex_serial -- 
    ,o.contract_no -- 
    ,o.trans_date -- 
    ,o.trans_time -- 
    ,o.occur_init_date -- 
    ,o.seller_code -- 
    ,o.trans_code -- 
    ,o.control_flag -- 
    ,o.branch_no -- 
    ,o.open_branch -- 
    ,o.ta_code -- 
    ,o.asset_acc -- 
    ,o.in_client_no -- 
    ,o.client_type -- 
    ,o.id_type -- 
    ,o.id_code -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.bank_acc -- 
    ,o.cash_flag -- 
    ,o.trans_account_type -- 
    ,o.trans_account -- 
    ,o.channel -- 
    ,o.term_no -- 
    ,o.oper_no -- 
    ,o.auth_oper -- 
    ,o.prd_code -- 
    ,o.curr_type -- 
    ,o.prd_type -- 
    ,o.share_class -- 
    ,o.asso_date -- 
    ,o.asso_serial -- 
    ,o.asso_serial2 -- 
    ,o.asso_serial3 -- 
    ,o.amt -- 
    ,o.manage_charge -- 
    ,o.manage_charge2 -- 
    ,o.agio -- 
    ,o.client_group -- 
    ,o.liqu_status -- 
    ,o.ori_channel -- 
    ,o.ori_branch_no -- 
    ,o.vol -- 
    ,o.larg_red_flag -- 
    ,o.red_mode -- 
    ,o.prd_price -- 
    ,o.amt_ratio -- 
    ,o.div_mode -- 
    ,o.div_rate -- 
    ,o.frozen_cause -- 
    ,o.transfer_cause -- 
    ,o.conv_dir -- 
    ,o.targ_prd_code -- 
    ,o.targ_seller_code -- 
    ,o.targ_asset_acc -- 
    ,o.targ_branch -- 
    ,o.targ_bank_acc -- 
    ,o.client_risk -- 
    ,o.product_risk -- 
    ,o.cfm_date -- 
    ,o.cfm_no -- 
    ,o.cfm_vol -- 
    ,o.to_host_serial -- 
    ,o.host_check_date -- 
    ,o.ori_host_chk_date -- 
    ,o.host_trans_code -- 
    ,o.host_date -- 
    ,o.host_serial -- 
    ,o.monitor_flag -- 
    ,o.client_manager -- 
    ,o.err_code -- 
    ,o.err_msg -- 
    ,o.status -- 
    ,o.deal_mode -- 
    ,o.summary -- 
    ,o.debit_account -- 
    ,o.fee_account -- 
    ,o.amt1 -- 
    ,o.amt2 -- 
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
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tcs_tbtransreq_bk o
    left join ${iol_schema}.nfss_tcs_tbtransreq_op n
        on
            o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tcs_tbtransreq_cl d
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
-- truncate table ${iol_schema}.nfss_tcs_tbtransreq;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tcs_tbtransreq exchange partition p_19000101 with table ${iol_schema}.nfss_tcs_tbtransreq_cl;
alter table ${iol_schema}.nfss_tcs_tbtransreq exchange partition p_20991231 with table ${iol_schema}.nfss_tcs_tbtransreq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tcs_tbtransreq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbtransreq_op purge;
drop table ${iol_schema}.nfss_tcs_tbtransreq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tcs_tbtransreq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tcs_tbtransreq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
