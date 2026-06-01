/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_upps_t_txn_credit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_upps_t_txn_credit
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_upps_t_txn_credit purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_upps_t_txn_credit(
    id number(20,0) -- 
    ,global_no varchar2(64) -- 
    ,txn_no varchar2(64) -- 
    ,txn_date varchar2(8) -- 
    ,txn_time varchar2(6) -- 
    ,txn_type varchar2(2) -- 
    ,corporate varchar2(64) -- 
    ,mcht_no varchar2(32) -- 
    ,product_no varchar2(32) -- 
    ,tran_no varchar2(64) -- 
    ,tran_date varchar2(8) -- 
    ,tran_time varchar2(20) -- 
    ,status varchar2(30) -- 
    ,biz_status varchar2(30) -- 
    ,trade_type varchar2(24) -- 
    ,route_type varchar2(6) -- 
    ,priority varchar2(2) -- 
    ,work_date varchar2(8) -- 
    ,amount number(20,2) -- 
    ,currency varchar2(6) -- 
    ,payee_acct_no varchar2(32) -- 
    ,payee_acct_name varchar2(192) -- 
    ,payee_acct_type varchar2(30) -- 
    ,payee_host_type varchar2(30) -- 
    ,payee_bank_code varchar2(24) -- 
    ,payer_acct_no varchar2(32) -- 
    ,payer_acct_name varchar2(192) -- 
    ,payer_acct_type varchar2(30) -- 
    ,payer_host_type varchar2(30) -- 
    ,payer_phone varchar2(24) -- 
    ,payer_valid_date varchar2(8) -- 
    ,payer_cvn2 varchar2(4) -- 
    ,payer_bank_code varchar2(24) -- 
    ,real_payer_acct_no varchar2(32) -- 
    ,real_payer_acct_name varchar2(192) -- 
    ,real_payer_acct_type varchar2(30) -- 
    ,real_payer_host_type varchar2(30) -- 
    ,ret_code varchar2(60) -- 
    ,ret_msg varchar2(1536) -- 
    ,is_limited varchar2(2) -- 
    ,action_type varchar2(24) -- 
    ,host_status varchar2(30) -- 
    ,account_cnt number(10,0) -- 
    ,host_code_list varchar2(120) -- 
    ,host_no varchar2(64) -- 
    ,reverse_no varchar2(64) -- 
    ,refunded varchar2(2) -- 
    ,pmc_code varchar2(12) -- 
    ,pmc_no varchar2(64) -- 
    ,pmc_status varchar2(30) -- 
    ,pmc_ret_code varchar2(24) -- 
    ,pmc_ret_msg varchar2(1536) -- 
    ,pmc_date varchar2(8) -- 
    ,pmc_time varchar2(6) -- 
    ,pmc_cost number(20,2) -- 
    ,mcht_fee number(20,2) -- 
    ,fee_no varchar2(64) -- 
    ,fee_status varchar2(12) -- 
    ,charge_type varchar2(2) -- 
    ,check_date varchar2(8) -- 
    ,checked varchar2(2) -- 
    ,check_state varchar2(12) -- 
    ,is_charge varchar2(1) -- 
    ,is_delay varchar2(1) -- 
    ,delay_time varchar2(12) -- 
    ,fee_amount number(20,2) -- 
    ,chl_checking_code varchar2(30) -- 
    ,chl_check_date varchar2(8) -- 
    ,auth_teller_no varchar2(30) -- 
    ,check_teller_no varchar2(30) -- 
    ,trans_org_no varchar2(30) -- 
    ,summery_code varchar2(30) -- 
    ,consumer_id varchar2(30) -- 
    ,is_notify varchar2(2) -- 
    ,notify_addr varchar2(100) -- 
    ,notify_service_name varchar2(60) -- 
    ,payer_ext_map_id varchar2(60) -- 
    ,payee_ext_map_id varchar2(60) -- 
    ,route_map_id varchar2(60) -- 
    ,host_desc varchar2(256) -- 
    ,channel_desc varchar2(256) -- 
    ,balance_desc varchar2(256) -- 
    ,check_time date -- 
    ,buiness_module varchar2(32) -- 
    ,init_mcht_no varchar2(64) -- 
    ,sys_comm_no varchar2(64) -- 
    ,pmc_ret_no varchar2(64) -- 
    ,pmc_ret_date varchar2(8) -- 
    ,pmc_ret_time varchar2(20) -- 
    ,pmc_ret_status varchar2(20) -- 
    ,mcht_check_mode varchar2(32) -- 
    ,payer_bank_name varchar2(256) -- 
    ,payee_bank_name varchar2(256) -- 
    ,check_flag varchar2(30) -- 
    ,host_date varchar2(8) -- 
    ,host_time varchar2(6) -- 
    ,acc_bean_json varchar2(3000) -- 
    ,clear_date varchar2(8) -- 
    ,cleared varchar2(2) -- 
    ,clear_no varchar2(64) -- 
    ,clear_type varchar2(2) -- 
    ,clear_cycle number(11,0) -- 
    ,teller_no varchar2(64) -- 
    ,payee_phone varchar2(24) -- 
    ,payee_valid_date varchar2(8) -- 
    ,payee_cvn2 varchar2(4) -- 
    ,biz_type varchar2(24) -- 
    ,sign_no varchar2(64) -- 
    ,batch_no varchar2(64) -- 
    ,purpose varchar2(128) -- 
    ,log_id varchar2(64) -- 
    ,server_id varchar2(64) -- 
    ,sharding varchar2(64) -- 
    ,remark varchar2(128) -- 
    ,create_time date -- 
    ,update_time date -- 
    ,trace_msg varchar2(256) -- 
    ,checking_code varchar2(24) -- 
    ,advance_flag varchar2(4) -- 
    ,biz_sys_code varchar2(24) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_upps_t_txn_credit to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_upps_t_txn_credit is '平台贷记类交易交互流水表';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.id is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.global_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.txn_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.txn_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.txn_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.txn_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.corporate is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.mcht_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.product_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.tran_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.tran_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.tran_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.status is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.biz_status is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.trade_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.route_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.priority is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.work_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.amount is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.currency is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_acct_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_acct_name is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_acct_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_host_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_bank_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_acct_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_acct_name is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_acct_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_host_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_phone is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_valid_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_cvn2 is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_bank_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.real_payer_acct_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.real_payer_acct_name is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.real_payer_acct_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.real_payer_host_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.ret_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.ret_msg is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.is_limited is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.action_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.host_status is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.account_cnt is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.host_code_list is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.host_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.reverse_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.refunded is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_status is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_ret_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_ret_msg is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_cost is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.mcht_fee is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.fee_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.fee_status is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.charge_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.check_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.checked is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.check_state is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.is_charge is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.is_delay is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.delay_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.fee_amount is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.chl_checking_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.chl_check_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.auth_teller_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.check_teller_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.trans_org_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.summery_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.consumer_id is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.is_notify is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.notify_addr is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.notify_service_name is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_ext_map_id is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_ext_map_id is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.route_map_id is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.host_desc is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.channel_desc is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.balance_desc is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.check_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.buiness_module is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.init_mcht_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.sys_comm_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_ret_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_ret_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_ret_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.pmc_ret_status is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.mcht_check_mode is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payer_bank_name is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_bank_name is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.check_flag is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.host_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.host_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.acc_bean_json is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.clear_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.cleared is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.clear_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.clear_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.clear_cycle is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.teller_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_phone is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_valid_date is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.payee_cvn2 is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.biz_type is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.sign_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.batch_no is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.purpose is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.log_id is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.server_id is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.sharding is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.remark is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.create_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.update_time is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.trace_msg is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.checking_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.advance_flag is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.biz_sys_code is '';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_upps_t_txn_credit.etl_timestamp is 'ETL处理时间戳';