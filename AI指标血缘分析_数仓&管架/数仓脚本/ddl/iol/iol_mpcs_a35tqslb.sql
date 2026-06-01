/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a35tqslb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a35tqslb
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a35tqslb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a35tqslb(
    seccd varchar2(15) -- 
    ,secname varchar2(90) -- 
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
grant select on ${iol_schema}.mpcs_a35tqslb to ${iml_schema};
grant select on ${iol_schema}.mpcs_a35tqslb to ${icl_schema};
grant select on ${iol_schema}.mpcs_a35tqslb to ${idl_schema};
grant select on ${iol_schema}.mpcs_a35tqslb to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a35tqslb is '';
comment on column ${iol_schema}.mpcs_a35tqslb.seccd is '';
comment on column ${iol_schema}.mpcs_a35tqslb.secname is '';
comment on column ${iol_schema}.mpcs_a35tqslb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a35tqslb.etl_timestamp is 'ETL处理时间戳';
