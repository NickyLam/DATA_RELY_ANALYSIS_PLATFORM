/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_irscoupondeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(21) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,serial_number varchar2(23) -- 交易组别
    ,seq number -- 计息周期序号
    ,pay_rec varchar2(2) -- 收付方向
    ,start_date number(8,0) -- 付息周期起始日
    ,end_date number(8,0) -- 付息周期结束日
    ,days number -- 当期计息周期天数
    ,nominal_ccy varchar2(5) -- 名义本金币种
    ,nominal number -- 名义本金
    ,fixing_date number(8,0) -- 利率重置日
    ,fixing_rate number -- 重置日利率
    ,amount number -- 收付息金额
    ,payment_date number(8,0) -- 收付息日期
    ,note varchar2(4000) -- 备注
    ,spread number -- 利差（BP）
    ,reduce number -- 名义本金重置变化金额
    ,dailyaccrualdays number -- 本计息周期天数
    ,os_amount number -- 剩余名义本金
    ,ori_payment number -- 本计息周期支付金额
    ,lastmodified timestamp -- 最后修改时间
    ,irsdeals_id number -- 对应IRS交易ID
    ,portfolio_id number -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,cpty_name varchar2(384) -- 交易对手
    ,counterparty_seq number -- 交易对手序号
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals is '实际收付确认-利率互换收付息';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.serial_number is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.seq is '计息周期序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.pay_rec is '收付方向';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.start_date is '付息周期起始日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.end_date is '付息周期结束日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.days is '当期计息周期天数';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.nominal_ccy is '名义本金币种';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.nominal is '名义本金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.fixing_date is '利率重置日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.fixing_rate is '重置日利率';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.amount is '收付息金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.payment_date is '收付息日期';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.note is '备注';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.spread is '利差（BP）';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.reduce is '名义本金重置变化金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.dailyaccrualdays is '本计息周期天数';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.os_amount is '剩余名义本金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.ori_payment is '本计息周期支付金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.irsdeals_id is '对应IRS交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.cpty_name is '交易对手';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.counterparty_seq is '交易对手序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals.etl_timestamp is 'ETL处理时间戳';
