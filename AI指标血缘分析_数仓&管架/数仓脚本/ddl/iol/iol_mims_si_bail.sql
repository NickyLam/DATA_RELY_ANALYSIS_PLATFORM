/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_bail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_bail
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_bail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_bail(
    sccode varchar2(48) -- 
    ,account varchar2(90) -- 
    ,startdate varchar2(15) -- 
    ,duedate varchar2(15) -- 
    ,balance number(20,2) -- 
    ,bailseqno varchar2(45) -- 
    ,isfreeze varchar2(3) -- 
    ,freezemoney number(20,2) -- 
    ,remark varchar2(4000) -- 
    ,childaccount varchar2(90) -- 
    ,opendept varchar2(90) -- 
    ,usebalance number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_bail to ${iml_schema};
grant select on ${iol_schema}.mims_si_bail to ${icl_schema};
grant select on ${iol_schema}.mims_si_bail to ${idl_schema};
grant select on ${iol_schema}.mims_si_bail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_bail is '保证金';
comment on column ${iol_schema}.mims_si_bail.sccode is '';
comment on column ${iol_schema}.mims_si_bail.account is '';
comment on column ${iol_schema}.mims_si_bail.startdate is '';
comment on column ${iol_schema}.mims_si_bail.duedate is '';
comment on column ${iol_schema}.mims_si_bail.balance is '';
comment on column ${iol_schema}.mims_si_bail.bailseqno is '';
comment on column ${iol_schema}.mims_si_bail.isfreeze is '';
comment on column ${iol_schema}.mims_si_bail.freezemoney is '';
comment on column ${iol_schema}.mims_si_bail.remark is '';
comment on column ${iol_schema}.mims_si_bail.childaccount is '';
comment on column ${iol_schema}.mims_si_bail.opendept is '';
comment on column ${iol_schema}.mims_si_bail.usebalance is '';
comment on column ${iol_schema}.mims_si_bail.tdcurrency is '';
comment on column ${iol_schema}.mims_si_bail.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_bail.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_bail.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_bail.etl_timestamp is 'ETL处理时间戳';
