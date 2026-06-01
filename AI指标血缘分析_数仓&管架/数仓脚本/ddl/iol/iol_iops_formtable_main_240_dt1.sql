/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iops_formtable_main_240_dt1
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iops_formtable_main_240_dt1
whenever sqlerror continue none;
drop table ${iol_schema}.iops_formtable_main_240_dt1 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iops_formtable_main_240_dt1(
    id number(38,0) -- 
    ,mainid number(38,0) -- 
    ,qjlx number(38,0) -- 
    ,syjq varchar2(4000) -- 
    ,sqkssj varchar2(4000) -- 
    ,sqjssj varchar2(4000) -- 
    ,sqgj varchar2(4000) -- 
    ,sjkssj varchar2(4000) -- 
    ,sjjssj varchar2(4000) -- 
    ,sjgj varchar2(4000) -- 
    ,kssjsfcz varchar2(500) -- 
    ,jssjsfcz varchar2(500) -- 
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
grant select on ${iol_schema}.iops_formtable_main_240_dt1 to ${iml_schema};
grant select on ${iol_schema}.iops_formtable_main_240_dt1 to ${icl_schema};
grant select on ${iol_schema}.iops_formtable_main_240_dt1 to ${idl_schema};
grant select on ${iol_schema}.iops_formtable_main_240_dt1 to ${iel_schema};

-- comment
comment on table ${iol_schema}.iops_formtable_main_240_dt1 is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.id is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.mainid is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.qjlx is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.syjq is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.sqkssj is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.sqjssj is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.sqgj is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.sjkssj is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.sjjssj is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.sjgj is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.kssjsfcz is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.jssjsfcz is '';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.iops_formtable_main_240_dt1.etl_timestamp is 'ETL处理时间戳';
