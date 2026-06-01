/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_landright
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_landright
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_landright purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_landright(
    sccode varchar2(48) -- 
    ,landno varchar2(90) -- 
    ,warrantsno varchar2(300) -- 
    ,landstartdate varchar2(15) -- 
    ,landenddate varchar2(15) -- 
    ,landarea number(20,2) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,address varchar2(300) -- 
    ,tradedate varchar2(15) -- 
    ,tradeprice number(20,2) -- 
    ,remark varchar2(4000) -- 
    ,tdcurrency varchar2(5) -- 
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
grant select on ${iol_schema}.mims_si_landright to ${iml_schema};
grant select on ${iol_schema}.mims_si_landright to ${icl_schema};
grant select on ${iol_schema}.mims_si_landright to ${idl_schema};
grant select on ${iol_schema}.mims_si_landright to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_landright is '土地承包经营权';
comment on column ${iol_schema}.mims_si_landright.sccode is '';
comment on column ${iol_schema}.mims_si_landright.landno is '';
comment on column ${iol_schema}.mims_si_landright.warrantsno is '';
comment on column ${iol_schema}.mims_si_landright.landstartdate is '';
comment on column ${iol_schema}.mims_si_landright.landenddate is '';
comment on column ${iol_schema}.mims_si_landright.landarea is '';
comment on column ${iol_schema}.mims_si_landright.province is '';
comment on column ${iol_schema}.mims_si_landright.city is '';
comment on column ${iol_schema}.mims_si_landright.address is '';
comment on column ${iol_schema}.mims_si_landright.tradedate is '';
comment on column ${iol_schema}.mims_si_landright.tradeprice is '';
comment on column ${iol_schema}.mims_si_landright.remark is '';
comment on column ${iol_schema}.mims_si_landright.tdcurrency is '';
comment on column ${iol_schema}.mims_si_landright.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_landright.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_landright.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_landright.etl_timestamp is 'ETL处理时间戳';
