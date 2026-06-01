/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_acc_cash_ext_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_acc_cash_ext_map
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_acc_cash_ext_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_cash_ext_map(
    cash_ext_accid varchar2(30) -- 一级资金账户
    ,cash_accid varchar2(45) -- 二级资金账户
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
grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext_map to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext_map to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext_map to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_acc_cash_ext_map is '一级二级资金账户关联关系';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext_map.cash_ext_accid is '一级资金账户';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext_map.cash_accid is '二级资金账户';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext_map.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext_map.etl_timestamp is 'ETL处理时间戳';
