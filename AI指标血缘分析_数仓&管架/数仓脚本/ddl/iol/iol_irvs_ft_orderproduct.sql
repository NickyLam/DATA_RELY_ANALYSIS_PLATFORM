/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol irvs_ft_orderproduct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.irvs_ft_orderproduct
whenever sqlerror continue none;
drop table ${iol_schema}.irvs_ft_orderproduct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.irvs_ft_orderproduct(
    product_id varchar2(50) -- 产品id
    ,ecif_id varchar2(50) -- 委托人id
    ,is_parent_ecif varchar2(3) -- 是否是主委托人0 否 1 是
    ,created_by varchar2(100) -- 创建者
    ,updated_by varchar2(100) -- 修改者
    ,create_time date -- 创建时间
    ,update_time date -- 修改时间
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
grant select on ${iol_schema}.irvs_ft_orderproduct to ${iml_schema};
grant select on ${iol_schema}.irvs_ft_orderproduct to ${icl_schema};
grant select on ${iol_schema}.irvs_ft_orderproduct to ${idl_schema};
grant select on ${iol_schema}.irvs_ft_orderproduct to ${iel_schema};

-- comment
comment on table ${iol_schema}.irvs_ft_orderproduct is '委托人关联产品';
comment on column ${iol_schema}.irvs_ft_orderproduct.product_id is '产品id';
comment on column ${iol_schema}.irvs_ft_orderproduct.ecif_id is '委托人id';
comment on column ${iol_schema}.irvs_ft_orderproduct.is_parent_ecif is '是否是主委托人0 否 1 是';
comment on column ${iol_schema}.irvs_ft_orderproduct.created_by is '创建者';
comment on column ${iol_schema}.irvs_ft_orderproduct.updated_by is '修改者';
comment on column ${iol_schema}.irvs_ft_orderproduct.create_time is '创建时间';
comment on column ${iol_schema}.irvs_ft_orderproduct.update_time is '修改时间';
comment on column ${iol_schema}.irvs_ft_orderproduct.start_dt is '开始时间';
comment on column ${iol_schema}.irvs_ft_orderproduct.end_dt is '结束时间';
comment on column ${iol_schema}.irvs_ft_orderproduct.id_mark is '增删标志';
comment on column ${iol_schema}.irvs_ft_orderproduct.etl_timestamp is 'ETL处理时间戳';
