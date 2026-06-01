/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_region
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_region
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_region purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_region(
    company varchar2(20) -- 法人
    ,internal_code varchar2(1) -- 内部码
    ,region varchar2(2) -- 地区（洲代码）
    ,region_desc varchar2(50) -- 地区描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_fm_region to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_region to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_region to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_region to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_region is '区域代码地区基本信息';
comment on column ${iol_schema}.ncbs_fm_region.company is '法人';
comment on column ${iol_schema}.ncbs_fm_region.internal_code is '内部码';
comment on column ${iol_schema}.ncbs_fm_region.region is '地区（洲代码）';
comment on column ${iol_schema}.ncbs_fm_region.region_desc is '地区描述';
comment on column ${iol_schema}.ncbs_fm_region.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_region.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_region.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_region.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_region.etl_timestamp is 'ETL处理时间戳';
