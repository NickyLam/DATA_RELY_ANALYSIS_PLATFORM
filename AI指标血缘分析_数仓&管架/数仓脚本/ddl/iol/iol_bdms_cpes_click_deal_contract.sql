/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_click_deal_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_click_deal_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_click_deal_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_click_deal_contract(
    id varchar2(60) -- 唯一主键
    ,contract_no varchar2(60) -- 批次号
    ,busi_type varchar2(6) -- 业务类型：BT01 转贴现
    ,busi_date varchar2(12) -- 业务日期
    ,trade_direct varchar2(8) -- 交易方向： TDD01 买入 TDD02 卖出
    ,is_anonymous varchar2(2) -- 是否匿名： 0 否 1 是
    ,trade_scope varchar2(6) -- 交易范围： TS01 不限 TS02 内部 TS03 外部
    ,busi_branch_no varchar2(15) -- 业务机构号
    ,top_branch_no varchar2(15) -- 总行机构号
    ,own_user_id varchar2(15) -- 我方交易员
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据属性： ME01 纸票 ME02 电票
    ,rate number(7,6) -- 利率
    ,sub_deal_flag varchar2(2) -- 部分成交选项： 0 否 1 是
    ,quote_valid_tm varchar2(21) -- 报价有效时间
    ,settle_time varchar2(21) -- 最晚结算时间
    ,clear_speed varchar2(6) -- 清算速度： CS00 T+0 CS01 T+1
    ,settle_date varchar2(12) -- 结算日期
    ,settle_mode varchar2(6) -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,clear_type varchar2(6) -- 清算类型： CT01 全额清算 CT02 净额清算
    ,adver_clear_mode varchar2(9) -- 交易对手清算模式： CLE001 模式一（人行清算账户） CLE002 模式二（票交所资金账户-法人会员） CLE003 模式三（票交所资金账户-资管类会员）
    ,adver_brh_no varchar2(14) -- 交易对手机构代码
    ,adver_pro_no varchar2(15) -- 交易对手非法人产品号
    ,adver_user_id varchar2(15) -- 交易对手交易员
    ,is_need_pay_confirm varchar2(2) -- 是否需要付款确认： 0 否 1 是
    ,min_tenor_days number(8,0) -- 最短剩余期限
    ,max_tenor_days number(8,0) -- 最长剩余期限
    ,due_date_begin varchar2(12) -- 票据到期起始日
    ,due_date_end varchar2(12) -- 票据到期截止日
    ,min_draft_amt number(18,2) -- 最小单张票面金额
    ,credit_type varchar2(5) -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,credit_codes varchar2(1500) -- 信用主体行别
    ,cust_types varchar2(1500) -- 交易对手类型
    ,accept_brh_types varchar2(1500) -- 承兑行类型
    ,accept_brh_no_list varchar2(1500) -- 承兑行
    ,discount_brh_no_types varchar2(1500) -- 贴现行类型
    ,discount_brh_no_list varchar2(1500) -- 贴现行
    ,guarantee_brh_types varchar2(1500) -- 保证增信行类型
    ,guarantee_brh_no_list varchar2(1500) -- 保证增信行
    ,department_no varchar2(15) -- 所属部门
    ,manager_no varchar2(30) -- 客户经理
    ,sum_count number(8,0) -- 票据张数
    ,sum_amount number(18,2) -- 票据总额
    ,yield_rate number(13,6) -- 收益率
    ,tenor_days number(8,0) -- 加权平均剩余期限
    ,settle_amt number(18,2) -- 结算金额
    ,pay_interest number(18,2) -- 应付利息
    ,contract_status varchar2(3) -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,message_status varchar2(3) -- 报文处理状态： 00 未处理 10 发送中 11 发送待确认 12 发送确认成功 13 发送确认失败 14 发送已收到应答(或收到通知) 21 撤销中 22 撤销成功 23 撤销失败 30 应答中 31 应答发送成功 32 应答确认成功(或收到通知) 33 应答确认失败 40 部分成交通知 41 全部成交通知 42 终止通知
    ,settle_status varchar2(6) -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败 06 部分记账
    ,created_by varchar2(45) -- 创建人
    ,last_upd_opr varchar2(45) -- 最后修改人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,product_no varchar2(12) -- 产品号
    ,deal_id varchar2(60) -- 成交单表ID
    ,quote_no varchar2(24) -- 报价单编号
    ,click_type varchar2(6) -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
    ,dealed_no varchar2(30) -- 成交单编号
    ,forward_num number(8,0) -- 报价转发次数
    ,ck_contract_type varchar2(2) -- 批次类型:1-发布报价,2-签收报价
    ,credit_check_status varchar2(3) -- 
    ,i9_type varchar2(8) -- 三分类标识
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
grant select on ${iol_schema}.bdms_cpes_click_deal_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_click_deal_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_click_deal_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_click_deal_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_click_deal_contract is '点击成交批次表';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.id is '唯一主键';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.busi_type is '业务类型：BT01 转贴现';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.busi_date is '业务日期';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.trade_direct is '交易方向： TDD01 买入 TDD02 卖出';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.is_anonymous is '是否匿名： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.trade_scope is '交易范围： TS01 不限 TS02 内部 TS03 外部';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.own_user_id is '我方交易员';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.draft_attr is '票据属性： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.rate is '利率';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.sub_deal_flag is '部分成交选项： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.quote_valid_tm is '报价有效时间';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.settle_time is '最晚结算时间';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.clear_speed is '清算速度： CS00 T+0 CS01 T+1';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.settle_mode is '结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.clear_type is '清算类型： CT01 全额清算 CT02 净额清算';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.adver_clear_mode is '交易对手清算模式： CLE001 模式一（人行清算账户） CLE002 模式二（票交所资金账户-法人会员） CLE003 模式三（票交所资金账户-资管类会员）';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.adver_brh_no is '交易对手机构代码';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.adver_pro_no is '交易对手非法人产品号';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.adver_user_id is '交易对手交易员';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.is_need_pay_confirm is '是否需要付款确认： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.min_tenor_days is '最短剩余期限';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.max_tenor_days is '最长剩余期限';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.due_date_begin is '票据到期起始日';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.due_date_end is '票据到期截止日';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.min_draft_amt is '最小单张票面金额';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.credit_type is '信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.credit_codes is '信用主体行别';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.cust_types is '交易对手类型';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.accept_brh_types is '承兑行类型';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.accept_brh_no_list is '承兑行';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.discount_brh_no_types is '贴现行类型';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.discount_brh_no_list is '贴现行';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.guarantee_brh_types is '保证增信行类型';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.guarantee_brh_no_list is '保证增信行';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.department_no is '所属部门';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.manager_no is '客户经理';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.sum_count is '票据张数';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.sum_amount is '票据总额';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.yield_rate is '收益率';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.tenor_days is '加权平均剩余期限';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.contract_status is '审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.message_status is '报文处理状态： 00 未处理 10 发送中 11 发送待确认 12 发送确认成功 13 发送确认失败 14 发送已收到应答(或收到通知) 21 撤销中 22 撤销成功 23 撤销失败 30 应答中 31 应答发送成功 32 应答确认成功(或收到通知) 33 应答确认失败 40 部分成交通知 41 全部成交通知 42 终止通知';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.settle_status is '清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败 06 部分记账';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.last_upd_opr is '最后修改人';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.deal_id is '成交单表ID';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.click_type is '点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.dealed_no is '成交单编号';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.forward_num is '报价转发次数';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.ck_contract_type is '批次类型:1-发布报价,2-签收报价';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.credit_check_status is '';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.i9_type is '三分类标识';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_click_deal_contract.etl_timestamp is 'ETL处理时间戳';
