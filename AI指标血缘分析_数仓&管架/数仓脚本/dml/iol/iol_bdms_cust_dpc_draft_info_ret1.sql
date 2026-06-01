/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cust_dpc_draft_info
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
                       FROM bdms_cust_dpc_draft_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdms_cust_dpc_draft_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdms_cust_dpc_draft_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdms_cust_dpc_draft_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdms_cust_dpc_draft_info(
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
            ,' ' as migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from bdms_cust_dpc_draft_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
