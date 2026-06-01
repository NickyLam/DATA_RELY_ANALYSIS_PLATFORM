/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_loancoupondeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(23) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,keepfolder_id number -- 交易组别
    ,keepfolder_shortname varchar2(75) -- 交易组别名称
    ,serial_number varchar2(23) -- 关联主交易的交易序号
    ,seq number -- 顺序号
    ,start_date number(8,0) -- 计息开始日
    ,end_date number(8,0) -- 计息截止日
    ,fixing_rate number -- 指标利率值
    ,spread number -- 点差
    ,rate number -- 重设利率
    ,payment_date number(8,0) -- 支付日
    ,os_amount number -- 计息金额
    ,interest number -- 本期利息
    ,ostart_date number(8,0) -- 原始计息开始日
    ,oend_date number(8,0) -- 原始计息结束日
    ,ofixing_date number(8,0) -- 原始重设日
    ,opayment_date number(8,0) -- 原始支付日
    ,fixing_date number(8,0) -- 利息重设日
    ,is_fixing varchar2(2) -- 利率是否已重设
    ,lastmodified timestamp -- 最终修改时间
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals is '实际收付确认-同存收付息';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.keepfolder_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.keepfolder_shortname is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.serial_number is '关联主交易的交易序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.seq is '顺序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.start_date is '计息开始日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.end_date is '计息截止日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.fixing_rate is '指标利率值';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.spread is '点差';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.rate is '重设利率';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.payment_date is '支付日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.os_amount is '计息金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.interest is '本期利息';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.ostart_date is '原始计息开始日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.oend_date is '原始计息结束日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.ofixing_date is '原始重设日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.opayment_date is '原始支付日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.fixing_date is '利息重设日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.is_fixing is '利率是否已重设';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.lastmodified is '最终修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals.etl_timestamp is 'ETL处理时间戳';
