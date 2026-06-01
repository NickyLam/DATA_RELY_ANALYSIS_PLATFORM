/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ent_info
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
create table ${iol_schema}.icms_ent_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ent_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ent_info_op purge;
drop table ${iol_schema}.icms_ent_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ent_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ent_info where 0=1;

create table ${iol_schema}.icms_ent_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ent_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ent_info_cl(
            basicbank -- 基本帐户行
            ,basicaccount -- 基本账户账号
            ,mybank -- 我行开户行
            ,mybankaccount -- 我行开户帐号
            ,otherbank -- 他行开户行
            ,otherbankaccount -- 他行开户帐号
            ,accountdate -- 在我行首次开立账户时间
            ,creditdate -- 与我行建立信贷关系时间
            ,evaluatedate -- 评估日期
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,swiftcode -- SWIFT代码
            ,financeorglicence -- 金融机构许可证
            ,financeorgcode -- 金融机构代码
            ,countryrisk -- 国别风险
            ,corpid -- 法人编号
            ,corporgid -- 法人机构编号
            ,registerregioncode -- 登记地行政区划代码
            ,economictype -- 经济类型
            ,countrycode -- 所在国家(地区)
            ,fictitiousperson -- 法定代表人(姓名)
            ,fictitiouspersonid -- 法定代表人证件号码（事业单位等=身份证号）
            ,listingcorpornot -- 是否上市公司标志
            ,hasiebusiness -- 有无进出口经营项目
            ,registerdate -- 注册日期
            ,mcompanyname -- 母公司名称
            ,mcompanycerttype -- 母公司证件类型
            ,mcompanycertid -- 母公司证件号码
            ,firstloandate -- 首贷日期
            ,subjectbusiness -- 主营业务
            ,industrytypeforrs -- 所属行业类型
            ,strategicemergingindustrytype -- 战略新兴产业类型
            ,corporationgrowthstage -- 企业成长阶段
            ,organiztype -- 组织机构类别
            ,orgdetail -- 组织机构类别细分
            ,ifoversea -- 是否离岸户
            ,rwacustomertype -- 加权风险资产客户分类
            ,isnewsetup -- 是否为新建企业
            ,privateent -- 是否民营企业
            ,bankingsupervision -- 是否银监小企业
            ,bankingtype -- 银监小企业规模
            ,isdebt -- 是否为逃废债企业
            ,islimit -- 是否属于两高行业
            ,laborintensiveentflag -- 是否劳动密集型企业
            ,holdingtype -- 控股类型
            ,iscountrysidenterprise -- 农村城市标志
            ,isblack -- 是否黑名单客户标志
            ,locality -- 是否我行认定小企业
            ,isfreshcust -- 是否绿色信贷标志
            ,lmcredittype -- 客户洗钱风险分类
            ,businessstrategy -- 授信策略
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,transformationandupgradeid -- 工业转型升级标识
            ,orgstatus -- 机构状态
            ,onlylimit -- 单一限额
            ,shareholderstructuredate -- 股东结构对应日期
            ,clyxcustomerid -- 策略营销客户号
            ,chargedepartment -- 上级主管单位
            ,isrelativetrade -- 是否我行关联交易
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,fundsource -- 经费来源
            ,fiscalsource -- 财政补助收入来源
            ,serviceupdateresult -- 客户服务升级分类
            ,governmentlevel -- 政府等级
            ,isrelatedparty -- 是否我行关联方标志
            ,managearea -- 政府机构行政区划
            ,financecorpid -- 非现场监管统计机构编码
            ,otherorgname -- 发证机关
            ,corpstartdate -- 发证日期
            ,isdlfr -- 是否独立法人
            ,ispart -- 是否我行股东
            ,isoverseas -- 是否海外子行客户
            ,authflag -- 是否授权
            ,isinvestcust -- 是否投资类客户
            ,distributestatus -- 分配状态
            ,customertype -- 客户机构类型
            ,ifsme -- 是否中小企业事业部专营客户
            ,fictitiouspersoncertificateid -- 法定代表人证明书标号
            ,fictitiousmobile -- 法定代表人移动电话
            ,registeradd -- 注册地址
            ,newregioncode -- 行政区域（风险预警）
            ,financedirectorname -- 财务总监姓名
            ,mobilephone -- 财务总监移动电话\移动电话
            ,loancardpassword -- 贷款卡密码
            ,projectflag -- 机构目前是否有项目
            ,realtyflag -- 是否从事房地产开发
            ,isstrategycustomer -- 是否战略客户
            ,financefiamtel -- 财务负责人家庭电话
            ,financeothertel -- 财务负责人其他电话
            ,actualcontrollercounts -- 实际控制人个数
            ,investmencounts -- 主要出资人个数
            ,financetype2 -- 金融机构类型
            ,greencategory -- 绿色贷款用途
            ,governmentltype -- 政府客户类型
            ,upbelongcustid -- 上级法人机构编号
            ,stateownedentholdingflag -- 是否国企控股
            ,acceptbankid -- 承兑行行号
            ,acceptbankname -- 承兑行行名
            ,creditinstitutioncode -- 机构信用代码
            ,societyinstitutioncode -- 社会信用代码
            ,ratifydate -- 核准日期
            ,commercialregisterno -- 工商注册号
            ,taxpayerregisterno -- 纳税人识别号
            ,survivalstatus -- 存续状态
            ,environmentrisktype -- 重大环境安全风险分类
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,corpregisteradd -- 组织机构代码注册地址
            ,corpvaliditydate -- 组织机构代码有效期
            ,platformaffiliatetype -- 地方融资平台按隶属关系分类类型
            ,platformlawtype -- 地方融资平台按法律性质分类类型
            ,techcorpidentifytime -- 科技型企业认定时间
            ,techcorptype -- 地方融资平台按隶属关系分类类型
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,englishname -- 客户英文名
            ,licenseno -- 营业执照登记号
            ,licensebegin -- 证件生效日期
            ,licensematurity -- 证件失效日期
            ,nationaltaxno -- 税务登记证号(国税)
            ,landtaxno -- 税务登记证号(地税)
            ,setupdate -- 企业成立日期
            ,loancardno -- 中征码
            ,loancardflag -- 中证码是否有效
            ,supercorpname -- 上级公司名称
            ,supercertid -- 上级公司组织机构代码
            ,supercerttype -- 上级公司证件类型
            ,superloancardno -- 上级公司贷款卡编号
            ,enttype -- 客户类型
            ,entscale -- 企业规模
            ,calcuentscale -- 企业测算规模
            ,orgtype -- 组织类型
            ,orgform -- 组织形式
            ,orgbelong -- 机构隶属
            ,industrytype -- 国标行业分类
            ,ecgroupflag -- 是否集团客户标志
            ,registercurrency -- 注册资本币种
            ,registeramount -- 注册资本
            ,financedepttel -- 财务部联系电话
            ,emailadd -- 公司E－Mail
            ,finarunarea -- 金融机构经营区域范围
            ,finabranchnum -- 金融机构一级分支机构数量
            ,listingcorptype -- 上市类型
            ,employeenumber -- 企业员工人数
            ,salesamount -- 销售收入
            ,generalassets -- 企业总资产总额
            ,entindustrytype -- 企业行业类型
            ,financetype -- 同业客户-金融机构类别
            ,businessscope -- 经营范围
            ,customerhistory -- 历史沿革、管理水平简介
            ,importrightsflag -- 有无进出口经营权
            ,creditlevel -- 本行即期信用等级
            ,workfieldarea -- 经营场地面积
            ,workfieldfee -- 经营场地所有权
            ,manageinfo -- 合法经营情况
            ,mainproduction -- 主要产品情况
            ,paidcurrency -- 实收币种
            ,paidamount -- 实收资本金额
            ,groupflag -- 是否集团标志
            ,isgovernmentplarform -- 是否政府融资平台
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,firstloanflag -- 首贷标志
            ,actualcontroller -- 实际控制人
            ,freshxdcatalog -- 绿色信贷细分类目
            ,isfreshzqproj -- 是否绿色债券项目
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ent_info_op(
            basicbank -- 基本帐户行
            ,basicaccount -- 基本账户账号
            ,mybank -- 我行开户行
            ,mybankaccount -- 我行开户帐号
            ,otherbank -- 他行开户行
            ,otherbankaccount -- 他行开户帐号
            ,accountdate -- 在我行首次开立账户时间
            ,creditdate -- 与我行建立信贷关系时间
            ,evaluatedate -- 评估日期
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,swiftcode -- SWIFT代码
            ,financeorglicence -- 金融机构许可证
            ,financeorgcode -- 金融机构代码
            ,countryrisk -- 国别风险
            ,corpid -- 法人编号
            ,corporgid -- 法人机构编号
            ,registerregioncode -- 登记地行政区划代码
            ,economictype -- 经济类型
            ,countrycode -- 所在国家(地区)
            ,fictitiousperson -- 法定代表人(姓名)
            ,fictitiouspersonid -- 法定代表人证件号码（事业单位等=身份证号）
            ,listingcorpornot -- 是否上市公司标志
            ,hasiebusiness -- 有无进出口经营项目
            ,registerdate -- 注册日期
            ,mcompanyname -- 母公司名称
            ,mcompanycerttype -- 母公司证件类型
            ,mcompanycertid -- 母公司证件号码
            ,firstloandate -- 首贷日期
            ,subjectbusiness -- 主营业务
            ,industrytypeforrs -- 所属行业类型
            ,strategicemergingindustrytype -- 战略新兴产业类型
            ,corporationgrowthstage -- 企业成长阶段
            ,organiztype -- 组织机构类别
            ,orgdetail -- 组织机构类别细分
            ,ifoversea -- 是否离岸户
            ,rwacustomertype -- 加权风险资产客户分类
            ,isnewsetup -- 是否为新建企业
            ,privateent -- 是否民营企业
            ,bankingsupervision -- 是否银监小企业
            ,bankingtype -- 银监小企业规模
            ,isdebt -- 是否为逃废债企业
            ,islimit -- 是否属于两高行业
            ,laborintensiveentflag -- 是否劳动密集型企业
            ,holdingtype -- 控股类型
            ,iscountrysidenterprise -- 农村城市标志
            ,isblack -- 是否黑名单客户标志
            ,locality -- 是否我行认定小企业
            ,isfreshcust -- 是否绿色信贷标志
            ,lmcredittype -- 客户洗钱风险分类
            ,businessstrategy -- 授信策略
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,transformationandupgradeid -- 工业转型升级标识
            ,orgstatus -- 机构状态
            ,onlylimit -- 单一限额
            ,shareholderstructuredate -- 股东结构对应日期
            ,clyxcustomerid -- 策略营销客户号
            ,chargedepartment -- 上级主管单位
            ,isrelativetrade -- 是否我行关联交易
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,fundsource -- 经费来源
            ,fiscalsource -- 财政补助收入来源
            ,serviceupdateresult -- 客户服务升级分类
            ,governmentlevel -- 政府等级
            ,isrelatedparty -- 是否我行关联方标志
            ,managearea -- 政府机构行政区划
            ,financecorpid -- 非现场监管统计机构编码
            ,otherorgname -- 发证机关
            ,corpstartdate -- 发证日期
            ,isdlfr -- 是否独立法人
            ,ispart -- 是否我行股东
            ,isoverseas -- 是否海外子行客户
            ,authflag -- 是否授权
            ,isinvestcust -- 是否投资类客户
            ,distributestatus -- 分配状态
            ,customertype -- 客户机构类型
            ,ifsme -- 是否中小企业事业部专营客户
            ,fictitiouspersoncertificateid -- 法定代表人证明书标号
            ,fictitiousmobile -- 法定代表人移动电话
            ,registeradd -- 注册地址
            ,newregioncode -- 行政区域（风险预警）
            ,financedirectorname -- 财务总监姓名
            ,mobilephone -- 财务总监移动电话\移动电话
            ,loancardpassword -- 贷款卡密码
            ,projectflag -- 机构目前是否有项目
            ,realtyflag -- 是否从事房地产开发
            ,isstrategycustomer -- 是否战略客户
            ,financefiamtel -- 财务负责人家庭电话
            ,financeothertel -- 财务负责人其他电话
            ,actualcontrollercounts -- 实际控制人个数
            ,investmencounts -- 主要出资人个数
            ,financetype2 -- 金融机构类型
            ,greencategory -- 绿色贷款用途
            ,governmentltype -- 政府客户类型
            ,upbelongcustid -- 上级法人机构编号
            ,stateownedentholdingflag -- 是否国企控股
            ,acceptbankid -- 承兑行行号
            ,acceptbankname -- 承兑行行名
            ,creditinstitutioncode -- 机构信用代码
            ,societyinstitutioncode -- 社会信用代码
            ,ratifydate -- 核准日期
            ,commercialregisterno -- 工商注册号
            ,taxpayerregisterno -- 纳税人识别号
            ,survivalstatus -- 存续状态
            ,environmentrisktype -- 重大环境安全风险分类
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,corpregisteradd -- 组织机构代码注册地址
            ,corpvaliditydate -- 组织机构代码有效期
            ,platformaffiliatetype -- 地方融资平台按隶属关系分类类型
            ,platformlawtype -- 地方融资平台按法律性质分类类型
            ,techcorpidentifytime -- 科技型企业认定时间
            ,techcorptype -- 地方融资平台按隶属关系分类类型
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,englishname -- 客户英文名
            ,licenseno -- 营业执照登记号
            ,licensebegin -- 证件生效日期
            ,licensematurity -- 证件失效日期
            ,nationaltaxno -- 税务登记证号(国税)
            ,landtaxno -- 税务登记证号(地税)
            ,setupdate -- 企业成立日期
            ,loancardno -- 中征码
            ,loancardflag -- 中证码是否有效
            ,supercorpname -- 上级公司名称
            ,supercertid -- 上级公司组织机构代码
            ,supercerttype -- 上级公司证件类型
            ,superloancardno -- 上级公司贷款卡编号
            ,enttype -- 客户类型
            ,entscale -- 企业规模
            ,calcuentscale -- 企业测算规模
            ,orgtype -- 组织类型
            ,orgform -- 组织形式
            ,orgbelong -- 机构隶属
            ,industrytype -- 国标行业分类
            ,ecgroupflag -- 是否集团客户标志
            ,registercurrency -- 注册资本币种
            ,registeramount -- 注册资本
            ,financedepttel -- 财务部联系电话
            ,emailadd -- 公司E－Mail
            ,finarunarea -- 金融机构经营区域范围
            ,finabranchnum -- 金融机构一级分支机构数量
            ,listingcorptype -- 上市类型
            ,employeenumber -- 企业员工人数
            ,salesamount -- 销售收入
            ,generalassets -- 企业总资产总额
            ,entindustrytype -- 企业行业类型
            ,financetype -- 同业客户-金融机构类别
            ,businessscope -- 经营范围
            ,customerhistory -- 历史沿革、管理水平简介
            ,importrightsflag -- 有无进出口经营权
            ,creditlevel -- 本行即期信用等级
            ,workfieldarea -- 经营场地面积
            ,workfieldfee -- 经营场地所有权
            ,manageinfo -- 合法经营情况
            ,mainproduction -- 主要产品情况
            ,paidcurrency -- 实收币种
            ,paidamount -- 实收资本金额
            ,groupflag -- 是否集团标志
            ,isgovernmentplarform -- 是否政府融资平台
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,firstloanflag -- 首贷标志
            ,actualcontroller -- 实际控制人
            ,freshxdcatalog -- 绿色信贷细分类目
            ,isfreshzqproj -- 是否绿色债券项目
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.basicbank, o.basicbank) as basicbank -- 基本帐户行
    ,nvl(n.basicaccount, o.basicaccount) as basicaccount -- 基本账户账号
    ,nvl(n.mybank, o.mybank) as mybank -- 我行开户行
    ,nvl(n.mybankaccount, o.mybankaccount) as mybankaccount -- 我行开户帐号
    ,nvl(n.otherbank, o.otherbank) as otherbank -- 他行开户行
    ,nvl(n.otherbankaccount, o.otherbankaccount) as otherbankaccount -- 他行开户帐号
    ,nvl(n.accountdate, o.accountdate) as accountdate -- 在我行首次开立账户时间
    ,nvl(n.creditdate, o.creditdate) as creditdate -- 与我行建立信贷关系时间
    ,nvl(n.evaluatedate, o.evaluatedate) as evaluatedate -- 评估日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.swiftcode, o.swiftcode) as swiftcode -- SWIFT代码
    ,nvl(n.financeorglicence, o.financeorglicence) as financeorglicence -- 金融机构许可证
    ,nvl(n.financeorgcode, o.financeorgcode) as financeorgcode -- 金融机构代码
    ,nvl(n.countryrisk, o.countryrisk) as countryrisk -- 国别风险
    ,nvl(n.corpid, o.corpid) as corpid -- 法人编号
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.registerregioncode, o.registerregioncode) as registerregioncode -- 登记地行政区划代码
    ,nvl(n.economictype, o.economictype) as economictype -- 经济类型
    ,nvl(n.countrycode, o.countrycode) as countrycode -- 所在国家(地区)
    ,nvl(n.fictitiousperson, o.fictitiousperson) as fictitiousperson -- 法定代表人(姓名)
    ,nvl(n.fictitiouspersonid, o.fictitiouspersonid) as fictitiouspersonid -- 法定代表人证件号码（事业单位等=身份证号）
    ,nvl(n.listingcorpornot, o.listingcorpornot) as listingcorpornot -- 是否上市公司标志
    ,nvl(n.hasiebusiness, o.hasiebusiness) as hasiebusiness -- 有无进出口经营项目
    ,nvl(n.registerdate, o.registerdate) as registerdate -- 注册日期
    ,nvl(n.mcompanyname, o.mcompanyname) as mcompanyname -- 母公司名称
    ,nvl(n.mcompanycerttype, o.mcompanycerttype) as mcompanycerttype -- 母公司证件类型
    ,nvl(n.mcompanycertid, o.mcompanycertid) as mcompanycertid -- 母公司证件号码
    ,nvl(n.firstloandate, o.firstloandate) as firstloandate -- 首贷日期
    ,nvl(n.subjectbusiness, o.subjectbusiness) as subjectbusiness -- 主营业务
    ,nvl(n.industrytypeforrs, o.industrytypeforrs) as industrytypeforrs -- 所属行业类型
    ,nvl(n.strategicemergingindustrytype, o.strategicemergingindustrytype) as strategicemergingindustrytype -- 战略新兴产业类型
    ,nvl(n.corporationgrowthstage, o.corporationgrowthstage) as corporationgrowthstage -- 企业成长阶段
    ,nvl(n.organiztype, o.organiztype) as organiztype -- 组织机构类别
    ,nvl(n.orgdetail, o.orgdetail) as orgdetail -- 组织机构类别细分
    ,nvl(n.ifoversea, o.ifoversea) as ifoversea -- 是否离岸户
    ,nvl(n.rwacustomertype, o.rwacustomertype) as rwacustomertype -- 加权风险资产客户分类
    ,nvl(n.isnewsetup, o.isnewsetup) as isnewsetup -- 是否为新建企业
    ,nvl(n.privateent, o.privateent) as privateent -- 是否民营企业
    ,nvl(n.bankingsupervision, o.bankingsupervision) as bankingsupervision -- 是否银监小企业
    ,nvl(n.bankingtype, o.bankingtype) as bankingtype -- 银监小企业规模
    ,nvl(n.isdebt, o.isdebt) as isdebt -- 是否为逃废债企业
    ,nvl(n.islimit, o.islimit) as islimit -- 是否属于两高行业
    ,nvl(n.laborintensiveentflag, o.laborintensiveentflag) as laborintensiveentflag -- 是否劳动密集型企业
    ,nvl(n.holdingtype, o.holdingtype) as holdingtype -- 控股类型
    ,nvl(n.iscountrysidenterprise, o.iscountrysidenterprise) as iscountrysidenterprise -- 农村城市标志
    ,nvl(n.isblack, o.isblack) as isblack -- 是否黑名单客户标志
    ,nvl(n.locality, o.locality) as locality -- 是否我行认定小企业
    ,nvl(n.isfreshcust, o.isfreshcust) as isfreshcust -- 是否绿色信贷标志
    ,nvl(n.lmcredittype, o.lmcredittype) as lmcredittype -- 客户洗钱风险分类
    ,nvl(n.businessstrategy, o.businessstrategy) as businessstrategy -- 授信策略
    ,nvl(n.industrialrestructuringtype, o.industrialrestructuringtype) as industrialrestructuringtype -- 客户产业结构调整类型
    ,nvl(n.transformationandupgradeid, o.transformationandupgradeid) as transformationandupgradeid -- 工业转型升级标识
    ,nvl(n.orgstatus, o.orgstatus) as orgstatus -- 机构状态
    ,nvl(n.onlylimit, o.onlylimit) as onlylimit -- 单一限额
    ,nvl(n.shareholderstructuredate, o.shareholderstructuredate) as shareholderstructuredate -- 股东结构对应日期
    ,nvl(n.clyxcustomerid, o.clyxcustomerid) as clyxcustomerid -- 策略营销客户号
    ,nvl(n.chargedepartment, o.chargedepartment) as chargedepartment -- 上级主管单位
    ,nvl(n.isrelativetrade, o.isrelativetrade) as isrelativetrade -- 是否我行关联交易
    ,nvl(n.corpidetitytype, o.corpidetitytype) as corpidetitytype -- 征信报送企业身份标识类型
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 经费来源
    ,nvl(n.fiscalsource, o.fiscalsource) as fiscalsource -- 财政补助收入来源
    ,nvl(n.serviceupdateresult, o.serviceupdateresult) as serviceupdateresult -- 客户服务升级分类
    ,nvl(n.governmentlevel, o.governmentlevel) as governmentlevel -- 政府等级
    ,nvl(n.isrelatedparty, o.isrelatedparty) as isrelatedparty -- 是否我行关联方标志
    ,nvl(n.managearea, o.managearea) as managearea -- 政府机构行政区划
    ,nvl(n.financecorpid, o.financecorpid) as financecorpid -- 非现场监管统计机构编码
    ,nvl(n.otherorgname, o.otherorgname) as otherorgname -- 发证机关
    ,nvl(n.corpstartdate, o.corpstartdate) as corpstartdate -- 发证日期
    ,nvl(n.isdlfr, o.isdlfr) as isdlfr -- 是否独立法人
    ,nvl(n.ispart, o.ispart) as ispart -- 是否我行股东
    ,nvl(n.isoverseas, o.isoverseas) as isoverseas -- 是否海外子行客户
    ,nvl(n.authflag, o.authflag) as authflag -- 是否授权
    ,nvl(n.isinvestcust, o.isinvestcust) as isinvestcust -- 是否投资类客户
    ,nvl(n.distributestatus, o.distributestatus) as distributestatus -- 分配状态
    ,nvl(n.customertype, o.customertype) as customertype -- 客户机构类型
    ,nvl(n.ifsme, o.ifsme) as ifsme -- 是否中小企业事业部专营客户
    ,nvl(n.fictitiouspersoncertificateid, o.fictitiouspersoncertificateid) as fictitiouspersoncertificateid -- 法定代表人证明书标号
    ,nvl(n.fictitiousmobile, o.fictitiousmobile) as fictitiousmobile -- 法定代表人移动电话
    ,nvl(n.registeradd, o.registeradd) as registeradd -- 注册地址
    ,nvl(n.newregioncode, o.newregioncode) as newregioncode -- 行政区域（风险预警）
    ,nvl(n.financedirectorname, o.financedirectorname) as financedirectorname -- 财务总监姓名
    ,nvl(n.mobilephone, o.mobilephone) as mobilephone -- 财务总监移动电话\移动电话
    ,nvl(n.loancardpassword, o.loancardpassword) as loancardpassword -- 贷款卡密码
    ,nvl(n.projectflag, o.projectflag) as projectflag -- 机构目前是否有项目
    ,nvl(n.realtyflag, o.realtyflag) as realtyflag -- 是否从事房地产开发
    ,nvl(n.isstrategycustomer, o.isstrategycustomer) as isstrategycustomer -- 是否战略客户
    ,nvl(n.financefiamtel, o.financefiamtel) as financefiamtel -- 财务负责人家庭电话
    ,nvl(n.financeothertel, o.financeothertel) as financeothertel -- 财务负责人其他电话
    ,nvl(n.actualcontrollercounts, o.actualcontrollercounts) as actualcontrollercounts -- 实际控制人个数
    ,nvl(n.investmencounts, o.investmencounts) as investmencounts -- 主要出资人个数
    ,nvl(n.financetype2, o.financetype2) as financetype2 -- 金融机构类型
    ,nvl(n.greencategory, o.greencategory) as greencategory -- 绿色贷款用途
    ,nvl(n.governmentltype, o.governmentltype) as governmentltype -- 政府客户类型
    ,nvl(n.upbelongcustid, o.upbelongcustid) as upbelongcustid -- 上级法人机构编号
    ,nvl(n.stateownedentholdingflag, o.stateownedentholdingflag) as stateownedentholdingflag -- 是否国企控股
    ,nvl(n.acceptbankid, o.acceptbankid) as acceptbankid -- 承兑行行号
    ,nvl(n.acceptbankname, o.acceptbankname) as acceptbankname -- 承兑行行名
    ,nvl(n.creditinstitutioncode, o.creditinstitutioncode) as creditinstitutioncode -- 机构信用代码
    ,nvl(n.societyinstitutioncode, o.societyinstitutioncode) as societyinstitutioncode -- 社会信用代码
    ,nvl(n.ratifydate, o.ratifydate) as ratifydate -- 核准日期
    ,nvl(n.commercialregisterno, o.commercialregisterno) as commercialregisterno -- 工商注册号
    ,nvl(n.taxpayerregisterno, o.taxpayerregisterno) as taxpayerregisterno -- 纳税人识别号
    ,nvl(n.survivalstatus, o.survivalstatus) as survivalstatus -- 存续状态
    ,nvl(n.environmentrisktype, o.environmentrisktype) as environmentrisktype -- 重大环境安全风险分类
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.corpregisteradd, o.corpregisteradd) as corpregisteradd -- 组织机构代码注册地址
    ,nvl(n.corpvaliditydate, o.corpvaliditydate) as corpvaliditydate -- 组织机构代码有效期
    ,nvl(n.platformaffiliatetype, o.platformaffiliatetype) as platformaffiliatetype -- 地方融资平台按隶属关系分类类型
    ,nvl(n.platformlawtype, o.platformlawtype) as platformlawtype -- 地方融资平台按法律性质分类类型
    ,nvl(n.techcorpidentifytime, o.techcorpidentifytime) as techcorpidentifytime -- 科技型企业认定时间
    ,nvl(n.techcorptype, o.techcorptype) as techcorptype -- 地方融资平台按隶属关系分类类型
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.englishname, o.englishname) as englishname -- 客户英文名
    ,nvl(n.licenseno, o.licenseno) as licenseno -- 营业执照登记号
    ,nvl(n.licensebegin, o.licensebegin) as licensebegin -- 证件生效日期
    ,nvl(n.licensematurity, o.licensematurity) as licensematurity -- 证件失效日期
    ,nvl(n.nationaltaxno, o.nationaltaxno) as nationaltaxno -- 税务登记证号(国税)
    ,nvl(n.landtaxno, o.landtaxno) as landtaxno -- 税务登记证号(地税)
    ,nvl(n.setupdate, o.setupdate) as setupdate -- 企业成立日期
    ,nvl(n.loancardno, o.loancardno) as loancardno -- 中征码
    ,nvl(n.loancardflag, o.loancardflag) as loancardflag -- 中证码是否有效
    ,nvl(n.supercorpname, o.supercorpname) as supercorpname -- 上级公司名称
    ,nvl(n.supercertid, o.supercertid) as supercertid -- 上级公司组织机构代码
    ,nvl(n.supercerttype, o.supercerttype) as supercerttype -- 上级公司证件类型
    ,nvl(n.superloancardno, o.superloancardno) as superloancardno -- 上级公司贷款卡编号
    ,nvl(n.enttype, o.enttype) as enttype -- 客户类型
    ,nvl(n.entscale, o.entscale) as entscale -- 企业规模
    ,nvl(n.calcuentscale, o.calcuentscale) as calcuentscale -- 企业测算规模
    ,nvl(n.orgtype, o.orgtype) as orgtype -- 组织类型
    ,nvl(n.orgform, o.orgform) as orgform -- 组织形式
    ,nvl(n.orgbelong, o.orgbelong) as orgbelong -- 机构隶属
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 国标行业分类
    ,nvl(n.ecgroupflag, o.ecgroupflag) as ecgroupflag -- 是否集团客户标志
    ,nvl(n.registercurrency, o.registercurrency) as registercurrency -- 注册资本币种
    ,nvl(n.registeramount, o.registeramount) as registeramount -- 注册资本
    ,nvl(n.financedepttel, o.financedepttel) as financedepttel -- 财务部联系电话
    ,nvl(n.emailadd, o.emailadd) as emailadd -- 公司E－Mail
    ,nvl(n.finarunarea, o.finarunarea) as finarunarea -- 金融机构经营区域范围
    ,nvl(n.finabranchnum, o.finabranchnum) as finabranchnum -- 金融机构一级分支机构数量
    ,nvl(n.listingcorptype, o.listingcorptype) as listingcorptype -- 上市类型
    ,nvl(n.employeenumber, o.employeenumber) as employeenumber -- 企业员工人数
    ,nvl(n.salesamount, o.salesamount) as salesamount -- 销售收入
    ,nvl(n.generalassets, o.generalassets) as generalassets -- 企业总资产总额
    ,nvl(n.entindustrytype, o.entindustrytype) as entindustrytype -- 企业行业类型
    ,nvl(n.financetype, o.financetype) as financetype -- 同业客户-金融机构类别
    ,nvl(n.businessscope, o.businessscope) as businessscope -- 经营范围
    ,nvl(n.customerhistory, o.customerhistory) as customerhistory -- 历史沿革、管理水平简介
    ,nvl(n.importrightsflag, o.importrightsflag) as importrightsflag -- 有无进出口经营权
    ,nvl(n.creditlevel, o.creditlevel) as creditlevel -- 本行即期信用等级
    ,nvl(n.workfieldarea, o.workfieldarea) as workfieldarea -- 经营场地面积
    ,nvl(n.workfieldfee, o.workfieldfee) as workfieldfee -- 经营场地所有权
    ,nvl(n.manageinfo, o.manageinfo) as manageinfo -- 合法经营情况
    ,nvl(n.mainproduction, o.mainproduction) as mainproduction -- 主要产品情况
    ,nvl(n.paidcurrency, o.paidcurrency) as paidcurrency -- 实收币种
    ,nvl(n.paidamount, o.paidamount) as paidamount -- 实收资本金额
    ,nvl(n.groupflag, o.groupflag) as groupflag -- 是否集团标志
    ,nvl(n.isgovernmentplarform, o.isgovernmentplarform) as isgovernmentplarform -- 是否政府融资平台
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.firstloanflag, o.firstloanflag) as firstloanflag -- 首贷标志
    ,nvl(n.actualcontroller, o.actualcontroller) as actualcontroller -- 实际控制人
    ,nvl(n.freshxdcatalog, o.freshxdcatalog) as freshxdcatalog -- 绿色信贷细分类目
    ,nvl(n.isfreshzqproj, o.isfreshzqproj) as isfreshzqproj -- 是否绿色债券项目
    ,nvl(n.advancedmanuflag, o.advancedmanuflag) as advancedmanuflag -- 先进制造业标志（0-否，1-是）
    ,nvl(n.cultureindustryflag, o.cultureindustryflag) as cultureindustryflag -- 文化产业标志（0-否，1-是）
    ,nvl(n.onlynewentflag, o.onlynewentflag) as onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
    ,nvl(n.onlynewsmallentflag, o.onlynewsmallentflag) as onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
    ,nvl(n.ecodepartmentcode, o.ecodepartmentcode) as ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ent_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ent_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.basicbank <> n.basicbank
        or o.basicaccount <> n.basicaccount
        or o.mybank <> n.mybank
        or o.mybankaccount <> n.mybankaccount
        or o.otherbank <> n.otherbank
        or o.otherbankaccount <> n.otherbankaccount
        or o.accountdate <> n.accountdate
        or o.creditdate <> n.creditdate
        or o.evaluatedate <> n.evaluatedate
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.swiftcode <> n.swiftcode
        or o.financeorglicence <> n.financeorglicence
        or o.financeorgcode <> n.financeorgcode
        or o.countryrisk <> n.countryrisk
        or o.corpid <> n.corpid
        or o.corporgid <> n.corporgid
        or o.registerregioncode <> n.registerregioncode
        or o.economictype <> n.economictype
        or o.countrycode <> n.countrycode
        or o.fictitiousperson <> n.fictitiousperson
        or o.fictitiouspersonid <> n.fictitiouspersonid
        or o.listingcorpornot <> n.listingcorpornot
        or o.hasiebusiness <> n.hasiebusiness
        or o.registerdate <> n.registerdate
        or o.mcompanyname <> n.mcompanyname
        or o.mcompanycerttype <> n.mcompanycerttype
        or o.mcompanycertid <> n.mcompanycertid
        or o.firstloandate <> n.firstloandate
        or o.subjectbusiness <> n.subjectbusiness
        or o.industrytypeforrs <> n.industrytypeforrs
        or o.strategicemergingindustrytype <> n.strategicemergingindustrytype
        or o.corporationgrowthstage <> n.corporationgrowthstage
        or o.organiztype <> n.organiztype
        or o.orgdetail <> n.orgdetail
        or o.ifoversea <> n.ifoversea
        or o.rwacustomertype <> n.rwacustomertype
        or o.isnewsetup <> n.isnewsetup
        or o.privateent <> n.privateent
        or o.bankingsupervision <> n.bankingsupervision
        or o.bankingtype <> n.bankingtype
        or o.isdebt <> n.isdebt
        or o.islimit <> n.islimit
        or o.laborintensiveentflag <> n.laborintensiveentflag
        or o.holdingtype <> n.holdingtype
        or o.iscountrysidenterprise <> n.iscountrysidenterprise
        or o.isblack <> n.isblack
        or o.locality <> n.locality
        or o.isfreshcust <> n.isfreshcust
        or o.lmcredittype <> n.lmcredittype
        or o.businessstrategy <> n.businessstrategy
        or o.industrialrestructuringtype <> n.industrialrestructuringtype
        or o.transformationandupgradeid <> n.transformationandupgradeid
        or o.orgstatus <> n.orgstatus
        or o.onlylimit <> n.onlylimit
        or o.shareholderstructuredate <> n.shareholderstructuredate
        or o.clyxcustomerid <> n.clyxcustomerid
        or o.chargedepartment <> n.chargedepartment
        or o.isrelativetrade <> n.isrelativetrade
        or o.corpidetitytype <> n.corpidetitytype
        or o.fundsource <> n.fundsource
        or o.fiscalsource <> n.fiscalsource
        or o.serviceupdateresult <> n.serviceupdateresult
        or o.governmentlevel <> n.governmentlevel
        or o.isrelatedparty <> n.isrelatedparty
        or o.managearea <> n.managearea
        or o.financecorpid <> n.financecorpid
        or o.otherorgname <> n.otherorgname
        or o.corpstartdate <> n.corpstartdate
        or o.isdlfr <> n.isdlfr
        or o.ispart <> n.ispart
        or o.isoverseas <> n.isoverseas
        or o.authflag <> n.authflag
        or o.isinvestcust <> n.isinvestcust
        or o.distributestatus <> n.distributestatus
        or o.customertype <> n.customertype
        or o.ifsme <> n.ifsme
        or o.fictitiouspersoncertificateid <> n.fictitiouspersoncertificateid
        or o.fictitiousmobile <> n.fictitiousmobile
        or o.registeradd <> n.registeradd
        or o.newregioncode <> n.newregioncode
        or o.financedirectorname <> n.financedirectorname
        or o.mobilephone <> n.mobilephone
        or o.loancardpassword <> n.loancardpassword
        or o.projectflag <> n.projectflag
        or o.realtyflag <> n.realtyflag
        or o.isstrategycustomer <> n.isstrategycustomer
        or o.financefiamtel <> n.financefiamtel
        or o.financeothertel <> n.financeothertel
        or o.actualcontrollercounts <> n.actualcontrollercounts
        or o.investmencounts <> n.investmencounts
        or o.financetype2 <> n.financetype2
        or o.greencategory <> n.greencategory
        or o.governmentltype <> n.governmentltype
        or o.upbelongcustid <> n.upbelongcustid
        or o.stateownedentholdingflag <> n.stateownedentholdingflag
        or o.acceptbankid <> n.acceptbankid
        or o.acceptbankname <> n.acceptbankname
        or o.creditinstitutioncode <> n.creditinstitutioncode
        or o.societyinstitutioncode <> n.societyinstitutioncode
        or o.ratifydate <> n.ratifydate
        or o.commercialregisterno <> n.commercialregisterno
        or o.taxpayerregisterno <> n.taxpayerregisterno
        or o.survivalstatus <> n.survivalstatus
        or o.environmentrisktype <> n.environmentrisktype
        or o.migtflag <> n.migtflag
        or o.corpregisteradd <> n.corpregisteradd
        or o.corpvaliditydate <> n.corpvaliditydate
        or o.platformaffiliatetype <> n.platformaffiliatetype
        or o.platformlawtype <> n.platformlawtype
        or o.techcorpidentifytime <> n.techcorpidentifytime
        or o.techcorptype <> n.techcorptype
        or o.customername <> n.customername
        or o.englishname <> n.englishname
        or o.licenseno <> n.licenseno
        or o.licensebegin <> n.licensebegin
        or o.licensematurity <> n.licensematurity
        or o.nationaltaxno <> n.nationaltaxno
        or o.landtaxno <> n.landtaxno
        or o.setupdate <> n.setupdate
        or o.loancardno <> n.loancardno
        or o.loancardflag <> n.loancardflag
        or o.supercorpname <> n.supercorpname
        or o.supercertid <> n.supercertid
        or o.supercerttype <> n.supercerttype
        or o.superloancardno <> n.superloancardno
        or o.enttype <> n.enttype
        or o.entscale <> n.entscale
        or o.calcuentscale <> n.calcuentscale
        or o.orgtype <> n.orgtype
        or o.orgform <> n.orgform
        or o.orgbelong <> n.orgbelong
        or o.industrytype <> n.industrytype
        or o.ecgroupflag <> n.ecgroupflag
        or o.registercurrency <> n.registercurrency
        or o.registeramount <> n.registeramount
        or o.financedepttel <> n.financedepttel
        or o.emailadd <> n.emailadd
        or o.finarunarea <> n.finarunarea
        or o.finabranchnum <> n.finabranchnum
        or o.listingcorptype <> n.listingcorptype
        or o.employeenumber <> n.employeenumber
        or o.salesamount <> n.salesamount
        or o.generalassets <> n.generalassets
        or o.entindustrytype <> n.entindustrytype
        or o.financetype <> n.financetype
        or o.businessscope <> n.businessscope
        or o.customerhistory <> n.customerhistory
        or o.importrightsflag <> n.importrightsflag
        or o.creditlevel <> n.creditlevel
        or o.workfieldarea <> n.workfieldarea
        or o.workfieldfee <> n.workfieldfee
        or o.manageinfo <> n.manageinfo
        or o.mainproduction <> n.mainproduction
        or o.paidcurrency <> n.paidcurrency
        or o.paidamount <> n.paidamount
        or o.groupflag <> n.groupflag
        or o.isgovernmentplarform <> n.isgovernmentplarform
        or o.migtoldvalue <> n.migtoldvalue
        or o.firstloanflag <> n.firstloanflag
        or o.actualcontroller <> n.actualcontroller
        or o.freshxdcatalog <> n.freshxdcatalog
        or o.isfreshzqproj <> n.isfreshzqproj
        or o.advancedmanuflag <> n.advancedmanuflag
        or o.cultureindustryflag <> n.cultureindustryflag
        or o.onlynewentflag <> n.onlynewentflag
        or o.onlynewsmallentflag <> n.onlynewsmallentflag
        or o.ecodepartmentcode <> n.ecodepartmentcode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ent_info_cl(
            basicbank -- 基本帐户行
            ,basicaccount -- 基本账户账号
            ,mybank -- 我行开户行
            ,mybankaccount -- 我行开户帐号
            ,otherbank -- 他行开户行
            ,otherbankaccount -- 他行开户帐号
            ,accountdate -- 在我行首次开立账户时间
            ,creditdate -- 与我行建立信贷关系时间
            ,evaluatedate -- 评估日期
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,swiftcode -- SWIFT代码
            ,financeorglicence -- 金融机构许可证
            ,financeorgcode -- 金融机构代码
            ,countryrisk -- 国别风险
            ,corpid -- 法人编号
            ,corporgid -- 法人机构编号
            ,registerregioncode -- 登记地行政区划代码
            ,economictype -- 经济类型
            ,countrycode -- 所在国家(地区)
            ,fictitiousperson -- 法定代表人(姓名)
            ,fictitiouspersonid -- 法定代表人证件号码（事业单位等=身份证号）
            ,listingcorpornot -- 是否上市公司标志
            ,hasiebusiness -- 有无进出口经营项目
            ,registerdate -- 注册日期
            ,mcompanyname -- 母公司名称
            ,mcompanycerttype -- 母公司证件类型
            ,mcompanycertid -- 母公司证件号码
            ,firstloandate -- 首贷日期
            ,subjectbusiness -- 主营业务
            ,industrytypeforrs -- 所属行业类型
            ,strategicemergingindustrytype -- 战略新兴产业类型
            ,corporationgrowthstage -- 企业成长阶段
            ,organiztype -- 组织机构类别
            ,orgdetail -- 组织机构类别细分
            ,ifoversea -- 是否离岸户
            ,rwacustomertype -- 加权风险资产客户分类
            ,isnewsetup -- 是否为新建企业
            ,privateent -- 是否民营企业
            ,bankingsupervision -- 是否银监小企业
            ,bankingtype -- 银监小企业规模
            ,isdebt -- 是否为逃废债企业
            ,islimit -- 是否属于两高行业
            ,laborintensiveentflag -- 是否劳动密集型企业
            ,holdingtype -- 控股类型
            ,iscountrysidenterprise -- 农村城市标志
            ,isblack -- 是否黑名单客户标志
            ,locality -- 是否我行认定小企业
            ,isfreshcust -- 是否绿色信贷标志
            ,lmcredittype -- 客户洗钱风险分类
            ,businessstrategy -- 授信策略
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,transformationandupgradeid -- 工业转型升级标识
            ,orgstatus -- 机构状态
            ,onlylimit -- 单一限额
            ,shareholderstructuredate -- 股东结构对应日期
            ,clyxcustomerid -- 策略营销客户号
            ,chargedepartment -- 上级主管单位
            ,isrelativetrade -- 是否我行关联交易
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,fundsource -- 经费来源
            ,fiscalsource -- 财政补助收入来源
            ,serviceupdateresult -- 客户服务升级分类
            ,governmentlevel -- 政府等级
            ,isrelatedparty -- 是否我行关联方标志
            ,managearea -- 政府机构行政区划
            ,financecorpid -- 非现场监管统计机构编码
            ,otherorgname -- 发证机关
            ,corpstartdate -- 发证日期
            ,isdlfr -- 是否独立法人
            ,ispart -- 是否我行股东
            ,isoverseas -- 是否海外子行客户
            ,authflag -- 是否授权
            ,isinvestcust -- 是否投资类客户
            ,distributestatus -- 分配状态
            ,customertype -- 客户机构类型
            ,ifsme -- 是否中小企业事业部专营客户
            ,fictitiouspersoncertificateid -- 法定代表人证明书标号
            ,fictitiousmobile -- 法定代表人移动电话
            ,registeradd -- 注册地址
            ,newregioncode -- 行政区域（风险预警）
            ,financedirectorname -- 财务总监姓名
            ,mobilephone -- 财务总监移动电话\移动电话
            ,loancardpassword -- 贷款卡密码
            ,projectflag -- 机构目前是否有项目
            ,realtyflag -- 是否从事房地产开发
            ,isstrategycustomer -- 是否战略客户
            ,financefiamtel -- 财务负责人家庭电话
            ,financeothertel -- 财务负责人其他电话
            ,actualcontrollercounts -- 实际控制人个数
            ,investmencounts -- 主要出资人个数
            ,financetype2 -- 金融机构类型
            ,greencategory -- 绿色贷款用途
            ,governmentltype -- 政府客户类型
            ,upbelongcustid -- 上级法人机构编号
            ,stateownedentholdingflag -- 是否国企控股
            ,acceptbankid -- 承兑行行号
            ,acceptbankname -- 承兑行行名
            ,creditinstitutioncode -- 机构信用代码
            ,societyinstitutioncode -- 社会信用代码
            ,ratifydate -- 核准日期
            ,commercialregisterno -- 工商注册号
            ,taxpayerregisterno -- 纳税人识别号
            ,survivalstatus -- 存续状态
            ,environmentrisktype -- 重大环境安全风险分类
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,corpregisteradd -- 组织机构代码注册地址
            ,corpvaliditydate -- 组织机构代码有效期
            ,platformaffiliatetype -- 地方融资平台按隶属关系分类类型
            ,platformlawtype -- 地方融资平台按法律性质分类类型
            ,techcorpidentifytime -- 科技型企业认定时间
            ,techcorptype -- 地方融资平台按隶属关系分类类型
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,englishname -- 客户英文名
            ,licenseno -- 营业执照登记号
            ,licensebegin -- 证件生效日期
            ,licensematurity -- 证件失效日期
            ,nationaltaxno -- 税务登记证号(国税)
            ,landtaxno -- 税务登记证号(地税)
            ,setupdate -- 企业成立日期
            ,loancardno -- 中征码
            ,loancardflag -- 中证码是否有效
            ,supercorpname -- 上级公司名称
            ,supercertid -- 上级公司组织机构代码
            ,supercerttype -- 上级公司证件类型
            ,superloancardno -- 上级公司贷款卡编号
            ,enttype -- 客户类型
            ,entscale -- 企业规模
            ,calcuentscale -- 企业测算规模
            ,orgtype -- 组织类型
            ,orgform -- 组织形式
            ,orgbelong -- 机构隶属
            ,industrytype -- 国标行业分类
            ,ecgroupflag -- 是否集团客户标志
            ,registercurrency -- 注册资本币种
            ,registeramount -- 注册资本
            ,financedepttel -- 财务部联系电话
            ,emailadd -- 公司E－Mail
            ,finarunarea -- 金融机构经营区域范围
            ,finabranchnum -- 金融机构一级分支机构数量
            ,listingcorptype -- 上市类型
            ,employeenumber -- 企业员工人数
            ,salesamount -- 销售收入
            ,generalassets -- 企业总资产总额
            ,entindustrytype -- 企业行业类型
            ,financetype -- 同业客户-金融机构类别
            ,businessscope -- 经营范围
            ,customerhistory -- 历史沿革、管理水平简介
            ,importrightsflag -- 有无进出口经营权
            ,creditlevel -- 本行即期信用等级
            ,workfieldarea -- 经营场地面积
            ,workfieldfee -- 经营场地所有权
            ,manageinfo -- 合法经营情况
            ,mainproduction -- 主要产品情况
            ,paidcurrency -- 实收币种
            ,paidamount -- 实收资本金额
            ,groupflag -- 是否集团标志
            ,isgovernmentplarform -- 是否政府融资平台
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,firstloanflag -- 首贷标志
            ,actualcontroller -- 实际控制人
            ,freshxdcatalog -- 绿色信贷细分类目
            ,isfreshzqproj -- 是否绿色债券项目
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ent_info_op(
            basicbank -- 基本帐户行
            ,basicaccount -- 基本账户账号
            ,mybank -- 我行开户行
            ,mybankaccount -- 我行开户帐号
            ,otherbank -- 他行开户行
            ,otherbankaccount -- 他行开户帐号
            ,accountdate -- 在我行首次开立账户时间
            ,creditdate -- 与我行建立信贷关系时间
            ,evaluatedate -- 评估日期
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,swiftcode -- SWIFT代码
            ,financeorglicence -- 金融机构许可证
            ,financeorgcode -- 金融机构代码
            ,countryrisk -- 国别风险
            ,corpid -- 法人编号
            ,corporgid -- 法人机构编号
            ,registerregioncode -- 登记地行政区划代码
            ,economictype -- 经济类型
            ,countrycode -- 所在国家(地区)
            ,fictitiousperson -- 法定代表人(姓名)
            ,fictitiouspersonid -- 法定代表人证件号码（事业单位等=身份证号）
            ,listingcorpornot -- 是否上市公司标志
            ,hasiebusiness -- 有无进出口经营项目
            ,registerdate -- 注册日期
            ,mcompanyname -- 母公司名称
            ,mcompanycerttype -- 母公司证件类型
            ,mcompanycertid -- 母公司证件号码
            ,firstloandate -- 首贷日期
            ,subjectbusiness -- 主营业务
            ,industrytypeforrs -- 所属行业类型
            ,strategicemergingindustrytype -- 战略新兴产业类型
            ,corporationgrowthstage -- 企业成长阶段
            ,organiztype -- 组织机构类别
            ,orgdetail -- 组织机构类别细分
            ,ifoversea -- 是否离岸户
            ,rwacustomertype -- 加权风险资产客户分类
            ,isnewsetup -- 是否为新建企业
            ,privateent -- 是否民营企业
            ,bankingsupervision -- 是否银监小企业
            ,bankingtype -- 银监小企业规模
            ,isdebt -- 是否为逃废债企业
            ,islimit -- 是否属于两高行业
            ,laborintensiveentflag -- 是否劳动密集型企业
            ,holdingtype -- 控股类型
            ,iscountrysidenterprise -- 农村城市标志
            ,isblack -- 是否黑名单客户标志
            ,locality -- 是否我行认定小企业
            ,isfreshcust -- 是否绿色信贷标志
            ,lmcredittype -- 客户洗钱风险分类
            ,businessstrategy -- 授信策略
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,transformationandupgradeid -- 工业转型升级标识
            ,orgstatus -- 机构状态
            ,onlylimit -- 单一限额
            ,shareholderstructuredate -- 股东结构对应日期
            ,clyxcustomerid -- 策略营销客户号
            ,chargedepartment -- 上级主管单位
            ,isrelativetrade -- 是否我行关联交易
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,fundsource -- 经费来源
            ,fiscalsource -- 财政补助收入来源
            ,serviceupdateresult -- 客户服务升级分类
            ,governmentlevel -- 政府等级
            ,isrelatedparty -- 是否我行关联方标志
            ,managearea -- 政府机构行政区划
            ,financecorpid -- 非现场监管统计机构编码
            ,otherorgname -- 发证机关
            ,corpstartdate -- 发证日期
            ,isdlfr -- 是否独立法人
            ,ispart -- 是否我行股东
            ,isoverseas -- 是否海外子行客户
            ,authflag -- 是否授权
            ,isinvestcust -- 是否投资类客户
            ,distributestatus -- 分配状态
            ,customertype -- 客户机构类型
            ,ifsme -- 是否中小企业事业部专营客户
            ,fictitiouspersoncertificateid -- 法定代表人证明书标号
            ,fictitiousmobile -- 法定代表人移动电话
            ,registeradd -- 注册地址
            ,newregioncode -- 行政区域（风险预警）
            ,financedirectorname -- 财务总监姓名
            ,mobilephone -- 财务总监移动电话\移动电话
            ,loancardpassword -- 贷款卡密码
            ,projectflag -- 机构目前是否有项目
            ,realtyflag -- 是否从事房地产开发
            ,isstrategycustomer -- 是否战略客户
            ,financefiamtel -- 财务负责人家庭电话
            ,financeothertel -- 财务负责人其他电话
            ,actualcontrollercounts -- 实际控制人个数
            ,investmencounts -- 主要出资人个数
            ,financetype2 -- 金融机构类型
            ,greencategory -- 绿色贷款用途
            ,governmentltype -- 政府客户类型
            ,upbelongcustid -- 上级法人机构编号
            ,stateownedentholdingflag -- 是否国企控股
            ,acceptbankid -- 承兑行行号
            ,acceptbankname -- 承兑行行名
            ,creditinstitutioncode -- 机构信用代码
            ,societyinstitutioncode -- 社会信用代码
            ,ratifydate -- 核准日期
            ,commercialregisterno -- 工商注册号
            ,taxpayerregisterno -- 纳税人识别号
            ,survivalstatus -- 存续状态
            ,environmentrisktype -- 重大环境安全风险分类
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,corpregisteradd -- 组织机构代码注册地址
            ,corpvaliditydate -- 组织机构代码有效期
            ,platformaffiliatetype -- 地方融资平台按隶属关系分类类型
            ,platformlawtype -- 地方融资平台按法律性质分类类型
            ,techcorpidentifytime -- 科技型企业认定时间
            ,techcorptype -- 地方融资平台按隶属关系分类类型
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,englishname -- 客户英文名
            ,licenseno -- 营业执照登记号
            ,licensebegin -- 证件生效日期
            ,licensematurity -- 证件失效日期
            ,nationaltaxno -- 税务登记证号(国税)
            ,landtaxno -- 税务登记证号(地税)
            ,setupdate -- 企业成立日期
            ,loancardno -- 中征码
            ,loancardflag -- 中证码是否有效
            ,supercorpname -- 上级公司名称
            ,supercertid -- 上级公司组织机构代码
            ,supercerttype -- 上级公司证件类型
            ,superloancardno -- 上级公司贷款卡编号
            ,enttype -- 客户类型
            ,entscale -- 企业规模
            ,calcuentscale -- 企业测算规模
            ,orgtype -- 组织类型
            ,orgform -- 组织形式
            ,orgbelong -- 机构隶属
            ,industrytype -- 国标行业分类
            ,ecgroupflag -- 是否集团客户标志
            ,registercurrency -- 注册资本币种
            ,registeramount -- 注册资本
            ,financedepttel -- 财务部联系电话
            ,emailadd -- 公司E－Mail
            ,finarunarea -- 金融机构经营区域范围
            ,finabranchnum -- 金融机构一级分支机构数量
            ,listingcorptype -- 上市类型
            ,employeenumber -- 企业员工人数
            ,salesamount -- 销售收入
            ,generalassets -- 企业总资产总额
            ,entindustrytype -- 企业行业类型
            ,financetype -- 同业客户-金融机构类别
            ,businessscope -- 经营范围
            ,customerhistory -- 历史沿革、管理水平简介
            ,importrightsflag -- 有无进出口经营权
            ,creditlevel -- 本行即期信用等级
            ,workfieldarea -- 经营场地面积
            ,workfieldfee -- 经营场地所有权
            ,manageinfo -- 合法经营情况
            ,mainproduction -- 主要产品情况
            ,paidcurrency -- 实收币种
            ,paidamount -- 实收资本金额
            ,groupflag -- 是否集团标志
            ,isgovernmentplarform -- 是否政府融资平台
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,firstloanflag -- 首贷标志
            ,actualcontroller -- 实际控制人
            ,freshxdcatalog -- 绿色信贷细分类目
            ,isfreshzqproj -- 是否绿色债券项目
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.basicbank -- 基本帐户行
    ,o.basicaccount -- 基本账户账号
    ,o.mybank -- 我行开户行
    ,o.mybankaccount -- 我行开户帐号
    ,o.otherbank -- 他行开户行
    ,o.otherbankaccount -- 他行开户帐号
    ,o.accountdate -- 在我行首次开立账户时间
    ,o.creditdate -- 与我行建立信贷关系时间
    ,o.evaluatedate -- 评估日期
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构编号
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.swiftcode -- SWIFT代码
    ,o.financeorglicence -- 金融机构许可证
    ,o.financeorgcode -- 金融机构代码
    ,o.countryrisk -- 国别风险
    ,o.corpid -- 法人编号
    ,o.corporgid -- 法人机构编号
    ,o.registerregioncode -- 登记地行政区划代码
    ,o.economictype -- 经济类型
    ,o.countrycode -- 所在国家(地区)
    ,o.fictitiousperson -- 法定代表人(姓名)
    ,o.fictitiouspersonid -- 法定代表人证件号码（事业单位等=身份证号）
    ,o.listingcorpornot -- 是否上市公司标志
    ,o.hasiebusiness -- 有无进出口经营项目
    ,o.registerdate -- 注册日期
    ,o.mcompanyname -- 母公司名称
    ,o.mcompanycerttype -- 母公司证件类型
    ,o.mcompanycertid -- 母公司证件号码
    ,o.firstloandate -- 首贷日期
    ,o.subjectbusiness -- 主营业务
    ,o.industrytypeforrs -- 所属行业类型
    ,o.strategicemergingindustrytype -- 战略新兴产业类型
    ,o.corporationgrowthstage -- 企业成长阶段
    ,o.organiztype -- 组织机构类别
    ,o.orgdetail -- 组织机构类别细分
    ,o.ifoversea -- 是否离岸户
    ,o.rwacustomertype -- 加权风险资产客户分类
    ,o.isnewsetup -- 是否为新建企业
    ,o.privateent -- 是否民营企业
    ,o.bankingsupervision -- 是否银监小企业
    ,o.bankingtype -- 银监小企业规模
    ,o.isdebt -- 是否为逃废债企业
    ,o.islimit -- 是否属于两高行业
    ,o.laborintensiveentflag -- 是否劳动密集型企业
    ,o.holdingtype -- 控股类型
    ,o.iscountrysidenterprise -- 农村城市标志
    ,o.isblack -- 是否黑名单客户标志
    ,o.locality -- 是否我行认定小企业
    ,o.isfreshcust -- 是否绿色信贷标志
    ,o.lmcredittype -- 客户洗钱风险分类
    ,o.businessstrategy -- 授信策略
    ,o.industrialrestructuringtype -- 客户产业结构调整类型
    ,o.transformationandupgradeid -- 工业转型升级标识
    ,o.orgstatus -- 机构状态
    ,o.onlylimit -- 单一限额
    ,o.shareholderstructuredate -- 股东结构对应日期
    ,o.clyxcustomerid -- 策略营销客户号
    ,o.chargedepartment -- 上级主管单位
    ,o.isrelativetrade -- 是否我行关联交易
    ,o.corpidetitytype -- 征信报送企业身份标识类型
    ,o.fundsource -- 经费来源
    ,o.fiscalsource -- 财政补助收入来源
    ,o.serviceupdateresult -- 客户服务升级分类
    ,o.governmentlevel -- 政府等级
    ,o.isrelatedparty -- 是否我行关联方标志
    ,o.managearea -- 政府机构行政区划
    ,o.financecorpid -- 非现场监管统计机构编码
    ,o.otherorgname -- 发证机关
    ,o.corpstartdate -- 发证日期
    ,o.isdlfr -- 是否独立法人
    ,o.ispart -- 是否我行股东
    ,o.isoverseas -- 是否海外子行客户
    ,o.authflag -- 是否授权
    ,o.isinvestcust -- 是否投资类客户
    ,o.distributestatus -- 分配状态
    ,o.customertype -- 客户机构类型
    ,o.ifsme -- 是否中小企业事业部专营客户
    ,o.fictitiouspersoncertificateid -- 法定代表人证明书标号
    ,o.fictitiousmobile -- 法定代表人移动电话
    ,o.registeradd -- 注册地址
    ,o.newregioncode -- 行政区域（风险预警）
    ,o.financedirectorname -- 财务总监姓名
    ,o.mobilephone -- 财务总监移动电话\移动电话
    ,o.loancardpassword -- 贷款卡密码
    ,o.projectflag -- 机构目前是否有项目
    ,o.realtyflag -- 是否从事房地产开发
    ,o.isstrategycustomer -- 是否战略客户
    ,o.financefiamtel -- 财务负责人家庭电话
    ,o.financeothertel -- 财务负责人其他电话
    ,o.actualcontrollercounts -- 实际控制人个数
    ,o.investmencounts -- 主要出资人个数
    ,o.financetype2 -- 金融机构类型
    ,o.greencategory -- 绿色贷款用途
    ,o.governmentltype -- 政府客户类型
    ,o.upbelongcustid -- 上级法人机构编号
    ,o.stateownedentholdingflag -- 是否国企控股
    ,o.acceptbankid -- 承兑行行号
    ,o.acceptbankname -- 承兑行行名
    ,o.creditinstitutioncode -- 机构信用代码
    ,o.societyinstitutioncode -- 社会信用代码
    ,o.ratifydate -- 核准日期
    ,o.commercialregisterno -- 工商注册号
    ,o.taxpayerregisterno -- 纳税人识别号
    ,o.survivalstatus -- 存续状态
    ,o.environmentrisktype -- 重大环境安全风险分类
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.corpregisteradd -- 组织机构代码注册地址
    ,o.corpvaliditydate -- 组织机构代码有效期
    ,o.platformaffiliatetype -- 地方融资平台按隶属关系分类类型
    ,o.platformlawtype -- 地方融资平台按法律性质分类类型
    ,o.techcorpidentifytime -- 科技型企业认定时间
    ,o.techcorptype -- 地方融资平台按隶属关系分类类型
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.englishname -- 客户英文名
    ,o.licenseno -- 营业执照登记号
    ,o.licensebegin -- 证件生效日期
    ,o.licensematurity -- 证件失效日期
    ,o.nationaltaxno -- 税务登记证号(国税)
    ,o.landtaxno -- 税务登记证号(地税)
    ,o.setupdate -- 企业成立日期
    ,o.loancardno -- 中征码
    ,o.loancardflag -- 中证码是否有效
    ,o.supercorpname -- 上级公司名称
    ,o.supercertid -- 上级公司组织机构代码
    ,o.supercerttype -- 上级公司证件类型
    ,o.superloancardno -- 上级公司贷款卡编号
    ,o.enttype -- 客户类型
    ,o.entscale -- 企业规模
    ,o.calcuentscale -- 企业测算规模
    ,o.orgtype -- 组织类型
    ,o.orgform -- 组织形式
    ,o.orgbelong -- 机构隶属
    ,o.industrytype -- 国标行业分类
    ,o.ecgroupflag -- 是否集团客户标志
    ,o.registercurrency -- 注册资本币种
    ,o.registeramount -- 注册资本
    ,o.financedepttel -- 财务部联系电话
    ,o.emailadd -- 公司E－Mail
    ,o.finarunarea -- 金融机构经营区域范围
    ,o.finabranchnum -- 金融机构一级分支机构数量
    ,o.listingcorptype -- 上市类型
    ,o.employeenumber -- 企业员工人数
    ,o.salesamount -- 销售收入
    ,o.generalassets -- 企业总资产总额
    ,o.entindustrytype -- 企业行业类型
    ,o.financetype -- 同业客户-金融机构类别
    ,o.businessscope -- 经营范围
    ,o.customerhistory -- 历史沿革、管理水平简介
    ,o.importrightsflag -- 有无进出口经营权
    ,o.creditlevel -- 本行即期信用等级
    ,o.workfieldarea -- 经营场地面积
    ,o.workfieldfee -- 经营场地所有权
    ,o.manageinfo -- 合法经营情况
    ,o.mainproduction -- 主要产品情况
    ,o.paidcurrency -- 实收币种
    ,o.paidamount -- 实收资本金额
    ,o.groupflag -- 是否集团标志
    ,o.isgovernmentplarform -- 是否政府融资平台
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.firstloanflag -- 首贷标志
    ,o.actualcontroller -- 实际控制人
    ,o.freshxdcatalog -- 绿色信贷细分类目
    ,o.isfreshzqproj -- 是否绿色债券项目
    ,o.advancedmanuflag -- 先进制造业标志（0-否，1-是）
    ,o.cultureindustryflag -- 文化产业标志（0-否，1-是）
    ,o.onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
    ,o.onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
    ,o.ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
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
from ${iol_schema}.icms_ent_info_bk o
    left join ${iol_schema}.icms_ent_info_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ent_info_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ent_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ent_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ent_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ent_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ent_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ent_info_cl;
alter table ${iol_schema}.icms_ent_info exchange partition p_20991231 with table ${iol_schema}.icms_ent_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ent_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ent_info_op purge;
drop table ${iol_schema}.icms_ent_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ent_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ent_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
