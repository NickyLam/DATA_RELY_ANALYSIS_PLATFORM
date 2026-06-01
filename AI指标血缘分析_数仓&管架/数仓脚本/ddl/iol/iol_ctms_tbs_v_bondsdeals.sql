/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_bondsdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_bondsdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_bondsdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_bondsdeals(
    deal_id number(22,0) -- 引用表id
    ,deal_tablename varchar2(15) -- 引用表名
    ,aspclient_id number(22,0) -- 部门编号
    ,bondscode varchar2(45) -- 债券代码
    ,bondsname varchar2(75) -- 债券名称
    ,bondstype varchar2(30) -- 债券类型
    ,serial_number varchar2(23) -- 交易号
    ,tradedate number(22,0) -- 交易日
    ,settledate number(8,0) -- 交割日
    ,buyorsell varchar2(2) -- 买卖方向
    ,cleanprice number(38,12) -- 交易净价
    ,dirtyprice number(38,12) -- 交易全价
    ,yieldtomaturity number(38,12) -- 到期收益率
    ,settleamount number(30,2) -- 结算金额
    ,portfolio_id number(22,0) -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,keepfolder_id number(22,0) -- 账户id
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,folderatts varchar2(12) -- 账户属性
    ,classfyname varchar2(30) -- 四分类名称
    ,cptys_shortname varchar2(192) -- 交易对手名称
    ,cptys_id number(22,0) -- 交易对手id
    ,settletype varchar2(15) -- 结算方式
    ,dealer_id number(4,0) -- 交易员
    ,dealer_name varchar2(30) -- 交易员名称
    ,ref_number varchar2(48) -- 成交编号
    ,feeamount number(30,2) -- 手续费
    ,taxamount number(30,2) -- 税金
    ,brokeramount number(30,2) -- 佣金
    ,note varchar2(4000) -- 备注
    ,nominal number(30,2) -- 券面总额
    ,accruedamount number(30,2) -- 应计利息总额
    ,cfets_from varchar2(2) -- 是否是cfets交易
    ,source varchar2(2) -- 交易来源
    ,lastmodified timestamp -- 最后修改时间
    ,datasymbol_id number(22,0) -- 数据源id
    ,assettype_id number(22,0) -- 资产类型id
    ,bondsdeals_id_grand number(22,0) -- 原始交易id
    ,stock_id varchar2(15) -- 股票代码
    ,convert_price number(10,4) -- 转股价格
    ,stock_price number(10,4) -- 正股价格
    ,convert_quantity number(27,12) -- 转股数量
    ,dn_dealer varchar2(900) -- 本币交易员
    ,currency varchar2(5) -- 币种
    ,tradetime varchar2(60) -- 交易时间
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
grant select on ${iol_schema}.ctms_tbs_v_bondsdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_bondsdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_bondsdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_bondsdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_bondsdeals is '现券交易';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.deal_id is '引用表id';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.deal_tablename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.bondscode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.bondsname is '债券名称';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.bondstype is '债券类型';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.serial_number is '交易号';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.tradedate is '交易日';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.settledate is '交割日';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.buyorsell is '买卖方向';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.cleanprice is '交易净价';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.dirtyprice is '交易全价';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.yieldtomaturity is '到期收益率';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.settleamount is '结算金额';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.keepfolder_id is '账户id';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.folderatts is '账户属性';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.classfyname is '四分类名称';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.cptys_shortname is '交易对手名称';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.cptys_id is '交易对手id';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.settletype is '结算方式';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.dealer_id is '交易员';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.dealer_name is '交易员名称';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.ref_number is '成交编号';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.feeamount is '手续费';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.taxamount is '税金';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.brokeramount is '佣金';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.note is '备注';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.nominal is '券面总额';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.accruedamount is '应计利息总额';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.cfets_from is '是否是cfets交易';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.source is '交易来源';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.datasymbol_id is '数据源id';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.assettype_id is '资产类型id';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.bondsdeals_id_grand is '原始交易id';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.stock_id is '股票代码';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.convert_price is '转股价格';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.stock_price is '正股价格';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.convert_quantity is '转股数量';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.currency is '币种';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.tradetime is '交易时间';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_bondsdeals.etl_timestamp is 'ETL处理时间戳';
