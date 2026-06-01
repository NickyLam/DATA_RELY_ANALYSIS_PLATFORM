/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_rate_index_value
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_rate_index_value
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_rate_index_value purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_rate_index_value(
    rate_index varchar2(24) -- 
    ,rate_date varchar2(12) -- 
    ,rate number(17,12) -- 
    ,status_flag varchar2(3) -- 
    ,modify_user number(5,0) -- 
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
grant select on ${iol_schema}.ctms_tbs_rate_index_value to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_rate_index_value to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_rate_index_value to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_rate_index_value to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_rate_index_value is '利率行情表';
comment on column ${iol_schema}.ctms_tbs_rate_index_value.rate_index is '';
comment on column ${iol_schema}.ctms_tbs_rate_index_value.rate_date is '';
comment on column ${iol_schema}.ctms_tbs_rate_index_value.rate is '';
comment on column ${iol_schema}.ctms_tbs_rate_index_value.status_flag is '';
comment on column ${iol_schema}.ctms_tbs_rate_index_value.modify_user is '';
comment on column ${iol_schema}.ctms_tbs_rate_index_value.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_tbs_rate_index_value.etl_timestamp is 'ETL处理时间戳';
