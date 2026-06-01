/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_anoclick_match_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_anoclick_match_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_anoclick_match_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_anoclick_match_contract(
    id varchar2(60) -- ID
    ,quote_contract_id varchar2(60) -- 报价批次表ID
    ,deal_id varchar2(60) -- 成交单表ID
    ,contract_no varchar2(60) -- 批次号
    ,product_no varchar2(12) -- 产品号
    ,dealed_no varchar2(30) -- 成交单编号
    ,trade_type varchar2(6) -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,trade_date varchar2(12) -- 成交日期
    ,trade_time varchar2(21) -- 成交时间
    ,trade_status varchar2(6) -- 成交单状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
    ,sum_count number(8,0) -- 票据总张数
    ,sum_amount number(18,2) -- 票据总金额
    ,quote_no varchar2(24) -- 报价单编号
    ,busi_type varchar2(6) -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 RBT01 再贴现买断 RBT02 再贴现质押式回购
    ,trade_direct varchar2(8) -- 交易方向： CRD01 逆回购 CRD02 正回购
    ,brh_no varchar2(14) -- 本方机构代码
    ,pro_no varchar2(14) -- 本方非法人产品
    ,trader_id varchar2(15) -- 本方交易员ID
    ,adver_brh_no varchar2(14) -- 对方机构代码
    ,adver_pro_no varchar2(14) -- 对方非法人产品
    ,adver_trader_id varchar2(15) -- 对方交易员ID
    ,draft_type varchar2(6) -- 票据类型 AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据属性： ME01 纸票 ME02 电票
    ,buy_back_amt number(18,2) -- 回购金额
    ,tenor_code varchar2(8) -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
    ,tenor_days number(8,0) -- 回购期限
    ,clear_speed varchar2(6) -- 清算速度 CS00 T+0 CS01 T+1
    ,clear_type varchar2(6) -- 清算类型 CT01 全额清算 CT02 净额清算
    ,latest_settle_time varchar2(21) -- 最晚首期结算时间
    ,settle_mode varchar2(6) -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,settle_amt number(18,2) -- 首期结算金额
    ,due_settle_amt number(18,2) -- 到期结算金额
    ,settle_date varchar2(12) -- 首期结算日
    ,due_settle_date varchar2(12) -- 到期结算日
    ,rate number(7,6) -- 回购利率
    ,pay_interest number(18,2) -- 应付利息
    ,yield_rate number(13,6) -- 回购收益率
    ,close_time varchar2(21) -- 提票截止时间
    ,credit_type varchar2(5) -- 信用主体类型 201 政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,department_no varchar2(15) -- 所属部门
    ,manager_no varchar2(30) -- 客户经理
    ,busi_branch_no varchar2(15) -- 业务机构号
    ,top_branch_no varchar2(15) -- 总行机构号
    ,contract_status varchar2(3) -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,message_status varchar2(3) -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
    ,settle_status varchar2(6) -- 清算状态 MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,account_status varchar2(3) -- 记账状态 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,created_by varchar2(45) -- 创建人
    ,last_upd_opr varchar2(45) -- 最后修改人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,credit_check_status varchar2(3) -- 
    ,due_pay_interest number(18,2) -- 到期应付利息
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
grant select on ${iol_schema}.bdms_cpes_anoclick_match_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_match_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_match_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_match_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_anoclick_match_contract is '质押式回购匿名点击匹配批次表';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.quote_contract_id is '报价批次表ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.deal_id is '成交单表ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.dealed_no is '成交单编号';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.trade_type is '成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.trade_date is '成交日期';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.trade_time is '成交时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.trade_status is '成交单状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.sum_count is '票据总张数';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.sum_amount is '票据总金额';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.busi_type is '业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 RBT01 再贴现买断 RBT02 再贴现质押式回购';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.trade_direct is '交易方向： CRD01 逆回购 CRD02 正回购';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.brh_no is '本方机构代码';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.pro_no is '本方非法人产品';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.trader_id is '本方交易员ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.adver_brh_no is '对方机构代码';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.adver_pro_no is '对方非法人产品';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.adver_trader_id is '对方交易员ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.draft_type is '票据类型 AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.draft_attr is '票据属性： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.buy_back_amt is '回购金额';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.tenor_code is '期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.tenor_days is '回购期限';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.clear_speed is '清算速度 CS00 T+0 CS01 T+1';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.clear_type is '清算类型 CT01 全额清算 CT02 净额清算';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.latest_settle_time is '最晚首期结算时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.settle_mode is '结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.settle_amt is '首期结算金额';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.due_settle_amt is '到期结算金额';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.settle_date is '首期结算日';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.due_settle_date is '到期结算日';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.rate is '回购利率';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.yield_rate is '回购收益率';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.close_time is '提票截止时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.credit_type is '信用主体类型 201 政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.department_no is '所属部门';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.manager_no is '客户经理';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.contract_status is '审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.message_status is '报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.settle_status is '清算状态 MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.account_status is '记账状态 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.last_upd_opr is '最后修改人';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.credit_check_status is '';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.due_pay_interest is '到期应付利息';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_anoclick_match_contract.etl_timestamp is 'ETL处理时间戳';
