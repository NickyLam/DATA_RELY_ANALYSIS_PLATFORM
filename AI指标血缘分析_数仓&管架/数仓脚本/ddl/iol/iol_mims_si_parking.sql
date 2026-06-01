/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_parking
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_parking
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_parking purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_parking(
    sccode varchar2(48) -- 
    ,isindepcard varchar2(90) -- 
    ,parktype varchar2(3) -- 
    ,contno varchar2(90) -- 
    ,tradedate varchar2(15) -- 
    ,tradeprice number(20,2) -- 
    ,buildingarea number(20,2) -- 
    ,usearea number(20,2) -- 
    ,createyear varchar2(15) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,counties varchar2(90) -- 
    ,street varchar2(90) -- 
    ,roomno varchar2(90) -- 
    ,buildingno varchar2(90) -- 
    ,address varchar2(300) -- 
    ,buildingname varchar2(150) -- 
    ,buildrightinfo varchar2(150) -- 
    ,isotherright varchar2(3) -- 
    ,remark varchar2(4000) -- 
    ,istwotogether varchar2(3) -- 
    ,landno varchar2(1350) -- 
    ,landusenature varchar2(3) -- 
    ,landusearea number(20,2) -- 
    ,landgainway varchar2(3) -- 
    ,landstartdate varchar2(15) -- 
    ,landenddate varchar2(15) -- 
    ,landuseryear number(3,1) -- 
    ,landusering varchar2(3) -- 
    ,isrents varchar2(2) -- 
    ,hpaddr varchar2(150) -- 
    ,hiresdate varchar2(15) -- 
    ,hireedate varchar2(15) -- 
    ,hireremark varchar2(300) -- 
    ,tdcurrency varchar2(5) -- 
    ,landnumber varchar2(90) -- 
    ,yearlyrental number(20,2) -- 租赁年收入（元）
    ,iscompleted varchar2(3) -- 房屋是否已竣工
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
grant select on ${iol_schema}.mims_si_parking to ${iml_schema};
grant select on ${iol_schema}.mims_si_parking to ${icl_schema};
grant select on ${iol_schema}.mims_si_parking to ${idl_schema};
grant select on ${iol_schema}.mims_si_parking to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_parking is '车库';
comment on column ${iol_schema}.mims_si_parking.sccode is '';
comment on column ${iol_schema}.mims_si_parking.isindepcard is '';
comment on column ${iol_schema}.mims_si_parking.parktype is '';
comment on column ${iol_schema}.mims_si_parking.contno is '';
comment on column ${iol_schema}.mims_si_parking.tradedate is '';
comment on column ${iol_schema}.mims_si_parking.tradeprice is '';
comment on column ${iol_schema}.mims_si_parking.buildingarea is '';
comment on column ${iol_schema}.mims_si_parking.usearea is '';
comment on column ${iol_schema}.mims_si_parking.createyear is '';
comment on column ${iol_schema}.mims_si_parking.province is '';
comment on column ${iol_schema}.mims_si_parking.city is '';
comment on column ${iol_schema}.mims_si_parking.counties is '';
comment on column ${iol_schema}.mims_si_parking.street is '';
comment on column ${iol_schema}.mims_si_parking.roomno is '';
comment on column ${iol_schema}.mims_si_parking.buildingno is '';
comment on column ${iol_schema}.mims_si_parking.address is '';
comment on column ${iol_schema}.mims_si_parking.buildingname is '';
comment on column ${iol_schema}.mims_si_parking.buildrightinfo is '';
comment on column ${iol_schema}.mims_si_parking.isotherright is '';
comment on column ${iol_schema}.mims_si_parking.remark is '';
comment on column ${iol_schema}.mims_si_parking.istwotogether is '';
comment on column ${iol_schema}.mims_si_parking.landno is '';
comment on column ${iol_schema}.mims_si_parking.landusenature is '';
comment on column ${iol_schema}.mims_si_parking.landusearea is '';
comment on column ${iol_schema}.mims_si_parking.landgainway is '';
comment on column ${iol_schema}.mims_si_parking.landstartdate is '';
comment on column ${iol_schema}.mims_si_parking.landenddate is '';
comment on column ${iol_schema}.mims_si_parking.landuseryear is '';
comment on column ${iol_schema}.mims_si_parking.landusering is '';
comment on column ${iol_schema}.mims_si_parking.isrents is '';
comment on column ${iol_schema}.mims_si_parking.hpaddr is '';
comment on column ${iol_schema}.mims_si_parking.hiresdate is '';
comment on column ${iol_schema}.mims_si_parking.hireedate is '';
comment on column ${iol_schema}.mims_si_parking.hireremark is '';
comment on column ${iol_schema}.mims_si_parking.tdcurrency is '';
comment on column ${iol_schema}.mims_si_parking.landnumber is '';
comment on column ${iol_schema}.mims_si_parking.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.mims_si_parking.iscompleted is '房屋是否已竣工';
comment on column ${iol_schema}.mims_si_parking.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_parking.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_parking.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_parking.etl_timestamp is 'ETL处理时间戳';
