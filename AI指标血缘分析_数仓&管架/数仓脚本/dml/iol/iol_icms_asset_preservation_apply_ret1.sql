/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_asset_preservation_apply
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
                       FROM icms_asset_preservation_apply_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_asset_preservation_apply');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_asset_preservation_apply drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_asset_preservation_apply add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_asset_preservation_apply(
            afterlobj -- 减免前本金合计(时点合计)
            ,afterloddfy -- 减免前代垫费用合计(时点合计)
            ,afterlofl -- 减免前复利合计(时点合计)
            ,afterlofx -- 减免前罚息合计(时点合计)
            ,afterlolx -- 减免前利息合计(时点合计)
            ,approvestatus -- 审批状态
            ,classify -- 资产分类
            ,condition -- 条件(原因)
            ,counterparty -- 受让方（交易对手）
            ,counterpartyname -- 受让方（交易对手）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ddfyamtsum -- 代垫费用合计（本次交易）
            ,duebillnum -- 借据数量
            ,establishment -- 内部户开立机构
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,intamtsum -- 利息合计（本次交易）
            ,isborrowerrecourse -- 对借款人是否保留追索权
            ,isgurantyrecourse -- 对保证人是否保留追索权
            ,ispropertyclue -- 是否存在财产线索
            ,lastreturnedmoneysum -- 上次累计回款金额
            ,objecttype -- 对象类型
            ,occurtype -- 发生类型(01单户，02批量)
            ,odiamtsum -- 复利合计（本次交易）
            ,odpamtsum -- 罚息合计（本次交易）
            ,operatedate -- 经办时间
            ,operateorgid -- 经办客户经理所属机构
            ,operateuserid -- 经办客户经理
            ,priamtsum -- 本金合计（本次交易）
            ,propertyclue -- 财产线索简介
            ,relativeserialno -- 关联流水号（贷款转让流水号）
            ,remark -- 备注
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoney -- 本次回款金额
            ,returnedmoneysum -- 累计回款金额
            ,serialno -- 流水号
            ,sqamount -- 首期回款金额（含保证金）
            ,tradingplatform -- 交易平台
            ,transferaccount -- 转让回款账户（内部账户）
            ,transferaccountname -- 转让回款账户（内部账户）
            ,transferactualprice -- 真实转让对价（元）
            ,transfercontractno -- 转让合同号
            ,transferprice -- 转让价格
            ,transfertype -- 转让方式
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,usetossfdj -- 用于归还诉讼费的对价（元）
            ,writeofftype -- 核销类型
            ,ysaccount -- 应收款账户
            ,ysaccountname -- 应收款账户名称
            ,ysamount -- 应收款金额
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵债金额
            ,receivedate -- 接收日期
            ,debtrepayassettype -- 抵债资产类型
            ,debtrepaymenttype -- 抵债类型
            ,handletype -- 处置方式
            ,handlebalance -- 处置金额
            ,handledesc -- 处置说明
            ,disposaldate -- 生成时间
            ,creditbalance -- 授信余额
            ,lossamount -- 损失金额
            ,customertype -- 客户类型
            ,gurantytype -- 担保方式
            ,gurantorinfo -- 保证人
            ,gurantyinfo -- 抵（质）押物
            ,ssprogress -- 诉讼进展
            ,disposalplan -- 清收处置方案
            ,disposalprogress -- 最新处置进展
            ,nextplan -- 下一步工作计划
            ,existdifficulty -- 存在的困难
            ,deductsettleaccount -- 扣款结算账户
            ,deductsettleaccountbalance -- 扣款结算账户余额
            ,deductamount -- 扣划金额
            ,deductreason -- 扣划理由
            ,accountno -- 挂账编号
            ,iscompinterestforgiveness -- 是否利息全额减免
            ,programno -- 方案编号"
            ,isinstallment -- 是否分期付款标识
            ,counterpartycerttype -- 受让方（交易对手）证件类型
            ,counterpartycertid -- 受让方（交易对手）证件号
            ,qydate -- 签约日期
            ,sxdate -- 生效日期
            ,currency -- 协议币种
            ,xyamt -- 协议金额（元）
            ,bzjamt -- 保证金金额（元）
            ,bzjrate -- 保证金比例（%）
            ,bzjcurrency -- 保证金币种
            ,counterpartyzh -- 交易对手账号
            ,counterpartyzhbank -- 交易对手账号行号
            ,counterpartyzzdate -- 交易对手转账日期
            ,fycdsid -- 法院裁定书编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            afterlobj -- 减免前本金合计(时点合计)
            ,afterloddfy -- 减免前代垫费用合计(时点合计)
            ,afterlofl -- 减免前复利合计(时点合计)
            ,afterlofx -- 减免前罚息合计(时点合计)
            ,afterlolx -- 减免前利息合计(时点合计)
            ,approvestatus -- 审批状态
            ,classify -- 资产分类
            ,condition -- 条件(原因)
            ,counterparty -- 受让方（交易对手）
            ,counterpartyname -- 受让方（交易对手）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ddfyamtsum -- 代垫费用合计（本次交易）
            ,duebillnum -- 借据数量
            ,establishment -- 内部户开立机构
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,intamtsum -- 利息合计（本次交易）
            ,isborrowerrecourse -- 对借款人是否保留追索权
            ,isgurantyrecourse -- 对保证人是否保留追索权
            ,ispropertyclue -- 是否存在财产线索
            ,lastreturnedmoneysum -- 上次累计回款金额
            ,objecttype -- 对象类型
            ,occurtype -- 发生类型(01单户，02批量)
            ,odiamtsum -- 复利合计（本次交易）
            ,odpamtsum -- 罚息合计（本次交易）
            ,operatedate -- 经办时间
            ,operateorgid -- 经办客户经理所属机构
            ,operateuserid -- 经办客户经理
            ,priamtsum -- 本金合计（本次交易）
            ,propertyclue -- 财产线索简介
            ,relativeserialno -- 关联流水号（贷款转让流水号）
            ,remark -- 备注
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoney -- 本次回款金额
            ,returnedmoneysum -- 累计回款金额
            ,serialno -- 流水号
            ,sqamount -- 首期回款金额（含保证金）
            ,tradingplatform -- 交易平台
            ,transferaccount -- 转让回款账户（内部账户）
            ,transferaccountname -- 转让回款账户（内部账户）
            ,transferactualprice -- 真实转让对价（元）
            ,transfercontractno -- 转让合同号
            ,transferprice -- 转让价格
            ,transfertype -- 转让方式
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,usetossfdj -- 用于归还诉讼费的对价（元）
            ,writeofftype -- 核销类型
            ,ysaccount -- 应收款账户
            ,ysaccountname -- 应收款账户名称
            ,ysamount -- 应收款金额
            ,' ' as debtrepayassetid -- 抵债资产编号
            ,' ' as debtrepayassetname -- 抵债资产名称
            ,0 as debtrepaysum -- 抵债金额
            ,to_date('00010101','yyyymmdd') as receivedate -- 接收日期
            ,' ' as debtrepayassettype -- 抵债资产类型
            ,' ' as debtrepaymenttype -- 抵债类型
            ,' ' as handletype -- 处置方式
            ,0 as handlebalance -- 处置金额
            ,' ' as handledesc -- 处置说明
            ,' ' as disposaldate -- 生成时间
            ,0 as creditbalance -- 授信余额
            ,0 as lossamount -- 损失金额
            ,' ' as customertype -- 客户类型
            ,' ' as gurantytype -- 担保方式
            ,' ' as gurantorinfo -- 保证人
            ,' ' as gurantyinfo -- 抵（质）押物
            ,' ' as ssprogress -- 诉讼进展
            ,' ' as disposalplan -- 清收处置方案
            ,' ' as disposalprogress -- 最新处置进展
            ,' ' as nextplan -- 下一步工作计划
            ,' ' as existdifficulty -- 存在的困难
            ,' ' as deductsettleaccount -- 扣款结算账户
            ,0 as deductsettleaccountbalance -- 扣款结算账户余额
            ,0 as deductamount -- 扣划金额
            ,' ' as deductreason -- 扣划理由
            ,' ' as accountno -- 挂账编号
            ,' ' as iscompinterestforgiveness -- 是否利息全额减免
            ,' ' as programno -- 方案编号"
            ,' ' as isinstallment -- 是否分期付款标识
            ,' ' as counterpartycerttype -- 受让方（交易对手）证件类型
            ,' ' as counterpartycertid -- 受让方（交易对手）证件号
            ,to_date('00010101','yyyymmdd') as qydate -- 签约日期
            ,to_date('00010101','yyyymmdd') as sxdate -- 生效日期
            ,' ' as currency -- 协议币种
            ,0 as xyamt -- 协议金额（元）
            ,0 as bzjamt -- 保证金金额（元）
            ,0 as bzjrate -- 保证金比例（%）
            ,' ' as bzjcurrency -- 保证金币种
            ,' ' as counterpartyzh -- 交易对手账号
            ,' ' as counterpartyzhbank -- 交易对手账号行号
            ,to_date('00010101','yyyymmdd') as counterpartyzzdate -- 交易对手转账日期
            ,' ' as fycdsid -- 法院裁定书编号
                        ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from icms_asset_preservation_apply_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
