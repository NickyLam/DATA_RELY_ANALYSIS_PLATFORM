/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_buy_back_contract
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
create table ${iol_schema}.bdms_cpes_buy_back_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_buy_back_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_buy_back_contract_op purge;
drop table ${iol_schema}.bdms_cpes_buy_back_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_buy_back_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_buy_back_contract where 0=1;

create table ${iol_schema}.bdms_cpes_buy_back_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_buy_back_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_buy_back_contract_cl(
            id -- 
            ,apply_id -- APPLY表ID
            ,contract_no -- 批次号
            ,org_contract_id -- 原质押式对话报价业务批次ID
            ,org_credit_status -- 原业务额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,product_no -- 产品号
            ,buss_flag -- 业务类型： 01 申请 02 签收
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,apply_date -- 业务申请日期
            ,brh_name -- 本方机构名称
            ,brh_no -- 本方机构号
            ,adver_brh_name -- 交易对手名称
            ,adver_brh_no -- 交易对手机构号
            ,adver_bank_no -- 交易对手行行号
            ,adver_pro_no -- 交易对手非法人产品
            ,deal_no -- 成交单编号
            ,buy_back_type -- 赎回类别： BBT01 提前赎回 BBT02 逾期赎回 BBT03 部分逾期赎回
            ,buy_back_reason -- 赎回事由： BBR01 存在风险票据 BBR02 其它情形
            ,buy_back_result -- 赎回结果： 0 未完成 1 成功 2 失败
            ,req_deal_opi -- 赎回发起方处理意见
            ,sign_deal_opi -- 赎回签收方处理意见
            ,req_misc -- 赎回发起方备注
            ,sign_misc -- 赎回签收方备注
            ,apv_sign_mk -- 场务处理结果： SU00 同意 SU01 拒绝
            ,apv_opi -- 场务处理意见
            ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
            ,err_code -- 错误码
            ,err_mesg -- 错误原因
            ,department_no -- 所属部门号
            ,manage_no -- 客户经理号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,sum_amount -- 票据总额
            ,sum_count -- 票据张数
            ,org_buy_back_amount -- 原业务回购金额
            ,settle_amount -- 首期结算金额
            ,buy_back_settle_amount -- 赎回结算金额
            ,buy_back_rate -- 回购利率
            ,org_pay_interest -- 原业务应付利息
            ,buy_back_pay_interest -- 赎回应付利息
            ,buy_back_yield_rate -- 回购收益率
            ,org_settle_date -- 原业务首期结算日
            ,org_due_settle_date -- 原业务到期结算日
            ,credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0 无效 1 有效
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_buy_back_contract_op(
            id -- 
            ,apply_id -- APPLY表ID
            ,contract_no -- 批次号
            ,org_contract_id -- 原质押式对话报价业务批次ID
            ,org_credit_status -- 原业务额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,product_no -- 产品号
            ,buss_flag -- 业务类型： 01 申请 02 签收
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,apply_date -- 业务申请日期
            ,brh_name -- 本方机构名称
            ,brh_no -- 本方机构号
            ,adver_brh_name -- 交易对手名称
            ,adver_brh_no -- 交易对手机构号
            ,adver_bank_no -- 交易对手行行号
            ,adver_pro_no -- 交易对手非法人产品
            ,deal_no -- 成交单编号
            ,buy_back_type -- 赎回类别： BBT01 提前赎回 BBT02 逾期赎回 BBT03 部分逾期赎回
            ,buy_back_reason -- 赎回事由： BBR01 存在风险票据 BBR02 其它情形
            ,buy_back_result -- 赎回结果： 0 未完成 1 成功 2 失败
            ,req_deal_opi -- 赎回发起方处理意见
            ,sign_deal_opi -- 赎回签收方处理意见
            ,req_misc -- 赎回发起方备注
            ,sign_misc -- 赎回签收方备注
            ,apv_sign_mk -- 场务处理结果： SU00 同意 SU01 拒绝
            ,apv_opi -- 场务处理意见
            ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
            ,err_code -- 错误码
            ,err_mesg -- 错误原因
            ,department_no -- 所属部门号
            ,manage_no -- 客户经理号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,sum_amount -- 票据总额
            ,sum_count -- 票据张数
            ,org_buy_back_amount -- 原业务回购金额
            ,settle_amount -- 首期结算金额
            ,buy_back_settle_amount -- 赎回结算金额
            ,buy_back_rate -- 回购利率
            ,org_pay_interest -- 原业务应付利息
            ,buy_back_pay_interest -- 赎回应付利息
            ,buy_back_yield_rate -- 回购收益率
            ,org_settle_date -- 原业务首期结算日
            ,org_due_settle_date -- 原业务到期结算日
            ,credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0 无效 1 有效
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.apply_id, o.apply_id) as apply_id -- APPLY表ID
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.org_contract_id, o.org_contract_id) as org_contract_id -- 原质押式对话报价业务批次ID
    ,nvl(n.org_credit_status, o.org_credit_status) as org_credit_status -- 原业务额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.buss_flag, o.buss_flag) as buss_flag -- 业务类型： 01 申请 02 签收
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 业务申请日期
    ,nvl(n.brh_name, o.brh_name) as brh_name -- 本方机构名称
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 本方机构号
    ,nvl(n.adver_brh_name, o.adver_brh_name) as adver_brh_name -- 交易对手名称
    ,nvl(n.adver_brh_no, o.adver_brh_no) as adver_brh_no -- 交易对手机构号
    ,nvl(n.adver_bank_no, o.adver_bank_no) as adver_bank_no -- 交易对手行行号
    ,nvl(n.adver_pro_no, o.adver_pro_no) as adver_pro_no -- 交易对手非法人产品
    ,nvl(n.deal_no, o.deal_no) as deal_no -- 成交单编号
    ,nvl(n.buy_back_type, o.buy_back_type) as buy_back_type -- 赎回类别： BBT01 提前赎回 BBT02 逾期赎回 BBT03 部分逾期赎回
    ,nvl(n.buy_back_reason, o.buy_back_reason) as buy_back_reason -- 赎回事由： BBR01 存在风险票据 BBR02 其它情形
    ,nvl(n.buy_back_result, o.buy_back_result) as buy_back_result -- 赎回结果： 0 未完成 1 成功 2 失败
    ,nvl(n.req_deal_opi, o.req_deal_opi) as req_deal_opi -- 赎回发起方处理意见
    ,nvl(n.sign_deal_opi, o.sign_deal_opi) as sign_deal_opi -- 赎回签收方处理意见
    ,nvl(n.req_misc, o.req_misc) as req_misc -- 赎回发起方备注
    ,nvl(n.sign_misc, o.sign_misc) as sign_misc -- 赎回签收方备注
    ,nvl(n.apv_sign_mk, o.apv_sign_mk) as apv_sign_mk -- 场务处理结果： SU00 同意 SU01 拒绝
    ,nvl(n.apv_opi, o.apv_opi) as apv_opi -- 场务处理意见
    ,nvl(n.sign_mk, o.sign_mk) as sign_mk -- 应答标识： SU00 同意 SU01 拒绝
    ,nvl(n.err_code, o.err_code) as err_code -- 错误码
    ,nvl(n.err_mesg, o.err_mesg) as err_mesg -- 错误原因
    ,nvl(n.department_no, o.department_no) as department_no -- 所属部门号
    ,nvl(n.manage_no, o.manage_no) as manage_no -- 客户经理号
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.sum_amount, o.sum_amount) as sum_amount -- 票据总额
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 票据张数
    ,nvl(n.org_buy_back_amount, o.org_buy_back_amount) as org_buy_back_amount -- 原业务回购金额
    ,nvl(n.settle_amount, o.settle_amount) as settle_amount -- 首期结算金额
    ,nvl(n.buy_back_settle_amount, o.buy_back_settle_amount) as buy_back_settle_amount -- 赎回结算金额
    ,nvl(n.buy_back_rate, o.buy_back_rate) as buy_back_rate -- 回购利率
    ,nvl(n.org_pay_interest, o.org_pay_interest) as org_pay_interest -- 原业务应付利息
    ,nvl(n.buy_back_pay_interest, o.buy_back_pay_interest) as buy_back_pay_interest -- 赎回应付利息
    ,nvl(n.buy_back_yield_rate, o.buy_back_yield_rate) as buy_back_yield_rate -- 回购收益率
    ,nvl(n.org_settle_date, o.org_settle_date) as org_settle_date -- 原业务首期结算日
    ,nvl(n.org_due_settle_date, o.org_due_settle_date) as org_due_settle_date -- 原业务到期结算日
    ,nvl(n.credit_status, o.credit_status) as credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 有效标识： 0 无效 1 有效
    ,nvl(n.message_status, o.message_status) as message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
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
from (select * from ${iol_schema}.bdms_cpes_buy_back_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_buy_back_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.apply_id <> n.apply_id
        or o.contract_no <> n.contract_no
        or o.org_contract_id <> n.org_contract_id
        or o.org_credit_status <> n.org_credit_status
        or o.product_no <> n.product_no
        or o.buss_flag <> n.buss_flag
        or o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.apply_date <> n.apply_date
        or o.brh_name <> n.brh_name
        or o.brh_no <> n.brh_no
        or o.adver_brh_name <> n.adver_brh_name
        or o.adver_brh_no <> n.adver_brh_no
        or o.adver_bank_no <> n.adver_bank_no
        or o.adver_pro_no <> n.adver_pro_no
        or o.deal_no <> n.deal_no
        or o.buy_back_type <> n.buy_back_type
        or o.buy_back_reason <> n.buy_back_reason
        or o.buy_back_result <> n.buy_back_result
        or o.req_deal_opi <> n.req_deal_opi
        or o.sign_deal_opi <> n.sign_deal_opi
        or o.req_misc <> n.req_misc
        or o.sign_misc <> n.sign_misc
        or o.apv_sign_mk <> n.apv_sign_mk
        or o.apv_opi <> n.apv_opi
        or o.sign_mk <> n.sign_mk
        or o.err_code <> n.err_code
        or o.err_mesg <> n.err_mesg
        or o.department_no <> n.department_no
        or o.manage_no <> n.manage_no
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.sum_amount <> n.sum_amount
        or o.sum_count <> n.sum_count
        or o.org_buy_back_amount <> n.org_buy_back_amount
        or o.settle_amount <> n.settle_amount
        or o.buy_back_settle_amount <> n.buy_back_settle_amount
        or o.buy_back_rate <> n.buy_back_rate
        or o.org_pay_interest <> n.org_pay_interest
        or o.buy_back_pay_interest <> n.buy_back_pay_interest
        or o.buy_back_yield_rate <> n.buy_back_yield_rate
        or o.org_settle_date <> n.org_settle_date
        or o.org_due_settle_date <> n.org_due_settle_date
        or o.credit_status <> n.credit_status
        or o.contract_status <> n.contract_status
        or o.account_status <> n.account_status
        or o.valid_flag <> n.valid_flag
        or o.message_status <> n.message_status
        or o.settle_status <> n.settle_status
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.created_by <> n.created_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_buy_back_contract_cl(
            id -- 
            ,apply_id -- APPLY表ID
            ,contract_no -- 批次号
            ,org_contract_id -- 原质押式对话报价业务批次ID
            ,org_credit_status -- 原业务额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,product_no -- 产品号
            ,buss_flag -- 业务类型： 01 申请 02 签收
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,apply_date -- 业务申请日期
            ,brh_name -- 本方机构名称
            ,brh_no -- 本方机构号
            ,adver_brh_name -- 交易对手名称
            ,adver_brh_no -- 交易对手机构号
            ,adver_bank_no -- 交易对手行行号
            ,adver_pro_no -- 交易对手非法人产品
            ,deal_no -- 成交单编号
            ,buy_back_type -- 赎回类别： BBT01 提前赎回 BBT02 逾期赎回 BBT03 部分逾期赎回
            ,buy_back_reason -- 赎回事由： BBR01 存在风险票据 BBR02 其它情形
            ,buy_back_result -- 赎回结果： 0 未完成 1 成功 2 失败
            ,req_deal_opi -- 赎回发起方处理意见
            ,sign_deal_opi -- 赎回签收方处理意见
            ,req_misc -- 赎回发起方备注
            ,sign_misc -- 赎回签收方备注
            ,apv_sign_mk -- 场务处理结果： SU00 同意 SU01 拒绝
            ,apv_opi -- 场务处理意见
            ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
            ,err_code -- 错误码
            ,err_mesg -- 错误原因
            ,department_no -- 所属部门号
            ,manage_no -- 客户经理号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,sum_amount -- 票据总额
            ,sum_count -- 票据张数
            ,org_buy_back_amount -- 原业务回购金额
            ,settle_amount -- 首期结算金额
            ,buy_back_settle_amount -- 赎回结算金额
            ,buy_back_rate -- 回购利率
            ,org_pay_interest -- 原业务应付利息
            ,buy_back_pay_interest -- 赎回应付利息
            ,buy_back_yield_rate -- 回购收益率
            ,org_settle_date -- 原业务首期结算日
            ,org_due_settle_date -- 原业务到期结算日
            ,credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0 无效 1 有效
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_buy_back_contract_op(
            id -- 
            ,apply_id -- APPLY表ID
            ,contract_no -- 批次号
            ,org_contract_id -- 原质押式对话报价业务批次ID
            ,org_credit_status -- 原业务额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,product_no -- 产品号
            ,buss_flag -- 业务类型： 01 申请 02 签收
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,apply_date -- 业务申请日期
            ,brh_name -- 本方机构名称
            ,brh_no -- 本方机构号
            ,adver_brh_name -- 交易对手名称
            ,adver_brh_no -- 交易对手机构号
            ,adver_bank_no -- 交易对手行行号
            ,adver_pro_no -- 交易对手非法人产品
            ,deal_no -- 成交单编号
            ,buy_back_type -- 赎回类别： BBT01 提前赎回 BBT02 逾期赎回 BBT03 部分逾期赎回
            ,buy_back_reason -- 赎回事由： BBR01 存在风险票据 BBR02 其它情形
            ,buy_back_result -- 赎回结果： 0 未完成 1 成功 2 失败
            ,req_deal_opi -- 赎回发起方处理意见
            ,sign_deal_opi -- 赎回签收方处理意见
            ,req_misc -- 赎回发起方备注
            ,sign_misc -- 赎回签收方备注
            ,apv_sign_mk -- 场务处理结果： SU00 同意 SU01 拒绝
            ,apv_opi -- 场务处理意见
            ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
            ,err_code -- 错误码
            ,err_mesg -- 错误原因
            ,department_no -- 所属部门号
            ,manage_no -- 客户经理号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,sum_amount -- 票据总额
            ,sum_count -- 票据张数
            ,org_buy_back_amount -- 原业务回购金额
            ,settle_amount -- 首期结算金额
            ,buy_back_settle_amount -- 赎回结算金额
            ,buy_back_rate -- 回购利率
            ,org_pay_interest -- 原业务应付利息
            ,buy_back_pay_interest -- 赎回应付利息
            ,buy_back_yield_rate -- 回购收益率
            ,org_settle_date -- 原业务首期结算日
            ,org_due_settle_date -- 原业务到期结算日
            ,credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0 无效 1 有效
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.apply_id -- APPLY表ID
    ,o.contract_no -- 批次号
    ,o.org_contract_id -- 原质押式对话报价业务批次ID
    ,o.org_credit_status -- 原业务额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,o.product_no -- 产品号
    ,o.buss_flag -- 业务类型： 01 申请 02 签收
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.apply_date -- 业务申请日期
    ,o.brh_name -- 本方机构名称
    ,o.brh_no -- 本方机构号
    ,o.adver_brh_name -- 交易对手名称
    ,o.adver_brh_no -- 交易对手机构号
    ,o.adver_bank_no -- 交易对手行行号
    ,o.adver_pro_no -- 交易对手非法人产品
    ,o.deal_no -- 成交单编号
    ,o.buy_back_type -- 赎回类别： BBT01 提前赎回 BBT02 逾期赎回 BBT03 部分逾期赎回
    ,o.buy_back_reason -- 赎回事由： BBR01 存在风险票据 BBR02 其它情形
    ,o.buy_back_result -- 赎回结果： 0 未完成 1 成功 2 失败
    ,o.req_deal_opi -- 赎回发起方处理意见
    ,o.sign_deal_opi -- 赎回签收方处理意见
    ,o.req_misc -- 赎回发起方备注
    ,o.sign_misc -- 赎回签收方备注
    ,o.apv_sign_mk -- 场务处理结果： SU00 同意 SU01 拒绝
    ,o.apv_opi -- 场务处理意见
    ,o.sign_mk -- 应答标识： SU00 同意 SU01 拒绝
    ,o.err_code -- 错误码
    ,o.err_mesg -- 错误原因
    ,o.department_no -- 所属部门号
    ,o.manage_no -- 客户经理号
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.sum_amount -- 票据总额
    ,o.sum_count -- 票据张数
    ,o.org_buy_back_amount -- 原业务回购金额
    ,o.settle_amount -- 首期结算金额
    ,o.buy_back_settle_amount -- 赎回结算金额
    ,o.buy_back_rate -- 回购利率
    ,o.org_pay_interest -- 原业务应付利息
    ,o.buy_back_pay_interest -- 赎回应付利息
    ,o.buy_back_yield_rate -- 回购收益率
    ,o.org_settle_date -- 原业务首期结算日
    ,o.org_due_settle_date -- 原业务到期结算日
    ,o.credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,o.contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.valid_flag -- 有效标识： 0 无效 1 有效
    ,o.message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,o.settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.created_by -- 创建人
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
from ${iol_schema}.bdms_cpes_buy_back_contract_bk o
    left join ${iol_schema}.bdms_cpes_buy_back_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_buy_back_contract_cl d
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
--truncate table ${iol_schema}.bdms_cpes_buy_back_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_buy_back_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_buy_back_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_buy_back_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_buy_back_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_buy_back_contract_cl;
alter table ${iol_schema}.bdms_cpes_buy_back_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_buy_back_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_buy_back_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_buy_back_contract_op purge;
drop table ${iol_schema}.bdms_cpes_buy_back_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_buy_back_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_buy_back_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
