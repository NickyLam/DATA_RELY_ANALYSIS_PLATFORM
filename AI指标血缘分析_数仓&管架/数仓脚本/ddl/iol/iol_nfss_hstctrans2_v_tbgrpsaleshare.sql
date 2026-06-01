/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_hstctrans2_v_tbgrpsaleshare
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare(
    import_date number(22,0) -- 
    ,seller_code varchar2(14) -- 
    ,bank_no varchar2(48) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(96) -- 
    ,virtual_bank_acc varchar2(48) -- 
    ,ta_client varchar2(48) -- 
    ,prd_type varchar2(2) -- 
    ,cash_flag varchar2(2) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,ta_code varchar2(27) -- 
    ,asset_acc varchar2(30) -- 
    ,prd_code varchar2(48) -- 
    ,tot_vol number(18,3) -- 
    ,frozen_vol number(18,3) -- 
    ,long_frozen_vol number(18,3) -- 
    ,group_vol number(18,3) -- 
    ,div_mode varchar2(2) -- 
    ,old_div_mode varchar2(2) -- 
    ,div_rate number(9,8) -- 
    ,ystdy_tot_vol number(18,3) -- 
    ,open_branch varchar2(120) -- 
    ,client_type varchar2(2) -- 
    ,other_frozen number(18,3) -- 
    ,cost number(18,2) -- 
    ,prd_value number(18,2) -- 
    ,tot_income number(18,2) -- 
    ,onway_amt number(18,2) -- 
    ,profit_loss number(22,8) -- 
    ,income_onway number(18,2) -- 
    ,income_frozen number(18,2) -- 
    ,income_new number(18,2) -- 
    ,tot_amt number(18,2) -- 
    ,use_amt number(18,2) -- 
    ,income_date number(22,0) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
    ,in_client_no varchar2(30) -- 
    ,modify_timestamp number(14,0) -- 
    ,group_code varchar2(48) -- 
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
grant select on ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare to ${iml_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare to ${icl_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare to ${idl_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare is '持仓（收益）表';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.import_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.seller_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.bank_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.client_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.bank_acc is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.virtual_bank_acc is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.ta_client is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.prd_type is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.cash_flag is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.trans_account_type is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.trans_account is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.ta_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.asset_acc is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.prd_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.tot_vol is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.frozen_vol is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.long_frozen_vol is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.group_vol is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.div_mode is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.old_div_mode is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.div_rate is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.ystdy_tot_vol is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.open_branch is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.client_type is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.other_frozen is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.cost is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.prd_value is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.tot_income is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.onway_amt is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.profit_loss is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.income_onway is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.income_frozen is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.income_new is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.tot_amt is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.use_amt is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.income_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.reserve1 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.reserve2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.reserve3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.reserve4 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.reserve5 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.in_client_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.modify_timestamp is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.group_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbgrpsaleshare.etl_timestamp is 'ETL处理时间戳';
