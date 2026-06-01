/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbg06exchange
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbg06exchange
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbg06exchange purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbg06exchange(
    cfm_date number(22) -- 
    ,curr_type varchar2(5) -- 
    ,exchange number(18,8) -- 
    ,unit number(18,2) -- 
    ,to_rmb_flag varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,2) -- 
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
grant select on ${iol_schema}.ifms_tbg06exchange to ${iml_schema};
grant select on ${iol_schema}.ifms_tbg06exchange to ${icl_schema};
grant select on ${iol_schema}.ifms_tbg06exchange to ${idl_schema};
grant select on ${iol_schema}.ifms_tbg06exchange to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbg06exchange is 'G06汇率表汇率表';
comment on column ${iol_schema}.ifms_tbg06exchange.cfm_date is '';
comment on column ${iol_schema}.ifms_tbg06exchange.curr_type is '';
comment on column ${iol_schema}.ifms_tbg06exchange.exchange is '';
comment on column ${iol_schema}.ifms_tbg06exchange.unit is '';
comment on column ${iol_schema}.ifms_tbg06exchange.to_rmb_flag is '';
comment on column ${iol_schema}.ifms_tbg06exchange.reserve1 is '';
comment on column ${iol_schema}.ifms_tbg06exchange.reserve2 is '';
comment on column ${iol_schema}.ifms_tbg06exchange.amt1 is '';
comment on column ${iol_schema}.ifms_tbg06exchange.amt2 is '';
comment on column ${iol_schema}.ifms_tbg06exchange.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbg06exchange.etl_timestamp is 'ETL处理时间戳';
