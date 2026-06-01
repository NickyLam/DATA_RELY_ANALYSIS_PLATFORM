/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbsquare
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbsquare
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbsquare purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbsquare(
    square_no varchar2(48) -- 
    ,seq_no number(22,0) -- 
    ,trans_date number(22,0) -- 
    ,clear_date number(22,0) -- 
    ,square_date number(22,0) -- 
    ,old_square_date number(22,0) -- 
    ,serial_no varchar2(48) -- 
    ,asso_serial varchar2(48) -- 
    ,from_flag varchar2(2) -- 
    ,trans_code varchar2(32) -- 
    ,busin_code varchar2(9) -- 
    ,client_type varchar2(2) -- 
    ,in_client_no varchar2(30) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,bank_acc_kind varchar2(2) -- 
    ,channel varchar2(2) -- 
    ,oper_no varchar2(48) -- 
    ,term_no varchar2(24) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(80) -- 
    ,ta_code varchar2(18) -- 
    ,prd_code varchar2(32) -- 
    ,liqu_dir varchar2(2) -- 
    ,amt number(18,2) -- 
    ,curr_type varchar2(5) -- 
    ,cash_flag varchar2(2) -- 
    ,unfrozen_amt number(18,2) -- 
    ,host_trans_code varchar2(9) -- 
    ,host_date number(22,0) -- 
    ,host_serial varchar2(48) -- 
    ,frozen_amt number(18,2) -- 
    ,check_status varchar2(2) -- 
    ,distrib_flag varchar2(2) -- 
    ,amt_flag varchar2(32) -- 
    ,cost_income_flag varchar2(2) -- 
    ,cfm_vol number(18,3) -- 
    ,cost number(18,2) -- 
    ,cfm_income number(18,2) -- 
    ,vol_cumulate number(18,3) -- 
    ,prd_account varchar2(48) -- 
    ,prd_account_kind varchar2(2) -- 
    ,summary varchar2(375) -- 
    ,status varchar2(2) -- 
    ,old_square_no varchar2(48) -- 
    ,err_code varchar2(12) -- 
    ,err_msg varchar2(512) -- 
    ,deal_status varchar2(2) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(22,4) -- 
    ,amt3 number(22,4) -- 
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
grant select on ${iol_schema}.nfss_tbsquare to ${iml_schema};
grant select on ${iol_schema}.nfss_tbsquare to ${icl_schema};
grant select on ${iol_schema}.nfss_tbsquare to ${idl_schema};
grant select on ${iol_schema}.nfss_tbsquare to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbsquare is '代销基金资金清算表';
comment on column ${iol_schema}.nfss_tbsquare.square_no is '';
comment on column ${iol_schema}.nfss_tbsquare.seq_no is '';
comment on column ${iol_schema}.nfss_tbsquare.trans_date is '';
comment on column ${iol_schema}.nfss_tbsquare.clear_date is '';
comment on column ${iol_schema}.nfss_tbsquare.square_date is '';
comment on column ${iol_schema}.nfss_tbsquare.old_square_date is '';
comment on column ${iol_schema}.nfss_tbsquare.serial_no is '';
comment on column ${iol_schema}.nfss_tbsquare.asso_serial is '';
comment on column ${iol_schema}.nfss_tbsquare.from_flag is '';
comment on column ${iol_schema}.nfss_tbsquare.trans_code is '';
comment on column ${iol_schema}.nfss_tbsquare.busin_code is '';
comment on column ${iol_schema}.nfss_tbsquare.client_type is '';
comment on column ${iol_schema}.nfss_tbsquare.in_client_no is '';
comment on column ${iol_schema}.nfss_tbsquare.bank_no is '';
comment on column ${iol_schema}.nfss_tbsquare.client_no is '';
comment on column ${iol_schema}.nfss_tbsquare.bank_acc is '';
comment on column ${iol_schema}.nfss_tbsquare.bank_acc_kind is '';
comment on column ${iol_schema}.nfss_tbsquare.channel is '';
comment on column ${iol_schema}.nfss_tbsquare.oper_no is '';
comment on column ${iol_schema}.nfss_tbsquare.term_no is '';
comment on column ${iol_schema}.nfss_tbsquare.branch_no is '';
comment on column ${iol_schema}.nfss_tbsquare.open_branch is '';
comment on column ${iol_schema}.nfss_tbsquare.ta_code is '';
comment on column ${iol_schema}.nfss_tbsquare.prd_code is '';
comment on column ${iol_schema}.nfss_tbsquare.liqu_dir is '';
comment on column ${iol_schema}.nfss_tbsquare.amt is '';
comment on column ${iol_schema}.nfss_tbsquare.curr_type is '';
comment on column ${iol_schema}.nfss_tbsquare.cash_flag is '';
comment on column ${iol_schema}.nfss_tbsquare.unfrozen_amt is '';
comment on column ${iol_schema}.nfss_tbsquare.host_trans_code is '';
comment on column ${iol_schema}.nfss_tbsquare.host_date is '';
comment on column ${iol_schema}.nfss_tbsquare.host_serial is '';
comment on column ${iol_schema}.nfss_tbsquare.frozen_amt is '';
comment on column ${iol_schema}.nfss_tbsquare.check_status is '';
comment on column ${iol_schema}.nfss_tbsquare.distrib_flag is '';
comment on column ${iol_schema}.nfss_tbsquare.amt_flag is '';
comment on column ${iol_schema}.nfss_tbsquare.cost_income_flag is '';
comment on column ${iol_schema}.nfss_tbsquare.cfm_vol is '';
comment on column ${iol_schema}.nfss_tbsquare.cost is '';
comment on column ${iol_schema}.nfss_tbsquare.cfm_income is '';
comment on column ${iol_schema}.nfss_tbsquare.vol_cumulate is '';
comment on column ${iol_schema}.nfss_tbsquare.prd_account is '';
comment on column ${iol_schema}.nfss_tbsquare.prd_account_kind is '';
comment on column ${iol_schema}.nfss_tbsquare.summary is '';
comment on column ${iol_schema}.nfss_tbsquare.status is '';
comment on column ${iol_schema}.nfss_tbsquare.old_square_no is '';
comment on column ${iol_schema}.nfss_tbsquare.err_code is '';
comment on column ${iol_schema}.nfss_tbsquare.err_msg is '';
comment on column ${iol_schema}.nfss_tbsquare.deal_status is '';
comment on column ${iol_schema}.nfss_tbsquare.amt1 is '';
comment on column ${iol_schema}.nfss_tbsquare.amt2 is '';
comment on column ${iol_schema}.nfss_tbsquare.amt3 is '';
comment on column ${iol_schema}.nfss_tbsquare.reserve1 is '';
comment on column ${iol_schema}.nfss_tbsquare.reserve2 is '';
comment on column ${iol_schema}.nfss_tbsquare.reserve3 is '';
comment on column ${iol_schema}.nfss_tbsquare.reserve4 is '';
comment on column ${iol_schema}.nfss_tbsquare.reserve5 is '';
comment on column ${iol_schema}.nfss_tbsquare.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbsquare.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbsquare.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbsquare.etl_timestamp is 'ETL处理时间戳';
