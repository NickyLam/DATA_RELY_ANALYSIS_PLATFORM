/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_dpc_draft_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_dpc_draft_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_dpc_draft_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_dpc_draft_info(
    id varchar2(60) -- ID
    ,bms_draft_id varchar2(60) -- 原票据系统的票据ID
    ,draft_number varchar2(45) -- 票据（包）号
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,draft_type varchar2(2) -- 票据类型： AC01 银承 AC02 商承
    ,remit_date varchar2(12) -- 出票日期
    ,maturity_date varchar2(12) -- 票据到期日期
    ,draft_amount number(18,2) -- 票据（包）金额
    ,remitter_name varchar2(150) -- 出票人名称
    ,remitter_account varchar2(48) -- 出票人账号
    ,remitter_bank_no varchar2(18) -- 出票人开户行行号
    ,remitter_bank_name varchar2(270) -- 出票人开户行名称
    ,remitter_crt_no varchar2(48) -- 出票人社会信用代码
    ,acceptor_name varchar2(150) -- 承兑人名称
    ,acceptor_account varchar2(60) -- 承兑人账号
    ,acceptor_bank_no varchar2(18) -- 承兑人开户行行号
    ,acceptor_bank_name varchar2(270) -- 承兑人开户行名称
    ,acceptor_crt_no varchar2(48) -- 承兑人社会信用代码
    ,payee_name varchar2(150) -- 收款人名称
    ,payee_bank_name varchar2(270) -- 收款人开户行名称
    ,payee_account varchar2(48) -- 收款人账号
    ,payee_bank_no varchar2(18) -- 收款人开户行行号
    ,payee_crt_no varchar2(48) -- 收款人社会信用代码
    ,drawee_bank_no varchar2(18) -- 付款行行号
    ,drawee_brh_no varchar2(15) -- 付款行机构代码
    ,drawee_bank_name varchar2(270) -- 付款行名称
    ,drawee_confirm_brh_no varchar2(15) -- 付款确认机构代码
    ,guarantee_bank_name varchar2(270) -- 保证增信行行名
    ,guarantee_brh_no varchar2(15) -- 保证增信行机构代码
    ,gua_accept_bank_no varchar2(18) -- 承兑保证行行号
    ,gua_accept_brh_no varchar2(15) -- 承兑保证行机构代码
    ,gua_discnt_brh_no varchar2(15) -- 贴现保证行机构代码
    ,collection_bank_no varchar2(18) -- 托收行行号
    ,holder_name varchar2(150) -- 持票人名称
    ,holder_crt_no varchar2(48) -- 持票人社会信用代码
    ,holder_acct_no varchar2(48) -- 持票人账号
    ,holder_brh_no varchar2(15) -- 持票人机构代码
    ,holder_brh_name varchar2(270) -- 持票人机构名称
    ,endorse_times number(8,0) -- 背书次数
    ,lock_flag varchar2(2) -- 锁定标志 1:锁定 0:解锁
    ,report_of_loss_flag varchar2(3) -- 挂失状态
    ,deduct_status varchar2(2) -- 扣款状态
    ,risk_status varchar2(9) -- 风险票据状态：见DPC_PRODUCT_TRANS表的RISK_STATUS
    ,store_status varchar2(23) -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
    ,src_type varchar2(9) -- 票据来源： SR002 质押 SR004 贴现 SR005 转贴现 SR006 质押式回购 SR007 买断式回购 SR010 增信保管 SR011 付款确认 SR012 行内移库 SR013 保证 SR014 提示付款 SR015 追偿 SR016 承兑登记 SR017 承兑保证登记 SR018 质押登记 SR020 贴现登记 SR021 结清登记 SR026 权属登记 SR036 非交易过户 SR041 存托 SR042 供应链贴现 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
    ,flow_status varchar2(9) -- 票据流转状态： F00 完成 F02 质押处理中 F03 质押解除处理中 F04 贴现处理中 F05 转贴现处理中 F06 质押式回购处理中 F07 买断式回购处理中 F08 质押式到期处理中 F09 买断式到期处理中 F10 增信保管处理中 F11 付款确认处理中 F12 行内移库处理中 F13 保证处理中 F14 提示付款处理中 F15 追偿处理中 F16 承兑登记处理中 F17 承兑保证登记处理中 F18 质押登记处理中 F19 质押解除登记处理中 F20 贴现登记处理中 F21 结清登记处理中 F22 止付登记处理中 F23 止付解除登记处理中 F24 线下追偿登记处理中 F25 追偿结清登记处理中 F26 权属登记处理中 F27 线下追偿申请处理中 F28 线下追偿签收处理中 F29 登记类撤回处理中 F34 提前赎回处理中 F35 逾期赎回处理中 F36 非交易过户处理中 F41 存托处理中 F42 供应链贴现处理中 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
    ,status varchar2(9) -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S06 质押式待赎回 S07 买断式待赎回 S08 质押式已逾期 S09 买断式已逾期 S10 已（增信）保证 S11 已付款确认 S14 已结清 S15 已偿付(付款) S16 承兑已登记 S17 承兑保证已登记 S18 质押已登记 S19 质押解除已登记 S20 贴现已登记 S21 结清已登记 S24 线下追偿已登记 S25 追偿结清已登记 S26 初始权属已登记 S27 线下追偿已申请 S28 线下追偿已签收 S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S36 已过户 S39 信息已作废 S40 已逾期 S41 已存托 S42 供应链贴现已完成 S502 已撤票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
    ,com_status varchar2(300) -- 组合状态
    ,discount_brh_no varchar2(15) -- 贴现行行机构代码
    ,discount_brh_name varchar2(270) -- 贴现行名称
    ,store_brh_no varchar2(15) -- 库存机构代码
    ,init_brh_no varchar2(15) -- 初始权属登记机构
    ,belong_branch_no varchar2(30) -- 票据所属机构号
    ,top_branch_no varchar2(30) -- 总行机构号
    ,pay_confirm_flag varchar2(6) -- 付款确认标志： PC00 完成 PC01 影像确认需补录影像 PC02 实物确认需补录影像 PC03 实物验证 PC04 审批拒绝 PC05 未付款确认 PC06 影像验证应答发起影像验证撤销 PC07 实物验证应答发起实物验证撤销
    ,settle_flag varchar2(2) -- 是否结清： 0 否 1 是
    ,recovery_flag varchar2(2) -- 是否追偿： 0 否 1 是
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(4000) -- 备注域
    ,squared_destroy_flag varchar2(3) -- 
    ,reserve1 varchar2(450) -- 备用字段1
    ,reserve2 varchar2(450) -- 备用字段2
    ,reserve3 varchar2(450) -- 备用字段3
    ,reserve4 varchar2(450) -- 备用字段4
    ,reserve5 varchar2(450) -- 备用字段5
    ,reserve6 varchar2(450) -- 备用字段6
    ,disc_date varchar2(12) -- 贴现日期
    ,advance_flag varchar2(6) -- 
    ,holder_bank_no varchar2(18) -- 持票人开户行行号
    ,bp_no varchar2(45) -- 供应链票据包编号
    ,forehand_range varchar2(38) -- 前手区间
    ,current_range varchar2(38) -- 当前区间
    ,product_type varchar2(6) -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,belong_brh_no varchar2(14) -- 所属票交所机构号/非法人产品
    ,transfer_flag varchar2(6) -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,cd_range varchar2(38) -- 子票区间
    ,standard_amt number(18,2) -- 标准金额
    ,draft_remark varchar2(675) -- 票面备注
    ,draft_explain varchar2(675) -- 票面说明
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,org_draft_id varchar2(60) -- 原始票据ID
    ,select_draft_id varchar2(60) -- 挑票ID
    ,split_draft_id varchar2(60) -- 实际拆前票据ID
    ,split_range varchar2(38) -- 实际拆前区间
    ,split_control_id varchar2(60) -- 登记中心拆包控制表ID
    ,split_status varchar2(3) -- 分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余
    ,remitter_mem_no varchar2(9) -- 出票人渠道代码
    ,remitter_dist_tp varchar2(6) -- 出票人识别类型： DT01 票据账户 DT02 银行账户
    ,remitter_brh_no varchar2(14) -- 出票人开户行机构代码
    ,remitter_brh_name varchar2(450) -- 出票人开户行机构名称
    ,acceptor_mem_no varchar2(9) -- 承兑人渠道代码
    ,acceptor_dist_tp varchar2(6) -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
    ,acceptor_brh_no varchar2(14) -- 承兑人开户行机构代码
    ,acceptor_brh_name varchar2(450) -- 承兑人开户行机构名称
    ,payee_mem_no varchar2(9) -- 收款人渠道代码
    ,payee_dist_tp varchar2(6) -- 收款人识别类型： DT01 票据账户 DT02 银行账户
    ,payee_brh_no varchar2(14) -- 收款人开户行机构代码
    ,payee_brh_name varchar2(450) -- 收款人开户行机构名称
    ,holder_mem_no varchar2(9) -- 持票人渠道代码
    ,holder_dist_tp varchar2(6) -- 持票人识别类型： DT01 票据账户 DT02 银行账户
    ,holder_bank_name varchar2(270) -- 持票人开户行名称
    ,concurrent_control varchar2(2) -- 并发控制
    ,consignment_code varchar2(6) -- 到期无条件委托: CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,draft_transfer_flag varchar2(6) -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
    ,recovery_hand_flag varchar2(2) -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
    ,discount_draft_id varchar2(60) -- 原票交所等分化贴现的票据ID
    ,hand_recovery_lock_flag varchar2(2) -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
    ,offline_recovery_flag varchar2(2) -- 线下追偿标志： 0-不可线下追索 1-可线下追索
    ,stock_status varchar2(2) -- 是否再贴现（1-已再贴现，0-库存。）
    ,is_receipt varchar2(2) -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
    ,recept_brh varchar2(15) -- 承接机构号
    ,create_by varchar2(48) -- 创建人
    ,create_time varchar2(21) -- 创建时间
    ,settle_date varchar2(12) -- 结清日期
    ,migrate_flag varchar2(15) -- ECDS迁移标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_dpc_draft_info to ${iml_schema};
grant select on ${iol_schema}.bdms_dpc_draft_info to ${icl_schema};
grant select on ${iol_schema}.bdms_dpc_draft_info to ${idl_schema};
grant select on ${iol_schema}.bdms_dpc_draft_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_dpc_draft_info is '登记中心票据信息表';
comment on column ${iol_schema}.bdms_dpc_draft_info.id is 'ID';
comment on column ${iol_schema}.bdms_dpc_draft_info.bms_draft_id is '原票据系统的票据ID';
comment on column ${iol_schema}.bdms_dpc_draft_info.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_dpc_draft_info.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_dpc_draft_info.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_dpc_draft_info.remit_date is '出票日期';
comment on column ${iol_schema}.bdms_dpc_draft_info.maturity_date is '票据到期日期';
comment on column ${iol_schema}.bdms_dpc_draft_info.draft_amount is '票据（包）金额';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_bank_no is '出票人开户行行号';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_bank_name is '出票人开户行名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_crt_no is '出票人社会信用代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_bank_no is '承兑人开户行行号';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_bank_name is '承兑人开户行名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_crt_no is '承兑人社会信用代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_name is '收款人名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_bank_name is '收款人开户行名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_account is '收款人账号';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_bank_no is '收款人开户行行号';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_crt_no is '收款人社会信用代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.drawee_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_dpc_draft_info.drawee_brh_no is '付款行机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.drawee_bank_name is '付款行名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.drawee_confirm_brh_no is '付款确认机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.guarantee_bank_name is '保证增信行行名';
comment on column ${iol_schema}.bdms_dpc_draft_info.guarantee_brh_no is '保证增信行机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.gua_accept_bank_no is '承兑保证行行号';
comment on column ${iol_schema}.bdms_dpc_draft_info.gua_accept_brh_no is '承兑保证行机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.gua_discnt_brh_no is '贴现保证行机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.collection_bank_no is '托收行行号';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_name is '持票人名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_crt_no is '持票人社会信用代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_acct_no is '持票人账号';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_brh_no is '持票人机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_brh_name is '持票人机构名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.endorse_times is '背书次数';
comment on column ${iol_schema}.bdms_dpc_draft_info.lock_flag is '锁定标志 1:锁定 0:解锁';
comment on column ${iol_schema}.bdms_dpc_draft_info.report_of_loss_flag is '挂失状态';
comment on column ${iol_schema}.bdms_dpc_draft_info.deduct_status is '扣款状态';
comment on column ${iol_schema}.bdms_dpc_draft_info.risk_status is '风险票据状态：见DPC_PRODUCT_TRANS表的RISK_STATUS';
comment on column ${iol_schema}.bdms_dpc_draft_info.store_status is '实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中';
comment on column ${iol_schema}.bdms_dpc_draft_info.src_type is '票据来源： SR002 质押 SR004 贴现 SR005 转贴现 SR006 质押式回购 SR007 买断式回购 SR010 增信保管 SR011 付款确认 SR012 行内移库 SR013 保证 SR014 提示付款 SR015 追偿 SR016 承兑登记 SR017 承兑保证登记 SR018 质押登记 SR020 贴现登记 SR021 结清登记 SR026 权属登记 SR036 非交易过户 SR041 存托 SR042 供应链贴现 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证';
comment on column ${iol_schema}.bdms_dpc_draft_info.flow_status is '票据流转状态： F00 完成 F02 质押处理中 F03 质押解除处理中 F04 贴现处理中 F05 转贴现处理中 F06 质押式回购处理中 F07 买断式回购处理中 F08 质押式到期处理中 F09 买断式到期处理中 F10 增信保管处理中 F11 付款确认处理中 F12 行内移库处理中 F13 保证处理中 F14 提示付款处理中 F15 追偿处理中 F16 承兑登记处理中 F17 承兑保证登记处理中 F18 质押登记处理中 F19 质押解除登记处理中 F20 贴现登记处理中 F21 结清登记处理中 F22 止付登记处理中 F23 止付解除登记处理中 F24 线下追偿登记处理中 F25 追偿结清登记处理中 F26 权属登记处理中 F27 线下追偿申请处理中 F28 线下追偿签收处理中 F29 登记类撤回处理中 F34 提前赎回处理中 F35 逾期赎回处理中 F36 非交易过户处理中 F41 存托处理中 F42 供应链贴现处理中 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中';
comment on column ${iol_schema}.bdms_dpc_draft_info.status is '票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S06 质押式待赎回 S07 买断式待赎回 S08 质押式已逾期 S09 买断式已逾期 S10 已（增信）保证 S11 已付款确认 S14 已结清 S15 已偿付(付款) S16 承兑已登记 S17 承兑保证已登记 S18 质押已登记 S19 质押解除已登记 S20 贴现已登记 S21 结清已登记 S24 线下追偿已登记 S25 追偿结清已登记 S26 初始权属已登记 S27 线下追偿已申请 S28 线下追偿已签收 S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S36 已过户 S39 信息已作废 S40 已逾期 S41 已存托 S42 供应链贴现已完成 S502 已撤票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分';
comment on column ${iol_schema}.bdms_dpc_draft_info.com_status is '组合状态';
comment on column ${iol_schema}.bdms_dpc_draft_info.discount_brh_no is '贴现行行机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.discount_brh_name is '贴现行名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.store_brh_no is '库存机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.init_brh_no is '初始权属登记机构';
comment on column ${iol_schema}.bdms_dpc_draft_info.belong_branch_no is '票据所属机构号';
comment on column ${iol_schema}.bdms_dpc_draft_info.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_dpc_draft_info.pay_confirm_flag is '付款确认标志： PC00 完成 PC01 影像确认需补录影像 PC02 实物确认需补录影像 PC03 实物验证 PC04 审批拒绝 PC05 未付款确认 PC06 影像验证应答发起影像验证撤销 PC07 实物验证应答发起实物验证撤销';
comment on column ${iol_schema}.bdms_dpc_draft_info.settle_flag is '是否结清： 0 否 1 是';
comment on column ${iol_schema}.bdms_dpc_draft_info.recovery_flag is '是否追偿： 0 否 1 是';
comment on column ${iol_schema}.bdms_dpc_draft_info.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_dpc_draft_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_dpc_draft_info.misc is '备注域';
comment on column ${iol_schema}.bdms_dpc_draft_info.squared_destroy_flag is '';
comment on column ${iol_schema}.bdms_dpc_draft_info.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_dpc_draft_info.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_dpc_draft_info.reserve3 is '备用字段3';
comment on column ${iol_schema}.bdms_dpc_draft_info.reserve4 is '备用字段4';
comment on column ${iol_schema}.bdms_dpc_draft_info.reserve5 is '备用字段5';
comment on column ${iol_schema}.bdms_dpc_draft_info.reserve6 is '备用字段6';
comment on column ${iol_schema}.bdms_dpc_draft_info.disc_date is '贴现日期';
comment on column ${iol_schema}.bdms_dpc_draft_info.advance_flag is '';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_bank_no is '持票人开户行行号';
comment on column ${iol_schema}.bdms_dpc_draft_info.bp_no is '供应链票据包编号';
comment on column ${iol_schema}.bdms_dpc_draft_info.forehand_range is '前手区间';
comment on column ${iol_schema}.bdms_dpc_draft_info.current_range is '当前区间';
comment on column ${iol_schema}.bdms_dpc_draft_info.product_type is '票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台';
comment on column ${iol_schema}.bdms_dpc_draft_info.belong_brh_no is '所属票交所机构号/非法人产品';
comment on column ${iol_schema}.bdms_dpc_draft_info.transfer_flag is '不得转让标志： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_dpc_draft_info.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_dpc_draft_info.standard_amt is '标准金额';
comment on column ${iol_schema}.bdms_dpc_draft_info.draft_remark is '票面备注';
comment on column ${iol_schema}.bdms_dpc_draft_info.draft_explain is '票面说明';
comment on column ${iol_schema}.bdms_dpc_draft_info.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_dpc_draft_info.org_draft_id is '原始票据ID';
comment on column ${iol_schema}.bdms_dpc_draft_info.select_draft_id is '挑票ID';
comment on column ${iol_schema}.bdms_dpc_draft_info.split_draft_id is '实际拆前票据ID';
comment on column ${iol_schema}.bdms_dpc_draft_info.split_range is '实际拆前区间';
comment on column ${iol_schema}.bdms_dpc_draft_info.split_control_id is '登记中心拆包控制表ID';
comment on column ${iol_schema}.bdms_dpc_draft_info.split_status is '分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_mem_no is '出票人渠道代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_dist_tp is '出票人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_brh_no is '出票人开户行机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.remitter_brh_name is '出票人开户行机构名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_mem_no is '承兑人渠道代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_dist_tp is '承兑人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_brh_no is '承兑人开户行机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.acceptor_brh_name is '承兑人开户行机构名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_mem_no is '收款人渠道代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_dist_tp is '收款人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_brh_no is '收款人开户行机构代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.payee_brh_name is '收款人开户行机构名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_mem_no is '持票人渠道代码';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_dist_tp is '持票人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_dpc_draft_info.holder_bank_name is '持票人开户行名称';
comment on column ${iol_schema}.bdms_dpc_draft_info.concurrent_control is '并发控制';
comment on column ${iol_schema}.bdms_dpc_draft_info.consignment_code is '到期无条件委托: CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付';
comment on column ${iol_schema}.bdms_dpc_draft_info.draft_transfer_flag is '票面不得转让标志： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_dpc_draft_info.recovery_hand_flag is '贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索';
comment on column ${iol_schema}.bdms_dpc_draft_info.discount_draft_id is '原票交所等分化贴现的票据ID';
comment on column ${iol_schema}.bdms_dpc_draft_info.hand_recovery_lock_flag is '手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功';
comment on column ${iol_schema}.bdms_dpc_draft_info.offline_recovery_flag is '线下追偿标志： 0-不可线下追索 1-可线下追索';
comment on column ${iol_schema}.bdms_dpc_draft_info.stock_status is '是否再贴现（1-已再贴现，0-库存。）';
comment on column ${iol_schema}.bdms_dpc_draft_info.is_receipt is '是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）';
comment on column ${iol_schema}.bdms_dpc_draft_info.recept_brh is '承接机构号';
comment on column ${iol_schema}.bdms_dpc_draft_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_dpc_draft_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_dpc_draft_info.settle_date is '结清日期';
comment on column ${iol_schema}.bdms_dpc_draft_info.migrate_flag is 'ECDS迁移标志';
comment on column ${iol_schema}.bdms_dpc_draft_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_dpc_draft_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_dpc_draft_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_dpc_draft_info.etl_timestamp is 'ETL处理时间戳';
