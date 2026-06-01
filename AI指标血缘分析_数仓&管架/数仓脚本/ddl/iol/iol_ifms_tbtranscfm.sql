/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbtranscfm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbtranscfm
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbtranscfm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtranscfm(
    ta_code varchar2(18) -- 
    ,cfm_date number(22) -- 
    ,cfm_no varchar2(48) -- 
    ,ori_cfm_no varchar2(48) -- 
    ,from_flag varchar2(2) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,clear_date number(22) -- 
    ,serial_no varchar2(48) -- 
    ,trans_code varchar2(32) -- 
    ,busin_code varchar2(9) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(80) -- 
    ,channel varchar2(2) -- 
    ,term_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,in_client_no varchar2(30) -- 
    ,client_type varchar2(2) -- 
    ,asset_acc varchar2(30) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,client_name varchar2(375) -- 
    ,bank_acc varchar2(64) -- 
    ,ta_client varchar2(48) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,cash_flag varchar2(2) -- 
    ,prd_code varchar2(32) -- 
    ,share_class varchar2(3) -- 
    ,nav number(18,8) -- 
    ,price number(26,12) -- 
    ,amt number(18,2) -- 
    ,curr_type varchar2(5) -- 
    ,cfm_amt number(18,2) -- 
    ,vol number(18,3) -- 
    ,cfm_vol number(18,3) -- 
    ,larg_red_flag varchar2(2) -- 
    ,red_cause varchar2(2) -- 
    ,agio number(5,4) -- 
    ,tot_fee number(18,2) -- 
    ,charge number(18,2) -- 
    ,stamp_tax number(18,2) -- 
    ,interest_tax number(18,2) -- 
    ,transfer_fee number(18,2) -- 
    ,agency_fee number(18,2) -- 
    ,back_fee number(18,2) -- 
    ,other_fee1 number(18,2) -- 
    ,other_fee2 number(18,2) -- 
    ,cfm_income number(18,2) -- 
    ,manage_fee number(18,2) -- 
    ,cont_frozen_amt number(18,2) -- 
    ,vol_cumulate number(18,3) -- 
    ,detail_flag varchar2(2) -- 
    ,finish_flag varchar2(2) -- 
    ,frozen_cause varchar2(2) -- 
    ,conv_dir varchar2(2) -- 
    ,targ_prd_code varchar2(32) -- 
    ,targ_nav number(18,8) -- 
    ,targ_price number(18,8) -- 
    ,targ_cfm_vol number(18,3) -- 
    ,targ_seller_code varchar2(14) -- 
    ,targ_branch varchar2(24) -- 
    ,targ_asset_acc varchar2(48) -- 
    ,targ_bank_acc varchar2(48) -- 
    ,interest number(18,2) -- 
    ,vol_of_int number(18,3) -- 
    ,div_mode varchar2(2) -- 
    ,div_rate number(9,8) -- 
    ,summary varchar2(375) -- 
    ,err_code varchar2(12) -- 
    ,err_msg varchar2(512) -- 
    ,status varchar2(2) -- 
    ,client_manager varchar2(48) -- 
    ,asso_date number(22) -- 
    ,asso_serial varchar2(48) -- 
    ,bank_charge number(18,2) -- 
    ,ex_serial varchar2(48) -- 
    ,contract_no varchar2(48) -- 
    ,manage_charge number(18,2) -- 
    ,host_trans_code varchar2(9) -- 
    ,host_date number(22) -- 
    ,host_serial varchar2(48) -- 
    ,post_vol number(18,3) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,2) -- 
    ,amt3 number(18,2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbtranscfm to ${iml_schema};
grant select on ${iol_schema}.ifms_tbtranscfm to ${icl_schema};
grant select on ${iol_schema}.ifms_tbtranscfm to ${idl_schema};
grant select on ${iol_schema}.ifms_tbtranscfm to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbtranscfm is '交易类确认表';
comment on column ${iol_schema}.ifms_tbtranscfm.ta_code is '';
comment on column ${iol_schema}.ifms_tbtranscfm.cfm_date is '';
comment on column ${iol_schema}.ifms_tbtranscfm.cfm_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.ori_cfm_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.from_flag is '';
comment on column ${iol_schema}.ifms_tbtranscfm.trans_date is '';
comment on column ${iol_schema}.ifms_tbtranscfm.trans_time is '';
comment on column ${iol_schema}.ifms_tbtranscfm.clear_date is '';
comment on column ${iol_schema}.ifms_tbtranscfm.serial_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.trans_code is '';
comment on column ${iol_schema}.ifms_tbtranscfm.busin_code is '';
comment on column ${iol_schema}.ifms_tbtranscfm.branch_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.open_branch is '';
comment on column ${iol_schema}.ifms_tbtranscfm.channel is '';
comment on column ${iol_schema}.ifms_tbtranscfm.term_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.oper_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.in_client_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.client_type is '';
comment on column ${iol_schema}.ifms_tbtranscfm.asset_acc is '';
comment on column ${iol_schema}.ifms_tbtranscfm.bank_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.client_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.client_name is '';
comment on column ${iol_schema}.ifms_tbtranscfm.bank_acc is '';
comment on column ${iol_schema}.ifms_tbtranscfm.ta_client is '';
comment on column ${iol_schema}.ifms_tbtranscfm.trans_account_type is '';
comment on column ${iol_schema}.ifms_tbtranscfm.trans_account is '';
comment on column ${iol_schema}.ifms_tbtranscfm.cash_flag is '';
comment on column ${iol_schema}.ifms_tbtranscfm.prd_code is '';
comment on column ${iol_schema}.ifms_tbtranscfm.share_class is '';
comment on column ${iol_schema}.ifms_tbtranscfm.nav is '';
comment on column ${iol_schema}.ifms_tbtranscfm.price is '';
comment on column ${iol_schema}.ifms_tbtranscfm.amt is '';
comment on column ${iol_schema}.ifms_tbtranscfm.curr_type is '';
comment on column ${iol_schema}.ifms_tbtranscfm.cfm_amt is '';
comment on column ${iol_schema}.ifms_tbtranscfm.vol is '';
comment on column ${iol_schema}.ifms_tbtranscfm.cfm_vol is '';
comment on column ${iol_schema}.ifms_tbtranscfm.larg_red_flag is '';
comment on column ${iol_schema}.ifms_tbtranscfm.red_cause is '';
comment on column ${iol_schema}.ifms_tbtranscfm.agio is '';
comment on column ${iol_schema}.ifms_tbtranscfm.tot_fee is '';
comment on column ${iol_schema}.ifms_tbtranscfm.charge is '';
comment on column ${iol_schema}.ifms_tbtranscfm.stamp_tax is '';
comment on column ${iol_schema}.ifms_tbtranscfm.interest_tax is '';
comment on column ${iol_schema}.ifms_tbtranscfm.transfer_fee is '';
comment on column ${iol_schema}.ifms_tbtranscfm.agency_fee is '';
comment on column ${iol_schema}.ifms_tbtranscfm.back_fee is '';
comment on column ${iol_schema}.ifms_tbtranscfm.other_fee1 is '';
comment on column ${iol_schema}.ifms_tbtranscfm.other_fee2 is '';
comment on column ${iol_schema}.ifms_tbtranscfm.cfm_income is '';
comment on column ${iol_schema}.ifms_tbtranscfm.manage_fee is '';
comment on column ${iol_schema}.ifms_tbtranscfm.cont_frozen_amt is '';
comment on column ${iol_schema}.ifms_tbtranscfm.vol_cumulate is '';
comment on column ${iol_schema}.ifms_tbtranscfm.detail_flag is '';
comment on column ${iol_schema}.ifms_tbtranscfm.finish_flag is '';
comment on column ${iol_schema}.ifms_tbtranscfm.frozen_cause is '';
comment on column ${iol_schema}.ifms_tbtranscfm.conv_dir is '';
comment on column ${iol_schema}.ifms_tbtranscfm.targ_prd_code is '';
comment on column ${iol_schema}.ifms_tbtranscfm.targ_nav is '';
comment on column ${iol_schema}.ifms_tbtranscfm.targ_price is '';
comment on column ${iol_schema}.ifms_tbtranscfm.targ_cfm_vol is '';
comment on column ${iol_schema}.ifms_tbtranscfm.targ_seller_code is '';
comment on column ${iol_schema}.ifms_tbtranscfm.targ_branch is '';
comment on column ${iol_schema}.ifms_tbtranscfm.targ_asset_acc is '';
comment on column ${iol_schema}.ifms_tbtranscfm.targ_bank_acc is '';
comment on column ${iol_schema}.ifms_tbtranscfm.interest is '';
comment on column ${iol_schema}.ifms_tbtranscfm.vol_of_int is '';
comment on column ${iol_schema}.ifms_tbtranscfm.div_mode is '';
comment on column ${iol_schema}.ifms_tbtranscfm.div_rate is '';
comment on column ${iol_schema}.ifms_tbtranscfm.summary is '';
comment on column ${iol_schema}.ifms_tbtranscfm.err_code is '';
comment on column ${iol_schema}.ifms_tbtranscfm.err_msg is '';
comment on column ${iol_schema}.ifms_tbtranscfm.status is '';
comment on column ${iol_schema}.ifms_tbtranscfm.client_manager is '';
comment on column ${iol_schema}.ifms_tbtranscfm.asso_date is '';
comment on column ${iol_schema}.ifms_tbtranscfm.asso_serial is '';
comment on column ${iol_schema}.ifms_tbtranscfm.bank_charge is '';
comment on column ${iol_schema}.ifms_tbtranscfm.ex_serial is '';
comment on column ${iol_schema}.ifms_tbtranscfm.contract_no is '';
comment on column ${iol_schema}.ifms_tbtranscfm.manage_charge is '';
comment on column ${iol_schema}.ifms_tbtranscfm.host_trans_code is '';
comment on column ${iol_schema}.ifms_tbtranscfm.host_date is '';
comment on column ${iol_schema}.ifms_tbtranscfm.host_serial is '';
comment on column ${iol_schema}.ifms_tbtranscfm.post_vol is '';
comment on column ${iol_schema}.ifms_tbtranscfm.amt1 is '';
comment on column ${iol_schema}.ifms_tbtranscfm.amt2 is '';
comment on column ${iol_schema}.ifms_tbtranscfm.amt3 is '';
comment on column ${iol_schema}.ifms_tbtranscfm.reserve1 is '';
comment on column ${iol_schema}.ifms_tbtranscfm.reserve2 is '';
comment on column ${iol_schema}.ifms_tbtranscfm.reserve3 is '';
comment on column ${iol_schema}.ifms_tbtranscfm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbtranscfm.etl_timestamp is 'ETL处理时间戳';
