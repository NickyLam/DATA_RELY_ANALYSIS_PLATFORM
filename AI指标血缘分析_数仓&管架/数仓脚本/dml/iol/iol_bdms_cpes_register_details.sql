/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_register_details
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
create table ${iol_schema}.bdms_cpes_register_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_register_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_register_details_op purge;
drop table ${iol_schema}.bdms_cpes_register_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_register_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_register_details where 0=1;

create table ${iol_schema}.bdms_cpes_register_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_register_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_register_details_cl(
            id -- ID
            ,contract_id -- 协议表ID
            ,reg_type -- 登记类型： 0 手工 1 自动
            ,draft_id -- 票据ID
            ,busi_date -- 交易日期
            ,trader_type -- 交易对手类型： RC00 同业客户 RC01 企业客户
            ,trader_cust_no -- 交易对手客户号
            ,trader_name -- 交易对手名称
            ,trader_account -- 交易对手账号
            ,trader_credit_no -- 交易对手社会信用代码
            ,trader_bank_no -- 交易对手大额行号
            ,trader_brh_no -- 交易对手机构代码
            ,collection_bank_no -- 托收行大额行号
            ,busi_brh_no -- 业务机构
            ,register_brh_no -- 登记机构
            ,payment_date -- 付款日期
            ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
            ,stop_pay_reason -- 止付原因
            ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
            ,relieve_stp_rsn -- 解除止付原因
            ,revoke_type -- 撤回类型： RV01 未用退回 RV02 信息作废 RV03 票据作废
            ,revoke_inf -- 撤回信息： RI00 承兑登记信息撤回 RI01 质押登记信息撤回 RI02 质押解除登记信息撤回 RI03 承兑保证登记信息撤回 RI04 贴现登记信息撤回 RI05 权属登记信息撤回 RI06 结清登记信息撤回 RI07 止付登记信息撤回 RI08 止付解除登记信息撤回
            ,revoke_rsn -- 撤回原因
            ,recovery_type -- 线下追偿类型： 00 线下追偿登记 01 线下偿付登记 02 追偿结清登记
            ,industry -- 行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
            ,corp_scale -- 企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
            ,arc_flag -- 是否三农企业： 0 否 1 是
            ,area -- 地区
            ,grn_flag -- 是否绿色企业： 0 否 1 是
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,last_upd_opr -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_register_details_op(
            id -- ID
            ,contract_id -- 协议表ID
            ,reg_type -- 登记类型： 0 手工 1 自动
            ,draft_id -- 票据ID
            ,busi_date -- 交易日期
            ,trader_type -- 交易对手类型： RC00 同业客户 RC01 企业客户
            ,trader_cust_no -- 交易对手客户号
            ,trader_name -- 交易对手名称
            ,trader_account -- 交易对手账号
            ,trader_credit_no -- 交易对手社会信用代码
            ,trader_bank_no -- 交易对手大额行号
            ,trader_brh_no -- 交易对手机构代码
            ,collection_bank_no -- 托收行大额行号
            ,busi_brh_no -- 业务机构
            ,register_brh_no -- 登记机构
            ,payment_date -- 付款日期
            ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
            ,stop_pay_reason -- 止付原因
            ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
            ,relieve_stp_rsn -- 解除止付原因
            ,revoke_type -- 撤回类型： RV01 未用退回 RV02 信息作废 RV03 票据作废
            ,revoke_inf -- 撤回信息： RI00 承兑登记信息撤回 RI01 质押登记信息撤回 RI02 质押解除登记信息撤回 RI03 承兑保证登记信息撤回 RI04 贴现登记信息撤回 RI05 权属登记信息撤回 RI06 结清登记信息撤回 RI07 止付登记信息撤回 RI08 止付解除登记信息撤回
            ,revoke_rsn -- 撤回原因
            ,recovery_type -- 线下追偿类型： 00 线下追偿登记 01 线下偿付登记 02 追偿结清登记
            ,industry -- 行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
            ,corp_scale -- 企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
            ,arc_flag -- 是否三农企业： 0 否 1 是
            ,area -- 地区
            ,grn_flag -- 是否绿色企业： 0 否 1 是
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,last_upd_opr -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 协议表ID
    ,nvl(n.reg_type, o.reg_type) as reg_type -- 登记类型： 0 手工 1 自动
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 交易日期
    ,nvl(n.trader_type, o.trader_type) as trader_type -- 交易对手类型： RC00 同业客户 RC01 企业客户
    ,nvl(n.trader_cust_no, o.trader_cust_no) as trader_cust_no -- 交易对手客户号
    ,nvl(n.trader_name, o.trader_name) as trader_name -- 交易对手名称
    ,nvl(n.trader_account, o.trader_account) as trader_account -- 交易对手账号
    ,nvl(n.trader_credit_no, o.trader_credit_no) as trader_credit_no -- 交易对手社会信用代码
    ,nvl(n.trader_bank_no, o.trader_bank_no) as trader_bank_no -- 交易对手大额行号
    ,nvl(n.trader_brh_no, o.trader_brh_no) as trader_brh_no -- 交易对手机构代码
    ,nvl(n.collection_bank_no, o.collection_bank_no) as collection_bank_no -- 托收行大额行号
    ,nvl(n.busi_brh_no, o.busi_brh_no) as busi_brh_no -- 业务机构
    ,nvl(n.register_brh_no, o.register_brh_no) as register_brh_no -- 登记机构
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 付款日期
    ,nvl(n.stop_pay_type, o.stop_pay_type) as stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,nvl(n.stop_pay_reason, o.stop_pay_reason) as stop_pay_reason -- 止付原因
    ,nvl(n.relieve_stp_type, o.relieve_stp_type) as relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,nvl(n.relieve_stp_rsn, o.relieve_stp_rsn) as relieve_stp_rsn -- 解除止付原因
    ,nvl(n.revoke_type, o.revoke_type) as revoke_type -- 撤回类型： RV01 未用退回 RV02 信息作废 RV03 票据作废
    ,nvl(n.revoke_inf, o.revoke_inf) as revoke_inf -- 撤回信息： RI00 承兑登记信息撤回 RI01 质押登记信息撤回 RI02 质押解除登记信息撤回 RI03 承兑保证登记信息撤回 RI04 贴现登记信息撤回 RI05 权属登记信息撤回 RI06 结清登记信息撤回 RI07 止付登记信息撤回 RI08 止付解除登记信息撤回
    ,nvl(n.revoke_rsn, o.revoke_rsn) as revoke_rsn -- 撤回原因
    ,nvl(n.recovery_type, o.recovery_type) as recovery_type -- 线下追偿类型： 00 线下追偿登记 01 线下偿付登记 02 追偿结清登记
    ,nvl(n.industry, o.industry) as industry -- 行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
    ,nvl(n.corp_scale, o.corp_scale) as corp_scale -- 企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
    ,nvl(n.arc_flag, o.arc_flag) as arc_flag -- 是否三农企业： 0 否 1 是
    ,nvl(n.area, o.area) as area -- 地区
    ,nvl(n.grn_flag, o.grn_flag) as grn_flag -- 是否绿色企业： 0 否 1 是
    ,nvl(n.err_code, o.err_code) as err_code -- 错误码
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 错误信息
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后修改操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
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
from (select * from ${iol_schema}.bdms_cpes_register_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_register_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_id <> n.contract_id
        or o.reg_type <> n.reg_type
        or o.draft_id <> n.draft_id
        or o.busi_date <> n.busi_date
        or o.trader_type <> n.trader_type
        or o.trader_cust_no <> n.trader_cust_no
        or o.trader_name <> n.trader_name
        or o.trader_account <> n.trader_account
        or o.trader_credit_no <> n.trader_credit_no
        or o.trader_bank_no <> n.trader_bank_no
        or o.trader_brh_no <> n.trader_brh_no
        or o.collection_bank_no <> n.collection_bank_no
        or o.busi_brh_no <> n.busi_brh_no
        or o.register_brh_no <> n.register_brh_no
        or o.payment_date <> n.payment_date
        or o.stop_pay_type <> n.stop_pay_type
        or o.stop_pay_reason <> n.stop_pay_reason
        or o.relieve_stp_type <> n.relieve_stp_type
        or o.relieve_stp_rsn <> n.relieve_stp_rsn
        or o.revoke_type <> n.revoke_type
        or o.revoke_inf <> n.revoke_inf
        or o.revoke_rsn <> n.revoke_rsn
        or o.recovery_type <> n.recovery_type
        or o.industry <> n.industry
        or o.corp_scale <> n.corp_scale
        or o.arc_flag <> n.arc_flag
        or o.area <> n.area
        or o.grn_flag <> n.grn_flag
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.deal_status <> n.deal_status
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
        into ${iol_schema}.bdms_cpes_register_details_cl(
            id -- ID
            ,contract_id -- 协议表ID
            ,reg_type -- 登记类型： 0 手工 1 自动
            ,draft_id -- 票据ID
            ,busi_date -- 交易日期
            ,trader_type -- 交易对手类型： RC00 同业客户 RC01 企业客户
            ,trader_cust_no -- 交易对手客户号
            ,trader_name -- 交易对手名称
            ,trader_account -- 交易对手账号
            ,trader_credit_no -- 交易对手社会信用代码
            ,trader_bank_no -- 交易对手大额行号
            ,trader_brh_no -- 交易对手机构代码
            ,collection_bank_no -- 托收行大额行号
            ,busi_brh_no -- 业务机构
            ,register_brh_no -- 登记机构
            ,payment_date -- 付款日期
            ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
            ,stop_pay_reason -- 止付原因
            ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
            ,relieve_stp_rsn -- 解除止付原因
            ,revoke_type -- 撤回类型： RV01 未用退回 RV02 信息作废 RV03 票据作废
            ,revoke_inf -- 撤回信息： RI00 承兑登记信息撤回 RI01 质押登记信息撤回 RI02 质押解除登记信息撤回 RI03 承兑保证登记信息撤回 RI04 贴现登记信息撤回 RI05 权属登记信息撤回 RI06 结清登记信息撤回 RI07 止付登记信息撤回 RI08 止付解除登记信息撤回
            ,revoke_rsn -- 撤回原因
            ,recovery_type -- 线下追偿类型： 00 线下追偿登记 01 线下偿付登记 02 追偿结清登记
            ,industry -- 行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
            ,corp_scale -- 企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
            ,arc_flag -- 是否三农企业： 0 否 1 是
            ,area -- 地区
            ,grn_flag -- 是否绿色企业： 0 否 1 是
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,last_upd_opr -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_register_details_op(
            id -- ID
            ,contract_id -- 协议表ID
            ,reg_type -- 登记类型： 0 手工 1 自动
            ,draft_id -- 票据ID
            ,busi_date -- 交易日期
            ,trader_type -- 交易对手类型： RC00 同业客户 RC01 企业客户
            ,trader_cust_no -- 交易对手客户号
            ,trader_name -- 交易对手名称
            ,trader_account -- 交易对手账号
            ,trader_credit_no -- 交易对手社会信用代码
            ,trader_bank_no -- 交易对手大额行号
            ,trader_brh_no -- 交易对手机构代码
            ,collection_bank_no -- 托收行大额行号
            ,busi_brh_no -- 业务机构
            ,register_brh_no -- 登记机构
            ,payment_date -- 付款日期
            ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
            ,stop_pay_reason -- 止付原因
            ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
            ,relieve_stp_rsn -- 解除止付原因
            ,revoke_type -- 撤回类型： RV01 未用退回 RV02 信息作废 RV03 票据作废
            ,revoke_inf -- 撤回信息： RI00 承兑登记信息撤回 RI01 质押登记信息撤回 RI02 质押解除登记信息撤回 RI03 承兑保证登记信息撤回 RI04 贴现登记信息撤回 RI05 权属登记信息撤回 RI06 结清登记信息撤回 RI07 止付登记信息撤回 RI08 止付解除登记信息撤回
            ,revoke_rsn -- 撤回原因
            ,recovery_type -- 线下追偿类型： 00 线下追偿登记 01 线下偿付登记 02 追偿结清登记
            ,industry -- 行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
            ,corp_scale -- 企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
            ,arc_flag -- 是否三农企业： 0 否 1 是
            ,area -- 地区
            ,grn_flag -- 是否绿色企业： 0 否 1 是
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,last_upd_opr -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 协议表ID
    ,o.reg_type -- 登记类型： 0 手工 1 自动
    ,o.draft_id -- 票据ID
    ,o.busi_date -- 交易日期
    ,o.trader_type -- 交易对手类型： RC00 同业客户 RC01 企业客户
    ,o.trader_cust_no -- 交易对手客户号
    ,o.trader_name -- 交易对手名称
    ,o.trader_account -- 交易对手账号
    ,o.trader_credit_no -- 交易对手社会信用代码
    ,o.trader_bank_no -- 交易对手大额行号
    ,o.trader_brh_no -- 交易对手机构代码
    ,o.collection_bank_no -- 托收行大额行号
    ,o.busi_brh_no -- 业务机构
    ,o.register_brh_no -- 登记机构
    ,o.payment_date -- 付款日期
    ,o.stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,o.stop_pay_reason -- 止付原因
    ,o.relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,o.relieve_stp_rsn -- 解除止付原因
    ,o.revoke_type -- 撤回类型： RV01 未用退回 RV02 信息作废 RV03 票据作废
    ,o.revoke_inf -- 撤回信息： RI00 承兑登记信息撤回 RI01 质押登记信息撤回 RI02 质押解除登记信息撤回 RI03 承兑保证登记信息撤回 RI04 贴现登记信息撤回 RI05 权属登记信息撤回 RI06 结清登记信息撤回 RI07 止付登记信息撤回 RI08 止付解除登记信息撤回
    ,o.revoke_rsn -- 撤回原因
    ,o.recovery_type -- 线下追偿类型： 00 线下追偿登记 01 线下偿付登记 02 追偿结清登记
    ,o.industry -- 行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
    ,o.corp_scale -- 企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
    ,o.arc_flag -- 是否三农企业： 0 否 1 是
    ,o.area -- 地区
    ,o.grn_flag -- 是否绿色企业： 0 否 1 是
    ,o.err_code -- 错误码
    ,o.err_msg -- 错误信息
    ,o.deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,o.last_upd_opr -- 最后修改操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
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
from ${iol_schema}.bdms_cpes_register_details_bk o
    left join ${iol_schema}.bdms_cpes_register_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_register_details_cl d
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
--truncate table ${iol_schema}.bdms_cpes_register_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_register_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_register_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_register_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_register_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_register_details_cl;
alter table ${iol_schema}.bdms_cpes_register_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_register_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_register_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_register_details_op purge;
drop table ${iol_schema}.bdms_cpes_register_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_register_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_register_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
