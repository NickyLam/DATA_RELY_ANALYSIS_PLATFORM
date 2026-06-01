/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_ces_quote_deal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_ces_quote_deal
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_ces_quote_deal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_ces_quote_deal(
    id varchar2(60) -- ID
    ,buss_contract_id varchar2(60) -- 业务表批次ID
    ,dealed_no varchar2(30) -- 成交单编号
    ,trade_direct varchar2(8) -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
    ,busi_type varchar2(6) -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,trade_type varchar2(6) -- 成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,trade_date varchar2(12) -- 成交日期
    ,trade_time varchar2(21) -- 成交时间
    ,trade_status varchar2(6) -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
    ,settle_status varchar2(6) -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,quote_no varchar2(24) -- 报价单编号
    ,brh_no varchar2(14) -- 机构代码
    ,product_no varchar2(14) -- 非法人产品
    ,trader_id varchar2(15) -- 交易员ID
    ,fundation_acct varchar2(48) -- 资金账户
    ,adver_brh_no varchar2(14) -- 对手机构代码
    ,adver_pro_no varchar2(14) -- 对手非法人产品
    ,adver_trader_id varchar2(15) -- 对手交易员ID
    ,adver_fund_acct varchar2(48) -- 对手资金账户
    ,quote_status varchar2(6) -- 报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
    ,trace_reason varchar2(2) -- 中止原因
    ,lock_flag varchar2(2) -- 锁定标识： 0 否 1 是
    ,misc varchar2(675) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,due_settle_status varchar2(6) -- 到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nesting_lock_flag varchar2(2) -- 嵌套锁标识： 0 否 1 是
    ,anoclick_deal_no varchar2(30) -- 匿名点击成交单编号
    ,click_type varchar2(6) -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
    ,own_mem_no varchar2(9) -- 所属会员代码
    ,busi_branch_no varchar2(15) -- 业务机构号
    ,top_branch_no varchar2(15) -- 总行机构号
    ,deal_tenor_days number(8,0) -- 持票期限
    ,deal_settle_amt number(18,2) -- 结算金额
    ,deal_sum_count number(8,0) -- 票据张数
    ,deal_sum_amount number(18,2) -- 票据总额
    ,deal_pay_interest number(18,2) -- 应付利息
    ,deal_yield_rate number(13,6) -- 收益率
    ,create_time varchar2(21) -- 创建时间
    ,create_by varchar2(45) -- 创建人
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
grant select on ${iol_schema}.bdms_ces_quote_deal to ${iml_schema};
grant select on ${iol_schema}.bdms_ces_quote_deal to ${icl_schema};
grant select on ${iol_schema}.bdms_ces_quote_deal to ${idl_schema};
grant select on ${iol_schema}.bdms_ces_quote_deal to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_ces_quote_deal is '对话报价成交单表';
comment on column ${iol_schema}.bdms_ces_quote_deal.id is 'ID';
comment on column ${iol_schema}.bdms_ces_quote_deal.buss_contract_id is '业务表批次ID';
comment on column ${iol_schema}.bdms_ces_quote_deal.dealed_no is '成交单编号';
comment on column ${iol_schema}.bdms_ces_quote_deal.trade_direct is '交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出';
comment on column ${iol_schema}.bdms_ces_quote_deal.busi_type is '业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票';
comment on column ${iol_schema}.bdms_ces_quote_deal.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_ces_quote_deal.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_ces_quote_deal.trade_type is '成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交';
comment on column ${iol_schema}.bdms_ces_quote_deal.trade_date is '成交日期';
comment on column ${iol_schema}.bdms_ces_quote_deal.trade_time is '成交时间';
comment on column ${iol_schema}.bdms_ces_quote_deal.trade_status is '成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功';
comment on column ${iol_schema}.bdms_ces_quote_deal.settle_status is '清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_ces_quote_deal.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_ces_quote_deal.brh_no is '机构代码';
comment on column ${iol_schema}.bdms_ces_quote_deal.product_no is '非法人产品';
comment on column ${iol_schema}.bdms_ces_quote_deal.trader_id is '交易员ID';
comment on column ${iol_schema}.bdms_ces_quote_deal.fundation_acct is '资金账户';
comment on column ${iol_schema}.bdms_ces_quote_deal.adver_brh_no is '对手机构代码';
comment on column ${iol_schema}.bdms_ces_quote_deal.adver_pro_no is '对手非法人产品';
comment on column ${iol_schema}.bdms_ces_quote_deal.adver_trader_id is '对手交易员ID';
comment on column ${iol_schema}.bdms_ces_quote_deal.adver_fund_acct is '对手资金账户';
comment on column ${iol_schema}.bdms_ces_quote_deal.quote_status is '报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账';
comment on column ${iol_schema}.bdms_ces_quote_deal.trace_reason is '中止原因';
comment on column ${iol_schema}.bdms_ces_quote_deal.lock_flag is '锁定标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_ces_quote_deal.misc is '备注';
comment on column ${iol_schema}.bdms_ces_quote_deal.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_ces_quote_deal.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_ces_quote_deal.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_ces_quote_deal.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_ces_quote_deal.due_settle_status is '到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_ces_quote_deal.nesting_lock_flag is '嵌套锁标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_ces_quote_deal.anoclick_deal_no is '匿名点击成交单编号';
comment on column ${iol_schema}.bdms_ces_quote_deal.click_type is '点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收';
comment on column ${iol_schema}.bdms_ces_quote_deal.own_mem_no is '所属会员代码';
comment on column ${iol_schema}.bdms_ces_quote_deal.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_ces_quote_deal.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_ces_quote_deal.deal_tenor_days is '持票期限';
comment on column ${iol_schema}.bdms_ces_quote_deal.deal_settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_ces_quote_deal.deal_sum_count is '票据张数';
comment on column ${iol_schema}.bdms_ces_quote_deal.deal_sum_amount is '票据总额';
comment on column ${iol_schema}.bdms_ces_quote_deal.deal_pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_ces_quote_deal.deal_yield_rate is '收益率';
comment on column ${iol_schema}.bdms_ces_quote_deal.create_time is '创建时间';
comment on column ${iol_schema}.bdms_ces_quote_deal.create_by is '创建人';
comment on column ${iol_schema}.bdms_ces_quote_deal.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_ces_quote_deal.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_ces_quote_deal.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_ces_quote_deal.etl_timestamp is 'ETL处理时间戳';
