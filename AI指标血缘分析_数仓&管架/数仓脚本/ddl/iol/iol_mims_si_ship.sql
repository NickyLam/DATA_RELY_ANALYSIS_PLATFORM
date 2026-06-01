/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_ship
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_ship
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_ship purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_ship(
    sccode varchar2(48) -- 
    ,identyno varchar2(150) -- 
    ,registno varchar2(90) -- 
    ,shipcerno varchar2(90) -- 
    ,engineno varchar2(90) -- 
    ,plateno varchar2(90) -- 
    ,isnewhouse varchar2(3) -- 
    ,country varchar2(90) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,equipmentbrand varchar2(150) -- 
    ,specificationno varchar2(90) -- 
    ,shiptype varchar2(3) -- 
    ,fullcapacity number(20,2) -- 
    ,netcapacity number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_ship to ${iml_schema};
grant select on ${iol_schema}.mims_si_ship to ${icl_schema};
grant select on ${iol_schema}.mims_si_ship to ${idl_schema};
grant select on ${iol_schema}.mims_si_ship to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_ship is '船舶';
comment on column ${iol_schema}.mims_si_ship.sccode is '';
comment on column ${iol_schema}.mims_si_ship.identyno is '';
comment on column ${iol_schema}.mims_si_ship.registno is '';
comment on column ${iol_schema}.mims_si_ship.shipcerno is '';
comment on column ${iol_schema}.mims_si_ship.engineno is '';
comment on column ${iol_schema}.mims_si_ship.plateno is '';
comment on column ${iol_schema}.mims_si_ship.isnewhouse is '';
comment on column ${iol_schema}.mims_si_ship.country is '';
comment on column ${iol_schema}.mims_si_ship.province is '';
comment on column ${iol_schema}.mims_si_ship.city is '';
comment on column ${iol_schema}.mims_si_ship.equipmentbrand is '';
comment on column ${iol_schema}.mims_si_ship.specificationno is '';
comment on column ${iol_schema}.mims_si_ship.shiptype is '';
comment on column ${iol_schema}.mims_si_ship.fullcapacity is '';
comment on column ${iol_schema}.mims_si_ship.netcapacity is '';
comment on column ${iol_schema}.mims_si_ship.startdate is '';
comment on column ${iol_schema}.mims_si_ship.enddate is '';
comment on column ${iol_schema}.mims_si_ship.invoiceno is '';
comment on column ${iol_schema}.mims_si_ship.invoicedate is '';
comment on column ${iol_schema}.mims_si_ship.invoicemoney is '';
comment on column ${iol_schema}.mims_si_ship.remark is '';
comment on column ${iol_schema}.mims_si_ship.tdcurrency is '';
comment on column ${iol_schema}.mims_si_ship.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_ship.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_ship.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_ship.etl_timestamp is 'ETL处理时间戳';
