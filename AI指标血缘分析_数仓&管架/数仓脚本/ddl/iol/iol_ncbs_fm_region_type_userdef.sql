/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_region_type_userdef
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_region_type_userdef
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_region_type_userdef purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_region_type_userdef(
    company varchar2(20) -- 法人
    ,cross_region_flag varchar2(1) -- 是否允许机构跨区域存在
    ,region_type varchar2(10) -- 区域类型
    ,region_type_desc varchar2(50) -- 区域类型描述
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
grant select on ${iol_schema}.ncbs_fm_region_type_userdef to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_region_type_userdef to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_region_type_userdef to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_region_type_userdef to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_region_type_userdef is '自定义区域类型定义';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.company is '法人';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.cross_region_flag is '是否允许机构跨区域存在';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.region_type is '区域类型';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.region_type_desc is '区域类型描述';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_region_type_userdef.etl_timestamp is 'ETL处理时间戳';
