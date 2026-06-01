/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hr_trnstype
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hr_trnstype
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hr_trnstype purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hr_trnstype(
    creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,ishrss varchar2(2) -- 
    ,memo varchar2(450) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_trnstype varchar2(30) -- 
    ,systypeflag varchar2(2) -- 
    ,trnsevent number(38,0) -- 
    ,trnstypecode varchar2(75) -- 
    ,trnstypename varchar2(450) -- 
    ,trnstypename2 varchar2(450) -- 
    ,trnstypename3 varchar2(450) -- 
    ,trnstypename4 varchar2(450) -- 
    ,trnstypename5 varchar2(450) -- 
    ,trnstypename6 varchar2(450) -- 
    ,ts varchar2(29) -- 
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
grant select on ${iol_schema}.nhrs_hr_trnstype to ${iml_schema};
grant select on ${iol_schema}.nhrs_hr_trnstype to ${icl_schema};
grant select on ${iol_schema}.nhrs_hr_trnstype to ${idl_schema};
grant select on ${iol_schema}.nhrs_hr_trnstype to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hr_trnstype is '异动类型表';
comment on column ${iol_schema}.nhrs_hr_trnstype.creationtime is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.creator is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.dr is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.enablestate is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.ishrss is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.memo is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.modifiedtime is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.modifier is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.pk_group is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.pk_org is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.pk_trnstype is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.systypeflag is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.trnsevent is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.trnstypecode is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.trnstypename is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.trnstypename2 is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.trnstypename3 is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.trnstypename4 is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.trnstypename5 is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.trnstypename6 is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.ts is '';
comment on column ${iol_schema}.nhrs_hr_trnstype.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hr_trnstype.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hr_trnstype.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hr_trnstype.etl_timestamp is 'ETL处理时间戳';
