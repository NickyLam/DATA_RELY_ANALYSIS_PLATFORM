/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_financial_product
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_financial_product
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_financial_product purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_financial_product(
    id number(22) -- 
    ,product_no varchar2(192) -- 产品编号
    ,product_name varchar2(192) -- 产品名称
    ,matudt varchar2(192) -- 期限
    ,start_date varchar2(12) -- 起息日
    ,maturity_date varchar2(12) -- 到期日
    ,quotient number(12,4) -- 份额
    ,available_quotient number(12,4) -- 可用份额
    ,yield_rate number(12,4) -- 收益率
    ,is_breakeven varchar2(3) -- 是否保本 11-保本12-非保本
    ,last_upd_time varchar2(21) -- 最后更新时间
    ,remark varchar2(192) -- 备注
    ,product_type varchar2(192) -- 产品类型
    ,bank_account varchar2(33) -- 理财产品账号
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
grant select on ${iol_schema}.bdps_financial_product to ${iml_schema};
grant select on ${iol_schema}.bdps_financial_product to ${icl_schema};
grant select on ${iol_schema}.bdps_financial_product to ${idl_schema};
grant select on ${iol_schema}.bdps_financial_product to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_financial_product is '理财产品表';
comment on column ${iol_schema}.bdps_financial_product.id is '';
comment on column ${iol_schema}.bdps_financial_product.product_no is '产品编号';
comment on column ${iol_schema}.bdps_financial_product.product_name is '产品名称';
comment on column ${iol_schema}.bdps_financial_product.matudt is '期限';
comment on column ${iol_schema}.bdps_financial_product.start_date is '起息日';
comment on column ${iol_schema}.bdps_financial_product.maturity_date is '到期日';
comment on column ${iol_schema}.bdps_financial_product.quotient is '份额';
comment on column ${iol_schema}.bdps_financial_product.available_quotient is '可用份额';
comment on column ${iol_schema}.bdps_financial_product.yield_rate is '收益率';
comment on column ${iol_schema}.bdps_financial_product.is_breakeven is '是否保本 11-保本12-非保本';
comment on column ${iol_schema}.bdps_financial_product.last_upd_time is '最后更新时间';
comment on column ${iol_schema}.bdps_financial_product.remark is '备注';
comment on column ${iol_schema}.bdps_financial_product.product_type is '产品类型';
comment on column ${iol_schema}.bdps_financial_product.bank_account is '理财产品账号';
comment on column ${iol_schema}.bdps_financial_product.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_financial_product.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_financial_product.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_financial_product.etl_timestamp is 'ETL处理时间戳';
