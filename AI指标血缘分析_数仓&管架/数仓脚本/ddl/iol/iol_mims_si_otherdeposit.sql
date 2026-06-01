/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_otherdeposit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_otherdeposit
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_otherdeposit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_otherdeposit(
    sccode varchar2(48) -- 
    ,certificatecode varchar2(150) -- 
    ,stoppaymentmoney number(20,2) -- 
    ,accountname varchar2(150) -- 
    ,registcountry varchar2(45) -- 
    ,outratingdate varchar2(15) -- 
    ,outratingresult varchar2(15) -- 
    ,inratingdate varchar2(15) -- 
    ,inratingresult varchar2(3) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,duedate number(22) -- 
    ,yearrate number(5,2) -- 
    ,money number(20,2) -- 
    ,remark varchar2(4000) -- 
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
grant select on ${iol_schema}.mims_si_otherdeposit to ${iml_schema};
grant select on ${iol_schema}.mims_si_otherdeposit to ${icl_schema};
grant select on ${iol_schema}.mims_si_otherdeposit to ${idl_schema};
grant select on ${iol_schema}.mims_si_otherdeposit to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_otherdeposit is '他行存单';
comment on column ${iol_schema}.mims_si_otherdeposit.sccode is '';
comment on column ${iol_schema}.mims_si_otherdeposit.certificatecode is '';
comment on column ${iol_schema}.mims_si_otherdeposit.stoppaymentmoney is '';
comment on column ${iol_schema}.mims_si_otherdeposit.accountname is '';
comment on column ${iol_schema}.mims_si_otherdeposit.registcountry is '';
comment on column ${iol_schema}.mims_si_otherdeposit.outratingdate is '';
comment on column ${iol_schema}.mims_si_otherdeposit.outratingresult is '';
comment on column ${iol_schema}.mims_si_otherdeposit.inratingdate is '';
comment on column ${iol_schema}.mims_si_otherdeposit.inratingresult is '';
comment on column ${iol_schema}.mims_si_otherdeposit.startdate is '';
comment on column ${iol_schema}.mims_si_otherdeposit.enddate is '';
comment on column ${iol_schema}.mims_si_otherdeposit.duedate is '';
comment on column ${iol_schema}.mims_si_otherdeposit.yearrate is '';
comment on column ${iol_schema}.mims_si_otherdeposit.money is '';
comment on column ${iol_schema}.mims_si_otherdeposit.remark is '';
comment on column ${iol_schema}.mims_si_otherdeposit.tdcurrency is '';
comment on column ${iol_schema}.mims_si_otherdeposit.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_otherdeposit.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_otherdeposit.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_otherdeposit.etl_timestamp is 'ETL处理时间戳';
