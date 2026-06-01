/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_self_rproduct_paymentinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo(
    i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,payment_date varchar2(15) -- 支付日期
    ,notional number(16,2) -- 本金
    ,ai number(16,2) -- 利息
    ,payment_info_type varchar2(2) -- 现金流获取方式（1系统默认，2偿还本息）
    ,update_time varchar2(35) -- 更新时间
    ,postpone_ai number(16,2) -- 顺延ai，用于记录顺延的利息值，区分ai是来自dueai还是比例顺延
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
grant select on ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo is '非标现金流表';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.payment_date is '支付日期';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.notional is '本金';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.ai is '利息';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.payment_info_type is '现金流获取方式（1系统默认，2偿还本息）';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.postpone_ai is '顺延ai，用于记录顺延的利息值，区分ai是来自dueai还是比例顺延';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_self_rproduct_paymentinfo.etl_timestamp is 'ETL处理时间戳';
