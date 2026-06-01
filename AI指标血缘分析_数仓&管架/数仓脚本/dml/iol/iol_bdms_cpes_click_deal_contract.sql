/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_click_deal_contract
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.bdms_cpes_click_deal_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_click_deal_contract;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_click_deal_contract_op purge;
drop table ${iol_schema}.bdms_cpes_click_deal_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_click_deal_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_click_deal_contract where 0=1;

create table ${iol_schema}.bdms_cpes_click_deal_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_click_deal_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_click_deal_contract_cl(
            id -- 唯一主键
            ,contract_no -- 批次号
            ,busi_type -- 业务类型：BT01 转贴现
            ,busi_date -- 业务日期
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,is_anonymous -- 是否匿名： 0 否 1 是
            ,trade_scope -- 交易范围： TS01 不限 TS02 内部 TS03 外部
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,own_user_id -- 我方交易员
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,rate -- 利率
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,settle_time -- 最晚结算时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,settle_date -- 结算日期
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,adver_clear_mode -- 交易对手清算模式： CLE001 模式一（人行清算账户） CLE002 模式二（票交所资金账户-法人会员） CLE003 模式三（票交所资金账户-资管类会员）
            ,adver_brh_no -- 交易对手机构代码
            ,adver_pro_no -- 交易对手非法人产品号
            ,adver_user_id -- 交易对手交易员
            ,is_need_pay_confirm -- 是否需要付款确认： 0 否 1 是
            ,min_tenor_days -- 最短剩余期限
            ,max_tenor_days -- 最长剩余期限
            ,due_date_begin -- 票据到期起始日
            ,due_date_end -- 票据到期截止日
            ,min_draft_amt -- 最小单张票面金额
            ,credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_codes -- 信用主体行别
            ,cust_types -- 交易对手类型
            ,accept_brh_types -- 承兑行类型
            ,accept_brh_no_list -- 承兑行
            ,discount_brh_no_types -- 贴现行类型
            ,discount_brh_no_list -- 贴现行
            ,guarantee_brh_types -- 保证增信行类型
            ,guarantee_brh_no_list -- 保证增信行
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,yield_rate -- 收益率
            ,tenor_days -- 加权平均剩余期限
            ,settle_amt -- 结算金额
            ,pay_interest -- 应付利息
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送待确认 12 发送确认成功 13 发送确认失败 14 发送已收到应答(或收到通知) 21 撤销中 22 撤销成功 23 撤销失败 30 应答中 31 应答发送成功 32 应答确认成功(或收到通知) 33 应答确认失败 40 部分成交通知 41 全部成交通知 42 终止通知
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败 06 部分记账
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,product_no -- 产品号
            ,deal_id -- 成交单表ID
            ,quote_no -- 报价单编号
            ,click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
            ,dealed_no -- 成交单编号
            ,forward_num -- 报价转发次数
            ,ck_contract_type -- 批次类型:1-发布报价,2-签收报价
            ,credit_check_status -- 
            ,i9_type -- 三分类标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_click_deal_contract_op(
            id -- 唯一主键
            ,contract_no -- 批次号
            ,busi_type -- 业务类型：BT01 转贴现
            ,busi_date -- 业务日期
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,is_anonymous -- 是否匿名： 0 否 1 是
            ,trade_scope -- 交易范围： TS01 不限 TS02 内部 TS03 外部
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,own_user_id -- 我方交易员
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,rate -- 利率
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,settle_time -- 最晚结算时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,settle_date -- 结算日期
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,adver_clear_mode -- 交易对手清算模式： CLE001 模式一（人行清算账户） CLE002 模式二（票交所资金账户-法人会员） CLE003 模式三（票交所资金账户-资管类会员）
            ,adver_brh_no -- 交易对手机构代码
            ,adver_pro_no -- 交易对手非法人产品号
            ,adver_user_id -- 交易对手交易员
            ,is_need_pay_confirm -- 是否需要付款确认： 0 否 1 是
            ,min_tenor_days -- 最短剩余期限
            ,max_tenor_days -- 最长剩余期限
            ,due_date_begin -- 票据到期起始日
            ,due_date_end -- 票据到期截止日
            ,min_draft_amt -- 最小单张票面金额
            ,credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_codes -- 信用主体行别
            ,cust_types -- 交易对手类型
            ,accept_brh_types -- 承兑行类型
            ,accept_brh_no_list -- 承兑行
            ,discount_brh_no_types -- 贴现行类型
            ,discount_brh_no_list -- 贴现行
            ,guarantee_brh_types -- 保证增信行类型
            ,guarantee_brh_no_list -- 保证增信行
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,yield_rate -- 收益率
            ,tenor_days -- 加权平均剩余期限
            ,settle_amt -- 结算金额
            ,pay_interest -- 应付利息
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送待确认 12 发送确认成功 13 发送确认失败 14 发送已收到应答(或收到通知) 21 撤销中 22 撤销成功 23 撤销失败 30 应答中 31 应答发送成功 32 应答确认成功(或收到通知) 33 应答确认失败 40 部分成交通知 41 全部成交通知 42 终止通知
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败 06 部分记账
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,product_no -- 产品号
            ,deal_id -- 成交单表ID
            ,quote_no -- 报价单编号
            ,click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
            ,dealed_no -- 成交单编号
            ,forward_num -- 报价转发次数
            ,ck_contract_type -- 批次类型:1-发布报价,2-签收报价
            ,credit_check_status -- 
            ,i9_type -- 三分类标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 唯一主键
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型：BT01 转贴现
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 业务日期
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
    ,nvl(n.is_anonymous, o.is_anonymous) as is_anonymous -- 是否匿名： 0 否 1 是
    ,nvl(n.trade_scope, o.trade_scope) as trade_scope -- 交易范围： TS01 不限 TS02 内部 TS03 外部
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.own_user_id, o.own_user_id) as own_user_id -- 我方交易员
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： ME01 纸票 ME02 电票
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.sub_deal_flag, o.sub_deal_flag) as sub_deal_flag -- 部分成交选项： 0 否 1 是
    ,nvl(n.quote_valid_tm, o.quote_valid_tm) as quote_valid_tm -- 报价有效时间
    ,nvl(n.settle_time, o.settle_time) as settle_time -- 最晚结算时间
    ,nvl(n.clear_speed, o.clear_speed) as clear_speed -- 清算速度： CS00 T+0 CS01 T+1
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,nvl(n.adver_clear_mode, o.adver_clear_mode) as adver_clear_mode -- 交易对手清算模式： CLE001 模式一（人行清算账户） CLE002 模式二（票交所资金账户-法人会员） CLE003 模式三（票交所资金账户-资管类会员）
    ,nvl(n.adver_brh_no, o.adver_brh_no) as adver_brh_no -- 交易对手机构代码
    ,nvl(n.adver_pro_no, o.adver_pro_no) as adver_pro_no -- 交易对手非法人产品号
    ,nvl(n.adver_user_id, o.adver_user_id) as adver_user_id -- 交易对手交易员
    ,nvl(n.is_need_pay_confirm, o.is_need_pay_confirm) as is_need_pay_confirm -- 是否需要付款确认： 0 否 1 是
    ,nvl(n.min_tenor_days, o.min_tenor_days) as min_tenor_days -- 最短剩余期限
    ,nvl(n.max_tenor_days, o.max_tenor_days) as max_tenor_days -- 最长剩余期限
    ,nvl(n.due_date_begin, o.due_date_begin) as due_date_begin -- 票据到期起始日
    ,nvl(n.due_date_end, o.due_date_end) as due_date_end -- 票据到期截止日
    ,nvl(n.min_draft_amt, o.min_draft_amt) as min_draft_amt -- 最小单张票面金额
    ,nvl(n.credit_type, o.credit_type) as credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,nvl(n.credit_codes, o.credit_codes) as credit_codes -- 信用主体行别
    ,nvl(n.cust_types, o.cust_types) as cust_types -- 交易对手类型
    ,nvl(n.accept_brh_types, o.accept_brh_types) as accept_brh_types -- 承兑行类型
    ,nvl(n.accept_brh_no_list, o.accept_brh_no_list) as accept_brh_no_list -- 承兑行
    ,nvl(n.discount_brh_no_types, o.discount_brh_no_types) as discount_brh_no_types -- 贴现行类型
    ,nvl(n.discount_brh_no_list, o.discount_brh_no_list) as discount_brh_no_list -- 贴现行
    ,nvl(n.guarantee_brh_types, o.guarantee_brh_types) as guarantee_brh_types -- 保证增信行类型
    ,nvl(n.guarantee_brh_no_list, o.guarantee_brh_no_list) as guarantee_brh_no_list -- 保证增信行
    ,nvl(n.department_no, o.department_no) as department_no -- 所属部门
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 票据张数
    ,nvl(n.sum_amount, o.sum_amount) as sum_amount -- 票据总额
    ,nvl(n.yield_rate, o.yield_rate) as yield_rate -- 收益率
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 加权平均剩余期限
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.message_status, o.message_status) as message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送待确认 12 发送确认成功 13 发送确认失败 14 发送已收到应答(或收到通知) 21 撤销中 22 撤销成功 23 撤销失败 30 应答中 31 应答发送成功 32 应答确认成功(或收到通知) 33 应答确认失败 40 部分成交通知 41 全部成交通知 42 终止通知
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败 06 部分记账
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后修改人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 成交单表ID
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.click_type, o.click_type) as click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
    ,nvl(n.dealed_no, o.dealed_no) as dealed_no -- 成交单编号
    ,nvl(n.forward_num, o.forward_num) as forward_num -- 报价转发次数
    ,nvl(n.ck_contract_type, o.ck_contract_type) as ck_contract_type -- 批次类型:1-发布报价,2-签收报价
    ,nvl(n.credit_check_status, o.credit_check_status) as credit_check_status -- 
    ,nvl(n.i9_type, o.i9_type) as i9_type -- 三分类标识
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpes_click_deal_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_click_deal_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_no <> n.contract_no
        or o.busi_type <> n.busi_type
        or o.busi_date <> n.busi_date
        or o.trade_direct <> n.trade_direct
        or o.is_anonymous <> n.is_anonymous
        or o.trade_scope <> n.trade_scope
        or o.busi_branch_no <> n.busi_branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.own_user_id <> n.own_user_id
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.rate <> n.rate
        or o.sub_deal_flag <> n.sub_deal_flag
        or o.quote_valid_tm <> n.quote_valid_tm
        or o.settle_time <> n.settle_time
        or o.clear_speed <> n.clear_speed
        or o.settle_date <> n.settle_date
        or o.settle_mode <> n.settle_mode
        or o.clear_type <> n.clear_type
        or o.adver_clear_mode <> n.adver_clear_mode
        or o.adver_brh_no <> n.adver_brh_no
        or o.adver_pro_no <> n.adver_pro_no
        or o.adver_user_id <> n.adver_user_id
        or o.is_need_pay_confirm <> n.is_need_pay_confirm
        or o.min_tenor_days <> n.min_tenor_days
        or o.max_tenor_days <> n.max_tenor_days
        or o.due_date_begin <> n.due_date_begin
        or o.due_date_end <> n.due_date_end
        or o.min_draft_amt <> n.min_draft_amt
        or o.credit_type <> n.credit_type
        or o.credit_codes <> n.credit_codes
        or o.cust_types <> n.cust_types
        or o.accept_brh_types <> n.accept_brh_types
        or o.accept_brh_no_list <> n.accept_brh_no_list
        or o.discount_brh_no_types <> n.discount_brh_no_types
        or o.discount_brh_no_list <> n.discount_brh_no_list
        or o.guarantee_brh_types <> n.guarantee_brh_types
        or o.guarantee_brh_no_list <> n.guarantee_brh_no_list
        or o.department_no <> n.department_no
        or o.manager_no <> n.manager_no
        or o.sum_count <> n.sum_count
        or o.sum_amount <> n.sum_amount
        or o.yield_rate <> n.yield_rate
        or o.tenor_days <> n.tenor_days
        or o.settle_amt <> n.settle_amt
        or o.pay_interest <> n.pay_interest
        or o.contract_status <> n.contract_status
        or o.message_status <> n.message_status
        or o.settle_status <> n.settle_status
        or o.account_status <> n.account_status
        or o.created_by <> n.created_by
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
        or o.product_no <> n.product_no
        or o.deal_id <> n.deal_id
        or o.quote_no <> n.quote_no
        or o.click_type <> n.click_type
        or o.dealed_no <> n.dealed_no
        or o.forward_num <> n.forward_num
        or o.ck_contract_type <> n.ck_contract_type
        or o.credit_check_status <> n.credit_check_status
        or o.i9_type <> n.i9_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_click_deal_contract_cl(
            id -- 唯一主键
            ,contract_no -- 批次号
            ,busi_type -- 业务类型：BT01 转贴现
            ,busi_date -- 业务日期
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,is_anonymous -- 是否匿名： 0 否 1 是
            ,trade_scope -- 交易范围： TS01 不限 TS02 内部 TS03 外部
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,own_user_id -- 我方交易员
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,rate -- 利率
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,settle_time -- 最晚结算时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,settle_date -- 结算日期
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,adver_clear_mode -- 交易对手清算模式： CLE001 模式一（人行清算账户） CLE002 模式二（票交所资金账户-法人会员） CLE003 模式三（票交所资金账户-资管类会员）
            ,adver_brh_no -- 交易对手机构代码
            ,adver_pro_no -- 交易对手非法人产品号
            ,adver_user_id -- 交易对手交易员
            ,is_need_pay_confirm -- 是否需要付款确认： 0 否 1 是
            ,min_tenor_days -- 最短剩余期限
            ,max_tenor_days -- 最长剩余期限
            ,due_date_begin -- 票据到期起始日
            ,due_date_end -- 票据到期截止日
            ,min_draft_amt -- 最小单张票面金额
            ,credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_codes -- 信用主体行别
            ,cust_types -- 交易对手类型
            ,accept_brh_types -- 承兑行类型
            ,accept_brh_no_list -- 承兑行
            ,discount_brh_no_types -- 贴现行类型
            ,discount_brh_no_list -- 贴现行
            ,guarantee_brh_types -- 保证增信行类型
            ,guarantee_brh_no_list -- 保证增信行
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,yield_rate -- 收益率
            ,tenor_days -- 加权平均剩余期限
            ,settle_amt -- 结算金额
            ,pay_interest -- 应付利息
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送待确认 12 发送确认成功 13 发送确认失败 14 发送已收到应答(或收到通知) 21 撤销中 22 撤销成功 23 撤销失败 30 应答中 31 应答发送成功 32 应答确认成功(或收到通知) 33 应答确认失败 40 部分成交通知 41 全部成交通知 42 终止通知
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败 06 部分记账
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,product_no -- 产品号
            ,deal_id -- 成交单表ID
            ,quote_no -- 报价单编号
            ,click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
            ,dealed_no -- 成交单编号
            ,forward_num -- 报价转发次数
            ,ck_contract_type -- 批次类型:1-发布报价,2-签收报价
            ,credit_check_status -- 
            ,i9_type -- 三分类标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_click_deal_contract_op(
            id -- 唯一主键
            ,contract_no -- 批次号
            ,busi_type -- 业务类型：BT01 转贴现
            ,busi_date -- 业务日期
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,is_anonymous -- 是否匿名： 0 否 1 是
            ,trade_scope -- 交易范围： TS01 不限 TS02 内部 TS03 外部
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,own_user_id -- 我方交易员
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,rate -- 利率
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,settle_time -- 最晚结算时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,settle_date -- 结算日期
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,adver_clear_mode -- 交易对手清算模式： CLE001 模式一（人行清算账户） CLE002 模式二（票交所资金账户-法人会员） CLE003 模式三（票交所资金账户-资管类会员）
            ,adver_brh_no -- 交易对手机构代码
            ,adver_pro_no -- 交易对手非法人产品号
            ,adver_user_id -- 交易对手交易员
            ,is_need_pay_confirm -- 是否需要付款确认： 0 否 1 是
            ,min_tenor_days -- 最短剩余期限
            ,max_tenor_days -- 最长剩余期限
            ,due_date_begin -- 票据到期起始日
            ,due_date_end -- 票据到期截止日
            ,min_draft_amt -- 最小单张票面金额
            ,credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_codes -- 信用主体行别
            ,cust_types -- 交易对手类型
            ,accept_brh_types -- 承兑行类型
            ,accept_brh_no_list -- 承兑行
            ,discount_brh_no_types -- 贴现行类型
            ,discount_brh_no_list -- 贴现行
            ,guarantee_brh_types -- 保证增信行类型
            ,guarantee_brh_no_list -- 保证增信行
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,yield_rate -- 收益率
            ,tenor_days -- 加权平均剩余期限
            ,settle_amt -- 结算金额
            ,pay_interest -- 应付利息
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送待确认 12 发送确认成功 13 发送确认失败 14 发送已收到应答(或收到通知) 21 撤销中 22 撤销成功 23 撤销失败 30 应答中 31 应答发送成功 32 应答确认成功(或收到通知) 33 应答确认失败 40 部分成交通知 41 全部成交通知 42 终止通知
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败 06 部分记账
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,product_no -- 产品号
            ,deal_id -- 成交单表ID
            ,quote_no -- 报价单编号
            ,click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
            ,dealed_no -- 成交单编号
            ,forward_num -- 报价转发次数
            ,ck_contract_type -- 批次类型:1-发布报价,2-签收报价
            ,credit_check_status -- 
            ,i9_type -- 三分类标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 唯一主键
    ,o.contract_no -- 批次号
    ,o.busi_type -- 业务类型：BT01 转贴现
    ,o.busi_date -- 业务日期
    ,o.trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
    ,o.is_anonymous -- 是否匿名： 0 否 1 是
    ,o.trade_scope -- 交易范围： TS01 不限 TS02 内部 TS03 外部
    ,o.busi_branch_no -- 业务机构号
    ,o.top_branch_no -- 总行机构号
    ,o.own_user_id -- 我方交易员
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据属性： ME01 纸票 ME02 电票
    ,o.rate -- 利率
    ,o.sub_deal_flag -- 部分成交选项： 0 否 1 是
    ,o.quote_valid_tm -- 报价有效时间
    ,o.settle_time -- 最晚结算时间
    ,o.clear_speed -- 清算速度： CS00 T+0 CS01 T+1
    ,o.settle_date -- 结算日期
    ,o.settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,o.clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,o.adver_clear_mode -- 交易对手清算模式： CLE001 模式一（人行清算账户） CLE002 模式二（票交所资金账户-法人会员） CLE003 模式三（票交所资金账户-资管类会员）
    ,o.adver_brh_no -- 交易对手机构代码
    ,o.adver_pro_no -- 交易对手非法人产品号
    ,o.adver_user_id -- 交易对手交易员
    ,o.is_need_pay_confirm -- 是否需要付款确认： 0 否 1 是
    ,o.min_tenor_days -- 最短剩余期限
    ,o.max_tenor_days -- 最长剩余期限
    ,o.due_date_begin -- 票据到期起始日
    ,o.due_date_end -- 票据到期截止日
    ,o.min_draft_amt -- 最小单张票面金额
    ,o.credit_type -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,o.credit_codes -- 信用主体行别
    ,o.cust_types -- 交易对手类型
    ,o.accept_brh_types -- 承兑行类型
    ,o.accept_brh_no_list -- 承兑行
    ,o.discount_brh_no_types -- 贴现行类型
    ,o.discount_brh_no_list -- 贴现行
    ,o.guarantee_brh_types -- 保证增信行类型
    ,o.guarantee_brh_no_list -- 保证增信行
    ,o.department_no -- 所属部门
    ,o.manager_no -- 客户经理
    ,o.sum_count -- 票据张数
    ,o.sum_amount -- 票据总额
    ,o.yield_rate -- 收益率
    ,o.tenor_days -- 加权平均剩余期限
    ,o.settle_amt -- 结算金额
    ,o.pay_interest -- 应付利息
    ,o.contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送待确认 12 发送确认成功 13 发送确认失败 14 发送已收到应答(或收到通知) 21 撤销中 22 撤销成功 23 撤销失败 30 应答中 31 应答发送成功 32 应答确认成功(或收到通知) 33 应答确认失败 40 部分成交通知 41 全部成交通知 42 终止通知
    ,o.settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败 06 部分记账
    ,o.created_by -- 创建人
    ,o.last_upd_opr -- 最后修改人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.product_no -- 产品号
    ,o.deal_id -- 成交单表ID
    ,o.quote_no -- 报价单编号
    ,o.click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
    ,o.dealed_no -- 成交单编号
    ,o.forward_num -- 报价转发次数
    ,o.ck_contract_type -- 批次类型:1-发布报价,2-签收报价
    ,o.credit_check_status -- 
    ,o.i9_type -- 三分类标识
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_click_deal_contract_bk o
    left join ${iol_schema}.bdms_cpes_click_deal_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_click_deal_contract_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdms_cpes_click_deal_contract;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_click_deal_contract exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_click_deal_contract_cl;
alter table ${iol_schema}.bdms_cpes_click_deal_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_click_deal_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_click_deal_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_click_deal_contract_op purge;
drop table ${iol_schema}.bdms_cpes_click_deal_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_click_deal_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_click_deal_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
