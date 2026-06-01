/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BC_EXTEND_T_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_BC_EXTEND_T_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BC_EXTEND_T');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BC_EXTEND_T drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BC_EXTEND_T add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BC_EXTEND_T(
            serialno -- 合同编号
            ,rivalname -- 交易对手名称
            ,consigneename -- 发行公司名称
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,consigneecertid -- 管理人/主承销商证件号码
            ,financier -- 实际融资人
            ,iscounterparty -- 是否合格中央交易对手
            ,fundsource -- 资金来源
            ,investway -- 投资方式
            ,managemodel -- 管理模式
            ,tradingassets -- 交易资产
            ,toindustryfund -- 是否投向产业基金
            ,isdebttoequity -- 是否投向市场化债转股
            ,isgovernfinance -- 是否涉及政府类融资
            ,isconsumerfinance -- 是否为消费服务类融资
            ,bondno -- 标的产品编号
            ,bondname -- 标的产品名称
            ,investkind -- 投资性质
            ,canseparate -- 是否可分离
            ,canbacktosale -- 是否含有回售选择权
            ,salebackbegindate -- 回售申请起始日
            ,salebackenddate -- 回售申请截止日
            ,businessmarkettype -- 交易市场类型
            ,businessmarketname -- 交易市场名称
            ,begindate -- 债券发行日期
            ,paymentdate -- 协议到期日期
            ,outerevaluate1 -- 债券外部评级结果（发行时）
            ,outerevaluate2 -- 债券外部评级结果（购买时）
            ,outerevaluate3 -- 债券外部评级结果（当前）
            ,couponrate -- 票面利率
            ,transactionprice -- 成交净价
            ,transactionrate -- 成交利率
            ,transactoinamount -- 成交量
            ,transactiondate -- 实际交割日期
            ,creditincrementtype -- 主要增信方式
            ,islikeloan -- 是否类信贷
            ,isclassflag -- 是否分级
            ,productlevel -- 产品分级级别
            ,productcollectmoney -- 债券面值
            ,finalinvestdirecttype -- 最终投向类型
            ,mandatecustname -- 委托人名称
            ,mandatecustid -- 委托人ID
            ,acceptbankid -- 承兑行行号
            ,billacptdate -- 出票日(票据)
            ,billcurrency -- 票据币种(票据)
            ,billmaturity -- 到期日(票据)
            ,chuantoutype -- 穿透类型
            ,econtractname -- 合同名称(信托资管)
            ,econtracttype -- 合同类型(信托资管)
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,guranteerate -- 质押率/初始履约保障比例
            ,contractitems -- 合同期次
            ,importantloan -- 重点贷款项目
            ,operationtype -- 业务类型
            ,acceptbankname -- 承兑行名称
            ,backtosaletype -- 回购类型
            ,beneficiaryacctno -- 受益人账户
            ,ifgudingcredit -- 是否固定资产授信
            ,manageratetype -- 管理费费率及计提方式
            ,othercondition -- 其他条件和要求
            ,subtotalprices -- 认购总价
            ,ztacceptbankid -- 直贴行行号
            ,corpuspaymethod -- 还款方式
            ,creditattribute -- 合同类型
            ,depositratetype -- 托管费费率及计提方式
            ,expectyieldrate -- 预期收益率
            ,isimportantloan -- 是否重点项目贷款
            ,tradecontractno -- 贸易合同号
            ,acceptcustomerid -- 承兑行我行客户编号
            ,entrustyieldtype -- 信托收益计提方式
            ,isbalancedeposit -- 是否结算性存款
            ,isfillassetsinfo -- 是否已完整录入全部底层资产信息
            ,raisefundpurpose -- 募集资金用途
            ,ztacceptbankname -- 直贴行名称
            ,raisemoneyaccountid -- 募集资金账户
            ,repayinteresttype -- 还本付息方式(输入)
            ,businessinvoicesum -- 商业发票金额
            ,financesupportmode -- 贷款财政扶持方式
            ,businessinvoiceinfo -- 商业发票号码
            ,businessinvoicetype -- 商业发票种类
            ,entrustinterestrate -- 信托报酬率
            ,rateexplain -- 利率/费率说明
            ,beneficiaryyieldrate -- 受益人的预计年净收益率
            ,circulatestockamount -- 流通股本(万股)
            ,issupplychainfinance -- 是否为供应链金融业务
            ,relztacceptbankcustid -- 直贴行我行客户编号
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,businessinvoicecurrency -- 商业发票币种
            ,entrustinterestratetype -- 信托报酬率计提方式
            ,gshy -- 过剩行业
            ,baileename -- 受托人名称
            ,billno -- 票据号码
            ,gksxpz -- 国开授信品种
            ,issuer -- 发行人/融资者
            ,iswhzt -- 是否我行直贴票据
            ,pcline -- 平仓线
            ,sfgksx -- 是否国开行授信
            ,sfzfsx -- 是否政府授信
            ,zfsxfs -- 政府授信支持方式
            ,zfsxlx -- 政府授信类型
            ,ztrate -- 转贴现利率(%)
            ,billsum -- 票面金额（元）
            ,enddate -- 到期日期(ABS)
            ,tdtimes -- 与交易对手成功交易次数
            ,tdyears -- 与交易对手合作年限
            ,trusteename -- 托管人名称
            ,billkind -- 票据种类
            ,billtype -- 票据类型
            ,deadline -- 期限(标的)
            ,issuesum -- 发行金额(元)
            ,sfgjxzhy -- 是否国家限制行业
            ,tradesum -- 贸易合同总金额(元)
            ,alarmline -- 预警线
            ,custodianname -- 管理人名称
            ,depositno -- 存单号码
            ,isfarming -- 是否涉农贷款标志
            ,repayremark -- 还款说明
            ,stockcode -- 标的股票代码
            ,stockname -- 标的股票名称
            ,tdstrenth -- 交易对手实力
            ,absabnname -- ABS/ABN名称
            ,bdindustry -- 标的公司行业分类
            ,billwriter -- 出票人
            ,entrustacc -- 信托专户
            ,issueprice -- 发行价格
            ,issuescale -- 发行规模
            ,partybname -- 借款人
            ,priequname -- 私募债名称
            ,subscriber -- 认购人/投资者
            ,useproduct -- 使用产品（贸易融资）
            ,contextinfo -- 交易背景描述
            ,drawingremark -- 提款说明
            ,contractsum -- 合同资金(信托资管)
            ,depositname -- 存单简称
            ,directionrs -- 行业投向(征信)
            ,drawingtype -- 提款方式
            ,issueamount -- 发行量(元)
            ,mainproduct -- 经营商品（贸易融资）
            ,stockamount -- 总股本(万股)
            ,beneficiaryname -- 受益人名称
            ,consigneeid -- 管理人/主承销商客户编号
            ,rivalid -- 同业交易对手
            ,datatype -- 业务来源（PJ,票据系统供数 LC,理财资管系统供数 ZJ,资金系统供数 ZH,同业综合业务系统供数）
            ,accountcatagory -- 账户类别
            ,migtflag -- 迁移标志
            ,assetno -- 资产唯一标识
            ,interestrepaycycle -- 
            ,shortbondno -- 
            ,oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 合同编号
            ,rivalname -- 交易对手名称
            ,consigneename -- 发行公司名称
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,consigneecertid -- 管理人/主承销商证件号码
            ,financier -- 实际融资人
            ,iscounterparty -- 是否合格中央交易对手
            ,fundsource -- 资金来源
            ,investway -- 投资方式
            ,managemodel -- 管理模式
            ,tradingassets -- 交易资产
            ,toindustryfund -- 是否投向产业基金
            ,isdebttoequity -- 是否投向市场化债转股
            ,isgovernfinance -- 是否涉及政府类融资
            ,isconsumerfinance -- 是否为消费服务类融资
            ,bondno -- 标的产品编号
            ,bondname -- 标的产品名称
            ,investkind -- 投资性质
            ,canseparate -- 是否可分离
            ,canbacktosale -- 是否含有回售选择权
            ,salebackbegindate -- 回售申请起始日
            ,salebackenddate -- 回售申请截止日
            ,businessmarkettype -- 交易市场类型
            ,businessmarketname -- 交易市场名称
            ,begindate -- 债券发行日期
            ,paymentdate -- 协议到期日期
            ,outerevaluate1 -- 债券外部评级结果（发行时）
            ,outerevaluate2 -- 债券外部评级结果（购买时）
            ,outerevaluate3 -- 债券外部评级结果（当前）
            ,couponrate -- 票面利率
            ,transactionprice -- 成交净价
            ,transactionrate -- 成交利率
            ,transactoinamount -- 成交量
            ,transactiondate -- 实际交割日期
            ,creditincrementtype -- 主要增信方式
            ,islikeloan -- 是否类信贷
            ,isclassflag -- 是否分级
            ,productlevel -- 产品分级级别
            ,productcollectmoney -- 债券面值
            ,finalinvestdirecttype -- 最终投向类型
            ,mandatecustname -- 委托人名称
            ,mandatecustid -- 委托人ID
            ,acceptbankid -- 承兑行行号
            ,billacptdate -- 出票日(票据)
            ,billcurrency -- 票据币种(票据)
            ,billmaturity -- 到期日(票据)
            ,chuantoutype -- 穿透类型
            ,econtractname -- 合同名称(信托资管)
            ,econtracttype -- 合同类型(信托资管)
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,guranteerate -- 质押率/初始履约保障比例
            ,contractitems -- 合同期次
            ,importantloan -- 重点贷款项目
            ,operationtype -- 业务类型
            ,acceptbankname -- 承兑行名称
            ,backtosaletype -- 回购类型
            ,beneficiaryacctno -- 受益人账户
            ,ifgudingcredit -- 是否固定资产授信
            ,manageratetype -- 管理费费率及计提方式
            ,othercondition -- 其他条件和要求
            ,subtotalprices -- 认购总价
            ,ztacceptbankid -- 直贴行行号
            ,corpuspaymethod -- 还款方式
            ,creditattribute -- 合同类型
            ,depositratetype -- 托管费费率及计提方式
            ,expectyieldrate -- 预期收益率
            ,isimportantloan -- 是否重点项目贷款
            ,tradecontractno -- 贸易合同号
            ,acceptcustomerid -- 承兑行我行客户编号
            ,entrustyieldtype -- 信托收益计提方式
            ,isbalancedeposit -- 是否结算性存款
            ,isfillassetsinfo -- 是否已完整录入全部底层资产信息
            ,raisefundpurpose -- 募集资金用途
            ,ztacceptbankname -- 直贴行名称
            ,raisemoneyaccountid -- 募集资金账户
            ,repayinteresttype -- 还本付息方式(输入)
            ,businessinvoicesum -- 商业发票金额
            ,financesupportmode -- 贷款财政扶持方式
            ,businessinvoiceinfo -- 商业发票号码
            ,businessinvoicetype -- 商业发票种类
            ,entrustinterestrate -- 信托报酬率
            ,rateexplain -- 利率/费率说明
            ,beneficiaryyieldrate -- 受益人的预计年净收益率
            ,circulatestockamount -- 流通股本(万股)
            ,issupplychainfinance -- 是否为供应链金融业务
            ,relztacceptbankcustid -- 直贴行我行客户编号
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,businessinvoicecurrency -- 商业发票币种
            ,entrustinterestratetype -- 信托报酬率计提方式
            ,gshy -- 过剩行业
            ,baileename -- 受托人名称
            ,billno -- 票据号码
            ,gksxpz -- 国开授信品种
            ,issuer -- 发行人/融资者
            ,iswhzt -- 是否我行直贴票据
            ,pcline -- 平仓线
            ,sfgksx -- 是否国开行授信
            ,sfzfsx -- 是否政府授信
            ,zfsxfs -- 政府授信支持方式
            ,zfsxlx -- 政府授信类型
            ,ztrate -- 转贴现利率(%)
            ,billsum -- 票面金额（元）
            ,enddate -- 到期日期(ABS)
            ,tdtimes -- 与交易对手成功交易次数
            ,tdyears -- 与交易对手合作年限
            ,trusteename -- 托管人名称
            ,billkind -- 票据种类
            ,billtype -- 票据类型
            ,deadline -- 期限(标的)
            ,issuesum -- 发行金额(元)
            ,sfgjxzhy -- 是否国家限制行业
            ,tradesum -- 贸易合同总金额(元)
            ,alarmline -- 预警线
            ,custodianname -- 管理人名称
            ,depositno -- 存单号码
            ,isfarming -- 是否涉农贷款标志
            ,repayremark -- 还款说明
            ,stockcode -- 标的股票代码
            ,stockname -- 标的股票名称
            ,tdstrenth -- 交易对手实力
            ,absabnname -- ABS/ABN名称
            ,bdindustry -- 标的公司行业分类
            ,billwriter -- 出票人
            ,entrustacc -- 信托专户
            ,issueprice -- 发行价格
            ,issuescale -- 发行规模
            ,partybname -- 借款人
            ,priequname -- 私募债名称
            ,subscriber -- 认购人/投资者
            ,useproduct -- 使用产品（贸易融资）
            ,contextinfo -- 交易背景描述
            ,drawingremark -- 提款说明
            ,contractsum -- 合同资金(信托资管)
            ,depositname -- 存单简称
            ,directionrs -- 行业投向(征信)
            ,drawingtype -- 提款方式
            ,issueamount -- 发行量(元)
            ,mainproduct -- 经营商品（贸易融资）
            ,stockamount -- 总股本(万股)
            ,beneficiaryname -- 受益人名称
            ,consigneeid -- 管理人/主承销商客户编号
            ,rivalid -- 同业交易对手
            ,datatype -- 业务来源（PJ,票据系统供数 LC,理财资管系统供数 ZJ,资金系统供数 ZH,同业综合业务系统供数）
            ,accountcatagory -- 账户类别
            ,migtflag -- 迁移标志
            ,assetno -- 资产唯一标识
            ,' ' AS interestrepaycycle -- 
            ,' ' AS shortbondno -- 
            ,' ' AS oldassetno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BC_EXTEND_T_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
