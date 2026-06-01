/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbhissquare
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbhissquare
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbhissquare purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbhissquare(
    square_no varchar2(48) -- 
    ,seq_no number(22,0) -- 
    ,trans_date number(22,0) -- 
    ,clear_date number(22,0) -- 
    ,square_date number(22,0) -- 
    ,old_square_date number(22,0) -- 
    ,serial_no varchar2(48) -- 
    ,asso_serial varchar2(48) -- 
    ,from_flag varchar2(2) -- 
    ,trans_code varchar2(9) -- 
    ,busin_code varchar2(9) -- 
    ,client_type varchar2(2) -- 
    ,in_client_no varchar2(30) -- 
    ,bank_no varchar2(3) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(48) -- 
    ,bank_acc_kind varchar2(2) -- 
    ,channel varchar2(2) -- 
    ,oper_no varchar2(48) -- 
    ,term_no varchar2(24) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(24) -- 
    ,ta_code varchar2(14) -- 
    ,prd_code varchar2(30) -- 
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
    ,amt_flag varchar2(2) -- 
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
    ,err_code varchar2(11) -- 
    ,err_msg varchar2(375) -- 
    ,deal_status varchar2(2) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,4) -- 
    ,amt3 number(18,4) -- 
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
grant select on ${iol_schema}.nfss_tcs_tbhissquare to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbhissquare to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbhissquare to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbhissquare to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbhissquare is '信托资金清算历史表';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.square_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.seq_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.trans_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.clear_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.square_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.old_square_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.serial_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.asso_serial is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.from_flag is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.trans_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.busin_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.client_type is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.in_client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.bank_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.bank_acc is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.bank_acc_kind is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.channel is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.oper_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.term_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.branch_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.open_branch is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.ta_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.prd_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.liqu_dir is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.amt is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.curr_type is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.cash_flag is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.unfrozen_amt is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.host_trans_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.host_date is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.host_serial is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.frozen_amt is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.check_status is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.distrib_flag is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.amt_flag is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.cost_income_flag is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.cfm_vol is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.cost is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.cfm_income is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.vol_cumulate is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.prd_account is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.prd_account_kind is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.summary is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.status is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.old_square_no is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.err_code is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.err_msg is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.deal_status is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.amt1 is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.amt2 is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.amt3 is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.reserve1 is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.reserve2 is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.reserve3 is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.reserve4 is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.reserve5 is '';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tcs_tbhissquare.etl_timestamp is 'ETL处理时间戳';
