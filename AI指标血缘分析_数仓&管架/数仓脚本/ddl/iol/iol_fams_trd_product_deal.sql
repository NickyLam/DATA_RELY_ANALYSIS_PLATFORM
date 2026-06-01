/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_trd_product_deal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_trd_product_deal
whenever sqlerror continue none;
drop table ${iol_schema}.fams_trd_product_deal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_trd_product_deal(
    trade_id varchar2(36) -- 交易编号
    ,busi_type varchar2(50) -- 业务类型，债券交易、产品交易，估值核算专用
    ,finprod_id varchar2(50) -- 金融产品代码
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,branch number(10) -- 分支序号
    ,trade_date date -- 交易日期
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,settle_date date -- 交割日期
    ,settle_speed number(10) -- 清算速度
    ,ccy varchar2(50) -- 交易币种
    ,cprice_date date -- 净值日期
    ,unit_cprice number(30,14) -- 单位净价
    ,unit_int number(30,14) -- 单位利息
    ,unit_fprice number(30,14) -- 单位全价
    ,par_value number(30,14) -- 单位面值，债券100或者当前面值(还本前)，其他资产1
    ,cprice_amt number(30,2) -- 净价总额
    ,share_amt number(30,4) -- 交易份额，债券数量等
    ,prin_amt number(30,2) -- 交易本金，债券券面等
    ,int_amt number(30,2) -- 利息总额
    ,fprice_amt number(30,2) -- 全价总额
    ,fee_amt_pay number(30,2) -- 随交易支付费用
    ,trade_amt number(30,2) -- 交易金额
    ,fee_amt_unpay number(30,2) -- 未随交易支付费用
    ,fee_amt number(30,2) -- 总交易费用
    ,ps varchar2(50) -- 交易方向，买入、卖出、收息、还本、申购、赎回等
    ,yield number(30,14) -- 到期收益率
    ,exer_yield number(30,14) -- 行权收益率
    ,inv_aim varchar2(50) -- 投资目的
    ,trade_status varchar2(50) -- 交易状态，初始、撤销
    ,is_cancel varchar2(50) -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
    ,p_trade_id varchar2(32) -- 原交易编号，撤销时存原来的交易编号
    ,is_clean varchar2(50) -- 是否结清，收息付费时用
    ,totle_trade_id varchar2(32) -- 汇总交易编号
    ,r_trade_id varchar2(32) -- 反向交易编号
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
    ,sec_manage_acct_id varchar2(32) -- 证券管理户代码
    ,f_trade_id varchar2(50) -- 关联系统交易编号
    ,cash_id varchar2(32) -- 现金流代码，还本、付息、付费等时存对应计划的现金流代码
    ,regist_org varchar2(50) -- 登记托管机构
    ,remark varchar2(4000) -- 备注
    ,cancel_remark varchar2(1000) -- 撤销说明
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,delivery_type varchar2(50) -- 
    ,pay_date date -- 交付日
    ,sale_code varchar2(32) -- 销售代码
    ,split_trade_id varchar2(32) -- 拆分前交易编号
    ,is_swap_transaction varchar2(10) -- 是否转仓交易
    ,out_of_account varchar2(33) -- 出账流水号
    ,org_code varchar2(32) -- 所属机构
    ,invest_manager varchar2(50) -- 投资经理
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
grant select on ${iol_schema}.fams_trd_product_deal to ${iml_schema};
grant select on ${iol_schema}.fams_trd_product_deal to ${icl_schema};
grant select on ${iol_schema}.fams_trd_product_deal to ${idl_schema};
grant select on ${iol_schema}.fams_trd_product_deal to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_trd_product_deal is '金融产品交易';
comment on column ${iol_schema}.fams_trd_product_deal.trade_id is '交易编号';
comment on column ${iol_schema}.fams_trd_product_deal.busi_type is '业务类型，债券交易、产品交易，估值核算专用';
comment on column ${iol_schema}.fams_trd_product_deal.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_trd_product_deal.finprod_type is '金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_trd_product_deal.finprod_type2 is '金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_trd_product_deal.branch is '分支序号';
comment on column ${iol_schema}.fams_trd_product_deal.trade_date is '交易日期';
comment on column ${iol_schema}.fams_trd_product_deal.vdate is '起息日';
comment on column ${iol_schema}.fams_trd_product_deal.mdate is '到期日';
comment on column ${iol_schema}.fams_trd_product_deal.settle_date is '交割日期';
comment on column ${iol_schema}.fams_trd_product_deal.settle_speed is '清算速度';
comment on column ${iol_schema}.fams_trd_product_deal.ccy is '交易币种';
comment on column ${iol_schema}.fams_trd_product_deal.cprice_date is '净值日期';
comment on column ${iol_schema}.fams_trd_product_deal.unit_cprice is '单位净价';
comment on column ${iol_schema}.fams_trd_product_deal.unit_int is '单位利息';
comment on column ${iol_schema}.fams_trd_product_deal.unit_fprice is '单位全价';
comment on column ${iol_schema}.fams_trd_product_deal.par_value is '单位面值，债券100或者当前面值(还本前)，其他资产1';
comment on column ${iol_schema}.fams_trd_product_deal.cprice_amt is '净价总额';
comment on column ${iol_schema}.fams_trd_product_deal.share_amt is '交易份额，债券数量等';
comment on column ${iol_schema}.fams_trd_product_deal.prin_amt is '交易本金，债券券面等';
comment on column ${iol_schema}.fams_trd_product_deal.int_amt is '利息总额';
comment on column ${iol_schema}.fams_trd_product_deal.fprice_amt is '全价总额';
comment on column ${iol_schema}.fams_trd_product_deal.fee_amt_pay is '随交易支付费用';
comment on column ${iol_schema}.fams_trd_product_deal.trade_amt is '交易金额';
comment on column ${iol_schema}.fams_trd_product_deal.fee_amt_unpay is '未随交易支付费用';
comment on column ${iol_schema}.fams_trd_product_deal.fee_amt is '总交易费用';
comment on column ${iol_schema}.fams_trd_product_deal.ps is '交易方向，买入、卖出、收息、还本、申购、赎回等';
comment on column ${iol_schema}.fams_trd_product_deal.yield is '到期收益率';
comment on column ${iol_schema}.fams_trd_product_deal.exer_yield is '行权收益率';
comment on column ${iol_schema}.fams_trd_product_deal.inv_aim is '投资目的';
comment on column ${iol_schema}.fams_trd_product_deal.trade_status is '交易状态，初始、撤销';
comment on column ${iol_schema}.fams_trd_product_deal.is_cancel is '是否已撤销，默认“否”，在交易发生撤销时更新成“是”';
comment on column ${iol_schema}.fams_trd_product_deal.p_trade_id is '原交易编号，撤销时存原来的交易编号';
comment on column ${iol_schema}.fams_trd_product_deal.is_clean is '是否结清，收息付费时用';
comment on column ${iol_schema}.fams_trd_product_deal.totle_trade_id is '汇总交易编号';
comment on column ${iol_schema}.fams_trd_product_deal.r_trade_id is '反向交易编号';
comment on column ${iol_schema}.fams_trd_product_deal.b_trade_id is '前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号';
comment on column ${iol_schema}.fams_trd_product_deal.chl_id is '渠道/通道代码';
comment on column ${iol_schema}.fams_trd_product_deal.counter_id is '交易对手';
comment on column ${iol_schema}.fams_trd_product_deal.is_out_trade is '是否外部交易，是、否';
comment on column ${iol_schema}.fams_trd_product_deal.trade_market is '交易场所，银行间、上交所、深交所、柜面等';
comment on column ${iol_schema}.fams_trd_product_deal.trade_plat is '交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等';
comment on column ${iol_schema}.fams_trd_product_deal.trade_market_mode is '交易市场，一级市场、二级市场';
comment on column ${iol_schema}.fams_trd_product_deal.trader is '交易员';
comment on column ${iol_schema}.fams_trd_product_deal.counter_trader is '对手方交易员';
comment on column ${iol_schema}.fams_trd_product_deal.counter_contact is '对手方联系方式';
comment on column ${iol_schema}.fams_trd_product_deal.sec_manage_acct_id is '证券管理户代码';
comment on column ${iol_schema}.fams_trd_product_deal.f_trade_id is '关联系统交易编号';
comment on column ${iol_schema}.fams_trd_product_deal.cash_id is '现金流代码，还本、付息、付费等时存对应计划的现金流代码';
comment on column ${iol_schema}.fams_trd_product_deal.regist_org is '登记托管机构';
comment on column ${iol_schema}.fams_trd_product_deal.remark is '备注';
comment on column ${iol_schema}.fams_trd_product_deal.cancel_remark is '撤销说明';
comment on column ${iol_schema}.fams_trd_product_deal.create_user is '创建人';
comment on column ${iol_schema}.fams_trd_product_deal.create_dept is '创建部门';
comment on column ${iol_schema}.fams_trd_product_deal.create_time is '创建时间';
comment on column ${iol_schema}.fams_trd_product_deal.update_user is '更新人';
comment on column ${iol_schema}.fams_trd_product_deal.update_time is '更新时间';
comment on column ${iol_schema}.fams_trd_product_deal.delivery_type is '';
comment on column ${iol_schema}.fams_trd_product_deal.pay_date is '交付日';
comment on column ${iol_schema}.fams_trd_product_deal.sale_code is '销售代码';
comment on column ${iol_schema}.fams_trd_product_deal.split_trade_id is '拆分前交易编号';
comment on column ${iol_schema}.fams_trd_product_deal.is_swap_transaction is '是否转仓交易';
comment on column ${iol_schema}.fams_trd_product_deal.out_of_account is '出账流水号';
comment on column ${iol_schema}.fams_trd_product_deal.org_code is '所属机构';
comment on column ${iol_schema}.fams_trd_product_deal.invest_manager is '投资经理';
comment on column ${iol_schema}.fams_trd_product_deal.start_dt is '开始时间';
comment on column ${iol_schema}.fams_trd_product_deal.end_dt is '结束时间';
comment on column ${iol_schema}.fams_trd_product_deal.id_mark is '增删标志';
comment on column ${iol_schema}.fams_trd_product_deal.etl_timestamp is 'ETL处理时间戳';
