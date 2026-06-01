/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cust_dpc_draft_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cust_dpc_draft_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cust_dpc_draft_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cust_dpc_draft_info(
    id varchar2(60) -- ID
    ,draft_number varchar2(45) -- 票据（包）号
    ,cd_range varchar2(38) -- 子票区间
    ,draft_amount number(18,2) -- 票据（包）金额
    ,standard_amt number(18,2) -- 标准金额
    ,draft_attr varchar2(2) -- 票据介质： 1 纸票 2 电票
    ,draft_type varchar2(2) -- 票据类型： 1 银承 2 商承
    ,product_type varchar2(6) -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,remit_date varchar2(12) -- 出票日
    ,maturity_date varchar2(12) -- 到期日
    ,draft_transfer_flag varchar2(6) -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
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
    ,remitter_name varchar2(270) -- 出票人名称
    ,remitter_crt_no varchar2(27) -- 出票人社会信用代码
    ,remitter_dist_tp varchar2(6) -- 出票人识别类型： DT01 票据账户 DT02 银行账户
    ,remitter_account varchar2(48) -- 出票人账号
    ,remitter_bank_no varchar2(18) -- 出票人开户行行号
    ,remitter_bank_name varchar2(150) -- 出票人开户行行名
    ,remitter_brh_no varchar2(14) -- 出票人开户行机构代码
    ,remitter_brh_name varchar2(450) -- 出票人开户行机构名称
    ,acceptor_mem_no varchar2(9) -- 承兑人渠道代码
    ,acceptor_name varchar2(270) -- 承兑人名称
    ,acceptor_crt_no varchar2(27) -- 承兑人社会信用代码
    ,acceptor_dist_tp varchar2(6) -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
    ,acceptor_account varchar2(48) -- 承兑人账号
    ,acceptor_bank_no varchar2(18) -- 承兑人开户行行号
    ,acceptor_bank_name varchar2(150) -- 承兑人开户行行名
    ,acceptor_brh_no varchar2(14) -- 承兑人开户行机构代码
    ,acceptor_brh_name varchar2(450) -- 承兑人开户行机构名称
    ,payee_mem_no varchar2(9) -- 收款人渠道代码
    ,payee_name varchar2(270) -- 收款人名称
    ,payee_crt_no varchar2(27) -- 收款人社会信用代码
    ,payee_dist_tp varchar2(6) -- 收款人识别类型： DT01 票据账户 DT02 银行账户
    ,payee_account varchar2(48) -- 收款人账号
    ,payee_bank_no varchar2(18) -- 收款人开户行行号
    ,payee_bank_name varchar2(150) -- 收款人开户行行名
    ,payee_brh_no varchar2(14) -- 收款人开户行机构代码
    ,payee_brh_name varchar2(450) -- 收款人开户行机构名称
    ,drawee_bank_no varchar2(18) -- 付款行行号
    ,drawee_brh_no varchar2(15) -- 付款行机构代码
    ,drawee_bank_name varchar2(150) -- 付款行名称
    ,gua_accept_bank_no varchar2(18) -- 承兑保证行行号
    ,gua_accept_brh_no varchar2(15) -- 承兑保证行机构代码
    ,collection_bank_no varchar2(18) -- 托收行行号
    ,disc_date varchar2(12) -- 贴现日期
    ,discount_brh_no varchar2(15) -- 贴现行行机构代码
    ,discount_brh_name varchar2(150) -- 贴现行名称
    ,init_brh_no varchar2(15) -- 初始权属登记机构
    ,report_of_loss_flag varchar2(3) -- 挂失状态
    ,deduct_status varchar2(2) -- 扣款状态
    ,risk_status varchar2(9) -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
    ,transfer_flag varchar2(6) -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,consignment_code varchar2(6) -- 到期无条件支付委托类型： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,settle_flag varchar2(2) -- 是否结清： 0 否 1 是
    ,recovery_flag varchar2(2) -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
    ,endorse_times number(8,0) -- 背书次数
    ,owner_mem_no varchar2(9) -- 票据权利人渠道代码
    ,owner_name varchar2(270) -- 票据权利人名称
    ,owner_crt_no varchar2(27) -- 票据权利人社会信用代码
    ,owner_dist_tp varchar2(6) -- 票据权利人识别类型： DT01 票据账户 DT02 银行账户
    ,owner_account varchar2(48) -- 票据权利人账号
    ,owner_bank_no varchar2(18) -- 票据权利人开户行行号
    ,owner_bank_name varchar2(150) -- 票据权利人开户行行名
    ,owner_brh_no varchar2(14) -- 票据权利人开户行机构代码
    ,owner_brh_name varchar2(450) -- 票据权利人开户行机构名称
    ,lock_flag varchar2(2) -- 锁定标志： 0 解锁 1 锁定
    ,src_type varchar2(9) -- 票据来源： SR002 质押 SR013 保证 SR014 提示付款 SR015 追偿 SR500 出票 SR503 收票 SR504 背书 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
    ,flow_status varchar2(9) -- 票据流转状态： F00 完成 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
    ,status varchar2(9) -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S10 已（增信）保证 S14 已结清 S15 已偿付(付款) S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S39 信息已作废 S40 已逾期 S500 已出票登记 S501 已提示承兑 S502 已撤票 S503 已提示收票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
    ,com_status varchar2(300) -- 组合状态
    ,belong_name varchar2(270) -- 票据所属人名称
    ,belong_crt_no varchar2(27) -- 票据所属人社会信用代码
    ,belong_account varchar2(48) -- 票据所属人账号
    ,belong_bank_no varchar2(18) -- 票据所属人开户行行号
    ,belong_bank_name varchar2(150) -- 票据所属人开户行行名
    ,belong_brh_no varchar2(14) -- 票据所属人开户行机构代码
    ,belong_brh_name varchar2(450) -- 票据所属人开户行机构名称
    ,init_trans_id varchar2(60) -- 首次交易ID
    ,concurrent_control varchar2(2) -- 并发控制
    ,create_opr varchar2(15) -- 创建人
    ,create_time varchar2(21) -- 创建时间
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注域
    ,reserve1 varchar2(450) -- 备用字段1
    ,reserve2 varchar2(450) -- 备用字段2
    ,reserve3 varchar2(450) -- 备用字段3
    ,reserve4 varchar2(450) -- 备用字段4
    ,reserve5 varchar2(450) -- 备用字段5
    ,reserve6 varchar2(450) -- 备用字段6
    ,recovery_hand_flag varchar2(2) -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
    ,hand_recovery_lock_flag varchar2(2) -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
    ,acceptor_acctname varchar2(675) -- 承兑人账户名称
    ,remitter_acctname varchar2(675) -- 出票人账户名称
    ,payee_acctname varchar2(675) -- 收款人账户名称
    ,recept_brh varchar2(15) -- 承接机构号
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
grant select on ${iol_schema}.bdms_cust_dpc_draft_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cust_dpc_draft_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cust_dpc_draft_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cust_dpc_draft_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cust_dpc_draft_info is '企业登记中心票据信息表';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.id is 'ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.draft_amount is '票据（包）金额';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.standard_amt is '标准金额';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.draft_attr is '票据介质： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.draft_type is '票据类型： 1 银承 2 商承';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.product_type is '票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.draft_transfer_flag is '票面不得转让标志： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.draft_remark is '票面备注';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.draft_explain is '票面说明';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.org_draft_id is '原始票据ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.select_draft_id is '挑票ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.split_draft_id is '实际拆前票据ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.split_range is '实际拆前区间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.split_control_id is '登记中心拆包控制表ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.split_status is '分包状态： 00-分包处理中 01-分包失败 02-分包成功 03-分包成功后交易失败 04-分包剩余';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_mem_no is '出票人渠道代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_crt_no is '出票人社会信用代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_dist_tp is '出票人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_bank_no is '出票人开户行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_bank_name is '出票人开户行行名';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_brh_no is '出票人开户行机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_brh_name is '出票人开户行机构名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_mem_no is '承兑人渠道代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_crt_no is '承兑人社会信用代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_dist_tp is '承兑人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_bank_no is '承兑人开户行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_bank_name is '承兑人开户行行名';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_brh_no is '承兑人开户行机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_brh_name is '承兑人开户行机构名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_mem_no is '收款人渠道代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_name is '收款人名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_crt_no is '收款人社会信用代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_dist_tp is '收款人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_account is '收款人账号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_bank_no is '收款人开户行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_bank_name is '收款人开户行行名';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_brh_no is '收款人开户行机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_brh_name is '收款人开户行机构名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.drawee_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.drawee_brh_no is '付款行机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.drawee_bank_name is '付款行名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.gua_accept_bank_no is '承兑保证行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.gua_accept_brh_no is '承兑保证行机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.collection_bank_no is '托收行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.disc_date is '贴现日期';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.discount_brh_no is '贴现行行机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.discount_brh_name is '贴现行名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.init_brh_no is '初始权属登记机构';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.report_of_loss_flag is '挂失状态';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.deduct_status is '扣款状态';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.risk_status is '风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.transfer_flag is '不得转让标志： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.consignment_code is '到期无条件支付委托类型： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.settle_flag is '是否结清： 0 否 1 是';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.recovery_flag is '追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.endorse_times is '背书次数';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_mem_no is '票据权利人渠道代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_name is '票据权利人名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_crt_no is '票据权利人社会信用代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_dist_tp is '票据权利人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_account is '票据权利人账号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_bank_no is '票据权利人开户行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_bank_name is '票据权利人开户行行名';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_brh_no is '票据权利人开户行机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.owner_brh_name is '票据权利人开户行机构名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.lock_flag is '锁定标志： 0 解锁 1 锁定';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.src_type is '票据来源： SR002 质押 SR013 保证 SR014 提示付款 SR015 追偿 SR500 出票 SR503 收票 SR504 背书 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.flow_status is '票据流转状态： F00 完成 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.status is '票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S10 已（增信）保证 S14 已结清 S15 已偿付(付款) S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S39 信息已作废 S40 已逾期 S500 已出票登记 S501 已提示承兑 S502 已撤票 S503 已提示收票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.com_status is '组合状态';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.belong_name is '票据所属人名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.belong_crt_no is '票据所属人社会信用代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.belong_account is '票据所属人账号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.belong_bank_no is '票据所属人开户行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.belong_bank_name is '票据所属人开户行行名';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.belong_brh_no is '票据所属人开户行机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.belong_brh_name is '票据所属人开户行机构名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.init_trans_id is '首次交易ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.concurrent_control is '并发控制';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.create_opr is '创建人';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.misc is '备注域';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.reserve3 is '备用字段3';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.reserve4 is '备用字段4';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.reserve5 is '备用字段5';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.reserve6 is '备用字段6';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.recovery_hand_flag is '贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.hand_recovery_lock_flag is '手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.acceptor_acctname is '承兑人账户名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.remitter_acctname is '出票人账户名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.payee_acctname is '收款人账户名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.recept_brh is '承接机构号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.settle_date is '结清日期';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.migrate_flag is 'ECDS迁移标志';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cust_dpc_draft_info.etl_timestamp is 'ETL处理时间戳';
