/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ctms_tbs_v_openrepodeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ctms_tbs_v_openrepodeals
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ctms_tbs_v_openrepodeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ctms_tbs_v_openrepodeals(
    etl_dt date -- 数据日期
    ,deal_id number -- 引用表ID
    ,deal_tablename varchar2(13) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,serial_number varchar2(15) -- 交易序号
    ,portfolio_id number(5) -- 投组编号
    ,portfolio_name varchar2(80) -- 投组名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(50) -- 账号名称
    ,currency varchar2(3) -- 币种
    ,buyorsell varchar2(1) -- 交易方向
    ,amount number(17,2) -- 首期金额
    ,trade_rate number -- 回购利率
    ,ref_number varchar2(32) -- 成交编号
    ,trade_date number(8) -- 交易日期
    ,value_date number(8) -- 首期交割日
    ,maturity_date number(8) -- 到期交割日
    ,bondscode varchar2(30) -- 债券代码
    ,bondsname varchar2(50) -- 债券名称
    ,face_amount number(17,2) -- 券面总额
    ,first_price number(17,9) -- 首期净价
    ,maturity_price number(17,9) -- 到期净价
    ,maturity_amount number(17,2) -- 到期金额
    ,interest number(17,2) -- 应计利息
    ,cpty_id number -- 交易对手ID
    ,cpty_name varchar2(128) -- 交易对手名称
    ,dealer_id number(5) -- 交易员ID
    ,dealer_name varchar2(20) -- 交易员名称
    ,fee1 number(17,2) -- 首期费用
    ,tax_amt1 number(17,2) -- 首期税金
    ,broker_amt1 number(17,2) -- 首期佣金
    ,fee2 number(17,2) -- 到期费用
    ,tax_amt2 number(17,2) -- 到期税金
    ,broker_amt2 number(17,2) -- 到期佣金
    ,tradingfee number -- 交易费
    ,settle_type varchar2(1) -- 首期交割方式
    ,settle_type2 varchar2(1) -- 到期交割方式
    ,source varchar2(1) -- 交易来源
    ,cfets_from varchar2(1) -- 是否是CFETS交易
    ,spot_v number -- 近端连结面额
    ,fwd_v number -- 远端连结面额
    ,cstp_req varchar2(1) -- 是否需要连结原始交易
    ,keep_type varchar2(1) -- 核算方法
    ,note varchar2(4000) -- 备注
    ,datasymbol_id number -- 数据源ID
    ,lastmodified timestamp(6) -- 最后修改时间
    ,openrepodeals_id_grand number -- 原始交易ID
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_ctms_tbs_v_openrepodeals to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ctms_tbs_v_openrepodeals is '开放式回购交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.deal_id is '引用表ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.deal_tablename is '引用表名';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.aspclient_id is '部门编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.serial_number is '交易序号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.portfolio_id is '投组编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.portfolio_name is '投组名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.keepfolder_id is '账户ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.keepfolder_shortname is '账号名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.currency is '币种';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.buyorsell is '交易方向';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.amount is '首期金额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.trade_rate is '回购利率';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.ref_number is '成交编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.trade_date is '交易日期';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.value_date is '首期交割日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.maturity_date is '到期交割日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.bondscode is '债券代码';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.bondsname is '债券名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.face_amount is '券面总额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.first_price is '首期净价';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.maturity_price is '到期净价';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.maturity_amount is '到期金额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.interest is '应计利息';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.cpty_id is '交易对手ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.cpty_name is '交易对手名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.dealer_id is '交易员ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.dealer_name is '交易员名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.fee1 is '首期费用';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.tax_amt1 is '首期税金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.broker_amt1 is '首期佣金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.fee2 is '到期费用';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.tax_amt2 is '到期税金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.broker_amt2 is '到期佣金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.tradingfee is '交易费';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.settle_type is '首期交割方式';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.settle_type2 is '到期交割方式';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.source is '交易来源';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.cfets_from is '是否是CFETS交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.spot_v is '近端连结面额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.fwd_v is '远端连结面额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.cstp_req is '是否需要连结原始交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.keep_type is '核算方法';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.note is '备注';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.datasymbol_id is '数据源ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.lastmodified is '最后修改时间';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.openrepodeals_id_grand is '原始交易ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_openrepodeals.etl_timestamp is '数据处理时间';
