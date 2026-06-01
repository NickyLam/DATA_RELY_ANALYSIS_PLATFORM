/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_dpc_draft_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM bdms_dpc_draft_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdms_dpc_draft_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdms_dpc_draft_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdms_dpc_draft_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdms_dpc_draft_info(
            id -- ID
            ,bms_draft_id -- 原票据系统的票据ID
            ,draft_number -- 票据（包）号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票据（包）金额
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_crt_no -- 出票人社会信用代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,acceptor_crt_no -- 承兑人社会信用代码
            ,payee_name -- 收款人名称
            ,payee_bank_name -- 收款人开户行名称
            ,payee_account -- 收款人账号
            ,payee_bank_no -- 收款人开户行行号
            ,payee_crt_no -- 收款人社会信用代码
            ,drawee_bank_no -- 付款行行号
            ,drawee_brh_no -- 付款行机构代码
            ,drawee_bank_name -- 付款行名称
            ,drawee_confirm_brh_no -- 付款确认机构代码
            ,guarantee_bank_name -- 保证增信行行名
            ,guarantee_brh_no -- 保证增信行机构代码
            ,gua_accept_bank_no -- 承兑保证行行号
            ,gua_accept_brh_no -- 承兑保证行机构代码
            ,gua_discnt_brh_no -- 贴现保证行机构代码
            ,collection_bank_no -- 托收行行号
            ,holder_name -- 持票人名称
            ,holder_crt_no -- 持票人社会信用代码
            ,holder_acct_no -- 持票人账号
            ,holder_brh_no -- 持票人机构代码
            ,holder_brh_name -- 持票人机构名称
            ,endorse_times -- 背书次数
            ,lock_flag -- 锁定标志 1:锁定 0:解锁
            ,report_of_loss_flag -- 挂失状态
            ,deduct_status -- 扣款状态
            ,risk_status -- 风险票据状态：见DPC_PRODUCT_TRANS表的RISK_STATUS
            ,store_status -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
            ,src_type -- 票据来源： SR002 质押 SR004 贴现 SR005 转贴现 SR006 质押式回购 SR007 买断式回购 SR010 增信保管 SR011 付款确认 SR012 行内移库 SR013 保证 SR014 提示付款 SR015 追偿 SR016 承兑登记 SR017 承兑保证登记 SR018 质押登记 SR020 贴现登记 SR021 结清登记 SR026 权属登记 SR036 非交易过户 SR041 存托 SR042 供应链贴现 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
            ,flow_status -- 票据流转状态： F00 完成 F02 质押处理中 F03 质押解除处理中 F04 贴现处理中 F05 转贴现处理中 F06 质押式回购处理中 F07 买断式回购处理中 F08 质押式到期处理中 F09 买断式到期处理中 F10 增信保管处理中 F11 付款确认处理中 F12 行内移库处理中 F13 保证处理中 F14 提示付款处理中 F15 追偿处理中 F16 承兑登记处理中 F17 承兑保证登记处理中 F18 质押登记处理中 F19 质押解除登记处理中 F20 贴现登记处理中 F21 结清登记处理中 F22 止付登记处理中 F23 止付解除登记处理中 F24 线下追偿登记处理中 F25 追偿结清登记处理中 F26 权属登记处理中 F27 线下追偿申请处理中 F28 线下追偿签收处理中 F29 登记类撤回处理中 F34 提前赎回处理中 F35 逾期赎回处理中 F36 非交易过户处理中 F41 存托处理中 F42 供应链贴现处理中 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
            ,status -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S06 质押式待赎回 S07 买断式待赎回 S08 质押式已逾期 S09 买断式已逾期 S10 已（增信）保证 S11 已付款确认 S14 已结清 S15 已偿付(付款) S16 承兑已登记 S17 承兑保证已登记 S18 质押已登记 S19 质押解除已登记 S20 贴现已登记 S21 结清已登记 S24 线下追偿已登记 S25 追偿结清已登记 S26 初始权属已登记 S27 线下追偿已申请 S28 线下追偿已签收 S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S36 已过户 S39 信息已作废 S40 已逾期 S41 已存托 S42 供应链贴现已完成 S502 已撤票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
            ,com_status -- 组合状态
            ,discount_brh_no -- 贴现行行机构代码
            ,discount_brh_name -- 贴现行名称
            ,store_brh_no -- 库存机构代码
            ,init_brh_no -- 初始权属登记机构
            ,belong_branch_no -- 票据所属机构号
            ,top_branch_no -- 总行机构号
            ,pay_confirm_flag -- 付款确认标志： PC00 完成 PC01 影像确认需补录影像 PC02 实物确认需补录影像 PC03 实物验证 PC04 审批拒绝 PC05 未付款确认 PC06 影像验证应答发起影像验证撤销 PC07 实物验证应答发起实物验证撤销
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 是否追偿： 0 否 1 是
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,squared_destroy_flag -- 
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,disc_date -- 贴现日期
            ,advance_flag -- 
            ,holder_bank_no -- 持票人开户行行号
            ,bp_no -- 供应链票据包编号
            ,forehand_range -- 前手区间
            ,current_range -- 当前区间
            ,product_type -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,belong_brh_no -- 所属票交所机构号/非法人产品
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
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
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_brh_no -- 出票人开户行机构代码
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_brh_no -- 收款人开户行机构代码
            ,payee_brh_name -- 收款人开户行机构名称
            ,holder_mem_no -- 持票人渠道代码
            ,holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
            ,holder_bank_name -- 持票人开户行名称
            ,concurrent_control -- 并发控制
            ,consignment_code -- 到期无条件委托: CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,draft_transfer_flag -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
            ,recovery_hand_flag -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
            ,discount_draft_id -- 原票交所等分化贴现的票据ID
            ,hand_recovery_lock_flag -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
            ,offline_recovery_flag -- 线下追偿标志： 0-不可线下追索 1-可线下追索
            ,stock_status -- 是否再贴现（1-已再贴现，0-库存。）
            ,is_receipt -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
            ,recept_brh -- 承接机构号
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- ID
            ,bms_draft_id -- 原票据系统的票据ID
            ,draft_number -- 票据（包）号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票据（包）金额
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_crt_no -- 出票人社会信用代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,acceptor_crt_no -- 承兑人社会信用代码
            ,payee_name -- 收款人名称
            ,payee_bank_name -- 收款人开户行名称
            ,payee_account -- 收款人账号
            ,payee_bank_no -- 收款人开户行行号
            ,payee_crt_no -- 收款人社会信用代码
            ,drawee_bank_no -- 付款行行号
            ,drawee_brh_no -- 付款行机构代码
            ,drawee_bank_name -- 付款行名称
            ,drawee_confirm_brh_no -- 付款确认机构代码
            ,guarantee_bank_name -- 保证增信行行名
            ,guarantee_brh_no -- 保证增信行机构代码
            ,gua_accept_bank_no -- 承兑保证行行号
            ,gua_accept_brh_no -- 承兑保证行机构代码
            ,gua_discnt_brh_no -- 贴现保证行机构代码
            ,collection_bank_no -- 托收行行号
            ,holder_name -- 持票人名称
            ,holder_crt_no -- 持票人社会信用代码
            ,holder_acct_no -- 持票人账号
            ,holder_brh_no -- 持票人机构代码
            ,holder_brh_name -- 持票人机构名称
            ,endorse_times -- 背书次数
            ,lock_flag -- 锁定标志 1:锁定 0:解锁
            ,report_of_loss_flag -- 挂失状态
            ,deduct_status -- 扣款状态
            ,risk_status -- 风险票据状态：见DPC_PRODUCT_TRANS表的RISK_STATUS
            ,store_status -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
            ,src_type -- 票据来源： SR002 质押 SR004 贴现 SR005 转贴现 SR006 质押式回购 SR007 买断式回购 SR010 增信保管 SR011 付款确认 SR012 行内移库 SR013 保证 SR014 提示付款 SR015 追偿 SR016 承兑登记 SR017 承兑保证登记 SR018 质押登记 SR020 贴现登记 SR021 结清登记 SR026 权属登记 SR036 非交易过户 SR041 存托 SR042 供应链贴现 SR505 承兑 SR512 出票保证 SR513 承兑保证 SR514 背书保证
            ,flow_status -- 票据流转状态： F00 完成 F02 质押处理中 F03 质押解除处理中 F04 贴现处理中 F05 转贴现处理中 F06 质押式回购处理中 F07 买断式回购处理中 F08 质押式到期处理中 F09 买断式到期处理中 F10 增信保管处理中 F11 付款确认处理中 F12 行内移库处理中 F13 保证处理中 F14 提示付款处理中 F15 追偿处理中 F16 承兑登记处理中 F17 承兑保证登记处理中 F18 质押登记处理中 F19 质押解除登记处理中 F20 贴现登记处理中 F21 结清登记处理中 F22 止付登记处理中 F23 止付解除登记处理中 F24 线下追偿登记处理中 F25 追偿结清登记处理中 F26 权属登记处理中 F27 线下追偿申请处理中 F28 线下追偿签收处理中 F29 登记类撤回处理中 F34 提前赎回处理中 F35 逾期赎回处理中 F36 非交易过户处理中 F41 存托处理中 F42 供应链贴现处理中 F500 出票登记处理中 F501 提示承兑处理中 F502 撤票处理中 F503 提示收票处理中 F504 背书处理中 F505 承兑处理中 F506 贴现申请处理中 F507 直贴处理中 F508 回购式贴现处理中 F509 代理直贴处理中 F510 贴现赎回申请处理中 F511 贴现赎回签收处理中 F512 出票保证申请处理中 F513 承兑保证申请处理中 F514 背书保证申请处理中 F517 供应链直贴处理中 F518 供应链贴现回购式处理中 F519 供应链代理直贴处理中 F520 供应链贴现赎回申请处理中 F521 不得转让撤销处理中
            ,status -- 票据状态： S00 无效 S01 可交易 S02 已质押 S03 已质押解除 S04 已卖出 S05 待赎回 S06 质押式待赎回 S07 买断式待赎回 S08 质押式已逾期 S09 买断式已逾期 S10 已（增信）保证 S11 已付款确认 S14 已结清 S15 已偿付(付款) S16 承兑已登记 S17 承兑保证已登记 S18 质押已登记 S19 质押解除已登记 S20 贴现已登记 S21 结清已登记 S24 线下追偿已登记 S25 追偿结清已登记 S26 初始权属已登记 S27 线下追偿已申请 S28 线下追偿已签收 S29 已作废 S30 提前提示付款已同意 S31 提前提示付款已拒绝 S32 提示付款已同意 S33 提示付款已拒绝 S36 已过户 S39 信息已作废 S40 已逾期 S41 已存托 S42 供应链贴现已完成 S502 已撤票 S505 已承兑 S515 已偿付(收款) S520 分包中 S555 已拆分
            ,com_status -- 组合状态
            ,discount_brh_no -- 贴现行行机构代码
            ,discount_brh_name -- 贴现行名称
            ,store_brh_no -- 库存机构代码
            ,init_brh_no -- 初始权属登记机构
            ,belong_branch_no -- 票据所属机构号
            ,top_branch_no -- 总行机构号
            ,pay_confirm_flag -- 付款确认标志： PC00 完成 PC01 影像确认需补录影像 PC02 实物确认需补录影像 PC03 实物验证 PC04 审批拒绝 PC05 未付款确认 PC06 影像验证应答发起影像验证撤销 PC07 实物验证应答发起实物验证撤销
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 是否追偿： 0 否 1 是
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,squared_destroy_flag -- 
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,disc_date -- 贴现日期
            ,advance_flag -- 
            ,holder_bank_no -- 持票人开户行行号
            ,bp_no -- 供应链票据包编号
            ,forehand_range -- 前手区间
            ,current_range -- 当前区间
            ,product_type -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,belong_brh_no -- 所属票交所机构号/非法人产品
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
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
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_brh_no -- 出票人开户行机构代码
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_brh_no -- 承兑人开户行机构代码
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_brh_no -- 收款人开户行机构代码
            ,payee_brh_name -- 收款人开户行机构名称
            ,holder_mem_no -- 持票人渠道代码
            ,holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
            ,holder_bank_name -- 持票人开户行名称
            ,concurrent_control -- 并发控制
            ,consignment_code -- 到期无条件委托: CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,draft_transfer_flag -- 票面不得转让标志： EM00 可再转让 EM01 不得转让
            ,recovery_hand_flag -- 贴现前手动追索标志： 0 默认值 1 已贴现持票人（非贴现行）贴现后自动追索失败；贴现行持票人或贴现前持票人到期或期后提示付款被拒付；那么现在可发起贴现前手动拒付追索 2 已被后手拒付追索并偿付，现在可向前手发起拒付再追索 3 已被后手非拒付追索并偿付，现在可向前手发起非拒付再追索
            ,discount_draft_id -- 原票交所等分化贴现的票据ID
            ,hand_recovery_lock_flag -- 手动追索锁定标志： 0 解锁 1 锁定 2 同意清偿签收成功
            ,offline_recovery_flag -- 线下追偿标志： 0-不可线下追索 1-可线下追索
            ,stock_status -- 是否再贴现（1-已再贴现，0-库存。）
            ,is_receipt -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
            ,recept_brh -- 承接机构号
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,settle_date -- 结清日期
            ,' ' as migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from bdms_dpc_draft_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
