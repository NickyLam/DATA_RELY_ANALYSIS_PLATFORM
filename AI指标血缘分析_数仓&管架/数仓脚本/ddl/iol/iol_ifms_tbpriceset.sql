/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbpriceset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbpriceset
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbpriceset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbpriceset(
    serial_no varchar2(48) -- 
    ,prd_code varchar2(30) -- 
    ,valid_date number(22) -- 
    ,price_mode varchar2(2) -- 
    ,seller_code varchar2(14) -- 
    ,client_group varchar2(2) -- 
    ,client_type varchar2(2) -- 
    ,seller_type varchar2(2) -- 
    ,channel varchar2(2) -- 
    ,hold_days number(22) -- 
    ,min_hold_days number(22) -- 
    ,max_hold_days number(22) -- 
    ,min_hold_amt number(18,2) -- 
    ,max_hold_amt number(18,2) -- 
    ,client_ratio number(9,8) -- 
    ,bank_ratio number(9,8) -- 
    ,min_income number(18,2) -- 
    ,max_income number(18,2) -- 
    ,default_flag varchar2(2) -- 
    ,amt1 number(18,2) -- 
    ,ratio1 number(9,8) -- 
    ,ratio2 number(9,8) -- 
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
grant select on ${iol_schema}.ifms_tbpriceset to ${iml_schema};
grant select on ${iol_schema}.ifms_tbpriceset to ${icl_schema};
grant select on ${iol_schema}.ifms_tbpriceset to ${idl_schema};
grant select on ${iol_schema}.ifms_tbpriceset to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbpriceset is '产品收益率设置表';
comment on column ${iol_schema}.ifms_tbpriceset.serial_no is '';
comment on column ${iol_schema}.ifms_tbpriceset.prd_code is '';
comment on column ${iol_schema}.ifms_tbpriceset.valid_date is '';
comment on column ${iol_schema}.ifms_tbpriceset.price_mode is '';
comment on column ${iol_schema}.ifms_tbpriceset.seller_code is '';
comment on column ${iol_schema}.ifms_tbpriceset.client_group is '';
comment on column ${iol_schema}.ifms_tbpriceset.client_type is '';
comment on column ${iol_schema}.ifms_tbpriceset.seller_type is '';
comment on column ${iol_schema}.ifms_tbpriceset.channel is '';
comment on column ${iol_schema}.ifms_tbpriceset.hold_days is '';
comment on column ${iol_schema}.ifms_tbpriceset.min_hold_days is '';
comment on column ${iol_schema}.ifms_tbpriceset.max_hold_days is '';
comment on column ${iol_schema}.ifms_tbpriceset.min_hold_amt is '';
comment on column ${iol_schema}.ifms_tbpriceset.max_hold_amt is '';
comment on column ${iol_schema}.ifms_tbpriceset.client_ratio is '';
comment on column ${iol_schema}.ifms_tbpriceset.bank_ratio is '';
comment on column ${iol_schema}.ifms_tbpriceset.min_income is '';
comment on column ${iol_schema}.ifms_tbpriceset.max_income is '';
comment on column ${iol_schema}.ifms_tbpriceset.default_flag is '';
comment on column ${iol_schema}.ifms_tbpriceset.amt1 is '';
comment on column ${iol_schema}.ifms_tbpriceset.ratio1 is '';
comment on column ${iol_schema}.ifms_tbpriceset.ratio2 is '';
comment on column ${iol_schema}.ifms_tbpriceset.reserve1 is '';
comment on column ${iol_schema}.ifms_tbpriceset.reserve2 is '';
comment on column ${iol_schema}.ifms_tbpriceset.reserve3 is '';
comment on column ${iol_schema}.ifms_tbpriceset.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbpriceset.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbpriceset.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbpriceset.etl_timestamp is 'ETL处理时间戳';
