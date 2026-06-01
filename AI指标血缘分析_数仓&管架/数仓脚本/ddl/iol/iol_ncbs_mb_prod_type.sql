/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_prod_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_prod_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_prod_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_prod_type(
    prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,gl_merge_type_flag varchar2(1) -- 计提是否合并标志
    ,prod_desc varchar2(200) -- 产品名称
    ,prod_group_flag varchar2(1) -- 是否产品组
    ,prod_range varchar2(1) -- 产品作用范围
    ,status varchar2(1) -- 状态
    ,prod_class varchar2(20) -- 产品分类
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,base_prod_type varchar2(20) -- 基础产品
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
grant select on ${iol_schema}.ncbs_mb_prod_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_prod_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_prod_type is '产品类型定义表';
comment on column ${iol_schema}.ncbs_mb_prod_type.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_mb_prod_type.company is '法人';
comment on column ${iol_schema}.ncbs_mb_prod_type.gl_merge_type_flag is '计提是否合并标志';
comment on column ${iol_schema}.ncbs_mb_prod_type.prod_desc is '产品名称';
comment on column ${iol_schema}.ncbs_mb_prod_type.prod_group_flag is '是否产品组';
comment on column ${iol_schema}.ncbs_mb_prod_type.prod_range is '产品作用范围';
comment on column ${iol_schema}.ncbs_mb_prod_type.status is '状态';
comment on column ${iol_schema}.ncbs_mb_prod_type.prod_class is '产品分类';
comment on column ${iol_schema}.ncbs_mb_prod_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_prod_type.base_prod_type is '基础产品';
comment on column ${iol_schema}.ncbs_mb_prod_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_prod_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_prod_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_prod_type.etl_timestamp is 'ETL处理时间戳';
