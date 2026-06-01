/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bap_cl_info
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
create table ${iol_schema}.icms_bap_cl_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bap_cl_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bap_cl_info_op purge;
drop table ${iol_schema}.icms_bap_cl_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bap_cl_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bap_cl_info where 0=1;

create table ${iol_schema}.icms_bap_cl_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bap_cl_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bap_cl_info_cl(
            serialno -- 流水号
            ,refbankname -- 参贷行行号
            ,agentbankname -- 代理行行号
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,nominalsum -- 额度名义金额
            ,landusecertid -- 国有土地使用证号
            ,thirdpartyzip1 -- 公积金贷款手续费比例%
            ,outclassifyorg -- 外部评级机构
            ,creditarea -- 授信区域
            ,isbillapply -- 是否新增银承额度专项贴现
            ,hostbankno -- 主办行行号
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,totalsumtypart -- 同业敞口金额(元)
            ,businesssumentpart -- 公司额度金额(元)
            ,mainlevelorg -- 主体评级机构
            ,otherlimittype -- 他用额度类型
            ,approveopinion -- 最终审批意见
            ,describe2 -- 项目座落位置
            ,fundsource -- 资金来源
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupynominalsum -- 已用名义金额自动计算)
            ,belonggroupapproveno -- 集团批复编号
            ,lngotimes -- 借新还旧次数
            ,playtype -- 参与方式
            ,flag1 -- 是否为项下业务提供保证担保
            ,investway -- 投资方式
            ,hxtyoperateorg -- 归口管理部门
            ,isfinancialcredit -- 是否商圈授信
            ,sqdkze -- 申请银团贷款总额(元)
            ,constructionarea -- 项目总面积（平方米）
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,drtimes -- 债务重组次数
            ,usewithoutcondition -- 能否直接使用额度)
            ,othercondition -- 额度使用条件\集群客户授信方案
            ,creditauthno -- 征信授权影像流水号
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,rateopinion -- 客户评级
            ,hxtyclassifylevel -- 债项分类
            ,lineclass -- 额度种类综合/专项/其他)
            ,refbankno -- 参贷行行号
            ,thirdpartyid1 -- 建设用地规划可证号
            ,thirdpartyid2 -- 建设工程规划许可证号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,termtype -- 期限申请类型额度)
            ,outclassifydate -- 外部评级日期
            ,iscreditincrement -- 是否有增信
            ,dlcdbz -- 代理参贷标志
            ,publishsum -- 本次发行金额
            ,availablenominalsum -- 可用名义金额
            ,availableexposuresum -- 可用敞口金额
            ,otherlimitno -- 他用额度流水号
            ,totalsumentpart -- 公司敞口金额(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,agentbankno -- 代理行行号
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,otherlimitownerid -- 他用额度所有人
            ,thirdparty1 -- 销(预)售许可证号
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,issme -- 是否小微企业贷款
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,bizextendedterm -- 额度下业务延展期限月)
            ,otherlimitflag -- 是否占用他用额度
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,currencyrange -- 项下业务币种范围
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,isyeartocheck -- 是否需要年审
            ,isgreenfinance -- 是否为绿色信贷融资
            ,outclassifylevel -- 外部债项评级
            ,investtarget -- 投资标的
            ,approvepubsum -- 批准发行总额
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,bailratio -- 保证金比例%
            ,bailsum -- 保证金金额（元）
            ,transcount -- 交易对手个数
            ,hxtymainratelevel -- 外部主体评级
            ,businesssumtypart -- 同业额度金额(元)
            ,islikeloan -- 是否类信贷
            ,authvouchtype -- 授权权限_担保方式
            ,approveopinion6 -- 贷后要求
            ,projectname -- 项目名称
            ,publicorg -- 发行场所
            ,termday -- 零（天）
            ,thirdpartyid3 -- 最高成数%
            ,migtflag -- 
            ,thirdpartyadd1 -- 最长期限(年)
            ,isestatefinance -- 是否涉及房地产融资
            ,financialcreditowner -- 集群客户专项额度所有人
            ,approveopinion1 -- 最终审批意见2
            ,approvedate -- 批复日期
            ,isyhcustomer -- 是否优合授信客户
            ,exposuresum -- 额度敞口金额
            ,sqcheckyeardate -- 上期年审日期
            ,describe1 -- 项下业务主要担保方式
            ,thirdparty3 -- 建筑工程施工可证号
            ,hostbankname -- 主办行行名
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,latestusedate -- 额度最迟使用日期
            ,flag2 -- 是否为项下业务承担回购责任
            ,gurantymonth -- 担保期限(月)
            ,isgovernfinance -- 是否涉及政府类融资
            ,approveopinion7 -- 贷后要求补充说明
            ,bqcheckyeardate -- 本期年审日期
            ,onlineamount -- 线上额度(元)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,mainleveldate -- 主体评级日期
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ifapprove -- 是否人工填写标志
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,custraterisklevel -- 客户内评评级结果
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,antimoneylaunderlevel -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bap_cl_info_op(
            serialno -- 流水号
            ,refbankname -- 参贷行行号
            ,agentbankname -- 代理行行号
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,nominalsum -- 额度名义金额
            ,landusecertid -- 国有土地使用证号
            ,thirdpartyzip1 -- 公积金贷款手续费比例%
            ,outclassifyorg -- 外部评级机构
            ,creditarea -- 授信区域
            ,isbillapply -- 是否新增银承额度专项贴现
            ,hostbankno -- 主办行行号
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,totalsumtypart -- 同业敞口金额(元)
            ,businesssumentpart -- 公司额度金额(元)
            ,mainlevelorg -- 主体评级机构
            ,otherlimittype -- 他用额度类型
            ,approveopinion -- 最终审批意见
            ,describe2 -- 项目座落位置
            ,fundsource -- 资金来源
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupynominalsum -- 已用名义金额自动计算)
            ,belonggroupapproveno -- 集团批复编号
            ,lngotimes -- 借新还旧次数
            ,playtype -- 参与方式
            ,flag1 -- 是否为项下业务提供保证担保
            ,investway -- 投资方式
            ,hxtyoperateorg -- 归口管理部门
            ,isfinancialcredit -- 是否商圈授信
            ,sqdkze -- 申请银团贷款总额(元)
            ,constructionarea -- 项目总面积（平方米）
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,drtimes -- 债务重组次数
            ,usewithoutcondition -- 能否直接使用额度)
            ,othercondition -- 额度使用条件\集群客户授信方案
            ,creditauthno -- 征信授权影像流水号
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,rateopinion -- 客户评级
            ,hxtyclassifylevel -- 债项分类
            ,lineclass -- 额度种类综合/专项/其他)
            ,refbankno -- 参贷行行号
            ,thirdpartyid1 -- 建设用地规划可证号
            ,thirdpartyid2 -- 建设工程规划许可证号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,termtype -- 期限申请类型额度)
            ,outclassifydate -- 外部评级日期
            ,iscreditincrement -- 是否有增信
            ,dlcdbz -- 代理参贷标志
            ,publishsum -- 本次发行金额
            ,availablenominalsum -- 可用名义金额
            ,availableexposuresum -- 可用敞口金额
            ,otherlimitno -- 他用额度流水号
            ,totalsumentpart -- 公司敞口金额(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,agentbankno -- 代理行行号
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,otherlimitownerid -- 他用额度所有人
            ,thirdparty1 -- 销(预)售许可证号
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,issme -- 是否小微企业贷款
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,bizextendedterm -- 额度下业务延展期限月)
            ,otherlimitflag -- 是否占用他用额度
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,currencyrange -- 项下业务币种范围
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,isyeartocheck -- 是否需要年审
            ,isgreenfinance -- 是否为绿色信贷融资
            ,outclassifylevel -- 外部债项评级
            ,investtarget -- 投资标的
            ,approvepubsum -- 批准发行总额
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,bailratio -- 保证金比例%
            ,bailsum -- 保证金金额（元）
            ,transcount -- 交易对手个数
            ,hxtymainratelevel -- 外部主体评级
            ,businesssumtypart -- 同业额度金额(元)
            ,islikeloan -- 是否类信贷
            ,authvouchtype -- 授权权限_担保方式
            ,approveopinion6 -- 贷后要求
            ,projectname -- 项目名称
            ,publicorg -- 发行场所
            ,termday -- 零（天）
            ,thirdpartyid3 -- 最高成数%
            ,migtflag -- 
            ,thirdpartyadd1 -- 最长期限(年)
            ,isestatefinance -- 是否涉及房地产融资
            ,financialcreditowner -- 集群客户专项额度所有人
            ,approveopinion1 -- 最终审批意见2
            ,approvedate -- 批复日期
            ,isyhcustomer -- 是否优合授信客户
            ,exposuresum -- 额度敞口金额
            ,sqcheckyeardate -- 上期年审日期
            ,describe1 -- 项下业务主要担保方式
            ,thirdparty3 -- 建筑工程施工可证号
            ,hostbankname -- 主办行行名
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,latestusedate -- 额度最迟使用日期
            ,flag2 -- 是否为项下业务承担回购责任
            ,gurantymonth -- 担保期限(月)
            ,isgovernfinance -- 是否涉及政府类融资
            ,approveopinion7 -- 贷后要求补充说明
            ,bqcheckyeardate -- 本期年审日期
            ,onlineamount -- 线上额度(元)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,mainleveldate -- 主体评级日期
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ifapprove -- 是否人工填写标志
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,custraterisklevel -- 客户内评评级结果
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,antimoneylaunderlevel -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.refbankname, o.refbankname) as refbankname -- 参贷行行号
    ,nvl(n.agentbankname, o.agentbankname) as agentbankname -- 代理行行号
    ,nvl(n.linecontrolmode, o.linecontrolmode) as linecontrolmode -- 集团额度管控模式超额分配/全额分配)
    ,nvl(n.nominalsum, o.nominalsum) as nominalsum -- 额度名义金额
    ,nvl(n.landusecertid, o.landusecertid) as landusecertid -- 国有土地使用证号
    ,nvl(n.thirdpartyzip1, o.thirdpartyzip1) as thirdpartyzip1 -- 公积金贷款手续费比例%
    ,nvl(n.outclassifyorg, o.outclassifyorg) as outclassifyorg -- 外部评级机构
    ,nvl(n.creditarea, o.creditarea) as creditarea -- 授信区域
    ,nvl(n.isbillapply, o.isbillapply) as isbillapply -- 是否新增银承额度专项贴现
    ,nvl(n.hostbankno, o.hostbankno) as hostbankno -- 主办行行号
    ,nvl(n.bizmostmortgagerate, o.bizmostmortgagerate) as bizmostmortgagerate -- 额度下业务最高抵质押率
    ,nvl(n.totalsumtypart, o.totalsumtypart) as totalsumtypart -- 同业敞口金额(元)
    ,nvl(n.businesssumentpart, o.businesssumentpart) as businesssumentpart -- 公司额度金额(元)
    ,nvl(n.mainlevelorg, o.mainlevelorg) as mainlevelorg -- 主体评级机构
    ,nvl(n.otherlimittype, o.otherlimittype) as otherlimittype -- 他用额度类型
    ,nvl(n.approveopinion, o.approveopinion) as approveopinion -- 最终审批意见
    ,nvl(n.describe2, o.describe2) as describe2 -- 项目座落位置
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 资金来源
    ,nvl(n.bizlongestterm, o.bizlongestterm) as bizlongestterm -- 额度下业务最长期限月)
    ,nvl(n.occupynominalsum, o.occupynominalsum) as occupynominalsum -- 已用名义金额自动计算)
    ,nvl(n.belonggroupapproveno, o.belonggroupapproveno) as belonggroupapproveno -- 集团批复编号
    ,nvl(n.lngotimes, o.lngotimes) as lngotimes -- 借新还旧次数
    ,nvl(n.playtype, o.playtype) as playtype -- 参与方式
    ,nvl(n.flag1, o.flag1) as flag1 -- 是否为项下业务提供保证担保
    ,nvl(n.investway, o.investway) as investway -- 投资方式
    ,nvl(n.hxtyoperateorg, o.hxtyoperateorg) as hxtyoperateorg -- 归口管理部门
    ,nvl(n.isfinancialcredit, o.isfinancialcredit) as isfinancialcredit -- 是否商圈授信
    ,nvl(n.sqdkze, o.sqdkze) as sqdkze -- 申请银团贷款总额(元)
    ,nvl(n.constructionarea, o.constructionarea) as constructionarea -- 项目总面积（平方米）
    ,nvl(n.financialmodel, o.financialmodel) as financialmodel -- 集群客户操作模式、风险管理及控制方案
    ,nvl(n.drtimes, o.drtimes) as drtimes -- 债务重组次数
    ,nvl(n.usewithoutcondition, o.usewithoutcondition) as usewithoutcondition -- 能否直接使用额度)
    ,nvl(n.othercondition, o.othercondition) as othercondition -- 额度使用条件\集群客户授信方案
    ,nvl(n.creditauthno, o.creditauthno) as creditauthno -- 征信授权影像流水号
    ,nvl(n.manageid, o.manageid) as manageid -- 管理人客户号
    ,nvl(n.istrans, o.istrans) as istrans -- 是否转授信
    ,nvl(n.bizbailinitialrate, o.bizbailinitialrate) as bizbailinitialrate -- 额度下业务初始保证金比例
    ,nvl(n.rateopinion, o.rateopinion) as rateopinion -- 客户评级
    ,nvl(n.hxtyclassifylevel, o.hxtyclassifylevel) as hxtyclassifylevel -- 债项分类
    ,nvl(n.lineclass, o.lineclass) as lineclass -- 额度种类综合/专项/其他)
    ,nvl(n.refbankno, o.refbankno) as refbankno -- 参贷行行号
    ,nvl(n.thirdpartyid1, o.thirdpartyid1) as thirdpartyid1 -- 建设用地规划可证号
    ,nvl(n.thirdpartyid2, o.thirdpartyid2) as thirdpartyid2 -- 建设工程规划许可证号
    ,nvl(n.maxexposureamount, o.maxexposureamount) as maxexposureamount -- 单一最高授信额度敞口金额
    ,nvl(n.termtype, o.termtype) as termtype -- 期限申请类型额度)
    ,nvl(n.outclassifydate, o.outclassifydate) as outclassifydate -- 外部评级日期
    ,nvl(n.iscreditincrement, o.iscreditincrement) as iscreditincrement -- 是否有增信
    ,nvl(n.dlcdbz, o.dlcdbz) as dlcdbz -- 代理参贷标志
    ,nvl(n.publishsum, o.publishsum) as publishsum -- 本次发行金额
    ,nvl(n.availablenominalsum, o.availablenominalsum) as availablenominalsum -- 可用名义金额
    ,nvl(n.availableexposuresum, o.availableexposuresum) as availableexposuresum -- 可用敞口金额
    ,nvl(n.otherlimitno, o.otherlimitno) as otherlimitno -- 他用额度流水号
    ,nvl(n.totalsumentpart, o.totalsumentpart) as totalsumentpart -- 公司敞口金额(元)
    ,nvl(n.isconsumerfinance, o.isconsumerfinance) as isconsumerfinance -- 是否为消费服务类融资
    ,nvl(n.agentbankno, o.agentbankno) as agentbankno -- 代理行行号
    ,nvl(n.occupyexposuresum, o.occupyexposuresum) as occupyexposuresum -- 已用敞口金额自动计算)
    ,nvl(n.otherlimitownerid, o.otherlimitownerid) as otherlimitownerid -- 他用额度所有人
    ,nvl(n.thirdparty1, o.thirdparty1) as thirdparty1 -- 销(预)售许可证号
    ,nvl(n.issmeandretail, o.issmeandretail) as issmeandretail -- 是否我行小微企业并且走零售条线
    ,nvl(n.issme, o.issme) as issme -- 是否小微企业贷款
    ,nvl(n.maxnominalamount, o.maxnominalamount) as maxnominalamount -- 单一最高授信额度名义金额
    ,nvl(n.bizextendedterm, o.bizextendedterm) as bizextendedterm -- 额度下业务延展期限月)
    ,nvl(n.otherlimitflag, o.otherlimitflag) as otherlimitflag -- 是否占用他用额度
    ,nvl(n.bizlowestfloatrate, o.bizlowestfloatrate) as bizlowestfloatrate -- 额度下业务利率最低浮动
    ,nvl(n.currencyrange, o.currencyrange) as currencyrange -- 项下业务币种范围
    ,nvl(n.isquerycreditreport, o.isquerycreditreport) as isquerycreditreport -- 是否自动查询贷后报告
    ,nvl(n.isyeartocheck, o.isyeartocheck) as isyeartocheck -- 是否需要年审
    ,nvl(n.isgreenfinance, o.isgreenfinance) as isgreenfinance -- 是否为绿色信贷融资
    ,nvl(n.outclassifylevel, o.outclassifylevel) as outclassifylevel -- 外部债项评级
    ,nvl(n.investtarget, o.investtarget) as investtarget -- 投资标的
    ,nvl(n.approvepubsum, o.approvepubsum) as approvepubsum -- 批准发行总额
    ,nvl(n.financialcreditserialno, o.financialcreditserialno) as financialcreditserialno -- 集群客户专项额度流水号
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例%
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 保证金金额（元）
    ,nvl(n.transcount, o.transcount) as transcount -- 交易对手个数
    ,nvl(n.hxtymainratelevel, o.hxtymainratelevel) as hxtymainratelevel -- 外部主体评级
    ,nvl(n.businesssumtypart, o.businesssumtypart) as businesssumtypart -- 同业额度金额(元)
    ,nvl(n.islikeloan, o.islikeloan) as islikeloan -- 是否类信贷
    ,nvl(n.authvouchtype, o.authvouchtype) as authvouchtype -- 授权权限_担保方式
    ,nvl(n.approveopinion6, o.approveopinion6) as approveopinion6 -- 贷后要求
    ,nvl(n.projectname, o.projectname) as projectname -- 项目名称
    ,nvl(n.publicorg, o.publicorg) as publicorg -- 发行场所
    ,nvl(n.termday, o.termday) as termday -- 零（天）
    ,nvl(n.thirdpartyid3, o.thirdpartyid3) as thirdpartyid3 -- 最高成数%
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.thirdpartyadd1, o.thirdpartyadd1) as thirdpartyadd1 -- 最长期限(年)
    ,nvl(n.isestatefinance, o.isestatefinance) as isestatefinance -- 是否涉及房地产融资
    ,nvl(n.financialcreditowner, o.financialcreditowner) as financialcreditowner -- 集群客户专项额度所有人
    ,nvl(n.approveopinion1, o.approveopinion1) as approveopinion1 -- 最终审批意见2
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 批复日期
    ,nvl(n.isyhcustomer, o.isyhcustomer) as isyhcustomer -- 是否优合授信客户
    ,nvl(n.exposuresum, o.exposuresum) as exposuresum -- 额度敞口金额
    ,nvl(n.sqcheckyeardate, o.sqcheckyeardate) as sqcheckyeardate -- 上期年审日期
    ,nvl(n.describe1, o.describe1) as describe1 -- 项下业务主要担保方式
    ,nvl(n.thirdparty3, o.thirdparty3) as thirdparty3 -- 建筑工程施工可证号
    ,nvl(n.hostbankname, o.hostbankname) as hostbankname -- 主办行行名
    ,nvl(n.singlebizmostamount, o.singlebizmostamount) as singlebizmostamount -- 额度下业务单笔最大金额
    ,nvl(n.suremodel, o.suremodel) as suremodel -- 是否总行认定模式
    ,nvl(n.managename, o.managename) as managename -- 管理人名称
    ,nvl(n.ispubliccredit, o.ispubliccredit) as ispubliccredit -- 是否公开授信额度)
    ,nvl(n.latestusedate, o.latestusedate) as latestusedate -- 额度最迟使用日期
    ,nvl(n.flag2, o.flag2) as flag2 -- 是否为项下业务承担回购责任
    ,nvl(n.gurantymonth, o.gurantymonth) as gurantymonth -- 担保期限(月)
    ,nvl(n.isgovernfinance, o.isgovernfinance) as isgovernfinance -- 是否涉及政府类融资
    ,nvl(n.approveopinion7, o.approveopinion7) as approveopinion7 -- 贷后要求补充说明
    ,nvl(n.bqcheckyeardate, o.bqcheckyeardate) as bqcheckyeardate -- 本期年审日期
    ,nvl(n.onlineamount, o.onlineamount) as onlineamount -- 线上额度(元)
    ,nvl(n.isbeltroadfinance, o.isbeltroadfinance) as isbeltroadfinance -- 是否为一带一路建设投融资
    ,nvl(n.riskexposuresum, o.riskexposuresum) as riskexposuresum -- 其中，一般风险敞口限额
    ,nvl(n.mainleveldate, o.mainleveldate) as mainleveldate -- 主体评级日期
    ,nvl(n.noeffectreason, o.noeffectreason) as noeffectreason -- 失效原因
    ,nvl(n.changetype, o.changetype) as changetype -- 变更原因
    ,nvl(n.phaseopinion, o.phaseopinion) as phaseopinion -- 主动批量-授信方案意见
    ,nvl(n.finishflag, o.finishflag) as finishflag -- 主动批量-授信方案确认标志
    ,nvl(n.ifapprove, o.ifapprove) as ifapprove -- 是否人工填写标志
    ,nvl(n.lowriskexposuresum, o.lowriskexposuresum) as lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,nvl(n.afterpayreq, o.afterpayreq) as afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,nvl(n.contractreq, o.contractreq) as contractreq -- 需落实到合同、协议中的特殊要求
    ,nvl(n.custraterisklevel, o.custraterisklevel) as custraterisklevel -- 客户内评评级结果
    ,nvl(n.islikelowrisk, o.islikelowrisk) as islikelowrisk -- 是否类低风险
    ,nvl(n.loanmanagereq, o.loanmanagereq) as loanmanagereq -- 贷后管理要求
    ,nvl(n.payreq, o.payreq) as payreq -- 授信方案
    ,nvl(n.focuslendtype, o.focuslendtype) as focuslendtype -- 集中放款业务类型
    ,nvl(n.isinnovate, o.isinnovate) as isinnovate -- 是否创新业务
    ,nvl(n.issupplychainfinance, o.issupplychainfinance) as issupplychainfinance -- 是否供应链金融业务
    ,nvl(n.isjoinlimits, o.isjoinlimits) as isjoinlimits -- 
    ,nvl(n.otherlimitamount, o.otherlimitamount) as otherlimitamount -- 
    ,nvl(n.iscollectionagency, o.iscollectionagency) as iscollectionagency -- 
    ,nvl(n.antimoneylaunderlevel, o.antimoneylaunderlevel) as antimoneylaunderlevel -- 
    ,nvl(n.islimit, o.islimit) as islimit -- 
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
from (select * from ${iol_schema}.icms_bap_cl_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bap_cl_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.refbankname <> n.refbankname
        or o.agentbankname <> n.agentbankname
        or o.linecontrolmode <> n.linecontrolmode
        or o.nominalsum <> n.nominalsum
        or o.landusecertid <> n.landusecertid
        or o.thirdpartyzip1 <> n.thirdpartyzip1
        or o.outclassifyorg <> n.outclassifyorg
        or o.creditarea <> n.creditarea
        or o.isbillapply <> n.isbillapply
        or o.hostbankno <> n.hostbankno
        or o.bizmostmortgagerate <> n.bizmostmortgagerate
        or o.totalsumtypart <> n.totalsumtypart
        or o.businesssumentpart <> n.businesssumentpart
        or o.mainlevelorg <> n.mainlevelorg
        or o.otherlimittype <> n.otherlimittype
        or o.approveopinion <> n.approveopinion
        or o.describe2 <> n.describe2
        or o.fundsource <> n.fundsource
        or o.bizlongestterm <> n.bizlongestterm
        or o.occupynominalsum <> n.occupynominalsum
        or o.belonggroupapproveno <> n.belonggroupapproveno
        or o.lngotimes <> n.lngotimes
        or o.playtype <> n.playtype
        or o.flag1 <> n.flag1
        or o.investway <> n.investway
        or o.hxtyoperateorg <> n.hxtyoperateorg
        or o.isfinancialcredit <> n.isfinancialcredit
        or o.sqdkze <> n.sqdkze
        or o.constructionarea <> n.constructionarea
        or o.financialmodel <> n.financialmodel
        or o.drtimes <> n.drtimes
        or o.usewithoutcondition <> n.usewithoutcondition
        or o.othercondition <> n.othercondition
        or o.creditauthno <> n.creditauthno
        or o.manageid <> n.manageid
        or o.istrans <> n.istrans
        or o.bizbailinitialrate <> n.bizbailinitialrate
        or o.rateopinion <> n.rateopinion
        or o.hxtyclassifylevel <> n.hxtyclassifylevel
        or o.lineclass <> n.lineclass
        or o.refbankno <> n.refbankno
        or o.thirdpartyid1 <> n.thirdpartyid1
        or o.thirdpartyid2 <> n.thirdpartyid2
        or o.maxexposureamount <> n.maxexposureamount
        or o.termtype <> n.termtype
        or o.outclassifydate <> n.outclassifydate
        or o.iscreditincrement <> n.iscreditincrement
        or o.dlcdbz <> n.dlcdbz
        or o.publishsum <> n.publishsum
        or o.availablenominalsum <> n.availablenominalsum
        or o.availableexposuresum <> n.availableexposuresum
        or o.otherlimitno <> n.otherlimitno
        or o.totalsumentpart <> n.totalsumentpart
        or o.isconsumerfinance <> n.isconsumerfinance
        or o.agentbankno <> n.agentbankno
        or o.occupyexposuresum <> n.occupyexposuresum
        or o.otherlimitownerid <> n.otherlimitownerid
        or o.thirdparty1 <> n.thirdparty1
        or o.issmeandretail <> n.issmeandretail
        or o.issme <> n.issme
        or o.maxnominalamount <> n.maxnominalamount
        or o.bizextendedterm <> n.bizextendedterm
        or o.otherlimitflag <> n.otherlimitflag
        or o.bizlowestfloatrate <> n.bizlowestfloatrate
        or o.currencyrange <> n.currencyrange
        or o.isquerycreditreport <> n.isquerycreditreport
        or o.isyeartocheck <> n.isyeartocheck
        or o.isgreenfinance <> n.isgreenfinance
        or o.outclassifylevel <> n.outclassifylevel
        or o.investtarget <> n.investtarget
        or o.approvepubsum <> n.approvepubsum
        or o.financialcreditserialno <> n.financialcreditserialno
        or o.bailratio <> n.bailratio
        or o.bailsum <> n.bailsum
        or o.transcount <> n.transcount
        or o.hxtymainratelevel <> n.hxtymainratelevel
        or o.businesssumtypart <> n.businesssumtypart
        or o.islikeloan <> n.islikeloan
        or o.authvouchtype <> n.authvouchtype
        or o.approveopinion6 <> n.approveopinion6
        or o.projectname <> n.projectname
        or o.publicorg <> n.publicorg
        or o.termday <> n.termday
        or o.thirdpartyid3 <> n.thirdpartyid3
        or o.migtflag <> n.migtflag
        or o.thirdpartyadd1 <> n.thirdpartyadd1
        or o.isestatefinance <> n.isestatefinance
        or o.financialcreditowner <> n.financialcreditowner
        or o.approveopinion1 <> n.approveopinion1
        or o.approvedate <> n.approvedate
        or o.isyhcustomer <> n.isyhcustomer
        or o.exposuresum <> n.exposuresum
        or o.sqcheckyeardate <> n.sqcheckyeardate
        or o.describe1 <> n.describe1
        or o.thirdparty3 <> n.thirdparty3
        or o.hostbankname <> n.hostbankname
        or o.singlebizmostamount <> n.singlebizmostamount
        or o.suremodel <> n.suremodel
        or o.managename <> n.managename
        or o.ispubliccredit <> n.ispubliccredit
        or o.latestusedate <> n.latestusedate
        or o.flag2 <> n.flag2
        or o.gurantymonth <> n.gurantymonth
        or o.isgovernfinance <> n.isgovernfinance
        or o.approveopinion7 <> n.approveopinion7
        or o.bqcheckyeardate <> n.bqcheckyeardate
        or o.onlineamount <> n.onlineamount
        or o.isbeltroadfinance <> n.isbeltroadfinance
        or o.riskexposuresum <> n.riskexposuresum
        or o.mainleveldate <> n.mainleveldate
        or o.noeffectreason <> n.noeffectreason
        or o.changetype <> n.changetype
        or o.phaseopinion <> n.phaseopinion
        or o.finishflag <> n.finishflag
        or o.ifapprove <> n.ifapprove
        or o.lowriskexposuresum <> n.lowriskexposuresum
        or o.afterpayreq <> n.afterpayreq
        or o.contractreq <> n.contractreq
        or o.custraterisklevel <> n.custraterisklevel
        or o.islikelowrisk <> n.islikelowrisk
        or o.loanmanagereq <> n.loanmanagereq
        or o.payreq <> n.payreq
        or o.focuslendtype <> n.focuslendtype
        or o.isinnovate <> n.isinnovate
        or o.issupplychainfinance <> n.issupplychainfinance
        or o.isjoinlimits <> n.isjoinlimits
        or o.otherlimitamount <> n.otherlimitamount
        or o.iscollectionagency <> n.iscollectionagency
        or o.antimoneylaunderlevel <> n.antimoneylaunderlevel
        or o.islimit <> n.islimit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bap_cl_info_cl(
            serialno -- 流水号
            ,refbankname -- 参贷行行号
            ,agentbankname -- 代理行行号
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,nominalsum -- 额度名义金额
            ,landusecertid -- 国有土地使用证号
            ,thirdpartyzip1 -- 公积金贷款手续费比例%
            ,outclassifyorg -- 外部评级机构
            ,creditarea -- 授信区域
            ,isbillapply -- 是否新增银承额度专项贴现
            ,hostbankno -- 主办行行号
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,totalsumtypart -- 同业敞口金额(元)
            ,businesssumentpart -- 公司额度金额(元)
            ,mainlevelorg -- 主体评级机构
            ,otherlimittype -- 他用额度类型
            ,approveopinion -- 最终审批意见
            ,describe2 -- 项目座落位置
            ,fundsource -- 资金来源
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupynominalsum -- 已用名义金额自动计算)
            ,belonggroupapproveno -- 集团批复编号
            ,lngotimes -- 借新还旧次数
            ,playtype -- 参与方式
            ,flag1 -- 是否为项下业务提供保证担保
            ,investway -- 投资方式
            ,hxtyoperateorg -- 归口管理部门
            ,isfinancialcredit -- 是否商圈授信
            ,sqdkze -- 申请银团贷款总额(元)
            ,constructionarea -- 项目总面积（平方米）
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,drtimes -- 债务重组次数
            ,usewithoutcondition -- 能否直接使用额度)
            ,othercondition -- 额度使用条件\集群客户授信方案
            ,creditauthno -- 征信授权影像流水号
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,rateopinion -- 客户评级
            ,hxtyclassifylevel -- 债项分类
            ,lineclass -- 额度种类综合/专项/其他)
            ,refbankno -- 参贷行行号
            ,thirdpartyid1 -- 建设用地规划可证号
            ,thirdpartyid2 -- 建设工程规划许可证号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,termtype -- 期限申请类型额度)
            ,outclassifydate -- 外部评级日期
            ,iscreditincrement -- 是否有增信
            ,dlcdbz -- 代理参贷标志
            ,publishsum -- 本次发行金额
            ,availablenominalsum -- 可用名义金额
            ,availableexposuresum -- 可用敞口金额
            ,otherlimitno -- 他用额度流水号
            ,totalsumentpart -- 公司敞口金额(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,agentbankno -- 代理行行号
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,otherlimitownerid -- 他用额度所有人
            ,thirdparty1 -- 销(预)售许可证号
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,issme -- 是否小微企业贷款
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,bizextendedterm -- 额度下业务延展期限月)
            ,otherlimitflag -- 是否占用他用额度
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,currencyrange -- 项下业务币种范围
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,isyeartocheck -- 是否需要年审
            ,isgreenfinance -- 是否为绿色信贷融资
            ,outclassifylevel -- 外部债项评级
            ,investtarget -- 投资标的
            ,approvepubsum -- 批准发行总额
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,bailratio -- 保证金比例%
            ,bailsum -- 保证金金额（元）
            ,transcount -- 交易对手个数
            ,hxtymainratelevel -- 外部主体评级
            ,businesssumtypart -- 同业额度金额(元)
            ,islikeloan -- 是否类信贷
            ,authvouchtype -- 授权权限_担保方式
            ,approveopinion6 -- 贷后要求
            ,projectname -- 项目名称
            ,publicorg -- 发行场所
            ,termday -- 零（天）
            ,thirdpartyid3 -- 最高成数%
            ,migtflag -- 
            ,thirdpartyadd1 -- 最长期限(年)
            ,isestatefinance -- 是否涉及房地产融资
            ,financialcreditowner -- 集群客户专项额度所有人
            ,approveopinion1 -- 最终审批意见2
            ,approvedate -- 批复日期
            ,isyhcustomer -- 是否优合授信客户
            ,exposuresum -- 额度敞口金额
            ,sqcheckyeardate -- 上期年审日期
            ,describe1 -- 项下业务主要担保方式
            ,thirdparty3 -- 建筑工程施工可证号
            ,hostbankname -- 主办行行名
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,latestusedate -- 额度最迟使用日期
            ,flag2 -- 是否为项下业务承担回购责任
            ,gurantymonth -- 担保期限(月)
            ,isgovernfinance -- 是否涉及政府类融资
            ,approveopinion7 -- 贷后要求补充说明
            ,bqcheckyeardate -- 本期年审日期
            ,onlineamount -- 线上额度(元)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,mainleveldate -- 主体评级日期
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ifapprove -- 是否人工填写标志
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,custraterisklevel -- 客户内评评级结果
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,antimoneylaunderlevel -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bap_cl_info_op(
            serialno -- 流水号
            ,refbankname -- 参贷行行号
            ,agentbankname -- 代理行行号
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,nominalsum -- 额度名义金额
            ,landusecertid -- 国有土地使用证号
            ,thirdpartyzip1 -- 公积金贷款手续费比例%
            ,outclassifyorg -- 外部评级机构
            ,creditarea -- 授信区域
            ,isbillapply -- 是否新增银承额度专项贴现
            ,hostbankno -- 主办行行号
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,totalsumtypart -- 同业敞口金额(元)
            ,businesssumentpart -- 公司额度金额(元)
            ,mainlevelorg -- 主体评级机构
            ,otherlimittype -- 他用额度类型
            ,approveopinion -- 最终审批意见
            ,describe2 -- 项目座落位置
            ,fundsource -- 资金来源
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupynominalsum -- 已用名义金额自动计算)
            ,belonggroupapproveno -- 集团批复编号
            ,lngotimes -- 借新还旧次数
            ,playtype -- 参与方式
            ,flag1 -- 是否为项下业务提供保证担保
            ,investway -- 投资方式
            ,hxtyoperateorg -- 归口管理部门
            ,isfinancialcredit -- 是否商圈授信
            ,sqdkze -- 申请银团贷款总额(元)
            ,constructionarea -- 项目总面积（平方米）
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,drtimes -- 债务重组次数
            ,usewithoutcondition -- 能否直接使用额度)
            ,othercondition -- 额度使用条件\集群客户授信方案
            ,creditauthno -- 征信授权影像流水号
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,rateopinion -- 客户评级
            ,hxtyclassifylevel -- 债项分类
            ,lineclass -- 额度种类综合/专项/其他)
            ,refbankno -- 参贷行行号
            ,thirdpartyid1 -- 建设用地规划可证号
            ,thirdpartyid2 -- 建设工程规划许可证号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,termtype -- 期限申请类型额度)
            ,outclassifydate -- 外部评级日期
            ,iscreditincrement -- 是否有增信
            ,dlcdbz -- 代理参贷标志
            ,publishsum -- 本次发行金额
            ,availablenominalsum -- 可用名义金额
            ,availableexposuresum -- 可用敞口金额
            ,otherlimitno -- 他用额度流水号
            ,totalsumentpart -- 公司敞口金额(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,agentbankno -- 代理行行号
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,otherlimitownerid -- 他用额度所有人
            ,thirdparty1 -- 销(预)售许可证号
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,issme -- 是否小微企业贷款
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,bizextendedterm -- 额度下业务延展期限月)
            ,otherlimitflag -- 是否占用他用额度
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,currencyrange -- 项下业务币种范围
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,isyeartocheck -- 是否需要年审
            ,isgreenfinance -- 是否为绿色信贷融资
            ,outclassifylevel -- 外部债项评级
            ,investtarget -- 投资标的
            ,approvepubsum -- 批准发行总额
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,bailratio -- 保证金比例%
            ,bailsum -- 保证金金额（元）
            ,transcount -- 交易对手个数
            ,hxtymainratelevel -- 外部主体评级
            ,businesssumtypart -- 同业额度金额(元)
            ,islikeloan -- 是否类信贷
            ,authvouchtype -- 授权权限_担保方式
            ,approveopinion6 -- 贷后要求
            ,projectname -- 项目名称
            ,publicorg -- 发行场所
            ,termday -- 零（天）
            ,thirdpartyid3 -- 最高成数%
            ,migtflag -- 
            ,thirdpartyadd1 -- 最长期限(年)
            ,isestatefinance -- 是否涉及房地产融资
            ,financialcreditowner -- 集群客户专项额度所有人
            ,approveopinion1 -- 最终审批意见2
            ,approvedate -- 批复日期
            ,isyhcustomer -- 是否优合授信客户
            ,exposuresum -- 额度敞口金额
            ,sqcheckyeardate -- 上期年审日期
            ,describe1 -- 项下业务主要担保方式
            ,thirdparty3 -- 建筑工程施工可证号
            ,hostbankname -- 主办行行名
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,latestusedate -- 额度最迟使用日期
            ,flag2 -- 是否为项下业务承担回购责任
            ,gurantymonth -- 担保期限(月)
            ,isgovernfinance -- 是否涉及政府类融资
            ,approveopinion7 -- 贷后要求补充说明
            ,bqcheckyeardate -- 本期年审日期
            ,onlineamount -- 线上额度(元)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,mainleveldate -- 主体评级日期
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ifapprove -- 是否人工填写标志
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,custraterisklevel -- 客户内评评级结果
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,antimoneylaunderlevel -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.refbankname -- 参贷行行号
    ,o.agentbankname -- 代理行行号
    ,o.linecontrolmode -- 集团额度管控模式超额分配/全额分配)
    ,o.nominalsum -- 额度名义金额
    ,o.landusecertid -- 国有土地使用证号
    ,o.thirdpartyzip1 -- 公积金贷款手续费比例%
    ,o.outclassifyorg -- 外部评级机构
    ,o.creditarea -- 授信区域
    ,o.isbillapply -- 是否新增银承额度专项贴现
    ,o.hostbankno -- 主办行行号
    ,o.bizmostmortgagerate -- 额度下业务最高抵质押率
    ,o.totalsumtypart -- 同业敞口金额(元)
    ,o.businesssumentpart -- 公司额度金额(元)
    ,o.mainlevelorg -- 主体评级机构
    ,o.otherlimittype -- 他用额度类型
    ,o.approveopinion -- 最终审批意见
    ,o.describe2 -- 项目座落位置
    ,o.fundsource -- 资金来源
    ,o.bizlongestterm -- 额度下业务最长期限月)
    ,o.occupynominalsum -- 已用名义金额自动计算)
    ,o.belonggroupapproveno -- 集团批复编号
    ,o.lngotimes -- 借新还旧次数
    ,o.playtype -- 参与方式
    ,o.flag1 -- 是否为项下业务提供保证担保
    ,o.investway -- 投资方式
    ,o.hxtyoperateorg -- 归口管理部门
    ,o.isfinancialcredit -- 是否商圈授信
    ,o.sqdkze -- 申请银团贷款总额(元)
    ,o.constructionarea -- 项目总面积（平方米）
    ,o.financialmodel -- 集群客户操作模式、风险管理及控制方案
    ,o.drtimes -- 债务重组次数
    ,o.usewithoutcondition -- 能否直接使用额度)
    ,o.othercondition -- 额度使用条件\集群客户授信方案
    ,o.creditauthno -- 征信授权影像流水号
    ,o.manageid -- 管理人客户号
    ,o.istrans -- 是否转授信
    ,o.bizbailinitialrate -- 额度下业务初始保证金比例
    ,o.rateopinion -- 客户评级
    ,o.hxtyclassifylevel -- 债项分类
    ,o.lineclass -- 额度种类综合/专项/其他)
    ,o.refbankno -- 参贷行行号
    ,o.thirdpartyid1 -- 建设用地规划可证号
    ,o.thirdpartyid2 -- 建设工程规划许可证号
    ,o.maxexposureamount -- 单一最高授信额度敞口金额
    ,o.termtype -- 期限申请类型额度)
    ,o.outclassifydate -- 外部评级日期
    ,o.iscreditincrement -- 是否有增信
    ,o.dlcdbz -- 代理参贷标志
    ,o.publishsum -- 本次发行金额
    ,o.availablenominalsum -- 可用名义金额
    ,o.availableexposuresum -- 可用敞口金额
    ,o.otherlimitno -- 他用额度流水号
    ,o.totalsumentpart -- 公司敞口金额(元)
    ,o.isconsumerfinance -- 是否为消费服务类融资
    ,o.agentbankno -- 代理行行号
    ,o.occupyexposuresum -- 已用敞口金额自动计算)
    ,o.otherlimitownerid -- 他用额度所有人
    ,o.thirdparty1 -- 销(预)售许可证号
    ,o.issmeandretail -- 是否我行小微企业并且走零售条线
    ,o.issme -- 是否小微企业贷款
    ,o.maxnominalamount -- 单一最高授信额度名义金额
    ,o.bizextendedterm -- 额度下业务延展期限月)
    ,o.otherlimitflag -- 是否占用他用额度
    ,o.bizlowestfloatrate -- 额度下业务利率最低浮动
    ,o.currencyrange -- 项下业务币种范围
    ,o.isquerycreditreport -- 是否自动查询贷后报告
    ,o.isyeartocheck -- 是否需要年审
    ,o.isgreenfinance -- 是否为绿色信贷融资
    ,o.outclassifylevel -- 外部债项评级
    ,o.investtarget -- 投资标的
    ,o.approvepubsum -- 批准发行总额
    ,o.financialcreditserialno -- 集群客户专项额度流水号
    ,o.bailratio -- 保证金比例%
    ,o.bailsum -- 保证金金额（元）
    ,o.transcount -- 交易对手个数
    ,o.hxtymainratelevel -- 外部主体评级
    ,o.businesssumtypart -- 同业额度金额(元)
    ,o.islikeloan -- 是否类信贷
    ,o.authvouchtype -- 授权权限_担保方式
    ,o.approveopinion6 -- 贷后要求
    ,o.projectname -- 项目名称
    ,o.publicorg -- 发行场所
    ,o.termday -- 零（天）
    ,o.thirdpartyid3 -- 最高成数%
    ,o.migtflag -- 
    ,o.thirdpartyadd1 -- 最长期限(年)
    ,o.isestatefinance -- 是否涉及房地产融资
    ,o.financialcreditowner -- 集群客户专项额度所有人
    ,o.approveopinion1 -- 最终审批意见2
    ,o.approvedate -- 批复日期
    ,o.isyhcustomer -- 是否优合授信客户
    ,o.exposuresum -- 额度敞口金额
    ,o.sqcheckyeardate -- 上期年审日期
    ,o.describe1 -- 项下业务主要担保方式
    ,o.thirdparty3 -- 建筑工程施工可证号
    ,o.hostbankname -- 主办行行名
    ,o.singlebizmostamount -- 额度下业务单笔最大金额
    ,o.suremodel -- 是否总行认定模式
    ,o.managename -- 管理人名称
    ,o.ispubliccredit -- 是否公开授信额度)
    ,o.latestusedate -- 额度最迟使用日期
    ,o.flag2 -- 是否为项下业务承担回购责任
    ,o.gurantymonth -- 担保期限(月)
    ,o.isgovernfinance -- 是否涉及政府类融资
    ,o.approveopinion7 -- 贷后要求补充说明
    ,o.bqcheckyeardate -- 本期年审日期
    ,o.onlineamount -- 线上额度(元)
    ,o.isbeltroadfinance -- 是否为一带一路建设投融资
    ,o.riskexposuresum -- 其中，一般风险敞口限额
    ,o.mainleveldate -- 主体评级日期
    ,o.noeffectreason -- 失效原因
    ,o.changetype -- 变更原因
    ,o.phaseopinion -- 主动批量-授信方案意见
    ,o.finishflag -- 主动批量-授信方案确认标志
    ,o.ifapprove -- 是否人工填写标志
    ,o.lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,o.afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,o.contractreq -- 需落实到合同、协议中的特殊要求
    ,o.custraterisklevel -- 客户内评评级结果
    ,o.islikelowrisk -- 是否类低风险
    ,o.loanmanagereq -- 贷后管理要求
    ,o.payreq -- 授信方案
    ,o.focuslendtype -- 集中放款业务类型
    ,o.isinnovate -- 是否创新业务
    ,o.issupplychainfinance -- 是否供应链金融业务
    ,o.isjoinlimits -- 
    ,o.otherlimitamount -- 
    ,o.iscollectionagency -- 
    ,o.antimoneylaunderlevel -- 
    ,o.islimit -- 
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
from ${iol_schema}.icms_bap_cl_info_bk o
    left join ${iol_schema}.icms_bap_cl_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bap_cl_info_cl d
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
--truncate table ${iol_schema}.icms_bap_cl_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bap_cl_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bap_cl_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bap_cl_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bap_cl_info exchange partition p_${batch_date} with table ${iol_schema}.icms_bap_cl_info_cl;
alter table ${iol_schema}.icms_bap_cl_info exchange partition p_20991231 with table ${iol_schema}.icms_bap_cl_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bap_cl_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bap_cl_info_op purge;
drop table ${iol_schema}.icms_bap_cl_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bap_cl_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bap_cl_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
