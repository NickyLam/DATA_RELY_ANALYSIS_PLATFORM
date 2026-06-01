/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_buy_transaction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_buy_transaction
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_buy_transaction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_buy_transaction(
    sysordid varchar2(45) -- 交易序号
    ,intordid varchar2(45) -- 交易单号
    ,ord_data varchar2(30) -- 交易日期
    ,ord_count varchar2(45) -- 券面总额
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
grant select on ${iol_schema}.ibms_ttrd_buy_transaction to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_buy_transaction to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_buy_transaction to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_buy_transaction to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_buy_transaction is '买入交易信息';
comment on column ${iol_schema}.ibms_ttrd_buy_transaction.sysordid is '交易序号';
comment on column ${iol_schema}.ibms_ttrd_buy_transaction.intordid is '交易单号';
comment on column ${iol_schema}.ibms_ttrd_buy_transaction.ord_data is '交易日期';
comment on column ${iol_schema}.ibms_ttrd_buy_transaction.ord_count is '券面总额';
comment on column ${iol_schema}.ibms_ttrd_buy_transaction.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_buy_transaction.etl_timestamp is 'ETL处理时间戳';
