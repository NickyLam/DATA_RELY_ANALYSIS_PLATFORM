/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_fee_catalog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_fee_catalog
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_fee_catalog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_catalog(
    base_fee_name varchar2(200) -- 基础费用名称
    ,company varchar2(20) -- 法人
    ,fee_class varchar2(20) -- 费用分类
    ,fee_desc varchar2(200) -- 费用类型描述
    ,fee_type varchar2(20) -- 费率类型
    ,system_id varchar2(20) -- 系统id
    ,effect_date date -- 产品生效日期
    ,expire_date date -- 失效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,fee_name varchar2(200) -- 费用名称
    ,fee_status varchar2(1) -- 费用状态
    ,fee_class_name varchar2(200) -- 费用分类名称
    ,fee_sub_class varchar2(20) -- 费用细类
    ,fee_group varchar2(20) -- 费用分组
    ,catalog_no varchar2(50) -- 目录序号
    ,base_fee varchar2(20) -- 基础费用，带目录结构
    ,fee_sub_class_name varchar2(20) -- 费用细类名称
    ,manage_dept varchar2(40) -- 管理部门
    ,fee_group_name varchar2(200) -- 费用分组名称
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
grant select on ${iol_schema}.ncbs_mb_fee_catalog to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_fee_catalog to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_catalog to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_catalog to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_fee_catalog is '费用目录';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.base_fee_name is '基础费用名称';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.company is '法人';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_class is '费用分类';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_desc is '费用类型描述';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.system_id is '系统id';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_name is '费用名称';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_status is '费用状态';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_class_name is '费用分类名称';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_sub_class is '费用细类';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_group is '费用分组';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.catalog_no is '目录序号';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.base_fee is '基础费用，带目录结构';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_sub_class_name is '费用细类名称';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.manage_dept is '管理部门';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.fee_group_name is '费用分组名称';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_fee_catalog.etl_timestamp is 'ETL处理时间戳';
