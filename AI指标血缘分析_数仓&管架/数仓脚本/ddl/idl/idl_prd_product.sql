/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl prd_product
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.prd_product
whenever sqlerror continue none;
drop table ${idl_schema}.prd_product purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.prd_product(
    etl_dt date -- 数据日期   
    ,prod_id varchar2(60) -- 产品编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,prod_name varchar2(500) -- 产品名称   
    ,prod_descb varchar2(1000) -- 产品描述   
    ,prod_type_cd varchar2(10) -- 产品类型代码   
    ,self_own_prod_flg varchar2(10) -- 自有产品标志   
    ,sellbl_prod_flg varchar2(10) -- 可售产品标志   
    ,prod_effect_dt date -- 产品生效日期   
    ,prod_invalid_dt date -- 产品失效日期   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.prd_product to ${iel_schema};

-- comment
comment on table ${idl_schema}.prd_product is '产品';
comment on column ${idl_schema}.prd_product.etl_dt is '数据日期';
comment on column ${idl_schema}.prd_product.prod_id is '产品编号';
comment on column ${idl_schema}.prd_product.lp_id is '法人编号';
comment on column ${idl_schema}.prd_product.prod_name is '产品名称';
comment on column ${idl_schema}.prd_product.prod_descb is '产品描述';
comment on column ${idl_schema}.prd_product.prod_type_cd is '产品类型代码';
comment on column ${idl_schema}.prd_product.self_own_prod_flg is '自有产品标志';
comment on column ${idl_schema}.prd_product.sellbl_prod_flg is '可售产品标志';
comment on column ${idl_schema}.prd_product.prod_effect_dt is '产品生效日期';
comment on column ${idl_schema}.prd_product.prod_invalid_dt is '产品失效日期';
comment on column ${idl_schema}.prd_product.create_dt is '创建日期';
comment on column ${idl_schema}.prd_product.update_dt is '更新日期';
comment on column ${idl_schema}.prd_product.id_mark is '删除标识';