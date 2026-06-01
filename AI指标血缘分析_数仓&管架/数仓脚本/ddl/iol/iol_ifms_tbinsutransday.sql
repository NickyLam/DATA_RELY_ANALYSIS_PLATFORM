/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinsutransday
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinsutransday
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinsutransday purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsutransday(
    date_type varchar2(2) -- 处理类型
    ,asso_code varchar2(30) -- 原交易代码
    ,trans_date number(22) -- 交易日期
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
grant select on ${iol_schema}.ifms_tbinsutransday to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinsutransday to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinsutransday to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinsutransday to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinsutransday is '保险节假日表';
comment on column ${iol_schema}.ifms_tbinsutransday.date_type is '处理类型';
comment on column ${iol_schema}.ifms_tbinsutransday.asso_code is '原交易代码';
comment on column ${iol_schema}.ifms_tbinsutransday.trans_date is '交易日期';
comment on column ${iol_schema}.ifms_tbinsutransday.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbinsutransday.etl_timestamp is 'ETL处理时间戳';
