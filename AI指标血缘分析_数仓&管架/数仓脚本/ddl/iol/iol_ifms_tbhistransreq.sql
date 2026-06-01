/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbhistransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbhistransreq
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbhistransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhistransreq(
    serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,contract_no varchar2(48) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,occur_init_date number(22) -- 
    ,seller_code varchar2(14) -- 
    ,trans_code varchar2(32) -- 
    ,control_flag varchar2(512) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(80) -- 
    ,ta_code varchar2(18) -- 
    ,asset_acc varchar2(30) -- 
    ,in_client_no varchar2(30) -- 
    ,client_type varchar2(2) -- 
    ,id_type varchar2(3) -- 
    ,id_code varchar2(50) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,cash_flag varchar2(2) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,channel varchar2(2) -- 
    ,term_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,auth_oper varchar2(48) -- 
    ,prd_code varchar2(32) -- 
    ,curr_type varchar2(5) -- 
    ,prd_type varchar2(2) -- 
    ,share_class varchar2(3) -- 
    ,asso_date number(22) -- 
    ,asso_serial varchar2(48) -- 
    ,asso_serial2 varchar2(48) -- 
    ,asso_serial3 varchar2(48) -- 
    ,amt number(18,2) -- 
    ,manage_charge number(18,2) -- 
    ,manage_charge2 number(18,2) -- 
    ,agio number(5,4) -- 
    ,client_group varchar2(10) -- 
    ,liqu_status varchar2(2) -- 
    ,ori_channel varchar2(2) -- 
    ,ori_branch_no varchar2(24) -- 
    ,vol number(18,3) -- 
    ,larg_red_flag varchar2(2) -- 
    ,red_mode varchar2(2) -- 
    ,prd_price number(22,8) -- 
    ,amt_ratio number(18,8) -- 
    ,div_mode varchar2(2) -- 
    ,div_rate number(9,8) -- 
    ,frozen_cause varchar2(2) -- 
    ,transfer_cause varchar2(3) -- 
    ,conv_dir varchar2(2) -- 
    ,targ_prd_code varchar2(32) -- 
    ,targ_seller_code varchar2(14) -- 
    ,targ_asset_acc varchar2(30) -- 
    ,targ_branch varchar2(24) -- 
    ,targ_bank_acc varchar2(48) -- 
    ,client_risk number(22) -- 
    ,product_risk number(22) -- 
    ,cfm_date number(22) -- 
    ,cfm_no varchar2(48) -- 
    ,cfm_vol number(18,3) -- 
    ,to_host_serial varchar2(48) -- 
    ,host_check_date number(22) -- 
    ,ori_host_chk_date number(22) -- 
    ,host_trans_code varchar2(9) -- 
    ,host_date number(22) -- 
    ,host_serial varchar2(48) -- 
    ,monitor_flag varchar2(2) -- 
    ,client_manager varchar2(48) -- 
    ,err_code varchar2(12) -- 
    ,err_msg varchar2(512) -- 
    ,status varchar2(2) -- 
    ,deal_mode varchar2(2) -- 
    ,summary varchar2(375) -- 
    ,debit_account varchar2(48) -- 
    ,fee_account varchar2(48) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(22,4) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
    ,crebit_account varchar2(48) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifms_tbhistransreq to ${iml_schema};
grant select on ${iol_schema}.ifms_tbhistransreq to ${icl_schema};
grant select on ${iol_schema}.ifms_tbhistransreq to ${idl_schema};
grant select on ${iol_schema}.ifms_tbhistransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbhistransreq is '委托类请求历史流水表';
comment on column ${iol_schema}.ifms_tbhistransreq.serial_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.ex_serial is '';
comment on column ${iol_schema}.ifms_tbhistransreq.contract_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.trans_date is '';
comment on column ${iol_schema}.ifms_tbhistransreq.trans_time is '';
comment on column ${iol_schema}.ifms_tbhistransreq.occur_init_date is '';
comment on column ${iol_schema}.ifms_tbhistransreq.seller_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.trans_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.control_flag is '';
comment on column ${iol_schema}.ifms_tbhistransreq.branch_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.open_branch is '';
comment on column ${iol_schema}.ifms_tbhistransreq.ta_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.asset_acc is '';
comment on column ${iol_schema}.ifms_tbhistransreq.in_client_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.client_type is '';
comment on column ${iol_schema}.ifms_tbhistransreq.id_type is '';
comment on column ${iol_schema}.ifms_tbhistransreq.id_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.bank_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.client_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.bank_acc is '';
comment on column ${iol_schema}.ifms_tbhistransreq.cash_flag is '';
comment on column ${iol_schema}.ifms_tbhistransreq.trans_account_type is '';
comment on column ${iol_schema}.ifms_tbhistransreq.trans_account is '';
comment on column ${iol_schema}.ifms_tbhistransreq.channel is '';
comment on column ${iol_schema}.ifms_tbhistransreq.term_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.oper_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.auth_oper is '';
comment on column ${iol_schema}.ifms_tbhistransreq.prd_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.curr_type is '';
comment on column ${iol_schema}.ifms_tbhistransreq.prd_type is '';
comment on column ${iol_schema}.ifms_tbhistransreq.share_class is '';
comment on column ${iol_schema}.ifms_tbhistransreq.asso_date is '';
comment on column ${iol_schema}.ifms_tbhistransreq.asso_serial is '';
comment on column ${iol_schema}.ifms_tbhistransreq.asso_serial2 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.asso_serial3 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.amt is '';
comment on column ${iol_schema}.ifms_tbhistransreq.manage_charge is '';
comment on column ${iol_schema}.ifms_tbhistransreq.manage_charge2 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.agio is '';
comment on column ${iol_schema}.ifms_tbhistransreq.client_group is '';
comment on column ${iol_schema}.ifms_tbhistransreq.liqu_status is '';
comment on column ${iol_schema}.ifms_tbhistransreq.ori_channel is '';
comment on column ${iol_schema}.ifms_tbhistransreq.ori_branch_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.vol is '';
comment on column ${iol_schema}.ifms_tbhistransreq.larg_red_flag is '';
comment on column ${iol_schema}.ifms_tbhistransreq.red_mode is '';
comment on column ${iol_schema}.ifms_tbhistransreq.prd_price is '';
comment on column ${iol_schema}.ifms_tbhistransreq.amt_ratio is '';
comment on column ${iol_schema}.ifms_tbhistransreq.div_mode is '';
comment on column ${iol_schema}.ifms_tbhistransreq.div_rate is '';
comment on column ${iol_schema}.ifms_tbhistransreq.frozen_cause is '';
comment on column ${iol_schema}.ifms_tbhistransreq.transfer_cause is '';
comment on column ${iol_schema}.ifms_tbhistransreq.conv_dir is '';
comment on column ${iol_schema}.ifms_tbhistransreq.targ_prd_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.targ_seller_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.targ_asset_acc is '';
comment on column ${iol_schema}.ifms_tbhistransreq.targ_branch is '';
comment on column ${iol_schema}.ifms_tbhistransreq.targ_bank_acc is '';
comment on column ${iol_schema}.ifms_tbhistransreq.client_risk is '';
comment on column ${iol_schema}.ifms_tbhistransreq.product_risk is '';
comment on column ${iol_schema}.ifms_tbhistransreq.cfm_date is '';
comment on column ${iol_schema}.ifms_tbhistransreq.cfm_no is '';
comment on column ${iol_schema}.ifms_tbhistransreq.cfm_vol is '';
comment on column ${iol_schema}.ifms_tbhistransreq.to_host_serial is '';
comment on column ${iol_schema}.ifms_tbhistransreq.host_check_date is '';
comment on column ${iol_schema}.ifms_tbhistransreq.ori_host_chk_date is '';
comment on column ${iol_schema}.ifms_tbhistransreq.host_trans_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.host_date is '';
comment on column ${iol_schema}.ifms_tbhistransreq.host_serial is '';
comment on column ${iol_schema}.ifms_tbhistransreq.monitor_flag is '';
comment on column ${iol_schema}.ifms_tbhistransreq.client_manager is '';
comment on column ${iol_schema}.ifms_tbhistransreq.err_code is '';
comment on column ${iol_schema}.ifms_tbhistransreq.err_msg is '';
comment on column ${iol_schema}.ifms_tbhistransreq.status is '';
comment on column ${iol_schema}.ifms_tbhistransreq.deal_mode is '';
comment on column ${iol_schema}.ifms_tbhistransreq.summary is '';
comment on column ${iol_schema}.ifms_tbhistransreq.debit_account is '';
comment on column ${iol_schema}.ifms_tbhistransreq.fee_account is '';
comment on column ${iol_schema}.ifms_tbhistransreq.amt1 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.amt2 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.reserve1 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.reserve2 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.reserve3 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.reserve4 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.reserve5 is '';
comment on column ${iol_schema}.ifms_tbhistransreq.crebit_account is '';
comment on column ${iol_schema}.ifms_tbhistransreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbhistransreq.etl_timestamp is 'ETL处理时间戳';
