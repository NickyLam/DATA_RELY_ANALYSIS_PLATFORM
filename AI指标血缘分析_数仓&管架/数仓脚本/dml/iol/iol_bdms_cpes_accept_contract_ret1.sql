/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_accept_contract
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
                       FROM bdms_cpes_accept_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdms_cpes_accept_contract');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdms_cpes_accept_contract drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdms_cpes_accept_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdms_cpes_accept_contract(
            id -- ID
            ,contract_no -- 批次协议号
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,product_no -- 产品号
            ,product_attr -- 产品属性
            ,remitter_name -- 出票人名称
            ,remitter_acct -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_bank_name -- 付款行名称
            ,acceptor_bank_no -- 承兑人行号
            ,acceptor_bank_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人机构代码
            ,deposit_type -- 保证金类型： 1 一对一 2 一对多
            ,deposit_ratio -- 保证金比例（%）
            ,pledge_no -- 抵质押编号
            ,pledge_amt -- 抵质押价值
            ,pledge_type -- 担保方式：
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sign_status -- 签收状态： 00 未签收 01 部分签收 02 已签收
            ,credit_status -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
            ,risk_status -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,accept_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,credit_no -- 信贷合同编号
            ,credit_contract_amt -- 信贷合同金额
            ,credit_flowno -- 信贷流水号
            ,department_no -- 部门编号
            ,department_name -- 部门名称
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理名称
            ,agency_name -- 被代理人名称
            ,agency_account -- 被代理人账号
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托客户号
            ,actually_industy -- 实际投向行业
            ,busi_branch_no -- 交易机构编号
            ,account_branch_no -- 账务机构号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,busi_date -- 承兑签发日期
            ,task_type -- 来源
            ,webbank_contract_id -- 网银承兑协议ID
            ,draft_type -- 票据类型：1 银票2 商票
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,apply_reason -- 申请原因和用途
            ,first_repayment_acct -- 第一还款账号
            ,charge_scale -- 手续费比例
            ,trans_amount -- 交易金额
            ,credit_check_status -- 授信检查0-未检查1-检查成功2-检查失败
            ,data_source_type -- 数据来源类型1、系统手工录入2、接收网银数据
            ,misc -- 信息域
            ,main_assure_type -- 主要担保方式
            ,manage_fee -- 管理费
            ,accept_fee -- 承兑费
            ,contract_date -- 信贷返回的协议到期日
            ,acct_amount -- 结算账号余额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 本次放款后累计使用敞口
            ,cert_type -- 证件类型
            ,cert_id -- 证件ID
            ,report_url -- 征信报告URL
            ,core_enterprise -- 核心企业名称
            ,core_enterprise_cmoncd -- 核心企业组织机构代码
            ,batch_no -- 网银批量号码
            ,file_name -- 走文件方式文件名
            ,is_related -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
            ,bail_term -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
            ,bail_account -- 保证金账号
            ,bail_type -- 保证金类型 PG01 定期PG02 活期AC99 协议
            ,rates_type -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
            ,bail_rate -- 保证金利率
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,ratio_exp -- 敞口比例
            ,credit_protocol_no -- 信贷业务合同号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,drawee_bank_no -- 付款行号
            ,charge_ratio -- 手续费比例（%）
            ,credit_fee_ratio -- 额度管理费比例（%）
            ,acct_status -- 
            ,send_file_status -- 
            ,exposure_type -- 敞口类型 0-低风险 1-类低风险 2-敞口
            ,exposure_amount -- 敞口金额
            ,is_adjust_deposit -- 是否调整存款收益 0-否 1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- ID
            ,contract_no -- 批次协议号
            ,draft_attr -- 票据介质： 1 纸票 2 电票
            ,product_no -- 产品号
            ,product_attr -- 产品属性
            ,remitter_name -- 出票人名称
            ,remitter_acct -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_bank_name -- 付款行名称
            ,acceptor_bank_no -- 承兑人行号
            ,acceptor_bank_name -- 承兑人名称
            ,acceptor_brh_no -- 承兑人机构代码
            ,deposit_type -- 保证金类型： 1 一对一 2 一对多
            ,deposit_ratio -- 保证金比例（%）
            ,pledge_no -- 抵质押编号
            ,pledge_amt -- 抵质押价值
            ,pledge_type -- 担保方式：
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,sign_status -- 签收状态： 00 未签收 01 部分签收 02 已签收
            ,credit_status -- 授信状态： 00 额度未占用 01 额度占用成功 02 额度占用失败
            ,risk_status -- 风险检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,accept_status -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,credit_no -- 信贷合同编号
            ,credit_contract_amt -- 信贷合同金额
            ,credit_flowno -- 信贷流水号
            ,department_no -- 部门编号
            ,department_name -- 部门名称
            ,manager_no -- 客户经理编号
            ,manager_name -- 客户经理名称
            ,agency_name -- 被代理人名称
            ,agency_account -- 被代理人账号
            ,agency_bank_name -- 被代理行全称
            ,agency_bank_no -- 被代理行行号
            ,entrust_cust_no -- 委托客户号
            ,actually_industy -- 实际投向行业
            ,busi_branch_no -- 交易机构编号
            ,account_branch_no -- 账务机构号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,busi_date -- 承兑签发日期
            ,task_type -- 来源
            ,webbank_contract_id -- 网银承兑协议ID
            ,draft_type -- 票据类型：1 银票2 商票
            ,apply_accept_amount -- 申请承兑金额
            ,apply_remit_date -- 申请出票日
            ,maturity_date -- 到期日
            ,apply_reason -- 申请原因和用途
            ,first_repayment_acct -- 第一还款账号
            ,charge_scale -- 手续费比例
            ,trans_amount -- 交易金额
            ,credit_check_status -- 授信检查0-未检查1-检查成功2-检查失败
            ,data_source_type -- 数据来源类型1、系统手工录入2、接收网银数据
            ,misc -- 信息域
            ,main_assure_type -- 主要担保方式
            ,manage_fee -- 管理费
            ,accept_fee -- 承兑费
            ,contract_date -- 信贷返回的协议到期日
            ,acct_amount -- 结算账号余额
            ,all_credit_exp -- 已批准使用授信敞口
            ,total_use_credit_exp -- 本次放款后累计使用敞口
            ,cert_type -- 证件类型
            ,cert_id -- 证件ID
            ,report_url -- 征信报告URL
            ,core_enterprise -- 核心企业名称
            ,core_enterprise_cmoncd -- 核心企业组织机构代码
            ,batch_no -- 网银批量号码
            ,file_name -- 走文件方式文件名
            ,is_related -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
            ,bail_term -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
            ,bail_account -- 保证金账号
            ,bail_type -- 保证金类型 PG01 定期PG02 活期AC99 协议
            ,rates_type -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
            ,bail_rate -- 保证金利率
            ,pdrifd -- 保证金利率浮动类型
            ,pdrifm -- 保证金利率浮动方式
            ,pdrifv -- 保证金浮动值
            ,business_exp -- 业务合同占用敞口金额
            ,low_risk -- 是否低风险业务
            ,ratio_exp -- 敞口比例
            ,credit_protocol_no -- 信贷业务合同号
            ,unique_seq_num -- 业务流水号(交易订单号)
            ,drawee_bank_no -- 付款行号
            ,charge_ratio -- 手续费比例（%）
            ,credit_fee_ratio -- 额度管理费比例（%）
            ,acct_status -- 
            ,send_file_status -- 
            ,exposure_type -- 敞口类型 0-低风险 1-类低风险 2-敞口
            ,exposure_amount -- 敞口金额
            ,' ' as is_adjust_deposit -- 是否调整存款收益 0-否 1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_accept_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
