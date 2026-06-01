/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_fds_tbshare1
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_fds_tbshare1
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_fds_tbshare1 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbshare1(
    in_client_no varchar2(30) -- 
    ,seller_code varchar2(14) -- 
    ,bank_no varchar2(14) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(48) -- 
    ,ta_client varchar2(30) -- 
    ,cash_flag varchar2(2) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,ta_code varchar2(14) -- 
    ,asset_acc varchar2(30) -- 
    ,prd_code varchar2(30) -- 
    ,contract_no varchar2(48) -- 
    ,last_date number(22,0) -- 
    ,tot_vol number(18,3) -- 
    ,frozen_vol number(18,3) -- 
    ,long_frozen_vol number(18,3) -- 
    ,group_vol number(18,3) -- 
    ,div_mode varchar2(2) -- 
    ,old_div_mode varchar2(2) -- 
    ,div_rate number(5,4) -- 
    ,ystdy_tot_vol number(18,3) -- 
    ,open_branch varchar2(24) -- 
    ,client_type varchar2(2) -- 
    ,append_flag varchar2(2) -- 
    ,other_frozen number(18,3) -- 
    ,income number(18,7) -- 
    ,income_rate number(9,8) -- 
    ,cost number(18,7) -- 
    ,tot_income number(18,7) -- 
    ,income_onway number(18,7) -- 
    ,income_frozen number(18,7) -- 
    ,income_new number(18,7) -- 
    ,manage_agio number(5,4) -- 
    ,tot_manage_fee number(18,7) -- 
    ,manage_fee number(18,7) -- 
    ,manage_date number(22,0) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
    ,real_prd_code varchar2(30) -- 
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
grant select on ${iol_schema}.ifms_fds_tbshare1 to ${iml_schema};
grant select on ${iol_schema}.ifms_fds_tbshare1 to ${icl_schema};
grant select on ${iol_schema}.ifms_fds_tbshare1 to ${idl_schema};
grant select on ${iol_schema}.ifms_fds_tbshare1 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_fds_tbshare1 is '份额明细表';
comment on column ${iol_schema}.ifms_fds_tbshare1.in_client_no is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.seller_code is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.bank_no is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.client_no is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.bank_acc is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.ta_client is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.cash_flag is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.trans_account_type is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.trans_account is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.ta_code is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.asset_acc is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.contract_no is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.last_date is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.tot_vol is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.frozen_vol is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.long_frozen_vol is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.group_vol is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.div_mode is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.old_div_mode is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.div_rate is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.ystdy_tot_vol is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.open_branch is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.client_type is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.append_flag is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.other_frozen is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.income is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.income_rate is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.cost is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.tot_income is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.income_onway is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.income_frozen is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.income_new is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.manage_agio is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.tot_manage_fee is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.manage_fee is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.manage_date is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.reserve1 is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.reserve2 is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.reserve3 is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.reserve4 is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.reserve5 is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.real_prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbshare1.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_fds_tbshare1.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_fds_tbshare1.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_fds_tbshare1.etl_timestamp is 'ETL处理时间戳';
