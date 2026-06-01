/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cust_dpc_draft_info
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
create table ${iol_schema}.bdms_cust_dpc_draft_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cust_dpc_draft_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cust_dpc_draft_info_op purge;
drop table ${iol_schema}.bdms_cust_dpc_draft_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cust_dpc_draft_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cust_dpc_draft_info where 0=1;

create table ${iol_schema}.bdms_cust_dpc_draft_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cust_dpc_draft_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cust_dpc_draft_info_cl(
            id -- ID
            ,draft_number -- 票据（包）号
            ,cd_range -- 子票区间
            ,draft_amount -- 票据（包）金额
            ,standard_amt -- 标准金额
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银承 2 商承
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,draft_transfer_flag -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_id -- 原始票据ID
            ,select_draft_id -- 挑票ID
            ,split_draft_id -- 实际拆前票据ID
            ,split_range -- 实际拆前区间
            ,split_control_id -- 登记中心拆包控制表ID
            ,split_status -- 分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_name -- 出票人名称
            ,remitter_crt_no -- 出票人社会信用代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行行名
            ,remitter_brh_no -- 出票人开户行机构代码
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_crt_no -- 承兑人社会信用代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行行名
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_name -- 收款人名称
            ,payee_crt_no -- 收款人社会信用代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_account -- 收款人账号
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payee_brh_no -- 收款人开户行机构代码
            ,payee_brh_name -- 收款人开户行机构名称
            ,drawee_bank_no -- 付款行行号
            ,drawee_brh_no -- 付款行机构代码
            ,drawee_bank_name -- 付款行名称
            ,gua_accept_bank_no -- 承兑保证行行号
            ,gua_accept_brh_no -- 承兑保证行机构代码
            ,collection_bank_no -- 托收行行号
            ,disc_date -- 贴现日期
            ,discount_brh_no -- 贴现行行机构代码
            ,discount_brh_name -- 贴现行名称
            ,init_brh_no -- 初始权属登记机构
            ,report_of_loss_flag -- 挂失状态
            ,deduct_status -- 扣款状态
            ,risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件支付委托类型： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
            ,endorse_times -- 背书次数
            ,owner_mem_no -- 票据权利人渠道代码
            ,owner_name -- 票据权利人名称
            ,owner_crt_no -- 票据权利人社会信用代码
            ,owner_dist_tp -- 票据权利人识别类型： DT01 票据账户 DT02 银行账户
            ,owner_account -- 票据权利人账号
            ,owner_bank_no -- 票据权利人开户行行号
            ,owner_bank_name -- 票据权利人开户行行名
            ,owner_brh_no -- 票据权利人开户行机构代码
            ,owner_brh_name -- 票据权利人开户行机构名称
            ,lock_flag -- 锁定标志： 0 解锁 1 锁定
            ,src_type -- 票据来源： SR002 质押 SR013 保证 SR014 提示付款 SR015 追偿 SR500 出票 SR503 收票 SR504 背书 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
            ,flow_status -- 票据流转状态： F00 完成 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
            ,status -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S10 已（增信）保证 S14 已结清 S15 已偿付(付款) S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S39 信息已作废 S40 已逾期 S500 已出票登记 S501 已提示承兑 S502 已撤票 S503 已提示收票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
            ,com_status -- 组合状态
            ,belong_name -- 票据所属人名称
            ,belong_crt_no -- 票据所属人社会信用代码
            ,belong_account -- 票据所属人账号
            ,belong_bank_no -- 票据所属人开户行行号
            ,belong_bank_name -- 票据所属人开户行行名
            ,belong_brh_no -- 票据所属人开户行机构代码
            ,belong_brh_name -- 票据所属人开户行机构名称
            ,init_trans_id -- 首次交易ID
            ,concurrent_control -- 并发控制
            ,create_opr -- 创建人
            ,create_time -- 创建时间
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,recovery_hand_flag -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
            ,hand_recovery_lock_flag -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,recept_brh -- 承接机构号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cust_dpc_draft_info_op(
            id -- ID
            ,draft_number -- 票据（包）号
            ,cd_range -- 子票区间
            ,draft_amount -- 票据（包）金额
            ,standard_amt -- 标准金额
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银承 2 商承
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,draft_transfer_flag -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_id -- 原始票据ID
            ,select_draft_id -- 挑票ID
            ,split_draft_id -- 实际拆前票据ID
            ,split_range -- 实际拆前区间
            ,split_control_id -- 登记中心拆包控制表ID
            ,split_status -- 分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_name -- 出票人名称
            ,remitter_crt_no -- 出票人社会信用代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行行名
            ,remitter_brh_no -- 出票人开户行机构代码
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_crt_no -- 承兑人社会信用代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行行名
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_name -- 收款人名称
            ,payee_crt_no -- 收款人社会信用代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_account -- 收款人账号
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payee_brh_no -- 收款人开户行机构代码
            ,payee_brh_name -- 收款人开户行机构名称
            ,drawee_bank_no -- 付款行行号
            ,drawee_brh_no -- 付款行机构代码
            ,drawee_bank_name -- 付款行名称
            ,gua_accept_bank_no -- 承兑保证行行号
            ,gua_accept_brh_no -- 承兑保证行机构代码
            ,collection_bank_no -- 托收行行号
            ,disc_date -- 贴现日期
            ,discount_brh_no -- 贴现行行机构代码
            ,discount_brh_name -- 贴现行名称
            ,init_brh_no -- 初始权属登记机构
            ,report_of_loss_flag -- 挂失状态
            ,deduct_status -- 扣款状态
            ,risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件支付委托类型： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
            ,endorse_times -- 背书次数
            ,owner_mem_no -- 票据权利人渠道代码
            ,owner_name -- 票据权利人名称
            ,owner_crt_no -- 票据权利人社会信用代码
            ,owner_dist_tp -- 票据权利人识别类型： DT01 票据账户 DT02 银行账户
            ,owner_account -- 票据权利人账号
            ,owner_bank_no -- 票据权利人开户行行号
            ,owner_bank_name -- 票据权利人开户行行名
            ,owner_brh_no -- 票据权利人开户行机构代码
            ,owner_brh_name -- 票据权利人开户行机构名称
            ,lock_flag -- 锁定标志： 0 解锁 1 锁定
            ,src_type -- 票据来源： SR002 质押 SR013 保证 SR014 提示付款 SR015 追偿 SR500 出票 SR503 收票 SR504 背书 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
            ,flow_status -- 票据流转状态： F00 完成 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
            ,status -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S10 已（增信）保证 S14 已结清 S15 已偿付(付款) S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S39 信息已作废 S40 已逾期 S500 已出票登记 S501 已提示承兑 S502 已撤票 S503 已提示收票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
            ,com_status -- 组合状态
            ,belong_name -- 票据所属人名称
            ,belong_crt_no -- 票据所属人社会信用代码
            ,belong_account -- 票据所属人账号
            ,belong_bank_no -- 票据所属人开户行行号
            ,belong_bank_name -- 票据所属人开户行行名
            ,belong_brh_no -- 票据所属人开户行机构代码
            ,belong_brh_name -- 票据所属人开户行机构名称
            ,init_trans_id -- 首次交易ID
            ,concurrent_control -- 并发控制
            ,create_opr -- 创建人
            ,create_time -- 创建时间
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,recovery_hand_flag -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
            ,hand_recovery_lock_flag -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,recept_brh -- 承接机构号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据（包）号
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据（包）金额
    ,nvl(n.standard_amt, o.standard_amt) as standard_amt -- 标准金额
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： 1 纸票 2 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： 1 银承 2 商承
    ,nvl(n.product_type, o.product_type) as product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.draft_transfer_flag, o.draft_transfer_flag) as draft_transfer_flag -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
    ,nvl(n.draft_remark, o.draft_remark) as draft_remark -- 票面备注
    ,nvl(n.draft_explain, o.draft_explain) as draft_explain -- 票面说明
    ,nvl(n.cd_split, o.cd_split) as cd_split -- 是否允许分包流转： 0 否 1 是
    ,nvl(n.org_draft_id, o.org_draft_id) as org_draft_id -- 原始票据ID
    ,nvl(n.select_draft_id, o.select_draft_id) as select_draft_id -- 挑票ID
    ,nvl(n.split_draft_id, o.split_draft_id) as split_draft_id -- 实际拆前票据ID
    ,nvl(n.split_range, o.split_range) as split_range -- 实际拆前区间
    ,nvl(n.split_control_id, o.split_control_id) as split_control_id -- 登记中心拆包控制表ID
    ,nvl(n.split_status, o.split_status) as split_status -- 分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余
    ,nvl(n.remitter_mem_no, o.remitter_mem_no) as remitter_mem_no -- 出票人渠道代码
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人名称
    ,nvl(n.remitter_crt_no, o.remitter_crt_no) as remitter_crt_no -- 出票人社会信用代码
    ,nvl(n.remitter_dist_tp, o.remitter_dist_tp) as remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 出票人账号
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 出票人开户行行号
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 出票人开户行行名
    ,nvl(n.remitter_brh_no, o.remitter_brh_no) as remitter_brh_no -- 出票人开户行机构代码
    ,nvl(n.remitter_brh_name, o.remitter_brh_name) as remitter_brh_name -- 出票人开户行机构名称
    ,nvl(n.acceptor_mem_no, o.acceptor_mem_no) as acceptor_mem_no -- 承兑人渠道代码
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人名称
    ,nvl(n.acceptor_crt_no, o.acceptor_crt_no) as acceptor_crt_no -- 承兑人社会信用代码
    ,nvl(n.acceptor_dist_tp, o.acceptor_dist_tp) as acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.acceptor_account, o.acceptor_account) as acceptor_account -- 承兑人账号
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行行号
    ,nvl(n.acceptor_bank_name, o.acceptor_bank_name) as acceptor_bank_name -- 承兑人开户行行名
    ,nvl(n.acceptor_brh_no, o.acceptor_brh_no) as acceptor_brh_no -- 承兑人开户行机构代码
    ,nvl(n.acceptor_brh_name, o.acceptor_brh_name) as acceptor_brh_name -- 承兑人开户行机构名称
    ,nvl(n.payee_mem_no, o.payee_mem_no) as payee_mem_no -- 收款人渠道代码
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 收款人名称
    ,nvl(n.payee_crt_no, o.payee_crt_no) as payee_crt_no -- 收款人社会信用代码
    ,nvl(n.payee_dist_tp, o.payee_dist_tp) as payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 收款人账号
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 收款人开户行行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收款人开户行行名
    ,nvl(n.payee_brh_no, o.payee_brh_no) as payee_brh_no -- 收款人开户行机构代码
    ,nvl(n.payee_brh_name, o.payee_brh_name) as payee_brh_name -- 收款人开户行机构名称
    ,nvl(n.drawee_bank_no, o.drawee_bank_no) as drawee_bank_no -- 付款行行号
    ,nvl(n.drawee_brh_no, o.drawee_brh_no) as drawee_brh_no -- 付款行机构代码
    ,nvl(n.drawee_bank_name, o.drawee_bank_name) as drawee_bank_name -- 付款行名称
    ,nvl(n.gua_accept_bank_no, o.gua_accept_bank_no) as gua_accept_bank_no -- 承兑保证行行号
    ,nvl(n.gua_accept_brh_no, o.gua_accept_brh_no) as gua_accept_brh_no -- 承兑保证行机构代码
    ,nvl(n.collection_bank_no, o.collection_bank_no) as collection_bank_no -- 托收行行号
    ,nvl(n.disc_date, o.disc_date) as disc_date -- 贴现日期
    ,nvl(n.discount_brh_no, o.discount_brh_no) as discount_brh_no -- 贴现行行机构代码
    ,nvl(n.discount_brh_name, o.discount_brh_name) as discount_brh_name -- 贴现行名称
    ,nvl(n.init_brh_no, o.init_brh_no) as init_brh_no -- 初始权属登记机构
    ,nvl(n.report_of_loss_flag, o.report_of_loss_flag) as report_of_loss_flag -- 挂失状态
    ,nvl(n.deduct_status, o.deduct_status) as deduct_status -- 扣款状态
    ,nvl(n.risk_status, o.risk_status) as risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
    ,nvl(n.transfer_flag, o.transfer_flag) as transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,nvl(n.consignment_code, o.consignment_code) as consignment_code -- 到期无条件支付委托类型： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,nvl(n.settle_flag, o.settle_flag) as settle_flag -- 是否结清： 0 否 1 是
    ,nvl(n.recovery_flag, o.recovery_flag) as recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
    ,nvl(n.endorse_times, o.endorse_times) as endorse_times -- 背书次数
    ,nvl(n.owner_mem_no, o.owner_mem_no) as owner_mem_no -- 票据权利人渠道代码
    ,nvl(n.owner_name, o.owner_name) as owner_name -- 票据权利人名称
    ,nvl(n.owner_crt_no, o.owner_crt_no) as owner_crt_no -- 票据权利人社会信用代码
    ,nvl(n.owner_dist_tp, o.owner_dist_tp) as owner_dist_tp -- 票据权利人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.owner_account, o.owner_account) as owner_account -- 票据权利人账号
    ,nvl(n.owner_bank_no, o.owner_bank_no) as owner_bank_no -- 票据权利人开户行行号
    ,nvl(n.owner_bank_name, o.owner_bank_name) as owner_bank_name -- 票据权利人开户行行名
    ,nvl(n.owner_brh_no, o.owner_brh_no) as owner_brh_no -- 票据权利人开户行机构代码
    ,nvl(n.owner_brh_name, o.owner_brh_name) as owner_brh_name -- 票据权利人开户行机构名称
    ,nvl(n.lock_flag, o.lock_flag) as lock_flag -- 锁定标志： 0 解锁 1 锁定
    ,nvl(n.src_type, o.src_type) as src_type -- 票据来源： SR002 质押 SR013 保证 SR014 提示付款 SR015 追偿 SR500 出票 SR503 收票 SR504 背书 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
    ,nvl(n.flow_status, o.flow_status) as flow_status -- 票据流转状态： F00 完成 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
    ,nvl(n.status, o.status) as status -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S10 已（增信）保证 S14 已结清 S15 已偿付(付款) S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S39 信息已作废 S40 已逾期 S500 已出票登记 S501 已提示承兑 S502 已撤票 S503 已提示收票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
    ,nvl(n.com_status, o.com_status) as com_status -- 组合状态
    ,nvl(n.belong_name, o.belong_name) as belong_name -- 票据所属人名称
    ,nvl(n.belong_crt_no, o.belong_crt_no) as belong_crt_no -- 票据所属人社会信用代码
    ,nvl(n.belong_account, o.belong_account) as belong_account -- 票据所属人账号
    ,nvl(n.belong_bank_no, o.belong_bank_no) as belong_bank_no -- 票据所属人开户行行号
    ,nvl(n.belong_bank_name, o.belong_bank_name) as belong_bank_name -- 票据所属人开户行行名
    ,nvl(n.belong_brh_no, o.belong_brh_no) as belong_brh_no -- 票据所属人开户行机构代码
    ,nvl(n.belong_brh_name, o.belong_brh_name) as belong_brh_name -- 票据所属人开户行机构名称
    ,nvl(n.init_trans_id, o.init_trans_id) as init_trans_id -- 首次交易ID
    ,nvl(n.concurrent_control, o.concurrent_control) as concurrent_control -- 并发控制
    ,nvl(n.create_opr, o.create_opr) as create_opr -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注域
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用字段3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备用字段4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备用字段5
    ,nvl(n.reserve6, o.reserve6) as reserve6 -- 备用字段6
    ,nvl(n.recovery_hand_flag, o.recovery_hand_flag) as recovery_hand_flag -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
    ,nvl(n.hand_recovery_lock_flag, o.hand_recovery_lock_flag) as hand_recovery_lock_flag -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
    ,nvl(n.acceptor_acctname, o.acceptor_acctname) as acceptor_acctname -- 承兑人账户名称
    ,nvl(n.remitter_acctname, o.remitter_acctname) as remitter_acctname -- 出票人账户名称
    ,nvl(n.payee_acctname, o.payee_acctname) as payee_acctname -- 收款人账户名称
    ,nvl(n.recept_brh, o.recept_brh) as recept_brh -- 承接机构号
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结清日期
    ,nvl(n.migrate_flag, o.migrate_flag) as migrate_flag -- ECDS迁移票据标志
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
from (select * from ${iol_schema}.bdms_cust_dpc_draft_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cust_dpc_draft_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.draft_number <> n.draft_number
        or o.cd_range <> n.cd_range
        or o.draft_amount <> n.draft_amount
        or o.standard_amt <> n.standard_amt
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.product_type <> n.product_type
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.draft_transfer_flag <> n.draft_transfer_flag
        or o.draft_remark <> n.draft_remark
        or o.draft_explain <> n.draft_explain
        or o.cd_split <> n.cd_split
        or o.org_draft_id <> n.org_draft_id
        or o.select_draft_id <> n.select_draft_id
        or o.split_draft_id <> n.split_draft_id
        or o.split_range <> n.split_range
        or o.split_control_id <> n.split_control_id
        or o.split_status <> n.split_status
        or o.remitter_mem_no <> n.remitter_mem_no
        or o.remitter_name <> n.remitter_name
        or o.remitter_crt_no <> n.remitter_crt_no
        or o.remitter_dist_tp <> n.remitter_dist_tp
        or o.remitter_account <> n.remitter_account
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.remitter_brh_no <> n.remitter_brh_no
        or o.remitter_brh_name <> n.remitter_brh_name
        or o.acceptor_mem_no <> n.acceptor_mem_no
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_crt_no <> n.acceptor_crt_no
        or o.acceptor_dist_tp <> n.acceptor_dist_tp
        or o.acceptor_account <> n.acceptor_account
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_bank_name <> n.acceptor_bank_name
        or o.acceptor_brh_no <> n.acceptor_brh_no
        or o.acceptor_brh_name <> n.acceptor_brh_name
        or o.payee_mem_no <> n.payee_mem_no
        or o.payee_name <> n.payee_name
        or o.payee_crt_no <> n.payee_crt_no
        or o.payee_dist_tp <> n.payee_dist_tp
        or o.payee_account <> n.payee_account
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.payee_brh_no <> n.payee_brh_no
        or o.payee_brh_name <> n.payee_brh_name
        or o.drawee_bank_no <> n.drawee_bank_no
        or o.drawee_brh_no <> n.drawee_brh_no
        or o.drawee_bank_name <> n.drawee_bank_name
        or o.gua_accept_bank_no <> n.gua_accept_bank_no
        or o.gua_accept_brh_no <> n.gua_accept_brh_no
        or o.collection_bank_no <> n.collection_bank_no
        or o.disc_date <> n.disc_date
        or o.discount_brh_no <> n.discount_brh_no
        or o.discount_brh_name <> n.discount_brh_name
        or o.init_brh_no <> n.init_brh_no
        or o.report_of_loss_flag <> n.report_of_loss_flag
        or o.deduct_status <> n.deduct_status
        or o.risk_status <> n.risk_status
        or o.transfer_flag <> n.transfer_flag
        or o.consignment_code <> n.consignment_code
        or o.settle_flag <> n.settle_flag
        or o.recovery_flag <> n.recovery_flag
        or o.endorse_times <> n.endorse_times
        or o.owner_mem_no <> n.owner_mem_no
        or o.owner_name <> n.owner_name
        or o.owner_crt_no <> n.owner_crt_no
        or o.owner_dist_tp <> n.owner_dist_tp
        or o.owner_account <> n.owner_account
        or o.owner_bank_no <> n.owner_bank_no
        or o.owner_bank_name <> n.owner_bank_name
        or o.owner_brh_no <> n.owner_brh_no
        or o.owner_brh_name <> n.owner_brh_name
        or o.lock_flag <> n.lock_flag
        or o.src_type <> n.src_type
        or o.flow_status <> n.flow_status
        or o.status <> n.status
        or o.com_status <> n.com_status
        or o.belong_name <> n.belong_name
        or o.belong_crt_no <> n.belong_crt_no
        or o.belong_account <> n.belong_account
        or o.belong_bank_no <> n.belong_bank_no
        or o.belong_bank_name <> n.belong_bank_name
        or o.belong_brh_no <> n.belong_brh_no
        or o.belong_brh_name <> n.belong_brh_name
        or o.init_trans_id <> n.init_trans_id
        or o.concurrent_control <> n.concurrent_control
        or o.create_opr <> n.create_opr
        or o.create_time <> n.create_time
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.reserve6 <> n.reserve6
        or o.recovery_hand_flag <> n.recovery_hand_flag
        or o.hand_recovery_lock_flag <> n.hand_recovery_lock_flag
        or o.acceptor_acctname <> n.acceptor_acctname
        or o.remitter_acctname <> n.remitter_acctname
        or o.payee_acctname <> n.payee_acctname
        or o.recept_brh <> n.recept_brh
        or o.settle_date <> n.settle_date
        or o.migrate_flag <> n.migrate_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cust_dpc_draft_info_cl(
            id -- ID
            ,draft_number -- 票据（包）号
            ,cd_range -- 子票区间
            ,draft_amount -- 票据（包）金额
            ,standard_amt -- 标准金额
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银承 2 商承
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,draft_transfer_flag -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_id -- 原始票据ID
            ,select_draft_id -- 挑票ID
            ,split_draft_id -- 实际拆前票据ID
            ,split_range -- 实际拆前区间
            ,split_control_id -- 登记中心拆包控制表ID
            ,split_status -- 分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_name -- 出票人名称
            ,remitter_crt_no -- 出票人社会信用代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行行名
            ,remitter_brh_no -- 出票人开户行机构代码
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_crt_no -- 承兑人社会信用代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行行名
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_name -- 收款人名称
            ,payee_crt_no -- 收款人社会信用代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_account -- 收款人账号
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payee_brh_no -- 收款人开户行机构代码
            ,payee_brh_name -- 收款人开户行机构名称
            ,drawee_bank_no -- 付款行行号
            ,drawee_brh_no -- 付款行机构代码
            ,drawee_bank_name -- 付款行名称
            ,gua_accept_bank_no -- 承兑保证行行号
            ,gua_accept_brh_no -- 承兑保证行机构代码
            ,collection_bank_no -- 托收行行号
            ,disc_date -- 贴现日期
            ,discount_brh_no -- 贴现行行机构代码
            ,discount_brh_name -- 贴现行名称
            ,init_brh_no -- 初始权属登记机构
            ,report_of_loss_flag -- 挂失状态
            ,deduct_status -- 扣款状态
            ,risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件支付委托类型： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
            ,endorse_times -- 背书次数
            ,owner_mem_no -- 票据权利人渠道代码
            ,owner_name -- 票据权利人名称
            ,owner_crt_no -- 票据权利人社会信用代码
            ,owner_dist_tp -- 票据权利人识别类型： DT01 票据账户 DT02 银行账户
            ,owner_account -- 票据权利人账号
            ,owner_bank_no -- 票据权利人开户行行号
            ,owner_bank_name -- 票据权利人开户行行名
            ,owner_brh_no -- 票据权利人开户行机构代码
            ,owner_brh_name -- 票据权利人开户行机构名称
            ,lock_flag -- 锁定标志： 0 解锁 1 锁定
            ,src_type -- 票据来源： SR002 质押 SR013 保证 SR014 提示付款 SR015 追偿 SR500 出票 SR503 收票 SR504 背书 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
            ,flow_status -- 票据流转状态： F00 完成 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
            ,status -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S10 已（增信）保证 S14 已结清 S15 已偿付(付款) S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S39 信息已作废 S40 已逾期 S500 已出票登记 S501 已提示承兑 S502 已撤票 S503 已提示收票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
            ,com_status -- 组合状态
            ,belong_name -- 票据所属人名称
            ,belong_crt_no -- 票据所属人社会信用代码
            ,belong_account -- 票据所属人账号
            ,belong_bank_no -- 票据所属人开户行行号
            ,belong_bank_name -- 票据所属人开户行行名
            ,belong_brh_no -- 票据所属人开户行机构代码
            ,belong_brh_name -- 票据所属人开户行机构名称
            ,init_trans_id -- 首次交易ID
            ,concurrent_control -- 并发控制
            ,create_opr -- 创建人
            ,create_time -- 创建时间
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,recovery_hand_flag -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
            ,hand_recovery_lock_flag -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,recept_brh -- 承接机构号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cust_dpc_draft_info_op(
            id -- ID
            ,draft_number -- 票据（包）号
            ,cd_range -- 子票区间
            ,draft_amount -- 票据（包）金额
            ,standard_amt -- 标准金额
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银承 2 商承
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,draft_transfer_flag -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_id -- 原始票据ID
            ,select_draft_id -- 挑票ID
            ,split_draft_id -- 实际拆前票据ID
            ,split_range -- 实际拆前区间
            ,split_control_id -- 登记中心拆包控制表ID
            ,split_status -- 分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_name -- 出票人名称
            ,remitter_crt_no -- 出票人社会信用代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行行名
            ,remitter_brh_no -- 出票人开户行机构代码
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_crt_no -- 承兑人社会信用代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行行名
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_name -- 收款人名称
            ,payee_crt_no -- 收款人社会信用代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_account -- 收款人账号
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payee_brh_no -- 收款人开户行机构代码
            ,payee_brh_name -- 收款人开户行机构名称
            ,drawee_bank_no -- 付款行行号
            ,drawee_brh_no -- 付款行机构代码
            ,drawee_bank_name -- 付款行名称
            ,gua_accept_bank_no -- 承兑保证行行号
            ,gua_accept_brh_no -- 承兑保证行机构代码
            ,collection_bank_no -- 托收行行号
            ,disc_date -- 贴现日期
            ,discount_brh_no -- 贴现行行机构代码
            ,discount_brh_name -- 贴现行名称
            ,init_brh_no -- 初始权属登记机构
            ,report_of_loss_flag -- 挂失状态
            ,deduct_status -- 扣款状态
            ,risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件支付委托类型： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
            ,endorse_times -- 背书次数
            ,owner_mem_no -- 票据权利人渠道代码
            ,owner_name -- 票据权利人名称
            ,owner_crt_no -- 票据权利人社会信用代码
            ,owner_dist_tp -- 票据权利人识别类型： DT01 票据账户 DT02 银行账户
            ,owner_account -- 票据权利人账号
            ,owner_bank_no -- 票据权利人开户行行号
            ,owner_bank_name -- 票据权利人开户行行名
            ,owner_brh_no -- 票据权利人开户行机构代码
            ,owner_brh_name -- 票据权利人开户行机构名称
            ,lock_flag -- 锁定标志： 0 解锁 1 锁定
            ,src_type -- 票据来源： SR002 质押 SR013 保证 SR014 提示付款 SR015 追偿 SR500 出票 SR503 收票 SR504 背书 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
            ,flow_status -- 票据流转状态： F00 完成 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
            ,status -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S10 已（增信）保证 S14 已结清 S15 已偿付(付款) S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S39 信息已作废 S40 已逾期 S500 已出票登记 S501 已提示承兑 S502 已撤票 S503 已提示收票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
            ,com_status -- 组合状态
            ,belong_name -- 票据所属人名称
            ,belong_crt_no -- 票据所属人社会信用代码
            ,belong_account -- 票据所属人账号
            ,belong_bank_no -- 票据所属人开户行行号
            ,belong_bank_name -- 票据所属人开户行行名
            ,belong_brh_no -- 票据所属人开户行机构代码
            ,belong_brh_name -- 票据所属人开户行机构名称
            ,init_trans_id -- 首次交易ID
            ,concurrent_control -- 并发控制
            ,create_opr -- 创建人
            ,create_time -- 创建时间
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,recovery_hand_flag -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
            ,hand_recovery_lock_flag -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,recept_brh -- 承接机构号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.draft_number -- 票据（包）号
    ,o.cd_range -- 子票区间
    ,o.draft_amount -- 票据（包）金额
    ,o.standard_amt -- 标准金额
    ,o.draft_attr -- 票据介质： 1 纸票 2 电票
    ,o.draft_type -- 票据类型： 1 银承 2 商承
    ,o.product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,o.remit_date -- 出票日
    ,o.maturity_date -- 到期日
    ,o.draft_transfer_flag -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
    ,o.draft_remark -- 票面备注
    ,o.draft_explain -- 票面说明
    ,o.cd_split -- 是否允许分包流转： 0 否 1 是
    ,o.org_draft_id -- 原始票据ID
    ,o.select_draft_id -- 挑票ID
    ,o.split_draft_id -- 实际拆前票据ID
    ,o.split_range -- 实际拆前区间
    ,o.split_control_id -- 登记中心拆包控制表ID
    ,o.split_status -- 分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余
    ,o.remitter_mem_no -- 出票人渠道代码
    ,o.remitter_name -- 出票人名称
    ,o.remitter_crt_no -- 出票人社会信用代码
    ,o.remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
    ,o.remitter_account -- 出票人账号
    ,o.remitter_bank_no -- 出票人开户行行号
    ,o.remitter_bank_name -- 出票人开户行行名
    ,o.remitter_brh_no -- 出票人开户行机构代码
    ,o.remitter_brh_name -- 出票人开户行机构名称
    ,o.acceptor_mem_no -- 承兑人渠道代码
    ,o.acceptor_name -- 承兑人名称
    ,o.acceptor_crt_no -- 承兑人社会信用代码
    ,o.acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
    ,o.acceptor_account -- 承兑人账号
    ,o.acceptor_bank_no -- 承兑人开户行行号
    ,o.acceptor_bank_name -- 承兑人开户行行名
    ,o.acceptor_brh_no -- 承兑人开户行机构代码
    ,o.acceptor_brh_name -- 承兑人开户行机构名称
    ,o.payee_mem_no -- 收款人渠道代码
    ,o.payee_name -- 收款人名称
    ,o.payee_crt_no -- 收款人社会信用代码
    ,o.payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
    ,o.payee_account -- 收款人账号
    ,o.payee_bank_no -- 收款人开户行行号
    ,o.payee_bank_name -- 收款人开户行行名
    ,o.payee_brh_no -- 收款人开户行机构代码
    ,o.payee_brh_name -- 收款人开户行机构名称
    ,o.drawee_bank_no -- 付款行行号
    ,o.drawee_brh_no -- 付款行机构代码
    ,o.drawee_bank_name -- 付款行名称
    ,o.gua_accept_bank_no -- 承兑保证行行号
    ,o.gua_accept_brh_no -- 承兑保证行机构代码
    ,o.collection_bank_no -- 托收行行号
    ,o.disc_date -- 贴现日期
    ,o.discount_brh_no -- 贴现行行机构代码
    ,o.discount_brh_name -- 贴现行名称
    ,o.init_brh_no -- 初始权属登记机构
    ,o.report_of_loss_flag -- 挂失状态
    ,o.deduct_status -- 扣款状态
    ,o.risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
    ,o.transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,o.consignment_code -- 到期无条件支付委托类型： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,o.settle_flag -- 是否结清： 0 否 1 是
    ,o.recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
    ,o.endorse_times -- 背书次数
    ,o.owner_mem_no -- 票据权利人渠道代码
    ,o.owner_name -- 票据权利人名称
    ,o.owner_crt_no -- 票据权利人社会信用代码
    ,o.owner_dist_tp -- 票据权利人识别类型： DT01 票据账户 DT02 银行账户
    ,o.owner_account -- 票据权利人账号
    ,o.owner_bank_no -- 票据权利人开户行行号
    ,o.owner_bank_name -- 票据权利人开户行行名
    ,o.owner_brh_no -- 票据权利人开户行机构代码
    ,o.owner_brh_name -- 票据权利人开户行机构名称
    ,o.lock_flag -- 锁定标志： 0 解锁 1 锁定
    ,o.src_type -- 票据来源： SR002 质押 SR013 保证 SR014 提示付款 SR015 追偿 SR500 出票 SR503 收票 SR504 背书 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
    ,o.flow_status -- 票据流转状态： F00 完成 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
    ,o.status -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S10 已（增信）保证 S14 已结清 S15 已偿付(付款) S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S39 信息已作废 S40 已逾期 S500 已出票登记 S501 已提示承兑 S502 已撤票 S503 已提示收票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
    ,o.com_status -- 组合状态
    ,o.belong_name -- 票据所属人名称
    ,o.belong_crt_no -- 票据所属人社会信用代码
    ,o.belong_account -- 票据所属人账号
    ,o.belong_bank_no -- 票据所属人开户行行号
    ,o.belong_bank_name -- 票据所属人开户行行名
    ,o.belong_brh_no -- 票据所属人开户行机构代码
    ,o.belong_brh_name -- 票据所属人开户行机构名称
    ,o.init_trans_id -- 首次交易ID
    ,o.concurrent_control -- 并发控制
    ,o.create_opr -- 创建人
    ,o.create_time -- 创建时间
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注域
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.reserve3 -- 备用字段3
    ,o.reserve4 -- 备用字段4
    ,o.reserve5 -- 备用字段5
    ,o.reserve6 -- 备用字段6
    ,o.recovery_hand_flag -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
    ,o.hand_recovery_lock_flag -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
    ,o.acceptor_acctname -- 承兑人账户名称
    ,o.remitter_acctname -- 出票人账户名称
    ,o.payee_acctname -- 收款人账户名称
    ,o.recept_brh -- 承接机构号
    ,o.settle_date -- 结清日期
    ,o.migrate_flag -- ECDS迁移票据标志
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
from ${iol_schema}.bdms_cust_dpc_draft_info_bk o
    left join ${iol_schema}.bdms_cust_dpc_draft_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cust_dpc_draft_info_cl d
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
--truncate table ${iol_schema}.bdms_cust_dpc_draft_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cust_dpc_draft_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cust_dpc_draft_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cust_dpc_draft_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cust_dpc_draft_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_cust_dpc_draft_info_cl;
alter table ${iol_schema}.bdms_cust_dpc_draft_info exchange partition p_20991231 with table ${iol_schema}.bdms_cust_dpc_draft_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cust_dpc_draft_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cust_dpc_draft_info_op purge;
drop table ${iol_schema}.bdms_cust_dpc_draft_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cust_dpc_draft_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cust_dpc_draft_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
