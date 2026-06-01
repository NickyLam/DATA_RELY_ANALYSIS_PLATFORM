/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_fds_tbtatranscfm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_fds_tbtatranscfm
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_fds_tbtatranscfm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbtatranscfm(
    busin_code varchar2(9) -- 
    ,cfm_date number(22,0) -- 
    ,cfm_no varchar2(48) -- 
    ,trans_date number(22,0) -- 
    ,serial_no varchar2(48) -- 
    ,seller_code varchar2(14) -- 
    ,branch_no varchar2(24) -- 
    ,asset_acc varchar2(30) -- 
    ,ta_client varchar2(30) -- 
    ,prd_code varchar2(30) -- 
    ,share_class varchar2(2) -- 
    ,cfm_amt number(18,2) -- 
    ,cfm_vol number(18,3) -- 
    ,tot_cfm_amt number(18,2) -- 
    ,tot_cfm_vol number(18,3) -- 
    ,no_cfm_amt number(18,2) -- 
    ,no_cfm_vol number(18,3) -- 
    ,trade_fee number(18,2) -- 
    ,ori_fee number(18,2) -- 
    ,transfer_fee number(18,2) -- 
    ,stamp_tax number(18,2) -- 
    ,back_fee number(18,2) -- 
    ,other_fee1 number(18,2) -- 
    ,interest number(18,2) -- 
    ,interest_tax number(18,2) -- 
    ,interest_share number(18,3) -- 
    ,ori_trade_fee number(18,2) -- 
    ,total_fee number(18,2) -- 
    ,commision number(18,2) -- 
    ,regist_fee number(18,2) -- 
    ,asset_fee number(18,2) -- 
    ,manage_fee number(18,2) -- 
    ,ori_transfer_fee number(18,2) -- 
    ,ori_back_fee number(18,2) -- 
    ,ori_other_fee1 number(18,2) -- 
    ,nav number(18,8) -- 
    ,frozen_amt number(18,2) -- 
    ,unfrozen_amt number(18,2) -- 
    ,status varchar2(2) -- 
    ,ta_flag varchar2(2) -- 
    ,client_type varchar2(2) -- 
    ,in_client_no varchar2(30) -- 
    ,gain_income number(18,2) -- 
    ,end_flag varchar2(2) -- 
    ,client_income number(18,2) -- 
    ,branch_income number(18,2) -- 
    ,ch_vol number(18,3) -- 
    ,cfm_income number(18,2) -- 
    ,amt number(18,2) -- 
    ,vol number(18,3) -- 
    ,agio number(5,4) -- 
    ,last_vol number(18,3) -- 
    ,last_frozen_vol number(18,3) -- 
    ,targ_prd_code varchar2(30) -- 
    ,targ_share_class varchar2(2) -- 
    ,targ_asset_acc varchar2(30) -- 
    ,targ_seller_code varchar2(14) -- 
    ,targ_net_no varchar2(48) -- 
    ,div_mode varchar2(2) -- 
    ,ori_serial_no varchar2(48) -- 
    ,larg_red_flag varchar2(2) -- 
    ,frozen_cause varchar2(2) -- 
    ,frozen_end_date number(22,0) -- 
    ,out_busin_code varchar2(9) -- 
    ,channel varchar2(2) -- 
    ,ori_agio number(5,4) -- 
    ,cis_date number(22,0) -- 
    ,back_agio number(5,4) -- 
    ,bank_no varchar2(14) -- 
    ,real_flag varchar2(2) -- 
    ,err_code varchar2(11) -- 
    ,err_msg varchar2(150) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
    ,real_prd_code varchar2(30) -- 
    ,targ_real_prd_code varchar2(30) -- 
    ,client_manager varchar2(48) -- 
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
grant select on ${iol_schema}.ifms_fds_tbtatranscfm to ${iml_schema};
grant select on ${iol_schema}.ifms_fds_tbtatranscfm to ${icl_schema};
grant select on ${iol_schema}.ifms_fds_tbtatranscfm to ${idl_schema};
grant select on ${iol_schema}.ifms_fds_tbtatranscfm to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_fds_tbtatranscfm is '交易确认明细(TA)';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.busin_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.cfm_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.cfm_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.trans_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.serial_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.seller_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.branch_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.asset_acc is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ta_client is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.share_class is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.cfm_amt is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.cfm_vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.tot_cfm_amt is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.tot_cfm_vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.no_cfm_amt is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.no_cfm_vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.trade_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ori_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.transfer_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.stamp_tax is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.back_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.other_fee1 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.interest is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.interest_tax is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.interest_share is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ori_trade_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.total_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.commision is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.regist_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.asset_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.manage_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ori_transfer_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ori_back_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ori_other_fee1 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.nav is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.frozen_amt is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.unfrozen_amt is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.status is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ta_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.client_type is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.in_client_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.gain_income is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.end_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.client_income is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.branch_income is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ch_vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.cfm_income is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.amt is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.agio is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.last_vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.last_frozen_vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.targ_prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.targ_share_class is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.targ_asset_acc is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.targ_seller_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.targ_net_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.div_mode is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ori_serial_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.larg_red_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.frozen_cause is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.frozen_end_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.out_busin_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.channel is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.ori_agio is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.cis_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.back_agio is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.bank_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.real_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.err_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.err_msg is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.amt1 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.amt2 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.reserve1 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.reserve2 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.reserve3 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.reserve4 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.reserve5 is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.real_prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.targ_real_prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.client_manager is '';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_fds_tbtatranscfm.etl_timestamp is 'ETL处理时间戳';
