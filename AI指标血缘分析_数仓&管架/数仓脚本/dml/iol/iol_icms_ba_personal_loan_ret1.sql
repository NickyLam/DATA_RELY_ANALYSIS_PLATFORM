/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BA_PERSONAL_LOAN_ret1
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
                       FROM ICMS_BA_PERSONAL_LOAN_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BA_PERSONAL_LOAN');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BA_PERSONAL_LOAN drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BA_PERSONAL_LOAN add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BA_PERSONAL_LOAN(
            serialno -- 流水号
            ,usccno -- 统一社会信用码
            ,flowflag -- 流程标记0业务申请1业务审批2出账申请3出账审批4待放款5放款6还款中7已结清,9已拒绝11-借呗初审12-借呗终审
            ,isdiscount -- 是否行内贴息/贴息标识
            ,authinfo -- 授权信息(JSON格式:授权类别,授权名称)
            ,groupavailexposure -- 集团客户可用敞口额度
            ,othercontsigndate -- 挂靠或租赁协议签订日期
            ,companybusinesssum -- 公司授信总金额
            ,parkingarea -- 购车位面积
            ,certid -- 借款人证件号码
            ,isfirstpurchase -- 是否首次购房
            ,downpayment -- 首付金额
            ,paybankname -- 收款人行名
            ,sellercertid -- 卖房人证件号码
            ,mandaterequirement -- 委托条件
            ,buildingcompany -- 建筑单位
            ,cuscomrelation -- 借款人与公司关系
            ,insurance -- 保险金额
            ,loanaccountclearbank -- 入账账户清算行行号
            ,feesum -- 手续费金额
            ,yxserno -- 影像流水号
            ,discountratio -- 贴息比例
            ,mandatedepositcurrency -- 委托存款币种
            ,determprice -- 认定价格
            ,evaluationname -- 评估机构名称
            ,onlineapproveresult -- 线上审批结果
            ,applycustype -- 申请人其他类型
            ,iswhite -- 是否白户
            ,mandatedepositaccounts -- 委托贷款存款账号
            ,passtime -- 审批通过时间
            ,repaymentdatetype -- 还款日确定
            ,businesslicence -- 营业执照号码
            ,presalepermitno -- 预售许可证编号
            ,guaranteeagreement -- 相关回购/担保协议书编号
            ,isgroupcustomer -- 是否集团客户
            ,returncapitalinterval -- 归还本金间隔
            ,insuranceperiod -- 保险期限
            ,insurername -- 保险公司名称
            ,stallprice -- 车位总价
            ,iscancel -- 是否撤销
            ,returncapitalratio -- 归还本金比例
            ,purchasecontractid -- 购房合同号
            ,recordrelativeserialno -- 关联中介备案编号
            ,groupcustomerid -- 集团客户号
            ,relserialno -- 关联流水号
            ,guarantytype -- 担保类型
            ,companyname -- 公司客户名称
            ,isthreemonthnewcar -- 是否三个月内上牌新车
            ,isonline -- 是否线上审批
            ,housingprice -- 房屋总价
            ,propertycontractno -- 车位配套住房产权号/购房合同号
            ,esaepclassify -- 节能环保分类
            ,businessname -- 商家/销售商/开发商/建房单位名称
            ,enddate -- 审批结束时间
            ,telephone -- 借款人手机号码
            ,evaluateprice -- 评估价格
            ,imageupflag -- 影像上传结果1完成上传2未完成上传
            ,phreceivableam -- 平安普惠收款金额
            ,suggestsum -- 建议贷款金额(元)
            ,authtelephone -- 绑卡鉴权手机号
            ,isimage -- 是否引入影像
            ,payeename -- 收款人名称
            ,parkingaddress -- 购车位详址
            ,applyaddr -- 申请地点
            ,isvendorassumeliability -- 是否销售商承担回购责任
            ,sellername -- 卖房人名称
            ,informflag -- 申请结果是否通知成功
            ,loanratio -- 贷款成数
            ,vehiclecontractno -- 购车合同号
            ,balloonamortenddate -- 气球贷摊销到期日
            ,investoinon -- 调查人意见
            ,otherloancontractno -- 借款合同编号
            ,mandatedepositsum -- 委托存款金额
            ,propertycertid -- 房屋权证号
            ,evaluationcertid -- 评估机构证件号码
            ,contimageupflag -- 借款合同影像上传结果1完成上传2未完成上传
            ,payeeaccounttel -- 开户b绑定手机号
            ,suitesunitprice -- 套房面积单价
            ,mandateriskclassify -- 委托贷款风险分类
            ,financialbond -- 委放/专项/金融债
            ,propertyarea -- 所购房产面积
            ,applyamt -- 申请额度
            ,insurancevariety -- 保险品种
            ,isback -- 客户是否捞回
            ,resetamt -- 重置额度
            ,housingname -- 楼盘名称
            ,channelcode -- 渠道来源
            ,enterprisecode -- 经销商企业代码
            ,propertytype -- 所购房产类型
            ,excess -- 免赔率
            ,isbankrel -- 是否与我行存在关联关系
            ,ischeckcreditreport -- 征信两岗是否点击了查看征信报告按钮:1是，0否
            ,housingsum -- 房屋套数
            ,businessclass -- 类别
            ,purpose -- 用途
            ,checkresult -- 校验结果
            ,insurflag -- 是否有保险
            ,insurancecontractno -- 保险合同编号
            ,isexception -- 是否例外额度
            ,startdate -- 审批开始时间
            ,callbackurl -- 普惠签约回调地址
            ,finalresult -- 最终风控结果-移动展业赎楼贷
            ,housingform -- 房屋形式
            ,fitmentprice -- 装修总价
            ,repayinterval -- 归还本金间隔
            ,indtype -- 客户性质
            ,taxcode -- 纳税人识别号
            ,buildingunitprice -- 建筑面积单价
            ,vehicletype -- 车型
            ,availexposure -- 集团客户名称
            ,companyid -- 公司客户编号
            ,graceperiod -- 宽限期（天）
            ,personalbusinessloanstype -- 个人经营性贷款分类
            ,isloananytime -- 是否随借随还
            ,housingaddress -- 房屋详址
            ,repayratio -- 归还本金比例
            ,signaddr -- 签署地
            ,evaluationcerttype -- 评估证件类型
            ,paymentobject -- 支付对象
            ,certtype -- 借款人证件类型
            ,relycompanyname -- 自家/挂靠企业名称
            ,paymenttype -- 支付方式
            ,feepayment -- 手续费支付方式
            ,paymentbasis -- 首付款依据
            ,propertyunitprice -- 物管费单价
            ,compcertid -- 企业证件号码
            ,groupcustcode -- 是否集团客户
            ,payeeaccountno -- 收款人帐号
            ,isinsurance -- 是否购买保险
            ,isopenentsettleaccounts -- 是否能够开立单位结算账户
            ,compcerttype -- 企业证件类型
            ,vehicleprice -- 汽车总价
            ,housinglevel -- 房屋等级
            ,isbusinessguarantee -- 是否合作机构/开发商/经销商担保
            ,localstrategicindustry -- 本地战略性新兴产业
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,cusgruoprelation -- 借款人与集团关系
            ,corporgid -- 法人机构编号
            ,relycompanycreditno -- 自家/挂靠企业统一社会信用代码
            ,baserateadjustper -- 基准利率上浮比例
            ,feeratio -- 手续费率
            ,companyquotacontrol -- 是否公司额度管控
            ,suitesarea -- 购房面积（套内面积）
            ,isaddamt -- 是否提额
            ,groupcustname -- 集团客户号
            ,buildingarea -- 购房面积（建筑面积）
            ,creditscore -- 机评信用等级
            ,remark -- 备注
            ,paymentratio -- 首付比例
            ,loandirection -- 资金投向
            ,groupcustomername -- 集团客户名称
            ,isjgaccount -- 是否在我行开立监管账户
            ,creditimageupflag -- 征信授权书影像上传结果1完成上传2未完成上传
            ,creditincrmode -- 增信模式标志
            ,referrerid -- 推荐人ID
            ,iswthrmanuactclmt -- 是否人工激活额度YesNo
            ,recheckflag -- 复核标识YesNo
            ,consignerid -- 委托人ID
            ,ishouseinguangdong -- 委托人ID
            ,worktype -- 委托人ID
            ,bigloanpurpose -- 贷款用途大类
            ,title -- 标题
            ,riskcontrolback -- 风控背景
            ,cuscreditscore -- 客户信用分数:内评
            ,cuscreditscorelevel -- 客户信用分数等级
            ,cartype -- 车辆类型
            ,greenloanpurpose -- 绿色贷款用途
            ,companytype -- 企业规模
            ,employments -- 从业人员
            ,busiincome -- 营业收入
            ,assetstotal -- 资产总额
            ,industry -- 所属行业
            ,custcreditlevel -- 客户风险等级
            ,loanpurposedetails -- 贷款用途细类字段
            ,highindustry -- 高技术产业
            ,economyindustry -- 数字经济核心产业
            ,intellectualindustry -- 投向知识产权密集型产业
            ,cultureindustry -- 投向文化及相关产业
            ,isagriculture -- 是否涉农
            ,strategicindustry -- 
            ,custlabel -- 
            ,warninginfo -- 
            ,subgreenconsumeloanpurpose -- 
            ,isoperatingentinvolvespecialized -- 
            ,ishightechnologyent -- 
            ,istechnologyent -- 
            ,isscientifictechent -- 
            ,isspecializedgiantent -- 
            ,isspecializedsmallandmident -- 
            ,istechnologysmallandmident -- 
            ,isindustrysinglechampionent -- 
            ,isnationaltechnologinnovationent -- 
            ,isgarden -- 
            ,productchannel -- 
            ,iscentralizedofficestaff -- 
            ,cobsratio -- 
            ,workingmonth -- 
            ,flowbranchtype -- 
            ,isicmsfactory -- 
            ,guaranteecompanyname -- 
            ,runentyearincome -- 
            ,lastyearentyearincome -- 
            ,yearincomerate -- 
            ,operationloanbalanceskr -- 
            ,otherworkcaptial -- 
            ,isrelatedcompany -- 
            ,intentguaramt -- 
            ,guarcompanyterm -- 
            ,comptaxgrade -- 
            ,iscompanyrelatedperson -- 
            ,recommendedamt -- 
            ,recommendedterm -- 
            ,otherlimitflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,usccno -- 统一社会信用码
            ,flowflag -- 流程标记0业务申请1业务审批2出账申请3出账审批4待放款5放款6还款中7已结清,9已拒绝11-借呗初审12-借呗终审
            ,isdiscount -- 是否行内贴息/贴息标识
            ,authinfo -- 授权信息(JSON格式:授权类别,授权名称)
            ,groupavailexposure -- 集团客户可用敞口额度
            ,othercontsigndate -- 挂靠或租赁协议签订日期
            ,companybusinesssum -- 公司授信总金额
            ,parkingarea -- 购车位面积
            ,certid -- 借款人证件号码
            ,isfirstpurchase -- 是否首次购房
            ,downpayment -- 首付金额
            ,paybankname -- 收款人行名
            ,sellercertid -- 卖房人证件号码
            ,mandaterequirement -- 委托条件
            ,buildingcompany -- 建筑单位
            ,cuscomrelation -- 借款人与公司关系
            ,insurance -- 保险金额
            ,loanaccountclearbank -- 入账账户清算行行号
            ,feesum -- 手续费金额
            ,yxserno -- 影像流水号
            ,discountratio -- 贴息比例
            ,mandatedepositcurrency -- 委托存款币种
            ,determprice -- 认定价格
            ,evaluationname -- 评估机构名称
            ,onlineapproveresult -- 线上审批结果
            ,applycustype -- 申请人其他类型
            ,iswhite -- 是否白户
            ,mandatedepositaccounts -- 委托贷款存款账号
            ,passtime -- 审批通过时间
            ,repaymentdatetype -- 还款日确定
            ,businesslicence -- 营业执照号码
            ,presalepermitno -- 预售许可证编号
            ,guaranteeagreement -- 相关回购/担保协议书编号
            ,isgroupcustomer -- 是否集团客户
            ,returncapitalinterval -- 归还本金间隔
            ,insuranceperiod -- 保险期限
            ,insurername -- 保险公司名称
            ,stallprice -- 车位总价
            ,iscancel -- 是否撤销
            ,returncapitalratio -- 归还本金比例
            ,purchasecontractid -- 购房合同号
            ,recordrelativeserialno -- 关联中介备案编号
            ,groupcustomerid -- 集团客户号
            ,relserialno -- 关联流水号
            ,guarantytype -- 担保类型
            ,companyname -- 公司客户名称
            ,isthreemonthnewcar -- 是否三个月内上牌新车
            ,isonline -- 是否线上审批
            ,housingprice -- 房屋总价
            ,propertycontractno -- 车位配套住房产权号/购房合同号
            ,esaepclassify -- 节能环保分类
            ,businessname -- 商家/销售商/开发商/建房单位名称
            ,enddate -- 审批结束时间
            ,telephone -- 借款人手机号码
            ,evaluateprice -- 评估价格
            ,imageupflag -- 影像上传结果1完成上传2未完成上传
            ,phreceivableam -- 平安普惠收款金额
            ,suggestsum -- 建议贷款金额(元)
            ,authtelephone -- 绑卡鉴权手机号
            ,isimage -- 是否引入影像
            ,payeename -- 收款人名称
            ,parkingaddress -- 购车位详址
            ,applyaddr -- 申请地点
            ,isvendorassumeliability -- 是否销售商承担回购责任
            ,sellername -- 卖房人名称
            ,informflag -- 申请结果是否通知成功
            ,loanratio -- 贷款成数
            ,vehiclecontractno -- 购车合同号
            ,balloonamortenddate -- 气球贷摊销到期日
            ,investoinon -- 调查人意见
            ,otherloancontractno -- 借款合同编号
            ,mandatedepositsum -- 委托存款金额
            ,propertycertid -- 房屋权证号
            ,evaluationcertid -- 评估机构证件号码
            ,contimageupflag -- 借款合同影像上传结果1完成上传2未完成上传
            ,payeeaccounttel -- 开户b绑定手机号
            ,suitesunitprice -- 套房面积单价
            ,mandateriskclassify -- 委托贷款风险分类
            ,financialbond -- 委放/专项/金融债
            ,propertyarea -- 所购房产面积
            ,applyamt -- 申请额度
            ,insurancevariety -- 保险品种
            ,isback -- 客户是否捞回
            ,resetamt -- 重置额度
            ,housingname -- 楼盘名称
            ,channelcode -- 渠道来源
            ,enterprisecode -- 经销商企业代码
            ,propertytype -- 所购房产类型
            ,excess -- 免赔率
            ,isbankrel -- 是否与我行存在关联关系
            ,ischeckcreditreport -- 征信两岗是否点击了查看征信报告按钮:1是，0否
            ,housingsum -- 房屋套数
            ,businessclass -- 类别
            ,purpose -- 用途
            ,checkresult -- 校验结果
            ,insurflag -- 是否有保险
            ,insurancecontractno -- 保险合同编号
            ,isexception -- 是否例外额度
            ,startdate -- 审批开始时间
            ,callbackurl -- 普惠签约回调地址
            ,finalresult -- 最终风控结果-移动展业赎楼贷
            ,housingform -- 房屋形式
            ,fitmentprice -- 装修总价
            ,repayinterval -- 归还本金间隔
            ,indtype -- 客户性质
            ,taxcode -- 纳税人识别号
            ,buildingunitprice -- 建筑面积单价
            ,vehicletype -- 车型
            ,availexposure -- 集团客户名称
            ,companyid -- 公司客户编号
            ,graceperiod -- 宽限期（天）
            ,personalbusinessloanstype -- 个人经营性贷款分类
            ,isloananytime -- 是否随借随还
            ,housingaddress -- 房屋详址
            ,repayratio -- 归还本金比例
            ,signaddr -- 签署地
            ,evaluationcerttype -- 评估证件类型
            ,paymentobject -- 支付对象
            ,certtype -- 借款人证件类型
            ,relycompanyname -- 自家/挂靠企业名称
            ,paymenttype -- 支付方式
            ,feepayment -- 手续费支付方式
            ,paymentbasis -- 首付款依据
            ,propertyunitprice -- 物管费单价
            ,compcertid -- 企业证件号码
            ,groupcustcode -- 是否集团客户
            ,payeeaccountno -- 收款人帐号
            ,isinsurance -- 是否购买保险
            ,isopenentsettleaccounts -- 是否能够开立单位结算账户
            ,compcerttype -- 企业证件类型
            ,vehicleprice -- 汽车总价
            ,housinglevel -- 房屋等级
            ,isbusinessguarantee -- 是否合作机构/开发商/经销商担保
            ,localstrategicindustry -- 本地战略性新兴产业
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,cusgruoprelation -- 借款人与集团关系
            ,corporgid -- 法人机构编号
            ,relycompanycreditno -- 自家/挂靠企业统一社会信用代码
            ,baserateadjustper -- 基准利率上浮比例
            ,feeratio -- 手续费率
            ,companyquotacontrol -- 是否公司额度管控
            ,suitesarea -- 购房面积（套内面积）
            ,isaddamt -- 是否提额
            ,groupcustname -- 集团客户号
            ,buildingarea -- 购房面积（建筑面积）
            ,creditscore -- 机评信用等级
            ,remark -- 备注
            ,paymentratio -- 首付比例
            ,loandirection -- 资金投向
            ,groupcustomername -- 集团客户名称
            ,isjgaccount -- 是否在我行开立监管账户
            ,creditimageupflag -- 征信授权书影像上传结果1完成上传2未完成上传
            ,creditincrmode -- 增信模式标志
            ,referrerid -- 推荐人ID
            ,iswthrmanuactclmt -- 是否人工激活额度YesNo
            ,recheckflag -- 复核标识YesNo
            ,consignerid -- 委托人ID
            ,ishouseinguangdong -- 委托人ID
            ,worktype -- 委托人ID
            ,bigloanpurpose -- 贷款用途大类
            ,title -- 标题
            ,riskcontrolback -- 风控背景
            ,cuscreditscore -- 客户信用分数:内评
            ,cuscreditscorelevel -- 客户信用分数等级
            ,cartype -- 车辆类型
            ,greenloanpurpose -- 绿色贷款用途
            ,companytype -- 企业规模
            ,employments -- 从业人员
            ,busiincome -- 营业收入
            ,assetstotal -- 资产总额
            ,industry -- 所属行业
            ,custcreditlevel -- 客户风险等级
            ,loanpurposedetails -- 贷款用途细类字段
            ,highindustry -- 高技术产业
            ,economyindustry -- 数字经济核心产业
            ,intellectualindustry -- 投向知识产权密集型产业
            ,cultureindustry -- 投向文化及相关产业
            ,isagriculture -- 是否涉农
            ,' ' AS strategicindustry -- 
            ,' ' AS custlabel -- 
            ,' ' AS warninginfo -- 
            ,' ' AS subgreenconsumeloanpurpose -- 
            ,' ' AS isoperatingentinvolvespecialized -- 
            ,' ' AS ishightechnologyent -- 
            ,' ' AS istechnologyent -- 
            ,' ' AS isscientifictechent -- 
            ,' ' AS isspecializedgiantent -- 
            ,' ' AS isspecializedsmallandmident -- 
            ,' ' AS istechnologysmallandmident -- 
            ,' ' AS isindustrysinglechampionent -- 
            ,' ' AS isnationaltechnologinnovationent -- 
            ,' ' AS isgarden -- 
            ,' ' AS productchannel -- 
            ,' ' AS iscentralizedofficestaff -- 
            ,0 AS cobsratio -- 
            ,0 AS workingmonth -- 
            ,' ' AS flowbranchtype -- 
            ,' ' AS isicmsfactory -- 
            ,' ' AS guaranteecompanyname -- 
            ,0 AS runentyearincome -- 
            ,0 AS lastyearentyearincome -- 
            ,0 AS yearincomerate -- 
            ,0 AS operationloanbalanceskr -- 
            ,0 AS otherworkcaptial -- 
            ,' ' AS isrelatedcompany -- 
            ,0 AS intentguaramt -- 
            ,0 AS guarcompanyterm -- 
            ,' ' AS comptaxgrade -- 
            ,' ' AS iscompanyrelatedperson -- 
            ,0 AS recommendedamt -- 
            ,0 AS recommendedterm -- 
            ,' ' AS otherlimitflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BA_PERSONAL_LOAN_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
