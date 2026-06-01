/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_irsdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_irsdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_irsdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_irsdeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(12) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,portfolio_id number -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,cpty_name varchar2(384) -- 交易对手
    ,ref_number varchar2(48) -- 合约编号
    ,trade_date number(8,0) -- 交易日期
    ,value_date number(8,0) -- 起息日
    ,contract_date number(8,0) -- 签约日
    ,maturity_date number(8,0) -- 到期日
    ,nominal number -- 交易面额
    ,os_amount number -- 剩余金额
    ,upfront_pr varchar2(8) -- 前置金付款方式
    ,upfront_fee number -- 前置金
    ,upfront_payment_date number(8,0) -- 前置金付款日
    ,amortization varchar2(2) -- 名义本金是否重置
    ,reduce_start_date number(8,0) -- 首期名义本金重置日
    ,reduce_freq varchar2(8) -- 名义本金重置频率
    ,reduce_type varchar2(8) -- 名义本金重置形态
    ,reduce_rate number -- 名义本金重置比率
    ,reduce_amt number -- 名义本金重置金额
    ,tax_amt number -- 税金
    ,fee number -- 手续费
    ,broker_amt number -- 佣金
    ,remark varchar2(4000) -- 备注
    ,receive_int_mode varchar2(2) -- 本方收取_计息方式
    ,receive_dc varchar2(8) -- 本方收取_计息基准
    ,receive_rate_type varchar2(8) -- 本方收取_利率类型
    ,receive_fixed_rate number -- 本方收取_固定利率
    ,receive_float_indicator number -- 本方收取_基准利率浮动方式
    ,receive_benchmark varchar2(23) -- 本方收取_浮动利率基准
    ,receive_spread number -- 本方收取_利率加点利差
    ,receive_upper_limit number -- 本方收取_浮动利率上界
    ,receive_lower_limit number -- 本方收取_浮动利率下界
    ,receive_fixing_freq varchar2(8) -- 本方收取_重置频率
    ,receive_dbcp_days number -- 本方收取_重置日调整天数
    ,receive_first_end_date number(8,0) -- 本方收取_首期付息日
    ,receive_period_adj varchar2(8) -- 本方收取_计息调整
    ,receive_payment_freq varchar2(8) -- 本方收取_支付频率
    ,receive_yield_curve varchar2(45) -- 本方收取_远期曲线
    ,receive_payment_adj varchar2(8) -- 本方收取_支付日调整
    ,receive_first_fix_date number(8,0) -- 本方收取_首次利率确定日
    ,receive_irr_period varchar2(8) -- 本方收取_支付日程畸零天期
    ,pay_int_mode varchar2(2) -- 本方支付_计息方式
    ,pay_dc varchar2(8) -- 本方支付_计息基准
    ,pay_rate_type varchar2(8) -- 本方支付_利率类型
    ,pay_fixed_rate number -- 本方支付_固定利率
    ,pay_float_indicator number -- 本方支付_基准利率浮动方式
    ,pay_benchmark varchar2(23) -- 本方支付_浮动利率基准
    ,pay_spread number -- 本方支付_利率加点利差
    ,pay_upper_limit number -- 本方支付_浮动利率上界
    ,pay_lower_limit number -- 本方支付_浮动利率下界
    ,pay_fixing_freq varchar2(8) -- 本方支付_重置频率
    ,pay_dbcp_days number -- 本方支付_重置日调整天数
    ,pay_first_end_date number(8,0) -- 本方支付_首期付息日
    ,pay_period_adj varchar2(8) -- 本方支付_计息调整
    ,pay_payment_freq varchar2(8) -- 本方支付_支付频率
    ,pay_yield_curve varchar2(45) -- 本方支付_远期曲线
    ,pay_payment_adj varchar2(8) -- 本方支付_支付日调整
    ,pay_first_fix_date number(8,0) -- 本方支付_首次利率确定日
    ,pay_irr_period varchar2(8) -- 本方支付_支付日程畸零天期
    ,serial_number varchar2(23) -- 交易序号
    ,dealer_id number(4,0) -- 交易员ID
    ,counterparty_seq number -- 交易对手序号
    ,lastmodified timestamp -- 最后修改时间
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,settlement_type varchar2(2) -- 清算方式
    ,irsdeals_id_grand number -- 原始交易ID
    ,dn_dealer varchar2(900) -- 本币交易员
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
grant select on ${iol_schema}.ctms_tbs_v_irsdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_irsdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_irsdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_irsdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_irsdeals is '利率互换交易';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.cpty_name is '交易对手';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.ref_number is '合约编号';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.trade_date is '交易日期';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.value_date is '起息日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.contract_date is '签约日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.maturity_date is '到期日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.nominal is '交易面额';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.os_amount is '剩余金额';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.upfront_pr is '前置金付款方式';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.upfront_fee is '前置金';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.upfront_payment_date is '前置金付款日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.amortization is '名义本金是否重置';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.reduce_start_date is '首期名义本金重置日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.reduce_freq is '名义本金重置频率';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.reduce_type is '名义本金重置形态';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.reduce_rate is '名义本金重置比率';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.reduce_amt is '名义本金重置金额';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.tax_amt is '税金';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.fee is '手续费';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.broker_amt is '佣金';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.remark is '备注';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_int_mode is '本方收取_计息方式';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_dc is '本方收取_计息基准';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_rate_type is '本方收取_利率类型';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_fixed_rate is '本方收取_固定利率';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_float_indicator is '本方收取_基准利率浮动方式';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_benchmark is '本方收取_浮动利率基准';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_spread is '本方收取_利率加点利差';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_upper_limit is '本方收取_浮动利率上界';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_lower_limit is '本方收取_浮动利率下界';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_fixing_freq is '本方收取_重置频率';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_dbcp_days is '本方收取_重置日调整天数';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_first_end_date is '本方收取_首期付息日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_period_adj is '本方收取_计息调整';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_payment_freq is '本方收取_支付频率';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_yield_curve is '本方收取_远期曲线';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_payment_adj is '本方收取_支付日调整';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_first_fix_date is '本方收取_首次利率确定日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.receive_irr_period is '本方收取_支付日程畸零天期';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_int_mode is '本方支付_计息方式';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_dc is '本方支付_计息基准';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_rate_type is '本方支付_利率类型';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_fixed_rate is '本方支付_固定利率';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_float_indicator is '本方支付_基准利率浮动方式';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_benchmark is '本方支付_浮动利率基准';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_spread is '本方支付_利率加点利差';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_upper_limit is '本方支付_浮动利率上界';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_lower_limit is '本方支付_浮动利率下界';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_fixing_freq is '本方支付_重置频率';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_dbcp_days is '本方支付_重置日调整天数';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_first_end_date is '本方支付_首期付息日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_period_adj is '本方支付_计息调整';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_payment_freq is '本方支付_支付频率';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_yield_curve is '本方支付_远期曲线';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_payment_adj is '本方支付_支付日调整';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_first_fix_date is '本方支付_首次利率确定日';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.pay_irr_period is '本方支付_支付日程畸零天期';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.serial_number is '交易序号';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.dealer_id is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.counterparty_seq is '交易对手序号';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.settlement_type is '清算方式';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.irsdeals_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_irsdeals.etl_timestamp is 'ETL处理时间戳';
