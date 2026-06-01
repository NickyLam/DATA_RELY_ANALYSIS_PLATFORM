/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbgoldquotation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbgoldquotation
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbgoldquotation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbgoldquotation(
    prd_code varchar2(30) -- 
    ,valid_date number(22) -- 
    ,start_time number(22) -- 
    ,end_time number(22) -- 
    ,price number(18,8) -- 
    ,oper_no varchar2(48) -- 
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
grant select on ${iol_schema}.ifms_tbgoldquotation to ${iml_schema};
grant select on ${iol_schema}.ifms_tbgoldquotation to ${icl_schema};
grant select on ${iol_schema}.ifms_tbgoldquotation to ${idl_schema};
grant select on ${iol_schema}.ifms_tbgoldquotation to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbgoldquotation is '黄金价值表';
comment on column ${iol_schema}.ifms_tbgoldquotation.prd_code is '';
comment on column ${iol_schema}.ifms_tbgoldquotation.valid_date is '';
comment on column ${iol_schema}.ifms_tbgoldquotation.start_time is '';
comment on column ${iol_schema}.ifms_tbgoldquotation.end_time is '';
comment on column ${iol_schema}.ifms_tbgoldquotation.price is '';
comment on column ${iol_schema}.ifms_tbgoldquotation.oper_no is '';
comment on column ${iol_schema}.ifms_tbgoldquotation.reserve1 is '';
comment on column ${iol_schema}.ifms_tbgoldquotation.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbgoldquotation.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbgoldquotation.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbgoldquotation.etl_timestamp is 'ETL处理时间戳';
