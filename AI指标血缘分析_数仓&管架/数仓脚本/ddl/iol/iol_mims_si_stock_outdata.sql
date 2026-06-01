/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_stock_outdata
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_stock_outdata
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_stock_outdata purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_stock_outdata(
    datecode varchar2(15) -- 
    ,interestno varchar2(90) -- 
    ,interestname varchar2(300) -- 
    ,newprice number(20,2) -- 
    ,scope number(20,6) -- 
    ,lastdayprice number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_stock_outdata to ${iml_schema};
grant select on ${iol_schema}.mims_si_stock_outdata to ${icl_schema};
grant select on ${iol_schema}.mims_si_stock_outdata to ${idl_schema};
grant select on ${iol_schema}.mims_si_stock_outdata to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_stock_outdata is '股票信息表-外部数据';
comment on column ${iol_schema}.mims_si_stock_outdata.datecode is '';
comment on column ${iol_schema}.mims_si_stock_outdata.interestno is '';
comment on column ${iol_schema}.mims_si_stock_outdata.interestname is '';
comment on column ${iol_schema}.mims_si_stock_outdata.newprice is '';
comment on column ${iol_schema}.mims_si_stock_outdata.scope is '';
comment on column ${iol_schema}.mims_si_stock_outdata.lastdayprice is '';
comment on column ${iol_schema}.mims_si_stock_outdata.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_stock_outdata.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_stock_outdata.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_stock_outdata.etl_timestamp is 'ETL处理时间戳';
