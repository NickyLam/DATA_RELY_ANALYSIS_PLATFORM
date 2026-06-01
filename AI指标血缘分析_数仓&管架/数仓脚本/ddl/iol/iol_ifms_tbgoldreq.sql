/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbgoldreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbgoldreq
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbgoldreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbgoldreq(
    serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,bank_no varchar2(3) -- 
    ,term_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,auth_oper varchar2(48) -- 
    ,branch_no varchar2(24) -- 
    ,channel varchar2(2) -- 
    ,gold_date number(22) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,client_manager varchar2(48) -- 
    ,trans_type varchar2(2) -- 
    ,asso_serial varchar2(48) -- 
    ,trans_code varchar2(9) -- 
    ,gold_client_no varchar2(30) -- 
    ,area_code varchar2(24) -- 
    ,center_code varchar2(30) -- 
    ,transfer_type varchar2(2) -- 
    ,client_name varchar2(375) -- 
    ,id_type varchar2(2) -- 
    ,id_code varchar2(45) -- 
    ,in_client_no varchar2(36) -- 
    ,client_no varchar2(36) -- 
    ,client_type varchar2(2) -- 
    ,bank_acc varchar2(48) -- 
    ,liqu_status varchar2(2) -- 
    ,curr_type varchar2(5) -- 
    ,cash_flag varchar2(2) -- 
    ,check_date number(22) -- 
    ,amt number(18,2) -- 
    ,gold_account varchar2(48) -- 
    ,targ_bank_acc varchar2(48) -- 
    ,host_trans_code varchar2(9) -- 
    ,to_host_serial varchar2(48) -- 
    ,host_date number(22) -- 
    ,host_serial varchar2(48) -- 
    ,host_err_code varchar2(15) -- 
    ,host_err_msg varchar2(150) -- 
    ,err_code varchar2(11) -- 
    ,err_msg varchar2(150) -- 
    ,status varchar2(2) -- 
    ,amt1 number(18,2) -- 
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
grant select on ${iol_schema}.ifms_tbgoldreq to ${iml_schema};
grant select on ${iol_schema}.ifms_tbgoldreq to ${icl_schema};
grant select on ${iol_schema}.ifms_tbgoldreq to ${idl_schema};
grant select on ${iol_schema}.ifms_tbgoldreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbgoldreq is '黄金业务流水表';
comment on column ${iol_schema}.ifms_tbgoldreq.serial_no is '';
comment on column ${iol_schema}.ifms_tbgoldreq.ex_serial is '';
comment on column ${iol_schema}.ifms_tbgoldreq.bank_no is '';
comment on column ${iol_schema}.ifms_tbgoldreq.term_no is '';
comment on column ${iol_schema}.ifms_tbgoldreq.oper_no is '';
comment on column ${iol_schema}.ifms_tbgoldreq.auth_oper is '';
comment on column ${iol_schema}.ifms_tbgoldreq.branch_no is '';
comment on column ${iol_schema}.ifms_tbgoldreq.channel is '';
comment on column ${iol_schema}.ifms_tbgoldreq.gold_date is '';
comment on column ${iol_schema}.ifms_tbgoldreq.trans_date is '';
comment on column ${iol_schema}.ifms_tbgoldreq.trans_time is '';
comment on column ${iol_schema}.ifms_tbgoldreq.client_manager is '';
comment on column ${iol_schema}.ifms_tbgoldreq.trans_type is '';
comment on column ${iol_schema}.ifms_tbgoldreq.asso_serial is '';
comment on column ${iol_schema}.ifms_tbgoldreq.trans_code is '';
comment on column ${iol_schema}.ifms_tbgoldreq.gold_client_no is '';
comment on column ${iol_schema}.ifms_tbgoldreq.area_code is '';
comment on column ${iol_schema}.ifms_tbgoldreq.center_code is '';
comment on column ${iol_schema}.ifms_tbgoldreq.transfer_type is '';
comment on column ${iol_schema}.ifms_tbgoldreq.client_name is '';
comment on column ${iol_schema}.ifms_tbgoldreq.id_type is '';
comment on column ${iol_schema}.ifms_tbgoldreq.id_code is '';
comment on column ${iol_schema}.ifms_tbgoldreq.in_client_no is '';
comment on column ${iol_schema}.ifms_tbgoldreq.client_no is '';
comment on column ${iol_schema}.ifms_tbgoldreq.client_type is '';
comment on column ${iol_schema}.ifms_tbgoldreq.bank_acc is '';
comment on column ${iol_schema}.ifms_tbgoldreq.liqu_status is '';
comment on column ${iol_schema}.ifms_tbgoldreq.curr_type is '';
comment on column ${iol_schema}.ifms_tbgoldreq.cash_flag is '';
comment on column ${iol_schema}.ifms_tbgoldreq.check_date is '';
comment on column ${iol_schema}.ifms_tbgoldreq.amt is '';
comment on column ${iol_schema}.ifms_tbgoldreq.gold_account is '';
comment on column ${iol_schema}.ifms_tbgoldreq.targ_bank_acc is '';
comment on column ${iol_schema}.ifms_tbgoldreq.host_trans_code is '';
comment on column ${iol_schema}.ifms_tbgoldreq.to_host_serial is '';
comment on column ${iol_schema}.ifms_tbgoldreq.host_date is '';
comment on column ${iol_schema}.ifms_tbgoldreq.host_serial is '';
comment on column ${iol_schema}.ifms_tbgoldreq.host_err_code is '';
comment on column ${iol_schema}.ifms_tbgoldreq.host_err_msg is '';
comment on column ${iol_schema}.ifms_tbgoldreq.err_code is '';
comment on column ${iol_schema}.ifms_tbgoldreq.err_msg is '';
comment on column ${iol_schema}.ifms_tbgoldreq.status is '';
comment on column ${iol_schema}.ifms_tbgoldreq.amt1 is '';
comment on column ${iol_schema}.ifms_tbgoldreq.reserve1 is '';
comment on column ${iol_schema}.ifms_tbgoldreq.reserve2 is '';
comment on column ${iol_schema}.ifms_tbgoldreq.reserve3 is '';
comment on column ${iol_schema}.ifms_tbgoldreq.reserve4 is '';
comment on column ${iol_schema}.ifms_tbgoldreq.reserve5 is '';
comment on column ${iol_schema}.ifms_tbgoldreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbgoldreq.etl_timestamp is 'ETL处理时间戳';
