/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_order_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_order_prod
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_order_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_order_prod(
    client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,order_seq_no varchar2(50) -- 预约登记号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,new_prod_type varchar2(12) -- 变更后的产品类型
    ,old_prod_type varchar2(12) -- 原产品类型
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
grant select on ${iol_schema}.ncbs_cl_order_prod to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_order_prod to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_order_prod to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_order_prod to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_order_prod is '产品变更预约表';
comment on column ${iol_schema}.ncbs_cl_order_prod.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_order_prod.company is '法人';
comment on column ${iol_schema}.ncbs_cl_order_prod.order_seq_no is '预约登记号';
comment on column ${iol_schema}.ncbs_cl_order_prod.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_order_prod.new_prod_type is '变更后的产品类型';
comment on column ${iol_schema}.ncbs_cl_order_prod.old_prod_type is '原产品类型';
comment on column ${iol_schema}.ncbs_cl_order_prod.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_order_prod.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_order_prod.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_order_prod.etl_timestamp is 'ETL处理时间戳';
