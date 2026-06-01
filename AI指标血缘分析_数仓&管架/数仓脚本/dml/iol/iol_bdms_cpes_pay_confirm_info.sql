/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_pay_confirm_info
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
create table ${iol_schema}.bdms_cpes_pay_confirm_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_pay_confirm_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_pay_confirm_info_op purge;
drop table ${iol_schema}.bdms_cpes_pay_confirm_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_pay_confirm_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_pay_confirm_info where 0=1;

create table ${iol_schema}.bdms_cpes_pay_confirm_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_pay_confirm_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_pay_confirm_info_cl(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 业务机构号
            ,product_no -- 产品号
            ,buss_flag -- 交易方向标识： 01 申请 02 签收
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,apply_date -- 申请日期
            ,pay_confirm_name -- 交易对手名称
            ,pay_confirm_brh_no -- 交易对手机构代码
            ,pay_confirm_acct_no -- 交易对手账号
            ,pay_confirm_address -- 交易对手地址
            ,pay_confirm_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
            ,pay_confirm_add_type -- 付款确认申请类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
            ,conf_pay_apv_opi -- 付款确认审批意见
            ,draft_id -- 票据ID
            ,apply_id -- 任务池表ID
            ,sign_mk -- 签收标识： SU00 同意 SU01 拒绝
            ,sign_date -- 签收日期
            ,refuse_reason -- 拒绝原因代码： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,ems_no -- EMS编号
            ,deal_status -- 处理状态： 00 无效 01 未检查完成 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后操作员号
            ,last_upd_time -- 最后操作时间
            ,misc -- 备注域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_pay_confirm_info_op(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 业务机构号
            ,product_no -- 产品号
            ,buss_flag -- 交易方向标识： 01 申请 02 签收
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,apply_date -- 申请日期
            ,pay_confirm_name -- 交易对手名称
            ,pay_confirm_brh_no -- 交易对手机构代码
            ,pay_confirm_acct_no -- 交易对手账号
            ,pay_confirm_address -- 交易对手地址
            ,pay_confirm_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
            ,pay_confirm_add_type -- 付款确认申请类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
            ,conf_pay_apv_opi -- 付款确认审批意见
            ,draft_id -- 票据ID
            ,apply_id -- 任务池表ID
            ,sign_mk -- 签收标识： SU00 同意 SU01 拒绝
            ,sign_date -- 签收日期
            ,refuse_reason -- 拒绝原因代码： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,ems_no -- EMS编号
            ,deal_status -- 处理状态： 00 无效 01 未检查完成 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后操作员号
            ,last_upd_time -- 最后操作时间
            ,misc -- 备注域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 业务机构号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.buss_flag, o.buss_flag) as buss_flag -- 交易方向标识： 01 申请 02 签收
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.pay_confirm_name, o.pay_confirm_name) as pay_confirm_name -- 交易对手名称
    ,nvl(n.pay_confirm_brh_no, o.pay_confirm_brh_no) as pay_confirm_brh_no -- 交易对手机构代码
    ,nvl(n.pay_confirm_acct_no, o.pay_confirm_acct_no) as pay_confirm_acct_no -- 交易对手账号
    ,nvl(n.pay_confirm_address, o.pay_confirm_address) as pay_confirm_address -- 交易对手地址
    ,nvl(n.pay_confirm_type, o.pay_confirm_type) as pay_confirm_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,nvl(n.pay_confirm_add_type, o.pay_confirm_add_type) as pay_confirm_add_type -- 付款确认申请类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,nvl(n.conf_pay_apv_opi, o.conf_pay_apv_opi) as conf_pay_apv_opi -- 付款确认审批意见
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 任务池表ID
    ,nvl(n.sign_mk, o.sign_mk) as sign_mk -- 签收标识： SU00 同意 SU01 拒绝
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签收日期
    ,nvl(n.refuse_reason, o.refuse_reason) as refuse_reason -- 拒绝原因代码： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,nvl(n.ems_no, o.ems_no) as ems_no -- EMS编号
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 处理状态： 00 无效 01 未检查完成 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
    ,nvl(n.message_status, o.message_status) as message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.err_code, o.err_code) as err_code -- 错误码
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 错误信息
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员号
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后操作时间
    ,nvl(n.misc, o.misc) as misc -- 备注域
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
from (select * from ${iol_schema}.bdms_cpes_pay_confirm_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_pay_confirm_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.branch_no <> n.branch_no
        or o.product_no <> n.product_no
        or o.buss_flag <> n.buss_flag
        or o.draft_type <> n.draft_type
        or o.apply_date <> n.apply_date
        or o.pay_confirm_name <> n.pay_confirm_name
        or o.pay_confirm_brh_no <> n.pay_confirm_brh_no
        or o.pay_confirm_acct_no <> n.pay_confirm_acct_no
        or o.pay_confirm_address <> n.pay_confirm_address
        or o.pay_confirm_type <> n.pay_confirm_type
        or o.pay_confirm_add_type <> n.pay_confirm_add_type
        or o.conf_pay_apv_opi <> n.conf_pay_apv_opi
        or o.draft_id <> n.draft_id
        or o.apply_id <> n.apply_id
        or o.sign_mk <> n.sign_mk
        or o.sign_date <> n.sign_date
        or o.refuse_reason <> n.refuse_reason
        or o.ems_no <> n.ems_no
        or o.deal_status <> n.deal_status
        or o.message_status <> n.message_status
        or o.account_status <> n.account_status
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_pay_confirm_info_cl(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 业务机构号
            ,product_no -- 产品号
            ,buss_flag -- 交易方向标识： 01 申请 02 签收
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,apply_date -- 申请日期
            ,pay_confirm_name -- 交易对手名称
            ,pay_confirm_brh_no -- 交易对手机构代码
            ,pay_confirm_acct_no -- 交易对手账号
            ,pay_confirm_address -- 交易对手地址
            ,pay_confirm_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
            ,pay_confirm_add_type -- 付款确认申请类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
            ,conf_pay_apv_opi -- 付款确认审批意见
            ,draft_id -- 票据ID
            ,apply_id -- 任务池表ID
            ,sign_mk -- 签收标识： SU00 同意 SU01 拒绝
            ,sign_date -- 签收日期
            ,refuse_reason -- 拒绝原因代码： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,ems_no -- EMS编号
            ,deal_status -- 处理状态： 00 无效 01 未检查完成 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后操作员号
            ,last_upd_time -- 最后操作时间
            ,misc -- 备注域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_pay_confirm_info_op(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 业务机构号
            ,product_no -- 产品号
            ,buss_flag -- 交易方向标识： 01 申请 02 签收
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,apply_date -- 申请日期
            ,pay_confirm_name -- 交易对手名称
            ,pay_confirm_brh_no -- 交易对手机构代码
            ,pay_confirm_acct_no -- 交易对手账号
            ,pay_confirm_address -- 交易对手地址
            ,pay_confirm_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
            ,pay_confirm_add_type -- 付款确认申请类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
            ,conf_pay_apv_opi -- 付款确认审批意见
            ,draft_id -- 票据ID
            ,apply_id -- 任务池表ID
            ,sign_mk -- 签收标识： SU00 同意 SU01 拒绝
            ,sign_date -- 签收日期
            ,refuse_reason -- 拒绝原因代码： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,ems_no -- EMS编号
            ,deal_status -- 处理状态： 00 无效 01 未检查完成 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
            ,message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后操作员号
            ,last_upd_time -- 最后操作时间
            ,misc -- 备注域
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 业务机构号
    ,o.product_no -- 产品号
    ,o.buss_flag -- 交易方向标识： 01 申请 02 签收
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.apply_date -- 申请日期
    ,o.pay_confirm_name -- 交易对手名称
    ,o.pay_confirm_brh_no -- 交易对手机构代码
    ,o.pay_confirm_acct_no -- 交易对手账号
    ,o.pay_confirm_address -- 交易对手地址
    ,o.pay_confirm_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,o.pay_confirm_add_type -- 付款确认申请类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,o.conf_pay_apv_opi -- 付款确认审批意见
    ,o.draft_id -- 票据ID
    ,o.apply_id -- 任务池表ID
    ,o.sign_mk -- 签收标识： SU00 同意 SU01 拒绝
    ,o.sign_date -- 签收日期
    ,o.refuse_reason -- 拒绝原因代码： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,o.ems_no -- EMS编号
    ,o.deal_status -- 处理状态： 00 无效 01 未检查完成 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
    ,o.message_status -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.err_code -- 错误码
    ,o.err_msg -- 错误信息
    ,o.last_upd_opr -- 最后操作员号
    ,o.last_upd_time -- 最后操作时间
    ,o.misc -- 备注域
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_pay_confirm_info_bk o
    left join ${iol_schema}.bdms_cpes_pay_confirm_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_pay_confirm_info_cl d
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
-- truncate table ${iol_schema}.bdms_cpes_pay_confirm_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_pay_confirm_info exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_pay_confirm_info_cl;
alter table ${iol_schema}.bdms_cpes_pay_confirm_info exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_pay_confirm_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_pay_confirm_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_pay_confirm_info_op purge;
drop table ${iol_schema}.bdms_cpes_pay_confirm_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_pay_confirm_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_pay_confirm_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
