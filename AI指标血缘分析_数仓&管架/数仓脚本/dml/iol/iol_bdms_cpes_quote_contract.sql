/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_quote_contract
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
create table ${iol_schema}.bdms_cpes_quote_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_quote_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_quote_contract_op purge;
drop table ${iol_schema}.bdms_cpes_quote_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_quote_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_quote_contract where 0=1;

create table ${iol_schema}.bdms_cpes_quote_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_quote_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_quote_contract_cl(
            id -- 
            ,top_branch_no -- 总行机构号
            ,contract_no -- 协议号
            ,apply_date -- 申请日期
            ,product_no -- 产品号
            ,cust_pro_no -- 交易对手非法人产品号
            ,cust_pro_name -- 交易对手非法人产品名称
            ,busi_date -- 
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,inner_flag -- 系统内外标识： 0 否 1 是
            ,is_send -- 是否发送报文： 0 否 1 是
            ,quote_mode -- 报价方式： 0 定向报价 1 全市场报价
            ,deal_id -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,branch_acct -- 资金账户
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,facct_no -- 
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,cust_no -- 客户号
            ,cust_user_id -- 交易员ID
            ,cust_name -- 客户名称
            ,cust_acct -- 客户帐号
            ,cust_bank_no -- 
            ,cust_brh_no -- 
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_time -- 最晚结算时间
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 利率
            ,due_rate -- 到期利率
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,yield_rate -- 收益率
            ,select_type -- 挑票类型： CSM01 单票 CSM02 票据包
            ,package_no -- 票据包编号
            ,check_status -- 检查状态
            ,credit_check_status -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,credit_no -- 额度编号
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,modify_flag -- 是否修改： 0 否 1 是
            ,created_by -- 创建人
            ,i9_type -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,bussiness_type -- 业务所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_quote_contract_op(
            id -- 
            ,top_branch_no -- 总行机构号
            ,contract_no -- 协议号
            ,apply_date -- 申请日期
            ,product_no -- 产品号
            ,cust_pro_no -- 交易对手非法人产品号
            ,cust_pro_name -- 交易对手非法人产品名称
            ,busi_date -- 
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,inner_flag -- 系统内外标识： 0 否 1 是
            ,is_send -- 是否发送报文： 0 否 1 是
            ,quote_mode -- 报价方式： 0 定向报价 1 全市场报价
            ,deal_id -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,branch_acct -- 资金账户
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,facct_no -- 
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,cust_no -- 客户号
            ,cust_user_id -- 交易员ID
            ,cust_name -- 客户名称
            ,cust_acct -- 客户帐号
            ,cust_bank_no -- 
            ,cust_brh_no -- 
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_time -- 最晚结算时间
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 利率
            ,due_rate -- 到期利率
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,yield_rate -- 收益率
            ,select_type -- 挑票类型： CSM01 单票 CSM02 票据包
            ,package_no -- 票据包编号
            ,check_status -- 检查状态
            ,credit_check_status -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,credit_no -- 额度编号
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,modify_flag -- 是否修改： 0 否 1 是
            ,created_by -- 创建人
            ,i9_type -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,bussiness_type -- 业务所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 协议号
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.cust_pro_no, o.cust_pro_no) as cust_pro_no -- 交易对手非法人产品号
    ,nvl(n.cust_pro_name, o.cust_pro_name) as cust_pro_name -- 交易对手非法人产品名称
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,nvl(n.inner_flag, o.inner_flag) as inner_flag -- 系统内外标识： 0 否 1 是
    ,nvl(n.is_send, o.is_send) as is_send -- 是否发送报文： 0 否 1 是
    ,nvl(n.quote_mode, o.quote_mode) as quote_mode -- 报价方式： 0 定向报价 1 全市场报价
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 成交单编号
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.branch_acct, o.branch_acct) as branch_acct -- 资金账户
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易员ID
    ,nvl(n.facct_no, o.facct_no) as facct_no -- 
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理
    ,nvl(n.department_no, o.department_no) as department_no -- 部门编号
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.cust_user_id, o.cust_user_id) as cust_user_id -- 交易员ID
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_acct, o.cust_acct) as cust_acct -- 客户帐号
    ,nvl(n.cust_bank_no, o.cust_bank_no) as cust_bank_no -- 
    ,nvl(n.cust_brh_no, o.cust_brh_no) as cust_brh_no -- 
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 票据张数
    ,nvl(n.sum_amount, o.sum_amount) as sum_amount -- 票据总额
    ,nvl(n.buy_back_amt, o.buy_back_amt) as buy_back_amt -- 回购金额
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 持票期限
    ,nvl(n.sub_deal_flag, o.sub_deal_flag) as sub_deal_flag -- 部分成交选项： 0 否 1 是
    ,nvl(n.quote_valid_tm, o.quote_valid_tm) as quote_valid_tm -- 报价有效时间
    ,nvl(n.clear_speed, o.clear_speed) as clear_speed -- 清算速度： CS00 T+0 CS01 T+1
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,nvl(n.settle_time, o.settle_time) as settle_time -- 最晚结算时间
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.due_settle_amt, o.due_settle_amt) as due_settle_amt -- 到期结算金额
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.due_settle_date, o.due_settle_date) as due_settle_date -- 到期结算日期
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.due_rate, o.due_rate) as due_rate -- 到期利率
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.due_pay_interest, o.due_pay_interest) as due_pay_interest -- 到期应付利息
    ,nvl(n.yield_rate, o.yield_rate) as yield_rate -- 收益率
    ,nvl(n.select_type, o.select_type) as select_type -- 挑票类型： CSM01 单票 CSM02 票据包
    ,nvl(n.package_no, o.package_no) as package_no -- 票据包编号
    ,nvl(n.check_status, o.check_status) as check_status -- 检查状态
    ,nvl(n.credit_check_status, o.credit_check_status) as credit_check_status -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,nvl(n.credit_no, o.credit_no) as credit_no -- 额度编号
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.message_status, o.message_status) as message_status -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.modify_flag, o.modify_flag) as modify_flag -- 是否修改： 0 否 1 是
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.i9_type, o.i9_type) as i9_type -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
    ,nvl(n.own_pro_no, o.own_pro_no) as own_pro_no -- 本方非法人产品
    ,nvl(n.own_pro_name, o.own_pro_name) as own_pro_name -- 本方非法人产品名称
    ,nvl(n.bussiness_type, o.bussiness_type) as bussiness_type -- 业务所属分行
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
from (select * from ${iol_schema}.bdms_cpes_quote_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_quote_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.top_branch_no <> n.top_branch_no
        or o.contract_no <> n.contract_no
        or o.apply_date <> n.apply_date
        or o.product_no <> n.product_no
        or o.cust_pro_no <> n.cust_pro_no
        or o.cust_pro_name <> n.cust_pro_name
        or o.busi_date <> n.busi_date
        or o.quote_no <> n.quote_no
        or o.busi_type <> n.busi_type
        or o.inner_flag <> n.inner_flag
        or o.is_send <> n.is_send
        or o.quote_mode <> n.quote_mode
        or o.deal_id <> n.deal_id
        or o.trade_direct <> n.trade_direct
        or o.busi_branch_no <> n.busi_branch_no
        or o.branch_acct <> n.branch_acct
        or o.acct_branch_no <> n.acct_branch_no
        or o.user_id <> n.user_id
        or o.facct_no <> n.facct_no
        or o.manager_no <> n.manager_no
        or o.department_no <> n.department_no
        or o.cust_no <> n.cust_no
        or o.cust_user_id <> n.cust_user_id
        or o.cust_name <> n.cust_name
        or o.cust_acct <> n.cust_acct
        or o.cust_bank_no <> n.cust_bank_no
        or o.cust_brh_no <> n.cust_brh_no
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.sum_count <> n.sum_count
        or o.sum_amount <> n.sum_amount
        or o.buy_back_amt <> n.buy_back_amt
        or o.tenor_days <> n.tenor_days
        or o.sub_deal_flag <> n.sub_deal_flag
        or o.quote_valid_tm <> n.quote_valid_tm
        or o.clear_speed <> n.clear_speed
        or o.clear_type <> n.clear_type
        or o.settle_time <> n.settle_time
        or o.settle_mode <> n.settle_mode
        or o.settle_amt <> n.settle_amt
        or o.due_settle_amt <> n.due_settle_amt
        or o.settle_date <> n.settle_date
        or o.due_settle_date <> n.due_settle_date
        or o.rate <> n.rate
        or o.due_rate <> n.due_rate
        or o.pay_interest <> n.pay_interest
        or o.due_pay_interest <> n.due_pay_interest
        or o.yield_rate <> n.yield_rate
        or o.select_type <> n.select_type
        or o.package_no <> n.package_no
        or o.check_status <> n.check_status
        or o.credit_check_status <> n.credit_check_status
        or o.credit_no <> n.credit_no
        or o.account_status <> n.account_status
        or o.message_status <> n.message_status
        or o.settle_status <> n.settle_status
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
        or o.contract_status <> n.contract_status
        or o.modify_flag <> n.modify_flag
        or o.created_by <> n.created_by
        or o.i9_type <> n.i9_type
        or o.own_pro_no <> n.own_pro_no
        or o.own_pro_name <> n.own_pro_name
        or o.bussiness_type <> n.bussiness_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_quote_contract_cl(
            id -- 
            ,top_branch_no -- 总行机构号
            ,contract_no -- 协议号
            ,apply_date -- 申请日期
            ,product_no -- 产品号
            ,cust_pro_no -- 交易对手非法人产品号
            ,cust_pro_name -- 交易对手非法人产品名称
            ,busi_date -- 
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,inner_flag -- 系统内外标识： 0 否 1 是
            ,is_send -- 是否发送报文： 0 否 1 是
            ,quote_mode -- 报价方式： 0 定向报价 1 全市场报价
            ,deal_id -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,branch_acct -- 资金账户
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,facct_no -- 
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,cust_no -- 客户号
            ,cust_user_id -- 交易员ID
            ,cust_name -- 客户名称
            ,cust_acct -- 客户帐号
            ,cust_bank_no -- 
            ,cust_brh_no -- 
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_time -- 最晚结算时间
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 利率
            ,due_rate -- 到期利率
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,yield_rate -- 收益率
            ,select_type -- 挑票类型： CSM01 单票 CSM02 票据包
            ,package_no -- 票据包编号
            ,check_status -- 检查状态
            ,credit_check_status -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,credit_no -- 额度编号
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,modify_flag -- 是否修改： 0 否 1 是
            ,created_by -- 创建人
            ,i9_type -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,bussiness_type -- 业务所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_quote_contract_op(
            id -- 
            ,top_branch_no -- 总行机构号
            ,contract_no -- 协议号
            ,apply_date -- 申请日期
            ,product_no -- 产品号
            ,cust_pro_no -- 交易对手非法人产品号
            ,cust_pro_name -- 交易对手非法人产品名称
            ,busi_date -- 
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,inner_flag -- 系统内外标识： 0 否 1 是
            ,is_send -- 是否发送报文： 0 否 1 是
            ,quote_mode -- 报价方式： 0 定向报价 1 全市场报价
            ,deal_id -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,branch_acct -- 资金账户
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,facct_no -- 
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,cust_no -- 客户号
            ,cust_user_id -- 交易员ID
            ,cust_name -- 客户名称
            ,cust_acct -- 客户帐号
            ,cust_bank_no -- 
            ,cust_brh_no -- 
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,sub_deal_flag -- 部分成交选项： 0 否 1 是
            ,quote_valid_tm -- 报价有效时间
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_time -- 最晚结算时间
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 利率
            ,due_rate -- 到期利率
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,yield_rate -- 收益率
            ,select_type -- 挑票类型： CSM01 单票 CSM02 票据包
            ,package_no -- 票据包编号
            ,check_status -- 检查状态
            ,credit_check_status -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,credit_no -- 额度编号
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,modify_flag -- 是否修改： 0 否 1 是
            ,created_by -- 创建人
            ,i9_type -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,bussiness_type -- 业务所属分行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.top_branch_no -- 总行机构号
    ,o.contract_no -- 协议号
    ,o.apply_date -- 申请日期
    ,o.product_no -- 产品号
    ,o.cust_pro_no -- 交易对手非法人产品号
    ,o.cust_pro_name -- 交易对手非法人产品名称
    ,o.busi_date -- 
    ,o.quote_no -- 报价单编号
    ,o.busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,o.inner_flag -- 系统内外标识： 0 否 1 是
    ,o.is_send -- 是否发送报文： 0 否 1 是
    ,o.quote_mode -- 报价方式： 0 定向报价 1 全市场报价
    ,o.deal_id -- 成交单编号
    ,o.trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
    ,o.busi_branch_no -- 业务机构号
    ,o.branch_acct -- 资金账户
    ,o.acct_branch_no -- 账务机构号
    ,o.user_id -- 交易员ID
    ,o.facct_no -- 
    ,o.manager_no -- 客户经理
    ,o.department_no -- 部门编号
    ,o.cust_no -- 客户号
    ,o.cust_user_id -- 交易员ID
    ,o.cust_name -- 客户名称
    ,o.cust_acct -- 客户帐号
    ,o.cust_bank_no -- 
    ,o.cust_brh_no -- 
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.sum_count -- 票据张数
    ,o.sum_amount -- 票据总额
    ,o.buy_back_amt -- 回购金额
    ,o.tenor_days -- 持票期限
    ,o.sub_deal_flag -- 部分成交选项： 0 否 1 是
    ,o.quote_valid_tm -- 报价有效时间
    ,o.clear_speed -- 清算速度： CS00 T+0 CS01 T+1
    ,o.clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,o.settle_time -- 最晚结算时间
    ,o.settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,o.settle_amt -- 结算金额
    ,o.due_settle_amt -- 到期结算金额
    ,o.settle_date -- 结算日期
    ,o.due_settle_date -- 到期结算日期
    ,o.rate -- 利率
    ,o.due_rate -- 到期利率
    ,o.pay_interest -- 应付利息
    ,o.due_pay_interest -- 到期应付利息
    ,o.yield_rate -- 收益率
    ,o.select_type -- 挑票类型： CSM01 单票 CSM02 票据包
    ,o.package_no -- 票据包编号
    ,o.check_status -- 检查状态
    ,o.credit_check_status -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,o.credit_no -- 额度编号
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.message_status -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
    ,o.settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.modify_flag -- 是否修改： 0 否 1 是
    ,o.created_by -- 创建人
    ,o.i9_type -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
    ,o.own_pro_no -- 本方非法人产品
    ,o.own_pro_name -- 本方非法人产品名称
    ,o.bussiness_type -- 业务所属分行
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_quote_contract_bk o
    left join ${iol_schema}.bdms_cpes_quote_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_quote_contract_cl d
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
--truncate table ${iol_schema}.bdms_cpes_quote_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_quote_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_quote_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_quote_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_quote_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_quote_contract_cl;
alter table ${iol_schema}.bdms_cpes_quote_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_quote_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_quote_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_quote_contract_op purge;
drop table ${iol_schema}.bdms_cpes_quote_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_quote_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_quote_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
