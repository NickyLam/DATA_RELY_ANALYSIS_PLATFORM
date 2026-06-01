/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_industryroom
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_industryroom
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_industryroom purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_industryroom(
    sccode varchar2(48) -- 
    ,isnewhouse varchar2(3) -- 
    ,istwotogether varchar2(3) -- 
    ,warrantsno varchar2(1350) -- 
    ,developmode varchar2(3) -- 
    ,istotal varchar2(3) -- 
    ,otherremark varchar2(1500) -- 
    ,contno varchar2(90) -- 
    ,tradedate varchar2(15) -- 
    ,tradeprice number(20,2) -- 
    ,buildingarea number(20,2) -- 
    ,usearea number(20,2) -- 
    ,createyear varchar2(15) -- 
    ,buildage number(5,2) -- 
    ,roomstructe varchar2(3) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,counties varchar2(90) -- 
    ,street varchar2(90) -- 
    ,roomno varchar2(90) -- 
    ,address varchar2(300) -- 
    ,storeyno varchar2(15) -- 
    ,totalstoreyno number(22) -- 
    ,presentstatus varchar2(3) -- 
    ,buildrightinfo varchar2(150) -- 
    ,landno varchar2(300) -- 
    ,landusenature varchar2(3) -- 
    ,landgainway varchar2(3) -- 
    ,landstartdate varchar2(15) -- 
    ,landenddate varchar2(15) -- 
    ,landuseryear number(22) -- 
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
grant select on ${iol_schema}.mims_si_industryroom to ${iml_schema};
grant select on ${iol_schema}.mims_si_industryroom to ${icl_schema};
grant select on ${iol_schema}.mims_si_industryroom to ${idl_schema};
grant select on ${iol_schema}.mims_si_industryroom to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_industryroom is '工业用房';
comment on column ${iol_schema}.mims_si_industryroom.sccode is '';
comment on column ${iol_schema}.mims_si_industryroom.isnewhouse is '';
comment on column ${iol_schema}.mims_si_industryroom.istwotogether is '';
comment on column ${iol_schema}.mims_si_industryroom.warrantsno is '';
comment on column ${iol_schema}.mims_si_industryroom.developmode is '';
comment on column ${iol_schema}.mims_si_industryroom.istotal is '';
comment on column ${iol_schema}.mims_si_industryroom.otherremark is '';
comment on column ${iol_schema}.mims_si_industryroom.contno is '';
comment on column ${iol_schema}.mims_si_industryroom.tradedate is '';
comment on column ${iol_schema}.mims_si_industryroom.tradeprice is '';
comment on column ${iol_schema}.mims_si_industryroom.buildingarea is '';
comment on column ${iol_schema}.mims_si_industryroom.usearea is '';
comment on column ${iol_schema}.mims_si_industryroom.createyear is '';
comment on column ${iol_schema}.mims_si_industryroom.buildage is '';
comment on column ${iol_schema}.mims_si_industryroom.roomstructe is '';
comment on column ${iol_schema}.mims_si_industryroom.province is '';
comment on column ${iol_schema}.mims_si_industryroom.city is '';
comment on column ${iol_schema}.mims_si_industryroom.counties is '';
comment on column ${iol_schema}.mims_si_industryroom.street is '';
comment on column ${iol_schema}.mims_si_industryroom.roomno is '';
comment on column ${iol_schema}.mims_si_industryroom.address is '';
comment on column ${iol_schema}.mims_si_industryroom.storeyno is '';
comment on column ${iol_schema}.mims_si_industryroom.totalstoreyno is '';
comment on column ${iol_schema}.mims_si_industryroom.presentstatus is '';
comment on column ${iol_schema}.mims_si_industryroom.buildrightinfo is '';
comment on column ${iol_schema}.mims_si_industryroom.landno is '';
comment on column ${iol_schema}.mims_si_industryroom.landusenature is '';
comment on column ${iol_schema}.mims_si_industryroom.landgainway is '';
comment on column ${iol_schema}.mims_si_industryroom.landstartdate is '';
comment on column ${iol_schema}.mims_si_industryroom.landenddate is '';
comment on column ${iol_schema}.mims_si_industryroom.landuseryear is '';
comment on column ${iol_schema}.mims_si_industryroom.landusering is '';
comment on column ${iol_schema}.mims_si_industryroom.isotherright is '';
comment on column ${iol_schema}.mims_si_industryroom.remark is '';
comment on column ${iol_schema}.mims_si_industryroom.isrents is '';
comment on column ${iol_schema}.mims_si_industryroom.hpaddr is '';
comment on column ${iol_schema}.mims_si_industryroom.hiresdate is '';
comment on column ${iol_schema}.mims_si_industryroom.hireedate is '';
comment on column ${iol_schema}.mims_si_industryroom.hireremark is '';
comment on column ${iol_schema}.mims_si_industryroom.tdcurrency is '';
comment on column ${iol_schema}.mims_si_industryroom.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.mims_si_industryroom.iscompleted is '房屋是否已竣工';
comment on column ${iol_schema}.mims_si_industryroom.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_industryroom.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_industryroom.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_industryroom.etl_timestamp is 'ETL处理时间戳';
