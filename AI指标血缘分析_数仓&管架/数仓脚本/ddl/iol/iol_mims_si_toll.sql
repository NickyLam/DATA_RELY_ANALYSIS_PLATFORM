/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_toll
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_toll
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_toll purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_toll(
    sccode varchar2(48) -- 
    ,inappdocno varchar2(90) -- 
    ,inappdocnum varchar2(150) -- 
    ,certificatecode varchar2(90) -- 
    ,startdate varchar2(15) -- 
    ,duedate varchar2(15) -- 
    ,yearlimit number(22) -- 
    ,province varchar2(45) -- 
    ,city varchar2(45) -- 
    ,address varchar2(300) -- 
    ,openbankname varchar2(150) -- 
    ,accountno varchar2(90) -- 
    ,accountname varchar2(150) -- 
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
grant select on ${iol_schema}.mims_si_toll to ${iml_schema};
grant select on ${iol_schema}.mims_si_toll to ${icl_schema};
grant select on ${iol_schema}.mims_si_toll to ${idl_schema};
grant select on ${iol_schema}.mims_si_toll to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_toll is '收费权';
comment on column ${iol_schema}.mims_si_toll.sccode is '';
comment on column ${iol_schema}.mims_si_toll.inappdocno is '';
comment on column ${iol_schema}.mims_si_toll.inappdocnum is '';
comment on column ${iol_schema}.mims_si_toll.certificatecode is '';
comment on column ${iol_schema}.mims_si_toll.startdate is '';
comment on column ${iol_schema}.mims_si_toll.duedate is '';
comment on column ${iol_schema}.mims_si_toll.yearlimit is '';
comment on column ${iol_schema}.mims_si_toll.province is '';
comment on column ${iol_schema}.mims_si_toll.city is '';
comment on column ${iol_schema}.mims_si_toll.address is '';
comment on column ${iol_schema}.mims_si_toll.openbankname is '';
comment on column ${iol_schema}.mims_si_toll.accountno is '';
comment on column ${iol_schema}.mims_si_toll.accountname is '';
comment on column ${iol_schema}.mims_si_toll.remark is '';
comment on column ${iol_schema}.mims_si_toll.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_toll.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_toll.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_toll.etl_timestamp is 'ETL处理时间戳';
