/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_equipment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_equipment
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_equipment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_equipment(
    sccode varchar2(48) -- 
    ,equipno varchar2(90) -- 
    ,isnewhouse varchar2(3) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,equiptype varchar2(3) -- 
    ,equipsort varchar2(45) -- 
    ,specificationno varchar2(90) -- 
    ,equipmentbrand varchar2(150) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,isqualify varchar2(3) -- 
    ,invoiceno varchar2(90) -- 
    ,invoicedate varchar2(15) -- 
    ,invoicemoney number(20,2) -- 
    ,tdcurrency varchar2(5) -- 
    ,remark varchar2(4000) -- 
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
grant select on ${iol_schema}.mims_si_equipment to ${iml_schema};
grant select on ${iol_schema}.mims_si_equipment to ${icl_schema};
grant select on ${iol_schema}.mims_si_equipment to ${idl_schema};
grant select on ${iol_schema}.mims_si_equipment to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_equipment is '机器设备';
comment on column ${iol_schema}.mims_si_equipment.sccode is '';
comment on column ${iol_schema}.mims_si_equipment.equipno is '';
comment on column ${iol_schema}.mims_si_equipment.isnewhouse is '';
comment on column ${iol_schema}.mims_si_equipment.province is '';
comment on column ${iol_schema}.mims_si_equipment.city is '';
comment on column ${iol_schema}.mims_si_equipment.equiptype is '';
comment on column ${iol_schema}.mims_si_equipment.equipsort is '';
comment on column ${iol_schema}.mims_si_equipment.specificationno is '';
comment on column ${iol_schema}.mims_si_equipment.equipmentbrand is '';
comment on column ${iol_schema}.mims_si_equipment.startdate is '';
comment on column ${iol_schema}.mims_si_equipment.enddate is '';
comment on column ${iol_schema}.mims_si_equipment.isqualify is '';
comment on column ${iol_schema}.mims_si_equipment.invoiceno is '';
comment on column ${iol_schema}.mims_si_equipment.invoicedate is '';
comment on column ${iol_schema}.mims_si_equipment.invoicemoney is '';
comment on column ${iol_schema}.mims_si_equipment.tdcurrency is '';
comment on column ${iol_schema}.mims_si_equipment.remark is '';
comment on column ${iol_schema}.mims_si_equipment.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_equipment.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_equipment.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_equipment.etl_timestamp is 'ETL处理时间戳';
