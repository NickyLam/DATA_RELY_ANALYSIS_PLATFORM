/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_receivables
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_receivables
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_receivables purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_receivables(
    sccode varchar2(48) -- 
    ,creditno varchar2(45) -- 
    ,faceamount number(20,2) -- 
    ,billno varchar2(90) -- 
    ,startdate varchar2(15) -- 
    ,duedate varchar2(15) -- 
    ,usedtime number(22) -- 
    ,payor varchar2(150) -- 
    ,ishandle varchar2(3) -- 
    ,payoraccount varchar2(90) -- 
    ,isnotice varchar2(3) -- 
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
grant select on ${iol_schema}.mims_si_receivables to ${iml_schema};
grant select on ${iol_schema}.mims_si_receivables to ${icl_schema};
grant select on ${iol_schema}.mims_si_receivables to ${idl_schema};
grant select on ${iol_schema}.mims_si_receivables to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_receivables is '交易类应收账款';
comment on column ${iol_schema}.mims_si_receivables.sccode is '';
comment on column ${iol_schema}.mims_si_receivables.creditno is '';
comment on column ${iol_schema}.mims_si_receivables.faceamount is '';
comment on column ${iol_schema}.mims_si_receivables.billno is '';
comment on column ${iol_schema}.mims_si_receivables.startdate is '';
comment on column ${iol_schema}.mims_si_receivables.duedate is '';
comment on column ${iol_schema}.mims_si_receivables.usedtime is '';
comment on column ${iol_schema}.mims_si_receivables.payor is '';
comment on column ${iol_schema}.mims_si_receivables.ishandle is '';
comment on column ${iol_schema}.mims_si_receivables.payoraccount is '';
comment on column ${iol_schema}.mims_si_receivables.isnotice is '';
comment on column ${iol_schema}.mims_si_receivables.isproduce is '';
comment on column ${iol_schema}.mims_si_receivables.remark is '';
comment on column ${iol_schema}.mims_si_receivables.isrelation2 is '';
comment on column ${iol_schema}.mims_si_receivables.tdcurrency is '';
comment on column ${iol_schema}.mims_si_receivables.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_receivables.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_receivables.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_receivables.etl_timestamp is 'ETL处理时间戳';
