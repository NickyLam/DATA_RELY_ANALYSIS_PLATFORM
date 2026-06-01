/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_buy_contract
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
                       FROM bdms_cpes_buy_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdms_cpes_buy_contract');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdms_cpes_buy_contract drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdms_cpes_buy_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdms_cpes_buy_contract(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 交易机构编号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 贴出人客户号
            ,cust_name -- 贴出人全称
            ,cust_account -- 贴出人帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_scale -- 买方付息比例
            ,payer_name -- 买方全称
            ,payer_account -- 买方帐号
            ,agent_name -- 代理人全称
            ,agent_account -- 代理人帐号
            ,agent_bank_no -- 代理人开户行行号
            ,agent_bank_name -- 代理人开户行名称
            ,mend_flag -- 是否资料后补： 0 否 1 是
            ,agent_flag -- 是否代理贴现： 0 否 1 是
            ,discount_first_flag -- 是否先贴后查： 0 否 1 是
            ,actually_industy -- 实际投向行业
            ,rpd_mk -- 贴现种类： RM00 买断 RM01 回购
            ,inner_flag -- 是否系统内买入： 0 否 1 是
            ,storage_flag -- 是否代保管： 0 否 1 是
            ,repurchase_rate_type -- 赎回利率类型
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payer_bank_no -- 买方开户行行号
            ,payer_bank_name -- 买方开户行名称
            ,operator_no -- 业务发起人编号
            ,txn_date -- 业务发起日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 10 报文处理中 11 报文处理完成 13 部分散票审核退回 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,busi_type -- 贴现类型： 507 直贴 508 回购式贴现 509 代理直贴 517 供应链直贴 518 供应链回购式贴现 519 供应链代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,is_related -- 是否关联方查询
            ,file_name -- 
            ,cert_type -- 
            ,total_ck_sum -- 客户已使用敞口
            ,used_total_ck_sum -- 客户已使用敞口
            ,contract_date -- 信贷协议到期日
            ,internal_account -- 内部结算户
            ,i9_type -- 
            ,cert_id -- 
            ,freeze_total_sum -- 
            ,credit_aggreement -- 额度合同号
            ,report_url -- 
            ,used_total_sum -- 合同已用总额
            ,sum_contract -- 
            ,add_last_date -- 后补截止日期
            ,batch_no -- 证件ID
            ,total_sum -- 客户总额度
            ,is_zhuanrang -- 
            ,sum_use_contract -- 合同已使用金额
            ,trans_amount -- 信贷有效金额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 
            ,bussiness_type -- 业务细类
            ,sttlm_mk -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,acct_status -- 
            ,send_file_status -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,ebank_seria_no -- 
            ,risk_scale -- 
            ,fnlrvwtm -- 
            ,scf_flag -- 
            ,scf_prod -- 
            ,scf_risk_control_result -- 
            ,ato_sell_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 交易机构编号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 贴出人客户号
            ,cust_name -- 贴出人全称
            ,cust_account -- 贴出人帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_scale -- 买方付息比例
            ,payer_name -- 买方全称
            ,payer_account -- 买方帐号
            ,agent_name -- 代理人全称
            ,agent_account -- 代理人帐号
            ,agent_bank_no -- 代理人开户行行号
            ,agent_bank_name -- 代理人开户行名称
            ,mend_flag -- 是否资料后补： 0 否 1 是
            ,agent_flag -- 是否代理贴现： 0 否 1 是
            ,discount_first_flag -- 是否先贴后查： 0 否 1 是
            ,actually_industy -- 实际投向行业
            ,rpd_mk -- 贴现种类： RM00 买断 RM01 回购
            ,inner_flag -- 是否系统内买入： 0 否 1 是
            ,storage_flag -- 是否代保管： 0 否 1 是
            ,repurchase_rate_type -- 赎回利率类型
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payer_bank_no -- 买方开户行行号
            ,payer_bank_name -- 买方开户行名称
            ,operator_no -- 业务发起人编号
            ,txn_date -- 业务发起日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 10 报文处理中 11 报文处理完成 13 部分散票审核退回 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,busi_type -- 贴现类型： 507 直贴 508 回购式贴现 509 代理直贴 517 供应链直贴 518 供应链回购式贴现 519 供应链代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,is_related -- 是否关联方查询
            ,file_name -- 
            ,cert_type -- 
            ,total_ck_sum -- 客户已使用敞口
            ,used_total_ck_sum -- 客户已使用敞口
            ,contract_date -- 信贷协议到期日
            ,internal_account -- 内部结算户
            ,i9_type -- 
            ,cert_id -- 
            ,freeze_total_sum -- 
            ,credit_aggreement -- 额度合同号
            ,report_url -- 
            ,used_total_sum -- 合同已用总额
            ,sum_contract -- 
            ,add_last_date -- 后补截止日期
            ,batch_no -- 证件ID
            ,total_sum -- 客户总额度
            ,is_zhuanrang -- 
            ,sum_use_contract -- 合同已使用金额
            ,trans_amount -- 信贷有效金额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 
            ,bussiness_type -- 业务细类
            ,sttlm_mk -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,acct_status -- 
            ,send_file_status -- 
            ,business_belong_branchno -- 业务所属分行
            ,0 as link_rate -- 联动利率
            ,' ' as ebank_seria_no -- 
            ,0 as risk_scale -- 
            ,' ' as fnlrvwtm -- 
            ,' ' as scf_flag -- 
            ,' ' as scf_prod -- 
            ,' ' as scf_risk_control_result -- 
            ,' ' as ato_sell_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_buy_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
