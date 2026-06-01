/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_client_exchange_rate_discount
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_client_exchange_rate_discount
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_client_exchange_rate_discount purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_client_exchange_rate_discount(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,exchange_type varchar2(10) -- 结售汇类型
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,apply_branch varchar2(12) -- 申请机构
    ,unc_discount_value number(15,8) -- 平盘优惠值
    ,int_valid_from_date date -- 利率优惠有效期起始日期
    ,int_valid_thru_date date -- 利率优惠有效期截止日期
    ,discount_term number(5) -- 优惠期限
    ,discount_status varchar2(3) -- 优惠状态
    ,exchange_discount_type varchar2(3) -- 汇率优惠类型
    ,last_operate_status varchar2(3) -- 上次操作状态
    ,discount_value number(15,8) -- 客户单户优惠值
    ,coupon_rate_type varchar2(1) -- 优惠汇率类型
    ,int_rate_form_no varchar2(50) -- 利率审批单单号
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
grant select on ${iol_schema}.ncbs_rb_client_exchange_rate_discount to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_client_exchange_rate_discount to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_client_exchange_rate_discount to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_client_exchange_rate_discount to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_client_exchange_rate_discount is '客户优惠汇率表';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.branch is '机构编号';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.company is '法人';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.exchange_type is '结售汇类型';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.apply_branch is '申请机构';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.unc_discount_value is '平盘优惠值';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.int_valid_from_date is '利率优惠有效期起始日期';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.int_valid_thru_date is '利率优惠有效期截止日期';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.discount_term is '优惠期限';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.discount_status is '优惠状态';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.exchange_discount_type is '汇率优惠类型';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.last_operate_status is '上次操作状态';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.discount_value is '客户单户优惠值';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.coupon_rate_type is '优惠汇率类型';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.int_rate_form_no is '利率审批单单号';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_client_exchange_rate_discount.etl_timestamp is 'ETL处理时间戳';
