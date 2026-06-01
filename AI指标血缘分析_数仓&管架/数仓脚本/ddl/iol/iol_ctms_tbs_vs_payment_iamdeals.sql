/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_iamdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_iamdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_iamdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_iamdeals(
    deal_id number -- 引用表ID
    ,deal_tablename varchar2(12) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,serial_number varchar2(23) -- 交易号(标识数据表中记录的唯一组合)
    ,trade_date number(8,0) -- 首期交易日
    ,value_date number(8,0) -- 首期交割日
    ,maturity_date number(8,0) -- 到期交割日
    ,buyorsell varchar2(2) -- 交易方向
    ,repo_rate number -- 拆借利率
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
    ,cptys_short_name varchar2(192) -- 交易对手名
    ,cptys_id number -- 交易对手ID
    ,dealer_id number(5,0) -- 交易员ID
    ,dealer_name varchar2(30) -- 交易员姓名
    ,ref_number varchar2(48) -- 成交编号
    ,cfets_from varchar2(2) -- 是否是CFETS交易
    ,lastmodified timestamp -- 最后修改时间
    ,datasymbol_id number -- 数据源ID
    ,repo_days number -- 拆借天数
    ,iamdeals_id_grand number -- 原始交易ID
    ,note varchar2(4000) -- 备注
    ,lastmodified_pay timestamp -- 实收付确认的修改时间
    ,counterparty_type varchar2(15) -- 交易类别
    ,repo_id varchar2(24) -- 交易品种
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_iamdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_iamdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_iamdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_iamdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_iamdeals is '实际收付确认-拆借交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.deal_tablename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.serial_number is '交易号(标识数据表中记录的唯一组合)';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.trade_date is '首期交易日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.value_date is '首期交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.maturity_date is '到期交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.buyorsell is '交易方向';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.repo_rate is '拆借利率';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.amount is '首期结算金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.maturity_amount is '到期结算金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.fee is '首期费用';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.tax_amt is '首期税金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.broker_amt is '首期佣金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.interest is '应计利息';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.cptys_short_name is '交易对手名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.cptys_id is '交易对手ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.dealer_id is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.dealer_name is '交易员姓名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.ref_number is '成交编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.cfets_from is '是否是CFETS交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.datasymbol_id is '数据源ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.repo_days is '拆借天数';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.iamdeals_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.note is '备注';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.counterparty_type is '交易类别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.repo_id is '交易品种';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_iamdeals.etl_timestamp is 'ETL处理时间戳';
