/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_fds_tbproduct
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
create table ${iol_schema}.ifms_fds_tbproduct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_fds_tbproduct;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbproduct_op purge;
drop table ${iol_schema}.ifms_fds_tbproduct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbproduct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbproduct where 0=1;

create table ${iol_schema}.ifms_fds_tbproduct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbproduct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbproduct_cl(
            real_prd_code -- 
            ,model_flag -- 
            ,model_comment -- 
            ,prd_type -- 
            ,ta_code -- 
            ,prd_name -- 
            ,prd_name2 -- 
            ,vol_digit -- 
            ,amt_digit -- 
            ,nav_digit -- 
            ,nav -- 
            ,nav_date -- 
            ,nav_days -- 
            ,face_value -- 
            ,iss_price -- 
            ,asso_code -- 
            ,prd_sponsor -- 
            ,prd_trustee -- 
            ,prd_manager -- 
            ,dep_id -- 
            ,branch_no -- 
            ,ipo_start_date -- 
            ,ipo_end_date -- 
            ,estab_date -- 
            ,income_date -- 
            ,end_date -- 
            ,interest_end_date -- 
            ,income_end_date -- 
            ,issue_fail_date -- 
            ,alimit_end_date -- 
            ,real_estab_date -- 
            ,prd_min_bala -- 
            ,prd_code -- 
            ,prd_max_bala -- 
            ,prd_min_shares -- 
            ,prd_max_shares -- 
            ,prd_issue_real_bala -- 
            ,curr_scale -- 
            ,div_modes -- 
            ,div_mode -- 
            ,inst_flag -- 
            ,limit_flag -- 
            ,liqu_mode -- 
            ,liqu_mode2 -- 
            ,channels -- 
            ,client_groups -- 
            ,temp_flag -- 
            ,control_flag -- 
            ,control_flag2 -- 
            ,share_class -- 
            ,issue_cfm_rate -- 
            ,sub_mode -- 
            ,sub_exp -- 
            ,interest_way -- 
            ,prd_attr -- 
            ,risk_level -- 
            ,grade -- 
            ,status -- 
            ,conv_flag -- 
            ,prd_totvol -- 
            ,tot_nav -- 
            ,curr_type -- 
            ,cost_curr_type -- 
            ,income_curr_type -- 
            ,cash_flag -- 
            ,agio_type -- 
            ,open_time -- 
            ,close_time -- 
            ,paper_no -- 
            ,paper_name -- 
            ,protocol_name -- 
            ,psub_unit -- 
            ,pfirst_amt -- 
            ,papp_amt -- 
            ,pmin_invest_amt -- 
            ,pmin_hold -- 
            ,pmin_red -- 
            ,pmax_red -- 
            ,pred_unit -- 
            ,pmin_conv_vol -- 
            ,pmin_red_vol -- 
            ,pmax_amt -- 
            ,pmax_accu_amt -- 
            ,osub_unit -- 
            ,ofirst_amt -- 
            ,oapp_amt -- 
            ,omin_invest_amt -- 
            ,omin_hold -- 
            ,omin_red -- 
            ,omax_red -- 
            ,ored_unit -- 
            ,omin_conv_vol -- 
            ,omin_red_vol -- 
            ,omax_amt -- 
            ,omax_accu_amt -- 
            ,tot_client -- 
            ,ipo_time -- 
            ,order_date -- 
            ,order_time -- 
            ,book_buy_days -- 
            ,book_sell_days -- 
            ,book_buy_date -- 
            ,book_sell_date -- 
            ,dir_order_type -- 
            ,dir_hold_day -- 
            ,dir_free_date -- 
            ,dir_start_date -- 
            ,dir_start_time -- 
            ,invest_fail_times -- 
            ,debit_account -- 
            ,crebit_account -- 
            ,red_draw_account -- 
            ,charge_account -- 
            ,manage_account -- 
            ,red_days -- 
            ,div_days -- 
            ,refund_days -- 
            ,fail_days -- 
            ,open_buy_days -- 
            ,red_arr_date -- 
            ,div_arr_date -- 
            ,refund_arr_date -- 
            ,fail_arr_date -- 
            ,open_arr_date -- 
            ,large_buy_rate -- 
            ,large_red_rate -- 
            ,real_red_amt_rate -- 
            ,real_red_vol_rate -- 
            ,real_red_max_vol -- 
            ,base_days -- 
            ,interest_days -- 
            ,manage_days -- 
            ,red_fare_rate -- 
            ,conv_fare_rate -- 
            ,manage_rate -- 
            ,total_bonus -- 
            ,cash_rate -- 
            ,money_date -- 
            ,corpus_rate -- 
            ,evend_date -- 
            ,tn_confirm -- 
            ,guest_rate -- 
            ,cycle_days -- 
            ,trans_way -- 
            ,int1 -- 
            ,int2 -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,bank_no -- 
            ,calc_income_way -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbproduct_op(
            real_prd_code -- 
            ,model_flag -- 
            ,model_comment -- 
            ,prd_type -- 
            ,ta_code -- 
            ,prd_name -- 
            ,prd_name2 -- 
            ,vol_digit -- 
            ,amt_digit -- 
            ,nav_digit -- 
            ,nav -- 
            ,nav_date -- 
            ,nav_days -- 
            ,face_value -- 
            ,iss_price -- 
            ,asso_code -- 
            ,prd_sponsor -- 
            ,prd_trustee -- 
            ,prd_manager -- 
            ,dep_id -- 
            ,branch_no -- 
            ,ipo_start_date -- 
            ,ipo_end_date -- 
            ,estab_date -- 
            ,income_date -- 
            ,end_date -- 
            ,interest_end_date -- 
            ,income_end_date -- 
            ,issue_fail_date -- 
            ,alimit_end_date -- 
            ,real_estab_date -- 
            ,prd_min_bala -- 
            ,prd_code -- 
            ,prd_max_bala -- 
            ,prd_min_shares -- 
            ,prd_max_shares -- 
            ,prd_issue_real_bala -- 
            ,curr_scale -- 
            ,div_modes -- 
            ,div_mode -- 
            ,inst_flag -- 
            ,limit_flag -- 
            ,liqu_mode -- 
            ,liqu_mode2 -- 
            ,channels -- 
            ,client_groups -- 
            ,temp_flag -- 
            ,control_flag -- 
            ,control_flag2 -- 
            ,share_class -- 
            ,issue_cfm_rate -- 
            ,sub_mode -- 
            ,sub_exp -- 
            ,interest_way -- 
            ,prd_attr -- 
            ,risk_level -- 
            ,grade -- 
            ,status -- 
            ,conv_flag -- 
            ,prd_totvol -- 
            ,tot_nav -- 
            ,curr_type -- 
            ,cost_curr_type -- 
            ,income_curr_type -- 
            ,cash_flag -- 
            ,agio_type -- 
            ,open_time -- 
            ,close_time -- 
            ,paper_no -- 
            ,paper_name -- 
            ,protocol_name -- 
            ,psub_unit -- 
            ,pfirst_amt -- 
            ,papp_amt -- 
            ,pmin_invest_amt -- 
            ,pmin_hold -- 
            ,pmin_red -- 
            ,pmax_red -- 
            ,pred_unit -- 
            ,pmin_conv_vol -- 
            ,pmin_red_vol -- 
            ,pmax_amt -- 
            ,pmax_accu_amt -- 
            ,osub_unit -- 
            ,ofirst_amt -- 
            ,oapp_amt -- 
            ,omin_invest_amt -- 
            ,omin_hold -- 
            ,omin_red -- 
            ,omax_red -- 
            ,ored_unit -- 
            ,omin_conv_vol -- 
            ,omin_red_vol -- 
            ,omax_amt -- 
            ,omax_accu_amt -- 
            ,tot_client -- 
            ,ipo_time -- 
            ,order_date -- 
            ,order_time -- 
            ,book_buy_days -- 
            ,book_sell_days -- 
            ,book_buy_date -- 
            ,book_sell_date -- 
            ,dir_order_type -- 
            ,dir_hold_day -- 
            ,dir_free_date -- 
            ,dir_start_date -- 
            ,dir_start_time -- 
            ,invest_fail_times -- 
            ,debit_account -- 
            ,crebit_account -- 
            ,red_draw_account -- 
            ,charge_account -- 
            ,manage_account -- 
            ,red_days -- 
            ,div_days -- 
            ,refund_days -- 
            ,fail_days -- 
            ,open_buy_days -- 
            ,red_arr_date -- 
            ,div_arr_date -- 
            ,refund_arr_date -- 
            ,fail_arr_date -- 
            ,open_arr_date -- 
            ,large_buy_rate -- 
            ,large_red_rate -- 
            ,real_red_amt_rate -- 
            ,real_red_vol_rate -- 
            ,real_red_max_vol -- 
            ,base_days -- 
            ,interest_days -- 
            ,manage_days -- 
            ,red_fare_rate -- 
            ,conv_fare_rate -- 
            ,manage_rate -- 
            ,total_bonus -- 
            ,cash_rate -- 
            ,money_date -- 
            ,corpus_rate -- 
            ,evend_date -- 
            ,tn_confirm -- 
            ,guest_rate -- 
            ,cycle_days -- 
            ,trans_way -- 
            ,int1 -- 
            ,int2 -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,bank_no -- 
            ,calc_income_way -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.real_prd_code, o.real_prd_code) as real_prd_code -- 
    ,nvl(n.model_flag, o.model_flag) as model_flag -- 
    ,nvl(n.model_comment, o.model_comment) as model_comment -- 
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 
    ,nvl(n.prd_name2, o.prd_name2) as prd_name2 -- 
    ,nvl(n.vol_digit, o.vol_digit) as vol_digit -- 
    ,nvl(n.amt_digit, o.amt_digit) as amt_digit -- 
    ,nvl(n.nav_digit, o.nav_digit) as nav_digit -- 
    ,nvl(n.nav, o.nav) as nav -- 
    ,nvl(n.nav_date, o.nav_date) as nav_date -- 
    ,nvl(n.nav_days, o.nav_days) as nav_days -- 
    ,nvl(n.face_value, o.face_value) as face_value -- 
    ,nvl(n.iss_price, o.iss_price) as iss_price -- 
    ,nvl(n.asso_code, o.asso_code) as asso_code -- 
    ,nvl(n.prd_sponsor, o.prd_sponsor) as prd_sponsor -- 
    ,nvl(n.prd_trustee, o.prd_trustee) as prd_trustee -- 
    ,nvl(n.prd_manager, o.prd_manager) as prd_manager -- 
    ,nvl(n.dep_id, o.dep_id) as dep_id -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.ipo_start_date, o.ipo_start_date) as ipo_start_date -- 
    ,nvl(n.ipo_end_date, o.ipo_end_date) as ipo_end_date -- 
    ,nvl(n.estab_date, o.estab_date) as estab_date -- 
    ,nvl(n.income_date, o.income_date) as income_date -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,nvl(n.interest_end_date, o.interest_end_date) as interest_end_date -- 
    ,nvl(n.income_end_date, o.income_end_date) as income_end_date -- 
    ,nvl(n.issue_fail_date, o.issue_fail_date) as issue_fail_date -- 
    ,nvl(n.alimit_end_date, o.alimit_end_date) as alimit_end_date -- 
    ,nvl(n.real_estab_date, o.real_estab_date) as real_estab_date -- 
    ,nvl(n.prd_min_bala, o.prd_min_bala) as prd_min_bala -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.prd_max_bala, o.prd_max_bala) as prd_max_bala -- 
    ,nvl(n.prd_min_shares, o.prd_min_shares) as prd_min_shares -- 
    ,nvl(n.prd_max_shares, o.prd_max_shares) as prd_max_shares -- 
    ,nvl(n.prd_issue_real_bala, o.prd_issue_real_bala) as prd_issue_real_bala -- 
    ,nvl(n.curr_scale, o.curr_scale) as curr_scale -- 
    ,nvl(n.div_modes, o.div_modes) as div_modes -- 
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 
    ,nvl(n.inst_flag, o.inst_flag) as inst_flag -- 
    ,nvl(n.limit_flag, o.limit_flag) as limit_flag -- 
    ,nvl(n.liqu_mode, o.liqu_mode) as liqu_mode -- 
    ,nvl(n.liqu_mode2, o.liqu_mode2) as liqu_mode2 -- 
    ,nvl(n.channels, o.channels) as channels -- 
    ,nvl(n.client_groups, o.client_groups) as client_groups -- 
    ,nvl(n.temp_flag, o.temp_flag) as temp_flag -- 
    ,nvl(n.control_flag, o.control_flag) as control_flag -- 
    ,nvl(n.control_flag2, o.control_flag2) as control_flag2 -- 
    ,nvl(n.share_class, o.share_class) as share_class -- 
    ,nvl(n.issue_cfm_rate, o.issue_cfm_rate) as issue_cfm_rate -- 
    ,nvl(n.sub_mode, o.sub_mode) as sub_mode -- 
    ,nvl(n.sub_exp, o.sub_exp) as sub_exp -- 
    ,nvl(n.interest_way, o.interest_way) as interest_way -- 
    ,nvl(n.prd_attr, o.prd_attr) as prd_attr -- 
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 
    ,nvl(n.grade, o.grade) as grade -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.conv_flag, o.conv_flag) as conv_flag -- 
    ,nvl(n.prd_totvol, o.prd_totvol) as prd_totvol -- 
    ,nvl(n.tot_nav, o.tot_nav) as tot_nav -- 
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 
    ,nvl(n.cost_curr_type, o.cost_curr_type) as cost_curr_type -- 
    ,nvl(n.income_curr_type, o.income_curr_type) as income_curr_type -- 
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 
    ,nvl(n.agio_type, o.agio_type) as agio_type -- 
    ,nvl(n.open_time, o.open_time) as open_time -- 
    ,nvl(n.close_time, o.close_time) as close_time -- 
    ,nvl(n.paper_no, o.paper_no) as paper_no -- 
    ,nvl(n.paper_name, o.paper_name) as paper_name -- 
    ,nvl(n.protocol_name, o.protocol_name) as protocol_name -- 
    ,nvl(n.psub_unit, o.psub_unit) as psub_unit -- 
    ,nvl(n.pfirst_amt, o.pfirst_amt) as pfirst_amt -- 
    ,nvl(n.papp_amt, o.papp_amt) as papp_amt -- 
    ,nvl(n.pmin_invest_amt, o.pmin_invest_amt) as pmin_invest_amt -- 
    ,nvl(n.pmin_hold, o.pmin_hold) as pmin_hold -- 
    ,nvl(n.pmin_red, o.pmin_red) as pmin_red -- 
    ,nvl(n.pmax_red, o.pmax_red) as pmax_red -- 
    ,nvl(n.pred_unit, o.pred_unit) as pred_unit -- 
    ,nvl(n.pmin_conv_vol, o.pmin_conv_vol) as pmin_conv_vol -- 
    ,nvl(n.pmin_red_vol, o.pmin_red_vol) as pmin_red_vol -- 
    ,nvl(n.pmax_amt, o.pmax_amt) as pmax_amt -- 
    ,nvl(n.pmax_accu_amt, o.pmax_accu_amt) as pmax_accu_amt -- 
    ,nvl(n.osub_unit, o.osub_unit) as osub_unit -- 
    ,nvl(n.ofirst_amt, o.ofirst_amt) as ofirst_amt -- 
    ,nvl(n.oapp_amt, o.oapp_amt) as oapp_amt -- 
    ,nvl(n.omin_invest_amt, o.omin_invest_amt) as omin_invest_amt -- 
    ,nvl(n.omin_hold, o.omin_hold) as omin_hold -- 
    ,nvl(n.omin_red, o.omin_red) as omin_red -- 
    ,nvl(n.omax_red, o.omax_red) as omax_red -- 
    ,nvl(n.ored_unit, o.ored_unit) as ored_unit -- 
    ,nvl(n.omin_conv_vol, o.omin_conv_vol) as omin_conv_vol -- 
    ,nvl(n.omin_red_vol, o.omin_red_vol) as omin_red_vol -- 
    ,nvl(n.omax_amt, o.omax_amt) as omax_amt -- 
    ,nvl(n.omax_accu_amt, o.omax_accu_amt) as omax_accu_amt -- 
    ,nvl(n.tot_client, o.tot_client) as tot_client -- 
    ,nvl(n.ipo_time, o.ipo_time) as ipo_time -- 
    ,nvl(n.order_date, o.order_date) as order_date -- 
    ,nvl(n.order_time, o.order_time) as order_time -- 
    ,nvl(n.book_buy_days, o.book_buy_days) as book_buy_days -- 
    ,nvl(n.book_sell_days, o.book_sell_days) as book_sell_days -- 
    ,nvl(n.book_buy_date, o.book_buy_date) as book_buy_date -- 
    ,nvl(n.book_sell_date, o.book_sell_date) as book_sell_date -- 
    ,nvl(n.dir_order_type, o.dir_order_type) as dir_order_type -- 
    ,nvl(n.dir_hold_day, o.dir_hold_day) as dir_hold_day -- 
    ,nvl(n.dir_free_date, o.dir_free_date) as dir_free_date -- 
    ,nvl(n.dir_start_date, o.dir_start_date) as dir_start_date -- 
    ,nvl(n.dir_start_time, o.dir_start_time) as dir_start_time -- 
    ,nvl(n.invest_fail_times, o.invest_fail_times) as invest_fail_times -- 
    ,nvl(n.debit_account, o.debit_account) as debit_account -- 
    ,nvl(n.crebit_account, o.crebit_account) as crebit_account -- 
    ,nvl(n.red_draw_account, o.red_draw_account) as red_draw_account -- 
    ,nvl(n.charge_account, o.charge_account) as charge_account -- 
    ,nvl(n.manage_account, o.manage_account) as manage_account -- 
    ,nvl(n.red_days, o.red_days) as red_days -- 
    ,nvl(n.div_days, o.div_days) as div_days -- 
    ,nvl(n.refund_days, o.refund_days) as refund_days -- 
    ,nvl(n.fail_days, o.fail_days) as fail_days -- 
    ,nvl(n.open_buy_days, o.open_buy_days) as open_buy_days -- 
    ,nvl(n.red_arr_date, o.red_arr_date) as red_arr_date -- 
    ,nvl(n.div_arr_date, o.div_arr_date) as div_arr_date -- 
    ,nvl(n.refund_arr_date, o.refund_arr_date) as refund_arr_date -- 
    ,nvl(n.fail_arr_date, o.fail_arr_date) as fail_arr_date -- 
    ,nvl(n.open_arr_date, o.open_arr_date) as open_arr_date -- 
    ,nvl(n.large_buy_rate, o.large_buy_rate) as large_buy_rate -- 
    ,nvl(n.large_red_rate, o.large_red_rate) as large_red_rate -- 
    ,nvl(n.real_red_amt_rate, o.real_red_amt_rate) as real_red_amt_rate -- 
    ,nvl(n.real_red_vol_rate, o.real_red_vol_rate) as real_red_vol_rate -- 
    ,nvl(n.real_red_max_vol, o.real_red_max_vol) as real_red_max_vol -- 
    ,nvl(n.base_days, o.base_days) as base_days -- 
    ,nvl(n.interest_days, o.interest_days) as interest_days -- 
    ,nvl(n.manage_days, o.manage_days) as manage_days -- 
    ,nvl(n.red_fare_rate, o.red_fare_rate) as red_fare_rate -- 
    ,nvl(n.conv_fare_rate, o.conv_fare_rate) as conv_fare_rate -- 
    ,nvl(n.manage_rate, o.manage_rate) as manage_rate -- 
    ,nvl(n.total_bonus, o.total_bonus) as total_bonus -- 
    ,nvl(n.cash_rate, o.cash_rate) as cash_rate -- 
    ,nvl(n.money_date, o.money_date) as money_date -- 
    ,nvl(n.corpus_rate, o.corpus_rate) as corpus_rate -- 
    ,nvl(n.evend_date, o.evend_date) as evend_date -- 
    ,nvl(n.tn_confirm, o.tn_confirm) as tn_confirm -- 
    ,nvl(n.guest_rate, o.guest_rate) as guest_rate -- 
    ,nvl(n.cycle_days, o.cycle_days) as cycle_days -- 
    ,nvl(n.trans_way, o.trans_way) as trans_way -- 
    ,nvl(n.int1, o.int1) as int1 -- 
    ,nvl(n.int2, o.int2) as int2 -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.amt2, o.amt2) as amt2 -- 
    ,nvl(n.amt3, o.amt3) as amt3 -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.calc_income_way, o.calc_income_way) as calc_income_way -- 
    ,case when
            n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_fds_tbproduct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_fds_tbproduct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
where (
        o.prd_code is null
    )
    or (
        n.prd_code is null
    )
    or (
        o.real_prd_code <> n.real_prd_code
        or o.model_flag <> n.model_flag
        or o.model_comment <> n.model_comment
        or o.prd_type <> n.prd_type
        or o.ta_code <> n.ta_code
        or o.prd_name <> n.prd_name
        or o.prd_name2 <> n.prd_name2
        or o.vol_digit <> n.vol_digit
        or o.amt_digit <> n.amt_digit
        or o.nav_digit <> n.nav_digit
        or o.nav <> n.nav
        or o.nav_date <> n.nav_date
        or o.nav_days <> n.nav_days
        or o.face_value <> n.face_value
        or o.iss_price <> n.iss_price
        or o.asso_code <> n.asso_code
        or o.prd_sponsor <> n.prd_sponsor
        or o.prd_trustee <> n.prd_trustee
        or o.prd_manager <> n.prd_manager
        or o.dep_id <> n.dep_id
        or o.branch_no <> n.branch_no
        or o.ipo_start_date <> n.ipo_start_date
        or o.ipo_end_date <> n.ipo_end_date
        or o.estab_date <> n.estab_date
        or o.income_date <> n.income_date
        or o.end_date <> n.end_date
        or o.interest_end_date <> n.interest_end_date
        or o.income_end_date <> n.income_end_date
        or o.issue_fail_date <> n.issue_fail_date
        or o.alimit_end_date <> n.alimit_end_date
        or o.real_estab_date <> n.real_estab_date
        or o.prd_min_bala <> n.prd_min_bala
        or o.prd_max_bala <> n.prd_max_bala
        or o.prd_min_shares <> n.prd_min_shares
        or o.prd_max_shares <> n.prd_max_shares
        or o.prd_issue_real_bala <> n.prd_issue_real_bala
        or o.curr_scale <> n.curr_scale
        or o.div_modes <> n.div_modes
        or o.div_mode <> n.div_mode
        or o.inst_flag <> n.inst_flag
        or o.limit_flag <> n.limit_flag
        or o.liqu_mode <> n.liqu_mode
        or o.liqu_mode2 <> n.liqu_mode2
        or o.channels <> n.channels
        or o.client_groups <> n.client_groups
        or o.temp_flag <> n.temp_flag
        or o.control_flag <> n.control_flag
        or o.control_flag2 <> n.control_flag2
        or o.share_class <> n.share_class
        or o.issue_cfm_rate <> n.issue_cfm_rate
        or o.sub_mode <> n.sub_mode
        or o.sub_exp <> n.sub_exp
        or o.interest_way <> n.interest_way
        or o.prd_attr <> n.prd_attr
        or o.risk_level <> n.risk_level
        or o.grade <> n.grade
        or o.status <> n.status
        or o.conv_flag <> n.conv_flag
        or o.prd_totvol <> n.prd_totvol
        or o.tot_nav <> n.tot_nav
        or o.curr_type <> n.curr_type
        or o.cost_curr_type <> n.cost_curr_type
        or o.income_curr_type <> n.income_curr_type
        or o.cash_flag <> n.cash_flag
        or o.agio_type <> n.agio_type
        or o.open_time <> n.open_time
        or o.close_time <> n.close_time
        or o.paper_no <> n.paper_no
        or o.paper_name <> n.paper_name
        or o.protocol_name <> n.protocol_name
        or o.psub_unit <> n.psub_unit
        or o.pfirst_amt <> n.pfirst_amt
        or o.papp_amt <> n.papp_amt
        or o.pmin_invest_amt <> n.pmin_invest_amt
        or o.pmin_hold <> n.pmin_hold
        or o.pmin_red <> n.pmin_red
        or o.pmax_red <> n.pmax_red
        or o.pred_unit <> n.pred_unit
        or o.pmin_conv_vol <> n.pmin_conv_vol
        or o.pmin_red_vol <> n.pmin_red_vol
        or o.pmax_amt <> n.pmax_amt
        or o.pmax_accu_amt <> n.pmax_accu_amt
        or o.osub_unit <> n.osub_unit
        or o.ofirst_amt <> n.ofirst_amt
        or o.oapp_amt <> n.oapp_amt
        or o.omin_invest_amt <> n.omin_invest_amt
        or o.omin_hold <> n.omin_hold
        or o.omin_red <> n.omin_red
        or o.omax_red <> n.omax_red
        or o.ored_unit <> n.ored_unit
        or o.omin_conv_vol <> n.omin_conv_vol
        or o.omin_red_vol <> n.omin_red_vol
        or o.omax_amt <> n.omax_amt
        or o.omax_accu_amt <> n.omax_accu_amt
        or o.tot_client <> n.tot_client
        or o.ipo_time <> n.ipo_time
        or o.order_date <> n.order_date
        or o.order_time <> n.order_time
        or o.book_buy_days <> n.book_buy_days
        or o.book_sell_days <> n.book_sell_days
        or o.book_buy_date <> n.book_buy_date
        or o.book_sell_date <> n.book_sell_date
        or o.dir_order_type <> n.dir_order_type
        or o.dir_hold_day <> n.dir_hold_day
        or o.dir_free_date <> n.dir_free_date
        or o.dir_start_date <> n.dir_start_date
        or o.dir_start_time <> n.dir_start_time
        or o.invest_fail_times <> n.invest_fail_times
        or o.debit_account <> n.debit_account
        or o.crebit_account <> n.crebit_account
        or o.red_draw_account <> n.red_draw_account
        or o.charge_account <> n.charge_account
        or o.manage_account <> n.manage_account
        or o.red_days <> n.red_days
        or o.div_days <> n.div_days
        or o.refund_days <> n.refund_days
        or o.fail_days <> n.fail_days
        or o.open_buy_days <> n.open_buy_days
        or o.red_arr_date <> n.red_arr_date
        or o.div_arr_date <> n.div_arr_date
        or o.refund_arr_date <> n.refund_arr_date
        or o.fail_arr_date <> n.fail_arr_date
        or o.open_arr_date <> n.open_arr_date
        or o.large_buy_rate <> n.large_buy_rate
        or o.large_red_rate <> n.large_red_rate
        or o.real_red_amt_rate <> n.real_red_amt_rate
        or o.real_red_vol_rate <> n.real_red_vol_rate
        or o.real_red_max_vol <> n.real_red_max_vol
        or o.base_days <> n.base_days
        or o.interest_days <> n.interest_days
        or o.manage_days <> n.manage_days
        or o.red_fare_rate <> n.red_fare_rate
        or o.conv_fare_rate <> n.conv_fare_rate
        or o.manage_rate <> n.manage_rate
        or o.total_bonus <> n.total_bonus
        or o.cash_rate <> n.cash_rate
        or o.money_date <> n.money_date
        or o.corpus_rate <> n.corpus_rate
        or o.evend_date <> n.evend_date
        or o.tn_confirm <> n.tn_confirm
        or o.guest_rate <> n.guest_rate
        or o.cycle_days <> n.cycle_days
        or o.trans_way <> n.trans_way
        or o.int1 <> n.int1
        or o.int2 <> n.int2
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.bank_no <> n.bank_no
        or o.calc_income_way <> n.calc_income_way
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbproduct_cl(
            real_prd_code -- 
            ,model_flag -- 
            ,model_comment -- 
            ,prd_type -- 
            ,ta_code -- 
            ,prd_name -- 
            ,prd_name2 -- 
            ,vol_digit -- 
            ,amt_digit -- 
            ,nav_digit -- 
            ,nav -- 
            ,nav_date -- 
            ,nav_days -- 
            ,face_value -- 
            ,iss_price -- 
            ,asso_code -- 
            ,prd_sponsor -- 
            ,prd_trustee -- 
            ,prd_manager -- 
            ,dep_id -- 
            ,branch_no -- 
            ,ipo_start_date -- 
            ,ipo_end_date -- 
            ,estab_date -- 
            ,income_date -- 
            ,end_date -- 
            ,interest_end_date -- 
            ,income_end_date -- 
            ,issue_fail_date -- 
            ,alimit_end_date -- 
            ,real_estab_date -- 
            ,prd_min_bala -- 
            ,prd_code -- 
            ,prd_max_bala -- 
            ,prd_min_shares -- 
            ,prd_max_shares -- 
            ,prd_issue_real_bala -- 
            ,curr_scale -- 
            ,div_modes -- 
            ,div_mode -- 
            ,inst_flag -- 
            ,limit_flag -- 
            ,liqu_mode -- 
            ,liqu_mode2 -- 
            ,channels -- 
            ,client_groups -- 
            ,temp_flag -- 
            ,control_flag -- 
            ,control_flag2 -- 
            ,share_class -- 
            ,issue_cfm_rate -- 
            ,sub_mode -- 
            ,sub_exp -- 
            ,interest_way -- 
            ,prd_attr -- 
            ,risk_level -- 
            ,grade -- 
            ,status -- 
            ,conv_flag -- 
            ,prd_totvol -- 
            ,tot_nav -- 
            ,curr_type -- 
            ,cost_curr_type -- 
            ,income_curr_type -- 
            ,cash_flag -- 
            ,agio_type -- 
            ,open_time -- 
            ,close_time -- 
            ,paper_no -- 
            ,paper_name -- 
            ,protocol_name -- 
            ,psub_unit -- 
            ,pfirst_amt -- 
            ,papp_amt -- 
            ,pmin_invest_amt -- 
            ,pmin_hold -- 
            ,pmin_red -- 
            ,pmax_red -- 
            ,pred_unit -- 
            ,pmin_conv_vol -- 
            ,pmin_red_vol -- 
            ,pmax_amt -- 
            ,pmax_accu_amt -- 
            ,osub_unit -- 
            ,ofirst_amt -- 
            ,oapp_amt -- 
            ,omin_invest_amt -- 
            ,omin_hold -- 
            ,omin_red -- 
            ,omax_red -- 
            ,ored_unit -- 
            ,omin_conv_vol -- 
            ,omin_red_vol -- 
            ,omax_amt -- 
            ,omax_accu_amt -- 
            ,tot_client -- 
            ,ipo_time -- 
            ,order_date -- 
            ,order_time -- 
            ,book_buy_days -- 
            ,book_sell_days -- 
            ,book_buy_date -- 
            ,book_sell_date -- 
            ,dir_order_type -- 
            ,dir_hold_day -- 
            ,dir_free_date -- 
            ,dir_start_date -- 
            ,dir_start_time -- 
            ,invest_fail_times -- 
            ,debit_account -- 
            ,crebit_account -- 
            ,red_draw_account -- 
            ,charge_account -- 
            ,manage_account -- 
            ,red_days -- 
            ,div_days -- 
            ,refund_days -- 
            ,fail_days -- 
            ,open_buy_days -- 
            ,red_arr_date -- 
            ,div_arr_date -- 
            ,refund_arr_date -- 
            ,fail_arr_date -- 
            ,open_arr_date -- 
            ,large_buy_rate -- 
            ,large_red_rate -- 
            ,real_red_amt_rate -- 
            ,real_red_vol_rate -- 
            ,real_red_max_vol -- 
            ,base_days -- 
            ,interest_days -- 
            ,manage_days -- 
            ,red_fare_rate -- 
            ,conv_fare_rate -- 
            ,manage_rate -- 
            ,total_bonus -- 
            ,cash_rate -- 
            ,money_date -- 
            ,corpus_rate -- 
            ,evend_date -- 
            ,tn_confirm -- 
            ,guest_rate -- 
            ,cycle_days -- 
            ,trans_way -- 
            ,int1 -- 
            ,int2 -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,bank_no -- 
            ,calc_income_way -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbproduct_op(
            real_prd_code -- 
            ,model_flag -- 
            ,model_comment -- 
            ,prd_type -- 
            ,ta_code -- 
            ,prd_name -- 
            ,prd_name2 -- 
            ,vol_digit -- 
            ,amt_digit -- 
            ,nav_digit -- 
            ,nav -- 
            ,nav_date -- 
            ,nav_days -- 
            ,face_value -- 
            ,iss_price -- 
            ,asso_code -- 
            ,prd_sponsor -- 
            ,prd_trustee -- 
            ,prd_manager -- 
            ,dep_id -- 
            ,branch_no -- 
            ,ipo_start_date -- 
            ,ipo_end_date -- 
            ,estab_date -- 
            ,income_date -- 
            ,end_date -- 
            ,interest_end_date -- 
            ,income_end_date -- 
            ,issue_fail_date -- 
            ,alimit_end_date -- 
            ,real_estab_date -- 
            ,prd_min_bala -- 
            ,prd_code -- 
            ,prd_max_bala -- 
            ,prd_min_shares -- 
            ,prd_max_shares -- 
            ,prd_issue_real_bala -- 
            ,curr_scale -- 
            ,div_modes -- 
            ,div_mode -- 
            ,inst_flag -- 
            ,limit_flag -- 
            ,liqu_mode -- 
            ,liqu_mode2 -- 
            ,channels -- 
            ,client_groups -- 
            ,temp_flag -- 
            ,control_flag -- 
            ,control_flag2 -- 
            ,share_class -- 
            ,issue_cfm_rate -- 
            ,sub_mode -- 
            ,sub_exp -- 
            ,interest_way -- 
            ,prd_attr -- 
            ,risk_level -- 
            ,grade -- 
            ,status -- 
            ,conv_flag -- 
            ,prd_totvol -- 
            ,tot_nav -- 
            ,curr_type -- 
            ,cost_curr_type -- 
            ,income_curr_type -- 
            ,cash_flag -- 
            ,agio_type -- 
            ,open_time -- 
            ,close_time -- 
            ,paper_no -- 
            ,paper_name -- 
            ,protocol_name -- 
            ,psub_unit -- 
            ,pfirst_amt -- 
            ,papp_amt -- 
            ,pmin_invest_amt -- 
            ,pmin_hold -- 
            ,pmin_red -- 
            ,pmax_red -- 
            ,pred_unit -- 
            ,pmin_conv_vol -- 
            ,pmin_red_vol -- 
            ,pmax_amt -- 
            ,pmax_accu_amt -- 
            ,osub_unit -- 
            ,ofirst_amt -- 
            ,oapp_amt -- 
            ,omin_invest_amt -- 
            ,omin_hold -- 
            ,omin_red -- 
            ,omax_red -- 
            ,ored_unit -- 
            ,omin_conv_vol -- 
            ,omin_red_vol -- 
            ,omax_amt -- 
            ,omax_accu_amt -- 
            ,tot_client -- 
            ,ipo_time -- 
            ,order_date -- 
            ,order_time -- 
            ,book_buy_days -- 
            ,book_sell_days -- 
            ,book_buy_date -- 
            ,book_sell_date -- 
            ,dir_order_type -- 
            ,dir_hold_day -- 
            ,dir_free_date -- 
            ,dir_start_date -- 
            ,dir_start_time -- 
            ,invest_fail_times -- 
            ,debit_account -- 
            ,crebit_account -- 
            ,red_draw_account -- 
            ,charge_account -- 
            ,manage_account -- 
            ,red_days -- 
            ,div_days -- 
            ,refund_days -- 
            ,fail_days -- 
            ,open_buy_days -- 
            ,red_arr_date -- 
            ,div_arr_date -- 
            ,refund_arr_date -- 
            ,fail_arr_date -- 
            ,open_arr_date -- 
            ,large_buy_rate -- 
            ,large_red_rate -- 
            ,real_red_amt_rate -- 
            ,real_red_vol_rate -- 
            ,real_red_max_vol -- 
            ,base_days -- 
            ,interest_days -- 
            ,manage_days -- 
            ,red_fare_rate -- 
            ,conv_fare_rate -- 
            ,manage_rate -- 
            ,total_bonus -- 
            ,cash_rate -- 
            ,money_date -- 
            ,corpus_rate -- 
            ,evend_date -- 
            ,tn_confirm -- 
            ,guest_rate -- 
            ,cycle_days -- 
            ,trans_way -- 
            ,int1 -- 
            ,int2 -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,bank_no -- 
            ,calc_income_way -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.real_prd_code -- 
    ,o.model_flag -- 
    ,o.model_comment -- 
    ,o.prd_type -- 
    ,o.ta_code -- 
    ,o.prd_name -- 
    ,o.prd_name2 -- 
    ,o.vol_digit -- 
    ,o.amt_digit -- 
    ,o.nav_digit -- 
    ,o.nav -- 
    ,o.nav_date -- 
    ,o.nav_days -- 
    ,o.face_value -- 
    ,o.iss_price -- 
    ,o.asso_code -- 
    ,o.prd_sponsor -- 
    ,o.prd_trustee -- 
    ,o.prd_manager -- 
    ,o.dep_id -- 
    ,o.branch_no -- 
    ,o.ipo_start_date -- 
    ,o.ipo_end_date -- 
    ,o.estab_date -- 
    ,o.income_date -- 
    ,o.end_date -- 
    ,o.interest_end_date -- 
    ,o.income_end_date -- 
    ,o.issue_fail_date -- 
    ,o.alimit_end_date -- 
    ,o.real_estab_date -- 
    ,o.prd_min_bala -- 
    ,o.prd_code -- 
    ,o.prd_max_bala -- 
    ,o.prd_min_shares -- 
    ,o.prd_max_shares -- 
    ,o.prd_issue_real_bala -- 
    ,o.curr_scale -- 
    ,o.div_modes -- 
    ,o.div_mode -- 
    ,o.inst_flag -- 
    ,o.limit_flag -- 
    ,o.liqu_mode -- 
    ,o.liqu_mode2 -- 
    ,o.channels -- 
    ,o.client_groups -- 
    ,o.temp_flag -- 
    ,o.control_flag -- 
    ,o.control_flag2 -- 
    ,o.share_class -- 
    ,o.issue_cfm_rate -- 
    ,o.sub_mode -- 
    ,o.sub_exp -- 
    ,o.interest_way -- 
    ,o.prd_attr -- 
    ,o.risk_level -- 
    ,o.grade -- 
    ,o.status -- 
    ,o.conv_flag -- 
    ,o.prd_totvol -- 
    ,o.tot_nav -- 
    ,o.curr_type -- 
    ,o.cost_curr_type -- 
    ,o.income_curr_type -- 
    ,o.cash_flag -- 
    ,o.agio_type -- 
    ,o.open_time -- 
    ,o.close_time -- 
    ,o.paper_no -- 
    ,o.paper_name -- 
    ,o.protocol_name -- 
    ,o.psub_unit -- 
    ,o.pfirst_amt -- 
    ,o.papp_amt -- 
    ,o.pmin_invest_amt -- 
    ,o.pmin_hold -- 
    ,o.pmin_red -- 
    ,o.pmax_red -- 
    ,o.pred_unit -- 
    ,o.pmin_conv_vol -- 
    ,o.pmin_red_vol -- 
    ,o.pmax_amt -- 
    ,o.pmax_accu_amt -- 
    ,o.osub_unit -- 
    ,o.ofirst_amt -- 
    ,o.oapp_amt -- 
    ,o.omin_invest_amt -- 
    ,o.omin_hold -- 
    ,o.omin_red -- 
    ,o.omax_red -- 
    ,o.ored_unit -- 
    ,o.omin_conv_vol -- 
    ,o.omin_red_vol -- 
    ,o.omax_amt -- 
    ,o.omax_accu_amt -- 
    ,o.tot_client -- 
    ,o.ipo_time -- 
    ,o.order_date -- 
    ,o.order_time -- 
    ,o.book_buy_days -- 
    ,o.book_sell_days -- 
    ,o.book_buy_date -- 
    ,o.book_sell_date -- 
    ,o.dir_order_type -- 
    ,o.dir_hold_day -- 
    ,o.dir_free_date -- 
    ,o.dir_start_date -- 
    ,o.dir_start_time -- 
    ,o.invest_fail_times -- 
    ,o.debit_account -- 
    ,o.crebit_account -- 
    ,o.red_draw_account -- 
    ,o.charge_account -- 
    ,o.manage_account -- 
    ,o.red_days -- 
    ,o.div_days -- 
    ,o.refund_days -- 
    ,o.fail_days -- 
    ,o.open_buy_days -- 
    ,o.red_arr_date -- 
    ,o.div_arr_date -- 
    ,o.refund_arr_date -- 
    ,o.fail_arr_date -- 
    ,o.open_arr_date -- 
    ,o.large_buy_rate -- 
    ,o.large_red_rate -- 
    ,o.real_red_amt_rate -- 
    ,o.real_red_vol_rate -- 
    ,o.real_red_max_vol -- 
    ,o.base_days -- 
    ,o.interest_days -- 
    ,o.manage_days -- 
    ,o.red_fare_rate -- 
    ,o.conv_fare_rate -- 
    ,o.manage_rate -- 
    ,o.total_bonus -- 
    ,o.cash_rate -- 
    ,o.money_date -- 
    ,o.corpus_rate -- 
    ,o.evend_date -- 
    ,o.tn_confirm -- 
    ,o.guest_rate -- 
    ,o.cycle_days -- 
    ,o.trans_way -- 
    ,o.int1 -- 
    ,o.int2 -- 
    ,o.amt1 -- 
    ,o.amt2 -- 
    ,o.amt3 -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.reserve5 -- 
    ,o.bank_no -- 
    ,o.calc_income_way -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_fds_tbproduct_bk o
    left join ${iol_schema}.ifms_fds_tbproduct_op n
        on
            o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_fds_tbproduct_cl d
        on
            o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_fds_tbproduct;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_fds_tbproduct exchange partition p_19000101 with table ${iol_schema}.ifms_fds_tbproduct_cl;
alter table ${iol_schema}.ifms_fds_tbproduct exchange partition p_20991231 with table ${iol_schema}.ifms_fds_tbproduct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_fds_tbproduct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbproduct_op purge;
drop table ${iol_schema}.ifms_fds_tbproduct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_fds_tbproduct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_fds_tbproduct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
