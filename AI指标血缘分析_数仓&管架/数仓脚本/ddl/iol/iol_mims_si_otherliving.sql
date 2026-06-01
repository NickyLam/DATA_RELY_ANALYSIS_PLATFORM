/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_otherliving
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_otherliving
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_otherliving purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_otherliving(
    sccode varchar2(48) -- 
    ,houseflag varchar2(3) -- 
    ,preregistnos varchar2(90) -- 
    ,preroyno varchar2(90) -- 
    ,prevalidity varchar2(15) -- 
    ,predeliver varchar2(15) -- 
    ,isnewhouse varchar2(3) -- 
    ,istwotogether varchar2(3) -- 
    ,warrantsno varchar2(1350) -- 
    ,licenceno varchar2(90) -- 
    ,istotal varchar2(3) -- 
    ,otherremark varchar2(1500) -- 
    ,contno varchar2(90) -- 
    ,tradedate varchar2(15) -- 
    ,tradeprice number(20,2) -- 
    ,isapply varchar2(3) -- 
    ,isonlyhouse varchar2(3) -- 
    ,buildingarea number(20,2) -- 
    ,usearea number(20,2) -- 
    ,createyear varchar2(15) -- 
    ,limitinfo number(2,0) -- 
    ,buildage number(5,2) -- 
    ,orientations varchar2(3) -- 
    ,roomstructe varchar2(3) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,counties varchar2(90) -- 
    ,street varchar2(90) -- 
    ,roomno varchar2(90) -- 
    ,buildingno varchar2(90) -- 
    ,address varchar2(300) -- 
    ,buildingname varchar2(150) -- 
    ,storeyno varchar2(15) -- 
    ,totalstoreyno number(22) -- 
    ,landno varchar2(150) -- 
    ,landusenature varchar2(3) -- 
    ,landgainway varchar2(3) -- 
    ,landstartdate varchar2(15) -- 
    ,landenddate varchar2(15) -- 
    ,landuseryear number(3,1) -- 
    ,landusering varchar2(3) -- 
    ,isotherright varchar2(3) -- 
    ,remark varchar2(4000) -- 
    ,isrents varchar2(2) -- 
    ,hpaddr varchar2(150) -- 
    ,hiresdate varchar2(15) -- 
    ,hireedate varchar2(15) -- 
    ,hireremark varchar2(300) -- 
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
grant select on ${iol_schema}.mims_si_otherliving to ${iml_schema};
grant select on ${iol_schema}.mims_si_otherliving to ${icl_schema};
grant select on ${iol_schema}.mims_si_otherliving to ${idl_schema};
grant select on ${iol_schema}.mims_si_otherliving to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_otherliving is '其他房地产';
comment on column ${iol_schema}.mims_si_otherliving.sccode is '';
comment on column ${iol_schema}.mims_si_otherliving.houseflag is '';
comment on column ${iol_schema}.mims_si_otherliving.preregistnos is '';
comment on column ${iol_schema}.mims_si_otherliving.preroyno is '';
comment on column ${iol_schema}.mims_si_otherliving.prevalidity is '';
comment on column ${iol_schema}.mims_si_otherliving.predeliver is '';
comment on column ${iol_schema}.mims_si_otherliving.isnewhouse is '';
comment on column ${iol_schema}.mims_si_otherliving.istwotogether is '';
comment on column ${iol_schema}.mims_si_otherliving.warrantsno is '';
comment on column ${iol_schema}.mims_si_otherliving.licenceno is '';
comment on column ${iol_schema}.mims_si_otherliving.istotal is '';
comment on column ${iol_schema}.mims_si_otherliving.otherremark is '';
comment on column ${iol_schema}.mims_si_otherliving.contno is '';
comment on column ${iol_schema}.mims_si_otherliving.tradedate is '';
comment on column ${iol_schema}.mims_si_otherliving.tradeprice is '';
comment on column ${iol_schema}.mims_si_otherliving.isapply is '';
comment on column ${iol_schema}.mims_si_otherliving.isonlyhouse is '';
comment on column ${iol_schema}.mims_si_otherliving.buildingarea is '';
comment on column ${iol_schema}.mims_si_otherliving.usearea is '';
comment on column ${iol_schema}.mims_si_otherliving.createyear is '';
comment on column ${iol_schema}.mims_si_otherliving.limitinfo is '';
comment on column ${iol_schema}.mims_si_otherliving.buildage is '';
comment on column ${iol_schema}.mims_si_otherliving.orientations is '';
comment on column ${iol_schema}.mims_si_otherliving.roomstructe is '';
comment on column ${iol_schema}.mims_si_otherliving.province is '';
comment on column ${iol_schema}.mims_si_otherliving.city is '';
comment on column ${iol_schema}.mims_si_otherliving.counties is '';
comment on column ${iol_schema}.mims_si_otherliving.street is '';
comment on column ${iol_schema}.mims_si_otherliving.roomno is '';
comment on column ${iol_schema}.mims_si_otherliving.buildingno is '';
comment on column ${iol_schema}.mims_si_otherliving.address is '';
comment on column ${iol_schema}.mims_si_otherliving.buildingname is '';
comment on column ${iol_schema}.mims_si_otherliving.storeyno is '';
comment on column ${iol_schema}.mims_si_otherliving.totalstoreyno is '';
comment on column ${iol_schema}.mims_si_otherliving.landno is '';
comment on column ${iol_schema}.mims_si_otherliving.landusenature is '';
comment on column ${iol_schema}.mims_si_otherliving.landgainway is '';
comment on column ${iol_schema}.mims_si_otherliving.landstartdate is '';
comment on column ${iol_schema}.mims_si_otherliving.landenddate is '';
comment on column ${iol_schema}.mims_si_otherliving.landuseryear is '';
comment on column ${iol_schema}.mims_si_otherliving.landusering is '';
comment on column ${iol_schema}.mims_si_otherliving.isotherright is '';
comment on column ${iol_schema}.mims_si_otherliving.remark is '';
comment on column ${iol_schema}.mims_si_otherliving.isrents is '';
comment on column ${iol_schema}.mims_si_otherliving.hpaddr is '';
comment on column ${iol_schema}.mims_si_otherliving.hiresdate is '';
comment on column ${iol_schema}.mims_si_otherliving.hireedate is '';
comment on column ${iol_schema}.mims_si_otherliving.hireremark is '';
comment on column ${iol_schema}.mims_si_otherliving.tdcurrency is '';
comment on column ${iol_schema}.mims_si_otherliving.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.mims_si_otherliving.iscompleted is '房屋是否已竣工';
comment on column ${iol_schema}.mims_si_otherliving.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_otherliving.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_otherliving.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_otherliving.etl_timestamp is 'ETL处理时间戳';
