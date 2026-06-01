/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_buy_contract
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
                       FROM bdms_bms_buy_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdms_bms_buy_contract');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdms_bms_buy_contract drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdms_bms_buy_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdms_bms_buy_contract(
            id -- ID
            ,protocol_no -- 贴现协议号
            ,credit_no -- 信贷合同号
            ,credit_flow_no -- 信贷流水号
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 交易客户编号
            ,cust_name -- 交易客户名称
            ,cust_account -- 交易帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
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
            ,rpd_mk -- （转）贴现种类： RM00 买断 RM01 回购
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
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
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_type -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,all_credit_exp -- 已批准使用授信敞口
            ,batch_no -- 批次号
            ,cert_id -- 证件ID
            ,cert_type -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
            ,freeze_total_sum -- 客户冻结额度
            ,is_internal_settle -- 是否内部结算
            ,total_ck_sum -- 客户已使用敞口
            ,total_sum -- 客户总额度
            ,total_use_credit_exp -- 根词放款后累计使用敞口
            ,trans_amount -- 信贷有效金额
            ,used_total_ck_sum -- 客户已使用敞口
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,i9_type -- 
            ,add_last_date -- 后补截止日期
            ,applock -- 锁状态：00-未加锁 01-加锁
            ,contract_date -- 信贷协议到期日
            ,credit_aggreement -- 额度合同号
            ,discount_flag -- 票交所贴现登记状态0-否 1-是
            ,ebank_seria_no -- 交易门户推送的在线进件的唯一标识
            ,flag -- 是否在线贴现标志0-否 1-是
            ,internal_account -- 内部结算户
            ,is_related -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
            ,is_zhuanrang -- 是否转让标志
            ,report_url -- 征信报告url
            ,main_assure_type -- 主要担保方式
            ,sum_use_contract -- 合同已使用金额
            ,sum_contract -- 合同总额金额
            ,used_total_sum -- 合同已用总额
            ,file_name -- 走文件方式文件名
            ,credit_protocol_no -- 信贷合同号
            ,central_bankflg -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
            ,calc_status -- 
            ,authstatus -- 
            ,bussiness_type -- 业务细类
            ,postpone_type -- 利息计算顺延方式
            ,acct_status -- 
            ,send_file_status -- 
            ,reserve4 -- 
            ,business_belong_branchno -- 业务所属分行
            ,link_rate -- 联动利率
            ,risk_scale -- 
            ,fnlrvwtm -- 
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
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 账务机构号
            ,store_branch_no -- 库存机构号
            ,manager_no -- 客户经理编号
            ,department_no -- 所属部门编号
            ,product_no -- 产品类型编码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,cust_no -- 交易客户编号
            ,cust_name -- 交易客户名称
            ,cust_account -- 交易帐号
            ,cust_bank_no -- 贴出人开户行行号
            ,cust_bank_name -- 贴出人开户行名称
            ,apply_date -- 贴现申请日
            ,rate_type -- 利率期限单位：1 年息% 2 月息‰ 3 日息(万分率)
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
            ,rpd_mk -- （转）贴现种类： RM00 买断 RM01 回购
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
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
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态：00 无效01 未提交记账02 记账中03 记账完成04 记账失败05 记账异常06 已抹账10 计息复核通过 11 计息复核不通过  07信贷出账中 08 信贷出账成功 09信贷出账失败 12信贷已抹账
            ,sell_contract_id -- 卖出协议ID
            ,task_type -- 任务类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_type -- 贴现类型： 020 直贴 021 回购式贴现 022 代理直贴
            ,end_smt_flag -- 是否转入： 0 否 1 是
            ,trans_branch_no -- 交易机构号
            ,credit_check_status -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
            ,top_branch_no -- 总行机构号
            ,all_credit_exp -- 已批准使用授信敞口
            ,batch_no -- 批次号
            ,cert_id -- 证件ID
            ,cert_type -- 证件类型1001	组织机构代码1002	中征码1003	机构信用代码2001	工商注册号2002	机关和事业单位登记号2003	社会团体登记号2004	民办非企业单位登记号2005	基金会登记号2006	宗教活动场所登记号2007	统一社会信用代码2008	商事与非商事登记证号2099	其他
            ,freeze_total_sum -- 客户冻结额度
            ,is_internal_settle -- 是否内部结算
            ,total_ck_sum -- 客户已使用敞口
            ,total_sum -- 客户总额度
            ,total_use_credit_exp -- 根词放款后累计使用敞口
            ,trans_amount -- 信贷有效金额
            ,used_total_ck_sum -- 客户已使用敞口
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,e_contract_no -- 电子合同号
            ,e_img_no -- 电子合同影响流水号
            ,i9_type -- 
            ,add_last_date -- 后补截止日期
            ,applock -- 锁状态：00-未加锁 01-加锁
            ,contract_date -- 信贷协议到期日
            ,credit_aggreement -- 额度合同号
            ,discount_flag -- 票交所贴现登记状态0-否 1-是
            ,ebank_seria_no -- 交易门户推送的在线进件的唯一标识
            ,flag -- 是否在线贴现标志0-否 1-是
            ,internal_account -- 内部结算户
            ,is_related -- 是否关联方查询 y-是我行关联方 n-未在我行关联方信息库中找出完全匹配信息 p-关联方是自然人，须同时输入姓名和证件号进行查询 m-通过输入信息查询出多个关联方,请输入更详细的信息进行查询 l-名称非常接近，请做进一步核实
            ,is_zhuanrang -- 是否转让标志
            ,report_url -- 征信报告url
            ,main_assure_type -- 主要担保方式
            ,sum_use_contract -- 合同已使用金额
            ,sum_contract -- 合同总额金额
            ,used_total_sum -- 合同已用总额
            ,file_name -- 走文件方式文件名
            ,credit_protocol_no -- 信贷合同号
            ,central_bankflg -- 转贴现或再贴现0-贴现 1-转贴现 2-再贴现
            ,calc_status -- 
            ,authstatus -- 
            ,bussiness_type -- 业务细类
            ,postpone_type -- 利息计算顺延方式
            ,acct_status -- 
            ,send_file_status -- 
            ,reserve4 -- 
            ,business_belong_branchno -- 业务所属分行
            ,0 as link_rate -- 联动利率
            ,0 as risk_scale -- 
            ,' ' as fnlrvwtm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_buy_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
