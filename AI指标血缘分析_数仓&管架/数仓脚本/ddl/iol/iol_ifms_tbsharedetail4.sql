/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbsharedetail4
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbsharedetail4
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbsharedetail4 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbsharedetail4(
    in_client_no varchar2(30) -- 
    ,seller_code varchar2(14) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,ta_client varchar2(32) -- 
    ,cash_flag varchar2(2) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,ta_code varchar2(18) -- 
    ,asset_acc varchar2(30) -- 
    ,prd_code varchar2(32) -- 
    ,contract_no varchar2(48) -- 
    ,last_date number(22) -- 
    ,serial_no varchar2(48) -- 
    ,cfm_date number(22) -- 
    ,cfm_no varchar2(48) -- 
    ,source_flag varchar2(2) -- 
    ,tot_vol number(18,3) -- 
    ,frozen_vol number(18,3) -- 
    ,long_frozen_vol number(18,3) -- 
    ,group_vol number(18,3) -- 
    ,div_mode varchar2(2) -- 
    ,old_div_mode varchar2(2) -- 
    ,div_rate number(9,8) -- 
    ,ystdy_tot_vol number(18,3) -- 
    ,open_branch varchar2(80) -- 
    ,client_type varchar2(2) -- 
    ,append_flag varchar2(2) -- 
    ,other_frozen number(18,3) -- 
    ,income number(24,8) -- 
    ,cost number(18,2) -- 
    ,tot_income number(18,2) -- 
    ,income_onway number(18,2) -- 
    ,income_frozen number(18,2) -- 
    ,income_new number(18,2) -- 
    ,manage_agio number(5,4) -- 
    ,tot_manage_fee number(18,2) -- 
    ,manage_fee number(18,2) -- 
    ,manage_date number(22) -- 
    ,ori_cfm_amt number(18,2) -- 
    ,ori_cfm_vol number(18,3) -- 
    ,ori_nav number(22,8) -- 
    ,gain_balance number(18,2) -- 
    ,ori_back_fee_rate number(9,8) -- 
    ,ori_source_flag varchar2(2) -- 
    ,even_nav number(20,9) -- 
    ,min_back_rate number(9,8) -- 
    ,min_redeem_rate number(9,8) -- 
    ,max_allot_rate number(9,8) -- 
    ,ori_agio number(5,4) -- 
    ,channel varchar2(2) -- 
    ,client_group varchar2(10) -- 
    ,last_cycle_date number(22) -- 
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
grant select on ${iol_schema}.ifms_tbsharedetail4 to ${iml_schema};
grant select on ${iol_schema}.ifms_tbsharedetail4 to ${icl_schema};
grant select on ${iol_schema}.ifms_tbsharedetail4 to ${idl_schema};
grant select on ${iol_schema}.ifms_tbsharedetail4 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbsharedetail4 is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.in_client_no is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.seller_code is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.bank_no is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.client_no is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.bank_acc is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ta_client is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.cash_flag is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.trans_account_type is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.trans_account is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ta_code is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.asset_acc is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.prd_code is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.contract_no is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.last_date is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.serial_no is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.cfm_date is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.cfm_no is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.source_flag is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.tot_vol is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.frozen_vol is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.long_frozen_vol is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.group_vol is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.div_mode is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.old_div_mode is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.div_rate is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ystdy_tot_vol is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.open_branch is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.client_type is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.append_flag is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.other_frozen is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.income is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.cost is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.tot_income is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.income_onway is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.income_frozen is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.income_new is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.manage_agio is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.tot_manage_fee is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.manage_fee is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.manage_date is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ori_cfm_amt is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ori_cfm_vol is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ori_nav is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.gain_balance is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ori_back_fee_rate is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ori_source_flag is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.even_nav is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.min_back_rate is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.min_redeem_rate is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.max_allot_rate is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.ori_agio is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.channel is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.client_group is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.last_cycle_date is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.reserve1 is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.reserve2 is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.reserve3 is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.reserve4 is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.reserve5 is '';
comment on column ${iol_schema}.ifms_tbsharedetail4.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbsharedetail4.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbsharedetail4.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbsharedetail4.etl_timestamp is 'ETL处理时间戳';
