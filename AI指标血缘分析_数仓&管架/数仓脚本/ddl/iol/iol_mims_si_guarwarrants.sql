/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_guarwarrants
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_guarwarrants
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_guarwarrants purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarwarrants(
    seqno varchar2(30) -- 
    ,sccode varchar2(48) -- 
    ,warrantsno varchar2(300) -- 
    ,warrantname varchar2(300) -- 
    ,warrantstype varchar2(3) -- 
    ,dptcode varchar2(300) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,recorddate varchar2(15) -- 
    ,reguser varchar2(45) -- 
    ,remark varchar2(4000) -- 
    ,inbusinessinsid varchar2(45) -- 
    ,acontno varchar2(75) -- 
    ,contractno varchar2(75) -- 
    ,inno varchar2(75) -- 
    ,indate varchar2(15) -- 
    ,outbusinessinsid varchar2(45) -- 
    ,outdate varchar2(15) -- 
    ,bowbusinessinsid varchar2(45) -- 
    ,bowtdate varchar2(15) -- 
    ,defbusinessinsid varchar2(45) -- 
    ,defdate varchar2(15) -- 
    ,degree number(22) -- 
    ,backdate varchar2(15) -- 
    ,state varchar2(3) -- 
    ,bursary varchar2(30) -- 
    ,location varchar2(75) -- 
    ,netamount number(20,4) -- 
    ,isunique varchar2(15) -- 
    ,updates varchar2(15) -- 
    ,flowflag varchar2(2) -- 
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
grant select on ${iol_schema}.mims_si_guarwarrants to ${iml_schema};
grant select on ${iol_schema}.mims_si_guarwarrants to ${icl_schema};
grant select on ${iol_schema}.mims_si_guarwarrants to ${idl_schema};
grant select on ${iol_schema}.mims_si_guarwarrants to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_guarwarrants is '押品权证信息';
comment on column ${iol_schema}.mims_si_guarwarrants.seqno is '';
comment on column ${iol_schema}.mims_si_guarwarrants.sccode is '';
comment on column ${iol_schema}.mims_si_guarwarrants.warrantsno is '';
comment on column ${iol_schema}.mims_si_guarwarrants.warrantname is '';
comment on column ${iol_schema}.mims_si_guarwarrants.warrantstype is '';
comment on column ${iol_schema}.mims_si_guarwarrants.dptcode is '';
comment on column ${iol_schema}.mims_si_guarwarrants.startdate is '';
comment on column ${iol_schema}.mims_si_guarwarrants.enddate is '';
comment on column ${iol_schema}.mims_si_guarwarrants.recorddate is '';
comment on column ${iol_schema}.mims_si_guarwarrants.reguser is '';
comment on column ${iol_schema}.mims_si_guarwarrants.remark is '';
comment on column ${iol_schema}.mims_si_guarwarrants.inbusinessinsid is '';
comment on column ${iol_schema}.mims_si_guarwarrants.acontno is '';
comment on column ${iol_schema}.mims_si_guarwarrants.contractno is '';
comment on column ${iol_schema}.mims_si_guarwarrants.inno is '';
comment on column ${iol_schema}.mims_si_guarwarrants.indate is '';
comment on column ${iol_schema}.mims_si_guarwarrants.outbusinessinsid is '';
comment on column ${iol_schema}.mims_si_guarwarrants.outdate is '';
comment on column ${iol_schema}.mims_si_guarwarrants.bowbusinessinsid is '';
comment on column ${iol_schema}.mims_si_guarwarrants.bowtdate is '';
comment on column ${iol_schema}.mims_si_guarwarrants.defbusinessinsid is '';
comment on column ${iol_schema}.mims_si_guarwarrants.defdate is '';
comment on column ${iol_schema}.mims_si_guarwarrants.degree is '';
comment on column ${iol_schema}.mims_si_guarwarrants.backdate is '';
comment on column ${iol_schema}.mims_si_guarwarrants.state is '';
comment on column ${iol_schema}.mims_si_guarwarrants.bursary is '';
comment on column ${iol_schema}.mims_si_guarwarrants.location is '';
comment on column ${iol_schema}.mims_si_guarwarrants.netamount is '';
comment on column ${iol_schema}.mims_si_guarwarrants.isunique is '';
comment on column ${iol_schema}.mims_si_guarwarrants.updates is '';
comment on column ${iol_schema}.mims_si_guarwarrants.flowflag is '';
comment on column ${iol_schema}.mims_si_guarwarrants.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_guarwarrants.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_guarwarrants.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_guarwarrants.etl_timestamp is 'ETL处理时间戳';
