/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_motor
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_motor
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_motor purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_motor(
    sccode varchar2(48) -- 
    ,registno varchar2(90) -- 
    ,drivelicense varchar2(150) -- 
    ,vehicleno varchar2(150) -- 
    ,engineno varchar2(150) -- 
    ,plateno varchar2(45) -- 
    ,isnewhouse varchar2(3) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,equipmentbrand varchar2(150) -- 
    ,specificationno varchar2(90) -- 
    ,capacity number(20,2) -- 
    ,speedtype varchar2(3) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,range number(20,2) -- 
    ,isoperate varchar2(3) -- 
    ,operatetype varchar2(3) -- 
    ,invoiceno varchar2(90) -- 
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
grant select on ${iol_schema}.mims_si_motor to ${iml_schema};
grant select on ${iol_schema}.mims_si_motor to ${icl_schema};
grant select on ${iol_schema}.mims_si_motor to ${idl_schema};
grant select on ${iol_schema}.mims_si_motor to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_motor is '机动车';
comment on column ${iol_schema}.mims_si_motor.sccode is '';
comment on column ${iol_schema}.mims_si_motor.registno is '';
comment on column ${iol_schema}.mims_si_motor.drivelicense is '';
comment on column ${iol_schema}.mims_si_motor.vehicleno is '';
comment on column ${iol_schema}.mims_si_motor.engineno is '';
comment on column ${iol_schema}.mims_si_motor.plateno is '';
comment on column ${iol_schema}.mims_si_motor.isnewhouse is '';
comment on column ${iol_schema}.mims_si_motor.province is '';
comment on column ${iol_schema}.mims_si_motor.city is '';
comment on column ${iol_schema}.mims_si_motor.equipmentbrand is '';
comment on column ${iol_schema}.mims_si_motor.specificationno is '';
comment on column ${iol_schema}.mims_si_motor.capacity is '';
comment on column ${iol_schema}.mims_si_motor.speedtype is '';
comment on column ${iol_schema}.mims_si_motor.startdate is '';
comment on column ${iol_schema}.mims_si_motor.enddate is '';
comment on column ${iol_schema}.mims_si_motor.range is '';
comment on column ${iol_schema}.mims_si_motor.isoperate is '';
comment on column ${iol_schema}.mims_si_motor.operatetype is '';
comment on column ${iol_schema}.mims_si_motor.invoiceno is '';
comment on column ${iol_schema}.mims_si_motor.remark is '';
comment on column ${iol_schema}.mims_si_motor.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_motor.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_motor.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_motor.etl_timestamp is 'ETL处理时间戳';
