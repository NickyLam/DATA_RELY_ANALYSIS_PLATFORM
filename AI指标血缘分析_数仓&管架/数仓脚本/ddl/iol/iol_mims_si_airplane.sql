/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_airplane
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_airplane
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_airplane purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_airplane(
    sccode varchar2(48) -- 
    ,identyno varchar2(90) -- 
    ,engineno varchar2(90) -- 
    ,isnewhouse varchar2(3) -- 
    ,country varchar2(90) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,equipmentbrand varchar2(150) -- 
    ,specificationno varchar2(90) -- 
    ,load number(20,2) -- 
    ,airplanetype varchar2(3) -- 
    ,enginenum number(22) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,invoiceno varchar2(90) -- 
    ,invoicedate varchar2(15) -- 
    ,invoicemoney number(20,2) -- 
    ,travelleddistance number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_airplane to ${iml_schema};
grant select on ${iol_schema}.mims_si_airplane to ${icl_schema};
grant select on ${iol_schema}.mims_si_airplane to ${idl_schema};
grant select on ${iol_schema}.mims_si_airplane to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_airplane is '民用航空器';
comment on column ${iol_schema}.mims_si_airplane.sccode is '';
comment on column ${iol_schema}.mims_si_airplane.identyno is '';
comment on column ${iol_schema}.mims_si_airplane.engineno is '';
comment on column ${iol_schema}.mims_si_airplane.isnewhouse is '';
comment on column ${iol_schema}.mims_si_airplane.country is '';
comment on column ${iol_schema}.mims_si_airplane.province is '';
comment on column ${iol_schema}.mims_si_airplane.city is '';
comment on column ${iol_schema}.mims_si_airplane.equipmentbrand is '';
comment on column ${iol_schema}.mims_si_airplane.specificationno is '';
comment on column ${iol_schema}.mims_si_airplane.load is '';
comment on column ${iol_schema}.mims_si_airplane.airplanetype is '';
comment on column ${iol_schema}.mims_si_airplane.enginenum is '';
comment on column ${iol_schema}.mims_si_airplane.startdate is '';
comment on column ${iol_schema}.mims_si_airplane.enddate is '';
comment on column ${iol_schema}.mims_si_airplane.invoiceno is '';
comment on column ${iol_schema}.mims_si_airplane.invoicedate is '';
comment on column ${iol_schema}.mims_si_airplane.invoicemoney is '';
comment on column ${iol_schema}.mims_si_airplane.travelleddistance is '';
comment on column ${iol_schema}.mims_si_airplane.remark is '';
comment on column ${iol_schema}.mims_si_airplane.tdcurrency is '';
comment on column ${iol_schema}.mims_si_airplane.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_airplane.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_airplane.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_airplane.etl_timestamp is 'ETL处理时间戳';
