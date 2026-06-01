/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fea
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fea
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fea purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fea(
    currency_code varchar2(5) -- 
    ,ver varchar2(6) -- 
    ,actiondesc varchar2(195) -- 
    ,en_code varchar2(27) -- 
    ,business_date date -- 
    ,accountno varchar2(96) -- 
    ,limit_type varchar2(3) -- 
    ,account_cata varchar2(3) -- 
    ,actiontype varchar2(2) -- 
    ,file_number varchar2(42) -- 
    ,amtype varchar2(3) -- 
    ,account_limit number(22,3) -- 
    ,business_date2 date -- 
    ,fea_type varchar2(12) -- 
    ,remark varchar2(390) -- 
    ,account_type varchar2(6) -- 
    ,branch_code varchar2(18) -- 
    ,en_name varchar2(195) -- 
    ,inr varchar2(12) -- 
    ,accountstat varchar2(3) -- 
    ,branch_name varchar2(195) -- 
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
grant select on ${iol_schema}.isbs_fea to ${iml_schema};
grant select on ${iol_schema}.isbs_fea to ${icl_schema};
grant select on ${iol_schema}.isbs_fea to ${idl_schema};
grant select on ${iol_schema}.isbs_fea to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fea is '外汇账户开关户信息';
comment on column ${iol_schema}.isbs_fea.currency_code is '';
comment on column ${iol_schema}.isbs_fea.ver is '';
comment on column ${iol_schema}.isbs_fea.actiondesc is '';
comment on column ${iol_schema}.isbs_fea.en_code is '';
comment on column ${iol_schema}.isbs_fea.business_date is '';
comment on column ${iol_schema}.isbs_fea.accountno is '';
comment on column ${iol_schema}.isbs_fea.limit_type is '';
comment on column ${iol_schema}.isbs_fea.account_cata is '';
comment on column ${iol_schema}.isbs_fea.actiontype is '';
comment on column ${iol_schema}.isbs_fea.file_number is '';
comment on column ${iol_schema}.isbs_fea.amtype is '';
comment on column ${iol_schema}.isbs_fea.account_limit is '';
comment on column ${iol_schema}.isbs_fea.business_date2 is '';
comment on column ${iol_schema}.isbs_fea.fea_type is '';
comment on column ${iol_schema}.isbs_fea.remark is '';
comment on column ${iol_schema}.isbs_fea.account_type is '';
comment on column ${iol_schema}.isbs_fea.branch_code is '';
comment on column ${iol_schema}.isbs_fea.en_name is '';
comment on column ${iol_schema}.isbs_fea.inr is '';
comment on column ${iol_schema}.isbs_fea.accountstat is '';
comment on column ${iol_schema}.isbs_fea.branch_name is '';
comment on column ${iol_schema}.isbs_fea.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fea.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fea.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fea.etl_timestamp is 'ETL处理时间戳';
