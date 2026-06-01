/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ctms_tbs_v_repodeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ctms_tbs_v_repodeals
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ctms_tbs_v_repodeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ctms_tbs_v_repodeals(
    etl_dt date -- 数据日期
    ,deal_id number -- 引用表ID
    ,deal_tablename varchar2(9) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,bondscode varchar2(16) -- 债券代码
    ,bondsname varchar2(50) -- 债券名称
    ,serial_number varchar2(15) -- 交易号(标识数据表中记录的唯一组合)
    ,trade_date number(8) -- 首期交易日
    ,value_date number(8) -- 首期交割日
    ,maturity_date number(8) -- 到期交割日
    ,buyorsell varchar2(1) -- 交易方向
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
    ,portfolio_id number(5) -- 交易组别
    ,portfolio_name varchar2(80) -- 交易组别名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(50) -- 账户名称
    ,cptys_short_name varchar2(128) -- 交易对手名
    ,cptys_id number -- 交易对手ID
    ,settle_type varchar2(20) -- 首期结算方式
    ,settle_type2 varchar2(20) -- 到期结算方式
    ,dealer_id number(5) -- 交易员ID
    ,dealer_name varchar2(20) -- 交易员姓名
    ,ref_number varchar2(32) -- 成交编号
    ,cfets_from varchar2(1) -- 是否是CFETS交易
    ,lastmodified timestamp(6) -- 最后修改时间
    ,datasymbol_id number -- 数据源ID
    ,repo_days number -- 回购天数
    ,repodeals_id_grand number -- 原始交易ID
    ,repo_id varchar2(16) -- 回购名称
    ,clearing_type varchar2(1) -- 清算类型
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
grant select on ${idl_schema}.icrm_ctms_tbs_v_repodeals to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ctms_tbs_v_repodeals is '买断式回购交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.deal_id is '引用表ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.deal_tablename is '引用表名';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.aspclient_id is '部门编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.bondscode is '债券代码';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.bondsname is '债券名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.serial_number is '交易号(标识数据表中记录的唯一组合)';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.trade_date is '首期交易日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.value_date is '首期交割日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.maturity_date is '到期交割日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.buyorsell is '交易方向';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.face_amount is '券面总额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.first_price is '首次净价';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.maturity_price is '到期净价';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.repo_rate is '回购利率';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.amount is '首期结算金额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.maturity_amount is '到期结算金额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.fee1 is '首期费用';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.tax_amt1 is '首期税金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.broker_amt1 is '首期佣金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.fee2 is '到期费用';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.tax_amt2 is '到期税金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.broker_amt2 is '到期佣金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.interest is '应计利息';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.portfolio_id is '交易组别';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.portfolio_name is '交易组别名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.keepfolder_id is '账户ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.keepfolder_shortname is '账户名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.cptys_short_name is '交易对手名';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.cptys_id is '交易对手ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.settle_type is '首期结算方式';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.settle_type2 is '到期结算方式';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.dealer_id is '交易员ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.dealer_name is '交易员姓名';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.ref_number is '成交编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.cfets_from is '是否是CFETS交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.lastmodified is '最后修改时间';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.datasymbol_id is '数据源ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.repo_days is '回购天数';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.repodeals_id_grand is '原始交易ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.repo_id is '回购名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.clearing_type is '清算类型';
comment on column ${idl_schema}.icrm_ctms_tbs_v_repodeals.etl_timestamp is '数据处理时间';
