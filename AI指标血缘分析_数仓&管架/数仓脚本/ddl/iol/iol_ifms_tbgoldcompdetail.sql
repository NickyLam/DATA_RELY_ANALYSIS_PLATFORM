/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbgoldcompdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbgoldcompdetail
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbgoldcompdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbgoldcompdetail(
    serial_no varchar2(48) -- 
    ,bank_no varchar2(3) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,gold_amt number(18,2) -- 
    ,amt number(18,2) -- 
    ,gold_bank_acc varchar2(48) -- 
    ,bank_acc varchar2(48) -- 
    ,gold_client_no varchar2(30) -- 
    ,b_gold_client_no varchar2(30) -- 
    ,gold_transfer_type varchar2(2) -- 
    ,transfer_type varchar2(30) -- 
    ,gold_curr_type varchar2(5) -- 
    ,curr_type varchar2(5) -- 
    ,status varchar2(2) -- 
    ,unequa_flag varchar2(60) -- 
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
grant select on ${iol_schema}.ifms_tbgoldcompdetail to ${iml_schema};
grant select on ${iol_schema}.ifms_tbgoldcompdetail to ${icl_schema};
grant select on ${iol_schema}.ifms_tbgoldcompdetail to ${idl_schema};
grant select on ${iol_schema}.ifms_tbgoldcompdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbgoldcompdetail is '黄金对账明细表';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.serial_no is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.bank_no is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.trans_date is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.trans_time is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.gold_amt is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.amt is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.gold_bank_acc is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.bank_acc is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.gold_client_no is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.b_gold_client_no is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.gold_transfer_type is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.transfer_type is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.gold_curr_type is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.curr_type is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.status is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.unequa_flag is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.reserve1 is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.reserve2 is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.reserve3 is '';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbgoldcompdetail.etl_timestamp is 'ETL处理时间戳';
