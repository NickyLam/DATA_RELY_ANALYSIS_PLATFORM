/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_ba_cl_info
CreateDate: 20250612
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_ba_cl_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_ba_cl_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_ba_cl_info (
etl_dt  --数据日期
,serialno  --流水号
,outclassifydate  --外部评级日期
,totalsumentpart  --公司敞口金额(元)
,dlcdbz  --代理参贷标志
,investtarget  --投资标的
,othercondition  --额度使用条件
,iscreditincrement  --是否有增信
,hxtymainratelevel  --外部主体评级
,migtflag  --迁移标志：crs rcr ilc upl
,channelname  --通道方名称
,isbillapply  --是否新增银承额度专项贴现
,refbankname  --参贷行行号
,isgovernfinance  --是否涉及政府类融资
,lngotimes  --借新还旧次数
,mainlevelorg  --主体评级机构
,singlebizmostamount  --额度下业务单笔最大金额
,riskexposuresum  --其中，一般风险敞口限额
,nominalsum  --额度名义金额
,isestatefinance  --是否涉及房地产融资
,bizextendedterm  --额度下业务延展期限月)
,availableexposuresum  --可用敞口金额
,islikeloan  --是否类信贷
,publishsum  --本次发行金额
,bizmostmortgagerate  --额度下业务最高抵质押率
,isfinancialcredit  --是否商圈授信
,investway  --投资方式
,fundsource  --资金来源
,playtype  --参与方式
,termtype  --期限申请类型额度)
,lineclass  --额度种类综合/专项/其他)
,suremodel  --是否总行认定模式
,managename  --管理人名称
,manageid  --管理人客户号
,istrans  --是否转授信
,belonggroupapproveno  --集团批复编号
,financialcreditowner  --集群客户专项额度所有人
,issmeandretail  --是否我行小微企业并且走零售条线
,originalname  --原始权益人名称
,ispubliccredit  --是否公开授信额度)
,occupynominalsum  --已用授信额度
,moneyindustryt  --资金投向行业
,bizbailinitialrate  --额度下业务初始保证金比例
,transcount  --交易对手个数
,maxnominalamount  --单一最高授信额度名义金额
,lowriskexposuresum  --其中，类低风险敞口金额(元)
,bizlowestfloatrate  --额度下业务利率最低浮动
,occupyexposuresum  --已用敞口金额自动计算)
,totalsumtypart  --同业敞口金额(元)
,linecontrolmode  --集团额度管控模式超额分配/全额分配)
,latestusedate  --额度最迟使用日期
,isgreenfinance  --是否为绿色信贷融资
,otherlimitownerid  --他用额度所有人
,availablenominalsum  --可用名义金额
,hostbankname  --主办行行名
,authvouchtype  --授权权限_担保方式
,isquerycreditreport  --是否自动查询贷后报告
,mainleveldate  --主体评级日期
,usewithoutcondition  --能否直接使用额度)
,isbeltroadfinance  --是否为一带一路建设投融资
,otherlimittype  --他用额度类型
,sqdkze  --申请银团贷款总额(元)
,outclassifylevel  --外部债项评级
,jxhjcontractno  --借新还旧原合同
,businesssumentpart  --公司授信额度(元)
,currencyrange  --项下业务币种范围
,isconsumerfinance  --是否为消费服务类融资
,drtimes  --债务重组次数
,exposuresum  --额度敞口金额
,classifyresulteleven  --债项分类
,issuername  --发行人名称
,financialcreditserialno  --集群客户专项额度流水号
,hxtyoperateorg  --归口管理部门
,issme  --是否小微企业贷款
,hostbankno  --主办行行号
,agentbankname  --代理行行号
,otherlimitno  --他用额度流水号
,creditauthno  --征信授权影像流水号
,agentbankno  --代理行行号
,approvepubsum  --批准发行总额
,outclassifyorg  --外部评级机构名称
,creditarea  --授信区域
,publicorg  --发行场所
,isyhcustomer  --是否优合授信客户
,onlineamount  --线上额度(元)
,refbankno  --参贷行行号
,otherlimitflag  --是否占用他用额度
,hxtyclassifylevel  --债项分类
,businesssumtypart  --同业授信额度(元)
,authostrdate  --授权起始日
,bizlongestterm  --额度下业务最长期限月)
,financialmodel  --集群客户操作模式、风险管理及控制方案
,channelid  --通道方编号
,maxexposureamount  --单一最高授信额度敞口金额
,changetype  --变更原因
,originalid  --原始权益人编号
,issuernameid  --发行人编号
,phaseopinion  --主动批量-授信方案意见
,finishflag  --主动批量-授信方案确认标志
,ispenetrate  --是否可穿透
,ifapprove  --是否人工填写标志
,afterpayreq  --发放与支付前须落实的特殊限制性条件
,contractreq  --需落实到合同、协议中的特殊要求
,islikelowrisk  --是否类低风险
,loanmanagereq  --贷后管理要求
,payreq  --授信方案
,focuslendtype  --集中放款业务类型
,isinnovate  --是否创新业务
,issupplychainfinance  --是否供应链金融业务
,isprojectfinancing  --是否项目融资
,custraterisklevel  --客户内评评级结果
,onlineapprovallimit  --线上审批额度
,oastatus  --OA审批状态
,isjoinlimits  --是否纳入单一客户或集团的限额
,otherlimitamount  --他用额度占用金额
,proborrowerattr  --借款人属性
,proborrowerincome  --借款人收入特征
,proborrowerdebt  --借款人偿债特征
,proassetscontrol  --资产控制
,prorevenuecontrol  --收入控制
,projfinancingtype  --项目融资类型
,mercfinancingobject  --商品融资对象
,itemsfinancingtype  --物品融资类型
,isonlineapprove  --是否线上化审批
,guaranteecompanyname  --见保即贷业务担保公司
,runentyearincome  --流水推算的年销售收入
,lastyearentyearincome  --纳税申报资料反映的上年度收入
,yearincomerate  --预计销售收入年增长率
,operationloanbalanceskr  --实控人经营性贷款余额
,otherworkcaptial  --其他渠道提供的营运资金
,isrelatedcompany  --借款企业是否为担保公司的关联企业:1是0否
,subjectbusiness  --主营业务
,enterpriseamt  --借款企业在我行有效额度
,riskapproveamout  --风控最终审批金额
,riskapprovestatus  --风控最终状态
,riskterm  --风控最终审批期限
,isbranchbusiness  --是否分行权限内业务
,bondingcompanyinamt  --意向担保金额
,guarcompanyterm  --
,comptaxgrade  --企业纳税等级
,ishxdanbaoloan  --是否为华兴担保贷:1-是0-否

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --流水号
,replace(replace(t1.outclassifydate,chr(13),''),chr(10),'') as outclassifydate --外部评级日期
,t1.totalsumentpart as totalsumentpart --公司敞口金额(元)
,replace(replace(t1.dlcdbz,chr(13),''),chr(10),'') as dlcdbz --代理参贷标志
,replace(replace(t1.investtarget,chr(13),''),chr(10),'') as investtarget --投资标的
,replace(replace(t1.othercondition,chr(13),''),chr(10),'') as othercondition --额度使用条件
,replace(replace(t1.iscreditincrement,chr(13),''),chr(10),'') as iscreditincrement --是否有增信
,replace(replace(t1.hxtymainratelevel,chr(13),''),chr(10),'') as hxtymainratelevel --外部主体评级
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.channelname,chr(13),''),chr(10),'') as channelname --通道方名称
,replace(replace(t1.isbillapply,chr(13),''),chr(10),'') as isbillapply --是否新增银承额度专项贴现
,replace(replace(t1.refbankname,chr(13),''),chr(10),'') as refbankname --参贷行行号
,replace(replace(t1.isgovernfinance,chr(13),''),chr(10),'') as isgovernfinance --是否涉及政府类融资
,t1.lngotimes as lngotimes --借新还旧次数
,replace(replace(t1.mainlevelorg,chr(13),''),chr(10),'') as mainlevelorg --主体评级机构
,t1.singlebizmostamount as singlebizmostamount --额度下业务单笔最大金额
,t1.riskexposuresum as riskexposuresum --其中，一般风险敞口限额
,t1.nominalsum as nominalsum --额度名义金额
,replace(replace(t1.isestatefinance,chr(13),''),chr(10),'') as isestatefinance --是否涉及房地产融资
,t1.bizextendedterm as bizextendedterm --额度下业务延展期限月)
,t1.availableexposuresum as availableexposuresum --可用敞口金额
,replace(replace(t1.islikeloan,chr(13),''),chr(10),'') as islikeloan --是否类信贷
,t1.publishsum as publishsum --本次发行金额
,t1.bizmostmortgagerate as bizmostmortgagerate --额度下业务最高抵质押率
,replace(replace(t1.isfinancialcredit,chr(13),''),chr(10),'') as isfinancialcredit --是否商圈授信
,replace(replace(t1.investway,chr(13),''),chr(10),'') as investway --投资方式
,replace(replace(t1.fundsource,chr(13),''),chr(10),'') as fundsource --资金来源
,replace(replace(t1.playtype,chr(13),''),chr(10),'') as playtype --参与方式
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype --期限申请类型额度)
,replace(replace(t1.lineclass,chr(13),''),chr(10),'') as lineclass --额度种类综合/专项/其他)
,replace(replace(t1.suremodel,chr(13),''),chr(10),'') as suremodel --是否总行认定模式
,replace(replace(t1.managename,chr(13),''),chr(10),'') as managename --管理人名称
,replace(replace(t1.manageid,chr(13),''),chr(10),'') as manageid --管理人客户号
,replace(replace(t1.istrans,chr(13),''),chr(10),'') as istrans --是否转授信
,replace(replace(t1.belonggroupapproveno,chr(13),''),chr(10),'') as belonggroupapproveno --集团批复编号
,replace(replace(t1.financialcreditowner,chr(13),''),chr(10),'') as financialcreditowner --集群客户专项额度所有人
,replace(replace(t1.issmeandretail,chr(13),''),chr(10),'') as issmeandretail --是否我行小微企业并且走零售条线
,replace(replace(t1.originalname,chr(13),''),chr(10),'') as originalname --原始权益人名称
,replace(replace(t1.ispubliccredit,chr(13),''),chr(10),'') as ispubliccredit --是否公开授信额度)
,t1.occupynominalsum as occupynominalsum --已用授信额度
,replace(replace(t1.moneyindustryt,chr(13),''),chr(10),'') as moneyindustryt --资金投向行业
,t1.bizbailinitialrate as bizbailinitialrate --额度下业务初始保证金比例
,replace(replace(t1.transcount,chr(13),''),chr(10),'') as transcount --交易对手个数
,t1.maxnominalamount as maxnominalamount --单一最高授信额度名义金额
,t1.lowriskexposuresum as lowriskexposuresum --其中，类低风险敞口金额(元)
,t1.bizlowestfloatrate as bizlowestfloatrate --额度下业务利率最低浮动
,t1.occupyexposuresum as occupyexposuresum --已用敞口金额自动计算)
,t1.totalsumtypart as totalsumtypart --同业敞口金额(元)
,replace(replace(t1.linecontrolmode,chr(13),''),chr(10),'') as linecontrolmode --集团额度管控模式超额分配/全额分配)
,t1.latestusedate as latestusedate --额度最迟使用日期
,replace(replace(t1.isgreenfinance,chr(13),''),chr(10),'') as isgreenfinance --是否为绿色信贷融资
,replace(replace(t1.otherlimitownerid,chr(13),''),chr(10),'') as otherlimitownerid --他用额度所有人
,t1.availablenominalsum as availablenominalsum --可用名义金额
,replace(replace(t1.hostbankname,chr(13),''),chr(10),'') as hostbankname --主办行行名
,replace(replace(t1.authvouchtype,chr(13),''),chr(10),'') as authvouchtype --授权权限_担保方式
,replace(replace(t1.isquerycreditreport,chr(13),''),chr(10),'') as isquerycreditreport --是否自动查询贷后报告
,replace(replace(t1.mainleveldate,chr(13),''),chr(10),'') as mainleveldate --主体评级日期
,replace(replace(t1.usewithoutcondition,chr(13),''),chr(10),'') as usewithoutcondition --能否直接使用额度)
,replace(replace(t1.isbeltroadfinance,chr(13),''),chr(10),'') as isbeltroadfinance --是否为一带一路建设投融资
,replace(replace(t1.otherlimittype,chr(13),''),chr(10),'') as otherlimittype --他用额度类型
,t1.sqdkze as sqdkze --申请银团贷款总额(元)
,replace(replace(t1.outclassifylevel,chr(13),''),chr(10),'') as outclassifylevel --外部债项评级
,replace(replace(t1.jxhjcontractno,chr(13),''),chr(10),'') as jxhjcontractno --借新还旧原合同
,t1.businesssumentpart as businesssumentpart --公司授信额度(元)
,replace(replace(t1.currencyrange,chr(13),''),chr(10),'') as currencyrange --项下业务币种范围
,replace(replace(t1.isconsumerfinance,chr(13),''),chr(10),'') as isconsumerfinance --是否为消费服务类融资
,t1.drtimes as drtimes --债务重组次数
,t1.exposuresum as exposuresum --额度敞口金额
,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'') as classifyresulteleven --债项分类
,replace(replace(t1.issuername,chr(13),''),chr(10),'') as issuername --发行人名称
,replace(replace(t1.financialcreditserialno,chr(13),''),chr(10),'') as financialcreditserialno --集群客户专项额度流水号
,replace(replace(t1.hxtyoperateorg,chr(13),''),chr(10),'') as hxtyoperateorg --归口管理部门
,replace(replace(t1.issme,chr(13),''),chr(10),'') as issme --是否小微企业贷款
,replace(replace(t1.hostbankno,chr(13),''),chr(10),'') as hostbankno --主办行行号
,replace(replace(t1.agentbankname,chr(13),''),chr(10),'') as agentbankname --代理行行号
,replace(replace(t1.otherlimitno,chr(13),''),chr(10),'') as otherlimitno --他用额度流水号
,replace(replace(t1.creditauthno,chr(13),''),chr(10),'') as creditauthno --征信授权影像流水号
,replace(replace(t1.agentbankno,chr(13),''),chr(10),'') as agentbankno --代理行行号
,t1.approvepubsum as approvepubsum --批准发行总额
,replace(replace(t1.outclassifyorg,chr(13),''),chr(10),'') as outclassifyorg --外部评级机构名称
,replace(replace(t1.creditarea,chr(13),''),chr(10),'') as creditarea --授信区域
,replace(replace(t1.publicorg,chr(13),''),chr(10),'') as publicorg --发行场所
,replace(replace(t1.isyhcustomer,chr(13),''),chr(10),'') as isyhcustomer --是否优合授信客户
,t1.onlineamount as onlineamount --线上额度(元)
,replace(replace(t1.refbankno,chr(13),''),chr(10),'') as refbankno --参贷行行号
,replace(replace(t1.otherlimitflag,chr(13),''),chr(10),'') as otherlimitflag --是否占用他用额度
,replace(replace(t1.hxtyclassifylevel,chr(13),''),chr(10),'') as hxtyclassifylevel --债项分类
,t1.businesssumtypart as businesssumtypart --同业授信额度(元)
,t1.authostrdate as authostrdate --授权起始日
,t1.bizlongestterm as bizlongestterm --额度下业务最长期限月)
,replace(replace(t1.financialmodel,chr(13),''),chr(10),'') as financialmodel --集群客户操作模式、风险管理及控制方案
,replace(replace(t1.channelid,chr(13),''),chr(10),'') as channelid --通道方编号
,t1.maxexposureamount as maxexposureamount --单一最高授信额度敞口金额
,replace(replace(t1.changetype,chr(13),''),chr(10),'') as changetype --变更原因
,replace(replace(t1.originalid,chr(13),''),chr(10),'') as originalid --原始权益人编号
,replace(replace(t1.issuernameid,chr(13),''),chr(10),'') as issuernameid --发行人编号
,replace(replace(t1.phaseopinion,chr(13),''),chr(10),'') as phaseopinion --主动批量-授信方案意见
,replace(replace(t1.finishflag,chr(13),''),chr(10),'') as finishflag --主动批量-授信方案确认标志
,replace(replace(t1.ispenetrate,chr(13),''),chr(10),'') as ispenetrate --是否可穿透
,replace(replace(t1.ifapprove,chr(13),''),chr(10),'') as ifapprove --是否人工填写标志
,replace(replace(t1.afterpayreq,chr(13),''),chr(10),'') as afterpayreq --发放与支付前须落实的特殊限制性条件
,replace(replace(t1.contractreq,chr(13),''),chr(10),'') as contractreq --需落实到合同、协议中的特殊要求
,replace(replace(t1.islikelowrisk,chr(13),''),chr(10),'') as islikelowrisk --是否类低风险
,replace(replace(t1.loanmanagereq,chr(13),''),chr(10),'') as loanmanagereq --贷后管理要求
,replace(replace(t1.payreq,chr(13),''),chr(10),'') as payreq --授信方案
,replace(replace(t1.focuslendtype,chr(13),''),chr(10),'') as focuslendtype --集中放款业务类型
,replace(replace(t1.isinnovate,chr(13),''),chr(10),'') as isinnovate --是否创新业务
,replace(replace(t1.issupplychainfinance,chr(13),''),chr(10),'') as issupplychainfinance --是否供应链金融业务
,replace(replace(t1.isprojectfinancing,chr(13),''),chr(10),'') as isprojectfinancing --是否项目融资
,replace(replace(t1.custraterisklevel,chr(13),''),chr(10),'') as custraterisklevel --客户内评评级结果
,t1.onlineapprovallimit as onlineapprovallimit --线上审批额度
,replace(replace(t1.oastatus,chr(13),''),chr(10),'') as oastatus --OA审批状态
,replace(replace(t1.isjoinlimits,chr(13),''),chr(10),'') as isjoinlimits --是否纳入单一客户或集团的限额
,t1.otherlimitamount as otherlimitamount --他用额度占用金额
,replace(replace(t1.proborrowerattr,chr(13),''),chr(10),'') as proborrowerattr --借款人属性
,replace(replace(t1.proborrowerincome,chr(13),''),chr(10),'') as proborrowerincome --借款人收入特征
,replace(replace(t1.proborrowerdebt,chr(13),''),chr(10),'') as proborrowerdebt --借款人偿债特征
,replace(replace(t1.proassetscontrol,chr(13),''),chr(10),'') as proassetscontrol --资产控制
,replace(replace(t1.prorevenuecontrol,chr(13),''),chr(10),'') as prorevenuecontrol --收入控制
,replace(replace(t1.projfinancingtype,chr(13),''),chr(10),'') as projfinancingtype --项目融资类型
,replace(replace(t1.mercfinancingobject,chr(13),''),chr(10),'') as mercfinancingobject --商品融资对象
,replace(replace(t1.itemsfinancingtype,chr(13),''),chr(10),'') as itemsfinancingtype --物品融资类型
,replace(replace(t1.isonlineapprove,chr(13),''),chr(10),'') as isonlineapprove --是否线上化审批
,replace(replace(t1.guaranteecompanyname,chr(13),''),chr(10),'') as guaranteecompanyname --见保即贷业务担保公司
,t1.runentyearincome as runentyearincome --流水推算的年销售收入
,t1.lastyearentyearincome as lastyearentyearincome --纳税申报资料反映的上年度收入
,replace(replace(t1.yearincomerate,chr(13),''),chr(10),'') as yearincomerate --预计销售收入年增长率
,t1.operationloanbalanceskr as operationloanbalanceskr --实控人经营性贷款余额
,t1.otherworkcaptial as otherworkcaptial --其他渠道提供的营运资金
,replace(replace(t1.isrelatedcompany,chr(13),''),chr(10),'') as isrelatedcompany --借款企业是否为担保公司的关联企业:1是0否
,replace(replace(t1.subjectbusiness,chr(13),''),chr(10),'') as subjectbusiness --主营业务
,t1.enterpriseamt as enterpriseamt --借款企业在我行有效额度
,t1.riskapproveamout as riskapproveamout --风控最终审批金额
,replace(replace(t1.riskapprovestatus,chr(13),''),chr(10),'') as riskapprovestatus --风控最终状态
,t1.riskterm as riskterm --风控最终审批期限
,replace(replace(t1.isbranchbusiness,chr(13),''),chr(10),'') as isbranchbusiness --是否分行权限内业务
,t1.bondingcompanyinamt as bondingcompanyinamt --意向担保金额
,t1.guarcompanyterm as guarcompanyterm --
,replace(replace(t1.comptaxgrade,chr(13),''),chr(10),'') as comptaxgrade --企业纳税等级
,replace(replace(t1.ishxdanbaoloan,chr(13),''),chr(10),'') as ishxdanbaoloan --是否为华兴担保贷:1-是0-否
from ${iol_schema}.icms_ba_cl_info t1    --授信申请附属表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_ba_cl_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
