/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_anoclick_quote_contract
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
create table ${iol_schema}.bdms_cpes_anoclick_quote_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_anoclick_quote_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_anoclick_quote_contract_op purge;
drop table ${iol_schema}.bdms_cpes_anoclick_quote_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_anoclick_quote_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_anoclick_quote_contract where 0=1;

create table ${iol_schema}.bdms_cpes_anoclick_quote_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_anoclick_quote_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_anoclick_quote_contract_cl(
            id -- ID
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,busi_date -- 业务日期
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
            ,top_branch_no -- 总行机构号
            ,busi_branch_no -- 业务机构号
            ,own_user_id -- 我方交易员
            ,draft_type -- 票据类型 AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,rebuy_rate -- 回购利率
            ,rebuy_amt -- 回购金额
            ,rebuy_tenor_days -- 回购期限
            ,tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
            ,settle_date -- 首期结算日
            ,due_settle_date -- 到期结算日
            ,clear_speed -- 清算速度 CS00 T+0 CS01 T+1
            ,settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
            ,credit_type -- 信用主体类型  201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
            ,quote_no -- 报价单编号
            ,quote_status -- 报价单状态： AQS01 已保存 AQS02 已发送 AQS03 全部成交 AQS05 已作废 AQS06 发送待确认 AQS07 建立失败 AQS08 部分撤销待确认 AQS09 全部撤销待确认 AQS10 已部分撤销 AQS11 已全部撤销 AQS12 部分成交
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,i9_type -- 三分类标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_anoclick_quote_contract_op(
            id -- ID
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,busi_date -- 业务日期
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
            ,top_branch_no -- 总行机构号
            ,busi_branch_no -- 业务机构号
            ,own_user_id -- 我方交易员
            ,draft_type -- 票据类型 AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,rebuy_rate -- 回购利率
            ,rebuy_amt -- 回购金额
            ,rebuy_tenor_days -- 回购期限
            ,tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
            ,settle_date -- 首期结算日
            ,due_settle_date -- 到期结算日
            ,clear_speed -- 清算速度 CS00 T+0 CS01 T+1
            ,settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
            ,credit_type -- 信用主体类型  201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
            ,quote_no -- 报价单编号
            ,quote_status -- 报价单状态： AQS01 已保存 AQS02 已发送 AQS03 全部成交 AQS05 已作废 AQS06 发送待确认 AQS07 建立失败 AQS08 部分撤销待确认 AQS09 全部撤销待确认 AQS10 已部分撤销 AQS11 已全部撤销 AQS12 部分成交
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,i9_type -- 三分类标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 业务日期
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.own_user_id, o.own_user_id) as own_user_id -- 我方交易员
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型 AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.rebuy_rate, o.rebuy_rate) as rebuy_rate -- 回购利率
    ,nvl(n.rebuy_amt, o.rebuy_amt) as rebuy_amt -- 回购金额
    ,nvl(n.rebuy_tenor_days, o.rebuy_tenor_days) as rebuy_tenor_days -- 回购期限
    ,nvl(n.tenor_code, o.tenor_code) as tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 首期结算日
    ,nvl(n.due_settle_date, o.due_settle_date) as due_settle_date -- 到期结算日
    ,nvl(n.clear_speed, o.clear_speed) as clear_speed -- 清算速度 CS00 T+0 CS01 T+1
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
    ,nvl(n.credit_type, o.credit_type) as credit_type -- 信用主体类型  201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,nvl(n.department_no, o.department_no) as department_no -- 所属部门
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.message_status, o.message_status) as message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.quote_status, o.quote_status) as quote_status -- 报价单状态： AQS01 已保存 AQS02 已发送 AQS03 全部成交 AQS05 已作废 AQS06 发送待确认 AQS07 建立失败 AQS08 部分撤销待确认 AQS09 全部撤销待确认 AQS10 已部分撤销 AQS11 已全部撤销 AQS12 部分成交
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后修改人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
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
from (select * from ${iol_schema}.bdms_cpes_anoclick_quote_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_anoclick_quote_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.product_no <> n.product_no
        or o.busi_date <> n.busi_date
        or o.busi_type <> n.busi_type
        or o.trade_direct <> n.trade_direct
        or o.top_branch_no <> n.top_branch_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.own_user_id <> n.own_user_id
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.rebuy_rate <> n.rebuy_rate
        or o.rebuy_amt <> n.rebuy_amt
        or o.rebuy_tenor_days <> n.rebuy_tenor_days
        or o.tenor_code <> n.tenor_code
        or o.settle_date <> n.settle_date
        or o.due_settle_date <> n.due_settle_date
        or o.clear_speed <> n.clear_speed
        or o.settle_mode <> n.settle_mode
        or o.clear_type <> n.clear_type
        or o.credit_type <> n.credit_type
        or o.department_no <> n.department_no
        or o.manager_no <> n.manager_no
        or o.contract_status <> n.contract_status
        or o.message_status <> n.message_status
        or o.quote_no <> n.quote_no
        or o.quote_status <> n.quote_status
        or o.created_by <> n.created_by
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
        or o.i9_type <> n.i9_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_anoclick_quote_contract_cl(
            id -- ID
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,busi_date -- 业务日期
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
            ,top_branch_no -- 总行机构号
            ,busi_branch_no -- 业务机构号
            ,own_user_id -- 我方交易员
            ,draft_type -- 票据类型 AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,rebuy_rate -- 回购利率
            ,rebuy_amt -- 回购金额
            ,rebuy_tenor_days -- 回购期限
            ,tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
            ,settle_date -- 首期结算日
            ,due_settle_date -- 到期结算日
            ,clear_speed -- 清算速度 CS00 T+0 CS01 T+1
            ,settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
            ,credit_type -- 信用主体类型  201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
            ,quote_no -- 报价单编号
            ,quote_status -- 报价单状态： AQS01 已保存 AQS02 已发送 AQS03 全部成交 AQS05 已作废 AQS06 发送待确认 AQS07 建立失败 AQS08 部分撤销待确认 AQS09 全部撤销待确认 AQS10 已部分撤销 AQS11 已全部撤销 AQS12 部分成交
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,i9_type -- 三分类标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_anoclick_quote_contract_op(
            id -- ID
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,busi_date -- 业务日期
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
            ,top_branch_no -- 总行机构号
            ,busi_branch_no -- 业务机构号
            ,own_user_id -- 我方交易员
            ,draft_type -- 票据类型 AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,rebuy_rate -- 回购利率
            ,rebuy_amt -- 回购金额
            ,rebuy_tenor_days -- 回购期限
            ,tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
            ,settle_date -- 首期结算日
            ,due_settle_date -- 到期结算日
            ,clear_speed -- 清算速度 CS00 T+0 CS01 T+1
            ,settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
            ,credit_type -- 信用主体类型  201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
            ,quote_no -- 报价单编号
            ,quote_status -- 报价单状态： AQS01 已保存 AQS02 已发送 AQS03 全部成交 AQS05 已作废 AQS06 发送待确认 AQS07 建立失败 AQS08 部分撤销待确认 AQS09 全部撤销待确认 AQS10 已部分撤销 AQS11 已全部撤销 AQS12 部分成交
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,i9_type -- 三分类标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_no -- 批次号
    ,o.product_no -- 产品号
    ,o.busi_date -- 业务日期
    ,o.busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,o.trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
    ,o.top_branch_no -- 总行机构号
    ,o.busi_branch_no -- 业务机构号
    ,o.own_user_id -- 我方交易员
    ,o.draft_type -- 票据类型 AC01 银承 AC02 商承
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.rebuy_rate -- 回购利率
    ,o.rebuy_amt -- 回购金额
    ,o.rebuy_tenor_days -- 回购期限
    ,o.tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
    ,o.settle_date -- 首期结算日
    ,o.due_settle_date -- 到期结算日
    ,o.clear_speed -- 清算速度 CS00 T+0 CS01 T+1
    ,o.settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,o.clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
    ,o.credit_type -- 信用主体类型  201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,o.department_no -- 所属部门
    ,o.manager_no -- 客户经理
    ,o.contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
    ,o.quote_no -- 报价单编号
    ,o.quote_status -- 报价单状态： AQS01 已保存 AQS02 已发送 AQS03 全部成交 AQS05 已作废 AQS06 发送待确认 AQS07 建立失败 AQS08 部分撤销待确认 AQS09 全部撤销待确认 AQS10 已部分撤销 AQS11 已全部撤销 AQS12 部分成交
    ,o.created_by -- 创建人
    ,o.last_upd_opr -- 最后修改人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.i9_type -- 三分类标识
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
from ${iol_schema}.bdms_cpes_anoclick_quote_contract_bk o
    left join ${iol_schema}.bdms_cpes_anoclick_quote_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_anoclick_quote_contract_cl d
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
--truncate table ${iol_schema}.bdms_cpes_anoclick_quote_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_anoclick_quote_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_anoclick_quote_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_anoclick_quote_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_anoclick_quote_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_anoclick_quote_contract_cl;
alter table ${iol_schema}.bdms_cpes_anoclick_quote_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_anoclick_quote_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_anoclick_quote_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_anoclick_quote_contract_op purge;
drop table ${iol_schema}.bdms_cpes_anoclick_quote_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_anoclick_quote_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_anoclick_quote_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
