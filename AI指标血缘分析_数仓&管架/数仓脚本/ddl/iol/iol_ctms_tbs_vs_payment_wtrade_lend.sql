/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_wtrade_lend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend(
    deal_id number -- 引用表ID
    ,deal_tablename varchar2(15) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,bondscode varchar2(510) -- 质押券代码
    ,lendbondscode varchar2(30) -- 标的券代码
    ,serial_number varchar2(23) -- 交易号
    ,trade_date varchar2(12) -- 首期交易日
    ,value_date varchar2(12) -- 首期交割日
    ,maturity_date varchar2(12) -- 到期交割日
    ,buyorsell varchar2(2) -- 交易方向
    ,face_amount varchar2(510) -- 质押券面额
    ,trade_time date -- 交易时间
    ,amount number(17,2) -- 首期结算金额
    ,maturity_amount number(17,2) -- 到期结算金额
    ,fee number(17,2) -- 首期费用
    ,tax_amt number(17,2) -- 首期税金
    ,broker_amt number(17,2) -- 首期佣金
    ,interest number(17,2) -- 应计利息
    ,portfolio_id number(5,0) -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,cptys_short_name varchar2(384) -- 交易对手名
    ,cptys_id number -- 交易对手ID
    ,settle_type varchar2(2) -- 首期结算方式
    ,settle_type2 varchar2(2) -- 到期结算方式
    ,dealer number(5,0) -- 交易员ID
    ,ref_number varchar2(48) -- 成交编号
    ,cfets_from varchar2(2) -- 是否是CFETS交易
    ,lastmodified timestamp -- 最后修改时间
    ,datasymbol_id number(38,0) -- 数据源ID
    ,trade_rate number(17,8) -- 借贷费率
    ,lend_days number -- 借贷天数
    ,wtrade_lend_id_grand number(38,0) -- 原始交易ID
    ,lastmodified_pay timestamp -- 实收付确认的修改时间
    ,day_count varchar2(2) -- 日计息基准
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend is '实际收付确认-债券借贷';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.deal_tablename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.bondscode is '质押券代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.lendbondscode is '标的券代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.serial_number is '交易号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.trade_date is '首期交易日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.value_date is '首期交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.maturity_date is '到期交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.buyorsell is '交易方向';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.face_amount is '质押券面额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.trade_time is '交易时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.amount is '首期结算金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.maturity_amount is '到期结算金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.fee is '首期费用';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.tax_amt is '首期税金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.broker_amt is '首期佣金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.interest is '应计利息';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.cptys_short_name is '交易对手名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.cptys_id is '交易对手ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.settle_type is '首期结算方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.settle_type2 is '到期结算方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.dealer is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.ref_number is '成交编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.cfets_from is '是否是CFETS交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.datasymbol_id is '数据源ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.trade_rate is '借贷费率';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.lend_days is '借贷天数';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.wtrade_lend_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.day_count is '日计息基准';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.dealer_name is '交易员名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend.etl_timestamp is 'ETL处理时间戳';
