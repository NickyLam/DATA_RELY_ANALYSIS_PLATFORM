/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bc_personal_loan
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
create table ${iol_schema}.icms_bc_personal_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bc_personal_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_personal_loan_op purge;
drop table ${iol_schema}.icms_bc_personal_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bc_personal_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_personal_loan where 0=1;

create table ${iol_schema}.icms_bc_personal_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_personal_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_personal_loan_cl(
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
            ,migtflag -- 迁移标志：crs rcr ilc upl
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
            ,isnewcoborrower -- 是否新增共同借款人
            ,productchannel -- 产品渠道标识
            ,claimperson -- 集中办公合同认领人员
            ,isclaim -- 是否认领
            ,isbelongterm -- 是否靠档计息
            ,centralizeorgid -- 登记机构（集中录入人员）
            ,centralizeoperaid -- 登记所属机构（集中录入人员）
            ,claimdate -- 集中录入日期
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
    else
        into ${iol_schema}.icms_bc_personal_loan_op(
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
            ,migtflag -- 迁移标志：crs rcr ilc upl
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
            ,isnewcoborrower -- 是否新增共同借款人
            ,productchannel -- 产品渠道标识
            ,claimperson -- 集中办公合同认领人员
            ,isclaim -- 是否认领
            ,isbelongterm -- 是否靠档计息
            ,centralizeorgid -- 登记机构（集中录入人员）
            ,centralizeoperaid -- 登记所属机构（集中录入人员）
            ,claimdate -- 集中录入日期
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
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.esaepclassify, o.esaepclassify) as esaepclassify -- 节能环保分类
    ,nvl(n.mandatedepositaccounts, o.mandatedepositaccounts) as mandatedepositaccounts -- 委托贷款存款账号
    ,nvl(n.relationship, o.relationship) as relationship -- 集团客户可用敞口额度
    ,nvl(n.eaccountno, o.eaccountno) as eaccountno -- E账户
    ,nvl(n.stallprice, o.stallprice) as stallprice -- 车位总价
    ,nvl(n.companyexposuresum, o.companyexposuresum) as companyexposuresum -- 公司授信总金额(元)
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否我行关联方
    ,nvl(n.sellercertid, o.sellercertid) as sellercertid -- 卖房人证件号码
    ,nvl(n.loanaccountname, o.loanaccountname) as loanaccountname -- 入账账户名称
    ,nvl(n.buildingunitprice, o.buildingunitprice) as buildingunitprice -- 建筑面积单价
    ,nvl(n.mandaterequirement, o.mandaterequirement) as mandaterequirement -- 委托条件
    ,nvl(n.isexception, o.isexception) as isexception -- 是否例外额度
    ,nvl(n.endaccountname, o.endaccountname) as endaccountname -- 最终绑定卡卡名
    ,nvl(n.imageapprresult, o.imageapprresult) as imageapprresult -- 影像审批结果
    ,nvl(n.isdiscount, o.isdiscount) as isdiscount -- 是否行内贴息/贴息标识
    ,nvl(n.vehiclecontractno, o.vehiclecontractno) as vehiclecontractno -- 购车合同号
    ,nvl(n.housingsum, o.housingsum) as housingsum -- 房屋套数
    ,nvl(n.renewalflag, o.renewalflag) as renewalflag -- 合同是否支持续期标识
    ,nvl(n.localstrategicindustry, o.localstrategicindustry) as localstrategicindustry -- 本地战略性新兴产业
    ,nvl(n.insuranceperiod, o.insuranceperiod) as insuranceperiod -- 保险期限保险期限(月)
    ,nvl(n.housingname, o.housingname) as housingname -- 楼盘名称
    ,nvl(n.totalrecyleamt, o.totalrecyleamt) as totalrecyleamt -- 累计回收金额
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保类型
    ,nvl(n.guaranteeagreement, o.guaranteeagreement) as guaranteeagreement -- 相关回购/担保协议书编号
    ,nvl(n.insurancecontractno, o.insurancecontractno) as insurancecontractno -- 保险合同编号
    ,nvl(n.paymentobject, o.paymentobject) as paymentobject -- 支付对象
    ,nvl(n.relserialno, o.relserialno) as relserialno -- 关联编号
    ,nvl(n.excess, o.excess) as excess -- 免赔率
    ,nvl(n.imagefilepath, o.imagefilepath) as imagefilepath -- 影像文件路径
    ,nvl(n.parkingaddress, o.parkingaddress) as parkingaddress -- 购车位详址
    ,nvl(n.groupcustcode, o.groupcustcode) as groupcustcode -- 集团客户号
    ,nvl(n.paymentratio, o.paymentratio) as paymentratio -- 首付比例
    ,nvl(n.isopenentsettleaccounts, o.isopenentsettleaccounts) as isopenentsettleaccounts -- 是否能够开立单位结算账户
    ,nvl(n.isfirstpurchase, o.isfirstpurchase) as isfirstpurchase -- 是否首次购房
    ,nvl(n.imageflag, o.imageflag) as imageflag -- 影像标识
    ,nvl(n.mandatedepositsum, o.mandatedepositsum) as mandatedepositsum -- 委托存款金额
    ,nvl(n.suitesunitprice, o.suitesunitprice) as suitesunitprice -- 套房面积单价
    ,nvl(n.downpayment, o.downpayment) as downpayment -- 首付金额
    ,nvl(n.isinsurance, o.isinsurance) as isinsurance -- 是否购买保险
    ,nvl(n.eaccountname, o.eaccountname) as eaccountname -- E账户户名
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.businessname, o.businessname) as businessname -- 商家/销售商/开发商/建房单位名称
    ,nvl(n.parkingarea, o.parkingarea) as parkingarea -- 购车位面积
    ,nvl(n.feeratio, o.feeratio) as feeratio -- 手续费率
    ,nvl(n.housingprice, o.housingprice) as housingprice -- 房屋总价
    ,nvl(n.iswhite, o.iswhite) as iswhite -- 借款人与集团关系
    ,nvl(n.purchasecontractid, o.purchasecontractid) as purchasecontractid -- 购房合同号
    ,nvl(n.loanratio, o.loanratio) as loanratio -- 贷款成数
    ,nvl(n.businesslicence, o.businesslicence) as businesslicence -- 营业执照号码
    ,nvl(n.payaccountcertid, o.payaccountcertid) as payaccountcertid -- 绑定身份证号
    ,nvl(n.recordrelativeserialno, o.recordrelativeserialno) as recordrelativeserialno -- 关联中介备案编号
    ,nvl(n.telephone, o.telephone) as telephone -- 手机号
    ,nvl(n.isbigaccountmode, o.isbigaccountmode) as isbigaccountmode -- 是否大账户模式
    ,nvl(n.channelno, o.channelno) as channelno -- 渠道编号
    ,nvl(n.buildingcompany, o.buildingcompany) as buildingcompany -- 建筑单位
    ,nvl(n.housinglevel, o.housinglevel) as housinglevel -- 房屋等级
    ,nvl(n.startbankno, o.startbankno) as startbankno -- 初始卡开户行
    ,nvl(n.financialbond, o.financialbond) as financialbond -- 委放/专项/金融债
    ,nvl(n.insurername, o.insurername) as insurername -- 保险公司名称
    ,nvl(n.fitmentprice, o.fitmentprice) as fitmentprice -- 装修总价
    ,nvl(n.repaymentaccname, o.repaymentaccname) as repaymentaccname -- 还款账户名称
    ,nvl(n.endclearbankno, o.endclearbankno) as endclearbankno -- 收款方开户行清算行行号（最终）
    ,nvl(n.presalepermitno, o.presalepermitno) as presalepermitno -- 预售许可证编号
    ,nvl(n.extenddays, o.extenddays) as extenddays -- 宽限天数
    ,nvl(n.isonline, o.isonline) as isonline -- 是否线上审批
    ,nvl(n.propertyarea, o.propertyarea) as propertyarea -- 所购房产面积
    ,nvl(n.evaluationname, o.evaluationname) as evaluationname -- 评估机构名称
    ,nvl(n.suitesarea, o.suitesarea) as suitesarea -- 购房面积（套内面积）
    ,nvl(n.payaccounttel, o.payaccounttel) as payaccounttel -- 开户手机
    ,nvl(n.evaluationcertid, o.evaluationcertid) as evaluationcertid -- 评估机构证件号码
    ,nvl(n.mandatedepositcurrency, o.mandatedepositcurrency) as mandatedepositcurrency -- 委托存款币种
    ,nvl(n.exposeclassifyresult, o.exposeclassifyresult) as exposeclassifyresult -- 风险暴露分类结果
    ,nvl(n.fundsprovided, o.fundsprovided) as fundsprovided -- 资金来源
    ,nvl(n.principalcertid, o.principalcertid) as principalcertid -- 委托人有效证件号码
    ,nvl(n.endaccountno, o.endaccountno) as endaccountno -- 最终绑定卡卡号
    ,nvl(n.principalmarriage, o.principalmarriage) as principalmarriage -- 委托人婚姻状况
    ,nvl(n.isbusinessguarantee, o.isbusinessguarantee) as isbusinessguarantee -- 是否合作机构/开发商/经销商担保
    ,nvl(n.isvendorassumeliability, o.isvendorassumeliability) as isvendorassumeliability -- 是否销售商承担回购责任
    ,nvl(n.groupcustname, o.groupcustname) as groupcustname -- 集团客户名称
    ,nvl(n.housingaddress, o.housingaddress) as housingaddress -- 房屋详址
    ,nvl(n.payaccounttype, o.payaccounttype) as payaccounttype -- 还款卡类型0-本行卡,1-他行卡
    ,nvl(n.personalbusinessloanstype, o.personalbusinessloanstype) as personalbusinessloanstype -- 个人经营性贷款分类
    ,nvl(n.evaluationcerttype, o.evaluationcerttype) as evaluationcerttype -- 评估证件类型
    ,nvl(n.discountratio, o.discountratio) as discountratio -- 贴息比例
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.iscompanycustomer, o.iscompanycustomer) as iscompanycustomer -- 是否公司额度管控
    ,nvl(n.enterprisecode, o.enterprisecode) as enterprisecode -- 经销商企业代码
    ,nvl(n.companycustomername, o.companycustomername) as companycustomername -- 公司客户名称
    ,nvl(n.housingform, o.housingform) as housingform -- 房屋形式
    ,nvl(n.paymentbasis, o.paymentbasis) as paymentbasis -- 首付款依据
    ,nvl(n.feesum, o.feesum) as feesum -- 手续费金额
    ,nvl(n.isgroupcustomer, o.isgroupcustomer) as isgroupcustomer -- 是否集团客户
    ,nvl(n.isloananytime, o.isloananytime) as isloananytime -- 是否随借随还
    ,nvl(n.sellername, o.sellername) as sellername -- 卖房人名称
    ,nvl(n.businessclass, o.businessclass) as businessclass -- 类别
    ,nvl(n.principalname, o.principalname) as principalname -- 委托人名称
    ,nvl(n.creditincrmode, o.creditincrmode) as creditincrmode -- 增信模式标志
    ,nvl(n.loandirection, o.loandirection) as loandirection -- 资金投向
    ,nvl(n.insurancevariety, o.insurancevariety) as insurancevariety -- 保险品种
    ,nvl(n.buildingarea, o.buildingarea) as buildingarea -- 购房面积（建筑面积）
    ,nvl(n.repaydatetype, o.repaydatetype) as repaydatetype -- 还款日确定
    ,nvl(n.feepayment, o.feepayment) as feepayment -- 手续费支付方式
    ,nvl(n.repaymentaccount, o.repaymentaccount) as repaymentaccount -- 还款账号
    ,nvl(n.evaluateprice, o.evaluateprice) as evaluateprice -- 评估价格
    ,nvl(n.propertyunitprice, o.propertyunitprice) as propertyunitprice -- 物管费单价
    ,nvl(n.availexposure, o.availexposure) as availexposure -- 集团客户可用敞口额度
    ,nvl(n.endbankno, o.endbankno) as endbankno -- 最终实体卡对应的开户行
    ,nvl(n.companyrelation, o.companyrelation) as companyrelation -- 借款人与公司关系
    ,nvl(n.propertytype, o.propertytype) as propertytype -- 所购房产类型
    ,nvl(n.endbankname, o.endbankname) as endbankname -- 最终实体卡对应的开户行名称
    ,nvl(n.isjgaccount, o.isjgaccount) as isjgaccount -- 是否在我行开立监管账户
    ,nvl(n.vehicletype, o.vehicletype) as vehicletype -- 车型
    ,nvl(n.startaccountno, o.startaccountno) as startaccountno -- 初始卡卡号
    ,nvl(n.startclearbankno, o.startclearbankno) as startclearbankno -- 收款方开户行清算行行号（最初）
    ,nvl(n.vehicleprice, o.vehicleprice) as vehicleprice -- 汽车总价
    ,nvl(n.insurance, o.insurance) as insurance -- 保险金额
    ,nvl(n.wthruselmt, o.wthruselmt) as wthruselmt -- 是否使用额度
    ,nvl(n.mandateriskclassify, o.mandateriskclassify) as mandateriskclassify -- 委托贷款风险分类
    ,nvl(n.propertycertid, o.propertycertid) as propertycertid -- 房屋权证号
    ,nvl(n.loanaccountno, o.loanaccountno) as loanaccountno -- 入账账号
    ,nvl(n.startbankname, o.startbankname) as startbankname -- 初始卡开户行名称
    ,nvl(n.determprice, o.determprice) as determprice -- 认定价格
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.companycustomerid, o.companycustomerid) as companycustomerid -- 公司客户号
    ,nvl(n.propertycontractno, o.propertycontractno) as propertycontractno -- 车位配套住房产权号/购房合同号
    ,nvl(n.clientno, o.clientno) as clientno -- 委托人编号
    ,nvl(n.startaccountname, o.startaccountname) as startaccountname -- 初始卡账户名称
    ,nvl(n.commodityamt, o.commodityamt) as commodityamt -- 购买金额
    ,nvl(n.businesscertcode, o.businesscertcode) as businesscertcode -- 统一社会信用代码
    ,nvl(n.payway, o.payway) as payway -- 贷款发放方式(1-一次2-分次)
    ,nvl(n.dealdisputeway, o.dealdisputeway) as dealdisputeway -- 解决争议方式(1-甲方所在地人民法院2-仲裁委员会3-天河区人民法院4-其他)
    ,nvl(n.dealdisputetxt, o.dealdisputetxt) as dealdisputetxt -- 解决争议方式备注
    ,nvl(n.isforcedeal, o.isforcedeal) as isforcedeal -- 是否强制执行公证(1-是2-否)
    ,nvl(n.bigloanpurpose, o.bigloanpurpose) as bigloanpurpose -- 贷款用途大类
    ,nvl(n.zjkjstatus, o.zjkjstatus) as zjkjstatus -- 致景科技合同激活状态 0-未激活 1-待激活 2-已激活
    ,nvl(n.cartype, o.cartype) as cartype -- 车辆类型
    ,nvl(n.greenloanpurpose, o.greenloanpurpose) as greenloanpurpose -- 绿色贷款用途
    ,nvl(n.accountserialno, o.accountserialno) as accountserialno -- 关联账户流水号
    ,nvl(n.subgreenconsumeloanpurpose, o.subgreenconsumeloanpurpose) as subgreenconsumeloanpurpose -- 绿色消费子类
    ,nvl(n.isagriculture, o.isagriculture) as isagriculture -- 是否涉农
    ,nvl(n.highindustry, o.highindustry) as highindustry -- 高技术产业
    ,nvl(n.economyindustry, o.economyindustry) as economyindustry -- 数字经济核心产业
    ,nvl(n.intellectualindustry, o.intellectualindustry) as intellectualindustry -- 投向知识产权密集型产业
    ,nvl(n.strategicindustry, o.strategicindustry) as strategicindustry -- 
    ,nvl(n.cultureindustry, o.cultureindustry) as cultureindustry -- 投向文化及相关产业
    ,nvl(n.isnewcoborrower, o.isnewcoborrower) as isnewcoborrower -- 是否新增共同借款人
    ,nvl(n.productchannel, o.productchannel) as productchannel -- 产品渠道标识
    ,nvl(n.claimperson, o.claimperson) as claimperson -- 集中办公合同认领人员
    ,nvl(n.isclaim, o.isclaim) as isclaim -- 是否认领
    ,nvl(n.isbelongterm, o.isbelongterm) as isbelongterm -- 是否靠档计息
    ,nvl(n.centralizeorgid, o.centralizeorgid) as centralizeorgid -- 登记机构（集中录入人员）
    ,nvl(n.centralizeoperaid, o.centralizeoperaid) as centralizeoperaid -- 登记所属机构（集中录入人员）
    ,nvl(n.claimdate, o.claimdate) as claimdate -- 集中录入日期
    ,nvl(n.extloanaccountno, o.extloanaccountno) as extloanaccountno -- 行外收款银行卡号
    ,nvl(n.extloanaccountname, o.extloanaccountname) as extloanaccountname -- 行外收款卡户名
    ,nvl(n.recvbankid, o.recvbankid) as recvbankid -- 收款银行编号
    ,nvl(n.recvbankname, o.recvbankname) as recvbankname -- 收款银行名称
    ,nvl(n.extrepaymentaccount, o.extrepaymentaccount) as extrepaymentaccount -- 行外还款银行卡号
    ,nvl(n.extrepaymentaccname, o.extrepaymentaccname) as extrepaymentaccname -- 行外还款卡户名
    ,nvl(n.repaybankid, o.repaybankid) as repaybankid -- 还款银行编号
    ,nvl(n.repaybankname, o.repaybankname) as repaybankname -- 还款银行名称
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
from (select * from ${iol_schema}.icms_bc_personal_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bc_personal_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.esaepclassify <> n.esaepclassify
        or o.mandatedepositaccounts <> n.mandatedepositaccounts
        or o.relationship <> n.relationship
        or o.eaccountno <> n.eaccountno
        or o.stallprice <> n.stallprice
        or o.companyexposuresum <> n.companyexposuresum
        or o.purpose <> n.purpose
        or o.isbankrel <> n.isbankrel
        or o.sellercertid <> n.sellercertid
        or o.loanaccountname <> n.loanaccountname
        or o.buildingunitprice <> n.buildingunitprice
        or o.mandaterequirement <> n.mandaterequirement
        or o.isexception <> n.isexception
        or o.endaccountname <> n.endaccountname
        or o.imageapprresult <> n.imageapprresult
        or o.isdiscount <> n.isdiscount
        or o.vehiclecontractno <> n.vehiclecontractno
        or o.housingsum <> n.housingsum
        or o.renewalflag <> n.renewalflag
        or o.localstrategicindustry <> n.localstrategicindustry
        or o.insuranceperiod <> n.insuranceperiod
        or o.housingname <> n.housingname
        or o.totalrecyleamt <> n.totalrecyleamt
        or o.guarantytype <> n.guarantytype
        or o.guaranteeagreement <> n.guaranteeagreement
        or o.insurancecontractno <> n.insurancecontractno
        or o.paymentobject <> n.paymentobject
        or o.relserialno <> n.relserialno
        or o.excess <> n.excess
        or o.imagefilepath <> n.imagefilepath
        or o.parkingaddress <> n.parkingaddress
        or o.groupcustcode <> n.groupcustcode
        or o.paymentratio <> n.paymentratio
        or o.isopenentsettleaccounts <> n.isopenentsettleaccounts
        or o.isfirstpurchase <> n.isfirstpurchase
        or o.imageflag <> n.imageflag
        or o.mandatedepositsum <> n.mandatedepositsum
        or o.suitesunitprice <> n.suitesunitprice
        or o.downpayment <> n.downpayment
        or o.isinsurance <> n.isinsurance
        or o.eaccountname <> n.eaccountname
        or o.migtflag <> n.migtflag
        or o.businessname <> n.businessname
        or o.parkingarea <> n.parkingarea
        or o.feeratio <> n.feeratio
        or o.housingprice <> n.housingprice
        or o.iswhite <> n.iswhite
        or o.purchasecontractid <> n.purchasecontractid
        or o.loanratio <> n.loanratio
        or o.businesslicence <> n.businesslicence
        or o.payaccountcertid <> n.payaccountcertid
        or o.recordrelativeserialno <> n.recordrelativeserialno
        or o.telephone <> n.telephone
        or o.isbigaccountmode <> n.isbigaccountmode
        or o.channelno <> n.channelno
        or o.buildingcompany <> n.buildingcompany
        or o.housinglevel <> n.housinglevel
        or o.startbankno <> n.startbankno
        or o.financialbond <> n.financialbond
        or o.insurername <> n.insurername
        or o.fitmentprice <> n.fitmentprice
        or o.repaymentaccname <> n.repaymentaccname
        or o.endclearbankno <> n.endclearbankno
        or o.presalepermitno <> n.presalepermitno
        or o.extenddays <> n.extenddays
        or o.isonline <> n.isonline
        or o.propertyarea <> n.propertyarea
        or o.evaluationname <> n.evaluationname
        or o.suitesarea <> n.suitesarea
        or o.payaccounttel <> n.payaccounttel
        or o.evaluationcertid <> n.evaluationcertid
        or o.mandatedepositcurrency <> n.mandatedepositcurrency
        or o.exposeclassifyresult <> n.exposeclassifyresult
        or o.fundsprovided <> n.fundsprovided
        or o.principalcertid <> n.principalcertid
        or o.endaccountno <> n.endaccountno
        or o.principalmarriage <> n.principalmarriage
        or o.isbusinessguarantee <> n.isbusinessguarantee
        or o.isvendorassumeliability <> n.isvendorassumeliability
        or o.groupcustname <> n.groupcustname
        or o.housingaddress <> n.housingaddress
        or o.payaccounttype <> n.payaccounttype
        or o.personalbusinessloanstype <> n.personalbusinessloanstype
        or o.evaluationcerttype <> n.evaluationcerttype
        or o.discountratio <> n.discountratio
        or o.corporgid <> n.corporgid
        or o.iscompanycustomer <> n.iscompanycustomer
        or o.enterprisecode <> n.enterprisecode
        or o.companycustomername <> n.companycustomername
        or o.housingform <> n.housingform
        or o.paymentbasis <> n.paymentbasis
        or o.feesum <> n.feesum
        or o.isgroupcustomer <> n.isgroupcustomer
        or o.isloananytime <> n.isloananytime
        or o.sellername <> n.sellername
        or o.businessclass <> n.businessclass
        or o.principalname <> n.principalname
        or o.creditincrmode <> n.creditincrmode
        or o.loandirection <> n.loandirection
        or o.insurancevariety <> n.insurancevariety
        or o.buildingarea <> n.buildingarea
        or o.repaydatetype <> n.repaydatetype
        or o.feepayment <> n.feepayment
        or o.repaymentaccount <> n.repaymentaccount
        or o.evaluateprice <> n.evaluateprice
        or o.propertyunitprice <> n.propertyunitprice
        or o.availexposure <> n.availexposure
        or o.endbankno <> n.endbankno
        or o.companyrelation <> n.companyrelation
        or o.propertytype <> n.propertytype
        or o.endbankname <> n.endbankname
        or o.isjgaccount <> n.isjgaccount
        or o.vehicletype <> n.vehicletype
        or o.startaccountno <> n.startaccountno
        or o.startclearbankno <> n.startclearbankno
        or o.vehicleprice <> n.vehicleprice
        or o.insurance <> n.insurance
        or o.wthruselmt <> n.wthruselmt
        or o.mandateriskclassify <> n.mandateriskclassify
        or o.propertycertid <> n.propertycertid
        or o.loanaccountno <> n.loanaccountno
        or o.startbankname <> n.startbankname
        or o.determprice <> n.determprice
        or o.paymenttype <> n.paymenttype
        or o.companycustomerid <> n.companycustomerid
        or o.propertycontractno <> n.propertycontractno
        or o.clientno <> n.clientno
        or o.startaccountname <> n.startaccountname
        or o.commodityamt <> n.commodityamt
        or o.businesscertcode <> n.businesscertcode
        or o.payway <> n.payway
        or o.dealdisputeway <> n.dealdisputeway
        or o.dealdisputetxt <> n.dealdisputetxt
        or o.isforcedeal <> n.isforcedeal
        or o.bigloanpurpose <> n.bigloanpurpose
        or o.zjkjstatus <> n.zjkjstatus
        or o.cartype <> n.cartype
        or o.greenloanpurpose <> n.greenloanpurpose
        or o.accountserialno <> n.accountserialno
        or o.subgreenconsumeloanpurpose <> n.subgreenconsumeloanpurpose
        or o.isagriculture <> n.isagriculture
        or o.highindustry <> n.highindustry
        or o.economyindustry <> n.economyindustry
        or o.intellectualindustry <> n.intellectualindustry
        or o.strategicindustry <> n.strategicindustry
        or o.cultureindustry <> n.cultureindustry
        or o.isnewcoborrower <> n.isnewcoborrower
        or o.productchannel <> n.productchannel
        or o.claimperson <> n.claimperson
        or o.isclaim <> n.isclaim
        or o.isbelongterm <> n.isbelongterm
        or o.centralizeorgid <> n.centralizeorgid
        or o.centralizeoperaid <> n.centralizeoperaid
        or o.claimdate <> n.claimdate
        or o.extloanaccountno <> n.extloanaccountno
        or o.extloanaccountname <> n.extloanaccountname
        or o.recvbankid <> n.recvbankid
        or o.recvbankname <> n.recvbankname
        or o.extrepaymentaccount <> n.extrepaymentaccount
        or o.extrepaymentaccname <> n.extrepaymentaccname
        or o.repaybankid <> n.repaybankid
        or o.repaybankname <> n.repaybankname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_personal_loan_cl(
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
            ,migtflag -- 迁移标志：crs rcr ilc upl
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
            ,isnewcoborrower -- 是否新增共同借款人
            ,productchannel -- 产品渠道标识
            ,claimperson -- 集中办公合同认领人员
            ,isclaim -- 是否认领
            ,isbelongterm -- 是否靠档计息
            ,centralizeorgid -- 登记机构（集中录入人员）
            ,centralizeoperaid -- 登记所属机构（集中录入人员）
            ,claimdate -- 集中录入日期
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
    else
        into ${iol_schema}.icms_bc_personal_loan_op(
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
            ,migtflag -- 迁移标志：crs rcr ilc upl
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
            ,isnewcoborrower -- 是否新增共同借款人
            ,productchannel -- 产品渠道标识
            ,claimperson -- 集中办公合同认领人员
            ,isclaim -- 是否认领
            ,isbelongterm -- 是否靠档计息
            ,centralizeorgid -- 登记机构（集中录入人员）
            ,centralizeoperaid -- 登记所属机构（集中录入人员）
            ,claimdate -- 集中录入日期
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
    o.serialno -- 流水号
    ,o.esaepclassify -- 节能环保分类
    ,o.mandatedepositaccounts -- 委托贷款存款账号
    ,o.relationship -- 集团客户可用敞口额度
    ,o.eaccountno -- E账户
    ,o.stallprice -- 车位总价
    ,o.companyexposuresum -- 公司授信总金额(元)
    ,o.purpose -- 用途
    ,o.isbankrel -- 是否我行关联方
    ,o.sellercertid -- 卖房人证件号码
    ,o.loanaccountname -- 入账账户名称
    ,o.buildingunitprice -- 建筑面积单价
    ,o.mandaterequirement -- 委托条件
    ,o.isexception -- 是否例外额度
    ,o.endaccountname -- 最终绑定卡卡名
    ,o.imageapprresult -- 影像审批结果
    ,o.isdiscount -- 是否行内贴息/贴息标识
    ,o.vehiclecontractno -- 购车合同号
    ,o.housingsum -- 房屋套数
    ,o.renewalflag -- 合同是否支持续期标识
    ,o.localstrategicindustry -- 本地战略性新兴产业
    ,o.insuranceperiod -- 保险期限保险期限(月)
    ,o.housingname -- 楼盘名称
    ,o.totalrecyleamt -- 累计回收金额
    ,o.guarantytype -- 担保类型
    ,o.guaranteeagreement -- 相关回购/担保协议书编号
    ,o.insurancecontractno -- 保险合同编号
    ,o.paymentobject -- 支付对象
    ,o.relserialno -- 关联编号
    ,o.excess -- 免赔率
    ,o.imagefilepath -- 影像文件路径
    ,o.parkingaddress -- 购车位详址
    ,o.groupcustcode -- 集团客户号
    ,o.paymentratio -- 首付比例
    ,o.isopenentsettleaccounts -- 是否能够开立单位结算账户
    ,o.isfirstpurchase -- 是否首次购房
    ,o.imageflag -- 影像标识
    ,o.mandatedepositsum -- 委托存款金额
    ,o.suitesunitprice -- 套房面积单价
    ,o.downpayment -- 首付金额
    ,o.isinsurance -- 是否购买保险
    ,o.eaccountname -- E账户户名
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.businessname -- 商家/销售商/开发商/建房单位名称
    ,o.parkingarea -- 购车位面积
    ,o.feeratio -- 手续费率
    ,o.housingprice -- 房屋总价
    ,o.iswhite -- 借款人与集团关系
    ,o.purchasecontractid -- 购房合同号
    ,o.loanratio -- 贷款成数
    ,o.businesslicence -- 营业执照号码
    ,o.payaccountcertid -- 绑定身份证号
    ,o.recordrelativeserialno -- 关联中介备案编号
    ,o.telephone -- 手机号
    ,o.isbigaccountmode -- 是否大账户模式
    ,o.channelno -- 渠道编号
    ,o.buildingcompany -- 建筑单位
    ,o.housinglevel -- 房屋等级
    ,o.startbankno -- 初始卡开户行
    ,o.financialbond -- 委放/专项/金融债
    ,o.insurername -- 保险公司名称
    ,o.fitmentprice -- 装修总价
    ,o.repaymentaccname -- 还款账户名称
    ,o.endclearbankno -- 收款方开户行清算行行号（最终）
    ,o.presalepermitno -- 预售许可证编号
    ,o.extenddays -- 宽限天数
    ,o.isonline -- 是否线上审批
    ,o.propertyarea -- 所购房产面积
    ,o.evaluationname -- 评估机构名称
    ,o.suitesarea -- 购房面积（套内面积）
    ,o.payaccounttel -- 开户手机
    ,o.evaluationcertid -- 评估机构证件号码
    ,o.mandatedepositcurrency -- 委托存款币种
    ,o.exposeclassifyresult -- 风险暴露分类结果
    ,o.fundsprovided -- 资金来源
    ,o.principalcertid -- 委托人有效证件号码
    ,o.endaccountno -- 最终绑定卡卡号
    ,o.principalmarriage -- 委托人婚姻状况
    ,o.isbusinessguarantee -- 是否合作机构/开发商/经销商担保
    ,o.isvendorassumeliability -- 是否销售商承担回购责任
    ,o.groupcustname -- 集团客户名称
    ,o.housingaddress -- 房屋详址
    ,o.payaccounttype -- 还款卡类型0-本行卡,1-他行卡
    ,o.personalbusinessloanstype -- 个人经营性贷款分类
    ,o.evaluationcerttype -- 评估证件类型
    ,o.discountratio -- 贴息比例
    ,o.corporgid -- 法人机构编号
    ,o.iscompanycustomer -- 是否公司额度管控
    ,o.enterprisecode -- 经销商企业代码
    ,o.companycustomername -- 公司客户名称
    ,o.housingform -- 房屋形式
    ,o.paymentbasis -- 首付款依据
    ,o.feesum -- 手续费金额
    ,o.isgroupcustomer -- 是否集团客户
    ,o.isloananytime -- 是否随借随还
    ,o.sellername -- 卖房人名称
    ,o.businessclass -- 类别
    ,o.principalname -- 委托人名称
    ,o.creditincrmode -- 增信模式标志
    ,o.loandirection -- 资金投向
    ,o.insurancevariety -- 保险品种
    ,o.buildingarea -- 购房面积（建筑面积）
    ,o.repaydatetype -- 还款日确定
    ,o.feepayment -- 手续费支付方式
    ,o.repaymentaccount -- 还款账号
    ,o.evaluateprice -- 评估价格
    ,o.propertyunitprice -- 物管费单价
    ,o.availexposure -- 集团客户可用敞口额度
    ,o.endbankno -- 最终实体卡对应的开户行
    ,o.companyrelation -- 借款人与公司关系
    ,o.propertytype -- 所购房产类型
    ,o.endbankname -- 最终实体卡对应的开户行名称
    ,o.isjgaccount -- 是否在我行开立监管账户
    ,o.vehicletype -- 车型
    ,o.startaccountno -- 初始卡卡号
    ,o.startclearbankno -- 收款方开户行清算行行号（最初）
    ,o.vehicleprice -- 汽车总价
    ,o.insurance -- 保险金额
    ,o.wthruselmt -- 是否使用额度
    ,o.mandateriskclassify -- 委托贷款风险分类
    ,o.propertycertid -- 房屋权证号
    ,o.loanaccountno -- 入账账号
    ,o.startbankname -- 初始卡开户行名称
    ,o.determprice -- 认定价格
    ,o.paymenttype -- 支付方式
    ,o.companycustomerid -- 公司客户号
    ,o.propertycontractno -- 车位配套住房产权号/购房合同号
    ,o.clientno -- 委托人编号
    ,o.startaccountname -- 初始卡账户名称
    ,o.commodityamt -- 购买金额
    ,o.businesscertcode -- 统一社会信用代码
    ,o.payway -- 贷款发放方式(1-一次2-分次)
    ,o.dealdisputeway -- 解决争议方式(1-甲方所在地人民法院2-仲裁委员会3-天河区人民法院4-其他)
    ,o.dealdisputetxt -- 解决争议方式备注
    ,o.isforcedeal -- 是否强制执行公证(1-是2-否)
    ,o.bigloanpurpose -- 贷款用途大类
    ,o.zjkjstatus -- 致景科技合同激活状态 0-未激活 1-待激活 2-已激活
    ,o.cartype -- 车辆类型
    ,o.greenloanpurpose -- 绿色贷款用途
    ,o.accountserialno -- 关联账户流水号
    ,o.subgreenconsumeloanpurpose -- 绿色消费子类
    ,o.isagriculture -- 是否涉农
    ,o.highindustry -- 高技术产业
    ,o.economyindustry -- 数字经济核心产业
    ,o.intellectualindustry -- 投向知识产权密集型产业
    ,o.strategicindustry -- 
    ,o.cultureindustry -- 投向文化及相关产业
    ,o.isnewcoborrower -- 是否新增共同借款人
    ,o.productchannel -- 产品渠道标识
    ,o.claimperson -- 集中办公合同认领人员
    ,o.isclaim -- 是否认领
    ,o.isbelongterm -- 是否靠档计息
    ,o.centralizeorgid -- 登记机构（集中录入人员）
    ,o.centralizeoperaid -- 登记所属机构（集中录入人员）
    ,o.claimdate -- 集中录入日期
    ,o.extloanaccountno -- 行外收款银行卡号
    ,o.extloanaccountname -- 行外收款卡户名
    ,o.recvbankid -- 收款银行编号
    ,o.recvbankname -- 收款银行名称
    ,o.extrepaymentaccount -- 行外还款银行卡号
    ,o.extrepaymentaccname -- 行外还款卡户名
    ,o.repaybankid -- 还款银行编号
    ,o.repaybankname -- 还款银行名称
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
from ${iol_schema}.icms_bc_personal_loan_bk o
    left join ${iol_schema}.icms_bc_personal_loan_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bc_personal_loan_cl d
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
--truncate table ${iol_schema}.icms_bc_personal_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bc_personal_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bc_personal_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bc_personal_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bc_personal_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_bc_personal_loan_cl;
alter table ${iol_schema}.icms_bc_personal_loan exchange partition p_20991231 with table ${iol_schema}.icms_bc_personal_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bc_personal_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_personal_loan_op purge;
drop table ${iol_schema}.icms_bc_personal_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bc_personal_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bc_personal_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
