/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_construction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_construction
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_construction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_construction(
    sccode varchar2(48) -- 
    ,landuseno varchar2(300) -- 
    ,landusenature varchar2(3) -- 
    ,landgainway varchar2(3) -- 
    ,landstartdate varchar2(15) -- 
    ,landenddate varchar2(15) -- 
    ,landuseyear number(22) -- 
    ,landarea number(20,2) -- 
    ,landleasprice number(20,2) -- 
    ,landdelivery varchar2(3) -- 
    ,transfermoney number(20,2) -- 
    ,landusering varchar2(3) -- 
    ,projectname varchar2(150) -- 
    ,landlicenceno varchar2(90) -- 
    ,projectlicenceno varchar2(90) -- 
    ,licenceno varchar2(90) -- 
    ,startworkdate varchar2(15) -- 
    ,prestartdate varchar2(15) -- 
    ,pretotalprice number(20,2) -- 
    ,buildarea number(20,2) -- 
    ,buildnumber number(22) -- 
    ,isrent varchar2(3) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,counties varchar2(90) -- 
    ,street varchar2(90) -- 
    ,roomno varchar2(90) -- 
    ,address varchar2(300) -- 
    ,remark varchar2(4000) -- 
    ,tdcurrency varchar2(5) -- 
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
grant select on ${iol_schema}.mims_si_construction to ${iml_schema};
grant select on ${iol_schema}.mims_si_construction to ${icl_schema};
grant select on ${iol_schema}.mims_si_construction to ${idl_schema};
grant select on ${iol_schema}.mims_si_construction to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_construction is '在建工程';
comment on column ${iol_schema}.mims_si_construction.sccode is '';
comment on column ${iol_schema}.mims_si_construction.landuseno is '';
comment on column ${iol_schema}.mims_si_construction.landusenature is '';
comment on column ${iol_schema}.mims_si_construction.landgainway is '';
comment on column ${iol_schema}.mims_si_construction.landstartdate is '';
comment on column ${iol_schema}.mims_si_construction.landenddate is '';
comment on column ${iol_schema}.mims_si_construction.landuseyear is '';
comment on column ${iol_schema}.mims_si_construction.landarea is '';
comment on column ${iol_schema}.mims_si_construction.landleasprice is '';
comment on column ${iol_schema}.mims_si_construction.landdelivery is '';
comment on column ${iol_schema}.mims_si_construction.transfermoney is '';
comment on column ${iol_schema}.mims_si_construction.landusering is '';
comment on column ${iol_schema}.mims_si_construction.projectname is '';
comment on column ${iol_schema}.mims_si_construction.landlicenceno is '';
comment on column ${iol_schema}.mims_si_construction.projectlicenceno is '';
comment on column ${iol_schema}.mims_si_construction.licenceno is '';
comment on column ${iol_schema}.mims_si_construction.startworkdate is '';
comment on column ${iol_schema}.mims_si_construction.prestartdate is '';
comment on column ${iol_schema}.mims_si_construction.pretotalprice is '';
comment on column ${iol_schema}.mims_si_construction.buildarea is '';
comment on column ${iol_schema}.mims_si_construction.buildnumber is '';
comment on column ${iol_schema}.mims_si_construction.isrent is '';
comment on column ${iol_schema}.mims_si_construction.province is '';
comment on column ${iol_schema}.mims_si_construction.city is '';
comment on column ${iol_schema}.mims_si_construction.counties is '';
comment on column ${iol_schema}.mims_si_construction.street is '';
comment on column ${iol_schema}.mims_si_construction.roomno is '';
comment on column ${iol_schema}.mims_si_construction.address is '';
comment on column ${iol_schema}.mims_si_construction.remark is '';
comment on column ${iol_schema}.mims_si_construction.tdcurrency is '';
comment on column ${iol_schema}.mims_si_construction.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.mims_si_construction.iscompleted is '房屋是否已竣工';
comment on column ${iol_schema}.mims_si_construction.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_construction.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_construction.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_construction.etl_timestamp is 'ETL处理时间戳';
