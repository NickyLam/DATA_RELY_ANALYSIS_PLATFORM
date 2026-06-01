/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bap_personal_loan
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_bap_personal_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bap_personal_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bap_personal_loan_op purge;
drop table ${iol_schema}.icms_bap_personal_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bap_personal_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bap_personal_loan where 0=1;

create table ${iol_schema}.icms_bap_personal_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bap_personal_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bap_personal_loan_cl(
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
    else
        into ${iol_schema}.icms_bap_personal_loan_op(
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
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.isinsurance, o.isinsurance) as isinsurance -- 是否购买保险
    ,nvl(n.groupcustomerid, o.groupcustomerid) as groupcustomerid -- 集团客户号
    ,nvl(n.isjgaccount, o.isjgaccount) as isjgaccount -- 是否在我行开立监管账户
    ,nvl(n.propertytype, o.propertytype) as propertytype -- 所购房产类型
    ,nvl(n.insuranceperiod, o.insuranceperiod) as insuranceperiod -- 保险期限
    ,nvl(n.balloonamortenddate, o.balloonamortenddate) as balloonamortenddate -- 气球贷摊销到期日
    ,nvl(n.creditimageupflag, o.creditimageupflag) as creditimageupflag -- 征信授权书影像上传结果1完成上传2未完成上传
    ,nvl(n.housingform, o.housingform) as housingform -- 房屋形式
    ,nvl(n.isexception, o.isexception) as isexception -- 是否例外额度
    ,nvl(n.companyquotacontrol, o.companyquotacontrol) as companyquotacontrol -- 是否公司额度管控
    ,nvl(n.authinfo, o.authinfo) as authinfo -- 授权信息(JSON格式:授权类别,授权名称)
    ,nvl(n.enterprisecode, o.enterprisecode) as enterprisecode -- 经销商企业代码
    ,nvl(n.finalresult, o.finalresult) as finalresult -- 最终风控结果-移动展业赎楼贷
    ,nvl(n.relserialno, o.relserialno) as relserialno -- 关联流水号
    ,nvl(n.returncapitalinterval, o.returncapitalinterval) as returncapitalinterval -- 归还本金间隔
    ,nvl(n.contimageupflag, o.contimageupflag) as contimageupflag -- 借款合同影像上传结果1完成上传2未完成上传
    ,nvl(n.businesslicence, o.businesslicence) as businesslicence -- 营业执照号码
    ,nvl(n.isimage, o.isimage) as isimage -- 是否引入影像
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.groupcustomername, o.groupcustomername) as groupcustomername -- 集团客户名称
    ,nvl(n.relycompanycreditno, o.relycompanycreditno) as relycompanycreditno -- 自家/挂靠企业统一社会信用代码
    ,nvl(n.purchasecontractid, o.purchasecontractid) as purchasecontractid -- 购房合同号
    ,nvl(n.phreceivableam, o.phreceivableam) as phreceivableam -- 平安普惠收款金额
    ,nvl(n.mandateriskclassify, o.mandateriskclassify) as mandateriskclassify -- 委托贷款风险分类
    ,nvl(n.indtype, o.indtype) as indtype -- 客户性质
    ,nvl(n.paymentobject, o.paymentobject) as paymentobject -- 支付对象
    ,nvl(n.vehicletype, o.vehicletype) as vehicletype -- 车型
    ,nvl(n.feeratio, o.feeratio) as feeratio -- 手续费率
    ,nvl(n.returncapitalratio, o.returncapitalratio) as returncapitalratio -- 归还本金比例
    ,nvl(n.companybusinesssum, o.companybusinesssum) as companybusinesssum -- 公司授信总金额
    ,nvl(n.repaymentdatetype, o.repaymentdatetype) as repaymentdatetype -- 还款日确定
    ,nvl(n.resetamt, o.resetamt) as resetamt -- 重置额度
    ,nvl(n.mandatedepositcurrency, o.mandatedepositcurrency) as mandatedepositcurrency -- 委托存款币种
    ,nvl(n.housingprice, o.housingprice) as housingprice -- 房屋总价
    ,nvl(n.buildingarea, o.buildingarea) as buildingarea -- 购房面积（建筑面积）
    ,nvl(n.applycustype, o.applycustype) as applycustype -- 申请人其他类型
    ,nvl(n.isvendorassumeliability, o.isvendorassumeliability) as isvendorassumeliability -- 是否销售商承担回购责任
    ,nvl(n.evaluationcerttype, o.evaluationcerttype) as evaluationcerttype -- 评估证件类型
    ,nvl(n.flowflag, o.flowflag) as flowflag -- 流程标记
    ,nvl(n.passtime, o.passtime) as passtime -- 审批通过时间
    ,nvl(n.iswhite, o.iswhite) as iswhite -- 是否白户
    ,nvl(n.suggestsum, o.suggestsum) as suggestsum -- 建议贷款金额(元)
    ,nvl(n.applyamt, o.applyamt) as applyamt -- 申请额度
    ,nvl(n.onlineapproveresult, o.onlineapproveresult) as onlineapproveresult -- 线上审批结果
    ,nvl(n.companyname, o.companyname) as companyname -- 企业名称
    ,nvl(n.fitmentprice, o.fitmentprice) as fitmentprice -- 装修总价
    ,nvl(n.propertycontractno, o.propertycontractno) as propertycontractno -- 车位配套住房产权号/购房合同号
    ,nvl(n.esaepclassify, o.esaepclassify) as esaepclassify -- 节能环保分类
    ,nvl(n.repayratio, o.repayratio) as repayratio -- 归还本金比例
    ,nvl(n.suitesarea, o.suitesarea) as suitesarea -- 购房面积（套内面积）
    ,nvl(n.businessclass, o.businessclass) as businessclass -- 类别
    ,nvl(n.cusgruoprelation, o.cusgruoprelation) as cusgruoprelation -- 借款人与集团关系
    ,nvl(n.insurance, o.insurance) as insurance -- 保险金额
    ,nvl(n.sellername, o.sellername) as sellername -- 卖房人名称
    ,nvl(n.buildingcompany, o.buildingcompany) as buildingcompany -- 建筑单位
    ,nvl(n.presalepermitno, o.presalepermitno) as presalepermitno -- 预售许可证编号
    ,nvl(n.propertyarea, o.propertyarea) as propertyarea -- 所购房产面积
    ,nvl(n.isopenentsettleaccounts, o.isopenentsettleaccounts) as isopenentsettleaccounts -- 是否能够开立单位结算账户
    ,nvl(n.isaddamt, o.isaddamt) as isaddamt -- 是否提额
    ,nvl(n.suitesunitprice, o.suitesunitprice) as suitesunitprice -- 套房面积单价
    ,nvl(n.evaluationcertid, o.evaluationcertid) as evaluationcertid -- 评估机构证件号码
    ,nvl(n.vehiclecontractno, o.vehiclecontractno) as vehiclecontractno -- 购车合同号
    ,nvl(n.determprice, o.determprice) as determprice -- 认定价格
    ,nvl(n.propertyunitprice, o.propertyunitprice) as propertyunitprice -- 物管费单价
    ,nvl(n.insurancecontractno, o.insurancecontractno) as insurancecontractno -- 保险合同编号
    ,nvl(n.isthreemonthnewcar, o.isthreemonthnewcar) as isthreemonthnewcar -- 是否三个月内上牌新车
    ,nvl(n.propertycertid, o.propertycertid) as propertycertid -- 房屋权证号
    ,nvl(n.applyaddr, o.applyaddr) as applyaddr -- 申请地点
    ,nvl(n.signaddr, o.signaddr) as signaddr -- 签署地
    ,nvl(n.insurancevariety, o.insurancevariety) as insurancevariety -- 保险品种
    ,nvl(n.mandatedepositsum, o.mandatedepositsum) as mandatedepositsum -- 委托存款金额
    ,nvl(n.payeeaccountno, o.payeeaccountno) as payeeaccountno -- 收款人帐号
    ,nvl(n.informflag, o.informflag) as informflag -- 申请结果是否通知成功
    ,nvl(n.payeeaccounttel, o.payeeaccounttel) as payeeaccounttel -- 开户b绑定手机号
    ,nvl(n.housingaddress, o.housingaddress) as housingaddress -- 房屋详址
    ,nvl(n.companyid, o.companyid) as companyid -- 公司客户编号
    ,nvl(n.isloananytime, o.isloananytime) as isloananytime -- 是否随借随还
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.startdate, o.startdate) as startdate -- 审批开始时间
    ,nvl(n.isfirstpurchase, o.isfirstpurchase) as isfirstpurchase -- 是否首次购房
    ,nvl(n.groupavailexposure, o.groupavailexposure) as groupavailexposure -- 集团客户可用敞口额度
    ,nvl(n.isbusinessguarantee, o.isbusinessguarantee) as isbusinessguarantee -- 是否合作机构/开发商/经销商担保
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保类型
    ,nvl(n.discountratio, o.discountratio) as discountratio -- 贴息比例
    ,nvl(n.enddate, o.enddate) as enddate -- 审批结束时间
    ,nvl(n.certid, o.certid) as certid -- 借款人证件号码
    ,nvl(n.baserateadjustper, o.baserateadjustper) as baserateadjustper -- 基准利率上浮比例
    ,nvl(n.housinglevel, o.housinglevel) as housinglevel -- 房屋等级
    ,nvl(n.paymentratio, o.paymentratio) as paymentratio -- 首付比例
    ,nvl(n.otherloancontractno, o.otherloancontractno) as otherloancontractno -- 借款合同编号
    ,nvl(n.isonline, o.isonline) as isonline -- 是否线上审批
    ,nvl(n.mandatedepositaccounts, o.mandatedepositaccounts) as mandatedepositaccounts -- 委托贷款存款账号
    ,nvl(n.ischeckcreditreport, o.ischeckcreditreport) as ischeckcreditreport -- 征信两岗是否点击了查看征信报告按钮:1是，0否
    ,nvl(n.imageupflag, o.imageupflag) as imageupflag -- 影像上传结果1完成上传2未完成上传
    ,nvl(n.usccno, o.usccno) as usccno -- 统一社会信用码
    ,nvl(n.businessname, o.businessname) as businessname -- 商家/销售商/开发商/建房单位名称
    ,nvl(n.feesum, o.feesum) as feesum -- 手续费金额
    ,nvl(n.stallprice, o.stallprice) as stallprice -- 车位总价
    ,nvl(n.loanratio, o.loanratio) as loanratio -- 贷款成数
    ,nvl(n.loandirection, o.loandirection) as loandirection -- 资金投向
    ,nvl(n.housingsum, o.housingsum) as housingsum -- 房屋套数
    ,nvl(n.downpayment, o.downpayment) as downpayment -- 首付金额
    ,nvl(n.paymentbasis, o.paymentbasis) as paymentbasis -- 首付款依据
    ,nvl(n.yxserno, o.yxserno) as yxserno -- 影像流水号
    ,nvl(n.mandaterequirement, o.mandaterequirement) as mandaterequirement -- 委托条件
    ,nvl(n.creditincrmode, o.creditincrmode) as creditincrmode -- 增信模式标志
    ,nvl(n.channelcode, o.channelcode) as channelcode -- 渠道来源
    ,nvl(n.isback, o.isback) as isback -- 客户是否捞回
    ,nvl(n.relycompanyname, o.relycompanyname) as relycompanyname -- 自家/挂靠企业名称
    ,nvl(n.vehicleprice, o.vehicleprice) as vehicleprice -- 汽车总价
    ,nvl(n.checkresult, o.checkresult) as checkresult -- 校验结果
    ,nvl(n.authtelephone, o.authtelephone) as authtelephone -- 绑卡鉴权手机号
    ,nvl(n.certtype, o.certtype) as certtype -- 借款人证件类型
    ,nvl(n.othercontsigndate, o.othercontsigndate) as othercontsigndate -- 挂靠或租赁协议签订日期
    ,nvl(n.taxcode, o.taxcode) as taxcode -- 纳税人识别号
    ,nvl(n.evaluationname, o.evaluationname) as evaluationname -- 评估机构名称
    ,nvl(n.parkingarea, o.parkingarea) as parkingarea -- 购车位面积
    ,nvl(n.telephone, o.telephone) as telephone -- 借款人手机号码
    ,nvl(n.compcertid, o.compcertid) as compcertid -- 企业证件号码
    ,nvl(n.evaluateprice, o.evaluateprice) as evaluateprice -- 评估价格
    ,nvl(n.recordrelativeserialno, o.recordrelativeserialno) as recordrelativeserialno -- 关联中介备案编号
    ,nvl(n.creditscore, o.creditscore) as creditscore -- 机评信用等级
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.guaranteeagreement, o.guaranteeagreement) as guaranteeagreement -- 相关回购/担保协议书编号
    ,nvl(n.feepayment, o.feepayment) as feepayment -- 手续费支付方式
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.housingname, o.housingname) as housingname -- 楼盘名称
    ,nvl(n.personalbusinessloanstype, o.personalbusinessloanstype) as personalbusinessloanstype -- 个人经营性贷款分类
    ,nvl(n.payeename, o.payeename) as payeename -- 收款人名称
    ,nvl(n.investoinon, o.investoinon) as investoinon -- 调查人意见
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否与我行存在关联关系
    ,nvl(n.insurername, o.insurername) as insurername -- 保险公司名称
    ,nvl(n.paybankname, o.paybankname) as paybankname -- 收款人行名
    ,nvl(n.sellercertid, o.sellercertid) as sellercertid -- 卖房人证件号码
    ,nvl(n.buildingunitprice, o.buildingunitprice) as buildingunitprice -- 建筑面积单价
    ,nvl(n.repayinterval, o.repayinterval) as repayinterval -- 归还本金间隔
    ,nvl(n.graceperiod, o.graceperiod) as graceperiod -- 宽限期（天）
    ,nvl(n.isgroupcustomer, o.isgroupcustomer) as isgroupcustomer -- 是否集团客户
    ,nvl(n.iscancel, o.iscancel) as iscancel -- 是否撤销
    ,nvl(n.insurflag, o.insurflag) as insurflag -- INSUR_Y:有保险,INSUR_N：无保险
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.callbackurl, o.callbackurl) as callbackurl -- 普惠签约回调地址
    ,nvl(n.loanaccountclearbank, o.loanaccountclearbank) as loanaccountclearbank -- 入账账户清算行行号
    ,nvl(n.financialbond, o.financialbond) as financialbond -- 委放/专项/金融债
    ,nvl(n.localstrategicindustry, o.localstrategicindustry) as localstrategicindustry -- 本地战略性新兴产业
    ,nvl(n.compcerttype, o.compcerttype) as compcerttype -- 企业证件类型
    ,nvl(n.excess, o.excess) as excess -- 免赔率
    ,nvl(n.parkingaddress, o.parkingaddress) as parkingaddress -- 购车位详址
    ,nvl(n.cuscomrelation, o.cuscomrelation) as cuscomrelation -- 借款人与公司关系
    ,nvl(n.isdiscount, o.isdiscount) as isdiscount -- 是否行内贴息/贴息标识
    ,nvl(n.bigloanpurpose, o.bigloanpurpose) as bigloanpurpose -- 贷款用途大类
    ,nvl(n.title, o.title) as title -- 标题
    ,nvl(n.riskcontrolback, o.riskcontrolback) as riskcontrolback -- 风控背景
    ,nvl(n.cartype, o.cartype) as cartype -- 车辆类型
    ,nvl(n.greenloanpurpose, o.greenloanpurpose) as greenloanpurpose -- 绿色贷款用途
    ,nvl(n.subgreenconsumeloanpurpose, o.subgreenconsumeloanpurpose) as subgreenconsumeloanpurpose -- 
    ,nvl(n.productchannel, o.productchannel) as productchannel -- 
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_bap_personal_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bap_personal_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.isinsurance <> n.isinsurance
        or o.groupcustomerid <> n.groupcustomerid
        or o.isjgaccount <> n.isjgaccount
        or o.propertytype <> n.propertytype
        or o.insuranceperiod <> n.insuranceperiod
        or o.balloonamortenddate <> n.balloonamortenddate
        or o.creditimageupflag <> n.creditimageupflag
        or o.housingform <> n.housingform
        or o.isexception <> n.isexception
        or o.companyquotacontrol <> n.companyquotacontrol
        or o.authinfo <> n.authinfo
        or o.enterprisecode <> n.enterprisecode
        or o.finalresult <> n.finalresult
        or o.relserialno <> n.relserialno
        or o.returncapitalinterval <> n.returncapitalinterval
        or o.contimageupflag <> n.contimageupflag
        or o.businesslicence <> n.businesslicence
        or o.isimage <> n.isimage
        or o.corporgid <> n.corporgid
        or o.groupcustomername <> n.groupcustomername
        or o.relycompanycreditno <> n.relycompanycreditno
        or o.purchasecontractid <> n.purchasecontractid
        or o.phreceivableam <> n.phreceivableam
        or o.mandateriskclassify <> n.mandateriskclassify
        or o.indtype <> n.indtype
        or o.paymentobject <> n.paymentobject
        or o.vehicletype <> n.vehicletype
        or o.feeratio <> n.feeratio
        or o.returncapitalratio <> n.returncapitalratio
        or o.companybusinesssum <> n.companybusinesssum
        or o.repaymentdatetype <> n.repaymentdatetype
        or o.resetamt <> n.resetamt
        or o.mandatedepositcurrency <> n.mandatedepositcurrency
        or o.housingprice <> n.housingprice
        or o.buildingarea <> n.buildingarea
        or o.applycustype <> n.applycustype
        or o.isvendorassumeliability <> n.isvendorassumeliability
        or o.evaluationcerttype <> n.evaluationcerttype
        or o.flowflag <> n.flowflag
        or o.passtime <> n.passtime
        or o.iswhite <> n.iswhite
        or o.suggestsum <> n.suggestsum
        or o.applyamt <> n.applyamt
        or o.onlineapproveresult <> n.onlineapproveresult
        or o.companyname <> n.companyname
        or o.fitmentprice <> n.fitmentprice
        or o.propertycontractno <> n.propertycontractno
        or o.esaepclassify <> n.esaepclassify
        or o.repayratio <> n.repayratio
        or o.suitesarea <> n.suitesarea
        or o.businessclass <> n.businessclass
        or o.cusgruoprelation <> n.cusgruoprelation
        or o.insurance <> n.insurance
        or o.sellername <> n.sellername
        or o.buildingcompany <> n.buildingcompany
        or o.presalepermitno <> n.presalepermitno
        or o.propertyarea <> n.propertyarea
        or o.isopenentsettleaccounts <> n.isopenentsettleaccounts
        or o.isaddamt <> n.isaddamt
        or o.suitesunitprice <> n.suitesunitprice
        or o.evaluationcertid <> n.evaluationcertid
        or o.vehiclecontractno <> n.vehiclecontractno
        or o.determprice <> n.determprice
        or o.propertyunitprice <> n.propertyunitprice
        or o.insurancecontractno <> n.insurancecontractno
        or o.isthreemonthnewcar <> n.isthreemonthnewcar
        or o.propertycertid <> n.propertycertid
        or o.applyaddr <> n.applyaddr
        or o.signaddr <> n.signaddr
        or o.insurancevariety <> n.insurancevariety
        or o.mandatedepositsum <> n.mandatedepositsum
        or o.payeeaccountno <> n.payeeaccountno
        or o.informflag <> n.informflag
        or o.payeeaccounttel <> n.payeeaccounttel
        or o.housingaddress <> n.housingaddress
        or o.companyid <> n.companyid
        or o.isloananytime <> n.isloananytime
        or o.purpose <> n.purpose
        or o.startdate <> n.startdate
        or o.isfirstpurchase <> n.isfirstpurchase
        or o.groupavailexposure <> n.groupavailexposure
        or o.isbusinessguarantee <> n.isbusinessguarantee
        or o.guarantytype <> n.guarantytype
        or o.discountratio <> n.discountratio
        or o.enddate <> n.enddate
        or o.certid <> n.certid
        or o.baserateadjustper <> n.baserateadjustper
        or o.housinglevel <> n.housinglevel
        or o.paymentratio <> n.paymentratio
        or o.otherloancontractno <> n.otherloancontractno
        or o.isonline <> n.isonline
        or o.mandatedepositaccounts <> n.mandatedepositaccounts
        or o.ischeckcreditreport <> n.ischeckcreditreport
        or o.imageupflag <> n.imageupflag
        or o.usccno <> n.usccno
        or o.businessname <> n.businessname
        or o.feesum <> n.feesum
        or o.stallprice <> n.stallprice
        or o.loanratio <> n.loanratio
        or o.loandirection <> n.loandirection
        or o.housingsum <> n.housingsum
        or o.downpayment <> n.downpayment
        or o.paymentbasis <> n.paymentbasis
        or o.yxserno <> n.yxserno
        or o.mandaterequirement <> n.mandaterequirement
        or o.creditincrmode <> n.creditincrmode
        or o.channelcode <> n.channelcode
        or o.isback <> n.isback
        or o.relycompanyname <> n.relycompanyname
        or o.vehicleprice <> n.vehicleprice
        or o.checkresult <> n.checkresult
        or o.authtelephone <> n.authtelephone
        or o.certtype <> n.certtype
        or o.othercontsigndate <> n.othercontsigndate
        or o.taxcode <> n.taxcode
        or o.evaluationname <> n.evaluationname
        or o.parkingarea <> n.parkingarea
        or o.telephone <> n.telephone
        or o.compcertid <> n.compcertid
        or o.evaluateprice <> n.evaluateprice
        or o.recordrelativeserialno <> n.recordrelativeserialno
        or o.creditscore <> n.creditscore
        or o.remark <> n.remark
        or o.guaranteeagreement <> n.guaranteeagreement
        or o.feepayment <> n.feepayment
        or o.paymenttype <> n.paymenttype
        or o.housingname <> n.housingname
        or o.personalbusinessloanstype <> n.personalbusinessloanstype
        or o.payeename <> n.payeename
        or o.investoinon <> n.investoinon
        or o.isbankrel <> n.isbankrel
        or o.insurername <> n.insurername
        or o.paybankname <> n.paybankname
        or o.sellercertid <> n.sellercertid
        or o.buildingunitprice <> n.buildingunitprice
        or o.repayinterval <> n.repayinterval
        or o.graceperiod <> n.graceperiod
        or o.isgroupcustomer <> n.isgroupcustomer
        or o.iscancel <> n.iscancel
        or o.insurflag <> n.insurflag
        or o.migtflag <> n.migtflag
        or o.callbackurl <> n.callbackurl
        or o.loanaccountclearbank <> n.loanaccountclearbank
        or o.financialbond <> n.financialbond
        or o.localstrategicindustry <> n.localstrategicindustry
        or o.compcerttype <> n.compcerttype
        or o.excess <> n.excess
        or o.parkingaddress <> n.parkingaddress
        or o.cuscomrelation <> n.cuscomrelation
        or o.isdiscount <> n.isdiscount
        or o.bigloanpurpose <> n.bigloanpurpose
        or o.title <> n.title
        or o.riskcontrolback <> n.riskcontrolback
        or o.cartype <> n.cartype
        or o.greenloanpurpose <> n.greenloanpurpose
        or o.subgreenconsumeloanpurpose <> n.subgreenconsumeloanpurpose
        or o.productchannel <> n.productchannel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bap_personal_loan_cl(
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
    else
        into ${iol_schema}.icms_bap_personal_loan_op(
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
    o.serialno -- 流水号
    ,o.isinsurance -- 是否购买保险
    ,o.groupcustomerid -- 集团客户号
    ,o.isjgaccount -- 是否在我行开立监管账户
    ,o.propertytype -- 所购房产类型
    ,o.insuranceperiod -- 保险期限
    ,o.balloonamortenddate -- 气球贷摊销到期日
    ,o.creditimageupflag -- 征信授权书影像上传结果1完成上传2未完成上传
    ,o.housingform -- 房屋形式
    ,o.isexception -- 是否例外额度
    ,o.companyquotacontrol -- 是否公司额度管控
    ,o.authinfo -- 授权信息(JSON格式:授权类别,授权名称)
    ,o.enterprisecode -- 经销商企业代码
    ,o.finalresult -- 最终风控结果-移动展业赎楼贷
    ,o.relserialno -- 关联流水号
    ,o.returncapitalinterval -- 归还本金间隔
    ,o.contimageupflag -- 借款合同影像上传结果1完成上传2未完成上传
    ,o.businesslicence -- 营业执照号码
    ,o.isimage -- 是否引入影像
    ,o.corporgid -- 法人机构编号
    ,o.groupcustomername -- 集团客户名称
    ,o.relycompanycreditno -- 自家/挂靠企业统一社会信用代码
    ,o.purchasecontractid -- 购房合同号
    ,o.phreceivableam -- 平安普惠收款金额
    ,o.mandateriskclassify -- 委托贷款风险分类
    ,o.indtype -- 客户性质
    ,o.paymentobject -- 支付对象
    ,o.vehicletype -- 车型
    ,o.feeratio -- 手续费率
    ,o.returncapitalratio -- 归还本金比例
    ,o.companybusinesssum -- 公司授信总金额
    ,o.repaymentdatetype -- 还款日确定
    ,o.resetamt -- 重置额度
    ,o.mandatedepositcurrency -- 委托存款币种
    ,o.housingprice -- 房屋总价
    ,o.buildingarea -- 购房面积（建筑面积）
    ,o.applycustype -- 申请人其他类型
    ,o.isvendorassumeliability -- 是否销售商承担回购责任
    ,o.evaluationcerttype -- 评估证件类型
    ,o.flowflag -- 流程标记
    ,o.passtime -- 审批通过时间
    ,o.iswhite -- 是否白户
    ,o.suggestsum -- 建议贷款金额(元)
    ,o.applyamt -- 申请额度
    ,o.onlineapproveresult -- 线上审批结果
    ,o.companyname -- 企业名称
    ,o.fitmentprice -- 装修总价
    ,o.propertycontractno -- 车位配套住房产权号/购房合同号
    ,o.esaepclassify -- 节能环保分类
    ,o.repayratio -- 归还本金比例
    ,o.suitesarea -- 购房面积（套内面积）
    ,o.businessclass -- 类别
    ,o.cusgruoprelation -- 借款人与集团关系
    ,o.insurance -- 保险金额
    ,o.sellername -- 卖房人名称
    ,o.buildingcompany -- 建筑单位
    ,o.presalepermitno -- 预售许可证编号
    ,o.propertyarea -- 所购房产面积
    ,o.isopenentsettleaccounts -- 是否能够开立单位结算账户
    ,o.isaddamt -- 是否提额
    ,o.suitesunitprice -- 套房面积单价
    ,o.evaluationcertid -- 评估机构证件号码
    ,o.vehiclecontractno -- 购车合同号
    ,o.determprice -- 认定价格
    ,o.propertyunitprice -- 物管费单价
    ,o.insurancecontractno -- 保险合同编号
    ,o.isthreemonthnewcar -- 是否三个月内上牌新车
    ,o.propertycertid -- 房屋权证号
    ,o.applyaddr -- 申请地点
    ,o.signaddr -- 签署地
    ,o.insurancevariety -- 保险品种
    ,o.mandatedepositsum -- 委托存款金额
    ,o.payeeaccountno -- 收款人帐号
    ,o.informflag -- 申请结果是否通知成功
    ,o.payeeaccounttel -- 开户b绑定手机号
    ,o.housingaddress -- 房屋详址
    ,o.companyid -- 公司客户编号
    ,o.isloananytime -- 是否随借随还
    ,o.purpose -- 用途
    ,o.startdate -- 审批开始时间
    ,o.isfirstpurchase -- 是否首次购房
    ,o.groupavailexposure -- 集团客户可用敞口额度
    ,o.isbusinessguarantee -- 是否合作机构/开发商/经销商担保
    ,o.guarantytype -- 担保类型
    ,o.discountratio -- 贴息比例
    ,o.enddate -- 审批结束时间
    ,o.certid -- 借款人证件号码
    ,o.baserateadjustper -- 基准利率上浮比例
    ,o.housinglevel -- 房屋等级
    ,o.paymentratio -- 首付比例
    ,o.otherloancontractno -- 借款合同编号
    ,o.isonline -- 是否线上审批
    ,o.mandatedepositaccounts -- 委托贷款存款账号
    ,o.ischeckcreditreport -- 征信两岗是否点击了查看征信报告按钮:1是，0否
    ,o.imageupflag -- 影像上传结果1完成上传2未完成上传
    ,o.usccno -- 统一社会信用码
    ,o.businessname -- 商家/销售商/开发商/建房单位名称
    ,o.feesum -- 手续费金额
    ,o.stallprice -- 车位总价
    ,o.loanratio -- 贷款成数
    ,o.loandirection -- 资金投向
    ,o.housingsum -- 房屋套数
    ,o.downpayment -- 首付金额
    ,o.paymentbasis -- 首付款依据
    ,o.yxserno -- 影像流水号
    ,o.mandaterequirement -- 委托条件
    ,o.creditincrmode -- 增信模式标志
    ,o.channelcode -- 渠道来源
    ,o.isback -- 客户是否捞回
    ,o.relycompanyname -- 自家/挂靠企业名称
    ,o.vehicleprice -- 汽车总价
    ,o.checkresult -- 校验结果
    ,o.authtelephone -- 绑卡鉴权手机号
    ,o.certtype -- 借款人证件类型
    ,o.othercontsigndate -- 挂靠或租赁协议签订日期
    ,o.taxcode -- 纳税人识别号
    ,o.evaluationname -- 评估机构名称
    ,o.parkingarea -- 购车位面积
    ,o.telephone -- 借款人手机号码
    ,o.compcertid -- 企业证件号码
    ,o.evaluateprice -- 评估价格
    ,o.recordrelativeserialno -- 关联中介备案编号
    ,o.creditscore -- 机评信用等级
    ,o.remark -- 备注
    ,o.guaranteeagreement -- 相关回购/担保协议书编号
    ,o.feepayment -- 手续费支付方式
    ,o.paymenttype -- 支付方式
    ,o.housingname -- 楼盘名称
    ,o.personalbusinessloanstype -- 个人经营性贷款分类
    ,o.payeename -- 收款人名称
    ,o.investoinon -- 调查人意见
    ,o.isbankrel -- 是否与我行存在关联关系
    ,o.insurername -- 保险公司名称
    ,o.paybankname -- 收款人行名
    ,o.sellercertid -- 卖房人证件号码
    ,o.buildingunitprice -- 建筑面积单价
    ,o.repayinterval -- 归还本金间隔
    ,o.graceperiod -- 宽限期（天）
    ,o.isgroupcustomer -- 是否集团客户
    ,o.iscancel -- 是否撤销
    ,o.insurflag -- INSUR_Y:有保险,INSUR_N：无保险
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.callbackurl -- 普惠签约回调地址
    ,o.loanaccountclearbank -- 入账账户清算行行号
    ,o.financialbond -- 委放/专项/金融债
    ,o.localstrategicindustry -- 本地战略性新兴产业
    ,o.compcerttype -- 企业证件类型
    ,o.excess -- 免赔率
    ,o.parkingaddress -- 购车位详址
    ,o.cuscomrelation -- 借款人与公司关系
    ,o.isdiscount -- 是否行内贴息/贴息标识
    ,o.bigloanpurpose -- 贷款用途大类
    ,o.title -- 标题
    ,o.riskcontrolback -- 风控背景
    ,o.cartype -- 车辆类型
    ,o.greenloanpurpose -- 绿色贷款用途
    ,o.subgreenconsumeloanpurpose -- 
    ,o.productchannel -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_bap_personal_loan_bk o
    left join ${iol_schema}.icms_bap_personal_loan_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bap_personal_loan_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_bap_personal_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bap_personal_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bap_personal_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bap_personal_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bap_personal_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_bap_personal_loan_cl;
alter table ${iol_schema}.icms_bap_personal_loan exchange partition p_20991231 with table ${iol_schema}.icms_bap_personal_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bap_personal_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bap_personal_loan_op purge;
drop table ${iol_schema}.icms_bap_personal_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bap_personal_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bap_personal_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
