/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_trd_fin_product_deal_total
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_trd_fin_product_deal_total
whenever sqlerror continue none;
drop table ${iol_schema}.fams_trd_fin_product_deal_total purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_trd_fin_product_deal_total(
    totle_trade_id varchar2(32) -- 汇总交易编号
    ,busi_type varchar2(50) -- 业务类型
    ,finprod_id varchar2(50) -- 金融产品代码
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,branch number(10) -- 分支序号
    ,trade_date date -- 交易日期
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,settle_date date -- 交割日期
    ,ccy varchar2(50) -- 交易币种
    ,unit_cprice number(30,14) -- 单位净价
    ,unit_int number(30,14) -- 单位利息
    ,unit_fprice number(30,14) -- 单位全价
    ,par_value number(30,14) -- 单位面值，债券100或者当前面值，其他资产1
    ,cprice_amt number(30,2) -- 净价总额
    ,share_amt number(30,2) -- 交易份额
    ,prin_amt number(30,2) -- 交易本金
    ,int_amt number(30,2) -- 利息总额
    ,fprice_amt number(30,2) -- 全价总额
    ,fee_amt_pay number(30,2) -- 随交易支付费用
    ,trade_amt number(30,2) -- 交易金额
    ,fee_amt_unpay number(30,2) -- 未随交易支付费用
    ,fee_amt number(30,2) -- 总交易费用
    ,ps varchar2(50) -- 交易方向
    ,yield number(30,14) -- 到期收益率
    ,exer_yield number(30,14) -- 行权收益率
    ,inv_aim varchar2(50) -- 投资目的
    ,trade_status varchar2(50) -- 交易状态，初始、修改、撤销
    ,p_trade_id varchar2(32) -- 原交易编号
    ,is_cancel varchar2(50) -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
    ,is_clean varchar2(50) -- 是否结清，收息付费时用
    ,cash_id varchar2(32) -- 现金流代码，金融产品代码+金融产品类型+现金流二级类型，还本、付息、付费等时存对应计划的现金流代码
    ,sec_manage_acct_id varchar2(32) -- 证券管理户代码
    ,b_trade_id varchar2(32) -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
    ,chl_id varchar2(32) -- 渠道/通道代码
    ,counter_id varchar2(32) -- 交易对手
    ,is_out_trade varchar2(50) -- 是否外部交易，是、否
    ,trade_market varchar2(50) -- 交易场所，银行间、上交所、深交所、柜面等
    ,trade_plat varchar2(50) -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
    ,trade_market_mode varchar2(50) -- 交易市场，一级市场、二级市场
    ,trader varchar2(32) -- 交易员
    ,counter_trader varchar2(200) -- 对手方交易员
    ,counter_contact varchar2(1000) -- 对手方联系方式
    ,f_trade_id varchar2(32) -- 关联系统交易编号
    ,portfolio_id varchar2(32) -- 投资组合代码
    ,prod_id varchar2(32) -- 理财产品代码
    ,p_totle_trade_id varchar2(32) -- 上级汇总交易编号
    ,remark varchar2(4000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,current_sub number(30,2) -- 本期认购
    ,last_amt number(30,2) -- 上期余额
    ,last_red number(30,2) -- 上期赎回
    ,last_amt_sub number(30,2) -- 上期滚入余额
    ,accounting_amt number(30,2) -- 到账资金
    ,red_profit number(30,2) -- 赎回收益
    ,red_cost number(30,2) -- 赎回成本
    ,dqprin_amt number(30,2) -- 到期本金
    ,pay_date date -- 交付日
    ,remain_prin number(30,2) -- 剩余名义本金
    ,tg_busi_type varchar2(50) -- 投管业务类型
    ,is_overdue_deal varchar2(50) -- 是否逾期交易
    ,clear_type varchar2(50) -- 清算类型
    ,eff_time timestamp -- 有效时间
    ,delivery_type varchar2(50) -- 首期结算方式
    ,m_delivery_type varchar2(50) -- 到期结算方式
    ,rate number(30,14) -- 利率
    ,repo_term number(10) -- 期限(天)
    ,term_type varchar2(50) -- 期限品种
    ,settle_speed number(10) -- 清算速度
    ,pay_unpaidint_amt number(30,14) -- 支付未支付利息
    ,ispay_unpaidint varchar2(50) -- 是否转让还本未支付利息
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
grant select on ${iol_schema}.fams_trd_fin_product_deal_total to ${iml_schema};
grant select on ${iol_schema}.fams_trd_fin_product_deal_total to ${icl_schema};
grant select on ${iol_schema}.fams_trd_fin_product_deal_total to ${idl_schema};
grant select on ${iol_schema}.fams_trd_fin_product_deal_total to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_trd_fin_product_deal_total is '金融产品交易汇总表';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.totle_trade_id is '汇总交易编号';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.busi_type is '业务类型';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.finprod_type is '金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.finprod_type2 is '金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.branch is '分支序号';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.trade_date is '交易日期';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.vdate is '起息日';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.mdate is '到期日';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.settle_date is '交割日期';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.ccy is '交易币种';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.unit_cprice is '单位净价';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.unit_int is '单位利息';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.unit_fprice is '单位全价';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.par_value is '单位面值，债券100或者当前面值，其他资产1';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.cprice_amt is '净价总额';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.share_amt is '交易份额';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.prin_amt is '交易本金';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.int_amt is '利息总额';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.fprice_amt is '全价总额';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.fee_amt_pay is '随交易支付费用';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.trade_amt is '交易金额';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.fee_amt_unpay is '未随交易支付费用';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.fee_amt is '总交易费用';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.ps is '交易方向';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.yield is '到期收益率';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.exer_yield is '行权收益率';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.inv_aim is '投资目的';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.trade_status is '交易状态，初始、修改、撤销';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.p_trade_id is '原交易编号';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.is_cancel is '是否已撤销，默认“否”，在交易发生撤销时更新成“是”';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.is_clean is '是否结清，收息付费时用';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.cash_id is '现金流代码，金融产品代码+金融产品类型+现金流二级类型，还本、付息、付费等时存对应计划的现金流代码';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.sec_manage_acct_id is '证券管理户代码';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.b_trade_id is '前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.chl_id is '渠道/通道代码';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.counter_id is '交易对手';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.is_out_trade is '是否外部交易，是、否';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.trade_market is '交易场所，银行间、上交所、深交所、柜面等';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.trade_plat is '交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.trade_market_mode is '交易市场，一级市场、二级市场';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.trader is '交易员';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.counter_trader is '对手方交易员';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.counter_contact is '对手方联系方式';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.f_trade_id is '关联系统交易编号';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.portfolio_id is '投资组合代码';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.prod_id is '理财产品代码';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.p_totle_trade_id is '上级汇总交易编号';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.remark is '备注';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.create_user is '创建人';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.create_dept is '创建部门';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.create_time is '创建时间';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.update_user is '更新人';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.update_time is '更新时间';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.current_sub is '本期认购';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.last_amt is '上期余额';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.last_red is '上期赎回';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.last_amt_sub is '上期滚入余额';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.accounting_amt is '到账资金';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.red_profit is '赎回收益';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.red_cost is '赎回成本';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.dqprin_amt is '到期本金';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.pay_date is '交付日';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.remain_prin is '剩余名义本金';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.tg_busi_type is '投管业务类型';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.is_overdue_deal is '是否逾期交易';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.clear_type is '清算类型';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.eff_time is '有效时间';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.delivery_type is '首期结算方式';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.m_delivery_type is '到期结算方式';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.rate is '利率';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.repo_term is '期限(天)';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.term_type is '期限品种';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.settle_speed is '清算速度';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.pay_unpaidint_amt is '支付未支付利息';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.ispay_unpaidint is '是否转让还本未支付利息';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.start_dt is '开始时间';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.end_dt is '结束时间';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.id_mark is '增删标志';
comment on column ${iol_schema}.fams_trd_fin_product_deal_total.etl_timestamp is 'ETL处理时间戳';
