/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BAP_PERSONAL_LOAN_ret1
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
                       FROM ICMS_BAP_PERSONAL_LOAN_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BAP_PERSONAL_LOAN');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BAP_PERSONAL_LOAN drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BAP_PERSONAL_LOAN add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BAP_PERSONAL_LOAN(
            serialno -- 流水号
            ,isinsurance -- 是否购买保险
            ,groupcustomerid -- 集团客户号
            ,isjgaccount -- 是否在我行开立监管账户
            ,propertytype -- 所购房产类型
            ,insuranceperiod -- 保险期限
            ,balloonamortenddate -- 气球贷摊销到期日
            ,creditimageupflag -- 征信授权书影像上传结果1完成上传2未完成上传
            ,housingform -- 房屋形式
            ,isexception -- 是否例外额度
            ,companyquotacontrol -- 是否公司额度管控
            ,authinfo -- 授权信息(JSON格式:授权类别,授权名称)
            ,enterprisecode -- 经销商企业代码
            ,finalresult -- 最终风控结果-移动展业赎楼贷
            ,relserialno -- 关联流水号
            ,returncapitalinterval -- 归还本金间隔
            ,contimageupflag -- 借款合同影像上传结果1完成上传2未完成上传
            ,businesslicence -- 营业执照号码
            ,isimage -- 是否引入影像
            ,corporgid -- 法人机构编号
            ,groupcustomername -- 集团客户名称
            ,relycompanycreditno -- 自家/挂靠企业统一社会信用代码
            ,purchasecontractid -- 购房合同号
            ,phreceivableam -- 平安普惠收款金额
            ,mandateriskclassify -- 委托贷款风险分类
            ,indtype -- 客户性质
            ,paymentobject -- 支付对象
            ,vehicletype -- 车型
            ,feeratio -- 手续费率
            ,returncapitalratio -- 归还本金比例
            ,companybusinesssum -- 公司授信总金额
            ,repaymentdatetype -- 还款日确定
            ,resetamt -- 重置额度
            ,mandatedepositcurrency -- 委托存款币种
            ,housingprice -- 房屋总价
            ,buildingarea -- 购房面积（建筑面积）
            ,applycustype -- 申请人其他类型
            ,isvendorassumeliability -- 是否销售商承担回购责任
            ,evaluationcerttype -- 评估证件类型
            ,flowflag -- 流程标记
            ,passtime -- 审批通过时间
            ,iswhite -- 是否白户
            ,suggestsum -- 建议贷款金额(元)
            ,applyamt -- 申请额度
            ,onlineapproveresult -- 线上审批结果
            ,companyname -- 企业名称
            ,fitmentprice -- 装修总价
            ,propertycontractno -- 车位配套住房产权号/购房合同号
            ,esaepclassify -- 节能环保分类
            ,repayratio -- 归还本金比例
            ,suitesarea -- 购房面积（套内面积）
            ,businessclass -- 类别
            ,cusgruoprelation -- 借款人与集团关系
            ,insurance -- 保险金额
            ,sellername -- 卖房人名称
            ,buildingcompany -- 建筑单位
            ,presalepermitno -- 预售许可证编号
            ,propertyarea -- 所购房产面积
            ,isopenentsettleaccounts -- 是否能够开立单位结算账户
            ,isaddamt -- 是否提额
            ,suitesunitprice -- 套房面积单价
            ,evaluationcertid -- 评估机构证件号码
            ,vehiclecontractno -- 购车合同号
            ,determprice -- 认定价格
            ,propertyunitprice -- 物管费单价
            ,insurancecontractno -- 保险合同编号
            ,isthreemonthnewcar -- 是否三个月内上牌新车
            ,propertycertid -- 房屋权证号
            ,applyaddr -- 申请地点
            ,signaddr -- 签署地
            ,insurancevariety -- 保险品种
            ,mandatedepositsum -- 委托存款金额
            ,payeeaccountno -- 收款人帐号
            ,informflag -- 申请结果是否通知成功
            ,payeeaccounttel -- 开户b绑定手机号
            ,housingaddress -- 房屋详址
            ,companyid -- 公司客户编号
            ,isloananytime -- 是否随借随还
            ,purpose -- 用途
            ,startdate -- 审批开始时间
            ,isfirstpurchase -- 是否首次购房
            ,groupavailexposure -- 集团客户可用敞口额度
            ,isbusinessguarantee -- 是否合作机构/开发商/经销商担保
            ,guarantytype -- 担保类型
            ,discountratio -- 贴息比例
            ,enddate -- 审批结束时间
            ,certid -- 借款人证件号码
            ,baserateadjustper -- 基准利率上浮比例
            ,housinglevel -- 房屋等级
            ,paymentratio -- 首付比例
            ,otherloancontractno -- 借款合同编号
            ,isonline -- 是否线上审批
            ,mandatedepositaccounts -- 委托贷款存款账号
            ,ischeckcreditreport -- 征信两岗是否点击了查看征信报告按钮:1是，0否
            ,imageupflag -- 影像上传结果1完成上传2未完成上传
            ,usccno -- 统一社会信用码
            ,businessname -- 商家/销售商/开发商/建房单位名称
            ,feesum -- 手续费金额
            ,stallprice -- 车位总价
            ,loanratio -- 贷款成数
            ,loandirection -- 资金投向
            ,housingsum -- 房屋套数
            ,downpayment -- 首付金额
            ,paymentbasis -- 首付款依据
            ,yxserno -- 影像流水号
            ,mandaterequirement -- 委托条件
            ,creditincrmode -- 增信模式标志
            ,channelcode -- 渠道来源
            ,isback -- 客户是否捞回
            ,relycompanyname -- 自家/挂靠企业名称
            ,vehicleprice -- 汽车总价
            ,checkresult -- 校验结果
            ,authtelephone -- 绑卡鉴权手机号
            ,certtype -- 借款人证件类型
            ,othercontsigndate -- 挂靠或租赁协议签订日期
            ,taxcode -- 纳税人识别号
            ,evaluationname -- 评估机构名称
            ,parkingarea -- 购车位面积
            ,telephone -- 借款人手机号码
            ,compcertid -- 企业证件号码
            ,evaluateprice -- 评估价格
            ,recordrelativeserialno -- 关联中介备案编号
            ,creditscore -- 机评信用等级
            ,remark -- 备注
            ,guaranteeagreement -- 相关回购/担保协议书编号
            ,feepayment -- 手续费支付方式
            ,paymenttype -- 支付方式
            ,housingname -- 楼盘名称
            ,personalbusinessloanstype -- 个人经营性贷款分类
            ,payeename -- 收款人名称
            ,investoinon -- 调查人意见
            ,isbankrel -- 是否与我行存在关联关系
            ,insurername -- 保险公司名称
            ,paybankname -- 收款人行名
            ,sellercertid -- 卖房人证件号码
            ,buildingunitprice -- 建筑面积单价
            ,repayinterval -- 归还本金间隔
            ,graceperiod -- 宽限期（天）
            ,isgroupcustomer -- 是否集团客户
            ,iscancel -- 是否撤销
            ,insurflag -- INSUR_Y:有保险,INSUR_N：无保险
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,callbackurl -- 普惠签约回调地址
            ,loanaccountclearbank -- 入账账户清算行行号
            ,financialbond -- 委放/专项/金融债
            ,localstrategicindustry -- 本地战略性新兴产业
            ,compcerttype -- 企业证件类型
            ,excess -- 免赔率
            ,parkingaddress -- 购车位详址
            ,cuscomrelation -- 借款人与公司关系
            ,isdiscount -- 是否行内贴息/贴息标识
            ,bigloanpurpose -- 贷款用途大类
            ,title -- 标题
            ,riskcontrolback -- 风控背景
            ,cartype -- 车辆类型
            ,greenloanpurpose -- 绿色贷款用途
            ,subgreenconsumeloanpurpose -- 
            ,productchannel -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,isinsurance -- 是否购买保险
            ,groupcustomerid -- 集团客户号
            ,isjgaccount -- 是否在我行开立监管账户
            ,propertytype -- 所购房产类型
            ,insuranceperiod -- 保险期限
            ,balloonamortenddate -- 气球贷摊销到期日
            ,creditimageupflag -- 征信授权书影像上传结果1完成上传2未完成上传
            ,housingform -- 房屋形式
            ,isexception -- 是否例外额度
            ,companyquotacontrol -- 是否公司额度管控
            ,authinfo -- 授权信息(JSON格式:授权类别,授权名称)
            ,enterprisecode -- 经销商企业代码
            ,finalresult -- 最终风控结果-移动展业赎楼贷
            ,relserialno -- 关联流水号
            ,returncapitalinterval -- 归还本金间隔
            ,contimageupflag -- 借款合同影像上传结果1完成上传2未完成上传
            ,businesslicence -- 营业执照号码
            ,isimage -- 是否引入影像
            ,corporgid -- 法人机构编号
            ,groupcustomername -- 集团客户名称
            ,relycompanycreditno -- 自家/挂靠企业统一社会信用代码
            ,purchasecontractid -- 购房合同号
            ,phreceivableam -- 平安普惠收款金额
            ,mandateriskclassify -- 委托贷款风险分类
            ,indtype -- 客户性质
            ,paymentobject -- 支付对象
            ,vehicletype -- 车型
            ,feeratio -- 手续费率
            ,returncapitalratio -- 归还本金比例
            ,companybusinesssum -- 公司授信总金额
            ,repaymentdatetype -- 还款日确定
            ,resetamt -- 重置额度
            ,mandatedepositcurrency -- 委托存款币种
            ,housingprice -- 房屋总价
            ,buildingarea -- 购房面积（建筑面积）
            ,applycustype -- 申请人其他类型
            ,isvendorassumeliability -- 是否销售商承担回购责任
            ,evaluationcerttype -- 评估证件类型
            ,flowflag -- 流程标记
            ,passtime -- 审批通过时间
            ,iswhite -- 是否白户
            ,suggestsum -- 建议贷款金额(元)
            ,applyamt -- 申请额度
            ,onlineapproveresult -- 线上审批结果
            ,companyname -- 企业名称
            ,fitmentprice -- 装修总价
            ,propertycontractno -- 车位配套住房产权号/购房合同号
            ,esaepclassify -- 节能环保分类
            ,repayratio -- 归还本金比例
            ,suitesarea -- 购房面积（套内面积）
            ,businessclass -- 类别
            ,cusgruoprelation -- 借款人与集团关系
            ,insurance -- 保险金额
            ,sellername -- 卖房人名称
            ,buildingcompany -- 建筑单位
            ,presalepermitno -- 预售许可证编号
            ,propertyarea -- 所购房产面积
            ,isopenentsettleaccounts -- 是否能够开立单位结算账户
            ,isaddamt -- 是否提额
            ,suitesunitprice -- 套房面积单价
            ,evaluationcertid -- 评估机构证件号码
            ,vehiclecontractno -- 购车合同号
            ,determprice -- 认定价格
            ,propertyunitprice -- 物管费单价
            ,insurancecontractno -- 保险合同编号
            ,isthreemonthnewcar -- 是否三个月内上牌新车
            ,propertycertid -- 房屋权证号
            ,applyaddr -- 申请地点
            ,signaddr -- 签署地
            ,insurancevariety -- 保险品种
            ,mandatedepositsum -- 委托存款金额
            ,payeeaccountno -- 收款人帐号
            ,informflag -- 申请结果是否通知成功
            ,payeeaccounttel -- 开户b绑定手机号
            ,housingaddress -- 房屋详址
            ,companyid -- 公司客户编号
            ,isloananytime -- 是否随借随还
            ,purpose -- 用途
            ,startdate -- 审批开始时间
            ,isfirstpurchase -- 是否首次购房
            ,groupavailexposure -- 集团客户可用敞口额度
            ,isbusinessguarantee -- 是否合作机构/开发商/经销商担保
            ,guarantytype -- 担保类型
            ,discountratio -- 贴息比例
            ,enddate -- 审批结束时间
            ,certid -- 借款人证件号码
            ,baserateadjustper -- 基准利率上浮比例
            ,housinglevel -- 房屋等级
            ,paymentratio -- 首付比例
            ,otherloancontractno -- 借款合同编号
            ,isonline -- 是否线上审批
            ,mandatedepositaccounts -- 委托贷款存款账号
            ,ischeckcreditreport -- 征信两岗是否点击了查看征信报告按钮:1是，0否
            ,imageupflag -- 影像上传结果1完成上传2未完成上传
            ,usccno -- 统一社会信用码
            ,businessname -- 商家/销售商/开发商/建房单位名称
            ,feesum -- 手续费金额
            ,stallprice -- 车位总价
            ,loanratio -- 贷款成数
            ,loandirection -- 资金投向
            ,housingsum -- 房屋套数
            ,downpayment -- 首付金额
            ,paymentbasis -- 首付款依据
            ,yxserno -- 影像流水号
            ,mandaterequirement -- 委托条件
            ,creditincrmode -- 增信模式标志
            ,channelcode -- 渠道来源
            ,isback -- 客户是否捞回
            ,relycompanyname -- 自家/挂靠企业名称
            ,vehicleprice -- 汽车总价
            ,checkresult -- 校验结果
            ,authtelephone -- 绑卡鉴权手机号
            ,certtype -- 借款人证件类型
            ,othercontsigndate -- 挂靠或租赁协议签订日期
            ,taxcode -- 纳税人识别号
            ,evaluationname -- 评估机构名称
            ,parkingarea -- 购车位面积
            ,telephone -- 借款人手机号码
            ,compcertid -- 企业证件号码
            ,evaluateprice -- 评估价格
            ,recordrelativeserialno -- 关联中介备案编号
            ,creditscore -- 机评信用等级
            ,remark -- 备注
            ,guaranteeagreement -- 相关回购/担保协议书编号
            ,feepayment -- 手续费支付方式
            ,paymenttype -- 支付方式
            ,housingname -- 楼盘名称
            ,personalbusinessloanstype -- 个人经营性贷款分类
            ,payeename -- 收款人名称
            ,investoinon -- 调查人意见
            ,isbankrel -- 是否与我行存在关联关系
            ,insurername -- 保险公司名称
            ,paybankname -- 收款人行名
            ,sellercertid -- 卖房人证件号码
            ,buildingunitprice -- 建筑面积单价
            ,repayinterval -- 归还本金间隔
            ,graceperiod -- 宽限期（天）
            ,isgroupcustomer -- 是否集团客户
            ,iscancel -- 是否撤销
            ,insurflag -- INSUR_Y:有保险,INSUR_N：无保险
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,callbackurl -- 普惠签约回调地址
            ,loanaccountclearbank -- 入账账户清算行行号
            ,financialbond -- 委放/专项/金融债
            ,localstrategicindustry -- 本地战略性新兴产业
            ,compcerttype -- 企业证件类型
            ,excess -- 免赔率
            ,parkingaddress -- 购车位详址
            ,cuscomrelation -- 借款人与公司关系
            ,isdiscount -- 是否行内贴息/贴息标识
            ,bigloanpurpose -- 贷款用途大类
            ,title -- 标题
            ,riskcontrolback -- 风控背景
            ,cartype -- 车辆类型
            ,greenloanpurpose -- 绿色贷款用途
            ,' ' AS subgreenconsumeloanpurpose -- 
            ,' ' AS productchannel -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BAP_PERSONAL_LOAN_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
