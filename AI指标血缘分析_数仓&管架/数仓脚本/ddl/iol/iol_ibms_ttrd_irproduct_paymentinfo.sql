/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_irproduct_paymentinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo(
    i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 金融工具资产类型
    ,m_type varchar2(30) -- 金融工具市场类型
    ,payment_date varchar2(15) -- 支付日期
    ,notional number(16,2) -- 本金
    ,ai number(16,2) -- 利息
    ,amount number(16,2) -- 总金额
    ,updatetime varchar2(30) -- 更新时间
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
grant select on ${iol_schema}.ibms_ttrd_irproduct_paymentinfo to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_irproduct_paymentinfo to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_irproduct_paymentinfo to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_irproduct_paymentinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo is '非标现金流表';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.a_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.m_type is '金融工具市场类型';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.payment_date is '支付日期';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.notional is '本金';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.ai is '利息';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.amount is '总金额';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.updatetime is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_irproduct_paymentinfo.etl_timestamp is 'ETL处理时间戳';
