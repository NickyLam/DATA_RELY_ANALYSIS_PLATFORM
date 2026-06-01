/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_fwarereceipt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_fwarereceipt
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_fwarereceipt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_fwarereceipt(
    sccode varchar2(48) -- 
    ,billno varchar2(90) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,tradename varchar2(150) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,unit varchar2(3) -- 
    ,amount number(22) -- 
    ,perprice number(20,2) -- 
    ,totalprice number(20,2) -- 
    ,remark varchar2(4000) -- 
    ,otherremark varchar2(45) -- 
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
grant select on ${iol_schema}.mims_si_fwarereceipt to ${iml_schema};
grant select on ${iol_schema}.mims_si_fwarereceipt to ${icl_schema};
grant select on ${iol_schema}.mims_si_fwarereceipt to ${idl_schema};
grant select on ${iol_schema}.mims_si_fwarereceipt to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_fwarereceipt is '非标仓单';
comment on column ${iol_schema}.mims_si_fwarereceipt.sccode is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.billno is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.startdate is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.enddate is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.tradename is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.province is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.city is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.unit is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.amount is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.perprice is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.totalprice is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.remark is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.otherremark is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.tdcurrency is '';
comment on column ${iol_schema}.mims_si_fwarereceipt.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_fwarereceipt.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_fwarereceipt.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_fwarereceipt.etl_timestamp is 'ETL处理时间戳';
