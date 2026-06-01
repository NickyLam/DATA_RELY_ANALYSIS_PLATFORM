/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_wtrade_underwrite_p
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p(
    deal_id number -- 引用表ID
    ,deal_name varchar2(26) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,portfolio_id number -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,cpty_name varchar2(384) -- 交易对手
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,ref_number varchar2(48) -- 成交编号
    ,currency varchar2(5) -- 交易币别
    ,trade_date number -- 交易日
    ,value_date number(8,0) -- 交割日
    ,security_code varchar2(45) -- 债券代码
    ,amount number -- 交易面额
    ,settle_amt number -- 成交金额
    ,price number -- 承分销价
    ,uw_fee_rate number -- 承销手续费率
    ,note varchar2(4000) -- 备注
    ,trade_type varchar2(2) -- 交易类型
    ,sell_portfolio number -- 转自营投组ID
    ,sell_portfolio_name varchar2(120) -- 转自营投组名称
    ,security_trade_no varchar2(23) -- 交易的现券表交易单号(SERIAL_NUMBER)
    ,fee number -- 手续费
    ,tax_amt number -- 税金
    ,broker_amt number -- 佣金
    ,uw_buy_no varchar2(23) -- 附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
    ,uw_buy_id number -- 附属交易对应承销买入主交易的单号（DEAL_ID）
    ,valid_source_sn varchar2(23) -- 审批单号
    ,cancel_reason varchar2(384) -- 撤销原因
    ,uw_price number -- 分销卖出对应承销买入的价格
    ,cfets_from varchar2(2) -- 是否场内交易
    ,review_status varchar2(2) -- 复核状态(前台)
    ,review_user_id varchar2(15) -- 复核人员ID
    ,review_user_name varchar2(48) -- 复核人员名称
    ,review_time date -- 复核日期
    ,serial_number varchar2(23) -- 交易序号
    ,dealer_id number(4,0) -- 交易员ID
    ,lastmodified timestamp -- 最近更新时间
    ,counterparty_seq number -- comstar交易对手序号
    ,counterparty_short_cname varchar2(384) -- 交易对手
    ,security_trade_id number -- 交易的现券表ID号(DEAL_ID)
    ,trading_fee number -- 交易费用
    ,fee_return number -- 返还手续费
    ,fee_date number(8,0) -- 手续费划付日
    ,return_rate number -- 手续费返还比例
    ,fx_price number -- 分销价
    ,fee_type varchar2(2) -- 手续费类型
    ,wtrade_underwrite_id_grand number -- 原始交易ID
    ,lastmodified_pay timestamp -- 实收付确认的修改时间
    ,dn_dealer varchar2(900) -- 本币交易员
    ,dealer_name varchar2(30) -- 交易员名称
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p is '实际收付确认-承分销代销';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.cpty_name is '交易对手';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.ref_number is '成交编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.currency is '交易币别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.trade_date is '交易日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.value_date is '交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.amount is '交易面额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.settle_amt is '成交金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.price is '承分销价';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.uw_fee_rate is '承销手续费率';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.note is '备注';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.trade_type is '交易类型';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.sell_portfolio is '转自营投组ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.sell_portfolio_name is '转自营投组名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.security_trade_no is '交易的现券表交易单号(SERIAL_NUMBER)';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.fee is '手续费';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.tax_amt is '税金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.broker_amt is '佣金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.uw_buy_no is '附属交易对应承销买入主交易的单号（SERIAL_NUMBER）';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.uw_buy_id is '附属交易对应承销买入主交易的单号（DEAL_ID）';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.valid_source_sn is '审批单号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.cancel_reason is '撤销原因';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.uw_price is '分销卖出对应承销买入的价格';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.cfets_from is '是否场内交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.review_status is '复核状态(前台)';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.review_user_id is '复核人员ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.review_user_name is '复核人员名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.review_time is '复核日期';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.serial_number is '交易序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.dealer_id is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.lastmodified is '最近更新时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.counterparty_seq is 'comstar交易对手序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.counterparty_short_cname is '交易对手';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.security_trade_id is '交易的现券表ID号(DEAL_ID)';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.trading_fee is '交易费用';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.fee_return is '返还手续费';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.fee_date is '手续费划付日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.return_rate is '手续费返还比例';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.fx_price is '分销价';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.fee_type is '手续费类型';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.wtrade_underwrite_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.dealer_name is '交易员名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_underwrite_p.etl_timestamp is 'ETL处理时间戳';
