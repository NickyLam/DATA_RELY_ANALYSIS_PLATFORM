/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbincome
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbincome(
    cfm_date number(22) -- 
    ,asset_acc varchar2(30) -- 
    ,ta_client varchar2(32) -- 
    ,prd_code varchar2(32) -- 
    ,share_class varchar2(3) -- 
    ,seller_code varchar2(14) -- 
    ,income number(24,8) -- 
    ,frozen_income number(18,2) -- 
    ,income_new number(18,2) -- 
    ,real_vol number(18,3) -- 
    ,frozen_vol number(18,3) -- 
    ,return_fee number(18,2) -- 
    ,return_fee_new number(18,2) -- 
    ,amt1 number(18,2) -- 
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
grant select on ${iol_schema}.ifms_tbincome to ${iml_schema};
grant select on ${iol_schema}.ifms_tbincome to ${icl_schema};
grant select on ${iol_schema}.ifms_tbincome to ${idl_schema};
grant select on ${iol_schema}.ifms_tbincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbincome is '账户未付收益表';
comment on column ${iol_schema}.ifms_tbincome.cfm_date is '';
comment on column ${iol_schema}.ifms_tbincome.asset_acc is '';
comment on column ${iol_schema}.ifms_tbincome.ta_client is '';
comment on column ${iol_schema}.ifms_tbincome.prd_code is '';
comment on column ${iol_schema}.ifms_tbincome.share_class is '';
comment on column ${iol_schema}.ifms_tbincome.seller_code is '';
comment on column ${iol_schema}.ifms_tbincome.income is '';
comment on column ${iol_schema}.ifms_tbincome.frozen_income is '';
comment on column ${iol_schema}.ifms_tbincome.income_new is '';
comment on column ${iol_schema}.ifms_tbincome.real_vol is '';
comment on column ${iol_schema}.ifms_tbincome.frozen_vol is '';
comment on column ${iol_schema}.ifms_tbincome.return_fee is '';
comment on column ${iol_schema}.ifms_tbincome.return_fee_new is '';
comment on column ${iol_schema}.ifms_tbincome.amt1 is '';
comment on column ${iol_schema}.ifms_tbincome.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbincome.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbincome.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbincome.etl_timestamp is 'ETL处理时间戳';
