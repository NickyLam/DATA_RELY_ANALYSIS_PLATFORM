/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbproduct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbproduct
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbproduct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbproduct(
    prd_code varchar2(32) -- 
    ,model_flag varchar2(2) -- 
    ,model_comment varchar2(768) -- 
    ,prd_type varchar2(2) -- 
    ,ta_code varchar2(18) -- 
    ,prd_name varchar2(375) -- 
    ,prd_name2 varchar2(375) -- 
    ,vol_digit number(22) -- 
    ,amt_digit number(22) -- 
    ,nav_digit number(22) -- 
    ,nav number(18,8) -- 
    ,nav_date number(22) -- 
    ,nav_days number(22) -- 
    ,face_value number(18,8) -- 
    ,iss_price number(22,8) -- 
    ,asso_code varchar2(30) -- 
    ,prd_sponsor varchar2(18) -- 
    ,prd_trustee varchar2(40) -- 
    ,prd_manager varchar2(18) -- 
    ,dep_id varchar2(256) -- 
    ,branch_no varchar2(24) -- 
    ,ipo_start_date number(22) -- 
    ,ipo_end_date number(22) -- 
    ,estab_date number(22) -- 
    ,income_date number(22) -- 
    ,end_date number(22) -- 
    ,interest_end_date number(22) -- 
    ,income_end_date number(22) -- 
    ,issue_fail_date number(22) -- 
    ,alimit_end_date number(22) -- 
    ,real_estab_date number(22) -- 
    ,prd_min_bala number(18,2) -- 
    ,prd_max_bala number(18,2) -- 
    ,prd_min_shares number(18,3) -- 
    ,prd_max_shares number(18,3) -- 
    ,prd_issue_real_bala number(18,2) -- 
    ,curr_scale number(18,2) -- 
    ,div_modes varchar2(12) -- 
    ,div_mode varchar2(2) -- 
    ,inst_flag varchar2(2) -- 
    ,limit_flag varchar2(2) -- 
    ,liqu_mode varchar2(2) -- 
    ,liqu_mode2 varchar2(2) -- 
    ,channels varchar2(75) -- 
    ,client_groups varchar2(48) -- 
    ,temp_flag varchar2(2) -- 
    ,control_flag varchar2(512) -- 
    ,control_flag2 varchar2(375) -- 
    ,share_class varchar2(3) -- 
    ,issue_cfm_rate number(9,8) -- 
    ,sub_mode varchar2(2) -- 
    ,sub_exp varchar2(2) -- 
    ,interest_way varchar2(2) -- 
    ,prd_attr varchar2(2) -- 
    ,risk_level number(22) -- 
    ,grade varchar2(2) -- 
    ,status varchar2(2) -- 
    ,conv_flag varchar2(2) -- 
    ,prd_totvol number(18,3) -- 
    ,tot_nav number(23,8) -- 
    ,curr_type varchar2(5) -- 
    ,cost_curr_type varchar2(5) -- 
    ,income_curr_type varchar2(5) -- 
    ,cash_flag varchar2(2) -- 
    ,agio_type varchar2(2) -- 
    ,open_time number(22) -- 
    ,close_time number(22) -- 
    ,paper_no number(22) -- 
    ,paper_name varchar2(375) -- 
    ,protocol_name varchar2(375) -- 
    ,psub_unit number(24,2) -- 
    ,pfirst_amt number(18,2) -- 
    ,papp_amt number(18,2) -- 
    ,pmin_invest_amt number(18,2) -- 
    ,pmin_hold number(18,3) -- 
    ,pmin_red number(18,3) -- 
    ,pmax_red number(18,3) -- 
    ,pred_unit number(18,3) -- 
    ,pmin_conv_vol number(18,3) -- 
    ,pmin_red_vol number(18,3) -- 
    ,pmax_amt number(18,2) -- 
    ,pmax_accu_amt number(18,2) -- 
    ,osub_unit number(24,2) -- 
    ,ofirst_amt number(18,2) -- 
    ,oapp_amt number(18,2) -- 
    ,omin_invest_amt number(18,2) -- 
    ,omin_hold number(18,3) -- 
    ,omin_red number(18,3) -- 
    ,omax_red number(18,3) -- 
    ,ored_unit number(18,3) -- 
    ,omin_conv_vol number(18,3) -- 
    ,omin_red_vol number(18,3) -- 
    ,omax_amt number(18,2) -- 
    ,omax_accu_amt number(18,2) -- 
    ,tot_client number(22) -- 
    ,ipo_time number(22) -- 
    ,order_date number(22) -- 
    ,order_time number(22) -- 
    ,book_buy_days number(22) -- 
    ,book_sell_days number(22) -- 
    ,book_buy_date number(22) -- 
    ,book_sell_date number(22) -- 
    ,dir_order_type varchar2(2) -- 
    ,dir_hold_day number(22) -- 
    ,dir_free_date number(22) -- 
    ,dir_start_date number(22) -- 
    ,dir_start_time number(22) -- 
    ,invest_fail_times number(22) -- 
    ,debit_account varchar2(48) -- 
    ,crebit_account varchar2(48) -- 
    ,red_draw_account varchar2(48) -- 
    ,charge_account varchar2(48) -- 
    ,manage_account varchar2(48) -- 
    ,red_days number(22) -- 
    ,div_days number(22) -- 
    ,refund_days number(22) -- 
    ,fail_days number(22) -- 
    ,open_buy_days number(22) -- 
    ,red_arr_date number(22) -- 
    ,div_arr_date number(22) -- 
    ,refund_arr_date number(22) -- 
    ,fail_arr_date number(22) -- 
    ,open_arr_date number(22) -- 
    ,large_buy_rate number(9,8) -- 
    ,large_red_rate number(9,8) -- 
    ,real_red_amt_rate number(9,8) -- 
    ,real_red_vol_rate number(9,8) -- 
    ,real_red_max_vol number(18,3) -- 
    ,base_days number(22) -- 
    ,interest_days number(22) -- 
    ,manage_days number(22) -- 
    ,red_fare_rate number(5,4) -- 
    ,conv_fare_rate number(5,4) -- 
    ,manage_rate number(5,4) -- 
    ,total_bonus number(18,8) -- 
    ,cash_rate varchar2(2) -- 
    ,money_date number(22) -- 
    ,corpus_rate number(5,4) -- 
    ,evend_date number(22) -- 
    ,tn_confirm number(22) -- 
    ,guest_rate number(18,8) -- 
    ,cycle_days number(22) -- 
    ,trans_way varchar2(2) -- 
    ,int1 number(22) -- 
    ,int2 number(22) -- 
    ,amt1 number(22,6) -- 
    ,amt2 number(22,6) -- 
    ,amt3 number(22,6) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifms_tbproduct to ${iml_schema};
grant select on ${iol_schema}.ifms_tbproduct to ${icl_schema};
grant select on ${iol_schema}.ifms_tbproduct to ${idl_schema};
grant select on ${iol_schema}.ifms_tbproduct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbproduct is '产品信息表';
comment on column ${iol_schema}.ifms_tbproduct.prd_code is '';
comment on column ${iol_schema}.ifms_tbproduct.model_flag is '';
comment on column ${iol_schema}.ifms_tbproduct.model_comment is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_type is '';
comment on column ${iol_schema}.ifms_tbproduct.ta_code is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_name is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_name2 is '';
comment on column ${iol_schema}.ifms_tbproduct.vol_digit is '';
comment on column ${iol_schema}.ifms_tbproduct.amt_digit is '';
comment on column ${iol_schema}.ifms_tbproduct.nav_digit is '';
comment on column ${iol_schema}.ifms_tbproduct.nav is '';
comment on column ${iol_schema}.ifms_tbproduct.nav_date is '';
comment on column ${iol_schema}.ifms_tbproduct.nav_days is '';
comment on column ${iol_schema}.ifms_tbproduct.face_value is '';
comment on column ${iol_schema}.ifms_tbproduct.iss_price is '';
comment on column ${iol_schema}.ifms_tbproduct.asso_code is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_sponsor is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_trustee is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_manager is '';
comment on column ${iol_schema}.ifms_tbproduct.dep_id is '';
comment on column ${iol_schema}.ifms_tbproduct.branch_no is '';
comment on column ${iol_schema}.ifms_tbproduct.ipo_start_date is '';
comment on column ${iol_schema}.ifms_tbproduct.ipo_end_date is '';
comment on column ${iol_schema}.ifms_tbproduct.estab_date is '';
comment on column ${iol_schema}.ifms_tbproduct.income_date is '';
comment on column ${iol_schema}.ifms_tbproduct.end_date is '';
comment on column ${iol_schema}.ifms_tbproduct.interest_end_date is '';
comment on column ${iol_schema}.ifms_tbproduct.income_end_date is '';
comment on column ${iol_schema}.ifms_tbproduct.issue_fail_date is '';
comment on column ${iol_schema}.ifms_tbproduct.alimit_end_date is '';
comment on column ${iol_schema}.ifms_tbproduct.real_estab_date is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_min_bala is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_max_bala is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_min_shares is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_max_shares is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_issue_real_bala is '';
comment on column ${iol_schema}.ifms_tbproduct.curr_scale is '';
comment on column ${iol_schema}.ifms_tbproduct.div_modes is '';
comment on column ${iol_schema}.ifms_tbproduct.div_mode is '';
comment on column ${iol_schema}.ifms_tbproduct.inst_flag is '';
comment on column ${iol_schema}.ifms_tbproduct.limit_flag is '';
comment on column ${iol_schema}.ifms_tbproduct.liqu_mode is '';
comment on column ${iol_schema}.ifms_tbproduct.liqu_mode2 is '';
comment on column ${iol_schema}.ifms_tbproduct.channels is '';
comment on column ${iol_schema}.ifms_tbproduct.client_groups is '';
comment on column ${iol_schema}.ifms_tbproduct.temp_flag is '';
comment on column ${iol_schema}.ifms_tbproduct.control_flag is '';
comment on column ${iol_schema}.ifms_tbproduct.control_flag2 is '';
comment on column ${iol_schema}.ifms_tbproduct.share_class is '';
comment on column ${iol_schema}.ifms_tbproduct.issue_cfm_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.sub_mode is '';
comment on column ${iol_schema}.ifms_tbproduct.sub_exp is '';
comment on column ${iol_schema}.ifms_tbproduct.interest_way is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_attr is '';
comment on column ${iol_schema}.ifms_tbproduct.risk_level is '';
comment on column ${iol_schema}.ifms_tbproduct.grade is '';
comment on column ${iol_schema}.ifms_tbproduct.status is '';
comment on column ${iol_schema}.ifms_tbproduct.conv_flag is '';
comment on column ${iol_schema}.ifms_tbproduct.prd_totvol is '';
comment on column ${iol_schema}.ifms_tbproduct.tot_nav is '';
comment on column ${iol_schema}.ifms_tbproduct.curr_type is '';
comment on column ${iol_schema}.ifms_tbproduct.cost_curr_type is '';
comment on column ${iol_schema}.ifms_tbproduct.income_curr_type is '';
comment on column ${iol_schema}.ifms_tbproduct.cash_flag is '';
comment on column ${iol_schema}.ifms_tbproduct.agio_type is '';
comment on column ${iol_schema}.ifms_tbproduct.open_time is '';
comment on column ${iol_schema}.ifms_tbproduct.close_time is '';
comment on column ${iol_schema}.ifms_tbproduct.paper_no is '';
comment on column ${iol_schema}.ifms_tbproduct.paper_name is '';
comment on column ${iol_schema}.ifms_tbproduct.protocol_name is '';
comment on column ${iol_schema}.ifms_tbproduct.psub_unit is '';
comment on column ${iol_schema}.ifms_tbproduct.pfirst_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.papp_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.pmin_invest_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.pmin_hold is '';
comment on column ${iol_schema}.ifms_tbproduct.pmin_red is '';
comment on column ${iol_schema}.ifms_tbproduct.pmax_red is '';
comment on column ${iol_schema}.ifms_tbproduct.pred_unit is '';
comment on column ${iol_schema}.ifms_tbproduct.pmin_conv_vol is '';
comment on column ${iol_schema}.ifms_tbproduct.pmin_red_vol is '';
comment on column ${iol_schema}.ifms_tbproduct.pmax_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.pmax_accu_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.osub_unit is '';
comment on column ${iol_schema}.ifms_tbproduct.ofirst_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.oapp_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.omin_invest_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.omin_hold is '';
comment on column ${iol_schema}.ifms_tbproduct.omin_red is '';
comment on column ${iol_schema}.ifms_tbproduct.omax_red is '';
comment on column ${iol_schema}.ifms_tbproduct.ored_unit is '';
comment on column ${iol_schema}.ifms_tbproduct.omin_conv_vol is '';
comment on column ${iol_schema}.ifms_tbproduct.omin_red_vol is '';
comment on column ${iol_schema}.ifms_tbproduct.omax_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.omax_accu_amt is '';
comment on column ${iol_schema}.ifms_tbproduct.tot_client is '';
comment on column ${iol_schema}.ifms_tbproduct.ipo_time is '';
comment on column ${iol_schema}.ifms_tbproduct.order_date is '';
comment on column ${iol_schema}.ifms_tbproduct.order_time is '';
comment on column ${iol_schema}.ifms_tbproduct.book_buy_days is '';
comment on column ${iol_schema}.ifms_tbproduct.book_sell_days is '';
comment on column ${iol_schema}.ifms_tbproduct.book_buy_date is '';
comment on column ${iol_schema}.ifms_tbproduct.book_sell_date is '';
comment on column ${iol_schema}.ifms_tbproduct.dir_order_type is '';
comment on column ${iol_schema}.ifms_tbproduct.dir_hold_day is '';
comment on column ${iol_schema}.ifms_tbproduct.dir_free_date is '';
comment on column ${iol_schema}.ifms_tbproduct.dir_start_date is '';
comment on column ${iol_schema}.ifms_tbproduct.dir_start_time is '';
comment on column ${iol_schema}.ifms_tbproduct.invest_fail_times is '';
comment on column ${iol_schema}.ifms_tbproduct.debit_account is '';
comment on column ${iol_schema}.ifms_tbproduct.crebit_account is '';
comment on column ${iol_schema}.ifms_tbproduct.red_draw_account is '';
comment on column ${iol_schema}.ifms_tbproduct.charge_account is '';
comment on column ${iol_schema}.ifms_tbproduct.manage_account is '';
comment on column ${iol_schema}.ifms_tbproduct.red_days is '';
comment on column ${iol_schema}.ifms_tbproduct.div_days is '';
comment on column ${iol_schema}.ifms_tbproduct.refund_days is '';
comment on column ${iol_schema}.ifms_tbproduct.fail_days is '';
comment on column ${iol_schema}.ifms_tbproduct.open_buy_days is '';
comment on column ${iol_schema}.ifms_tbproduct.red_arr_date is '';
comment on column ${iol_schema}.ifms_tbproduct.div_arr_date is '';
comment on column ${iol_schema}.ifms_tbproduct.refund_arr_date is '';
comment on column ${iol_schema}.ifms_tbproduct.fail_arr_date is '';
comment on column ${iol_schema}.ifms_tbproduct.open_arr_date is '';
comment on column ${iol_schema}.ifms_tbproduct.large_buy_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.large_red_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.real_red_amt_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.real_red_vol_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.real_red_max_vol is '';
comment on column ${iol_schema}.ifms_tbproduct.base_days is '';
comment on column ${iol_schema}.ifms_tbproduct.interest_days is '';
comment on column ${iol_schema}.ifms_tbproduct.manage_days is '';
comment on column ${iol_schema}.ifms_tbproduct.red_fare_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.conv_fare_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.manage_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.total_bonus is '';
comment on column ${iol_schema}.ifms_tbproduct.cash_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.money_date is '';
comment on column ${iol_schema}.ifms_tbproduct.corpus_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.evend_date is '';
comment on column ${iol_schema}.ifms_tbproduct.tn_confirm is '';
comment on column ${iol_schema}.ifms_tbproduct.guest_rate is '';
comment on column ${iol_schema}.ifms_tbproduct.cycle_days is '';
comment on column ${iol_schema}.ifms_tbproduct.trans_way is '';
comment on column ${iol_schema}.ifms_tbproduct.int1 is '';
comment on column ${iol_schema}.ifms_tbproduct.int2 is '';
comment on column ${iol_schema}.ifms_tbproduct.amt1 is '';
comment on column ${iol_schema}.ifms_tbproduct.amt2 is '';
comment on column ${iol_schema}.ifms_tbproduct.amt3 is '';
comment on column ${iol_schema}.ifms_tbproduct.reserve1 is '';
comment on column ${iol_schema}.ifms_tbproduct.reserve2 is '';
comment on column ${iol_schema}.ifms_tbproduct.reserve3 is '';
comment on column ${iol_schema}.ifms_tbproduct.reserve4 is '';
comment on column ${iol_schema}.ifms_tbproduct.reserve5 is '';
comment on column ${iol_schema}.ifms_tbproduct.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbproduct.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbproduct.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbproduct.etl_timestamp is 'ETL处理时间戳';
