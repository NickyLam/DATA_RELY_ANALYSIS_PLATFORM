/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbshareinsure
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbshareinsure
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbshareinsure purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbshareinsure(
    ta_code varchar2(14) -- 
    ,prd_code varchar2(30) -- 
    ,insure_no varchar2(45) -- 
    ,bank_no varchar2(3) -- 
    ,insure_pwd varchar2(45) -- 
    ,client_manager varchar2(48) -- 
    ,client_no varchar2(36) -- 
    ,holder_name varchar2(75) -- 
    ,holder_id_type varchar2(5) -- 
    ,holder_id_code varchar2(45) -- 
    ,relation varchar2(3) -- 
    ,insured_name varchar2(75) -- 
    ,insured_id_type varchar2(2) -- 
    ,insured_id_code varchar2(45) -- 
    ,insure_print varchar2(48) -- 
    ,insure_publish varchar2(48) -- 
    ,invoice_no varchar2(48) -- 
    ,internal_branch varchar2(18) -- 
    ,branch_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,trans_date number(22) -- 
    ,serial_no varchar2(48) -- 
    ,insure_date number(22) -- 
    ,cfm_date number(22) -- 
    ,pay_year varchar2(3) -- 
    ,insure_year_type varchar2(2) -- 
    ,insure_year varchar2(5) -- 
    ,effect_date number(22) -- 
    ,pay_type varchar2(3) -- 
    ,pay_year_type varchar2(2) -- 
    ,amt number(18,2) -- 
    ,insure_fee number(18,2) -- 
    ,bank_acc varchar2(48) -- 
    ,vol number(22) -- 
    ,status varchar2(2) -- 
    ,recommender varchar2(48) -- 
    ,benici_flag varchar2(2) -- 
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
grant select on ${iol_schema}.ifms_tbshareinsure to ${iml_schema};
grant select on ${iol_schema}.ifms_tbshareinsure to ${icl_schema};
grant select on ${iol_schema}.ifms_tbshareinsure to ${idl_schema};
grant select on ${iol_schema}.ifms_tbshareinsure to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbshareinsure is '保单信息表';
comment on column ${iol_schema}.ifms_tbshareinsure.ta_code is '';
comment on column ${iol_schema}.ifms_tbshareinsure.prd_code is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insure_no is '';
comment on column ${iol_schema}.ifms_tbshareinsure.bank_no is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insure_pwd is '';
comment on column ${iol_schema}.ifms_tbshareinsure.client_manager is '';
comment on column ${iol_schema}.ifms_tbshareinsure.client_no is '';
comment on column ${iol_schema}.ifms_tbshareinsure.holder_name is '';
comment on column ${iol_schema}.ifms_tbshareinsure.holder_id_type is '';
comment on column ${iol_schema}.ifms_tbshareinsure.holder_id_code is '';
comment on column ${iol_schema}.ifms_tbshareinsure.relation is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insured_name is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insured_id_type is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insured_id_code is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insure_print is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insure_publish is '';
comment on column ${iol_schema}.ifms_tbshareinsure.invoice_no is '';
comment on column ${iol_schema}.ifms_tbshareinsure.internal_branch is '';
comment on column ${iol_schema}.ifms_tbshareinsure.branch_no is '';
comment on column ${iol_schema}.ifms_tbshareinsure.oper_no is '';
comment on column ${iol_schema}.ifms_tbshareinsure.trans_date is '';
comment on column ${iol_schema}.ifms_tbshareinsure.serial_no is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insure_date is '';
comment on column ${iol_schema}.ifms_tbshareinsure.cfm_date is '';
comment on column ${iol_schema}.ifms_tbshareinsure.pay_year is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insure_year_type is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insure_year is '';
comment on column ${iol_schema}.ifms_tbshareinsure.effect_date is '';
comment on column ${iol_schema}.ifms_tbshareinsure.pay_type is '';
comment on column ${iol_schema}.ifms_tbshareinsure.pay_year_type is '';
comment on column ${iol_schema}.ifms_tbshareinsure.amt is '';
comment on column ${iol_schema}.ifms_tbshareinsure.insure_fee is '';
comment on column ${iol_schema}.ifms_tbshareinsure.bank_acc is '';
comment on column ${iol_schema}.ifms_tbshareinsure.vol is '';
comment on column ${iol_schema}.ifms_tbshareinsure.status is '';
comment on column ${iol_schema}.ifms_tbshareinsure.recommender is '';
comment on column ${iol_schema}.ifms_tbshareinsure.benici_flag is '';
comment on column ${iol_schema}.ifms_tbshareinsure.reserve1 is '';
comment on column ${iol_schema}.ifms_tbshareinsure.reserve2 is '';
comment on column ${iol_schema}.ifms_tbshareinsure.reserve3 is '';
comment on column ${iol_schema}.ifms_tbshareinsure.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbshareinsure.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbshareinsure.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbshareinsure.etl_timestamp is 'ETL处理时间戳';
