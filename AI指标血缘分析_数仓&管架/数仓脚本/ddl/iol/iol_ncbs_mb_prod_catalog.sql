/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_prod_catalog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_prod_catalog
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_prod_catalog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_prod_catalog(
    prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,prod_desc varchar2(200) -- 产品名称
    ,prod_status varchar2(1) -- 产品状态
    ,system_id varchar2(20) -- 系统id
    ,prod_class varchar2(20) -- 产品分类
    ,effect_date date -- 产品生效日期
    ,expire_date date -- 失效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,base_prod varchar2(20) -- 基础产品
    ,prod_name varchar2(200) -- 总账产品名称
    ,prod_sub_class varchar2(20) -- 产品细类
    ,ctlg_level varchar2(1) -- 目录层级
    ,prod_group_name varchar2(200) -- 产品分组名称
    ,prod_group varchar2(20) -- 产品分组
    ,prod_class_name varchar2(200) -- 产品分类名称
    ,catalog_no varchar2(50) -- 目录序号
    ,prod_sub_class_name varchar2(200) -- 产品细类名称
    ,base_prod_name varchar2(200) -- 基础产品名称
    ,manage_dept varchar2(40) -- 管理部门
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
grant select on ${iol_schema}.ncbs_mb_prod_catalog to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_prod_catalog to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_catalog to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_catalog to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_prod_catalog is '产品目录表';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.company is '法人';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_desc is '产品名称';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_status is '产品状态';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.system_id is '系统id';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_class is '产品分类';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.base_prod is '基础产品';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_name is '总账产品名称';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_sub_class is '产品细类';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.ctlg_level is '目录层级';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_group_name is '产品分组名称';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_group is '产品分组';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_class_name is '产品分类名称';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.catalog_no is '目录序号';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.prod_sub_class_name is '产品细类名称';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.base_prod_name is '基础产品名称';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.manage_dept is '管理部门';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_prod_catalog.etl_timestamp is 'ETL处理时间戳';
