/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_ba_personal_loan
CreateDate: 20250210
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_ba_personal_loan drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_ba_personal_loan add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_ba_personal_loan (
etl_dt  --数据日期
,serialno  --流水号
,usccno  --统一社会信用码
,flowflag  --流程标记0业务申请1业务审批2出账申请3出账审批4待放款5放款6还款中7已结清,9已拒绝11-借呗初审12-借呗终审
,isdiscount  --是否行内贴息/贴息标识
,authinfo  --授权信息(json格式:授权类别,授权名称)
,groupavailexposure  --集团客户可用敞口额度
,othercontsigndate  --挂靠或租赁协议签订日期
,companybusinesssum  --公司授信总金额
,parkingarea  --购车位面积
,certid  --借款人证件号码
,isfirstpurchase  --是否首次购房
,downpayment  --首付金额
,paybankname  --收款人行名
,sellercertid  --卖房人证件号码
,mandaterequirement  --委托条件
,buildingcompany  --建筑单位
,cuscomrelation  --借款人与公司关系
,insurance  --保险金额
,loanaccountclearbank  --入账账户清算行行号
,feesum  --手续费金额
,yxserno  --影像流水号
,discountratio  --贴息比例
,mandatedepositcurrency  --委托存款币种
,determprice  --认定价格
,evaluationname  --评估机构名称
,onlineapproveresult  --线上审批结果
,applycustype  --申请人其他类型
,iswhite  --是否白户
,mandatedepositaccounts  --委托贷款存款账号
,passtime  --审批通过时间
,repaymentdatetype  --还款日确定
,businesslicence  --营业执照号码
,presalepermitno  --预售许可证编号
,guaranteeagreement  --相关回购/担保协议书编号
,isgroupcustomer  --是否集团客户
,returncapitalinterval  --归还本金间隔
,insuranceperiod  --保险期限
,insurername  --保险公司名称
,stallprice  --车位总价
,iscancel  --是否撤销
,returncapitalratio  --归还本金比例
,purchasecontractid  --购房合同号
,recordrelativeserialno  --关联中介备案编号
,groupcustomerid  --集团客户号
,relserialno  --关联流水号
,guarantytype  --担保类型
,companyname  --公司客户名称
,isthreemonthnewcar  --是否三个月内上牌新车
,isonline  --是否线上审批
,housingprice  --房屋总价
,propertycontractno  --车位配套住房产权号/购房合同号
,esaepclassify  --节能环保分类
,businessname  --商家/销售商/开发商/建房单位名称
,enddate  --审批结束时间
,telephone  --借款人手机号码
,evaluateprice  --评估价格
,imageupflag  --影像上传结果1完成上传2未完成上传
,phreceivableam  --平安普惠收款金额
,suggestsum  --建议贷款金额(元)
,authtelephone  --绑卡鉴权手机号
,isimage  --是否引入影像
,payeename  --收款人名称
,parkingaddress  --购车位详址
,applyaddr  --申请地点
,isvendorassumeliability  --是否销售商承担回购责任
,sellername  --卖房人名称
,informflag  --申请结果是否通知成功
,loanratio  --贷款成数
,vehiclecontractno  --购车合同号
,balloonamortenddate  --气球贷摊销到期日
,investoinon  --调查人意见
,otherloancontractno  --借款合同编号
,mandatedepositsum  --委托存款金额
,propertycertid  --房屋权证号
,evaluationcertid  --评估机构证件号码
,contimageupflag  --借款合同影像上传结果1完成上传2未完成上传
,payeeaccounttel  --开户b绑定手机号
,suitesunitprice  --套房面积单价
,mandateriskclassify  --委托贷款风险分类
,financialbond  --委放/专项/金融债
,propertyarea  --所购房产面积
,applyamt  --申请额度
,insurancevariety  --保险品种
,isback  --客户是否捞回
,resetamt  --重置额度
,housingname  --楼盘名称
,channelcode  --渠道来源
,enterprisecode  --经销商企业代码
,propertytype  --所购房产类型
,excess  --免赔率
,isbankrel  --是否与我行存在关联关系
,ischeckcreditreport  --征信两岗是否点击了查看征信报告按钮:1是，0否
,housingsum  --房屋套数
,businessclass  --类别
,purpose  --用途
,checkresult  --校验结果
,insurflag  --是否有保险
,insurancecontractno  --保险合同编号
,isexception  --是否例外额度
,startdate  --审批开始时间
,callbackurl  --普惠签约回调地址
,finalresult  --最终风控结果-移动展业赎楼贷
,housingform  --房屋形式
,fitmentprice  --装修总价
,repayinterval  --归还本金间隔
,indtype  --客户性质
,taxcode  --纳税人识别号
,buildingunitprice  --建筑面积单价
,vehicletype  --车型
,availexposure  --集团客户名称
,companyid  --公司客户编号
,graceperiod  --宽限期（天）
,personalbusinessloanstype  --个人经营性贷款分类
,isloananytime  --是否随借随还
,housingaddress  --房屋详址
,repayratio  --归还本金比例
,signaddr  --签署地
,evaluationcerttype  --评估证件类型
,paymentobject  --支付对象
,certtype  --借款人证件类型
,relycompanyname  --自家/挂靠企业名称
,paymenttype  --支付方式
,feepayment  --手续费支付方式
,paymentbasis  --首付款依据
,propertyunitprice  --物管费单价
,compcertid  --企业证件号码
,groupcustcode  --是否集团客户
,payeeaccountno  --收款人帐号
,isinsurance  --是否购买保险
,isopenentsettleaccounts  --是否能够开立单位结算账户
,compcerttype  --企业证件类型
,vehicleprice  --汽车总价
,housinglevel  --房屋等级
,isbusinessguarantee  --是否合作机构/开发商/经销商担保
,localstrategicindustry  --本地战略性新兴产业
,migtflag  --迁移标志：crs rcr ilc upl
,cusgruoprelation  --借款人与集团关系
,corporgid  --法人机构编号
,relycompanycreditno  --自家/挂靠企业统一社会信用代码
,baserateadjustper  --基准利率上浮比例
,feeratio  --手续费率
,companyquotacontrol  --是否公司额度管控
,suitesarea  --购房面积（套内面积）
,isaddamt  --是否提额
,groupcustname  --集团客户号
,buildingarea  --购房面积（建筑面积）
,creditscore  --机评信用等级
,remark  --备注
,paymentratio  --首付比例
,loandirection  --资金投向
,groupcustomername  --集团客户名称
,isjgaccount  --是否在我行开立监管账户
,creditimageupflag  --征信授权书影像上传结果1完成上传2未完成上传
,creditincrmode  --增信模式标志
,referrerid  --推荐人id
,iswthrmanuactclmt  --是否人工激活额度yesno
,recheckflag  --复核标识yesno
,consignerid  --委托人id
,ishouseinguangdong  --委托人id
,worktype  --委托人id
,bigloanpurpose  --贷款用途大类
,title  --标题
,riskcontrolback  --风控背景
,cuscreditscore  --客户信用分数:内评
,cuscreditscorelevel  --客户信用分数等级
,cartype  --车辆类型
,greenloanpurpose  --绿色贷款用途
,companytype  --企业规模
,employments  --从业人员
,busiincome  --营业收入
,assetstotal  --资产总额
,industry  --所属行业
,custcreditlevel  --客户风险等级
,loanpurposedetails  --贷款用途细类字段
,highindustry  --高技术产业
,economyindustry  --数字经济核心产业
,intellectualindustry  --投向知识产权密集型产业
,cultureindustry  --投向文化及相关产业
,isagriculture  --是否涉农
,strategicindustry  --
,custlabel  --
,warninginfo  --预警信息
,subgreenconsumeloanpurpose  --绿色消费子类
,isoperatingentinvolvespecialized  --经营企业是否涉及专精特新
,ishightechnologyent  --是否高新技术企业
,istechnologyent  --是否科技型企业
,isscientifictechent  --是否科创企业
,isspecializedgiantent  --是否专精特新“小巨人”企业
,isspecializedsmallandmident  --是否“专精特新”中小企业
,istechnologysmallandmident  --是否科技型中小企业
,isindustrysinglechampionent  --是否制造业单项冠军企业
,isnationaltechnologinnovationent  --是否国家技术创新示范企业
,isgarden  --是否园区贷
,productchannel  --产品渠道标识
,iscentralizedofficestaff  --合同制作人员（集中办公人员/本人）
,cobsratio  --持股比例
,workingmonth  --从业期限月
,flowbranchtype  --流程分支类型
,isicmsfactory  --信贷工厂模式（01-是,02-否,03-无）
,guaranteecompanyname  --见保即贷业务担保公司
,runentyearincome  --流水推算的年销售收入
,lastyearentyearincome  --纳税申报资料反映的上年度收入
,yearincomerate  --预计销售收入年增长率
,operationloanbalanceskr  --实控人经营性贷款余额
,otherworkcaptial  --其他渠道提供的营运资金
,isrelatedcompany  --借款企业是否为担保公司的关联企业:1是0否
,intentguaramt  --意向担保金额
,guarcompanyterm  --
,comptaxgrade  --企业纳税等级
,iscompanyrelatedperson  --是否担保公司关联人
,recommendedamt  --担保公司推荐金额
,recommendedterm  --
,otherlimitflag  --是否占用他用额度

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --流水号
,replace(replace(t1.usccno,chr(13),''),chr(10),'') as usccno --统一社会信用码
,replace(replace(t1.flowflag,chr(13),''),chr(10),'') as flowflag --流程标记0业务申请1业务审批2出账申请3出账审批4待放款5放款6还款中7已结清,9已拒绝11-借呗初审12-借呗终审
,replace(replace(t1.isdiscount,chr(13),''),chr(10),'') as isdiscount --是否行内贴息/贴息标识
,replace(replace(t1.authinfo,chr(13),''),chr(10),'') as authinfo --授权信息(json格式:授权类别,授权名称)
,t1.groupavailexposure as groupavailexposure --集团客户可用敞口额度
,t1.othercontsigndate as othercontsigndate --挂靠或租赁协议签订日期
,t1.companybusinesssum as companybusinesssum --公司授信总金额
,t1.parkingarea as parkingarea --购车位面积
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid --借款人证件号码
,replace(replace(t1.isfirstpurchase,chr(13),''),chr(10),'') as isfirstpurchase --是否首次购房
,t1.downpayment as downpayment --首付金额
,replace(replace(t1.paybankname,chr(13),''),chr(10),'') as paybankname --收款人行名
,replace(replace(t1.sellercertid,chr(13),''),chr(10),'') as sellercertid --卖房人证件号码
,replace(replace(t1.mandaterequirement,chr(13),''),chr(10),'') as mandaterequirement --委托条件
,replace(replace(t1.buildingcompany,chr(13),''),chr(10),'') as buildingcompany --建筑单位
,replace(replace(t1.cuscomrelation,chr(13),''),chr(10),'') as cuscomrelation --借款人与公司关系
,t1.insurance as insurance --保险金额
,replace(replace(t1.loanaccountclearbank,chr(13),''),chr(10),'') as loanaccountclearbank --入账账户清算行行号
,t1.feesum as feesum --手续费金额
,replace(replace(t1.yxserno,chr(13),''),chr(10),'') as yxserno --影像流水号
,t1.discountratio as discountratio --贴息比例
,replace(replace(t1.mandatedepositcurrency,chr(13),''),chr(10),'') as mandatedepositcurrency --委托存款币种
,t1.determprice as determprice --认定价格
,replace(replace(t1.evaluationname,chr(13),''),chr(10),'') as evaluationname --评估机构名称
,replace(replace(t1.onlineapproveresult,chr(13),''),chr(10),'') as onlineapproveresult --线上审批结果
,replace(replace(t1.applycustype,chr(13),''),chr(10),'') as applycustype --申请人其他类型
,replace(replace(t1.iswhite,chr(13),''),chr(10),'') as iswhite --是否白户
,replace(replace(t1.mandatedepositaccounts,chr(13),''),chr(10),'') as mandatedepositaccounts --委托贷款存款账号
,t1.passtime as passtime --审批通过时间
,replace(replace(t1.repaymentdatetype,chr(13),''),chr(10),'') as repaymentdatetype --还款日确定
,replace(replace(t1.businesslicence,chr(13),''),chr(10),'') as businesslicence --营业执照号码
,replace(replace(t1.presalepermitno,chr(13),''),chr(10),'') as presalepermitno --预售许可证编号
,replace(replace(t1.guaranteeagreement,chr(13),''),chr(10),'') as guaranteeagreement --相关回购/担保协议书编号
,replace(replace(t1.isgroupcustomer,chr(13),''),chr(10),'') as isgroupcustomer --是否集团客户
,replace(replace(t1.returncapitalinterval,chr(13),''),chr(10),'') as returncapitalinterval --归还本金间隔
,t1.insuranceperiod as insuranceperiod --保险期限
,replace(replace(t1.insurername,chr(13),''),chr(10),'') as insurername --保险公司名称
,t1.stallprice as stallprice --车位总价
,replace(replace(t1.iscancel,chr(13),''),chr(10),'') as iscancel --是否撤销
,t1.returncapitalratio as returncapitalratio --归还本金比例
,replace(replace(t1.purchasecontractid,chr(13),''),chr(10),'') as purchasecontractid --购房合同号
,replace(replace(t1.recordrelativeserialno,chr(13),''),chr(10),'') as recordrelativeserialno --关联中介备案编号
,replace(replace(t1.groupcustomerid,chr(13),''),chr(10),'') as groupcustomerid --集团客户号
,replace(replace(t1.relserialno,chr(13),''),chr(10),'') as relserialno --关联流水号
,replace(replace(t1.guarantytype,chr(13),''),chr(10),'') as guarantytype --担保类型
,replace(replace(t1.companyname,chr(13),''),chr(10),'') as companyname --公司客户名称
,replace(replace(t1.isthreemonthnewcar,chr(13),''),chr(10),'') as isthreemonthnewcar --是否三个月内上牌新车
,replace(replace(t1.isonline,chr(13),''),chr(10),'') as isonline --是否线上审批
,t1.housingprice as housingprice --房屋总价
,replace(replace(t1.propertycontractno,chr(13),''),chr(10),'') as propertycontractno --车位配套住房产权号/购房合同号
,replace(replace(t1.esaepclassify,chr(13),''),chr(10),'') as esaepclassify --节能环保分类
,replace(replace(t1.businessname,chr(13),''),chr(10),'') as businessname --商家/销售商/开发商/建房单位名称
,t1.enddate as enddate --审批结束时间
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone --借款人手机号码
,t1.evaluateprice as evaluateprice --评估价格
,replace(replace(t1.imageupflag,chr(13),''),chr(10),'') as imageupflag --影像上传结果1完成上传2未完成上传
,t1.phreceivableam as phreceivableam --平安普惠收款金额
,t1.suggestsum as suggestsum --建议贷款金额(元)
,replace(replace(t1.authtelephone,chr(13),''),chr(10),'') as authtelephone --绑卡鉴权手机号
,replace(replace(t1.isimage,chr(13),''),chr(10),'') as isimage --是否引入影像
,replace(replace(t1.payeename,chr(13),''),chr(10),'') as payeename --收款人名称
,replace(replace(t1.parkingaddress,chr(13),''),chr(10),'') as parkingaddress --购车位详址
,replace(replace(t1.applyaddr,chr(13),''),chr(10),'') as applyaddr --申请地点
,replace(replace(t1.isvendorassumeliability,chr(13),''),chr(10),'') as isvendorassumeliability --是否销售商承担回购责任
,replace(replace(t1.sellername,chr(13),''),chr(10),'') as sellername --卖房人名称
,replace(replace(t1.informflag,chr(13),''),chr(10),'') as informflag --申请结果是否通知成功
,t1.loanratio as loanratio --贷款成数
,replace(replace(t1.vehiclecontractno,chr(13),''),chr(10),'') as vehiclecontractno --购车合同号
,t1.balloonamortenddate as balloonamortenddate --气球贷摊销到期日
,replace(replace(t1.investoinon,chr(13),''),chr(10),'') as investoinon --调查人意见
,replace(replace(t1.otherloancontractno,chr(13),''),chr(10),'') as otherloancontractno --借款合同编号
,t1.mandatedepositsum as mandatedepositsum --委托存款金额
,replace(replace(t1.propertycertid,chr(13),''),chr(10),'') as propertycertid --房屋权证号
,replace(replace(t1.evaluationcertid,chr(13),''),chr(10),'') as evaluationcertid --评估机构证件号码
,replace(replace(t1.contimageupflag,chr(13),''),chr(10),'') as contimageupflag --借款合同影像上传结果1完成上传2未完成上传
,replace(replace(t1.payeeaccounttel,chr(13),''),chr(10),'') as payeeaccounttel --开户b绑定手机号
,t1.suitesunitprice as suitesunitprice --套房面积单价
,replace(replace(t1.mandateriskclassify,chr(13),''),chr(10),'') as mandateriskclassify --委托贷款风险分类
,t1.financialbond as financialbond --委放/专项/金融债
,t1.propertyarea as propertyarea --所购房产面积
,t1.applyamt as applyamt --申请额度
,replace(replace(t1.insurancevariety,chr(13),''),chr(10),'') as insurancevariety --保险品种
,replace(replace(t1.isback,chr(13),''),chr(10),'') as isback --客户是否捞回
,t1.resetamt as resetamt --重置额度
,replace(replace(t1.housingname,chr(13),''),chr(10),'') as housingname --楼盘名称
,replace(replace(t1.channelcode,chr(13),''),chr(10),'') as channelcode --渠道来源
,replace(replace(t1.enterprisecode,chr(13),''),chr(10),'') as enterprisecode --经销商企业代码
,replace(replace(t1.propertytype,chr(13),''),chr(10),'') as propertytype --所购房产类型
,t1.excess as excess --免赔率
,replace(replace(t1.isbankrel,chr(13),''),chr(10),'') as isbankrel --是否与我行存在关联关系
,replace(replace(t1.ischeckcreditreport,chr(13),''),chr(10),'') as ischeckcreditreport --征信两岗是否点击了查看征信报告按钮:1是，0否
,t1.housingsum as housingsum --房屋套数
,replace(replace(t1.businessclass,chr(13),''),chr(10),'') as businessclass --类别
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose --用途
,replace(replace(t1.checkresult,chr(13),''),chr(10),'') as checkresult --校验结果
,replace(replace(t1.insurflag,chr(13),''),chr(10),'') as insurflag --是否有保险
,replace(replace(t1.insurancecontractno,chr(13),''),chr(10),'') as insurancecontractno --保险合同编号
,replace(replace(t1.isexception,chr(13),''),chr(10),'') as isexception --是否例外额度
,t1.startdate as startdate --审批开始时间
,replace(replace(t1.callbackurl,chr(13),''),chr(10),'') as callbackurl --普惠签约回调地址
,replace(replace(t1.finalresult,chr(13),''),chr(10),'') as finalresult --最终风控结果-移动展业赎楼贷
,replace(replace(t1.housingform,chr(13),''),chr(10),'') as housingform --房屋形式
,t1.fitmentprice as fitmentprice --装修总价
,replace(replace(t1.repayinterval,chr(13),''),chr(10),'') as repayinterval --归还本金间隔
,replace(replace(t1.indtype,chr(13),''),chr(10),'') as indtype --客户性质
,replace(replace(t1.taxcode,chr(13),''),chr(10),'') as taxcode --纳税人识别号
,t1.buildingunitprice as buildingunitprice --建筑面积单价
,replace(replace(t1.vehicletype,chr(13),''),chr(10),'') as vehicletype --车型
,t1.availexposure as availexposure --集团客户名称
,replace(replace(t1.companyid,chr(13),''),chr(10),'') as companyid --公司客户编号
,t1.graceperiod as graceperiod --宽限期（天）
,replace(replace(t1.personalbusinessloanstype,chr(13),''),chr(10),'') as personalbusinessloanstype --个人经营性贷款分类
,replace(replace(t1.isloananytime,chr(13),''),chr(10),'') as isloananytime --是否随借随还
,replace(replace(t1.housingaddress,chr(13),''),chr(10),'') as housingaddress --房屋详址
,t1.repayratio as repayratio --归还本金比例
,replace(replace(t1.signaddr,chr(13),''),chr(10),'') as signaddr --签署地
,replace(replace(t1.evaluationcerttype,chr(13),''),chr(10),'') as evaluationcerttype --评估证件类型
,replace(replace(t1.paymentobject,chr(13),''),chr(10),'') as paymentobject --支付对象
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype --借款人证件类型
,replace(replace(t1.relycompanyname,chr(13),''),chr(10),'') as relycompanyname --自家/挂靠企业名称
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype --支付方式
,replace(replace(t1.feepayment,chr(13),''),chr(10),'') as feepayment --手续费支付方式
,replace(replace(t1.paymentbasis,chr(13),''),chr(10),'') as paymentbasis --首付款依据
,t1.propertyunitprice as propertyunitprice --物管费单价
,replace(replace(t1.compcertid,chr(13),''),chr(10),'') as compcertid --企业证件号码
,replace(replace(t1.groupcustcode,chr(13),''),chr(10),'') as groupcustcode --是否集团客户
,replace(replace(t1.payeeaccountno,chr(13),''),chr(10),'') as payeeaccountno --收款人帐号
,replace(replace(t1.isinsurance,chr(13),''),chr(10),'') as isinsurance --是否购买保险
,replace(replace(t1.isopenentsettleaccounts,chr(13),''),chr(10),'') as isopenentsettleaccounts --是否能够开立单位结算账户
,replace(replace(t1.compcerttype,chr(13),''),chr(10),'') as compcerttype --企业证件类型
,t1.vehicleprice as vehicleprice --汽车总价
,replace(replace(t1.housinglevel,chr(13),''),chr(10),'') as housinglevel --房屋等级
,replace(replace(t1.isbusinessguarantee,chr(13),''),chr(10),'') as isbusinessguarantee --是否合作机构/开发商/经销商担保
,replace(replace(t1.localstrategicindustry,chr(13),''),chr(10),'') as localstrategicindustry --本地战略性新兴产业
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.cusgruoprelation,chr(13),''),chr(10),'') as cusgruoprelation --借款人与集团关系
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid --法人机构编号
,replace(replace(t1.relycompanycreditno,chr(13),''),chr(10),'') as relycompanycreditno --自家/挂靠企业统一社会信用代码
,t1.baserateadjustper as baserateadjustper --基准利率上浮比例
,t1.feeratio as feeratio --手续费率
,replace(replace(t1.companyquotacontrol,chr(13),''),chr(10),'') as companyquotacontrol --是否公司额度管控
,t1.suitesarea as suitesarea --购房面积（套内面积）
,replace(replace(t1.isaddamt,chr(13),''),chr(10),'') as isaddamt --是否提额
,replace(replace(t1.groupcustname,chr(13),''),chr(10),'') as groupcustname --集团客户号
,t1.buildingarea as buildingarea --购房面积（建筑面积）
,t1.creditscore as creditscore --机评信用等级
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,t1.paymentratio as paymentratio --首付比例
,replace(replace(t1.loandirection,chr(13),''),chr(10),'') as loandirection --资金投向
,replace(replace(t1.groupcustomername,chr(13),''),chr(10),'') as groupcustomername --集团客户名称
,replace(replace(t1.isjgaccount,chr(13),''),chr(10),'') as isjgaccount --是否在我行开立监管账户
,replace(replace(t1.creditimageupflag,chr(13),''),chr(10),'') as creditimageupflag --征信授权书影像上传结果1完成上传2未完成上传
,replace(replace(t1.creditincrmode,chr(13),''),chr(10),'') as creditincrmode --增信模式标志
,replace(replace(t1.referrerid,chr(13),''),chr(10),'') as referrerid --推荐人id
,replace(replace(t1.iswthrmanuactclmt,chr(13),''),chr(10),'') as iswthrmanuactclmt --是否人工激活额度yesno
,replace(replace(t1.recheckflag,chr(13),''),chr(10),'') as recheckflag --复核标识yesno
,replace(replace(t1.consignerid,chr(13),''),chr(10),'') as consignerid --委托人id
,replace(replace(t1.ishouseinguangdong,chr(13),''),chr(10),'') as ishouseinguangdong --委托人id
,replace(replace(t1.worktype,chr(13),''),chr(10),'') as worktype --委托人id
,replace(replace(t1.bigloanpurpose,chr(13),''),chr(10),'') as bigloanpurpose --贷款用途大类
,replace(replace(t1.title,chr(13),''),chr(10),'') as title --标题
,replace(replace(t1.riskcontrolback,chr(13),''),chr(10),'') as riskcontrolback --风控背景
,t1.cuscreditscore as cuscreditscore --客户信用分数:内评
,replace(replace(t1.cuscreditscorelevel,chr(13),''),chr(10),'') as cuscreditscorelevel --客户信用分数等级
,replace(replace(t1.cartype,chr(13),''),chr(10),'') as cartype --车辆类型
,replace(replace(t1.greenloanpurpose,chr(13),''),chr(10),'') as greenloanpurpose --绿色贷款用途
,replace(replace(t1.companytype,chr(13),''),chr(10),'') as companytype --企业规模
,t1.employments as employments --从业人员
,t1.busiincome as busiincome --营业收入
,t1.assetstotal as assetstotal --资产总额
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry --所属行业
,replace(replace(t1.custcreditlevel,chr(13),''),chr(10),'') as custcreditlevel --客户风险等级
,replace(replace(t1.loanpurposedetails,chr(13),''),chr(10),'') as loanpurposedetails --贷款用途细类字段
,replace(replace(t1.highindustry,chr(13),''),chr(10),'') as highindustry --高技术产业
,replace(replace(t1.economyindustry,chr(13),''),chr(10),'') as economyindustry --数字经济核心产业
,replace(replace(t1.intellectualindustry,chr(13),''),chr(10),'') as intellectualindustry --投向知识产权密集型产业
,replace(replace(t1.cultureindustry,chr(13),''),chr(10),'') as cultureindustry --投向文化及相关产业
,replace(replace(t1.isagriculture,chr(13),''),chr(10),'') as isagriculture --是否涉农
,replace(replace(t1.strategicindustry,chr(13),''),chr(10),'') as strategicindustry --
,replace(replace(t1.custlabel,chr(13),''),chr(10),'') as custlabel --
,replace(replace(t1.warninginfo,chr(13),''),chr(10),'') as warninginfo --预警信息
,replace(replace(t1.subgreenconsumeloanpurpose,chr(13),''),chr(10),'') as subgreenconsumeloanpurpose --绿色消费子类
,replace(replace(t1.isoperatingentinvolvespecialized,chr(13),''),chr(10),'') as isoperatingentinvolvespecialized --经营企业是否涉及专精特新
,replace(replace(t1.ishightechnologyent,chr(13),''),chr(10),'') as ishightechnologyent --是否高新技术企业
,replace(replace(t1.istechnologyent,chr(13),''),chr(10),'') as istechnologyent --是否科技型企业
,replace(replace(t1.isscientifictechent,chr(13),''),chr(10),'') as isscientifictechent --是否科创企业
,replace(replace(t1.isspecializedgiantent,chr(13),''),chr(10),'') as isspecializedgiantent --是否专精特新“小巨人”企业
,replace(replace(t1.isspecializedsmallandmident,chr(13),''),chr(10),'') as isspecializedsmallandmident --是否“专精特新”中小企业
,replace(replace(t1.istechnologysmallandmident,chr(13),''),chr(10),'') as istechnologysmallandmident --是否科技型中小企业
,replace(replace(t1.isindustrysinglechampionent,chr(13),''),chr(10),'') as isindustrysinglechampionent --是否制造业单项冠军企业
,replace(replace(t1.isnationaltechnologinnovationent,chr(13),''),chr(10),'') as isnationaltechnologinnovationent --是否国家技术创新示范企业
,replace(replace(t1.isgarden,chr(13),''),chr(10),'') as isgarden --是否园区贷
,replace(replace(t1.productchannel,chr(13),''),chr(10),'') as productchannel --产品渠道标识
,replace(replace(t1.iscentralizedofficestaff,chr(13),''),chr(10),'') as iscentralizedofficestaff --合同制作人员（集中办公人员/本人）
,t1.cobsratio as cobsratio --持股比例
,t1.workingmonth as workingmonth --从业期限月
,replace(replace(t1.flowbranchtype,chr(13),''),chr(10),'') as flowbranchtype --流程分支类型
,replace(replace(t1.isicmsfactory,chr(13),''),chr(10),'') as isicmsfactory --信贷工厂模式（01-是,02-否,03-无）
,replace(replace(t1.guaranteecompanyname,chr(13),''),chr(10),'') as guaranteecompanyname --见保即贷业务担保公司
,t1.runentyearincome as runentyearincome --流水推算的年销售收入
,t1.lastyearentyearincome as lastyearentyearincome --纳税申报资料反映的上年度收入
,t1.yearincomerate as yearincomerate --预计销售收入年增长率
,t1.operationloanbalanceskr as operationloanbalanceskr --实控人经营性贷款余额
,t1.otherworkcaptial as otherworkcaptial --其他渠道提供的营运资金
,replace(replace(t1.isrelatedcompany,chr(13),''),chr(10),'') as isrelatedcompany --借款企业是否为担保公司的关联企业:1是0否
,t1.intentguaramt as intentguaramt --意向担保金额
,t1.guarcompanyterm as guarcompanyterm --
,replace(replace(t1.comptaxgrade,chr(13),''),chr(10),'') as comptaxgrade --企业纳税等级
,replace(replace(t1.iscompanyrelatedperson,chr(13),''),chr(10),'') as iscompanyrelatedperson --是否担保公司关联人
,t1.recommendedamt as recommendedamt --担保公司推荐金额
,t1.recommendedterm as recommendedterm --
,replace(replace(t1.otherlimitflag,chr(13),''),chr(10),'') as otherlimitflag --是否占用他用额度
from ${iol_schema}.icms_ba_personal_loan t1    --申请个人贷款业务附属表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_ba_personal_loan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
