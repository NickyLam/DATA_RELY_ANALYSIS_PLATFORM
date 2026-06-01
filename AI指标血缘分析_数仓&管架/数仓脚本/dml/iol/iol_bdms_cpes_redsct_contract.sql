/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_redsct_contract
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
create table ${iol_schema}.bdms_cpes_redsct_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_redsct_contract;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_redsct_contract_op purge;
drop table ${iol_schema}.bdms_cpes_redsct_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_redsct_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_redsct_contract where 0=1;

create table ${iol_schema}.bdms_cpes_redsct_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_redsct_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_redsct_contract_cl(
            id -- 
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,deal_no -- 成交单编号
            ,quote_no -- 报价单编号
            ,ref_apply_no -- 申请单修改关联号
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,recept_brh_id -- 承接行机构代码
            ,apply_date -- 业务申请日期
            ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
            ,trader_id -- 交易员ID
            ,cfm_trader_id -- 确认人ID
            ,pbc_brh_no -- 人行机构代码
            ,acpt_user_id -- 人行机构受理人用户ID
            ,acpt_user_name -- 人行机构受理人名称
            ,acpt_user_note -- 受理审核人审批意见
            ,complete_user_id -- 人行机构复核人用户ID
            ,complete_user_name -- 人行机构复核人名称
            ,complete_user_note -- 复核人审批意见
            ,approval_user_id -- 人行机构审批人用户ID
            ,approval_user_name -- 人行机构审批人名称
            ,approval_user_note -- 审批人审批意见
            ,draft_type -- 票据类型：AC01-银承 AC02-商承
            ,draft_attr -- 票据介质：ME01-纸票 ME02-电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 再贴现利率
            ,pay_interest -- 应付利息
            ,department_no -- 部门编号
            ,manager_no -- 客户经理
            ,approve_result -- 审批结果： SU00 同意 SU01 拒绝
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文处理状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,created_by -- 创建人
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,status -- id
            ,due_pay_interest -- 到期应付利息
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_redsct_contract_op(
            id -- 
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,deal_no -- 成交单编号
            ,quote_no -- 报价单编号
            ,ref_apply_no -- 申请单修改关联号
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,recept_brh_id -- 承接行机构代码
            ,apply_date -- 业务申请日期
            ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
            ,trader_id -- 交易员ID
            ,cfm_trader_id -- 确认人ID
            ,pbc_brh_no -- 人行机构代码
            ,acpt_user_id -- 人行机构受理人用户ID
            ,acpt_user_name -- 人行机构受理人名称
            ,acpt_user_note -- 受理审核人审批意见
            ,complete_user_id -- 人行机构复核人用户ID
            ,complete_user_name -- 人行机构复核人名称
            ,complete_user_note -- 复核人审批意见
            ,approval_user_id -- 人行机构审批人用户ID
            ,approval_user_name -- 人行机构审批人名称
            ,approval_user_note -- 审批人审批意见
            ,draft_type -- 票据类型：AC01-银承 AC02-商承
            ,draft_attr -- 票据介质：ME01-纸票 ME02-电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 再贴现利率
            ,pay_interest -- 应付利息
            ,department_no -- 部门编号
            ,manager_no -- 客户经理
            ,approve_result -- 审批结果： SU00 同意 SU01 拒绝
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文处理状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,created_by -- 创建人
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,status -- id
            ,due_pay_interest -- 到期应付利息
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.deal_no, o.deal_no) as deal_no -- 成交单编号
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.ref_apply_no, o.ref_apply_no) as ref_apply_no -- 申请单修改关联号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.recept_brh_id, o.recept_brh_id) as recept_brh_id -- 承接行机构代码
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 业务申请日期
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,nvl(n.trader_id, o.trader_id) as trader_id -- 交易员ID
    ,nvl(n.cfm_trader_id, o.cfm_trader_id) as cfm_trader_id -- 确认人ID
    ,nvl(n.pbc_brh_no, o.pbc_brh_no) as pbc_brh_no -- 人行机构代码
    ,nvl(n.acpt_user_id, o.acpt_user_id) as acpt_user_id -- 人行机构受理人用户ID
    ,nvl(n.acpt_user_name, o.acpt_user_name) as acpt_user_name -- 人行机构受理人名称
    ,nvl(n.acpt_user_note, o.acpt_user_note) as acpt_user_note -- 受理审核人审批意见
    ,nvl(n.complete_user_id, o.complete_user_id) as complete_user_id -- 人行机构复核人用户ID
    ,nvl(n.complete_user_name, o.complete_user_name) as complete_user_name -- 人行机构复核人名称
    ,nvl(n.complete_user_note, o.complete_user_note) as complete_user_note -- 复核人审批意见
    ,nvl(n.approval_user_id, o.approval_user_id) as approval_user_id -- 人行机构审批人用户ID
    ,nvl(n.approval_user_name, o.approval_user_name) as approval_user_name -- 人行机构审批人名称
    ,nvl(n.approval_user_note, o.approval_user_note) as approval_user_note -- 审批人审批意见
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型：AC01-银承 AC02-商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质：ME01-纸票 ME02-电票
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 票据张数
    ,nvl(n.sum_amount, o.sum_amount) as sum_amount -- 票据总额
    ,nvl(n.buy_back_amt, o.buy_back_amt) as buy_back_amt -- 回购金额
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 持票期限
    ,nvl(n.clear_speed, o.clear_speed) as clear_speed -- 清算速度： CS00 T+0 CS01 T+1
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.due_settle_amt, o.due_settle_amt) as due_settle_amt -- 到期结算金额
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.due_settle_date, o.due_settle_date) as due_settle_date -- 到期结算日期
    ,nvl(n.rate, o.rate) as rate -- 再贴现利率
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.department_no, o.department_no) as department_no -- 部门编号
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理
    ,nvl(n.approve_result, o.approve_result) as approve_result -- 审批结果： SU00 同意 SU01 拒绝
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.message_status, o.message_status) as message_status -- 报文处理状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.status, o.status) as status -- id
    ,nvl(n.due_pay_interest, o.due_pay_interest) as due_pay_interest -- 到期应付利息
    ,nvl(n.own_pro_no, o.own_pro_no) as own_pro_no -- 本方非法人产品
    ,nvl(n.own_pro_name, o.own_pro_name) as own_pro_name -- 本方非法人产品名称
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
from (select * from ${iol_schema}.bdms_cpes_redsct_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_redsct_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.deal_no <> n.deal_no
        or o.quote_no <> n.quote_no
        or o.ref_apply_no <> n.ref_apply_no
        or o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.recept_brh_id <> n.recept_brh_id
        or o.apply_date <> n.apply_date
        or o.busi_type <> n.busi_type
        or o.trader_id <> n.trader_id
        or o.cfm_trader_id <> n.cfm_trader_id
        or o.pbc_brh_no <> n.pbc_brh_no
        or o.acpt_user_id <> n.acpt_user_id
        or o.acpt_user_name <> n.acpt_user_name
        or o.acpt_user_note <> n.acpt_user_note
        or o.complete_user_id <> n.complete_user_id
        or o.complete_user_name <> n.complete_user_name
        or o.complete_user_note <> n.complete_user_note
        or o.approval_user_id <> n.approval_user_id
        or o.approval_user_name <> n.approval_user_name
        or o.approval_user_note <> n.approval_user_note
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.sum_count <> n.sum_count
        or o.sum_amount <> n.sum_amount
        or o.buy_back_amt <> n.buy_back_amt
        or o.tenor_days <> n.tenor_days
        or o.clear_speed <> n.clear_speed
        or o.clear_type <> n.clear_type
        or o.settle_mode <> n.settle_mode
        or o.settle_amt <> n.settle_amt
        or o.due_settle_amt <> n.due_settle_amt
        or o.settle_date <> n.settle_date
        or o.due_settle_date <> n.due_settle_date
        or o.rate <> n.rate
        or o.pay_interest <> n.pay_interest
        or o.department_no <> n.department_no
        or o.manager_no <> n.manager_no
        or o.approve_result <> n.approve_result
        or o.contract_status <> n.contract_status
        or o.message_status <> n.message_status
        or o.settle_status <> n.settle_status
        or o.account_status <> n.account_status
        or o.created_by <> n.created_by
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.status <> n.status
        or o.due_pay_interest <> n.due_pay_interest
        or o.own_pro_no <> n.own_pro_no
        or o.own_pro_name <> n.own_pro_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_redsct_contract_cl(
            id -- 
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,deal_no -- 成交单编号
            ,quote_no -- 报价单编号
            ,ref_apply_no -- 申请单修改关联号
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,recept_brh_id -- 承接行机构代码
            ,apply_date -- 业务申请日期
            ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
            ,trader_id -- 交易员ID
            ,cfm_trader_id -- 确认人ID
            ,pbc_brh_no -- 人行机构代码
            ,acpt_user_id -- 人行机构受理人用户ID
            ,acpt_user_name -- 人行机构受理人名称
            ,acpt_user_note -- 受理审核人审批意见
            ,complete_user_id -- 人行机构复核人用户ID
            ,complete_user_name -- 人行机构复核人名称
            ,complete_user_note -- 复核人审批意见
            ,approval_user_id -- 人行机构审批人用户ID
            ,approval_user_name -- 人行机构审批人名称
            ,approval_user_note -- 审批人审批意见
            ,draft_type -- 票据类型：AC01-银承 AC02-商承
            ,draft_attr -- 票据介质：ME01-纸票 ME02-电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 再贴现利率
            ,pay_interest -- 应付利息
            ,department_no -- 部门编号
            ,manager_no -- 客户经理
            ,approve_result -- 审批结果： SU00 同意 SU01 拒绝
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文处理状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,created_by -- 创建人
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,status -- id
            ,due_pay_interest -- 到期应付利息
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_redsct_contract_op(
            id -- 
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,deal_no -- 成交单编号
            ,quote_no -- 报价单编号
            ,ref_apply_no -- 申请单修改关联号
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,recept_brh_id -- 承接行机构代码
            ,apply_date -- 业务申请日期
            ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
            ,trader_id -- 交易员ID
            ,cfm_trader_id -- 确认人ID
            ,pbc_brh_no -- 人行机构代码
            ,acpt_user_id -- 人行机构受理人用户ID
            ,acpt_user_name -- 人行机构受理人名称
            ,acpt_user_note -- 受理审核人审批意见
            ,complete_user_id -- 人行机构复核人用户ID
            ,complete_user_name -- 人行机构复核人名称
            ,complete_user_note -- 复核人审批意见
            ,approval_user_id -- 人行机构审批人用户ID
            ,approval_user_name -- 人行机构审批人名称
            ,approval_user_note -- 审批人审批意见
            ,draft_type -- 票据类型：AC01-银承 AC02-商承
            ,draft_attr -- 票据介质：ME01-纸票 ME02-电票
            ,sum_count -- 票据张数
            ,sum_amount -- 票据总额
            ,buy_back_amt -- 回购金额
            ,tenor_days -- 持票期限
            ,clear_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 结算日期
            ,due_settle_date -- 到期结算日期
            ,rate -- 再贴现利率
            ,pay_interest -- 应付利息
            ,department_no -- 部门编号
            ,manager_no -- 客户经理
            ,approve_result -- 审批结果： SU00 同意 SU01 拒绝
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文处理状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
            ,settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,created_by -- 创建人
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,status -- id
            ,due_pay_interest -- 到期应付利息
            ,own_pro_no -- 本方非法人产品
            ,own_pro_name -- 本方非法人产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_no -- 批次号
    ,o.product_no -- 产品号
    ,o.deal_no -- 成交单编号
    ,o.quote_no -- 报价单编号
    ,o.ref_apply_no -- 申请单修改关联号
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.recept_brh_id -- 承接行机构代码
    ,o.apply_date -- 业务申请日期
    ,o.busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,o.trader_id -- 交易员ID
    ,o.cfm_trader_id -- 确认人ID
    ,o.pbc_brh_no -- 人行机构代码
    ,o.acpt_user_id -- 人行机构受理人用户ID
    ,o.acpt_user_name -- 人行机构受理人名称
    ,o.acpt_user_note -- 受理审核人审批意见
    ,o.complete_user_id -- 人行机构复核人用户ID
    ,o.complete_user_name -- 人行机构复核人名称
    ,o.complete_user_note -- 复核人审批意见
    ,o.approval_user_id -- 人行机构审批人用户ID
    ,o.approval_user_name -- 人行机构审批人名称
    ,o.approval_user_note -- 审批人审批意见
    ,o.draft_type -- 票据类型：AC01-银承 AC02-商承
    ,o.draft_attr -- 票据介质：ME01-纸票 ME02-电票
    ,o.sum_count -- 票据张数
    ,o.sum_amount -- 票据总额
    ,o.buy_back_amt -- 回购金额
    ,o.tenor_days -- 持票期限
    ,o.clear_speed -- 清算速度： CS00 T+0 CS01 T+1
    ,o.clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,o.settle_mode -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,o.settle_amt -- 结算金额
    ,o.due_settle_amt -- 到期结算金额
    ,o.settle_date -- 结算日期
    ,o.due_settle_date -- 到期结算日期
    ,o.rate -- 再贴现利率
    ,o.pay_interest -- 应付利息
    ,o.department_no -- 部门编号
    ,o.manager_no -- 客户经理
    ,o.approve_result -- 审批结果： SU00 同意 SU01 拒绝
    ,o.contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.message_status -- 报文处理状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
    ,o.settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.created_by -- 创建人
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.status -- id
    ,o.due_pay_interest -- 到期应付利息
    ,o.own_pro_no -- 本方非法人产品
    ,o.own_pro_name -- 本方非法人产品名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_redsct_contract_bk o
    left join ${iol_schema}.bdms_cpes_redsct_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_redsct_contract_cl d
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
-- truncate table ${iol_schema}.bdms_cpes_redsct_contract;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_redsct_contract exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_redsct_contract_cl;
alter table ${iol_schema}.bdms_cpes_redsct_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_redsct_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_redsct_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_redsct_contract_op purge;
drop table ${iol_schema}.bdms_cpes_redsct_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_redsct_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_redsct_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
