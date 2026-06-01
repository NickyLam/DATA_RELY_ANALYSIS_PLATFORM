/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbtransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbtransreq
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbtransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtransreq(
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
    ,amt2 number(18,4) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
    ,crebit_account varchar2(32) -- 
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
grant select on ${iol_schema}.ifms_tbtransreq to ${iml_schema};
grant select on ${iol_schema}.ifms_tbtransreq to ${icl_schema};
grant select on ${iol_schema}.ifms_tbtransreq to ${idl_schema};
grant select on ${iol_schema}.ifms_tbtransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbtransreq is '委托类请求流水表*';
comment on column ${iol_schema}.ifms_tbtransreq.serial_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.ex_serial is '';
comment on column ${iol_schema}.ifms_tbtransreq.contract_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.trans_date is '';
comment on column ${iol_schema}.ifms_tbtransreq.trans_time is '';
comment on column ${iol_schema}.ifms_tbtransreq.occur_init_date is '';
comment on column ${iol_schema}.ifms_tbtransreq.seller_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.trans_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.control_flag is '';
comment on column ${iol_schema}.ifms_tbtransreq.branch_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.open_branch is '';
comment on column ${iol_schema}.ifms_tbtransreq.ta_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.asset_acc is '';
comment on column ${iol_schema}.ifms_tbtransreq.in_client_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.client_type is '';
comment on column ${iol_schema}.ifms_tbtransreq.id_type is '';
comment on column ${iol_schema}.ifms_tbtransreq.id_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.bank_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.client_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.bank_acc is '';
comment on column ${iol_schema}.ifms_tbtransreq.cash_flag is '';
comment on column ${iol_schema}.ifms_tbtransreq.trans_account_type is '';
comment on column ${iol_schema}.ifms_tbtransreq.trans_account is '';
comment on column ${iol_schema}.ifms_tbtransreq.channel is '';
comment on column ${iol_schema}.ifms_tbtransreq.term_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.oper_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.auth_oper is '';
comment on column ${iol_schema}.ifms_tbtransreq.prd_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.curr_type is '';
comment on column ${iol_schema}.ifms_tbtransreq.prd_type is '';
comment on column ${iol_schema}.ifms_tbtransreq.share_class is '';
comment on column ${iol_schema}.ifms_tbtransreq.asso_date is '';
comment on column ${iol_schema}.ifms_tbtransreq.asso_serial is '';
comment on column ${iol_schema}.ifms_tbtransreq.asso_serial2 is '';
comment on column ${iol_schema}.ifms_tbtransreq.asso_serial3 is '';
comment on column ${iol_schema}.ifms_tbtransreq.amt is '';
comment on column ${iol_schema}.ifms_tbtransreq.manage_charge is '';
comment on column ${iol_schema}.ifms_tbtransreq.manage_charge2 is '';
comment on column ${iol_schema}.ifms_tbtransreq.agio is '';
comment on column ${iol_schema}.ifms_tbtransreq.client_group is '';
comment on column ${iol_schema}.ifms_tbtransreq.liqu_status is '';
comment on column ${iol_schema}.ifms_tbtransreq.ori_channel is '';
comment on column ${iol_schema}.ifms_tbtransreq.ori_branch_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.vol is '';
comment on column ${iol_schema}.ifms_tbtransreq.larg_red_flag is '';
comment on column ${iol_schema}.ifms_tbtransreq.red_mode is '';
comment on column ${iol_schema}.ifms_tbtransreq.prd_price is '';
comment on column ${iol_schema}.ifms_tbtransreq.amt_ratio is '';
comment on column ${iol_schema}.ifms_tbtransreq.div_mode is '';
comment on column ${iol_schema}.ifms_tbtransreq.div_rate is '';
comment on column ${iol_schema}.ifms_tbtransreq.frozen_cause is '';
comment on column ${iol_schema}.ifms_tbtransreq.transfer_cause is '';
comment on column ${iol_schema}.ifms_tbtransreq.conv_dir is '';
comment on column ${iol_schema}.ifms_tbtransreq.targ_prd_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.targ_seller_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.targ_asset_acc is '';
comment on column ${iol_schema}.ifms_tbtransreq.targ_branch is '';
comment on column ${iol_schema}.ifms_tbtransreq.targ_bank_acc is '';
comment on column ${iol_schema}.ifms_tbtransreq.client_risk is '';
comment on column ${iol_schema}.ifms_tbtransreq.product_risk is '';
comment on column ${iol_schema}.ifms_tbtransreq.cfm_date is '';
comment on column ${iol_schema}.ifms_tbtransreq.cfm_no is '';
comment on column ${iol_schema}.ifms_tbtransreq.cfm_vol is '';
comment on column ${iol_schema}.ifms_tbtransreq.to_host_serial is '';
comment on column ${iol_schema}.ifms_tbtransreq.host_check_date is '';
comment on column ${iol_schema}.ifms_tbtransreq.ori_host_chk_date is '';
comment on column ${iol_schema}.ifms_tbtransreq.host_trans_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.host_date is '';
comment on column ${iol_schema}.ifms_tbtransreq.host_serial is '';
comment on column ${iol_schema}.ifms_tbtransreq.monitor_flag is '';
comment on column ${iol_schema}.ifms_tbtransreq.client_manager is '';
comment on column ${iol_schema}.ifms_tbtransreq.err_code is '';
comment on column ${iol_schema}.ifms_tbtransreq.err_msg is '';
comment on column ${iol_schema}.ifms_tbtransreq.status is '';
comment on column ${iol_schema}.ifms_tbtransreq.deal_mode is '';
comment on column ${iol_schema}.ifms_tbtransreq.summary is '';
comment on column ${iol_schema}.ifms_tbtransreq.debit_account is '';
comment on column ${iol_schema}.ifms_tbtransreq.fee_account is '';
comment on column ${iol_schema}.ifms_tbtransreq.amt1 is '';
comment on column ${iol_schema}.ifms_tbtransreq.amt2 is '';
comment on column ${iol_schema}.ifms_tbtransreq.reserve1 is '';
comment on column ${iol_schema}.ifms_tbtransreq.reserve2 is '';
comment on column ${iol_schema}.ifms_tbtransreq.reserve3 is '';
comment on column ${iol_schema}.ifms_tbtransreq.reserve4 is '';
comment on column ${iol_schema}.ifms_tbtransreq.reserve5 is '';
comment on column ${iol_schema}.ifms_tbtransreq.crebit_account is '';
comment on column ${iol_schema}.ifms_tbtransreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbtransreq.etl_timestamp is 'ETL处理时间戳';
