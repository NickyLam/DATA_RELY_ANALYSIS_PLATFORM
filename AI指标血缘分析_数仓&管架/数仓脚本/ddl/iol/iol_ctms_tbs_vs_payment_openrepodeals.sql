/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_openrepodeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_openrepodeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_openrepodeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_openrepodeals(
    deal_id number -- 引用表ID
    ,deal_tablename varchar2(20) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,serial_number varchar2(23) -- 交易序号
    ,portfolio_id number(5,0) -- 投组编号
    ,portfolio_name varchar2(120) -- 投组名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账号名称
    ,currency varchar2(5) -- 币种
    ,buyorsell varchar2(2) -- 交易方向
    ,amount number(17,2) -- 首期金额
    ,trade_date number(8,0) -- 交易日期
    ,value_date number(8,0) -- 首期交割日
    ,maturity_date number(8,0) -- 到期交割日
    ,bondscode varchar2(45) -- 债券代码
    ,bondsname varchar2(75) -- 债券名称
    ,face_amount number(17,2) -- 券面总额
    ,first_price number(17,9) -- 首期净价
    ,maturity_price number(17,9) -- 到期净价
    ,maturity_amount number(17,2) -- 到期金额
    ,interest number(17,2) -- 应计利息
    ,cpty_id number -- 交易对手ID
    ,cpty_name varchar2(192) -- 交易对手名称
    ,dealer_id number(5,0) -- 交易员ID
    ,dealer_name varchar2(30) -- 交易员名称
    ,fee1 number(17,2) -- 首期费用
    ,tax_amt1 number(17,2) -- 首期税金
    ,broker_amt1 number(17,2) -- 首期佣金
    ,fee2 number(17,2) -- 到期费用
    ,tax_amt2 number(17,2) -- 到期税金
    ,broker_amt2 number(17,2) -- 到期佣金
    ,tradingfee number -- 交易费
    ,settle_type varchar2(2) -- 首期交割方式
    ,settle_type2 varchar2(2) -- 到期交割方式
    ,source varchar2(2) -- 交易来源
    ,cfets_from varchar2(2) -- 是否是CFETS交易
    ,spot_v number -- 近端连结面额
    ,fwd_v number -- 远端连结面额
    ,cstp_req varchar2(2) -- 是否需要连结原始交易
    ,keep_type varchar2(2) -- 核算方法
    ,note varchar2(4000) -- 备注
    ,datasymbol_id number -- 数据源ID
    ,lastmodified timestamp -- 最后修改时间
    ,openrepodeals_id_grand number -- 原始交易ID
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_openrepodeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_openrepodeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_openrepodeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_openrepodeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_openrepodeals is '实际收付确认-开放式回购交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.deal_tablename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.serial_number is '交易序号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.portfolio_id is '投组编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.portfolio_name is '投组名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.keepfolder_shortname is '账号名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.currency is '币种';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.buyorsell is '交易方向';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.amount is '首期金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.trade_date is '交易日期';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.value_date is '首期交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.maturity_date is '到期交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.bondscode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.bondsname is '债券名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.face_amount is '券面总额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.first_price is '首期净价';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.maturity_price is '到期净价';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.maturity_amount is '到期金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.interest is '应计利息';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.cpty_id is '交易对手ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.cpty_name is '交易对手名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.dealer_id is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.dealer_name is '交易员名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.fee1 is '首期费用';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.tax_amt1 is '首期税金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.broker_amt1 is '首期佣金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.fee2 is '到期费用';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.tax_amt2 is '到期税金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.broker_amt2 is '到期佣金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.tradingfee is '交易费';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.settle_type is '首期交割方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.settle_type2 is '到期交割方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.source is '交易来源';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.cfets_from is '是否是CFETS交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.spot_v is '近端连结面额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.fwd_v is '远端连结面额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.cstp_req is '是否需要连结原始交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.keep_type is '核算方法';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.note is '备注';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.datasymbol_id is '数据源ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.openrepodeals_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_openrepodeals.etl_timestamp is 'ETL处理时间戳';
