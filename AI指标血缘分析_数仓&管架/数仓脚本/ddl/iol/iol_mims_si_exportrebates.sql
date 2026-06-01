/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_exportrebates
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_exportrebates
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_exportrebates purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_exportrebates(
    sccode varchar2(48) -- 
    ,exportmoney number(20,2) -- 
    ,startdate varchar2(15) -- 
    ,duedate varchar2(15) -- 
    ,account varchar2(90) -- 
    ,accountname varchar2(150) -- 
    ,accountowner varchar2(45) -- 
    ,customno varchar2(90) -- 
    ,usedtime number(22) -- 
    ,isproduce varchar2(3) -- 
    ,remark varchar2(4000) -- 
    ,isrelation2 varchar2(3) -- 
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
grant select on ${iol_schema}.mims_si_exportrebates to ${iml_schema};
grant select on ${iol_schema}.mims_si_exportrebates to ${icl_schema};
grant select on ${iol_schema}.mims_si_exportrebates to ${idl_schema};
grant select on ${iol_schema}.mims_si_exportrebates to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_exportrebates is '出口退税';
comment on column ${iol_schema}.mims_si_exportrebates.sccode is '';
comment on column ${iol_schema}.mims_si_exportrebates.exportmoney is '';
comment on column ${iol_schema}.mims_si_exportrebates.startdate is '';
comment on column ${iol_schema}.mims_si_exportrebates.duedate is '';
comment on column ${iol_schema}.mims_si_exportrebates.account is '';
comment on column ${iol_schema}.mims_si_exportrebates.accountname is '';
comment on column ${iol_schema}.mims_si_exportrebates.accountowner is '';
comment on column ${iol_schema}.mims_si_exportrebates.customno is '';
comment on column ${iol_schema}.mims_si_exportrebates.usedtime is '';
comment on column ${iol_schema}.mims_si_exportrebates.isproduce is '';
comment on column ${iol_schema}.mims_si_exportrebates.remark is '';
comment on column ${iol_schema}.mims_si_exportrebates.isrelation2 is '';
comment on column ${iol_schema}.mims_si_exportrebates.tdcurrency is '';
comment on column ${iol_schema}.mims_si_exportrebates.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_exportrebates.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_exportrebates.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_exportrebates.etl_timestamp is 'ETL处理时间戳';
