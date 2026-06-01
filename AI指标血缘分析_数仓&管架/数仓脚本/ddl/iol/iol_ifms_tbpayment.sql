/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbpayment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbpayment
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbpayment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbpayment(
    clear_date number(22) -- 
    ,prd_code varchar2(30) -- 
    ,ta_code varchar2(14) -- 
    ,prd_manager varchar2(9) -- 
    ,curr_type varchar2(5) -- 
    ,red_amt number(18,2) -- 
    ,div_amt number(18,2) -- 
    ,refund_amt number(18,2) -- 
    ,other_in number(18,2) -- 
    ,tot_amt number(18,2) -- 
    ,req_amt number(18,2) -- 
    ,cfm_amt number(18,2) -- 
    ,charge number(18,2) -- 
    ,fail_amt number(18,2) -- 
    ,other_amt number(18,2) -- 
    ,trans_date number(22) -- 
    ,status varchar2(2) -- 
    ,red_charge number(18,2) -- 
    ,trans_charge number(18,2) -- 
    ,reserve varchar2(375) -- 
    ,square_date number(22) -- 
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
grant select on ${iol_schema}.ifms_tbpayment to ${iml_schema};
grant select on ${iol_schema}.ifms_tbpayment to ${icl_schema};
grant select on ${iol_schema}.ifms_tbpayment to ${idl_schema};
grant select on ${iol_schema}.ifms_tbpayment to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbpayment is '资金划款表';
comment on column ${iol_schema}.ifms_tbpayment.clear_date is '';
comment on column ${iol_schema}.ifms_tbpayment.prd_code is '';
comment on column ${iol_schema}.ifms_tbpayment.ta_code is '';
comment on column ${iol_schema}.ifms_tbpayment.prd_manager is '';
comment on column ${iol_schema}.ifms_tbpayment.curr_type is '';
comment on column ${iol_schema}.ifms_tbpayment.red_amt is '';
comment on column ${iol_schema}.ifms_tbpayment.div_amt is '';
comment on column ${iol_schema}.ifms_tbpayment.refund_amt is '';
comment on column ${iol_schema}.ifms_tbpayment.other_in is '';
comment on column ${iol_schema}.ifms_tbpayment.tot_amt is '';
comment on column ${iol_schema}.ifms_tbpayment.req_amt is '';
comment on column ${iol_schema}.ifms_tbpayment.cfm_amt is '';
comment on column ${iol_schema}.ifms_tbpayment.charge is '';
comment on column ${iol_schema}.ifms_tbpayment.fail_amt is '';
comment on column ${iol_schema}.ifms_tbpayment.other_amt is '';
comment on column ${iol_schema}.ifms_tbpayment.trans_date is '';
comment on column ${iol_schema}.ifms_tbpayment.status is '';
comment on column ${iol_schema}.ifms_tbpayment.red_charge is '';
comment on column ${iol_schema}.ifms_tbpayment.trans_charge is '';
comment on column ${iol_schema}.ifms_tbpayment.reserve is '';
comment on column ${iol_schema}.ifms_tbpayment.square_date is '';
comment on column ${iol_schema}.ifms_tbpayment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbpayment.etl_timestamp is 'ETL处理时间戳';
