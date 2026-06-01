/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbonddefaultpayment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbonddefaultpayment
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbonddefaultpayment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbonddefaultpayment(
    object_id varchar2(57) -- 对象ID
    ,b_info_windcode varchar2(60) -- Wind代码
    ,b_announcementdate varchar2(12) -- 公告日
    ,b_actual_payment varchar2(12) -- 实际兑付日
    ,b_payment_code number(9,0) -- 兑付类型代码
    ,b_payment_front_balance number(20,4) -- 兑付前债券余额(元)
    ,b_payment_amount number(20,4) -- 百元付息金额(元)
    ,b_principal_amount number(20,4) -- 百元兑付本金金额(元)
    ,b_principal_interest_amount number(20,4) -- 百元兑付本息金额(元)
    ,b_principal_amount_tot number(20,4) -- 兑付本金总额(元)
    ,b_principal_int_amount_tot number(20,4) -- 兑付利息总额(元)
    ,b_resale_payment_tot number(20,4) -- 兑付回售款总额(元)
    ,b_resale_payment_tot1 number(20,4) -- 兑付本息及回售款总额(元)
    ,b_payment_after_balance number(20,4) -- 兑付后债券余额(元)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_cbonddefaultpayment to ${iml_schema};
grant select on ${iol_schema}.wind_cbonddefaultpayment to ${icl_schema};
grant select on ${iol_schema}.wind_cbonddefaultpayment to ${idl_schema};
grant select on ${iol_schema}.wind_cbonddefaultpayment to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbonddefaultpayment is '中国债券违约兑付表';
comment on column ${iol_schema}.wind_cbonddefaultpayment.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_announcementdate is '公告日';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_actual_payment is '实际兑付日';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_payment_code is '兑付类型代码';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_payment_front_balance is '兑付前债券余额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_payment_amount is '百元付息金额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_principal_amount is '百元兑付本金金额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_principal_interest_amount is '百元兑付本息金额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_principal_amount_tot is '兑付本金总额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_principal_int_amount_tot is '兑付利息总额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_resale_payment_tot is '兑付回售款总额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_resale_payment_tot1 is '兑付本息及回售款总额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.b_payment_after_balance is '兑付后债券余额(元)';
comment on column ${iol_schema}.wind_cbonddefaultpayment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbonddefaultpayment.etl_timestamp is 'ETL处理时间戳';
