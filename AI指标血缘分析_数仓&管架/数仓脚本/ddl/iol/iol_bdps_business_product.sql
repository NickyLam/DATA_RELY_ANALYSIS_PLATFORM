/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_business_product
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_business_product
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_business_product purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_business_product(
    id number(22) -- 
    ,business_type varchar2(6) -- 
    ,product_name varchar2(90) -- 
    ,draft_type varchar2(2) -- 
    ,biz_type varchar2(3) -- 
    ,buy_type varchar2(6) -- 
    ,misc varchar2(150) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
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
grant select on ${iol_schema}.bdps_business_product to ${iml_schema};
grant select on ${iol_schema}.bdps_business_product to ${icl_schema};
grant select on ${iol_schema}.bdps_business_product to ${idl_schema};
grant select on ${iol_schema}.bdps_business_product to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_business_product is '业务产品表';
comment on column ${iol_schema}.bdps_business_product.id is '';
comment on column ${iol_schema}.bdps_business_product.business_type is '';
comment on column ${iol_schema}.bdps_business_product.product_name is '';
comment on column ${iol_schema}.bdps_business_product.draft_type is '';
comment on column ${iol_schema}.bdps_business_product.biz_type is '';
comment on column ${iol_schema}.bdps_business_product.buy_type is '';
comment on column ${iol_schema}.bdps_business_product.misc is '';
comment on column ${iol_schema}.bdps_business_product.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_business_product.last_upd_time is '';
comment on column ${iol_schema}.bdps_business_product.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_business_product.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_business_product.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_business_product.etl_timestamp is 'ETL处理时间戳';
