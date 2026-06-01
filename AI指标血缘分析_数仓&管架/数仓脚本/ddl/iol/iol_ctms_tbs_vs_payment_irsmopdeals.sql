/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_irsmopdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(17) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,portfolio_id number -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,seq number -- 序号
    ,source_trade_number varchar2(23) -- 源交易序号
    ,ref_number varchar2(48) -- 合约编号
    ,cpty_name varchar2(384) -- 交易对手名称
    ,trade_date number(8,0) -- 交易日期
    ,value_date number(8,0) -- 生效日
    ,payment_date number(8,0) -- 付款日
    ,amount number -- 解约金额
    ,cost_type varchar2(8) -- 违约金付款方式
    ,cost_ccy varchar2(5) -- 支出货币
    ,cost_amt number -- 违约金
    ,remark varchar2(4000) -- 备注
    ,serial_number varchar2(23) -- 交易序号
    ,dealer_id number(4,0) -- 交易员ID
    ,lastmodified timestamp -- 最后更新时间
    ,counterparty_seq number -- 交易对手序号
    ,irsdeals_id number -- 对应IRS交易ID
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,settlement_type varchar2(2) -- 清算方式
    ,irsmopdeals_id_grand number -- 原始交易ID
    ,lastmodified_pay timestamp -- 实收付确认的修改时间
    ,dn_dealer varchar2(900) -- 本币交易员
    ,status varchar2(2) -- 状态
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals is '实际收付确认-利率互换解约';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.seq is '序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.source_trade_number is '源交易序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.ref_number is '合约编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.cpty_name is '交易对手名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.trade_date is '交易日期';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.value_date is '生效日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.payment_date is '付款日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.amount is '解约金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.cost_type is '违约金付款方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.cost_ccy is '支出货币';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.cost_amt is '违约金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.remark is '备注';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.serial_number is '交易序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.dealer_id is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.lastmodified is '最后更新时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.counterparty_seq is '交易对手序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.irsdeals_id is '对应IRS交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.settlement_type is '清算方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.irsmopdeals_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_irsmopdeals.etl_timestamp is 'ETL处理时间戳';
