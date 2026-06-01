/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbhometransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbhometransreq
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbhometransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhometransreq(
    serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,contract_no varchar2(48) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,occur_init_date number(22) -- 
    ,seller_code varchar2(14) -- 
    ,trans_code varchar2(9) -- 
    ,control_flag varchar2(375) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(24) -- 
    ,ta_code varchar2(14) -- 
    ,asset_acc varchar2(30) -- 
    ,in_client_no varchar2(30) -- 
    ,client_type varchar2(2) -- 
    ,id_type varchar2(2) -- 
    ,id_code varchar2(45) -- 
    ,bank_no varchar2(3) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(48) -- 
    ,cash_flag varchar2(2) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,channel varchar2(2) -- 
    ,term_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,auth_oper varchar2(48) -- 
    ,prd_code varchar2(30) -- 
    ,curr_type varchar2(5) -- 
    ,prd_type varchar2(2) -- 
    ,share_class varchar2(2) -- 
    ,asso_date number(22) -- 
    ,asso_serial varchar2(48) -- 
    ,asso_serial2 varchar2(48) -- 
    ,asso_serial3 varchar2(48) -- 
    ,amt number(18,2) -- 
    ,manage_charge number(18,2) -- 
    ,manage_charge2 number(18,2) -- 
    ,agio number(5,4) -- 
    ,client_group varchar2(2) -- 
    ,liqu_status varchar2(2) -- 
    ,ori_channel varchar2(2) -- 
    ,ori_branch_no varchar2(24) -- 
    ,vol number(18,3) -- 
    ,larg_red_flag varchar2(2) -- 
    ,red_mode varchar2(2) -- 
    ,prd_price number(18,6) -- 
    ,amt_ratio number(5,4) -- 
    ,div_mode varchar2(2) -- 
    ,div_rate number(5,4) -- 
    ,frozen_cause varchar2(2) -- 
    ,transfer_cause varchar2(2) -- 
    ,conv_dir varchar2(2) -- 
    ,targ_prd_code varchar2(30) -- 
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
    ,err_code varchar2(11) -- 
    ,err_msg varchar2(150) -- 
    ,status varchar2(2) -- 
    ,cfm_status varchar2(2) -- 
    ,deal_mode varchar2(2) -- 
    ,summary varchar2(375) -- 
    ,debit_account varchar2(48) -- 
    ,fee_account varchar2(48) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,4) -- 
    ,home_id varchar2(48) -- 
    ,is_main number(22) -- 
    ,msg_send_date varchar2(21) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbhometransreq to ${iml_schema};
grant select on ${iol_schema}.ifms_tbhometransreq to ${icl_schema};
grant select on ${iol_schema}.ifms_tbhometransreq to ${idl_schema};
grant select on ${iol_schema}.ifms_tbhometransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbhometransreq is '家庭交易请求流水表';
comment on column ${iol_schema}.ifms_tbhometransreq.serial_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.ex_serial is '';
comment on column ${iol_schema}.ifms_tbhometransreq.contract_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.trans_date is '';
comment on column ${iol_schema}.ifms_tbhometransreq.trans_time is '';
comment on column ${iol_schema}.ifms_tbhometransreq.occur_init_date is '';
comment on column ${iol_schema}.ifms_tbhometransreq.seller_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.trans_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.control_flag is '';
comment on column ${iol_schema}.ifms_tbhometransreq.branch_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.open_branch is '';
comment on column ${iol_schema}.ifms_tbhometransreq.ta_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.asset_acc is '';
comment on column ${iol_schema}.ifms_tbhometransreq.in_client_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.client_type is '';
comment on column ${iol_schema}.ifms_tbhometransreq.id_type is '';
comment on column ${iol_schema}.ifms_tbhometransreq.id_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.bank_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.client_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.bank_acc is '';
comment on column ${iol_schema}.ifms_tbhometransreq.cash_flag is '';
comment on column ${iol_schema}.ifms_tbhometransreq.trans_account_type is '';
comment on column ${iol_schema}.ifms_tbhometransreq.trans_account is '';
comment on column ${iol_schema}.ifms_tbhometransreq.channel is '';
comment on column ${iol_schema}.ifms_tbhometransreq.term_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.oper_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.auth_oper is '';
comment on column ${iol_schema}.ifms_tbhometransreq.prd_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.curr_type is '';
comment on column ${iol_schema}.ifms_tbhometransreq.prd_type is '';
comment on column ${iol_schema}.ifms_tbhometransreq.share_class is '';
comment on column ${iol_schema}.ifms_tbhometransreq.asso_date is '';
comment on column ${iol_schema}.ifms_tbhometransreq.asso_serial is '';
comment on column ${iol_schema}.ifms_tbhometransreq.asso_serial2 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.asso_serial3 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.amt is '';
comment on column ${iol_schema}.ifms_tbhometransreq.manage_charge is '';
comment on column ${iol_schema}.ifms_tbhometransreq.manage_charge2 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.agio is '';
comment on column ${iol_schema}.ifms_tbhometransreq.client_group is '';
comment on column ${iol_schema}.ifms_tbhometransreq.liqu_status is '';
comment on column ${iol_schema}.ifms_tbhometransreq.ori_channel is '';
comment on column ${iol_schema}.ifms_tbhometransreq.ori_branch_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.vol is '';
comment on column ${iol_schema}.ifms_tbhometransreq.larg_red_flag is '';
comment on column ${iol_schema}.ifms_tbhometransreq.red_mode is '';
comment on column ${iol_schema}.ifms_tbhometransreq.prd_price is '';
comment on column ${iol_schema}.ifms_tbhometransreq.amt_ratio is '';
comment on column ${iol_schema}.ifms_tbhometransreq.div_mode is '';
comment on column ${iol_schema}.ifms_tbhometransreq.div_rate is '';
comment on column ${iol_schema}.ifms_tbhometransreq.frozen_cause is '';
comment on column ${iol_schema}.ifms_tbhometransreq.transfer_cause is '';
comment on column ${iol_schema}.ifms_tbhometransreq.conv_dir is '';
comment on column ${iol_schema}.ifms_tbhometransreq.targ_prd_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.targ_seller_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.targ_asset_acc is '';
comment on column ${iol_schema}.ifms_tbhometransreq.targ_branch is '';
comment on column ${iol_schema}.ifms_tbhometransreq.targ_bank_acc is '';
comment on column ${iol_schema}.ifms_tbhometransreq.client_risk is '';
comment on column ${iol_schema}.ifms_tbhometransreq.product_risk is '';
comment on column ${iol_schema}.ifms_tbhometransreq.cfm_date is '';
comment on column ${iol_schema}.ifms_tbhometransreq.cfm_no is '';
comment on column ${iol_schema}.ifms_tbhometransreq.cfm_vol is '';
comment on column ${iol_schema}.ifms_tbhometransreq.to_host_serial is '';
comment on column ${iol_schema}.ifms_tbhometransreq.host_check_date is '';
comment on column ${iol_schema}.ifms_tbhometransreq.ori_host_chk_date is '';
comment on column ${iol_schema}.ifms_tbhometransreq.host_trans_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.host_date is '';
comment on column ${iol_schema}.ifms_tbhometransreq.host_serial is '';
comment on column ${iol_schema}.ifms_tbhometransreq.monitor_flag is '';
comment on column ${iol_schema}.ifms_tbhometransreq.client_manager is '';
comment on column ${iol_schema}.ifms_tbhometransreq.err_code is '';
comment on column ${iol_schema}.ifms_tbhometransreq.err_msg is '';
comment on column ${iol_schema}.ifms_tbhometransreq.status is '';
comment on column ${iol_schema}.ifms_tbhometransreq.cfm_status is '';
comment on column ${iol_schema}.ifms_tbhometransreq.deal_mode is '';
comment on column ${iol_schema}.ifms_tbhometransreq.summary is '';
comment on column ${iol_schema}.ifms_tbhometransreq.debit_account is '';
comment on column ${iol_schema}.ifms_tbhometransreq.fee_account is '';
comment on column ${iol_schema}.ifms_tbhometransreq.amt1 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.amt2 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.home_id is '';
comment on column ${iol_schema}.ifms_tbhometransreq.is_main is '';
comment on column ${iol_schema}.ifms_tbhometransreq.msg_send_date is '';
comment on column ${iol_schema}.ifms_tbhometransreq.reserve1 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.reserve2 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.reserve3 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.reserve4 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.reserve5 is '';
comment on column ${iol_schema}.ifms_tbhometransreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbhometransreq.etl_timestamp is 'ETL处理时间戳';
