/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ba_cl_info
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
create table ${iol_schema}.icms_ba_cl_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ba_cl_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ba_cl_info_op purge;
drop table ${iol_schema}.icms_ba_cl_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ba_cl_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ba_cl_info where 0=1;

create table ${iol_schema}.icms_ba_cl_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ba_cl_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ba_cl_info_cl(
            serialno -- 流水号
            ,outclassifydate -- 外部评级日期
            ,totalsumentpart -- 公司敞口金额(元)
            ,dlcdbz -- 代理参贷标志
            ,investtarget -- 投资标的
            ,othercondition -- 额度使用条件
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,migtflag -- 迁移标志：CRS RCR ILC UPL
            ,channelname -- 通道方名称
            ,isbillapply -- 是否新增银承额度专项贴现
            ,refbankname -- 参贷行行号
            ,isgovernfinance -- 是否涉及政府类融资
            ,lngotimes -- 借新还旧次数
            ,mainlevelorg -- 主体评级机构
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 额度名义金额
            ,isestatefinance -- 是否涉及房地产融资
            ,bizextendedterm -- 额度下业务延展期限月)
            ,availableexposuresum -- 可用敞口金额
            ,islikeloan -- 是否类信贷
            ,publishsum -- 本次发行金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,isfinancialcredit -- 是否商圈授信
            ,investway -- 投资方式
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,termtype -- 期限申请类型额度)
            ,lineclass -- 额度种类综合/专项/其他)
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,belonggroupapproveno -- 集团批复编号
            ,financialcreditowner -- 集群客户专项额度所有人
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,originalname -- 原始权益人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,occupynominalsum -- 已用授信额度
            ,moneyindustryt -- 资金投向行业
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,transcount -- 交易对手个数
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,totalsumtypart -- 同业敞口金额(元)
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,latestusedate -- 额度最迟使用日期
            ,isgreenfinance -- 是否为绿色信贷融资
            ,otherlimitownerid -- 他用额度所有人
            ,availablenominalsum -- 可用名义金额
            ,hostbankname -- 主办行行名
            ,authvouchtype -- 授权权限_担保方式
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,mainleveldate -- 主体评级日期
            ,usewithoutcondition -- 能否直接使用额度)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,otherlimittype -- 他用额度类型
            ,sqdkze -- 申请银团贷款总额(元)
            ,outclassifylevel -- 外部债项评级
            ,jxhjcontractno -- 借新还旧原合同
            ,businesssumentpart -- 公司授信额度(元)
            ,currencyrange -- 项下业务币种范围
            ,isconsumerfinance -- 是否为消费服务类融资
            ,drtimes -- 债务重组次数
            ,exposuresum -- 额度敞口金额
            ,classifyresulteleven -- 债项分类
            ,issuername -- 发行人名称
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,hxtyoperateorg -- 归口管理部门
            ,issme -- 是否小微企业贷款
            ,hostbankno -- 主办行行号
            ,agentbankname -- 代理行行号
            ,otherlimitno -- 他用额度流水号
            ,creditauthno -- 征信授权影像流水号
            ,agentbankno -- 代理行行号
            ,approvepubsum -- 批准发行总额
            ,outclassifyorg -- 外部评级机构名称
            ,creditarea -- 授信区域
            ,publicorg -- 发行场所
            ,isyhcustomer -- 是否优合授信客户
            ,onlineamount -- 线上额度(元)
            ,refbankno -- 参贷行行号
            ,otherlimitflag -- 是否占用他用额度
            ,hxtyclassifylevel -- 债项分类
            ,businesssumtypart -- 同业授信额度(元)
            ,authostrdate -- 授权起始日
            ,bizlongestterm -- 额度下业务最长期限月)
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,channelid -- 通道方编号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,changetype -- 变更原因
            ,originalid -- 原始权益人编号
            ,issuernameid -- 发行人编号
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ispenetrate -- 是否可穿透
            ,ifapprove -- 是否人工填写标志
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isprojectfinancing -- 是否项目融资
            ,custraterisklevel -- 客户内评评级结果
            ,onlineapprovallimit -- 线上审批额度
            ,oastatus -- OA审批状态
            ,isjoinlimits -- 是否纳入单一客户或集团的限额
            ,otherlimitamount -- 他用额度占用金额
            ,proborrowerattr -- 借款人属性
            ,proborrowerincome -- 借款人收入特征
            ,proborrowerdebt -- 借款人偿债特征
            ,proassetscontrol -- 资产控制
            ,prorevenuecontrol -- 收入控制
            ,projfinancingtype -- 项目融资类型
            ,mercfinancingobject -- 商品融资对象
            ,itemsfinancingtype -- 物品融资类型
            ,isonlineapprove -- 是否线上化审批
            ,guaranteecompanyname -- 见保即贷业务担保公司
            ,runentyearincome -- 流水推算的年销售收入
            ,lastyearentyearincome -- 纳税申报资料反映的上年度收入
            ,yearincomerate -- 预计销售收入年增长率
            ,operationloanbalanceskr -- 实控人经营性贷款余额
            ,otherworkcaptial -- 其他渠道提供的营运资金
            ,isrelatedcompany -- 借款企业是否为担保公司的关联企业:1是0否
            ,subjectbusiness -- 主营业务
            ,enterpriseamt -- 借款企业在我行有效额度
            ,riskapproveamout -- 风控最终审批金额
            ,riskapprovestatus -- 风控最终状态
            ,riskterm -- 风控最终审批期限
            ,isbranchbusiness -- 是否分行权限内业务
            ,bondingcompanyinamt -- 意向担保金额
            ,guarcompanyterm -- 担保公司推送期限
            ,comptaxgrade -- 企业纳税等级
            ,issignchange -- 经营情况是否发生重大变化
            ,isothersignclassify -- 是否存在其他重大风险
            ,batchcustomertype -- 批量授信客户类型
            ,ishxdanbaoloan -- 是否为华兴担保贷:1-是0-否
            ,enttermduedate -- 企业营业期限到期日
            ,hxdanbaocustomername -- 华兴担保贷担保公司名称
            ,hxdanbaocertid -- 华兴担保贷担保公司证件号码
            ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
            ,actualenttype -- 实际企业类型
            ,actualbusinesstype -- 实际业务类型
            ,externalstatus -- 外部数据状态
            ,externaldate -- 外部数据日期
            ,baseproducttype -- 基础资产类型
            ,baseproducttypeiscycle -- 基础资产是否涉及循环购买
            ,customerprojectrole -- 受信人项目角色
            ,isautomanagelimit -- 是否主动管理类额度
            ,customerproductrole -- 受信人在产品中的角色
            ,dbinvesttermmonth -- 单笔投资期限
            ,isbankbilldiscount -- 是否银票贴现
            ,creditmodel -- 额度类型
            ,actualbaseproducttype -- 资产证券化业务子类
            ,isstateenttype -- 是否国有企业标识(0否1是)
            ,iscityinvestbond -- 是否城投债(0否1是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ba_cl_info_op(
            serialno -- 流水号
            ,outclassifydate -- 外部评级日期
            ,totalsumentpart -- 公司敞口金额(元)
            ,dlcdbz -- 代理参贷标志
            ,investtarget -- 投资标的
            ,othercondition -- 额度使用条件
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,migtflag -- 迁移标志：CRS RCR ILC UPL
            ,channelname -- 通道方名称
            ,isbillapply -- 是否新增银承额度专项贴现
            ,refbankname -- 参贷行行号
            ,isgovernfinance -- 是否涉及政府类融资
            ,lngotimes -- 借新还旧次数
            ,mainlevelorg -- 主体评级机构
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 额度名义金额
            ,isestatefinance -- 是否涉及房地产融资
            ,bizextendedterm -- 额度下业务延展期限月)
            ,availableexposuresum -- 可用敞口金额
            ,islikeloan -- 是否类信贷
            ,publishsum -- 本次发行金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,isfinancialcredit -- 是否商圈授信
            ,investway -- 投资方式
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,termtype -- 期限申请类型额度)
            ,lineclass -- 额度种类综合/专项/其他)
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,belonggroupapproveno -- 集团批复编号
            ,financialcreditowner -- 集群客户专项额度所有人
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,originalname -- 原始权益人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,occupynominalsum -- 已用授信额度
            ,moneyindustryt -- 资金投向行业
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,transcount -- 交易对手个数
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,totalsumtypart -- 同业敞口金额(元)
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,latestusedate -- 额度最迟使用日期
            ,isgreenfinance -- 是否为绿色信贷融资
            ,otherlimitownerid -- 他用额度所有人
            ,availablenominalsum -- 可用名义金额
            ,hostbankname -- 主办行行名
            ,authvouchtype -- 授权权限_担保方式
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,mainleveldate -- 主体评级日期
            ,usewithoutcondition -- 能否直接使用额度)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,otherlimittype -- 他用额度类型
            ,sqdkze -- 申请银团贷款总额(元)
            ,outclassifylevel -- 外部债项评级
            ,jxhjcontractno -- 借新还旧原合同
            ,businesssumentpart -- 公司授信额度(元)
            ,currencyrange -- 项下业务币种范围
            ,isconsumerfinance -- 是否为消费服务类融资
            ,drtimes -- 债务重组次数
            ,exposuresum -- 额度敞口金额
            ,classifyresulteleven -- 债项分类
            ,issuername -- 发行人名称
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,hxtyoperateorg -- 归口管理部门
            ,issme -- 是否小微企业贷款
            ,hostbankno -- 主办行行号
            ,agentbankname -- 代理行行号
            ,otherlimitno -- 他用额度流水号
            ,creditauthno -- 征信授权影像流水号
            ,agentbankno -- 代理行行号
            ,approvepubsum -- 批准发行总额
            ,outclassifyorg -- 外部评级机构名称
            ,creditarea -- 授信区域
            ,publicorg -- 发行场所
            ,isyhcustomer -- 是否优合授信客户
            ,onlineamount -- 线上额度(元)
            ,refbankno -- 参贷行行号
            ,otherlimitflag -- 是否占用他用额度
            ,hxtyclassifylevel -- 债项分类
            ,businesssumtypart -- 同业授信额度(元)
            ,authostrdate -- 授权起始日
            ,bizlongestterm -- 额度下业务最长期限月)
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,channelid -- 通道方编号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,changetype -- 变更原因
            ,originalid -- 原始权益人编号
            ,issuernameid -- 发行人编号
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ispenetrate -- 是否可穿透
            ,ifapprove -- 是否人工填写标志
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isprojectfinancing -- 是否项目融资
            ,custraterisklevel -- 客户内评评级结果
            ,onlineapprovallimit -- 线上审批额度
            ,oastatus -- OA审批状态
            ,isjoinlimits -- 是否纳入单一客户或集团的限额
            ,otherlimitamount -- 他用额度占用金额
            ,proborrowerattr -- 借款人属性
            ,proborrowerincome -- 借款人收入特征
            ,proborrowerdebt -- 借款人偿债特征
            ,proassetscontrol -- 资产控制
            ,prorevenuecontrol -- 收入控制
            ,projfinancingtype -- 项目融资类型
            ,mercfinancingobject -- 商品融资对象
            ,itemsfinancingtype -- 物品融资类型
            ,isonlineapprove -- 是否线上化审批
            ,guaranteecompanyname -- 见保即贷业务担保公司
            ,runentyearincome -- 流水推算的年销售收入
            ,lastyearentyearincome -- 纳税申报资料反映的上年度收入
            ,yearincomerate -- 预计销售收入年增长率
            ,operationloanbalanceskr -- 实控人经营性贷款余额
            ,otherworkcaptial -- 其他渠道提供的营运资金
            ,isrelatedcompany -- 借款企业是否为担保公司的关联企业:1是0否
            ,subjectbusiness -- 主营业务
            ,enterpriseamt -- 借款企业在我行有效额度
            ,riskapproveamout -- 风控最终审批金额
            ,riskapprovestatus -- 风控最终状态
            ,riskterm -- 风控最终审批期限
            ,isbranchbusiness -- 是否分行权限内业务
            ,bondingcompanyinamt -- 意向担保金额
            ,guarcompanyterm -- 担保公司推送期限
            ,comptaxgrade -- 企业纳税等级
            ,issignchange -- 经营情况是否发生重大变化
            ,isothersignclassify -- 是否存在其他重大风险
            ,batchcustomertype -- 批量授信客户类型
            ,ishxdanbaoloan -- 是否为华兴担保贷:1-是0-否
            ,enttermduedate -- 企业营业期限到期日
            ,hxdanbaocustomername -- 华兴担保贷担保公司名称
            ,hxdanbaocertid -- 华兴担保贷担保公司证件号码
            ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
            ,actualenttype -- 实际企业类型
            ,actualbusinesstype -- 实际业务类型
            ,externalstatus -- 外部数据状态
            ,externaldate -- 外部数据日期
            ,baseproducttype -- 基础资产类型
            ,baseproducttypeiscycle -- 基础资产是否涉及循环购买
            ,customerprojectrole -- 受信人项目角色
            ,isautomanagelimit -- 是否主动管理类额度
            ,customerproductrole -- 受信人在产品中的角色
            ,dbinvesttermmonth -- 单笔投资期限
            ,isbankbilldiscount -- 是否银票贴现
            ,creditmodel -- 额度类型
            ,actualbaseproducttype -- 资产证券化业务子类
            ,isstateenttype -- 是否国有企业标识(0否1是)
            ,iscityinvestbond -- 是否城投债(0否1是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.outclassifydate, o.outclassifydate) as outclassifydate -- 外部评级日期
    ,nvl(n.totalsumentpart, o.totalsumentpart) as totalsumentpart -- 公司敞口金额(元)
    ,nvl(n.dlcdbz, o.dlcdbz) as dlcdbz -- 代理参贷标志
    ,nvl(n.investtarget, o.investtarget) as investtarget -- 投资标的
    ,nvl(n.othercondition, o.othercondition) as othercondition -- 额度使用条件
    ,nvl(n.iscreditincrement, o.iscreditincrement) as iscreditincrement -- 是否有增信
    ,nvl(n.hxtymainratelevel, o.hxtymainratelevel) as hxtymainratelevel -- 外部主体评级
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：CRS RCR ILC UPL
    ,nvl(n.channelname, o.channelname) as channelname -- 通道方名称
    ,nvl(n.isbillapply, o.isbillapply) as isbillapply -- 是否新增银承额度专项贴现
    ,nvl(n.refbankname, o.refbankname) as refbankname -- 参贷行行号
    ,nvl(n.isgovernfinance, o.isgovernfinance) as isgovernfinance -- 是否涉及政府类融资
    ,nvl(n.lngotimes, o.lngotimes) as lngotimes -- 借新还旧次数
    ,nvl(n.mainlevelorg, o.mainlevelorg) as mainlevelorg -- 主体评级机构
    ,nvl(n.singlebizmostamount, o.singlebizmostamount) as singlebizmostamount -- 额度下业务单笔最大金额
    ,nvl(n.riskexposuresum, o.riskexposuresum) as riskexposuresum -- 其中，一般风险敞口限额
    ,nvl(n.nominalsum, o.nominalsum) as nominalsum -- 额度名义金额
    ,nvl(n.isestatefinance, o.isestatefinance) as isestatefinance -- 是否涉及房地产融资
    ,nvl(n.bizextendedterm, o.bizextendedterm) as bizextendedterm -- 额度下业务延展期限月)
    ,nvl(n.availableexposuresum, o.availableexposuresum) as availableexposuresum -- 可用敞口金额
    ,nvl(n.islikeloan, o.islikeloan) as islikeloan -- 是否类信贷
    ,nvl(n.publishsum, o.publishsum) as publishsum -- 本次发行金额
    ,nvl(n.bizmostmortgagerate, o.bizmostmortgagerate) as bizmostmortgagerate -- 额度下业务最高抵质押率
    ,nvl(n.isfinancialcredit, o.isfinancialcredit) as isfinancialcredit -- 是否商圈授信
    ,nvl(n.investway, o.investway) as investway -- 投资方式
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 资金来源
    ,nvl(n.playtype, o.playtype) as playtype -- 参与方式
    ,nvl(n.termtype, o.termtype) as termtype -- 期限申请类型额度)
    ,nvl(n.lineclass, o.lineclass) as lineclass -- 额度种类综合/专项/其他)
    ,nvl(n.suremodel, o.suremodel) as suremodel -- 是否总行认定模式
    ,nvl(n.managename, o.managename) as managename -- 管理人名称
    ,nvl(n.manageid, o.manageid) as manageid -- 管理人客户号
    ,nvl(n.istrans, o.istrans) as istrans -- 是否转授信
    ,nvl(n.belonggroupapproveno, o.belonggroupapproveno) as belonggroupapproveno -- 集团批复编号
    ,nvl(n.financialcreditowner, o.financialcreditowner) as financialcreditowner -- 集群客户专项额度所有人
    ,nvl(n.issmeandretail, o.issmeandretail) as issmeandretail -- 是否我行小微企业并且走零售条线
    ,nvl(n.originalname, o.originalname) as originalname -- 原始权益人名称
    ,nvl(n.ispubliccredit, o.ispubliccredit) as ispubliccredit -- 是否公开授信额度)
    ,nvl(n.occupynominalsum, o.occupynominalsum) as occupynominalsum -- 已用授信额度
    ,nvl(n.moneyindustryt, o.moneyindustryt) as moneyindustryt -- 资金投向行业
    ,nvl(n.bizbailinitialrate, o.bizbailinitialrate) as bizbailinitialrate -- 额度下业务初始保证金比例
    ,nvl(n.transcount, o.transcount) as transcount -- 交易对手个数
    ,nvl(n.maxnominalamount, o.maxnominalamount) as maxnominalamount -- 单一最高授信额度名义金额
    ,nvl(n.lowriskexposuresum, o.lowriskexposuresum) as lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,nvl(n.bizlowestfloatrate, o.bizlowestfloatrate) as bizlowestfloatrate -- 额度下业务利率最低浮动
    ,nvl(n.occupyexposuresum, o.occupyexposuresum) as occupyexposuresum -- 已用敞口金额自动计算)
    ,nvl(n.totalsumtypart, o.totalsumtypart) as totalsumtypart -- 同业敞口金额(元)
    ,nvl(n.linecontrolmode, o.linecontrolmode) as linecontrolmode -- 集团额度管控模式超额分配/全额分配)
    ,nvl(n.latestusedate, o.latestusedate) as latestusedate -- 额度最迟使用日期
    ,nvl(n.isgreenfinance, o.isgreenfinance) as isgreenfinance -- 是否为绿色信贷融资
    ,nvl(n.otherlimitownerid, o.otherlimitownerid) as otherlimitownerid -- 他用额度所有人
    ,nvl(n.availablenominalsum, o.availablenominalsum) as availablenominalsum -- 可用名义金额
    ,nvl(n.hostbankname, o.hostbankname) as hostbankname -- 主办行行名
    ,nvl(n.authvouchtype, o.authvouchtype) as authvouchtype -- 授权权限_担保方式
    ,nvl(n.isquerycreditreport, o.isquerycreditreport) as isquerycreditreport -- 是否自动查询贷后报告
    ,nvl(n.mainleveldate, o.mainleveldate) as mainleveldate -- 主体评级日期
    ,nvl(n.usewithoutcondition, o.usewithoutcondition) as usewithoutcondition -- 能否直接使用额度)
    ,nvl(n.isbeltroadfinance, o.isbeltroadfinance) as isbeltroadfinance -- 是否为一带一路建设投融资
    ,nvl(n.otherlimittype, o.otherlimittype) as otherlimittype -- 他用额度类型
    ,nvl(n.sqdkze, o.sqdkze) as sqdkze -- 申请银团贷款总额(元)
    ,nvl(n.outclassifylevel, o.outclassifylevel) as outclassifylevel -- 外部债项评级
    ,nvl(n.jxhjcontractno, o.jxhjcontractno) as jxhjcontractno -- 借新还旧原合同
    ,nvl(n.businesssumentpart, o.businesssumentpart) as businesssumentpart -- 公司授信额度(元)
    ,nvl(n.currencyrange, o.currencyrange) as currencyrange -- 项下业务币种范围
    ,nvl(n.isconsumerfinance, o.isconsumerfinance) as isconsumerfinance -- 是否为消费服务类融资
    ,nvl(n.drtimes, o.drtimes) as drtimes -- 债务重组次数
    ,nvl(n.exposuresum, o.exposuresum) as exposuresum -- 额度敞口金额
    ,nvl(n.classifyresulteleven, o.classifyresulteleven) as classifyresulteleven -- 债项分类
    ,nvl(n.issuername, o.issuername) as issuername -- 发行人名称
    ,nvl(n.financialcreditserialno, o.financialcreditserialno) as financialcreditserialno -- 集群客户专项额度流水号
    ,nvl(n.hxtyoperateorg, o.hxtyoperateorg) as hxtyoperateorg -- 归口管理部门
    ,nvl(n.issme, o.issme) as issme -- 是否小微企业贷款
    ,nvl(n.hostbankno, o.hostbankno) as hostbankno -- 主办行行号
    ,nvl(n.agentbankname, o.agentbankname) as agentbankname -- 代理行行号
    ,nvl(n.otherlimitno, o.otherlimitno) as otherlimitno -- 他用额度流水号
    ,nvl(n.creditauthno, o.creditauthno) as creditauthno -- 征信授权影像流水号
    ,nvl(n.agentbankno, o.agentbankno) as agentbankno -- 代理行行号
    ,nvl(n.approvepubsum, o.approvepubsum) as approvepubsum -- 批准发行总额
    ,nvl(n.outclassifyorg, o.outclassifyorg) as outclassifyorg -- 外部评级机构名称
    ,nvl(n.creditarea, o.creditarea) as creditarea -- 授信区域
    ,nvl(n.publicorg, o.publicorg) as publicorg -- 发行场所
    ,nvl(n.isyhcustomer, o.isyhcustomer) as isyhcustomer -- 是否优合授信客户
    ,nvl(n.onlineamount, o.onlineamount) as onlineamount -- 线上额度(元)
    ,nvl(n.refbankno, o.refbankno) as refbankno -- 参贷行行号
    ,nvl(n.otherlimitflag, o.otherlimitflag) as otherlimitflag -- 是否占用他用额度
    ,nvl(n.hxtyclassifylevel, o.hxtyclassifylevel) as hxtyclassifylevel -- 债项分类
    ,nvl(n.businesssumtypart, o.businesssumtypart) as businesssumtypart -- 同业授信额度(元)
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权起始日
    ,nvl(n.bizlongestterm, o.bizlongestterm) as bizlongestterm -- 额度下业务最长期限月)
    ,nvl(n.financialmodel, o.financialmodel) as financialmodel -- 集群客户操作模式、风险管理及控制方案
    ,nvl(n.channelid, o.channelid) as channelid -- 通道方编号
    ,nvl(n.maxexposureamount, o.maxexposureamount) as maxexposureamount -- 单一最高授信额度敞口金额
    ,nvl(n.changetype, o.changetype) as changetype -- 变更原因
    ,nvl(n.originalid, o.originalid) as originalid -- 原始权益人编号
    ,nvl(n.issuernameid, o.issuernameid) as issuernameid -- 发行人编号
    ,nvl(n.phaseopinion, o.phaseopinion) as phaseopinion -- 主动批量-授信方案意见
    ,nvl(n.finishflag, o.finishflag) as finishflag -- 主动批量-授信方案确认标志
    ,nvl(n.ispenetrate, o.ispenetrate) as ispenetrate -- 是否可穿透
    ,nvl(n.ifapprove, o.ifapprove) as ifapprove -- 是否人工填写标志
    ,nvl(n.afterpayreq, o.afterpayreq) as afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,nvl(n.contractreq, o.contractreq) as contractreq -- 需落实到合同、协议中的特殊要求
    ,nvl(n.islikelowrisk, o.islikelowrisk) as islikelowrisk -- 是否类低风险
    ,nvl(n.loanmanagereq, o.loanmanagereq) as loanmanagereq -- 贷后管理要求
    ,nvl(n.payreq, o.payreq) as payreq -- 授信方案
    ,nvl(n.focuslendtype, o.focuslendtype) as focuslendtype -- 集中放款业务类型
    ,nvl(n.isinnovate, o.isinnovate) as isinnovate -- 是否创新业务
    ,nvl(n.issupplychainfinance, o.issupplychainfinance) as issupplychainfinance -- 是否供应链金融业务
    ,nvl(n.isprojectfinancing, o.isprojectfinancing) as isprojectfinancing -- 是否项目融资
    ,nvl(n.custraterisklevel, o.custraterisklevel) as custraterisklevel -- 客户内评评级结果
    ,nvl(n.onlineapprovallimit, o.onlineapprovallimit) as onlineapprovallimit -- 线上审批额度
    ,nvl(n.oastatus, o.oastatus) as oastatus -- OA审批状态
    ,nvl(n.isjoinlimits, o.isjoinlimits) as isjoinlimits -- 是否纳入单一客户或集团的限额
    ,nvl(n.otherlimitamount, o.otherlimitamount) as otherlimitamount -- 他用额度占用金额
    ,nvl(n.proborrowerattr, o.proborrowerattr) as proborrowerattr -- 借款人属性
    ,nvl(n.proborrowerincome, o.proborrowerincome) as proborrowerincome -- 借款人收入特征
    ,nvl(n.proborrowerdebt, o.proborrowerdebt) as proborrowerdebt -- 借款人偿债特征
    ,nvl(n.proassetscontrol, o.proassetscontrol) as proassetscontrol -- 资产控制
    ,nvl(n.prorevenuecontrol, o.prorevenuecontrol) as prorevenuecontrol -- 收入控制
    ,nvl(n.projfinancingtype, o.projfinancingtype) as projfinancingtype -- 项目融资类型
    ,nvl(n.mercfinancingobject, o.mercfinancingobject) as mercfinancingobject -- 商品融资对象
    ,nvl(n.itemsfinancingtype, o.itemsfinancingtype) as itemsfinancingtype -- 物品融资类型
    ,nvl(n.isonlineapprove, o.isonlineapprove) as isonlineapprove -- 是否线上化审批
    ,nvl(n.guaranteecompanyname, o.guaranteecompanyname) as guaranteecompanyname -- 见保即贷业务担保公司
    ,nvl(n.runentyearincome, o.runentyearincome) as runentyearincome -- 流水推算的年销售收入
    ,nvl(n.lastyearentyearincome, o.lastyearentyearincome) as lastyearentyearincome -- 纳税申报资料反映的上年度收入
    ,nvl(n.yearincomerate, o.yearincomerate) as yearincomerate -- 预计销售收入年增长率
    ,nvl(n.operationloanbalanceskr, o.operationloanbalanceskr) as operationloanbalanceskr -- 实控人经营性贷款余额
    ,nvl(n.otherworkcaptial, o.otherworkcaptial) as otherworkcaptial -- 其他渠道提供的营运资金
    ,nvl(n.isrelatedcompany, o.isrelatedcompany) as isrelatedcompany -- 借款企业是否为担保公司的关联企业:1是0否
    ,nvl(n.subjectbusiness, o.subjectbusiness) as subjectbusiness -- 主营业务
    ,nvl(n.enterpriseamt, o.enterpriseamt) as enterpriseamt -- 借款企业在我行有效额度
    ,nvl(n.riskapproveamout, o.riskapproveamout) as riskapproveamout -- 风控最终审批金额
    ,nvl(n.riskapprovestatus, o.riskapprovestatus) as riskapprovestatus -- 风控最终状态
    ,nvl(n.riskterm, o.riskterm) as riskterm -- 风控最终审批期限
    ,nvl(n.isbranchbusiness, o.isbranchbusiness) as isbranchbusiness -- 是否分行权限内业务
    ,nvl(n.bondingcompanyinamt, o.bondingcompanyinamt) as bondingcompanyinamt -- 意向担保金额
    ,nvl(n.guarcompanyterm, o.guarcompanyterm) as guarcompanyterm -- 担保公司推送期限
    ,nvl(n.comptaxgrade, o.comptaxgrade) as comptaxgrade -- 企业纳税等级
    ,nvl(n.issignchange, o.issignchange) as issignchange -- 经营情况是否发生重大变化
    ,nvl(n.isothersignclassify, o.isothersignclassify) as isothersignclassify -- 是否存在其他重大风险
    ,nvl(n.batchcustomertype, o.batchcustomertype) as batchcustomertype -- 批量授信客户类型
    ,nvl(n.ishxdanbaoloan, o.ishxdanbaoloan) as ishxdanbaoloan -- 是否为华兴担保贷:1-是0-否
    ,nvl(n.enttermduedate, o.enttermduedate) as enttermduedate -- 企业营业期限到期日
    ,nvl(n.hxdanbaocustomername, o.hxdanbaocustomername) as hxdanbaocustomername -- 华兴担保贷担保公司名称
    ,nvl(n.hxdanbaocertid, o.hxdanbaocertid) as hxdanbaocertid -- 华兴担保贷担保公司证件号码
    ,nvl(n.scanstatus, o.scanstatus) as scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
    ,nvl(n.actualenttype, o.actualenttype) as actualenttype -- 实际企业类型
    ,nvl(n.actualbusinesstype, o.actualbusinesstype) as actualbusinesstype -- 实际业务类型
    ,nvl(n.externalstatus, o.externalstatus) as externalstatus -- 外部数据状态
    ,nvl(n.externaldate, o.externaldate) as externaldate -- 外部数据日期
    ,nvl(n.baseproducttype, o.baseproducttype) as baseproducttype -- 基础资产类型
    ,nvl(n.baseproducttypeiscycle, o.baseproducttypeiscycle) as baseproducttypeiscycle -- 基础资产是否涉及循环购买
    ,nvl(n.customerprojectrole, o.customerprojectrole) as customerprojectrole -- 受信人项目角色
    ,nvl(n.isautomanagelimit, o.isautomanagelimit) as isautomanagelimit -- 是否主动管理类额度
    ,nvl(n.customerproductrole, o.customerproductrole) as customerproductrole -- 受信人在产品中的角色
    ,nvl(n.dbinvesttermmonth, o.dbinvesttermmonth) as dbinvesttermmonth -- 单笔投资期限
    ,nvl(n.isbankbilldiscount, o.isbankbilldiscount) as isbankbilldiscount -- 是否银票贴现
    ,nvl(n.creditmodel, o.creditmodel) as creditmodel -- 额度类型
    ,nvl(n.actualbaseproducttype, o.actualbaseproducttype) as actualbaseproducttype -- 资产证券化业务子类
    ,nvl(n.isstateenttype, o.isstateenttype) as isstateenttype -- 是否国有企业标识(0否1是)
    ,nvl(n.iscityinvestbond, o.iscityinvestbond) as iscityinvestbond -- 是否城投债(0否1是)
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
from (select * from ${iol_schema}.icms_ba_cl_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ba_cl_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.outclassifydate <> n.outclassifydate
        or o.totalsumentpart <> n.totalsumentpart
        or o.dlcdbz <> n.dlcdbz
        or o.investtarget <> n.investtarget
        or o.othercondition <> n.othercondition
        or o.iscreditincrement <> n.iscreditincrement
        or o.hxtymainratelevel <> n.hxtymainratelevel
        or o.migtflag <> n.migtflag
        or o.channelname <> n.channelname
        or o.isbillapply <> n.isbillapply
        or o.refbankname <> n.refbankname
        or o.isgovernfinance <> n.isgovernfinance
        or o.lngotimes <> n.lngotimes
        or o.mainlevelorg <> n.mainlevelorg
        or o.singlebizmostamount <> n.singlebizmostamount
        or o.riskexposuresum <> n.riskexposuresum
        or o.nominalsum <> n.nominalsum
        or o.isestatefinance <> n.isestatefinance
        or o.bizextendedterm <> n.bizextendedterm
        or o.availableexposuresum <> n.availableexposuresum
        or o.islikeloan <> n.islikeloan
        or o.publishsum <> n.publishsum
        or o.bizmostmortgagerate <> n.bizmostmortgagerate
        or o.isfinancialcredit <> n.isfinancialcredit
        or o.investway <> n.investway
        or o.fundsource <> n.fundsource
        or o.playtype <> n.playtype
        or o.termtype <> n.termtype
        or o.lineclass <> n.lineclass
        or o.suremodel <> n.suremodel
        or o.managename <> n.managename
        or o.manageid <> n.manageid
        or o.istrans <> n.istrans
        or o.belonggroupapproveno <> n.belonggroupapproveno
        or o.financialcreditowner <> n.financialcreditowner
        or o.issmeandretail <> n.issmeandretail
        or o.originalname <> n.originalname
        or o.ispubliccredit <> n.ispubliccredit
        or o.occupynominalsum <> n.occupynominalsum
        or o.moneyindustryt <> n.moneyindustryt
        or o.bizbailinitialrate <> n.bizbailinitialrate
        or o.transcount <> n.transcount
        or o.maxnominalamount <> n.maxnominalamount
        or o.lowriskexposuresum <> n.lowriskexposuresum
        or o.bizlowestfloatrate <> n.bizlowestfloatrate
        or o.occupyexposuresum <> n.occupyexposuresum
        or o.totalsumtypart <> n.totalsumtypart
        or o.linecontrolmode <> n.linecontrolmode
        or o.latestusedate <> n.latestusedate
        or o.isgreenfinance <> n.isgreenfinance
        or o.otherlimitownerid <> n.otherlimitownerid
        or o.availablenominalsum <> n.availablenominalsum
        or o.hostbankname <> n.hostbankname
        or o.authvouchtype <> n.authvouchtype
        or o.isquerycreditreport <> n.isquerycreditreport
        or o.mainleveldate <> n.mainleveldate
        or o.usewithoutcondition <> n.usewithoutcondition
        or o.isbeltroadfinance <> n.isbeltroadfinance
        or o.otherlimittype <> n.otherlimittype
        or o.sqdkze <> n.sqdkze
        or o.outclassifylevel <> n.outclassifylevel
        or o.jxhjcontractno <> n.jxhjcontractno
        or o.businesssumentpart <> n.businesssumentpart
        or o.currencyrange <> n.currencyrange
        or o.isconsumerfinance <> n.isconsumerfinance
        or o.drtimes <> n.drtimes
        or o.exposuresum <> n.exposuresum
        or o.classifyresulteleven <> n.classifyresulteleven
        or o.issuername <> n.issuername
        or o.financialcreditserialno <> n.financialcreditserialno
        or o.hxtyoperateorg <> n.hxtyoperateorg
        or o.issme <> n.issme
        or o.hostbankno <> n.hostbankno
        or o.agentbankname <> n.agentbankname
        or o.otherlimitno <> n.otherlimitno
        or o.creditauthno <> n.creditauthno
        or o.agentbankno <> n.agentbankno
        or o.approvepubsum <> n.approvepubsum
        or o.outclassifyorg <> n.outclassifyorg
        or o.creditarea <> n.creditarea
        or o.publicorg <> n.publicorg
        or o.isyhcustomer <> n.isyhcustomer
        or o.onlineamount <> n.onlineamount
        or o.refbankno <> n.refbankno
        or o.otherlimitflag <> n.otherlimitflag
        or o.hxtyclassifylevel <> n.hxtyclassifylevel
        or o.businesssumtypart <> n.businesssumtypart
        or o.authostrdate <> n.authostrdate
        or o.bizlongestterm <> n.bizlongestterm
        or o.financialmodel <> n.financialmodel
        or o.channelid <> n.channelid
        or o.maxexposureamount <> n.maxexposureamount
        or o.changetype <> n.changetype
        or o.originalid <> n.originalid
        or o.issuernameid <> n.issuernameid
        or o.phaseopinion <> n.phaseopinion
        or o.finishflag <> n.finishflag
        or o.ispenetrate <> n.ispenetrate
        or o.ifapprove <> n.ifapprove
        or o.afterpayreq <> n.afterpayreq
        or o.contractreq <> n.contractreq
        or o.islikelowrisk <> n.islikelowrisk
        or o.loanmanagereq <> n.loanmanagereq
        or o.payreq <> n.payreq
        or o.focuslendtype <> n.focuslendtype
        or o.isinnovate <> n.isinnovate
        or o.issupplychainfinance <> n.issupplychainfinance
        or o.isprojectfinancing <> n.isprojectfinancing
        or o.custraterisklevel <> n.custraterisklevel
        or o.onlineapprovallimit <> n.onlineapprovallimit
        or o.oastatus <> n.oastatus
        or o.isjoinlimits <> n.isjoinlimits
        or o.otherlimitamount <> n.otherlimitamount
        or o.proborrowerattr <> n.proborrowerattr
        or o.proborrowerincome <> n.proborrowerincome
        or o.proborrowerdebt <> n.proborrowerdebt
        or o.proassetscontrol <> n.proassetscontrol
        or o.prorevenuecontrol <> n.prorevenuecontrol
        or o.projfinancingtype <> n.projfinancingtype
        or o.mercfinancingobject <> n.mercfinancingobject
        or o.itemsfinancingtype <> n.itemsfinancingtype
        or o.isonlineapprove <> n.isonlineapprove
        or o.guaranteecompanyname <> n.guaranteecompanyname
        or o.runentyearincome <> n.runentyearincome
        or o.lastyearentyearincome <> n.lastyearentyearincome
        or o.yearincomerate <> n.yearincomerate
        or o.operationloanbalanceskr <> n.operationloanbalanceskr
        or o.otherworkcaptial <> n.otherworkcaptial
        or o.isrelatedcompany <> n.isrelatedcompany
        or o.subjectbusiness <> n.subjectbusiness
        or o.enterpriseamt <> n.enterpriseamt
        or o.riskapproveamout <> n.riskapproveamout
        or o.riskapprovestatus <> n.riskapprovestatus
        or o.riskterm <> n.riskterm
        or o.isbranchbusiness <> n.isbranchbusiness
        or o.bondingcompanyinamt <> n.bondingcompanyinamt
        or o.guarcompanyterm <> n.guarcompanyterm
        or o.comptaxgrade <> n.comptaxgrade
        or o.issignchange <> n.issignchange
        or o.isothersignclassify <> n.isothersignclassify
        or o.batchcustomertype <> n.batchcustomertype
        or o.ishxdanbaoloan <> n.ishxdanbaoloan
        or o.enttermduedate <> n.enttermduedate
        or o.hxdanbaocustomername <> n.hxdanbaocustomername
        or o.hxdanbaocertid <> n.hxdanbaocertid
        or o.scanstatus <> n.scanstatus
        or o.actualenttype <> n.actualenttype
        or o.actualbusinesstype <> n.actualbusinesstype
        or o.externalstatus <> n.externalstatus
        or o.externaldate <> n.externaldate
        or o.baseproducttype <> n.baseproducttype
        or o.baseproducttypeiscycle <> n.baseproducttypeiscycle
        or o.customerprojectrole <> n.customerprojectrole
        or o.isautomanagelimit <> n.isautomanagelimit
        or o.customerproductrole <> n.customerproductrole
        or o.dbinvesttermmonth <> n.dbinvesttermmonth
        or o.isbankbilldiscount <> n.isbankbilldiscount
        or o.creditmodel <> n.creditmodel
        or o.actualbaseproducttype <> n.actualbaseproducttype
        or o.isstateenttype <> n.isstateenttype
        or o.iscityinvestbond <> n.iscityinvestbond
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ba_cl_info_cl(
            serialno -- 流水号
            ,outclassifydate -- 外部评级日期
            ,totalsumentpart -- 公司敞口金额(元)
            ,dlcdbz -- 代理参贷标志
            ,investtarget -- 投资标的
            ,othercondition -- 额度使用条件
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,migtflag -- 迁移标志：CRS RCR ILC UPL
            ,channelname -- 通道方名称
            ,isbillapply -- 是否新增银承额度专项贴现
            ,refbankname -- 参贷行行号
            ,isgovernfinance -- 是否涉及政府类融资
            ,lngotimes -- 借新还旧次数
            ,mainlevelorg -- 主体评级机构
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 额度名义金额
            ,isestatefinance -- 是否涉及房地产融资
            ,bizextendedterm -- 额度下业务延展期限月)
            ,availableexposuresum -- 可用敞口金额
            ,islikeloan -- 是否类信贷
            ,publishsum -- 本次发行金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,isfinancialcredit -- 是否商圈授信
            ,investway -- 投资方式
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,termtype -- 期限申请类型额度)
            ,lineclass -- 额度种类综合/专项/其他)
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,belonggroupapproveno -- 集团批复编号
            ,financialcreditowner -- 集群客户专项额度所有人
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,originalname -- 原始权益人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,occupynominalsum -- 已用授信额度
            ,moneyindustryt -- 资金投向行业
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,transcount -- 交易对手个数
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,totalsumtypart -- 同业敞口金额(元)
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,latestusedate -- 额度最迟使用日期
            ,isgreenfinance -- 是否为绿色信贷融资
            ,otherlimitownerid -- 他用额度所有人
            ,availablenominalsum -- 可用名义金额
            ,hostbankname -- 主办行行名
            ,authvouchtype -- 授权权限_担保方式
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,mainleveldate -- 主体评级日期
            ,usewithoutcondition -- 能否直接使用额度)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,otherlimittype -- 他用额度类型
            ,sqdkze -- 申请银团贷款总额(元)
            ,outclassifylevel -- 外部债项评级
            ,jxhjcontractno -- 借新还旧原合同
            ,businesssumentpart -- 公司授信额度(元)
            ,currencyrange -- 项下业务币种范围
            ,isconsumerfinance -- 是否为消费服务类融资
            ,drtimes -- 债务重组次数
            ,exposuresum -- 额度敞口金额
            ,classifyresulteleven -- 债项分类
            ,issuername -- 发行人名称
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,hxtyoperateorg -- 归口管理部门
            ,issme -- 是否小微企业贷款
            ,hostbankno -- 主办行行号
            ,agentbankname -- 代理行行号
            ,otherlimitno -- 他用额度流水号
            ,creditauthno -- 征信授权影像流水号
            ,agentbankno -- 代理行行号
            ,approvepubsum -- 批准发行总额
            ,outclassifyorg -- 外部评级机构名称
            ,creditarea -- 授信区域
            ,publicorg -- 发行场所
            ,isyhcustomer -- 是否优合授信客户
            ,onlineamount -- 线上额度(元)
            ,refbankno -- 参贷行行号
            ,otherlimitflag -- 是否占用他用额度
            ,hxtyclassifylevel -- 债项分类
            ,businesssumtypart -- 同业授信额度(元)
            ,authostrdate -- 授权起始日
            ,bizlongestterm -- 额度下业务最长期限月)
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,channelid -- 通道方编号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,changetype -- 变更原因
            ,originalid -- 原始权益人编号
            ,issuernameid -- 发行人编号
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ispenetrate -- 是否可穿透
            ,ifapprove -- 是否人工填写标志
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isprojectfinancing -- 是否项目融资
            ,custraterisklevel -- 客户内评评级结果
            ,onlineapprovallimit -- 线上审批额度
            ,oastatus -- OA审批状态
            ,isjoinlimits -- 是否纳入单一客户或集团的限额
            ,otherlimitamount -- 他用额度占用金额
            ,proborrowerattr -- 借款人属性
            ,proborrowerincome -- 借款人收入特征
            ,proborrowerdebt -- 借款人偿债特征
            ,proassetscontrol -- 资产控制
            ,prorevenuecontrol -- 收入控制
            ,projfinancingtype -- 项目融资类型
            ,mercfinancingobject -- 商品融资对象
            ,itemsfinancingtype -- 物品融资类型
            ,isonlineapprove -- 是否线上化审批
            ,guaranteecompanyname -- 见保即贷业务担保公司
            ,runentyearincome -- 流水推算的年销售收入
            ,lastyearentyearincome -- 纳税申报资料反映的上年度收入
            ,yearincomerate -- 预计销售收入年增长率
            ,operationloanbalanceskr -- 实控人经营性贷款余额
            ,otherworkcaptial -- 其他渠道提供的营运资金
            ,isrelatedcompany -- 借款企业是否为担保公司的关联企业:1是0否
            ,subjectbusiness -- 主营业务
            ,enterpriseamt -- 借款企业在我行有效额度
            ,riskapproveamout -- 风控最终审批金额
            ,riskapprovestatus -- 风控最终状态
            ,riskterm -- 风控最终审批期限
            ,isbranchbusiness -- 是否分行权限内业务
            ,bondingcompanyinamt -- 意向担保金额
            ,guarcompanyterm -- 担保公司推送期限
            ,comptaxgrade -- 企业纳税等级
            ,issignchange -- 经营情况是否发生重大变化
            ,isothersignclassify -- 是否存在其他重大风险
            ,batchcustomertype -- 批量授信客户类型
            ,ishxdanbaoloan -- 是否为华兴担保贷:1-是0-否
            ,enttermduedate -- 企业营业期限到期日
            ,hxdanbaocustomername -- 华兴担保贷担保公司名称
            ,hxdanbaocertid -- 华兴担保贷担保公司证件号码
            ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
            ,actualenttype -- 实际企业类型
            ,actualbusinesstype -- 实际业务类型
            ,externalstatus -- 外部数据状态
            ,externaldate -- 外部数据日期
            ,baseproducttype -- 基础资产类型
            ,baseproducttypeiscycle -- 基础资产是否涉及循环购买
            ,customerprojectrole -- 受信人项目角色
            ,isautomanagelimit -- 是否主动管理类额度
            ,customerproductrole -- 受信人在产品中的角色
            ,dbinvesttermmonth -- 单笔投资期限
            ,isbankbilldiscount -- 是否银票贴现
            ,creditmodel -- 额度类型
            ,actualbaseproducttype -- 资产证券化业务子类
            ,isstateenttype -- 是否国有企业标识(0否1是)
            ,iscityinvestbond -- 是否城投债(0否1是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ba_cl_info_op(
            serialno -- 流水号
            ,outclassifydate -- 外部评级日期
            ,totalsumentpart -- 公司敞口金额(元)
            ,dlcdbz -- 代理参贷标志
            ,investtarget -- 投资标的
            ,othercondition -- 额度使用条件
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,migtflag -- 迁移标志：CRS RCR ILC UPL
            ,channelname -- 通道方名称
            ,isbillapply -- 是否新增银承额度专项贴现
            ,refbankname -- 参贷行行号
            ,isgovernfinance -- 是否涉及政府类融资
            ,lngotimes -- 借新还旧次数
            ,mainlevelorg -- 主体评级机构
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 额度名义金额
            ,isestatefinance -- 是否涉及房地产融资
            ,bizextendedterm -- 额度下业务延展期限月)
            ,availableexposuresum -- 可用敞口金额
            ,islikeloan -- 是否类信贷
            ,publishsum -- 本次发行金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,isfinancialcredit -- 是否商圈授信
            ,investway -- 投资方式
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,termtype -- 期限申请类型额度)
            ,lineclass -- 额度种类综合/专项/其他)
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,belonggroupapproveno -- 集团批复编号
            ,financialcreditowner -- 集群客户专项额度所有人
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,originalname -- 原始权益人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,occupynominalsum -- 已用授信额度
            ,moneyindustryt -- 资金投向行业
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,transcount -- 交易对手个数
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,totalsumtypart -- 同业敞口金额(元)
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,latestusedate -- 额度最迟使用日期
            ,isgreenfinance -- 是否为绿色信贷融资
            ,otherlimitownerid -- 他用额度所有人
            ,availablenominalsum -- 可用名义金额
            ,hostbankname -- 主办行行名
            ,authvouchtype -- 授权权限_担保方式
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,mainleveldate -- 主体评级日期
            ,usewithoutcondition -- 能否直接使用额度)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,otherlimittype -- 他用额度类型
            ,sqdkze -- 申请银团贷款总额(元)
            ,outclassifylevel -- 外部债项评级
            ,jxhjcontractno -- 借新还旧原合同
            ,businesssumentpart -- 公司授信额度(元)
            ,currencyrange -- 项下业务币种范围
            ,isconsumerfinance -- 是否为消费服务类融资
            ,drtimes -- 债务重组次数
            ,exposuresum -- 额度敞口金额
            ,classifyresulteleven -- 债项分类
            ,issuername -- 发行人名称
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,hxtyoperateorg -- 归口管理部门
            ,issme -- 是否小微企业贷款
            ,hostbankno -- 主办行行号
            ,agentbankname -- 代理行行号
            ,otherlimitno -- 他用额度流水号
            ,creditauthno -- 征信授权影像流水号
            ,agentbankno -- 代理行行号
            ,approvepubsum -- 批准发行总额
            ,outclassifyorg -- 外部评级机构名称
            ,creditarea -- 授信区域
            ,publicorg -- 发行场所
            ,isyhcustomer -- 是否优合授信客户
            ,onlineamount -- 线上额度(元)
            ,refbankno -- 参贷行行号
            ,otherlimitflag -- 是否占用他用额度
            ,hxtyclassifylevel -- 债项分类
            ,businesssumtypart -- 同业授信额度(元)
            ,authostrdate -- 授权起始日
            ,bizlongestterm -- 额度下业务最长期限月)
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,channelid -- 通道方编号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,changetype -- 变更原因
            ,originalid -- 原始权益人编号
            ,issuernameid -- 发行人编号
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ispenetrate -- 是否可穿透
            ,ifapprove -- 是否人工填写标志
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isprojectfinancing -- 是否项目融资
            ,custraterisklevel -- 客户内评评级结果
            ,onlineapprovallimit -- 线上审批额度
            ,oastatus -- OA审批状态
            ,isjoinlimits -- 是否纳入单一客户或集团的限额
            ,otherlimitamount -- 他用额度占用金额
            ,proborrowerattr -- 借款人属性
            ,proborrowerincome -- 借款人收入特征
            ,proborrowerdebt -- 借款人偿债特征
            ,proassetscontrol -- 资产控制
            ,prorevenuecontrol -- 收入控制
            ,projfinancingtype -- 项目融资类型
            ,mercfinancingobject -- 商品融资对象
            ,itemsfinancingtype -- 物品融资类型
            ,isonlineapprove -- 是否线上化审批
            ,guaranteecompanyname -- 见保即贷业务担保公司
            ,runentyearincome -- 流水推算的年销售收入
            ,lastyearentyearincome -- 纳税申报资料反映的上年度收入
            ,yearincomerate -- 预计销售收入年增长率
            ,operationloanbalanceskr -- 实控人经营性贷款余额
            ,otherworkcaptial -- 其他渠道提供的营运资金
            ,isrelatedcompany -- 借款企业是否为担保公司的关联企业:1是0否
            ,subjectbusiness -- 主营业务
            ,enterpriseamt -- 借款企业在我行有效额度
            ,riskapproveamout -- 风控最终审批金额
            ,riskapprovestatus -- 风控最终状态
            ,riskterm -- 风控最终审批期限
            ,isbranchbusiness -- 是否分行权限内业务
            ,bondingcompanyinamt -- 意向担保金额
            ,guarcompanyterm -- 担保公司推送期限
            ,comptaxgrade -- 企业纳税等级
            ,issignchange -- 经营情况是否发生重大变化
            ,isothersignclassify -- 是否存在其他重大风险
            ,batchcustomertype -- 批量授信客户类型
            ,ishxdanbaoloan -- 是否为华兴担保贷:1-是0-否
            ,enttermduedate -- 企业营业期限到期日
            ,hxdanbaocustomername -- 华兴担保贷担保公司名称
            ,hxdanbaocertid -- 华兴担保贷担保公司证件号码
            ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
            ,actualenttype -- 实际企业类型
            ,actualbusinesstype -- 实际业务类型
            ,externalstatus -- 外部数据状态
            ,externaldate -- 外部数据日期
            ,baseproducttype -- 基础资产类型
            ,baseproducttypeiscycle -- 基础资产是否涉及循环购买
            ,customerprojectrole -- 受信人项目角色
            ,isautomanagelimit -- 是否主动管理类额度
            ,customerproductrole -- 受信人在产品中的角色
            ,dbinvesttermmonth -- 单笔投资期限
            ,isbankbilldiscount -- 是否银票贴现
            ,creditmodel -- 额度类型
            ,actualbaseproducttype -- 资产证券化业务子类
            ,isstateenttype -- 是否国有企业标识(0否1是)
            ,iscityinvestbond -- 是否城投债(0否1是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.outclassifydate -- 外部评级日期
    ,o.totalsumentpart -- 公司敞口金额(元)
    ,o.dlcdbz -- 代理参贷标志
    ,o.investtarget -- 投资标的
    ,o.othercondition -- 额度使用条件
    ,o.iscreditincrement -- 是否有增信
    ,o.hxtymainratelevel -- 外部主体评级
    ,o.migtflag -- 迁移标志：CRS RCR ILC UPL
    ,o.channelname -- 通道方名称
    ,o.isbillapply -- 是否新增银承额度专项贴现
    ,o.refbankname -- 参贷行行号
    ,o.isgovernfinance -- 是否涉及政府类融资
    ,o.lngotimes -- 借新还旧次数
    ,o.mainlevelorg -- 主体评级机构
    ,o.singlebizmostamount -- 额度下业务单笔最大金额
    ,o.riskexposuresum -- 其中，一般风险敞口限额
    ,o.nominalsum -- 额度名义金额
    ,o.isestatefinance -- 是否涉及房地产融资
    ,o.bizextendedterm -- 额度下业务延展期限月)
    ,o.availableexposuresum -- 可用敞口金额
    ,o.islikeloan -- 是否类信贷
    ,o.publishsum -- 本次发行金额
    ,o.bizmostmortgagerate -- 额度下业务最高抵质押率
    ,o.isfinancialcredit -- 是否商圈授信
    ,o.investway -- 投资方式
    ,o.fundsource -- 资金来源
    ,o.playtype -- 参与方式
    ,o.termtype -- 期限申请类型额度)
    ,o.lineclass -- 额度种类综合/专项/其他)
    ,o.suremodel -- 是否总行认定模式
    ,o.managename -- 管理人名称
    ,o.manageid -- 管理人客户号
    ,o.istrans -- 是否转授信
    ,o.belonggroupapproveno -- 集团批复编号
    ,o.financialcreditowner -- 集群客户专项额度所有人
    ,o.issmeandretail -- 是否我行小微企业并且走零售条线
    ,o.originalname -- 原始权益人名称
    ,o.ispubliccredit -- 是否公开授信额度)
    ,o.occupynominalsum -- 已用授信额度
    ,o.moneyindustryt -- 资金投向行业
    ,o.bizbailinitialrate -- 额度下业务初始保证金比例
    ,o.transcount -- 交易对手个数
    ,o.maxnominalamount -- 单一最高授信额度名义金额
    ,o.lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,o.bizlowestfloatrate -- 额度下业务利率最低浮动
    ,o.occupyexposuresum -- 已用敞口金额自动计算)
    ,o.totalsumtypart -- 同业敞口金额(元)
    ,o.linecontrolmode -- 集团额度管控模式超额分配/全额分配)
    ,o.latestusedate -- 额度最迟使用日期
    ,o.isgreenfinance -- 是否为绿色信贷融资
    ,o.otherlimitownerid -- 他用额度所有人
    ,o.availablenominalsum -- 可用名义金额
    ,o.hostbankname -- 主办行行名
    ,o.authvouchtype -- 授权权限_担保方式
    ,o.isquerycreditreport -- 是否自动查询贷后报告
    ,o.mainleveldate -- 主体评级日期
    ,o.usewithoutcondition -- 能否直接使用额度)
    ,o.isbeltroadfinance -- 是否为一带一路建设投融资
    ,o.otherlimittype -- 他用额度类型
    ,o.sqdkze -- 申请银团贷款总额(元)
    ,o.outclassifylevel -- 外部债项评级
    ,o.jxhjcontractno -- 借新还旧原合同
    ,o.businesssumentpart -- 公司授信额度(元)
    ,o.currencyrange -- 项下业务币种范围
    ,o.isconsumerfinance -- 是否为消费服务类融资
    ,o.drtimes -- 债务重组次数
    ,o.exposuresum -- 额度敞口金额
    ,o.classifyresulteleven -- 债项分类
    ,o.issuername -- 发行人名称
    ,o.financialcreditserialno -- 集群客户专项额度流水号
    ,o.hxtyoperateorg -- 归口管理部门
    ,o.issme -- 是否小微企业贷款
    ,o.hostbankno -- 主办行行号
    ,o.agentbankname -- 代理行行号
    ,o.otherlimitno -- 他用额度流水号
    ,o.creditauthno -- 征信授权影像流水号
    ,o.agentbankno -- 代理行行号
    ,o.approvepubsum -- 批准发行总额
    ,o.outclassifyorg -- 外部评级机构名称
    ,o.creditarea -- 授信区域
    ,o.publicorg -- 发行场所
    ,o.isyhcustomer -- 是否优合授信客户
    ,o.onlineamount -- 线上额度(元)
    ,o.refbankno -- 参贷行行号
    ,o.otherlimitflag -- 是否占用他用额度
    ,o.hxtyclassifylevel -- 债项分类
    ,o.businesssumtypart -- 同业授信额度(元)
    ,o.authostrdate -- 授权起始日
    ,o.bizlongestterm -- 额度下业务最长期限月)
    ,o.financialmodel -- 集群客户操作模式、风险管理及控制方案
    ,o.channelid -- 通道方编号
    ,o.maxexposureamount -- 单一最高授信额度敞口金额
    ,o.changetype -- 变更原因
    ,o.originalid -- 原始权益人编号
    ,o.issuernameid -- 发行人编号
    ,o.phaseopinion -- 主动批量-授信方案意见
    ,o.finishflag -- 主动批量-授信方案确认标志
    ,o.ispenetrate -- 是否可穿透
    ,o.ifapprove -- 是否人工填写标志
    ,o.afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,o.contractreq -- 需落实到合同、协议中的特殊要求
    ,o.islikelowrisk -- 是否类低风险
    ,o.loanmanagereq -- 贷后管理要求
    ,o.payreq -- 授信方案
    ,o.focuslendtype -- 集中放款业务类型
    ,o.isinnovate -- 是否创新业务
    ,o.issupplychainfinance -- 是否供应链金融业务
    ,o.isprojectfinancing -- 是否项目融资
    ,o.custraterisklevel -- 客户内评评级结果
    ,o.onlineapprovallimit -- 线上审批额度
    ,o.oastatus -- OA审批状态
    ,o.isjoinlimits -- 是否纳入单一客户或集团的限额
    ,o.otherlimitamount -- 他用额度占用金额
    ,o.proborrowerattr -- 借款人属性
    ,o.proborrowerincome -- 借款人收入特征
    ,o.proborrowerdebt -- 借款人偿债特征
    ,o.proassetscontrol -- 资产控制
    ,o.prorevenuecontrol -- 收入控制
    ,o.projfinancingtype -- 项目融资类型
    ,o.mercfinancingobject -- 商品融资对象
    ,o.itemsfinancingtype -- 物品融资类型
    ,o.isonlineapprove -- 是否线上化审批
    ,o.guaranteecompanyname -- 见保即贷业务担保公司
    ,o.runentyearincome -- 流水推算的年销售收入
    ,o.lastyearentyearincome -- 纳税申报资料反映的上年度收入
    ,o.yearincomerate -- 预计销售收入年增长率
    ,o.operationloanbalanceskr -- 实控人经营性贷款余额
    ,o.otherworkcaptial -- 其他渠道提供的营运资金
    ,o.isrelatedcompany -- 借款企业是否为担保公司的关联企业:1是0否
    ,o.subjectbusiness -- 主营业务
    ,o.enterpriseamt -- 借款企业在我行有效额度
    ,o.riskapproveamout -- 风控最终审批金额
    ,o.riskapprovestatus -- 风控最终状态
    ,o.riskterm -- 风控最终审批期限
    ,o.isbranchbusiness -- 是否分行权限内业务
    ,o.bondingcompanyinamt -- 意向担保金额
    ,o.guarcompanyterm -- 担保公司推送期限
    ,o.comptaxgrade -- 企业纳税等级
    ,o.issignchange -- 经营情况是否发生重大变化
    ,o.isothersignclassify -- 是否存在其他重大风险
    ,o.batchcustomertype -- 批量授信客户类型
    ,o.ishxdanbaoloan -- 是否为华兴担保贷:1-是0-否
    ,o.enttermduedate -- 企业营业期限到期日
    ,o.hxdanbaocustomername -- 华兴担保贷担保公司名称
    ,o.hxdanbaocertid -- 华兴担保贷担保公司证件号码
    ,o.scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
    ,o.actualenttype -- 实际企业类型
    ,o.actualbusinesstype -- 实际业务类型
    ,o.externalstatus -- 外部数据状态
    ,o.externaldate -- 外部数据日期
    ,o.baseproducttype -- 基础资产类型
    ,o.baseproducttypeiscycle -- 基础资产是否涉及循环购买
    ,o.customerprojectrole -- 受信人项目角色
    ,o.isautomanagelimit -- 是否主动管理类额度
    ,o.customerproductrole -- 受信人在产品中的角色
    ,o.dbinvesttermmonth -- 单笔投资期限
    ,o.isbankbilldiscount -- 是否银票贴现
    ,o.creditmodel -- 额度类型
    ,o.actualbaseproducttype -- 资产证券化业务子类
    ,o.isstateenttype -- 是否国有企业标识(0否1是)
    ,o.iscityinvestbond -- 是否城投债(0否1是)
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
from ${iol_schema}.icms_ba_cl_info_bk o
    left join ${iol_schema}.icms_ba_cl_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ba_cl_info_cl d
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
--truncate table ${iol_schema}.icms_ba_cl_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ba_cl_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ba_cl_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ba_cl_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ba_cl_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ba_cl_info_cl;
alter table ${iol_schema}.icms_ba_cl_info exchange partition p_20991231 with table ${iol_schema}.icms_ba_cl_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ba_cl_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ba_cl_info_op purge;
drop table ${iol_schema}.icms_ba_cl_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ba_cl_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ba_cl_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
