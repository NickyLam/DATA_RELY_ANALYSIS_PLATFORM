/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ctms_tbs_v_bondsdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ctms_tbs_v_bondsdeals
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ctms_tbs_v_bondsdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ctms_tbs_v_bondsdeals(
    etl_dt date -- 数据日期
    ,deal_id number -- 引用表ID
    ,deal_tablename varchar2(10) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,bondscode varchar2(30) -- 债券代码
    ,bondsname varchar2(50) -- 债券名称
    ,bondstype varchar2(20) -- 债券类型
    ,serial_number varchar2(15) -- 交易号
    ,tradedate number -- 交易日
    ,settledate number(8) -- 交割日
    ,buyorsell varchar2(1) -- 买卖方向
    ,cleanprice number -- 交易净价
    ,dirtyprice number -- 交易全价
    ,yieldtomaturity number -- 到期收益率
    ,settleamount number -- 结算金额
    ,portfolio_id number -- 交易组别
    ,portfolio_name varchar2(80) -- 交易组别名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(50) -- 账户名称
    ,folderatts varchar2(8) -- 账户属性
    ,classfyname varchar2(20) -- 四分类名称
    ,cptys_shortname varchar2(128) -- 交易对手名称
    ,cptys_id number -- 交易对手ID
    ,settletype varchar2(10) -- 结算方式
    ,dealer_id number(4) -- 交易员
    ,dealer_name varchar2(20) -- 交易员名称
    ,ref_number varchar2(32) -- 成交编号
    ,feeamount number -- 手续费
    ,taxamount number -- 税金
    ,brokeramount number -- 佣金
    ,note varchar2(4000) -- 备注
    ,nominal number -- 券面总额
    ,accruedamount number -- 应计利息总额
    ,cfets_from varchar2(1) -- 是否是CFETS交易
    ,source varchar2(1) -- 交易来源
    ,lastmodified timestamp(6) -- 最后修改时间
    ,datasymbol_id number -- 数据源ID
    ,assettype_id number -- 资产类型ID
    ,bondsdeals_id_grand number -- 原始交易ID
    ,stock_id varchar2(10) -- 股票代码
    ,convert_price number(10,4) -- 转股价格
    ,stock_price number(10,4) -- 正股价格
    ,convert_quantity number(27,12) -- 转股数量
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
grant select on ${idl_schema}.icrm_ctms_tbs_v_bondsdeals to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ctms_tbs_v_bondsdeals is '现券交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.deal_id is '引用表ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.deal_tablename is '引用表名';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.aspclient_id is '部门编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.bondscode is '债券代码';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.bondsname is '债券名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.bondstype is '债券类型';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.serial_number is '交易号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.tradedate is '交易日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.settledate is '交割日';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.buyorsell is '买卖方向';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.cleanprice is '交易净价';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.dirtyprice is '交易全价';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.yieldtomaturity is '到期收益率';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.settleamount is '结算金额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.portfolio_id is '交易组别';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.portfolio_name is '交易组别名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.keepfolder_id is '账户ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.keepfolder_shortname is '账户名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.folderatts is '账户属性';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.classfyname is '四分类名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.cptys_shortname is '交易对手名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.cptys_id is '交易对手ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.settletype is '结算方式';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.dealer_id is '交易员';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.dealer_name is '交易员名称';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.ref_number is '成交编号';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.feeamount is '手续费';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.taxamount is '税金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.brokeramount is '佣金';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.note is '备注';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.nominal is '券面总额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.accruedamount is '应计利息总额';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.cfets_from is '是否是CFETS交易';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.source is '交易来源';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.lastmodified is '最后修改时间';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.datasymbol_id is '数据源ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.assettype_id is '资产类型ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.bondsdeals_id_grand is '原始交易ID';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.stock_id is '股票代码';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.convert_price is '转股价格';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.stock_price is '正股价格';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.convert_quantity is '转股数量';
comment on column ${idl_schema}.icrm_ctms_tbs_v_bondsdeals.etl_timestamp is '数据处理时间';
