/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cmfbalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cmfbalancesheet
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cmfbalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cmfbalancesheet(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,sec_id varchar2(15) -- 证券ID
    ,report_period varchar2(12) -- 报告期
    ,ann_dt varchar2(12) -- 公告日期
    ,is_list number(5,0) -- 是否上市后数据
    ,f_stm_bs number(20,4) -- 银行存款
    ,settle_rsrv number(20,4) -- 清算备付金
    ,mrgn_paid number(20,4) -- 交易保证金
    ,tradable_fin_assets number(20,4) -- 交易性金融资产
    ,stock_value number(20,4) -- 股票投资市值
    ,stock_cost number(20,4) -- 股票投资成本
    ,stock_add_value number(20,4) -- 股票投资估值增值
    ,fund_value number(20,4) -- 基金投资市值(基金投资)
    ,bond_value number(20,4) -- 债券投资市值
    ,abs_value number(20,4) -- 资产支持证券投资市值
    ,bond_cost number(20,4) -- 债券投资成本
    ,bond_add_value number(20,4) -- 债券投资估值增值
    ,govbond_cost number(20,4) -- 国债投资成本
    ,govbond_add_value number(15,2) -- 国债投资估值增值
    ,convertbond_cost number(20,4) -- 可转债投资成本
    ,convertbond_add_value number(20,4) -- 可转债投资估值增值
    ,derivative_fin_value number(20,4) -- 权证投资市值
    ,derivative_fin_cost number(20,4) -- 权证投资成本
    ,trade_rcv number(20,4) -- 应收证券交易清算款
    ,war_rcv number(20,4) -- 配股权证
    ,int_rcv number(20,4) -- 应收利息
    ,acct_rcv number(20,4) -- 应收帐款
    ,dvd_rcv number(20,4) -- 应收股利
    ,pur_rcv number(20,4) -- 应收申购款
    ,deferred_tax_assets number(20,4) -- 递延所得税资产
    ,oth_rcv number(20,4) -- 其他应收款项
    ,deferred_exp number(20,4) -- 待摊费用
    ,repo_rev number(20,4) -- 买入返售证券
    ,oth_assets number(20,4) -- 其他资产
    ,tot_assets number(20,4) -- 资产总计
    ,st_borrow number(20,4) -- 短期借款
    ,manage_payable number(20,4) -- 应付基金管理费
    ,trustee_payable number(20,4) -- 应付基金托管费
    ,sec_trade_payable number(20,4) -- 应付交易清算款
    ,acct_payable number(20,4) -- 应付帐款
    ,trade_payable number(20,4) -- 应付佣金
    ,oth_payable number(20,4) -- 其他应付款项
    ,right_payable number(20,4) -- 应付配股款
    ,rede_payable number(20,4) -- 应付赎回费
    ,rede_payable2 number(20,4) -- 应付赎回款
    ,repo_amount number(20,4) -- 卖出回购证券
    ,int_payable number(20,4) -- 应付利息
    ,rev_payable number(20,4) -- 应付收益
    ,notpaytax number(20,4) -- 未交税金
    ,acc_exp number(20,4) -- 预提费用
    ,deferred_tax_liab number(20,4) -- 递延所得税负债
    ,oth_liab number(20,4) -- 其他负债
    ,sell_exp number(20,4) -- 应付销售费用
    ,tradable_fin_liab number(20,4) -- 交易性金融负债
    ,derivative_fin_liab number(20,4) -- 衍生金融负债
    ,tot_liab number(20,4) -- 负债总额
    ,paidincapital number(20,4) -- 实收基金
    ,undistributed_et_inc number(20,4) -- 未分配收益
    ,unrealized_profit number(20,4) -- 未实现利得
    ,undistributed_profit number(20,4) -- 未分配利润
    ,unrealized_add_value number(20,4) -- 未实现估值增值
    ,holder_equity number(20,4) -- 持有人权益合计
    ,prt_netasset number(20,4) -- 基金资产净值
    ,tot_liab_shrhldr_eqy number(20,4) -- 负债及持有人权益合计
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_cmfbalancesheet to ${iml_schema};
grant select on ${iol_schema}.wind_cmfbalancesheet to ${icl_schema};
grant select on ${iol_schema}.wind_cmfbalancesheet to ${idl_schema};
grant select on ${iol_schema}.wind_cmfbalancesheet to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cmfbalancesheet is '中国共同基金资产负债表';
comment on column ${iol_schema}.wind_cmfbalancesheet.object_id is '对象ID';
comment on column ${iol_schema}.wind_cmfbalancesheet.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cmfbalancesheet.sec_id is '证券ID';
comment on column ${iol_schema}.wind_cmfbalancesheet.report_period is '报告期';
comment on column ${iol_schema}.wind_cmfbalancesheet.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_cmfbalancesheet.is_list is '是否上市后数据';
comment on column ${iol_schema}.wind_cmfbalancesheet.f_stm_bs is '银行存款';
comment on column ${iol_schema}.wind_cmfbalancesheet.settle_rsrv is '清算备付金';
comment on column ${iol_schema}.wind_cmfbalancesheet.mrgn_paid is '交易保证金';
comment on column ${iol_schema}.wind_cmfbalancesheet.tradable_fin_assets is '交易性金融资产';
comment on column ${iol_schema}.wind_cmfbalancesheet.stock_value is '股票投资市值';
comment on column ${iol_schema}.wind_cmfbalancesheet.stock_cost is '股票投资成本';
comment on column ${iol_schema}.wind_cmfbalancesheet.stock_add_value is '股票投资估值增值';
comment on column ${iol_schema}.wind_cmfbalancesheet.fund_value is '基金投资市值(基金投资)';
comment on column ${iol_schema}.wind_cmfbalancesheet.bond_value is '债券投资市值';
comment on column ${iol_schema}.wind_cmfbalancesheet.abs_value is '资产支持证券投资市值';
comment on column ${iol_schema}.wind_cmfbalancesheet.bond_cost is '债券投资成本';
comment on column ${iol_schema}.wind_cmfbalancesheet.bond_add_value is '债券投资估值增值';
comment on column ${iol_schema}.wind_cmfbalancesheet.govbond_cost is '国债投资成本';
comment on column ${iol_schema}.wind_cmfbalancesheet.govbond_add_value is '国债投资估值增值';
comment on column ${iol_schema}.wind_cmfbalancesheet.convertbond_cost is '可转债投资成本';
comment on column ${iol_schema}.wind_cmfbalancesheet.convertbond_add_value is '可转债投资估值增值';
comment on column ${iol_schema}.wind_cmfbalancesheet.derivative_fin_value is '权证投资市值';
comment on column ${iol_schema}.wind_cmfbalancesheet.derivative_fin_cost is '权证投资成本';
comment on column ${iol_schema}.wind_cmfbalancesheet.trade_rcv is '应收证券交易清算款';
comment on column ${iol_schema}.wind_cmfbalancesheet.war_rcv is '配股权证';
comment on column ${iol_schema}.wind_cmfbalancesheet.int_rcv is '应收利息';
comment on column ${iol_schema}.wind_cmfbalancesheet.acct_rcv is '应收帐款';
comment on column ${iol_schema}.wind_cmfbalancesheet.dvd_rcv is '应收股利';
comment on column ${iol_schema}.wind_cmfbalancesheet.pur_rcv is '应收申购款';
comment on column ${iol_schema}.wind_cmfbalancesheet.deferred_tax_assets is '递延所得税资产';
comment on column ${iol_schema}.wind_cmfbalancesheet.oth_rcv is '其他应收款项';
comment on column ${iol_schema}.wind_cmfbalancesheet.deferred_exp is '待摊费用';
comment on column ${iol_schema}.wind_cmfbalancesheet.repo_rev is '买入返售证券';
comment on column ${iol_schema}.wind_cmfbalancesheet.oth_assets is '其他资产';
comment on column ${iol_schema}.wind_cmfbalancesheet.tot_assets is '资产总计';
comment on column ${iol_schema}.wind_cmfbalancesheet.st_borrow is '短期借款';
comment on column ${iol_schema}.wind_cmfbalancesheet.manage_payable is '应付基金管理费';
comment on column ${iol_schema}.wind_cmfbalancesheet.trustee_payable is '应付基金托管费';
comment on column ${iol_schema}.wind_cmfbalancesheet.sec_trade_payable is '应付交易清算款';
comment on column ${iol_schema}.wind_cmfbalancesheet.acct_payable is '应付帐款';
comment on column ${iol_schema}.wind_cmfbalancesheet.trade_payable is '应付佣金';
comment on column ${iol_schema}.wind_cmfbalancesheet.oth_payable is '其他应付款项';
comment on column ${iol_schema}.wind_cmfbalancesheet.right_payable is '应付配股款';
comment on column ${iol_schema}.wind_cmfbalancesheet.rede_payable is '应付赎回费';
comment on column ${iol_schema}.wind_cmfbalancesheet.rede_payable2 is '应付赎回款';
comment on column ${iol_schema}.wind_cmfbalancesheet.repo_amount is '卖出回购证券';
comment on column ${iol_schema}.wind_cmfbalancesheet.int_payable is '应付利息';
comment on column ${iol_schema}.wind_cmfbalancesheet.rev_payable is '应付收益';
comment on column ${iol_schema}.wind_cmfbalancesheet.notpaytax is '未交税金';
comment on column ${iol_schema}.wind_cmfbalancesheet.acc_exp is '预提费用';
comment on column ${iol_schema}.wind_cmfbalancesheet.deferred_tax_liab is '递延所得税负债';
comment on column ${iol_schema}.wind_cmfbalancesheet.oth_liab is '其他负债';
comment on column ${iol_schema}.wind_cmfbalancesheet.sell_exp is '应付销售费用';
comment on column ${iol_schema}.wind_cmfbalancesheet.tradable_fin_liab is '交易性金融负债';
comment on column ${iol_schema}.wind_cmfbalancesheet.derivative_fin_liab is '衍生金融负债';
comment on column ${iol_schema}.wind_cmfbalancesheet.tot_liab is '负债总额';
comment on column ${iol_schema}.wind_cmfbalancesheet.paidincapital is '实收基金';
comment on column ${iol_schema}.wind_cmfbalancesheet.undistributed_et_inc is '未分配收益';
comment on column ${iol_schema}.wind_cmfbalancesheet.unrealized_profit is '未实现利得';
comment on column ${iol_schema}.wind_cmfbalancesheet.undistributed_profit is '未分配利润';
comment on column ${iol_schema}.wind_cmfbalancesheet.unrealized_add_value is '未实现估值增值';
comment on column ${iol_schema}.wind_cmfbalancesheet.holder_equity is '持有人权益合计';
comment on column ${iol_schema}.wind_cmfbalancesheet.prt_netasset is '基金资产净值';
comment on column ${iol_schema}.wind_cmfbalancesheet.tot_liab_shrhldr_eqy is '负债及持有人权益合计';
comment on column ${iol_schema}.wind_cmfbalancesheet.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cmfbalancesheet.etl_timestamp is 'ETL处理时间戳';
