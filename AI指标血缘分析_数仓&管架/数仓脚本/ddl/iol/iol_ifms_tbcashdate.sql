/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbcashdate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbcashdate
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbcashdate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbcashdate(
    cash_date number(22) -- 
    ,prd_code varchar2(30) -- 
    ,deal_status varchar2(2) -- 
    ,deal_date number(22) -- 
    ,reserve1 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbcashdate to ${iml_schema};
grant select on ${iol_schema}.ifms_tbcashdate to ${icl_schema};
grant select on ${iol_schema}.ifms_tbcashdate to ${idl_schema};
grant select on ${iol_schema}.ifms_tbcashdate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbcashdate is '货币式产品兑付日表';
comment on column ${iol_schema}.ifms_tbcashdate.cash_date is '';
comment on column ${iol_schema}.ifms_tbcashdate.prd_code is '';
comment on column ${iol_schema}.ifms_tbcashdate.deal_status is '';
comment on column ${iol_schema}.ifms_tbcashdate.deal_date is '';
comment on column ${iol_schema}.ifms_tbcashdate.reserve1 is '';
comment on column ${iol_schema}.ifms_tbcashdate.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbcashdate.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbcashdate.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbcashdate.etl_timestamp is 'ETL处理时间戳';
