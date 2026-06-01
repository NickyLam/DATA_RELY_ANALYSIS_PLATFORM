/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_coupondeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_coupondeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_coupondeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_coupondeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(17) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,balance_id number -- 引用表2ID
    ,paydate number -- 还本付息日期
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,assettype varchar2(30) -- 资产类别
    ,bondscode varchar2(30) -- 债券代码
    ,coupontype varchar2(2) -- 本息类型
    ,principalamount number -- 还本金额
    ,interestamount number -- 付息金额
    ,lastmodified timestamp -- 最后修改时间
    ,coupondeals_id_grand number -- 原始交易ID
    ,act_paydate number -- 实际支付日
    ,lastmodified_pay timestamp -- 实收付确认的修改时间
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_coupondeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_coupondeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_coupondeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_coupondeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_coupondeals is '实际收付确认-现券收付息';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.balance_id is '引用表2ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.paydate is '还本付息日期';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.assettype is '资产类别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.bondscode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.coupontype is '本息类型';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.principalamount is '还本金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.interestamount is '付息金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.coupondeals_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.act_paydate is '实际支付日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_coupondeals.etl_timestamp is 'ETL处理时间戳';
