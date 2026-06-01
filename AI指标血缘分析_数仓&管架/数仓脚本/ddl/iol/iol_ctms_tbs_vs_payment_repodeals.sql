/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_repodeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_repodeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_repodeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_repodeals(
    deal_id number -- 引用表ID
    ,deal_tablename varchar2(14) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,bondscode varchar2(24) -- 债券代码
    ,bondsname varchar2(75) -- 债券名称
    ,serial_number varchar2(23) -- 交易号(标识数据表中记录的唯一组合)
    ,trade_date number(8,0) -- 首期交易日
    ,value_date number(8,0) -- 首期交割日
    ,maturity_date number(8,0) -- 到期交割日
    ,buyorsell varchar2(2) -- 交易方向
    ,face_amount number(17,2) -- 券面总额
    ,first_price number(17,9) -- 首次净价
    ,maturity_price number(17,9) -- 到期净价
    ,repo_rate number -- 回购利率
    ,amount number(17,2) -- 首期结算金额
    ,maturity_amount number(17,2) -- 到期结算金额
    ,fee1 number(17,2) -- 首期费用
    ,tax_amt1 number(17,2) -- 首期税金
    ,broker_amt1 number(17,2) -- 首期佣金
    ,fee2 number(17,2) -- 到期费用
    ,tax_amt2 number(17,2) -- 到期税金
    ,broker_amt2 number(17,2) -- 到期佣金
    ,interest number(17,2) -- 应计利息
    ,portfolio_id number(5,0) -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,cptys_short_name varchar2(192) -- 交易对手名
    ,cptys_id number -- 交易对手ID
    ,settle_type varchar2(30) -- 首期结算方式
    ,settle_type2 varchar2(30) -- 到期结算方式
    ,dealer_id number(5,0) -- 交易员ID
    ,dealer_name varchar2(30) -- 交易员姓名
    ,ref_number varchar2(48) -- 成交编号
    ,cfets_from varchar2(2) -- 是否是CFETS交易
    ,lastmodified timestamp -- 最后修改时间
    ,datasymbol_id number -- 数据源ID
    ,repo_days number -- 回购天数
    ,repodeals_id_grand number -- 原始交易ID
    ,lastmodified_pay timestamp -- 实收付确认的修改时间
    ,repo_id varchar2(24) -- 回购名称
    ,clearing_type varchar2(2) -- 清算类型
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_repodeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_repodeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_repodeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_repodeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_repodeals is '实际收付确认-买断式回购交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.deal_tablename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.bondscode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.bondsname is '债券名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.serial_number is '交易号(标识数据表中记录的唯一组合)';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.trade_date is '首期交易日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.value_date is '首期交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.maturity_date is '到期交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.buyorsell is '交易方向';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.face_amount is '券面总额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.first_price is '首次净价';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.maturity_price is '到期净价';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.repo_rate is '回购利率';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.amount is '首期结算金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.maturity_amount is '到期结算金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.fee1 is '首期费用';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.tax_amt1 is '首期税金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.broker_amt1 is '首期佣金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.fee2 is '到期费用';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.tax_amt2 is '到期税金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.broker_amt2 is '到期佣金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.interest is '应计利息';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.cptys_short_name is '交易对手名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.cptys_id is '交易对手ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.settle_type is '首期结算方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.settle_type2 is '到期结算方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.dealer_id is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.dealer_name is '交易员姓名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.ref_number is '成交编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.cfets_from is '是否是CFETS交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.datasymbol_id is '数据源ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.repo_days is '回购天数';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.repodeals_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.repo_id is '回购名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.clearing_type is '清算类型';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_repodeals.etl_timestamp is 'ETL处理时间戳';
