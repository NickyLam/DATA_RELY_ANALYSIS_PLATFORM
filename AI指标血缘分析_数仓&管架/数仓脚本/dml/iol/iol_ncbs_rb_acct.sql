/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct
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
create table ${iol_schema}.ncbs_rb_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_op purge;
drop table ${iol_schema}.ncbs_rb_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct where 0=1;

create table ${iol_schema}.ncbs_rb_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,business_unit -- 账套
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_class -- 账户等级
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_license_no -- 账户许可证号
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,acct_stop_pay -- 账户余额止付标志
            ,addtl_principal -- 是否允许增加本金
            ,agreement_id -- 协议编号
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,appr_flag -- 复核标志
            ,appr_letter_no -- 核准件编号
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,gl_type -- 总账类型
            ,impound_fad -- 强制扣划导致违约状态
            ,individual_flag -- 对公对私标志
            ,int_ind_flag -- 是否计息
            ,joint_acct_flag -- 联合账户标志
            ,last_mvmt_status -- 定期账户上一次更改状态
            ,lead_acct_flag -- 主账户标志
            ,main_bal_flag -- 主账户是否带余额
            ,main_int_flag -- 主账户是否带利息
            ,management_free_flag -- 对公免收管理费标志，对私免收管理费和卡年费标识
            ,multi_bal_type_flag -- 是否多余额
            ,no_tran_flag -- 6个月无交易标志
            ,osa_flag -- 离岸标记
            ,ownership_type -- 归属种类
            ,partial_renew_roll -- 是否部分本金转存
            ,prefix -- 前缀
            ,recover_flag -- 实时追缴标志字段
            ,region_flag -- 区内区外标记
            ,renew_no -- 本金转存次数
            ,rollover_no -- 本息转存次数
            ,settle -- 结算标志
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,times_renewed -- 已本金转存次数
            ,times_rolledover -- 已本息转存次数
            ,xrate_id -- 汇兑方式
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,fixed_call -- 定期账户细类
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_close_date -- 销户日期
            ,acct_due_date -- 账户有效日期
            ,acct_license_date -- 账户许可证签发日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,dormant_date -- 转不动户日期
            ,effect_date -- 产品生效日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,main_prod_type -- 卡产品代码
            ,mm_ref_no -- 资金交易参考号
            ,notice_period -- 通知期限
            ,old_prod_type -- 原产品类型
            ,parent_internal_key -- 上级账户标识符
            ,settle_user_id -- 结算柜员
            ,voucher_start_no -- 凭证起始号码
            ,xrate -- 汇率
            ,apply_branch -- 申请机构
            ,acct_name_prefix -- 账户名称前缀
            ,acct_name_suffix -- 账户名称后缀
            ,open_user_id -- 开户柜员编号
            ,acct_property2 -- 账户性质2
            ,amend_date -- 变更日期
            ,is_med_ins_flag -- 是否医保账户标志
            ,is_travel_card_flag -- 是否旅行通账户标志
            ,travel_due_date -- 旅行通卡有效期
            ,is_soc_fin_flag -- 是否为社保卡下金融账户标志
            ,to_out_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,business_unit -- 账套
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_class -- 账户等级
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_license_no -- 账户许可证号
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,acct_stop_pay -- 账户余额止付标志
            ,addtl_principal -- 是否允许增加本金
            ,agreement_id -- 协议编号
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,appr_flag -- 复核标志
            ,appr_letter_no -- 核准件编号
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,gl_type -- 总账类型
            ,impound_fad -- 强制扣划导致违约状态
            ,individual_flag -- 对公对私标志
            ,int_ind_flag -- 是否计息
            ,joint_acct_flag -- 联合账户标志
            ,last_mvmt_status -- 定期账户上一次更改状态
            ,lead_acct_flag -- 主账户标志
            ,main_bal_flag -- 主账户是否带余额
            ,main_int_flag -- 主账户是否带利息
            ,management_free_flag -- 对公免收管理费标志，对私免收管理费和卡年费标识
            ,multi_bal_type_flag -- 是否多余额
            ,no_tran_flag -- 6个月无交易标志
            ,osa_flag -- 离岸标记
            ,ownership_type -- 归属种类
            ,partial_renew_roll -- 是否部分本金转存
            ,prefix -- 前缀
            ,recover_flag -- 实时追缴标志字段
            ,region_flag -- 区内区外标记
            ,renew_no -- 本金转存次数
            ,rollover_no -- 本息转存次数
            ,settle -- 结算标志
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,times_renewed -- 已本金转存次数
            ,times_rolledover -- 已本息转存次数
            ,xrate_id -- 汇兑方式
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,fixed_call -- 定期账户细类
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_close_date -- 销户日期
            ,acct_due_date -- 账户有效日期
            ,acct_license_date -- 账户许可证签发日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,dormant_date -- 转不动户日期
            ,effect_date -- 产品生效日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,main_prod_type -- 卡产品代码
            ,mm_ref_no -- 资金交易参考号
            ,notice_period -- 通知期限
            ,old_prod_type -- 原产品类型
            ,parent_internal_key -- 上级账户标识符
            ,settle_user_id -- 结算柜员
            ,voucher_start_no -- 凭证起始号码
            ,xrate -- 汇率
            ,apply_branch -- 申请机构
            ,acct_name_prefix -- 账户名称前缀
            ,acct_name_suffix -- 账户名称后缀
            ,open_user_id -- 开户柜员编号
            ,acct_property2 -- 账户性质2
            ,amend_date -- 变更日期
            ,is_med_ins_flag -- 是否医保账户标志
            ,is_travel_card_flag -- 是否旅行通账户标志
            ,travel_due_date -- 旅行通卡有效期
            ,is_soc_fin_flag -- 是否为社保卡下金融账户标志
            ,to_out_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.business_unit, o.business_unit) as business_unit -- 账套
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.reason_code, o.reason_code) as reason_code -- 账户用途
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.voucher_status, o.voucher_status) as voucher_status -- 凭证状态
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.acct_class, o.acct_class) as acct_class -- 账户等级
    ,nvl(n.acct_desc, o.acct_desc) as acct_desc -- 账户描述
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.acct_license_no, o.acct_license_no) as acct_license_no -- 账户许可证号
    ,nvl(n.acct_nature, o.acct_nature) as acct_nature -- 存款账户类型
    ,nvl(n.acct_real_flag, o.acct_real_flag) as acct_real_flag -- 账户虚实标志
    ,nvl(n.acct_res_status, o.acct_res_status) as acct_res_status -- 账户限制标志
    ,nvl(n.acct_status_prev, o.acct_status_prev) as acct_status_prev -- 账户上一状态
    ,nvl(n.acct_stop_pay, o.acct_stop_pay) as acct_stop_pay -- 账户余额止付标志
    ,nvl(n.addtl_principal, o.addtl_principal) as addtl_principal -- 是否允许增加本金
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.all_dep_ind, o.all_dep_ind) as all_dep_ind -- 通存标志
    ,nvl(n.all_dra_ind, o.all_dra_ind) as all_dra_ind -- 通兑标志
    ,nvl(n.appr_flag, o.appr_flag) as appr_flag -- 复核标志
    ,nvl(n.appr_letter_no, o.appr_letter_no) as appr_letter_no -- 核准件编号
    ,nvl(n.auto_renew_rollover, o.auto_renew_rollover) as auto_renew_rollover -- 自动转存方式
    ,nvl(n.auto_settle_flag, o.auto_settle_flag) as auto_settle_flag -- 自动结清标志
    ,nvl(n.bal_type, o.bal_type) as bal_type -- 余额类型
    ,nvl(n.checked_flag, o.checked_flag) as checked_flag -- 黑名单是否已检查标志位
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cur_stage_no, o.cur_stage_no) as cur_stage_no -- 当前期数
    ,nvl(n.dac_value, o.dac_value) as dac_value -- dac值防篡改加密
    ,nvl(n.gl_type, o.gl_type) as gl_type -- 总账类型
    ,nvl(n.impound_fad, o.impound_fad) as impound_fad -- 强制扣划导致违约状态
    ,nvl(n.individual_flag, o.individual_flag) as individual_flag -- 对公对私标志
    ,nvl(n.int_ind_flag, o.int_ind_flag) as int_ind_flag -- 是否计息
    ,nvl(n.joint_acct_flag, o.joint_acct_flag) as joint_acct_flag -- 联合账户标志
    ,nvl(n.last_mvmt_status, o.last_mvmt_status) as last_mvmt_status -- 定期账户上一次更改状态
    ,nvl(n.lead_acct_flag, o.lead_acct_flag) as lead_acct_flag -- 主账户标志
    ,nvl(n.main_bal_flag, o.main_bal_flag) as main_bal_flag -- 主账户是否带余额
    ,nvl(n.main_int_flag, o.main_int_flag) as main_int_flag -- 主账户是否带利息
    ,nvl(n.management_free_flag, o.management_free_flag) as management_free_flag -- 对公免收管理费标志，对私免收管理费和卡年费标识
    ,nvl(n.multi_bal_type_flag, o.multi_bal_type_flag) as multi_bal_type_flag -- 是否多余额
    ,nvl(n.no_tran_flag, o.no_tran_flag) as no_tran_flag -- 6个月无交易标志
    ,nvl(n.osa_flag, o.osa_flag) as osa_flag -- 离岸标记
    ,nvl(n.ownership_type, o.ownership_type) as ownership_type -- 归属种类
    ,nvl(n.partial_renew_roll, o.partial_renew_roll) as partial_renew_roll -- 是否部分本金转存
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.recover_flag, o.recover_flag) as recover_flag -- 实时追缴标志字段
    ,nvl(n.region_flag, o.region_flag) as region_flag -- 区内区外标记
    ,nvl(n.renew_no, o.renew_no) as renew_no -- 本金转存次数
    ,nvl(n.rollover_no, o.rollover_no) as rollover_no -- 本息转存次数
    ,nvl(n.settle, o.settle) as settle -- 结算标志
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.terminal_id, o.terminal_id) as terminal_id -- 交易终端编号
    ,nvl(n.times_renewed, o.times_renewed) as times_renewed -- 已本金转存次数
    ,nvl(n.times_rolledover, o.times_rolledover) as times_rolledover -- 已本息转存次数
    ,nvl(n.xrate_id, o.xrate_id) as xrate_id -- 汇兑方式
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.accounting_status_prev, o.accounting_status_prev) as accounting_status_prev -- 上次核算状态
    ,nvl(n.fixed_call, o.fixed_call) as fixed_call -- 定期账户细类
    ,nvl(n.accounting_status_upd_date, o.accounting_status_upd_date) as accounting_status_upd_date -- 核算状态变更日期
    ,nvl(n.acct_close_date, o.acct_close_date) as acct_close_date -- 销户日期
    ,nvl(n.acct_due_date, o.acct_due_date) as acct_due_date -- 账户有效日期
    ,nvl(n.acct_license_date, o.acct_license_date) as acct_license_date -- 账户许可证签发日期
    ,nvl(n.acct_open_date, o.acct_open_date) as acct_open_date -- 账户开户日期
    ,nvl(n.acct_status_upd_date, o.acct_status_upd_date) as acct_status_upd_date -- 账户状态变更日期
    ,nvl(n.approval_date, o.approval_date) as approval_date -- 复核日期
    ,nvl(n.dormant_date, o.dormant_date) as dormant_date -- 转不动户日期
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_tran_date, o.last_tran_date) as last_tran_date -- 最后交易日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.open_tran_date, o.open_tran_date) as open_tran_date -- 开户后首次交易日期
    ,nvl(n.ori_maturity_date, o.ori_maturity_date) as ori_maturity_date -- 账户原始到期日期
    ,nvl(n.orig_acct_open_date, o.orig_acct_open_date) as orig_acct_open_date -- 账户原始开立日期
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.iss_country, o.iss_country) as iss_country -- 发证国家
    ,nvl(n.acct_branch, o.acct_branch) as acct_branch -- 开户机构编号
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.acct_close_reason, o.acct_close_reason) as acct_close_reason -- 关闭原因
    ,nvl(n.acct_close_user_id, o.acct_close_user_id) as acct_close_user_id -- 账户销户操作柜员
    ,nvl(n.alt_acct_name, o.alt_acct_name) as alt_acct_name -- 备用账户名称
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.home_branch, o.home_branch) as home_branch -- 客户管理行
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.main_prod_type, o.main_prod_type) as main_prod_type -- 卡产品代码
    ,nvl(n.mm_ref_no, o.mm_ref_no) as mm_ref_no -- 资金交易参考号
    ,nvl(n.notice_period, o.notice_period) as notice_period -- 通知期限
    ,nvl(n.old_prod_type, o.old_prod_type) as old_prod_type -- 原产品类型
    ,nvl(n.parent_internal_key, o.parent_internal_key) as parent_internal_key -- 上级账户标识符
    ,nvl(n.settle_user_id, o.settle_user_id) as settle_user_id -- 结算柜员
    ,nvl(n.voucher_start_no, o.voucher_start_no) as voucher_start_no -- 凭证起始号码
    ,nvl(n.xrate, o.xrate) as xrate -- 汇率
    ,nvl(n.apply_branch, o.apply_branch) as apply_branch -- 申请机构
    ,nvl(n.acct_name_prefix, o.acct_name_prefix) as acct_name_prefix -- 账户名称前缀
    ,nvl(n.acct_name_suffix, o.acct_name_suffix) as acct_name_suffix -- 账户名称后缀
    ,nvl(n.open_user_id, o.open_user_id) as open_user_id -- 开户柜员编号
    ,nvl(n.acct_property2, o.acct_property2) as acct_property2 -- 账户性质2
    ,nvl(n.amend_date, o.amend_date) as amend_date -- 变更日期
    ,nvl(n.is_med_ins_flag, o.is_med_ins_flag) as is_med_ins_flag -- 是否医保账户标志
    ,nvl(n.is_travel_card_flag, o.is_travel_card_flag) as is_travel_card_flag -- 是否旅行通账户标志
    ,nvl(n.travel_due_date, o.travel_due_date) as travel_due_date -- 旅行通卡有效期
    ,nvl(n.is_soc_fin_flag, o.is_soc_fin_flag) as is_soc_fin_flag -- 是否为社保卡下金融账户标志
    ,nvl(n.to_out_flag, o.to_out_flag) as to_out_flag -- 
    ,case when
            n.client_no is null
            and n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.client_no is null
            and n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.client_no is null
            and n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
where (
        o.client_no is null
        and o.internal_key is null
    )
    or (
        n.client_no is null
        and n.internal_key is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.acct_status <> n.acct_status
        or o.acct_type <> n.acct_type
        or o.base_acct_no <> n.base_acct_no
        or o.business_unit <> n.business_unit
        or o.card_no <> n.card_no
        or o.client_type <> n.client_type
        or o.doc_type <> n.doc_type
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.prod_type <> n.prod_type
        or o.profit_center <> n.profit_center
        or o.reason_code <> n.reason_code
        or o.user_id <> n.user_id
        or o.voucher_status <> n.voucher_status
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.acct_class <> n.acct_class
        or o.acct_desc <> n.acct_desc
        or o.acct_exec <> n.acct_exec
        or o.acct_license_no <> n.acct_license_no
        or o.acct_nature <> n.acct_nature
        or o.acct_real_flag <> n.acct_real_flag
        or o.acct_res_status <> n.acct_res_status
        or o.acct_status_prev <> n.acct_status_prev
        or o.acct_stop_pay <> n.acct_stop_pay
        or o.addtl_principal <> n.addtl_principal
        or o.agreement_id <> n.agreement_id
        or o.all_dep_ind <> n.all_dep_ind
        or o.all_dra_ind <> n.all_dra_ind
        or o.appr_flag <> n.appr_flag
        or o.appr_letter_no <> n.appr_letter_no
        or o.auto_renew_rollover <> n.auto_renew_rollover
        or o.auto_settle_flag <> n.auto_settle_flag
        or o.bal_type <> n.bal_type
        or o.checked_flag <> n.checked_flag
        or o.company <> n.company
        or o.cur_stage_no <> n.cur_stage_no
        or o.dac_value <> n.dac_value
        or o.gl_type <> n.gl_type
        or o.impound_fad <> n.impound_fad
        or o.individual_flag <> n.individual_flag
        or o.int_ind_flag <> n.int_ind_flag
        or o.joint_acct_flag <> n.joint_acct_flag
        or o.last_mvmt_status <> n.last_mvmt_status
        or o.lead_acct_flag <> n.lead_acct_flag
        or o.main_bal_flag <> n.main_bal_flag
        or o.main_int_flag <> n.main_int_flag
        or o.management_free_flag <> n.management_free_flag
        or o.multi_bal_type_flag <> n.multi_bal_type_flag
        or o.no_tran_flag <> n.no_tran_flag
        or o.osa_flag <> n.osa_flag
        or o.ownership_type <> n.ownership_type
        or o.partial_renew_roll <> n.partial_renew_roll
        or o.prefix <> n.prefix
        or o.recover_flag <> n.recover_flag
        or o.region_flag <> n.region_flag
        or o.renew_no <> n.renew_no
        or o.rollover_no <> n.rollover_no
        or o.settle <> n.settle
        or o.source_module <> n.source_module
        or o.source_type <> n.source_type
        or o.terminal_id <> n.terminal_id
        or o.times_renewed <> n.times_renewed
        or o.times_rolledover <> n.times_rolledover
        or o.xrate_id <> n.xrate_id
        or o.accounting_status <> n.accounting_status
        or o.accounting_status_prev <> n.accounting_status_prev
        or o.fixed_call <> n.fixed_call
        or o.accounting_status_upd_date <> n.accounting_status_upd_date
        or o.acct_close_date <> n.acct_close_date
        or o.acct_due_date <> n.acct_due_date
        or o.acct_license_date <> n.acct_license_date
        or o.acct_open_date <> n.acct_open_date
        or o.acct_status_upd_date <> n.acct_status_upd_date
        or o.approval_date <> n.approval_date
        or o.dormant_date <> n.dormant_date
        or o.effect_date <> n.effect_date
        or o.last_change_date <> n.last_change_date
        or o.last_tran_date <> n.last_tran_date
        or o.maturity_date <> n.maturity_date
        or o.open_tran_date <> n.open_tran_date
        or o.ori_maturity_date <> n.ori_maturity_date
        or o.orig_acct_open_date <> n.orig_acct_open_date
        or o.settle_date <> n.settle_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.iss_country <> n.iss_country
        or o.acct_branch <> n.acct_branch
        or o.acct_ccy <> n.acct_ccy
        or o.acct_close_reason <> n.acct_close_reason
        or o.acct_close_user_id <> n.acct_close_user_id
        or o.alt_acct_name <> n.alt_acct_name
        or o.appr_user_id <> n.appr_user_id
        or o.home_branch <> n.home_branch
        or o.last_change_user_id <> n.last_change_user_id
        or o.main_prod_type <> n.main_prod_type
        or o.mm_ref_no <> n.mm_ref_no
        or o.notice_period <> n.notice_period
        or o.old_prod_type <> n.old_prod_type
        or o.parent_internal_key <> n.parent_internal_key
        or o.settle_user_id <> n.settle_user_id
        or o.voucher_start_no <> n.voucher_start_no
        or o.xrate <> n.xrate
        or o.apply_branch <> n.apply_branch
        or o.acct_name_prefix <> n.acct_name_prefix
        or o.acct_name_suffix <> n.acct_name_suffix
        or o.open_user_id <> n.open_user_id
        or o.acct_property2 <> n.acct_property2
        or o.amend_date <> n.amend_date
        or o.is_med_ins_flag <> n.is_med_ins_flag
        or o.is_travel_card_flag <> n.is_travel_card_flag
        or o.travel_due_date <> n.travel_due_date
        or o.is_soc_fin_flag <> n.is_soc_fin_flag
        or o.to_out_flag <> n.to_out_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,business_unit -- 账套
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_class -- 账户等级
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_license_no -- 账户许可证号
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,acct_stop_pay -- 账户余额止付标志
            ,addtl_principal -- 是否允许增加本金
            ,agreement_id -- 协议编号
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,appr_flag -- 复核标志
            ,appr_letter_no -- 核准件编号
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,gl_type -- 总账类型
            ,impound_fad -- 强制扣划导致违约状态
            ,individual_flag -- 对公对私标志
            ,int_ind_flag -- 是否计息
            ,joint_acct_flag -- 联合账户标志
            ,last_mvmt_status -- 定期账户上一次更改状态
            ,lead_acct_flag -- 主账户标志
            ,main_bal_flag -- 主账户是否带余额
            ,main_int_flag -- 主账户是否带利息
            ,management_free_flag -- 对公免收管理费标志，对私免收管理费和卡年费标识
            ,multi_bal_type_flag -- 是否多余额
            ,no_tran_flag -- 6个月无交易标志
            ,osa_flag -- 离岸标记
            ,ownership_type -- 归属种类
            ,partial_renew_roll -- 是否部分本金转存
            ,prefix -- 前缀
            ,recover_flag -- 实时追缴标志字段
            ,region_flag -- 区内区外标记
            ,renew_no -- 本金转存次数
            ,rollover_no -- 本息转存次数
            ,settle -- 结算标志
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,times_renewed -- 已本金转存次数
            ,times_rolledover -- 已本息转存次数
            ,xrate_id -- 汇兑方式
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,fixed_call -- 定期账户细类
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_close_date -- 销户日期
            ,acct_due_date -- 账户有效日期
            ,acct_license_date -- 账户许可证签发日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,dormant_date -- 转不动户日期
            ,effect_date -- 产品生效日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,main_prod_type -- 卡产品代码
            ,mm_ref_no -- 资金交易参考号
            ,notice_period -- 通知期限
            ,old_prod_type -- 原产品类型
            ,parent_internal_key -- 上级账户标识符
            ,settle_user_id -- 结算柜员
            ,voucher_start_no -- 凭证起始号码
            ,xrate -- 汇率
            ,apply_branch -- 申请机构
            ,acct_name_prefix -- 账户名称前缀
            ,acct_name_suffix -- 账户名称后缀
            ,open_user_id -- 开户柜员编号
            ,acct_property2 -- 账户性质2
            ,amend_date -- 变更日期
            ,is_med_ins_flag -- 是否医保账户标志
            ,is_travel_card_flag -- 是否旅行通账户标志
            ,travel_due_date -- 旅行通卡有效期
            ,is_soc_fin_flag -- 是否为社保卡下金融账户标志
            ,to_out_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,business_unit -- 账套
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_class -- 账户等级
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_license_no -- 账户许可证号
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,acct_stop_pay -- 账户余额止付标志
            ,addtl_principal -- 是否允许增加本金
            ,agreement_id -- 协议编号
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,appr_flag -- 复核标志
            ,appr_letter_no -- 核准件编号
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,gl_type -- 总账类型
            ,impound_fad -- 强制扣划导致违约状态
            ,individual_flag -- 对公对私标志
            ,int_ind_flag -- 是否计息
            ,joint_acct_flag -- 联合账户标志
            ,last_mvmt_status -- 定期账户上一次更改状态
            ,lead_acct_flag -- 主账户标志
            ,main_bal_flag -- 主账户是否带余额
            ,main_int_flag -- 主账户是否带利息
            ,management_free_flag -- 对公免收管理费标志，对私免收管理费和卡年费标识
            ,multi_bal_type_flag -- 是否多余额
            ,no_tran_flag -- 6个月无交易标志
            ,osa_flag -- 离岸标记
            ,ownership_type -- 归属种类
            ,partial_renew_roll -- 是否部分本金转存
            ,prefix -- 前缀
            ,recover_flag -- 实时追缴标志字段
            ,region_flag -- 区内区外标记
            ,renew_no -- 本金转存次数
            ,rollover_no -- 本息转存次数
            ,settle -- 结算标志
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,times_renewed -- 已本金转存次数
            ,times_rolledover -- 已本息转存次数
            ,xrate_id -- 汇兑方式
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,fixed_call -- 定期账户细类
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_close_date -- 销户日期
            ,acct_due_date -- 账户有效日期
            ,acct_license_date -- 账户许可证签发日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,dormant_date -- 转不动户日期
            ,effect_date -- 产品生效日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,main_prod_type -- 卡产品代码
            ,mm_ref_no -- 资金交易参考号
            ,notice_period -- 通知期限
            ,old_prod_type -- 原产品类型
            ,parent_internal_key -- 上级账户标识符
            ,settle_user_id -- 结算柜员
            ,voucher_start_no -- 凭证起始号码
            ,xrate -- 汇率
            ,apply_branch -- 申请机构
            ,acct_name_prefix -- 账户名称前缀
            ,acct_name_suffix -- 账户名称后缀
            ,open_user_id -- 开户柜员编号
            ,acct_property2 -- 账户性质2
            ,amend_date -- 变更日期
            ,is_med_ins_flag -- 是否医保账户标志
            ,is_travel_card_flag -- 是否旅行通账户标志
            ,travel_due_date -- 旅行通卡有效期
            ,is_soc_fin_flag -- 是否为社保卡下金融账户标志
            ,to_out_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.acct_status -- 账户状态
    ,o.acct_type -- 账户类型
    ,o.base_acct_no -- 交易账号/卡号
    ,o.business_unit -- 账套
    ,o.card_no -- 卡号
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.doc_type -- 凭证类型
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.profit_center -- 利润中心
    ,o.reason_code -- 账户用途
    ,o.user_id -- 交易柜员编号
    ,o.voucher_status -- 凭证状态
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.acct_class -- 账户等级
    ,o.acct_desc -- 账户描述
    ,o.acct_exec -- 银行客户经理编号
    ,o.acct_license_no -- 账户许可证号
    ,o.acct_nature -- 存款账户类型
    ,o.acct_real_flag -- 账户虚实标志
    ,o.acct_res_status -- 账户限制标志
    ,o.acct_status_prev -- 账户上一状态
    ,o.acct_stop_pay -- 账户余额止付标志
    ,o.addtl_principal -- 是否允许增加本金
    ,o.agreement_id -- 协议编号
    ,o.all_dep_ind -- 通存标志
    ,o.all_dra_ind -- 通兑标志
    ,o.appr_flag -- 复核标志
    ,o.appr_letter_no -- 核准件编号
    ,o.auto_renew_rollover -- 自动转存方式
    ,o.auto_settle_flag -- 自动结清标志
    ,o.bal_type -- 余额类型
    ,o.checked_flag -- 黑名单是否已检查标志位
    ,o.company -- 法人
    ,o.cur_stage_no -- 当前期数
    ,o.dac_value -- dac值防篡改加密
    ,o.gl_type -- 总账类型
    ,o.impound_fad -- 强制扣划导致违约状态
    ,o.individual_flag -- 对公对私标志
    ,o.int_ind_flag -- 是否计息
    ,o.joint_acct_flag -- 联合账户标志
    ,o.last_mvmt_status -- 定期账户上一次更改状态
    ,o.lead_acct_flag -- 主账户标志
    ,o.main_bal_flag -- 主账户是否带余额
    ,o.main_int_flag -- 主账户是否带利息
    ,o.management_free_flag -- 对公免收管理费标志，对私免收管理费和卡年费标识
    ,o.multi_bal_type_flag -- 是否多余额
    ,o.no_tran_flag -- 6个月无交易标志
    ,o.osa_flag -- 离岸标记
    ,o.ownership_type -- 归属种类
    ,o.partial_renew_roll -- 是否部分本金转存
    ,o.prefix -- 前缀
    ,o.recover_flag -- 实时追缴标志字段
    ,o.region_flag -- 区内区外标记
    ,o.renew_no -- 本金转存次数
    ,o.rollover_no -- 本息转存次数
    ,o.settle -- 结算标志
    ,o.source_module -- 源模块
    ,o.source_type -- 渠道编号
    ,o.terminal_id -- 交易终端编号
    ,o.times_renewed -- 已本金转存次数
    ,o.times_rolledover -- 已本息转存次数
    ,o.xrate_id -- 汇兑方式
    ,o.accounting_status -- 核算状态
    ,o.accounting_status_prev -- 上次核算状态
    ,o.fixed_call -- 定期账户细类
    ,o.accounting_status_upd_date -- 核算状态变更日期
    ,o.acct_close_date -- 销户日期
    ,o.acct_due_date -- 账户有效日期
    ,o.acct_license_date -- 账户许可证签发日期
    ,o.acct_open_date -- 账户开户日期
    ,o.acct_status_upd_date -- 账户状态变更日期
    ,o.approval_date -- 复核日期
    ,o.dormant_date -- 转不动户日期
    ,o.effect_date -- 产品生效日期
    ,o.last_change_date -- 最后修改日期
    ,o.last_tran_date -- 最后交易日期
    ,o.maturity_date -- 到期日期
    ,o.open_tran_date -- 开户后首次交易日期
    ,o.ori_maturity_date -- 账户原始到期日期
    ,o.orig_acct_open_date -- 账户原始开立日期
    ,o.settle_date -- 结算日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.iss_country -- 发证国家
    ,o.acct_branch -- 开户机构编号
    ,o.acct_ccy -- 账户币种
    ,o.acct_close_reason -- 关闭原因
    ,o.acct_close_user_id -- 账户销户操作柜员
    ,o.alt_acct_name -- 备用账户名称
    ,o.appr_user_id -- 复核柜员
    ,o.home_branch -- 客户管理行
    ,o.last_change_user_id -- 最后修改柜员
    ,o.main_prod_type -- 卡产品代码
    ,o.mm_ref_no -- 资金交易参考号
    ,o.notice_period -- 通知期限
    ,o.old_prod_type -- 原产品类型
    ,o.parent_internal_key -- 上级账户标识符
    ,o.settle_user_id -- 结算柜员
    ,o.voucher_start_no -- 凭证起始号码
    ,o.xrate -- 汇率
    ,o.apply_branch -- 申请机构
    ,o.acct_name_prefix -- 账户名称前缀
    ,o.acct_name_suffix -- 账户名称后缀
    ,o.open_user_id -- 开户柜员编号
    ,o.acct_property2 -- 账户性质2
    ,o.amend_date -- 变更日期
    ,o.is_med_ins_flag -- 是否医保账户标志
    ,o.is_travel_card_flag -- 是否旅行通账户标志
    ,o.travel_due_date -- 旅行通卡有效期
    ,o.is_soc_fin_flag -- 是否为社保卡下金融账户标志
    ,o.to_out_flag -- 
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
from ${iol_schema}.ncbs_rb_acct_bk o
    left join ${iol_schema}.ncbs_rb_acct_op n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_cl d
        on
            o.client_no = d.client_no
            and o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_cl;
alter table ${iol_schema}.ncbs_rb_acct exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_op purge;
drop table ${iol_schema}.ncbs_rb_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
