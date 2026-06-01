/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_dbl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_dbl
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_dbl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_dbl(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- Internal Unique ID
    ,ver varchar2(4) -- Version
    ,objtyp varchar2(6) -- Object Type
    ,objinr varchar2(8) -- Object INR
    ,rptno varchar2(22) -- 申报号码
    ,bassta varchar2(1) -- 基本数据状态
    ,dclsta varchar2(1) -- 申报信息状态
    ,vrfsta varchar2(1) -- 核销信息状态
    ,ownextkey varchar2(8) -- Initial Entity Code
    ,ownusr varchar2(6) -- Own User
    ,trninr varchar2(8) -- 对应TRNINR
    ,credat date -- 创建日期
    ,reldat date -- 授权日期
    ,tmpref varchar2(16) -- 临时申报流水号
    ,trdtyp varchar2(1) -- 贸易类型
    ,acttyp varchar2(4) -- 款项标志
    ,ygasta varchar2(1) -- 粤港澳电子缴费业务状态
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_isbs_dbl to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_dbl is '申报信息状态表';
comment on column ${idl_schema}.aml_isbs_dbl.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_dbl.inr is 'Internal Unique ID';
comment on column ${idl_schema}.aml_isbs_dbl.ver is 'Version';
comment on column ${idl_schema}.aml_isbs_dbl.objtyp is 'Object Type';
comment on column ${idl_schema}.aml_isbs_dbl.objinr is 'Object INR';
comment on column ${idl_schema}.aml_isbs_dbl.rptno is '申报号码';
comment on column ${idl_schema}.aml_isbs_dbl.bassta is '基本数据状态';
comment on column ${idl_schema}.aml_isbs_dbl.dclsta is '申报信息状态';
comment on column ${idl_schema}.aml_isbs_dbl.vrfsta is '核销信息状态';
comment on column ${idl_schema}.aml_isbs_dbl.ownextkey is 'Initial Entity Code';
comment on column ${idl_schema}.aml_isbs_dbl.ownusr is 'Own User';
comment on column ${idl_schema}.aml_isbs_dbl.trninr is '对应TRNINR';
comment on column ${idl_schema}.aml_isbs_dbl.credat is '创建日期';
comment on column ${idl_schema}.aml_isbs_dbl.reldat is '授权日期';
comment on column ${idl_schema}.aml_isbs_dbl.tmpref is '临时申报流水号';
comment on column ${idl_schema}.aml_isbs_dbl.trdtyp is '贸易类型';
comment on column ${idl_schema}.aml_isbs_dbl.acttyp is '款项标志';
comment on column ${idl_schema}.aml_isbs_dbl.ygasta is '粤港澳电子缴费业务状态';
comment on column ${idl_schema}.aml_isbs_dbl.etl_timestamp is '数据处理时间';
