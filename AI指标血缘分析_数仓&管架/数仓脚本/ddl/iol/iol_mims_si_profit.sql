/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_profit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_profit
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_profit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_profit(
    sccode varchar2(48) -- 
    ,inappdocno varchar2(90) -- 
    ,inappdocnum varchar2(150) -- 
    ,ownerno varchar2(90) -- 
    ,ownername varchar2(150) -- 
    ,startdate varchar2(15) -- 
    ,duedate varchar2(15) -- 
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
grant select on ${iol_schema}.mims_si_profit to ${iml_schema};
grant select on ${iol_schema}.mims_si_profit to ${icl_schema};
grant select on ${iol_schema}.mims_si_profit to ${idl_schema};
grant select on ${iol_schema}.mims_si_profit to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_profit is '收益权';
comment on column ${iol_schema}.mims_si_profit.sccode is '';
comment on column ${iol_schema}.mims_si_profit.inappdocno is '';
comment on column ${iol_schema}.mims_si_profit.inappdocnum is '';
comment on column ${iol_schema}.mims_si_profit.ownerno is '';
comment on column ${iol_schema}.mims_si_profit.ownername is '';
comment on column ${iol_schema}.mims_si_profit.startdate is '';
comment on column ${iol_schema}.mims_si_profit.duedate is '';
comment on column ${iol_schema}.mims_si_profit.remark is '';
comment on column ${iol_schema}.mims_si_profit.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_profit.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_profit.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_profit.etl_timestamp is 'ETL处理时间戳';
