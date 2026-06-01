/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_payment_bondsdeals_uw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw(
    deal_id number -- 引用表ID
    ,deal_tablename varchar2(15) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,bondscode varchar2(45) -- 债券代码
    ,bondsname varchar2(75) -- 债券名称
    ,bondstype varchar2(30) -- 债券类型
    ,serial_number varchar2(23) -- 交易号
    ,tradedate number -- 交易日
    ,settledate number(8,0) -- 交割日
    ,buyorsell varchar2(2) -- 买卖方向
    ,cleanprice number -- 交易净价
    ,dirtyprice number -- 交易全价
    ,yieldtomaturity number -- 到期收益率
    ,settleamount number -- 结算金额
    ,portfolio_id number -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,folderatts varchar2(12) -- 账户属性
    ,classfyname varchar2(30) -- 四分类名称
    ,cptys_shortname varchar2(192) -- 交易对手名称
    ,cptys_id number -- 交易对手ID
    ,settletype varchar2(15) -- 结算方式
    ,dealer_id number(4,0) -- 交易员
    ,dealer_name varchar2(30) -- 交易员名称
    ,ref_number varchar2(48) -- 成交编号
    ,feeamount number -- 手续费
    ,taxamount number -- 税金
    ,brokeramount number -- 佣金
    ,note varchar2(4000) -- 备注
    ,nominal number -- 券面总额
    ,accruedamount number -- 应计利息总额
    ,cfets_from varchar2(2) -- 是否是CFETS交易
    ,source varchar2(2) -- 交易来源
    ,lastmodified timestamp -- 最后修改时间
    ,datasymbol_id number -- 数据源ID
    ,assettype_id number -- 资产类型ID
    ,bondsdeals_id_grand number -- 原始交易ID
    ,lastmodified_pay timestamp -- 实收付确认的修改时间
    ,stock_id varchar2(15) -- 股票代码
    ,convert_price number(10,4) -- 转股价格
    ,stock_price number(10,4) -- 正股价格
    ,convert_quantity number(27,12) -- 转股数量
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
grant select on ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw is '实际收付确认-现券交易-承分销';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.deal_tablename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.bondscode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.bondsname is '债券名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.bondstype is '债券类型';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.serial_number is '交易号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.tradedate is '交易日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.settledate is '交割日';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.buyorsell is '买卖方向';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.cleanprice is '交易净价';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.dirtyprice is '交易全价';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.yieldtomaturity is '到期收益率';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.settleamount is '结算金额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.folderatts is '账户属性';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.classfyname is '四分类名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.cptys_shortname is '交易对手名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.cptys_id is '交易对手ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.settletype is '结算方式';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.dealer_id is '交易员';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.dealer_name is '交易员名称';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.ref_number is '成交编号';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.feeamount is '手续费';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.taxamount is '税金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.brokeramount is '佣金';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.note is '备注';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.nominal is '券面总额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.accruedamount is '应计利息总额';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.cfets_from is '是否是CFETS交易';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.source is '交易来源';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.datasymbol_id is '数据源ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.assettype_id is '资产类型ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.bondsdeals_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.lastmodified_pay is '实收付确认的修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.stock_id is '股票代码';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.convert_price is '转股价格';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.stock_price is '正股价格';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.convert_quantity is '转股数量';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_payment_bondsdeals_uw.etl_timestamp is 'ETL处理时间戳';
