/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_dpst_draft_details
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
create table ${iol_schema}.bdms_cpes_dpst_draft_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_dpst_draft_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_dpst_draft_details_op purge;
drop table ${iol_schema}.bdms_cpes_dpst_draft_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_dpst_draft_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_dpst_draft_details where 0=1;

create table ${iol_schema}.bdms_cpes_dpst_draft_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_dpst_draft_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_dpst_draft_details_cl(
            id -- ID
            ,dpst_id -- 存托申请表ID
            ,contract_id -- 批次ID
            ,apply_id -- 存托申请单编号
            ,draft_id -- 票据表ID
            ,draft_number -- 票号
            ,draft_amount -- 票据金额
            ,maturity_date -- 到期日
            ,bp_no -- 票据包编号
            ,bp_range -- 子票据区间号
            ,dpst_range -- 存托区间
            ,discount_date -- 贴现日
            ,remit_date -- 出票日
            ,remitter_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,discount_brh_no -- 贴现行机构代码
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 承兑人开户行（确认）机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证人机构代码
            ,tenor_day -- 剩余期限
            ,bp_amount -- 票据包金额
            ,dpst_amount -- 存托金额
            ,dpst_number -- 存托数量
            ,bp_std_amount -- 标准金额
            ,pay_interest -- 应付利息
            ,adjust_pay_interest -- 调整后应付利息
            ,settle_amount -- 结算金额
            ,bp_due_date -- 票据包到期日
            ,valid_flag -- 有效标识： 0 否 1 是
            ,wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,proc_code -- 返回码
            ,proc_msg -- 返回结果
            ,wthd_info -- 退票说明
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_dpst_draft_details_op(
            id -- ID
            ,dpst_id -- 存托申请表ID
            ,contract_id -- 批次ID
            ,apply_id -- 存托申请单编号
            ,draft_id -- 票据表ID
            ,draft_number -- 票号
            ,draft_amount -- 票据金额
            ,maturity_date -- 到期日
            ,bp_no -- 票据包编号
            ,bp_range -- 子票据区间号
            ,dpst_range -- 存托区间
            ,discount_date -- 贴现日
            ,remit_date -- 出票日
            ,remitter_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,discount_brh_no -- 贴现行机构代码
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 承兑人开户行（确认）机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证人机构代码
            ,tenor_day -- 剩余期限
            ,bp_amount -- 票据包金额
            ,dpst_amount -- 存托金额
            ,dpst_number -- 存托数量
            ,bp_std_amount -- 标准金额
            ,pay_interest -- 应付利息
            ,adjust_pay_interest -- 调整后应付利息
            ,settle_amount -- 结算金额
            ,bp_due_date -- 票据包到期日
            ,valid_flag -- 有效标识： 0 否 1 是
            ,wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,proc_code -- 返回码
            ,proc_msg -- 返回结果
            ,wthd_info -- 退票说明
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.dpst_id, o.dpst_id) as dpst_id -- 存托申请表ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 批次ID
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 存托申请单编号
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据表ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票号
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据金额
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.bp_no, o.bp_no) as bp_no -- 票据包编号
    ,nvl(n.bp_range, o.bp_range) as bp_range -- 子票据区间号
    ,nvl(n.dpst_range, o.dpst_range) as dpst_range -- 存托区间
    ,nvl(n.discount_date, o.discount_date) as discount_date -- 贴现日
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人名称
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人名称
    ,nvl(n.acceptor_brh_no, o.acceptor_brh_no) as acceptor_brh_no -- 承兑人开户行机构代码
    ,nvl(n.discount_brh_no, o.discount_brh_no) as discount_brh_no -- 贴现行机构代码
    ,nvl(n.guarantee_brh_no, o.guarantee_brh_no) as guarantee_brh_no -- 保证增信行机构代码
    ,nvl(n.payer_confirm_brh_no, o.payer_confirm_brh_no) as payer_confirm_brh_no -- 承兑人开户行（确认）机构代码
    ,nvl(n.accept_gua_brh_no, o.accept_gua_brh_no) as accept_gua_brh_no -- 承兑保证行机构代码
    ,nvl(n.disc_gua_brh_no, o.disc_gua_brh_no) as disc_gua_brh_no -- 贴现保证人机构代码
    ,nvl(n.tenor_day, o.tenor_day) as tenor_day -- 剩余期限
    ,nvl(n.bp_amount, o.bp_amount) as bp_amount -- 票据包金额
    ,nvl(n.dpst_amount, o.dpst_amount) as dpst_amount -- 存托金额
    ,nvl(n.dpst_number, o.dpst_number) as dpst_number -- 存托数量
    ,nvl(n.bp_std_amount, o.bp_std_amount) as bp_std_amount -- 标准金额
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.adjust_pay_interest, o.adjust_pay_interest) as adjust_pay_interest -- 调整后应付利息
    ,nvl(n.settle_amount, o.settle_amount) as settle_amount -- 结算金额
    ,nvl(n.bp_due_date, o.bp_due_date) as bp_due_date -- 票据包到期日
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 有效标识： 0 否 1 是
    ,nvl(n.wthd_status, o.wthd_status) as wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.message_status, o.message_status) as message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,nvl(n.proc_code, o.proc_code) as proc_code -- 返回码
    ,nvl(n.proc_msg, o.proc_msg) as proc_msg -- 返回结果
    ,nvl(n.wthd_info, o.wthd_info) as wthd_info -- 退票说明
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
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
from (select * from ${iol_schema}.bdms_cpes_dpst_draft_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_dpst_draft_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.dpst_id <> n.dpst_id
        or o.contract_id <> n.contract_id
        or o.apply_id <> n.apply_id
        or o.draft_id <> n.draft_id
        or o.draft_number <> n.draft_number
        or o.draft_amount <> n.draft_amount
        or o.maturity_date <> n.maturity_date
        or o.bp_no <> n.bp_no
        or o.bp_range <> n.bp_range
        or o.dpst_range <> n.dpst_range
        or o.discount_date <> n.discount_date
        or o.remit_date <> n.remit_date
        or o.remitter_name <> n.remitter_name
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_brh_no <> n.acceptor_brh_no
        or o.discount_brh_no <> n.discount_brh_no
        or o.guarantee_brh_no <> n.guarantee_brh_no
        or o.payer_confirm_brh_no <> n.payer_confirm_brh_no
        or o.accept_gua_brh_no <> n.accept_gua_brh_no
        or o.disc_gua_brh_no <> n.disc_gua_brh_no
        or o.tenor_day <> n.tenor_day
        or o.bp_amount <> n.bp_amount
        or o.dpst_amount <> n.dpst_amount
        or o.dpst_number <> n.dpst_number
        or o.bp_std_amount <> n.bp_std_amount
        or o.pay_interest <> n.pay_interest
        or o.adjust_pay_interest <> n.adjust_pay_interest
        or o.settle_amount <> n.settle_amount
        or o.bp_due_date <> n.bp_due_date
        or o.valid_flag <> n.valid_flag
        or o.wthd_status <> n.wthd_status
        or o.account_status <> n.account_status
        or o.message_status <> n.message_status
        or o.proc_code <> n.proc_code
        or o.proc_msg <> n.proc_msg
        or o.wthd_info <> n.wthd_info
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_dpst_draft_details_cl(
            id -- ID
            ,dpst_id -- 存托申请表ID
            ,contract_id -- 批次ID
            ,apply_id -- 存托申请单编号
            ,draft_id -- 票据表ID
            ,draft_number -- 票号
            ,draft_amount -- 票据金额
            ,maturity_date -- 到期日
            ,bp_no -- 票据包编号
            ,bp_range -- 子票据区间号
            ,dpst_range -- 存托区间
            ,discount_date -- 贴现日
            ,remit_date -- 出票日
            ,remitter_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,discount_brh_no -- 贴现行机构代码
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 承兑人开户行（确认）机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证人机构代码
            ,tenor_day -- 剩余期限
            ,bp_amount -- 票据包金额
            ,dpst_amount -- 存托金额
            ,dpst_number -- 存托数量
            ,bp_std_amount -- 标准金额
            ,pay_interest -- 应付利息
            ,adjust_pay_interest -- 调整后应付利息
            ,settle_amount -- 结算金额
            ,bp_due_date -- 票据包到期日
            ,valid_flag -- 有效标识： 0 否 1 是
            ,wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,proc_code -- 返回码
            ,proc_msg -- 返回结果
            ,wthd_info -- 退票说明
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_dpst_draft_details_op(
            id -- ID
            ,dpst_id -- 存托申请表ID
            ,contract_id -- 批次ID
            ,apply_id -- 存托申请单编号
            ,draft_id -- 票据表ID
            ,draft_number -- 票号
            ,draft_amount -- 票据金额
            ,maturity_date -- 到期日
            ,bp_no -- 票据包编号
            ,bp_range -- 子票据区间号
            ,dpst_range -- 存托区间
            ,discount_date -- 贴现日
            ,remit_date -- 出票日
            ,remitter_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,discount_brh_no -- 贴现行机构代码
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 承兑人开户行（确认）机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证人机构代码
            ,tenor_day -- 剩余期限
            ,bp_amount -- 票据包金额
            ,dpst_amount -- 存托金额
            ,dpst_number -- 存托数量
            ,bp_std_amount -- 标准金额
            ,pay_interest -- 应付利息
            ,adjust_pay_interest -- 调整后应付利息
            ,settle_amount -- 结算金额
            ,bp_due_date -- 票据包到期日
            ,valid_flag -- 有效标识： 0 否 1 是
            ,wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,proc_code -- 返回码
            ,proc_msg -- 返回结果
            ,wthd_info -- 退票说明
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.dpst_id -- 存托申请表ID
    ,o.contract_id -- 批次ID
    ,o.apply_id -- 存托申请单编号
    ,o.draft_id -- 票据表ID
    ,o.draft_number -- 票号
    ,o.draft_amount -- 票据金额
    ,o.maturity_date -- 到期日
    ,o.bp_no -- 票据包编号
    ,o.bp_range -- 子票据区间号
    ,o.dpst_range -- 存托区间
    ,o.discount_date -- 贴现日
    ,o.remit_date -- 出票日
    ,o.remitter_name -- 出票人名称
    ,o.acceptor_name -- 承兑人名称
    ,o.acceptor_brh_no -- 承兑人开户行机构代码
    ,o.discount_brh_no -- 贴现行机构代码
    ,o.guarantee_brh_no -- 保证增信行机构代码
    ,o.payer_confirm_brh_no -- 承兑人开户行（确认）机构代码
    ,o.accept_gua_brh_no -- 承兑保证行机构代码
    ,o.disc_gua_brh_no -- 贴现保证人机构代码
    ,o.tenor_day -- 剩余期限
    ,o.bp_amount -- 票据包金额
    ,o.dpst_amount -- 存托金额
    ,o.dpst_number -- 存托数量
    ,o.bp_std_amount -- 标准金额
    ,o.pay_interest -- 应付利息
    ,o.adjust_pay_interest -- 调整后应付利息
    ,o.settle_amount -- 结算金额
    ,o.bp_due_date -- 票据包到期日
    ,o.valid_flag -- 有效标识： 0 否 1 是
    ,o.wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,o.proc_code -- 返回码
    ,o.proc_msg -- 返回结果
    ,o.wthd_info -- 退票说明
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
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
from ${iol_schema}.bdms_cpes_dpst_draft_details_bk o
    left join ${iol_schema}.bdms_cpes_dpst_draft_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_dpst_draft_details_cl d
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
--truncate table ${iol_schema}.bdms_cpes_dpst_draft_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_dpst_draft_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_dpst_draft_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_dpst_draft_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_dpst_draft_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_dpst_draft_details_cl;
alter table ${iol_schema}.bdms_cpes_dpst_draft_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_dpst_draft_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_dpst_draft_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_dpst_draft_details_op purge;
drop table ${iol_schema}.bdms_cpes_dpst_draft_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_dpst_draft_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_dpst_draft_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
