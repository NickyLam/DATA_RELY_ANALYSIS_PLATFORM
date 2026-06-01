/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_register_program
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
                       FROM icms_ap_register_program_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_ap_register_program');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_ap_register_program drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_ap_register_program add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.icms_ap_register_program(
            serialno -- 流水号
            ,programno -- 方案编号
            ,programname -- 方案名称
            ,customername -- 方案涉及借款人
            ,handletype -- 处置类型（不良资产转让）
            ,businesssum -- 合同金额合计
            ,balancesum -- 合同余额合计
            ,receiveamonut -- 财务应收款
            ,oninterestsum -- 表外利息余额合计
            ,outinterestsum -- 表外利息余额合计
            ,pecuniacreditasum -- 债权金额合计
            ,transferprice -- 转让价格
            ,payreceiveamonut -- 偿还财务应收款
            ,paylowamonut -- 偿还法律应收款
            ,paylowcost -- 偿还法律性费用
            ,paysum -- 偿还本金
            ,payinterest -- 偿还利息
            ,transferway -- 债权转让方式一（CD060034）
            ,othertransferway -- 债权转让方式二（CD060035）
            ,respinvestigationdate -- 卖方尽职调查基准日
            ,respinvestigationorg -- 卖方尽职调查中介机构名称
            ,vendeename -- 买受人名称
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,litigationphasecost -- 诉讼阶段法律性费用（元）
            ,cancelaccountcapbaldepos -- 账销案存资产本金余额（元）
            ,cancelaccountcapinowebalance -- 账销案存资产表内欠息余额（元）
            ,cancelaccountcapoutowebalance -- 账销案存资产表外欠息余额（元）
            ,summarize -- 方案综述
            ,riskassetlist -- 风险资产清单
            ,saveflag -- 保存标志
            ,executestatus -- 执行状态(CodeNo:ExecuteResult)
            ,packagedate -- 封包日期
            ,transferflag -- 转让标志(CodeNo:TransferFlag)
            ,currency -- 币种
            ,transferorg -- 变更后机构
            ,agentlegalfee -- 代垫诉讼费
            ,repaymode -- 付款方式（一次性付款、分期付款）
            ,downpayment -- 首付金额
            ,onaccountno -- 挂账编号
            ,transcontractno -- 转让合同号
            ,counterpartyacctname -- 交易对手名称
            ,counterpartyacct -- 交易对手账号
            ,openbankname -- 交易对手开户行名称
            ,openbankno -- 交易对手开户行行号
            ,counterpartyaccttype -- 交易对手类型
            ,transcontractstartdate -- 转让合同起始日期
            ,transcontractenddate -- 转让合同到期日期
            ,transtradplatform -- 转让交易平台
            ,transtradplatformcus -- 转让交易平台（自定义）
            ,counterpartypaydate -- 交易对手转账日期
            ,isaddrec -- 是否补录
            ,counterpartyacctcerttype -- 交易对手证件类型
            ,counterpartyacctcertid -- 交易对手证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,programno -- 方案编号
            ,programname -- 方案名称
            ,customername -- 方案涉及借款人
            ,handletype -- 处置类型（不良资产转让）
            ,businesssum -- 合同金额合计
            ,balancesum -- 合同余额合计
            ,receiveamonut -- 财务应收款
            ,oninterestsum -- 表外利息余额合计
            ,outinterestsum -- 表外利息余额合计
            ,pecuniacreditasum -- 债权金额合计
            ,transferprice -- 转让价格
            ,payreceiveamonut -- 偿还财务应收款
            ,paylowamonut -- 偿还法律应收款
            ,paylowcost -- 偿还法律性费用
            ,paysum -- 偿还本金
            ,payinterest -- 偿还利息
            ,transferway -- 债权转让方式一（CD060034）
            ,othertransferway -- 债权转让方式二（CD060035）
            ,respinvestigationdate -- 卖方尽职调查基准日
            ,respinvestigationorg -- 卖方尽职调查中介机构名称
            ,vendeename -- 买受人名称
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,litigationphasecost -- 诉讼阶段法律性费用（元）
            ,cancelaccountcapbaldepos -- 账销案存资产本金余额（元）
            ,cancelaccountcapinowebalance -- 账销案存资产表内欠息余额（元）
            ,cancelaccountcapoutowebalance -- 账销案存资产表外欠息余额（元）
            ,summarize -- 方案综述
            ,riskassetlist -- 风险资产清单
            ,saveflag -- 保存标志
            ,executestatus -- 执行状态(CodeNo:ExecuteResult)
            ,packagedate -- 封包日期
            ,transferflag -- 转让标志(CodeNo:TransferFlag)
            ,currency -- 币种
            ,transferorg -- 变更后机构
            ,agentlegalfee -- 代垫诉讼费
            ,repaymode -- 付款方式（一次性付款、分期付款）
            ,downpayment -- 首付金额
            ,onaccountno -- 挂账编号
            ,transcontractno -- 转让合同号
            ,counterpartyacctname -- 交易对手名称
            ,counterpartyacct -- 交易对手账号
            ,openbankname -- 交易对手开户行名称
            ,openbankno -- 交易对手开户行行号
            ,counterpartyaccttype -- 交易对手类型
            ,transcontractstartdate -- 转让合同起始日期
            ,transcontractenddate -- 转让合同到期日期
            ,transtradplatform -- 转让交易平台
            ,transtradplatformcus -- 转让交易平台（自定义）
            ,counterpartypaydate -- 交易对手转账日期
            ,isaddrec -- 是否补录
            ,' ' as counterpartyacctcerttype -- 交易对手证件类型
            ,' ' as counterpartyacctcertid -- 交易对手证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ap_register_program_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
