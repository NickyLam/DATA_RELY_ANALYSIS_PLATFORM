/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_accept_due_pay
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
create table ${iol_schema}.bdms_bms_accept_due_pay_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_accept_due_pay
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_accept_due_pay_op purge;
drop table ${iol_schema}.bdms_bms_accept_due_pay_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_accept_due_pay_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_accept_due_pay where 0=1;

create table ${iol_schema}.bdms_bms_accept_due_pay_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_accept_due_pay where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_accept_due_pay_cl(
            id -- ID
            ,branch_no -- 交易机构编号
            ,acpt_id -- 清单ID
            ,draft_id -- 票据信息ID
            ,isse_curcd -- 票据币种： CNY 人民币
            ,draft_amount -- 票据金额
            ,mesg_type -- 报文种类
            ,apply_date -- 提示付款/逾期提示付款申请日期
            ,ovrdue_rsn -- 逾期原因说明
            ,apply_curcd -- 提示付款币种： CNY 人民币
            ,apply_amount -- 提示付款金额
            ,sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
            ,voc_cnt -- 所附凭证张数
            ,accept_curcd -- 兑付币种： CNY 人民币
            ,accept_amount -- 兑付金额
            ,payee_bank_no -- 解付申请人开户行行号
            ,payee_bank_name -- 解付申请人开户行
            ,payee_name -- 解付申请人
            ,payee_account -- 解付申请人帐号
            ,receive_date -- 提示付款申请日期
            ,operator_no -- 回复操作员号
            ,repay_sig_mk -- 回复意见： SU00 同意 SU01 拒绝
            ,dish_code -- 拒付代码： DC00 与自己有直接债权债务关系的持票人未履行约定义务 DC01 持票人以欺诈、偷盗或者胁迫等手段取得票据 DC02 持票人明知有欺诈、偷盗或者胁迫等情形，出于恶意取得票据 DC03 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 DC04 持票人因重大过失取得不符合《票据法》规定的票据 DC05 超过提示付款期 DC06 被法院冻结或收到法院止付通知书 DC07 票据未到期 DC08 商业承兑汇票承兑人账户余额不足 DC09 其他（必须注明）
            ,appstatus -- 审批状态： 0 已接收未提交 1 受理已提交 2 记账 3 已拒付(处理纸票拒付交易时增加)
            ,acpay_status -- 发出签收明细状态： 00 到期付款时我方未签收 11 到期付款时签收通讯中 12 到期付款时签收通讯成功 21 到期付款时签收通讯失败 22 到期付款时签收已确认失败 25 线上清算失败 26 清分失败回复 31 到期付款时签收已确认成功 90 到期付款已交易成功(记账) 91 到期付款时对方已撤回申请
            ,endst_date -- 签收日期
            ,sig_mk -- 签收意见： SU00 同意 SU01 拒绝
            ,cancel_date -- 撤销日期
            ,account_date -- 记账日期
            ,account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,trf_ref -- 线上清算结果-特许参与者号码
            ,trf_id -- 线上清算结果-支付交易序号
            ,dualcontrol_lockstatus -- 双杠复核锁标记
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,endor_num -- 背书次数
            ,payee_type -- 解付类型： A 正常 B 提前
            ,payee_reserve -- 提前解付原因
            ,dish_rsn -- 拒付备注
            ,drft_hldr_cmonid -- 提示付款人组织机构代码
            ,drft_hldr_role -- 提示付款人类别RC00接入行RC01企业RC02人民银行RC03被代理行RC04被代理财务公司RC05接入财务公司
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,position_audit_status -- 头寸审批状态
            ,position_seqno -- 头寸交易流水
            ,req_remark -- 请求方申请备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_accept_due_pay_op(
            id -- ID
            ,branch_no -- 交易机构编号
            ,acpt_id -- 清单ID
            ,draft_id -- 票据信息ID
            ,isse_curcd -- 票据币种： CNY 人民币
            ,draft_amount -- 票据金额
            ,mesg_type -- 报文种类
            ,apply_date -- 提示付款/逾期提示付款申请日期
            ,ovrdue_rsn -- 逾期原因说明
            ,apply_curcd -- 提示付款币种： CNY 人民币
            ,apply_amount -- 提示付款金额
            ,sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
            ,voc_cnt -- 所附凭证张数
            ,accept_curcd -- 兑付币种： CNY 人民币
            ,accept_amount -- 兑付金额
            ,payee_bank_no -- 解付申请人开户行行号
            ,payee_bank_name -- 解付申请人开户行
            ,payee_name -- 解付申请人
            ,payee_account -- 解付申请人帐号
            ,receive_date -- 提示付款申请日期
            ,operator_no -- 回复操作员号
            ,repay_sig_mk -- 回复意见： SU00 同意 SU01 拒绝
            ,dish_code -- 拒付代码： DC00 与自己有直接债权债务关系的持票人未履行约定义务 DC01 持票人以欺诈、偷盗或者胁迫等手段取得票据 DC02 持票人明知有欺诈、偷盗或者胁迫等情形，出于恶意取得票据 DC03 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 DC04 持票人因重大过失取得不符合《票据法》规定的票据 DC05 超过提示付款期 DC06 被法院冻结或收到法院止付通知书 DC07 票据未到期 DC08 商业承兑汇票承兑人账户余额不足 DC09 其他（必须注明）
            ,appstatus -- 审批状态： 0 已接收未提交 1 受理已提交 2 记账 3 已拒付(处理纸票拒付交易时增加)
            ,acpay_status -- 发出签收明细状态： 00 到期付款时我方未签收 11 到期付款时签收通讯中 12 到期付款时签收通讯成功 21 到期付款时签收通讯失败 22 到期付款时签收已确认失败 25 线上清算失败 26 清分失败回复 31 到期付款时签收已确认成功 90 到期付款已交易成功(记账) 91 到期付款时对方已撤回申请
            ,endst_date -- 签收日期
            ,sig_mk -- 签收意见： SU00 同意 SU01 拒绝
            ,cancel_date -- 撤销日期
            ,account_date -- 记账日期
            ,account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,trf_ref -- 线上清算结果-特许参与者号码
            ,trf_id -- 线上清算结果-支付交易序号
            ,dualcontrol_lockstatus -- 双杠复核锁标记
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,endor_num -- 背书次数
            ,payee_type -- 解付类型： A 正常 B 提前
            ,payee_reserve -- 提前解付原因
            ,dish_rsn -- 拒付备注
            ,drft_hldr_cmonid -- 提示付款人组织机构代码
            ,drft_hldr_role -- 提示付款人类别RC00接入行RC01企业RC02人民银行RC03被代理行RC04被代理财务公司RC05接入财务公司
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,position_audit_status -- 头寸审批状态
            ,position_seqno -- 头寸交易流水
            ,req_remark -- 请求方申请备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 交易机构编号
    ,nvl(n.acpt_id, o.acpt_id) as acpt_id -- 清单ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据信息ID
    ,nvl(n.isse_curcd, o.isse_curcd) as isse_curcd -- 票据币种： CNY 人民币
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据金额
    ,nvl(n.mesg_type, o.mesg_type) as mesg_type -- 报文种类
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 提示付款/逾期提示付款申请日期
    ,nvl(n.ovrdue_rsn, o.ovrdue_rsn) as ovrdue_rsn -- 逾期原因说明
    ,nvl(n.apply_curcd, o.apply_curcd) as apply_curcd -- 提示付款币种： CNY 人民币
    ,nvl(n.apply_amount, o.apply_amount) as apply_amount -- 提示付款金额
    ,nvl(n.sttlm_mk, o.sttlm_mk) as sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,nvl(n.voc_cnt, o.voc_cnt) as voc_cnt -- 所附凭证张数
    ,nvl(n.accept_curcd, o.accept_curcd) as accept_curcd -- 兑付币种： CNY 人民币
    ,nvl(n.accept_amount, o.accept_amount) as accept_amount -- 兑付金额
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 解付申请人开户行行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 解付申请人开户行
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 解付申请人
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 解付申请人帐号
    ,nvl(n.receive_date, o.receive_date) as receive_date -- 提示付款申请日期
    ,nvl(n.operator_no, o.operator_no) as operator_no -- 回复操作员号
    ,nvl(n.repay_sig_mk, o.repay_sig_mk) as repay_sig_mk -- 回复意见： SU00 同意 SU01 拒绝
    ,nvl(n.dish_code, o.dish_code) as dish_code -- 拒付代码： DC00 与自己有直接债权债务关系的持票人未履行约定义务 DC01 持票人以欺诈、偷盗或者胁迫等手段取得票据 DC02 持票人明知有欺诈、偷盗或者胁迫等情形，出于恶意取得票据 DC03 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 DC04 持票人因重大过失取得不符合《票据法》规定的票据 DC05 超过提示付款期 DC06 被法院冻结或收到法院止付通知书 DC07 票据未到期 DC08 商业承兑汇票承兑人账户余额不足 DC09 其他（必须注明）
    ,nvl(n.appstatus, o.appstatus) as appstatus -- 审批状态： 0 已接收未提交 1 受理已提交 2 记账 3 已拒付(处理纸票拒付交易时增加)
    ,nvl(n.acpay_status, o.acpay_status) as acpay_status -- 发出签收明细状态： 00 到期付款时我方未签收 11 到期付款时签收通讯中 12 到期付款时签收通讯成功 21 到期付款时签收通讯失败 22 到期付款时签收已确认失败 25 线上清算失败 26 清分失败回复 31 到期付款时签收已确认成功 90 到期付款已交易成功(记账) 91 到期付款时对方已撤回申请
    ,nvl(n.endst_date, o.endst_date) as endst_date -- 签收日期
    ,nvl(n.sig_mk, o.sig_mk) as sig_mk -- 签收意见： SU00 同意 SU01 拒绝
    ,nvl(n.cancel_date, o.cancel_date) as cancel_date -- 撤销日期
    ,nvl(n.account_date, o.account_date) as account_date -- 记账日期
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,nvl(n.trf_ref, o.trf_ref) as trf_ref -- 线上清算结果-特许参与者号码
    ,nvl(n.trf_id, o.trf_id) as trf_id -- 线上清算结果-支付交易序号
    ,nvl(n.dualcontrol_lockstatus, o.dualcontrol_lockstatus) as dualcontrol_lockstatus -- 双杠复核锁标记
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.endor_num, o.endor_num) as endor_num -- 背书次数
    ,nvl(n.payee_type, o.payee_type) as payee_type -- 解付类型： A 正常 B 提前
    ,nvl(n.payee_reserve, o.payee_reserve) as payee_reserve -- 提前解付原因
    ,nvl(n.dish_rsn, o.dish_rsn) as dish_rsn -- 拒付备注
    ,nvl(n.drft_hldr_cmonid, o.drft_hldr_cmonid) as drft_hldr_cmonid -- 提示付款人组织机构代码
    ,nvl(n.drft_hldr_role, o.drft_hldr_role) as drft_hldr_role -- 提示付款人类别RC00接入行RC01企业RC02人民银行RC03被代理行RC04被代理财务公司RC05接入财务公司
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后修改操作员号
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.position_audit_status, o.position_audit_status) as position_audit_status -- 头寸审批状态
    ,nvl(n.position_seqno, o.position_seqno) as position_seqno -- 头寸交易流水
    ,nvl(n.req_remark, o.req_remark) as req_remark -- 请求方申请备注
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
from (select * from ${iol_schema}.bdms_bms_accept_due_pay_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_accept_due_pay where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.branch_no <> n.branch_no
        or o.acpt_id <> n.acpt_id
        or o.draft_id <> n.draft_id
        or o.isse_curcd <> n.isse_curcd
        or o.draft_amount <> n.draft_amount
        or o.mesg_type <> n.mesg_type
        or o.apply_date <> n.apply_date
        or o.ovrdue_rsn <> n.ovrdue_rsn
        or o.apply_curcd <> n.apply_curcd
        or o.apply_amount <> n.apply_amount
        or o.sttlm_mk <> n.sttlm_mk
        or o.voc_cnt <> n.voc_cnt
        or o.accept_curcd <> n.accept_curcd
        or o.accept_amount <> n.accept_amount
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.payee_name <> n.payee_name
        or o.payee_account <> n.payee_account
        or o.receive_date <> n.receive_date
        or o.operator_no <> n.operator_no
        or o.repay_sig_mk <> n.repay_sig_mk
        or o.dish_code <> n.dish_code
        or o.appstatus <> n.appstatus
        or o.acpay_status <> n.acpay_status
        or o.endst_date <> n.endst_date
        or o.sig_mk <> n.sig_mk
        or o.cancel_date <> n.cancel_date
        or o.account_date <> n.account_date
        or o.account_flag <> n.account_flag
        or o.trf_ref <> n.trf_ref
        or o.trf_id <> n.trf_id
        or o.dualcontrol_lockstatus <> n.dualcontrol_lockstatus
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.endor_num <> n.endor_num
        or o.payee_type <> n.payee_type
        or o.payee_reserve <> n.payee_reserve
        or o.dish_rsn <> n.dish_rsn
        or o.drft_hldr_cmonid <> n.drft_hldr_cmonid
        or o.drft_hldr_role <> n.drft_hldr_role
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.position_audit_status <> n.position_audit_status
        or o.position_seqno <> n.position_seqno
        or o.req_remark <> n.req_remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_accept_due_pay_cl(
            id -- ID
            ,branch_no -- 交易机构编号
            ,acpt_id -- 清单ID
            ,draft_id -- 票据信息ID
            ,isse_curcd -- 票据币种： CNY 人民币
            ,draft_amount -- 票据金额
            ,mesg_type -- 报文种类
            ,apply_date -- 提示付款/逾期提示付款申请日期
            ,ovrdue_rsn -- 逾期原因说明
            ,apply_curcd -- 提示付款币种： CNY 人民币
            ,apply_amount -- 提示付款金额
            ,sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
            ,voc_cnt -- 所附凭证张数
            ,accept_curcd -- 兑付币种： CNY 人民币
            ,accept_amount -- 兑付金额
            ,payee_bank_no -- 解付申请人开户行行号
            ,payee_bank_name -- 解付申请人开户行
            ,payee_name -- 解付申请人
            ,payee_account -- 解付申请人帐号
            ,receive_date -- 提示付款申请日期
            ,operator_no -- 回复操作员号
            ,repay_sig_mk -- 回复意见： SU00 同意 SU01 拒绝
            ,dish_code -- 拒付代码： DC00 与自己有直接债权债务关系的持票人未履行约定义务 DC01 持票人以欺诈、偷盗或者胁迫等手段取得票据 DC02 持票人明知有欺诈、偷盗或者胁迫等情形，出于恶意取得票据 DC03 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 DC04 持票人因重大过失取得不符合《票据法》规定的票据 DC05 超过提示付款期 DC06 被法院冻结或收到法院止付通知书 DC07 票据未到期 DC08 商业承兑汇票承兑人账户余额不足 DC09 其他（必须注明）
            ,appstatus -- 审批状态： 0 已接收未提交 1 受理已提交 2 记账 3 已拒付(处理纸票拒付交易时增加)
            ,acpay_status -- 发出签收明细状态： 00 到期付款时我方未签收 11 到期付款时签收通讯中 12 到期付款时签收通讯成功 21 到期付款时签收通讯失败 22 到期付款时签收已确认失败 25 线上清算失败 26 清分失败回复 31 到期付款时签收已确认成功 90 到期付款已交易成功(记账) 91 到期付款时对方已撤回申请
            ,endst_date -- 签收日期
            ,sig_mk -- 签收意见： SU00 同意 SU01 拒绝
            ,cancel_date -- 撤销日期
            ,account_date -- 记账日期
            ,account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,trf_ref -- 线上清算结果-特许参与者号码
            ,trf_id -- 线上清算结果-支付交易序号
            ,dualcontrol_lockstatus -- 双杠复核锁标记
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,endor_num -- 背书次数
            ,payee_type -- 解付类型： A 正常 B 提前
            ,payee_reserve -- 提前解付原因
            ,dish_rsn -- 拒付备注
            ,drft_hldr_cmonid -- 提示付款人组织机构代码
            ,drft_hldr_role -- 提示付款人类别RC00接入行RC01企业RC02人民银行RC03被代理行RC04被代理财务公司RC05接入财务公司
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,position_audit_status -- 头寸审批状态
            ,position_seqno -- 头寸交易流水
            ,req_remark -- 请求方申请备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_accept_due_pay_op(
            id -- ID
            ,branch_no -- 交易机构编号
            ,acpt_id -- 清单ID
            ,draft_id -- 票据信息ID
            ,isse_curcd -- 票据币种： CNY 人民币
            ,draft_amount -- 票据金额
            ,mesg_type -- 报文种类
            ,apply_date -- 提示付款/逾期提示付款申请日期
            ,ovrdue_rsn -- 逾期原因说明
            ,apply_curcd -- 提示付款币种： CNY 人民币
            ,apply_amount -- 提示付款金额
            ,sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
            ,voc_cnt -- 所附凭证张数
            ,accept_curcd -- 兑付币种： CNY 人民币
            ,accept_amount -- 兑付金额
            ,payee_bank_no -- 解付申请人开户行行号
            ,payee_bank_name -- 解付申请人开户行
            ,payee_name -- 解付申请人
            ,payee_account -- 解付申请人帐号
            ,receive_date -- 提示付款申请日期
            ,operator_no -- 回复操作员号
            ,repay_sig_mk -- 回复意见： SU00 同意 SU01 拒绝
            ,dish_code -- 拒付代码： DC00 与自己有直接债权债务关系的持票人未履行约定义务 DC01 持票人以欺诈、偷盗或者胁迫等手段取得票据 DC02 持票人明知有欺诈、偷盗或者胁迫等情形，出于恶意取得票据 DC03 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 DC04 持票人因重大过失取得不符合《票据法》规定的票据 DC05 超过提示付款期 DC06 被法院冻结或收到法院止付通知书 DC07 票据未到期 DC08 商业承兑汇票承兑人账户余额不足 DC09 其他（必须注明）
            ,appstatus -- 审批状态： 0 已接收未提交 1 受理已提交 2 记账 3 已拒付(处理纸票拒付交易时增加)
            ,acpay_status -- 发出签收明细状态： 00 到期付款时我方未签收 11 到期付款时签收通讯中 12 到期付款时签收通讯成功 21 到期付款时签收通讯失败 22 到期付款时签收已确认失败 25 线上清算失败 26 清分失败回复 31 到期付款时签收已确认成功 90 到期付款已交易成功(记账) 91 到期付款时对方已撤回申请
            ,endst_date -- 签收日期
            ,sig_mk -- 签收意见： SU00 同意 SU01 拒绝
            ,cancel_date -- 撤销日期
            ,account_date -- 记账日期
            ,account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,trf_ref -- 线上清算结果-特许参与者号码
            ,trf_id -- 线上清算结果-支付交易序号
            ,dualcontrol_lockstatus -- 双杠复核锁标记
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,endor_num -- 背书次数
            ,payee_type -- 解付类型： A 正常 B 提前
            ,payee_reserve -- 提前解付原因
            ,dish_rsn -- 拒付备注
            ,drft_hldr_cmonid -- 提示付款人组织机构代码
            ,drft_hldr_role -- 提示付款人类别RC00接入行RC01企业RC02人民银行RC03被代理行RC04被代理财务公司RC05接入财务公司
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,position_audit_status -- 头寸审批状态
            ,position_seqno -- 头寸交易流水
            ,req_remark -- 请求方申请备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.branch_no -- 交易机构编号
    ,o.acpt_id -- 清单ID
    ,o.draft_id -- 票据信息ID
    ,o.isse_curcd -- 票据币种： CNY 人民币
    ,o.draft_amount -- 票据金额
    ,o.mesg_type -- 报文种类
    ,o.apply_date -- 提示付款/逾期提示付款申请日期
    ,o.ovrdue_rsn -- 逾期原因说明
    ,o.apply_curcd -- 提示付款币种： CNY 人民币
    ,o.apply_amount -- 提示付款金额
    ,o.sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,o.voc_cnt -- 所附凭证张数
    ,o.accept_curcd -- 兑付币种： CNY 人民币
    ,o.accept_amount -- 兑付金额
    ,o.payee_bank_no -- 解付申请人开户行行号
    ,o.payee_bank_name -- 解付申请人开户行
    ,o.payee_name -- 解付申请人
    ,o.payee_account -- 解付申请人帐号
    ,o.receive_date -- 提示付款申请日期
    ,o.operator_no -- 回复操作员号
    ,o.repay_sig_mk -- 回复意见： SU00 同意 SU01 拒绝
    ,o.dish_code -- 拒付代码： DC00 与自己有直接债权债务关系的持票人未履行约定义务 DC01 持票人以欺诈、偷盗或者胁迫等手段取得票据 DC02 持票人明知有欺诈、偷盗或者胁迫等情形，出于恶意取得票据 DC03 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 DC04 持票人因重大过失取得不符合《票据法》规定的票据 DC05 超过提示付款期 DC06 被法院冻结或收到法院止付通知书 DC07 票据未到期 DC08 商业承兑汇票承兑人账户余额不足 DC09 其他（必须注明）
    ,o.appstatus -- 审批状态： 0 已接收未提交 1 受理已提交 2 记账 3 已拒付(处理纸票拒付交易时增加)
    ,o.acpay_status -- 发出签收明细状态： 00 到期付款时我方未签收 11 到期付款时签收通讯中 12 到期付款时签收通讯成功 21 到期付款时签收通讯失败 22 到期付款时签收已确认失败 25 线上清算失败 26 清分失败回复 31 到期付款时签收已确认成功 90 到期付款已交易成功(记账) 91 到期付款时对方已撤回申请
    ,o.endst_date -- 签收日期
    ,o.sig_mk -- 签收意见： SU00 同意 SU01 拒绝
    ,o.cancel_date -- 撤销日期
    ,o.account_date -- 记账日期
    ,o.account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,o.trf_ref -- 线上清算结果-特许参与者号码
    ,o.trf_id -- 线上清算结果-支付交易序号
    ,o.dualcontrol_lockstatus -- 双杠复核锁标记
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.endor_num -- 背书次数
    ,o.payee_type -- 解付类型： A 正常 B 提前
    ,o.payee_reserve -- 提前解付原因
    ,o.dish_rsn -- 拒付备注
    ,o.drft_hldr_cmonid -- 提示付款人组织机构代码
    ,o.drft_hldr_role -- 提示付款人类别RC00接入行RC01企业RC02人民银行RC03被代理行RC04被代理财务公司RC05接入财务公司
    ,o.last_upd_oper_id -- 最后修改操作员号
    ,o.last_upd_time -- 最后修改时间
    ,o.position_audit_status -- 头寸审批状态
    ,o.position_seqno -- 头寸交易流水
    ,o.req_remark -- 请求方申请备注
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
from ${iol_schema}.bdms_bms_accept_due_pay_bk o
    left join ${iol_schema}.bdms_bms_accept_due_pay_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_accept_due_pay_cl d
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
--truncate table ${iol_schema}.bdms_bms_accept_due_pay;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_accept_due_pay') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_accept_due_pay drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_accept_due_pay add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_accept_due_pay exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_accept_due_pay_cl;
alter table ${iol_schema}.bdms_bms_accept_due_pay exchange partition p_20991231 with table ${iol_schema}.bdms_bms_accept_due_pay_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_accept_due_pay to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_accept_due_pay_op purge;
drop table ${iol_schema}.bdms_bms_accept_due_pay_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_accept_due_pay_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_accept_due_pay',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
