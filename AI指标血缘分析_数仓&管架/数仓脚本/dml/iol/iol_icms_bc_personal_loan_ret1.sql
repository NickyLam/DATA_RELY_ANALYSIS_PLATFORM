/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BC_PERSONAL_LOAN_ret1
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
                       FROM ICMS_BC_PERSONAL_LOAN_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BC_PERSONAL_LOAN');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BC_PERSONAL_LOAN drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BC_PERSONAL_LOAN add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BC_PERSONAL_LOAN(
            serialno -- 流水号
            ,esaepclassify -- 节能环保分类
            ,mandatedepositaccounts -- 委托贷款存款账号
            ,relationship -- 集团客户可用敞口额度
            ,eaccountno -- E账户
            ,stallprice -- 车位总价
            ,companyexposuresum -- 公司授信总金额(元)
            ,purpose -- 用途
            ,isbankrel -- 是否我行关联方
            ,sellercertid -- 卖房人证件号码
            ,loanaccountname -- 入账账户名称
            ,buildingunitprice -- 建筑面积单价
            ,mandaterequirement -- 委托条件
            ,isexception -- 是否例外额度
            ,endaccountname -- 最终绑定卡卡名
            ,imageapprresult -- 影像审批结果
            ,isdiscount -- 是否行内贴息/贴息标识
            ,vehiclecontractno -- 购车合同号
            ,housingsum -- 房屋套数
            ,renewalflag -- 合同是否支持续期标识
            ,localstrategicindustry -- 本地战略性新兴产业
            ,insuranceperiod -- 保险期限保险期限(月)
            ,housingname -- 楼盘名称
            ,totalrecyleamt -- 累计回收金额
            ,guarantytype -- 担保类型
            ,guaranteeagreement -- 相关回购/担保协议书编号
            ,insurancecontractno -- 保险合同编号
            ,paymentobject -- 支付对象
            ,relserialno -- 关联编号
            ,excess -- 免赔率
            ,imagefilepath -- 影像文件路径
            ,parkingaddress -- 购车位详址
            ,groupcustcode -- 集团客户号
            ,paymentratio -- 首付比例
            ,isopenentsettleaccounts -- 是否能够开立单位结算账户
            ,isfirstpurchase -- 是否首次购房
            ,imageflag -- 影像标识
            ,mandatedepositsum -- 委托存款金额
            ,suitesunitprice -- 套房面积单价
            ,downpayment -- 首付金额
            ,isinsurance -- 是否购买保险
            ,eaccountname -- E账户户名
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businessname -- 商家/销售商/开发商/建房单位名称
            ,parkingarea -- 购车位面积
            ,feeratio -- 手续费率
            ,housingprice -- 房屋总价
            ,iswhite -- 借款人与集团关系
            ,purchasecontractid -- 购房合同号
            ,loanratio -- 贷款成数
            ,businesslicence -- 营业执照号码
            ,payaccountcertid -- 绑定身份证号
            ,recordrelativeserialno -- 关联中介备案编号
            ,telephone -- 手机号
            ,isbigaccountmode -- 是否大账户模式
            ,channelno -- 渠道编号
            ,buildingcompany -- 建筑单位
            ,housinglevel -- 房屋等级
            ,startbankno -- 初始卡开户行
            ,financialbond -- 委放/专项/金融债
            ,insurername -- 保险公司名称
            ,fitmentprice -- 装修总价
            ,repaymentaccname -- 还款账户名称
            ,endclearbankno -- 收款方开户行清算行行号（最终）
            ,presalepermitno -- 预售许可证编号
            ,extenddays -- 宽限天数
            ,isonline -- 是否线上审批
            ,propertyarea -- 所购房产面积
            ,evaluationname -- 评估机构名称
            ,suitesarea -- 购房面积（套内面积）
            ,payaccounttel -- 开户手机
            ,evaluationcertid -- 评估机构证件号码
            ,mandatedepositcurrency -- 委托存款币种
            ,exposeclassifyresult -- 风险暴露分类结果
            ,fundsprovided -- 资金来源
            ,principalcertid -- 委托人有效证件号码
            ,endaccountno -- 最终绑定卡卡号
            ,principalmarriage -- 委托人婚姻状况
            ,isbusinessguarantee -- 是否合作机构/开发商/经销商担保
            ,isvendorassumeliability -- 是否销售商承担回购责任
            ,groupcustname -- 集团客户名称
            ,housingaddress -- 房屋详址
            ,payaccounttype -- 还款卡类型0-本行卡,1-他行卡
            ,personalbusinessloanstype -- 个人经营性贷款分类
            ,evaluationcerttype -- 评估证件类型
            ,discountratio -- 贴息比例
            ,corporgid -- 法人机构编号
            ,iscompanycustomer -- 是否公司额度管控
            ,enterprisecode -- 经销商企业代码
            ,companycustomername -- 公司客户名称
            ,housingform -- 房屋形式
            ,paymentbasis -- 首付款依据
            ,feesum -- 手续费金额
            ,isgroupcustomer -- 是否集团客户
            ,isloananytime -- 是否随借随还
            ,sellername -- 卖房人名称
            ,businessclass -- 类别
            ,principalname -- 委托人名称
            ,creditincrmode -- 增信模式标志
            ,loandirection -- 资金投向
            ,insurancevariety -- 保险品种
            ,buildingarea -- 购房面积（建筑面积）
            ,repaydatetype -- 还款日确定
            ,feepayment -- 手续费支付方式
            ,repaymentaccount -- 还款账号
            ,evaluateprice -- 评估价格
            ,propertyunitprice -- 物管费单价
            ,availexposure -- 集团客户可用敞口额度
            ,endbankno -- 最终实体卡对应的开户行
            ,companyrelation -- 借款人与公司关系
            ,propertytype -- 所购房产类型
            ,endbankname -- 最终实体卡对应的开户行名称
            ,isjgaccount -- 是否在我行开立监管账户
            ,vehicletype -- 车型
            ,startaccountno -- 初始卡卡号
            ,startclearbankno -- 收款方开户行清算行行号（最初）
            ,vehicleprice -- 汽车总价
            ,insurance -- 保险金额
            ,wthruselmt -- 是否使用额度
            ,mandateriskclassify -- 委托贷款风险分类
            ,propertycertid -- 房屋权证号
            ,loanaccountno -- 入账账号
            ,startbankname -- 初始卡开户行名称
            ,determprice -- 认定价格
            ,paymenttype -- 支付方式
            ,companycustomerid -- 公司客户号
            ,propertycontractno -- 车位配套住房产权号/购房合同号
            ,clientno -- 委托人编号
            ,startaccountname -- 初始卡账户名称
            ,commodityamt -- 购买金额
            ,businesscertcode -- 统一社会信用代码
            ,payway -- 贷款发放方式(1-一次2-分次)
            ,dealdisputeway -- 解决争议方式(1-甲方所在地人民法院2-仲裁委员会3-天河区人民法院4-其他)
            ,dealdisputetxt -- 解决争议方式备注
            ,isforcedeal -- 是否强制执行公证(1-是2-否)
            ,bigloanpurpose -- 贷款用途大类
            ,zjkjstatus -- 致景科技合同激活状态 0-未激活 1-待激活 2-已激活
            ,cartype -- 车辆类型
            ,greenloanpurpose -- 绿色贷款用途
            ,accountserialno -- 关联账户流水号
            ,subgreenconsumeloanpurpose -- 绿色消费子类
            ,isagriculture -- 是否涉农
            ,highindustry -- 高技术产业
            ,economyindustry -- 数字经济核心产业
            ,intellectualindustry -- 投向知识产权密集型产业
            ,strategicindustry -- 
            ,cultureindustry -- 投向文化及相关产业
            ,isnewcoborrower -- 
            ,productchannel -- 
            ,claimperson -- 
            ,isclaim -- 
            ,isbelongterm -- 
            ,centralizeorgid -- 
            ,centralizeoperaid -- 
            ,claimdate -- 
			,extloanaccountno -- 行外收款银行卡号
            ,extloanaccountname -- 行外收款卡户名
            ,recvbankid -- 收款银行编号
            ,recvbankname -- 收款银行名称
            ,extrepaymentaccount -- 行外还款银行卡号
            ,extrepaymentaccname -- 行外还款卡户名
            ,repaybankid -- 还款银行编号
            ,repaybankname -- 还款银行名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,esaepclassify -- 节能环保分类
            ,mandatedepositaccounts -- 委托贷款存款账号
            ,relationship -- 集团客户可用敞口额度
            ,eaccountno -- E账户
            ,stallprice -- 车位总价
            ,companyexposuresum -- 公司授信总金额(元)
            ,purpose -- 用途
            ,isbankrel -- 是否我行关联方
            ,sellercertid -- 卖房人证件号码
            ,loanaccountname -- 入账账户名称
            ,buildingunitprice -- 建筑面积单价
            ,mandaterequirement -- 委托条件
            ,isexception -- 是否例外额度
            ,endaccountname -- 最终绑定卡卡名
            ,imageapprresult -- 影像审批结果
            ,isdiscount -- 是否行内贴息/贴息标识
            ,vehiclecontractno -- 购车合同号
            ,housingsum -- 房屋套数
            ,renewalflag -- 合同是否支持续期标识
            ,localstrategicindustry -- 本地战略性新兴产业
            ,insuranceperiod -- 保险期限保险期限(月)
            ,housingname -- 楼盘名称
            ,totalrecyleamt -- 累计回收金额
            ,guarantytype -- 担保类型
            ,guaranteeagreement -- 相关回购/担保协议书编号
            ,insurancecontractno -- 保险合同编号
            ,paymentobject -- 支付对象
            ,relserialno -- 关联编号
            ,excess -- 免赔率
            ,imagefilepath -- 影像文件路径
            ,parkingaddress -- 购车位详址
            ,groupcustcode -- 集团客户号
            ,paymentratio -- 首付比例
            ,isopenentsettleaccounts -- 是否能够开立单位结算账户
            ,isfirstpurchase -- 是否首次购房
            ,imageflag -- 影像标识
            ,mandatedepositsum -- 委托存款金额
            ,suitesunitprice -- 套房面积单价
            ,downpayment -- 首付金额
            ,isinsurance -- 是否购买保险
            ,eaccountname -- E账户户名
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businessname -- 商家/销售商/开发商/建房单位名称
            ,parkingarea -- 购车位面积
            ,feeratio -- 手续费率
            ,housingprice -- 房屋总价
            ,iswhite -- 借款人与集团关系
            ,purchasecontractid -- 购房合同号
            ,loanratio -- 贷款成数
            ,businesslicence -- 营业执照号码
            ,payaccountcertid -- 绑定身份证号
            ,recordrelativeserialno -- 关联中介备案编号
            ,telephone -- 手机号
            ,isbigaccountmode -- 是否大账户模式
            ,channelno -- 渠道编号
            ,buildingcompany -- 建筑单位
            ,housinglevel -- 房屋等级
            ,startbankno -- 初始卡开户行
            ,financialbond -- 委放/专项/金融债
            ,insurername -- 保险公司名称
            ,fitmentprice -- 装修总价
            ,repaymentaccname -- 还款账户名称
            ,endclearbankno -- 收款方开户行清算行行号（最终）
            ,presalepermitno -- 预售许可证编号
            ,extenddays -- 宽限天数
            ,isonline -- 是否线上审批
            ,propertyarea -- 所购房产面积
            ,evaluationname -- 评估机构名称
            ,suitesarea -- 购房面积（套内面积）
            ,payaccounttel -- 开户手机
            ,evaluationcertid -- 评估机构证件号码
            ,mandatedepositcurrency -- 委托存款币种
            ,exposeclassifyresult -- 风险暴露分类结果
            ,fundsprovided -- 资金来源
            ,principalcertid -- 委托人有效证件号码
            ,endaccountno -- 最终绑定卡卡号
            ,principalmarriage -- 委托人婚姻状况
            ,isbusinessguarantee -- 是否合作机构/开发商/经销商担保
            ,isvendorassumeliability -- 是否销售商承担回购责任
            ,groupcustname -- 集团客户名称
            ,housingaddress -- 房屋详址
            ,payaccounttype -- 还款卡类型0-本行卡,1-他行卡
            ,personalbusinessloanstype -- 个人经营性贷款分类
            ,evaluationcerttype -- 评估证件类型
            ,discountratio -- 贴息比例
            ,corporgid -- 法人机构编号
            ,iscompanycustomer -- 是否公司额度管控
            ,enterprisecode -- 经销商企业代码
            ,companycustomername -- 公司客户名称
            ,housingform -- 房屋形式
            ,paymentbasis -- 首付款依据
            ,feesum -- 手续费金额
            ,isgroupcustomer -- 是否集团客户
            ,isloananytime -- 是否随借随还
            ,sellername -- 卖房人名称
            ,businessclass -- 类别
            ,principalname -- 委托人名称
            ,creditincrmode -- 增信模式标志
            ,loandirection -- 资金投向
            ,insurancevariety -- 保险品种
            ,buildingarea -- 购房面积（建筑面积）
            ,repaydatetype -- 还款日确定
            ,feepayment -- 手续费支付方式
            ,repaymentaccount -- 还款账号
            ,evaluateprice -- 评估价格
            ,propertyunitprice -- 物管费单价
            ,availexposure -- 集团客户可用敞口额度
            ,endbankno -- 最终实体卡对应的开户行
            ,companyrelation -- 借款人与公司关系
            ,propertytype -- 所购房产类型
            ,endbankname -- 最终实体卡对应的开户行名称
            ,isjgaccount -- 是否在我行开立监管账户
            ,vehicletype -- 车型
            ,startaccountno -- 初始卡卡号
            ,startclearbankno -- 收款方开户行清算行行号（最初）
            ,vehicleprice -- 汽车总价
            ,insurance -- 保险金额
            ,wthruselmt -- 是否使用额度
            ,mandateriskclassify -- 委托贷款风险分类
            ,propertycertid -- 房屋权证号
            ,loanaccountno -- 入账账号
            ,startbankname -- 初始卡开户行名称
            ,determprice -- 认定价格
            ,paymenttype -- 支付方式
            ,companycustomerid -- 公司客户号
            ,propertycontractno -- 车位配套住房产权号/购房合同号
            ,clientno -- 委托人编号
            ,startaccountname -- 初始卡账户名称
            ,commodityamt -- 购买金额
            ,businesscertcode -- 统一社会信用代码
            ,payway -- 贷款发放方式(1-一次2-分次)
            ,dealdisputeway -- 解决争议方式(1-甲方所在地人民法院2-仲裁委员会3-天河区人民法院4-其他)
            ,dealdisputetxt -- 解决争议方式备注
            ,isforcedeal -- 是否强制执行公证(1-是2-否)
            ,bigloanpurpose -- 贷款用途大类
            ,zjkjstatus -- 致景科技合同激活状态 0-未激活 1-待激活 2-已激活
            ,cartype -- 车辆类型
            ,greenloanpurpose -- 绿色贷款用途
            ,accountserialno -- 关联账户流水号
            ,subgreenconsumeloanpurpose -- 绿色消费子类
            ,isagriculture -- 是否涉农
            ,highindustry -- 高技术产业
            ,economyindustry -- 数字经济核心产业
            ,intellectualindustry -- 投向知识产权密集型产业
            ,strategicindustry -- 
            ,cultureindustry -- 投向文化及相关产业
            ,isnewcoborrower -- 
            ,productchannel -- 
            ,claimperson -- 
            ,isclaim -- 
            ,isbelongterm -- 
            ,centralizeorgid -- 
            ,centralizeoperaid -- 
            ,claimdate -- 
			,' ' as extloanaccountno -- 行外收款银行卡号
            ,' ' as extloanaccountname -- 行外收款卡户名
            ,' ' as recvbankid -- 收款银行编号
            ,' ' as recvbankname -- 收款银行名称
            ,' ' as extrepaymentaccount -- 行外还款银行卡号
            ,' ' as extrepaymentaccname -- 行外还款卡户名
            ,' ' as repaybankid -- 还款银行编号
            ,' ' as repaybankname -- 还款银行名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BC_PERSONAL_LOAN_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
