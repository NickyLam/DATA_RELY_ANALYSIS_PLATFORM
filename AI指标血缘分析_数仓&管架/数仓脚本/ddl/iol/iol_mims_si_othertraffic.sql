/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_othertraffic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_othertraffic
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_othertraffic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_othertraffic(
    sccode varchar2(48) -- 
    ,identyno varchar2(90) -- 
    ,registno varchar2(90) -- 
    ,shipcerno varchar2(90) -- 
    ,engineno varchar2(90) -- 
    ,plateno varchar2(90) -- 
    ,isnewhouse varchar2(3) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,equipmentbrand varchar2(150) -- 
    ,specificationno varchar2(90) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,invoiceno varchar2(90) -- 
    ,invoicedate varchar2(15) -- 
    ,invoicemoney number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_othertraffic to ${iml_schema};
grant select on ${iol_schema}.mims_si_othertraffic to ${icl_schema};
grant select on ${iol_schema}.mims_si_othertraffic to ${idl_schema};
grant select on ${iol_schema}.mims_si_othertraffic to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_othertraffic is '其他交通工具';
comment on column ${iol_schema}.mims_si_othertraffic.sccode is '';
comment on column ${iol_schema}.mims_si_othertraffic.identyno is '';
comment on column ${iol_schema}.mims_si_othertraffic.registno is '';
comment on column ${iol_schema}.mims_si_othertraffic.shipcerno is '';
comment on column ${iol_schema}.mims_si_othertraffic.engineno is '';
comment on column ${iol_schema}.mims_si_othertraffic.plateno is '';
comment on column ${iol_schema}.mims_si_othertraffic.isnewhouse is '';
comment on column ${iol_schema}.mims_si_othertraffic.province is '';
comment on column ${iol_schema}.mims_si_othertraffic.city is '';
comment on column ${iol_schema}.mims_si_othertraffic.equipmentbrand is '';
comment on column ${iol_schema}.mims_si_othertraffic.specificationno is '';
comment on column ${iol_schema}.mims_si_othertraffic.startdate is '';
comment on column ${iol_schema}.mims_si_othertraffic.enddate is '';
comment on column ${iol_schema}.mims_si_othertraffic.invoiceno is '';
comment on column ${iol_schema}.mims_si_othertraffic.invoicedate is '';
comment on column ${iol_schema}.mims_si_othertraffic.invoicemoney is '';
comment on column ${iol_schema}.mims_si_othertraffic.remark is '';
comment on column ${iol_schema}.mims_si_othertraffic.tdcurrency is '';
comment on column ${iol_schema}.mims_si_othertraffic.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_othertraffic.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_othertraffic.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_othertraffic.etl_timestamp is 'ETL处理时间戳';
