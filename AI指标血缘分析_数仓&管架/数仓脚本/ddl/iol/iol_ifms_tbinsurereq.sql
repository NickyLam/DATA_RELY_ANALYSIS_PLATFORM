/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinsurereq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinsurereq
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinsurereq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsurereq(
    trans_date number(22) -- 
    ,serial_no varchar2(48) -- 
    ,bank_no varchar2(3) -- 
    ,asso_serial varchar2(48) -- 
    ,ta_code varchar2(14) -- 
    ,prd_code varchar2(30) -- 
    ,insure_no varchar2(45) -- 
    ,client_manager varchar2(48) -- 
    ,client_no varchar2(36) -- 
    ,client_type varchar2(2) -- 
    ,trans_code varchar2(9) -- 
    ,trans_name varchar2(90) -- 
    ,bank_acc varchar2(48) -- 
    ,acc_name varchar2(30) -- 
    ,voucher_type varchar2(15) -- 
    ,voucher_no varchar2(48) -- 
    ,voucher_pwd varchar2(45) -- 
    ,voucher_date number(22) -- 
    ,voucher_note varchar2(90) -- 
    ,curr_type varchar2(5) -- 
    ,clear_status varchar2(2) -- 
    ,check_status varchar2(2) -- 
    ,liqu_status varchar2(2) -- 
    ,amt number(18,2) -- 
    ,charge number(18,2) -- 
    ,internal_branch varchar2(18) -- 
    ,branch_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,auth_oper varchar2(48) -- 
    ,term varchar2(12) -- 
    ,channel varchar2(15) -- 
    ,err_code varchar2(15) -- 
    ,err_msg varchar2(900) -- 
    ,insure_date number(22) -- 
    ,insure_cfm_no varchar2(45) -- 
    ,insure_trans_code varchar2(15) -- 
    ,targ_err_code varchar2(15) -- 
    ,targ_err_msg varchar2(900) -- 
    ,host_date number(22) -- 
    ,host_serial varchar2(48) -- 
    ,host_trans_code varchar2(15) -- 
    ,host_err_code varchar2(15) -- 
    ,host_err_msg varchar2(900) -- 
    ,status varchar2(2) -- 
    ,trans_time number(22) -- 
    ,offer_charge number(18,2) -- 
    ,insure_print varchar2(48) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(20,4) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbinsurereq to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinsurereq to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinsurereq to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinsurereq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinsurereq is '业务流水表';
comment on column ${iol_schema}.ifms_tbinsurereq.trans_date is '';
comment on column ${iol_schema}.ifms_tbinsurereq.serial_no is '';
comment on column ${iol_schema}.ifms_tbinsurereq.bank_no is '';
comment on column ${iol_schema}.ifms_tbinsurereq.asso_serial is '';
comment on column ${iol_schema}.ifms_tbinsurereq.ta_code is '';
comment on column ${iol_schema}.ifms_tbinsurereq.prd_code is '';
comment on column ${iol_schema}.ifms_tbinsurereq.insure_no is '';
comment on column ${iol_schema}.ifms_tbinsurereq.client_manager is '';
comment on column ${iol_schema}.ifms_tbinsurereq.client_no is '';
comment on column ${iol_schema}.ifms_tbinsurereq.client_type is '';
comment on column ${iol_schema}.ifms_tbinsurereq.trans_code is '';
comment on column ${iol_schema}.ifms_tbinsurereq.trans_name is '';
comment on column ${iol_schema}.ifms_tbinsurereq.bank_acc is '';
comment on column ${iol_schema}.ifms_tbinsurereq.acc_name is '';
comment on column ${iol_schema}.ifms_tbinsurereq.voucher_type is '';
comment on column ${iol_schema}.ifms_tbinsurereq.voucher_no is '';
comment on column ${iol_schema}.ifms_tbinsurereq.voucher_pwd is '';
comment on column ${iol_schema}.ifms_tbinsurereq.voucher_date is '';
comment on column ${iol_schema}.ifms_tbinsurereq.voucher_note is '';
comment on column ${iol_schema}.ifms_tbinsurereq.curr_type is '';
comment on column ${iol_schema}.ifms_tbinsurereq.clear_status is '';
comment on column ${iol_schema}.ifms_tbinsurereq.check_status is '';
comment on column ${iol_schema}.ifms_tbinsurereq.liqu_status is '';
comment on column ${iol_schema}.ifms_tbinsurereq.amt is '';
comment on column ${iol_schema}.ifms_tbinsurereq.charge is '';
comment on column ${iol_schema}.ifms_tbinsurereq.internal_branch is '';
comment on column ${iol_schema}.ifms_tbinsurereq.branch_no is '';
comment on column ${iol_schema}.ifms_tbinsurereq.oper_no is '';
comment on column ${iol_schema}.ifms_tbinsurereq.auth_oper is '';
comment on column ${iol_schema}.ifms_tbinsurereq.term is '';
comment on column ${iol_schema}.ifms_tbinsurereq.channel is '';
comment on column ${iol_schema}.ifms_tbinsurereq.err_code is '';
comment on column ${iol_schema}.ifms_tbinsurereq.err_msg is '';
comment on column ${iol_schema}.ifms_tbinsurereq.insure_date is '';
comment on column ${iol_schema}.ifms_tbinsurereq.insure_cfm_no is '';
comment on column ${iol_schema}.ifms_tbinsurereq.insure_trans_code is '';
comment on column ${iol_schema}.ifms_tbinsurereq.targ_err_code is '';
comment on column ${iol_schema}.ifms_tbinsurereq.targ_err_msg is '';
comment on column ${iol_schema}.ifms_tbinsurereq.host_date is '';
comment on column ${iol_schema}.ifms_tbinsurereq.host_serial is '';
comment on column ${iol_schema}.ifms_tbinsurereq.host_trans_code is '';
comment on column ${iol_schema}.ifms_tbinsurereq.host_err_code is '';
comment on column ${iol_schema}.ifms_tbinsurereq.host_err_msg is '';
comment on column ${iol_schema}.ifms_tbinsurereq.status is '';
comment on column ${iol_schema}.ifms_tbinsurereq.trans_time is '';
comment on column ${iol_schema}.ifms_tbinsurereq.offer_charge is '';
comment on column ${iol_schema}.ifms_tbinsurereq.insure_print is '';
comment on column ${iol_schema}.ifms_tbinsurereq.amt1 is '';
comment on column ${iol_schema}.ifms_tbinsurereq.amt2 is '';
comment on column ${iol_schema}.ifms_tbinsurereq.reserve1 is '';
comment on column ${iol_schema}.ifms_tbinsurereq.reserve2 is '';
comment on column ${iol_schema}.ifms_tbinsurereq.reserve3 is '';
comment on column ${iol_schema}.ifms_tbinsurereq.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbinsurereq.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbinsurereq.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbinsurereq.etl_timestamp is 'ETL处理时间戳';
