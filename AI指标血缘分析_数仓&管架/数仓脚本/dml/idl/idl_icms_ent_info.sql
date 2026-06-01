/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_ent_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icms_ent_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_ent_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_ent_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,basicbank  -- 基本帐户行
    ,basicaccount  -- 基本帐户号
    ,mybank  -- 我行开户行
    ,mybankaccount  -- 我行开户帐号
    ,otherbank  -- 他行开户行
    ,otherbankaccount  -- 他行开户帐号
    ,accountdate  -- 在我行首次开立账户时间
    ,creditdate  -- 与我行建立信贷关系时间
    ,evaluatedate  -- 评估日期
    ,remark  -- 备注
    ,inputuserid  -- 登记人
    ,inputorgid  -- 登记机构
    ,inputdate  -- 登记日期
    ,updateuserid  -- 更新人
    ,updateorgid  -- 更新机构
    ,updatedate  -- 更新日期
    ,swiftcode  -- swift代码
    ,financeorglicence  -- 金融机构许可证
    ,financeorgcode  -- 金融机构代码
    ,countryrisk  -- 国别风险
    ,corpid  -- 法人编号
    ,corporgid  -- 法人机构编号
    ,registerregioncode  -- 登记地行政区划代码
    ,economictype  -- 经济类型
    ,countrycode  -- 所在国家(地区)
    ,fictitiousperson  -- 法定代表人(姓名)
    ,fictitiouspersonid  -- 法定代表人证件号码（事业单位等=身份证号）
    ,listingcorpornot  -- 是否上市公司
    ,hasiebusiness  -- 有无进出口经营项目
    ,registerdate  -- 注册日期
    ,mcompanyname  -- 母公司名称
    ,mcompanycerttype  -- 母公司证件类型
    ,mcompanycertid  -- 母公司证件号码
    ,firstloandate  -- 首贷日期
    ,subjectbusiness  -- 主营业务
    ,industrytypeforrs  -- 客户所属行业分类（征信）
    ,strategicemergingindustrytype  -- 战略新兴产业类型
    ,corporationgrowthstage  -- 企业成长阶段
    ,organiztype  -- 组织机构类别
    ,orgdetail  -- 组织机构类别细分
    ,ifoversea  -- 是否离岸户
    ,rwacustomertype  -- 加权风险资产客户分类
    ,isnewsetup  -- 是否为新建企业
    ,privateent  -- 是否民营企业
    ,bankingsupervision  -- 是否银监小企业
    ,bankingtype  -- 银监小企业规模
    ,isdebt  -- 是否为逃废债企业
    ,islimit  -- 是否属于两高行业
    ,laborintensiveentflag  -- 是否劳动密集型企业
    ,holdingtype  -- 控股类型
    ,iscountrysidenterprise  -- 是否农村企业
    ,isblack  -- 是否黑名单客户
    ,locality  -- 是否我行认定小企业
    ,isfreshcust  -- 是否绿色信贷客户
    ,lmcredittype  -- 客户洗钱风险分类
    ,businessstrategy  -- 授信策略
    ,industrialrestructuringtype  -- 客户产业结构调整类型
    ,transformationandupgradeid  -- 工业转型升级标识
    ,orgstatus  -- 机构状态
    ,onlylimit  -- 单一限额
    ,shareholderstructuredate  -- 股东结构对应日期
    ,clyxcustomerid  -- 策略营销客户号
    ,chargedepartment  -- 上级主管单位
    ,isrelativetrade  -- 是否我行关联交易
    ,corpidetitytype  -- 征信报送企业身份标识类型
    ,fundsource  -- 经费来源
    ,fiscalsource  -- 财政补助收入来源
    ,serviceupdateresult  -- 客户服务升级分类
    ,governmentlevel  -- 政府等级
    ,isrelatedparty  -- 是否我行关联方
    ,managearea  -- 政府机构行政区划
    ,financecorpid  -- 非现场监管统计机构编码
    ,otherorgname  -- 发证机关
    ,corpstartdate  -- 发证日期
    ,isdlfr  -- 是否独立法人
    ,ispart  -- 是否我行股东
    ,isoverseas  -- 是否海外子行客户
    ,authflag  -- 是否授权
    ,isinvestcust  -- 是否投资类客户
    ,distributestatus  -- 分配状态
    ,customertype  -- 客户类型
    ,ifsme  -- 是否中小企业事业部专营客户
    ,fictitiouspersoncertificateid  -- 法定代表人证明书标号
    ,fictitiousmobile  -- 法定代表人移动电话
    ,registeradd  -- 注册地址
    ,newregioncode  -- 行政区域（风险预警）
    ,financedirectorname  -- 财务总监姓名
    ,mobilephone  -- 财务总监移动电话\移动电话
    ,loancardpassword  -- 贷款卡密码
    ,projectflag  -- 机构目前是否有项目
    ,realtyflag  -- 是否从事房地产开发
    ,isstrategycustomer  -- 是否战略客户
    ,financefiamtel  -- 财务负责人家庭电话
    ,financeothertel  -- 财务负责人其他电话
    ,actualcontrollercounts  -- 实际控制人个数
    ,investmencounts  -- 主要出资人个数
    ,financetype2  -- 金融机构类型
    ,greencategory  -- 绿色信贷细分类目
    ,governmentltype  -- 政府客户类型
    ,upbelongcustid  -- 上级法人机构编号
    ,stateownedentholdingflag  -- 是否国企控股
    ,acceptbankid  -- 承兑行行号
    ,acceptbankname  -- 承兑行行名
    ,creditinstitutioncode  -- 机构信用代码
    ,societyinstitutioncode  -- 社会信用代码
    ,customerid  -- 客户编号
    ,customername  -- 客户名称
    ,englishname  -- 客户英文名
    ,licenseno  -- 营业执照登记号
    ,licensebegin  -- 营业执照登记日
    ,licensematurity  -- 营业执照到期日
    ,nationaltaxno  -- 税务登记证号(国税)
    ,landtaxno  -- 税务登记证号(地税)
    ,setupdate  -- 企业成立日期
    ,loancardno  -- 中证码
    ,loancardflag  -- 中证码是否有效
    ,supercorpname  -- 上级公司名称
    ,supercertid  -- 上级公司组织机构代码
    ,supercerttype  -- 上级公司证件类型
    ,superloancardno  -- 上级公司贷款卡编号
    ,enttype  -- 客户类型
    ,entscale  -- 企业规模
    ,calcuentscale  -- 企业测算规模
    ,orgtype  -- 组织类型
    ,orgform  -- 组织形式
    ,orgbelong  -- 机构隶属
    ,industrytype  -- 国标行业分类
    ,ecgroupflag  -- 是否征信标准集团客户
    ,registercurrency  -- 注册资本币种
    ,registeramount  -- 注册资本
    ,financedepttel  -- 财务部联系电话
    ,emailadd  -- 公司e－mail
    ,finarunarea  -- 金融机构经营区域范围
    ,finabranchnum  -- 金融机构一级分支机构数量
    ,listingcorptype  -- 上市公司类型
    ,employeenumber  -- 职工人数
    ,salesamount  -- 销售收入
    ,generalassets  -- 资产总额
    ,entindustrytype  -- 企业行业类型
    ,financetype  -- 同业客户类型
    ,businessscope  -- 经营范围
    ,customerhistory  -- 历史沿革、管理水平简介
    ,importrightsflag  -- 有无进出口经营权
    ,creditlevel  -- 本行即期信用等级
    ,workfieldarea  -- 经营场地面积
    ,workfieldfee  -- 经营场地所有权
    ,manageinfo  -- 合法经营情况
    ,mainproduction  -- 主要产品情况
    ,paidcurrency  -- 实收币种
    ,paidamount  -- 实收金额
    ,groupflag  -- 是否集团标志
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,ratifydate  -- 核准日期
    ,commercialregisterno  -- 工商注册号
    ,taxpayerregisterno  -- 纳税人识别号
    ,survivalstatus  -- 存续状态
    ,environmentrisktype  -- 重大环境安全风险分类
    ,migtflag  -- 迁移标志：crs rcr ilc upl
    ,corpregisteradd  -- 组织机构代码注册地址
    ,corpvaliditydate  -- 组织机构代码有效期
    ,platformaffiliatetype  -- 地方融资平台按隶属关系分类类型
    ,platformlawtype  -- 地方融资平台按法律性质分类类型
    ,techcorpidentifytime  -- 科技型企业认定时间
    ,techcorptype  -- 地方融资平台按隶属关系分类类型
    ,isgovernmentplarform  -- 是否政府融资平台
    ,migtoldvalue  -- 迁移数据-参数转换前字段值
    ,firstloanflag  -- 首贷标志
    ,actualcontroller  -- 实际控制人
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.basicbank,chr(13),''),chr(10),'') as basicbank  -- 基本帐户行
    ,replace(replace(t.basicaccount,chr(13),''),chr(10),'') as basicaccount  -- 基本帐户号
    ,replace(replace(t.mybank,chr(13),''),chr(10),'') as mybank  -- 我行开户行
    ,replace(replace(t.mybankaccount,chr(13),''),chr(10),'') as mybankaccount  -- 我行开户帐号
    ,replace(replace(t.otherbank,chr(13),''),chr(10),'') as otherbank  -- 他行开户行
    ,replace(replace(t.otherbankaccount,chr(13),''),chr(10),'') as otherbankaccount  -- 他行开户帐号
    ,t.accountdate as accountdate  -- 在我行首次开立账户时间
    ,t.creditdate as creditdate  -- 与我行建立信贷关系时间
    ,t.evaluatedate as evaluatedate  -- 评估日期
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark  -- 备注
    ,replace(replace(t.inputuserid,chr(13),''),chr(10),'') as inputuserid  -- 登记人
    ,replace(replace(t.inputorgid,chr(13),''),chr(10),'') as inputorgid  -- 登记机构
    ,t.inputdate as inputdate  -- 登记日期
    ,replace(replace(t.updateuserid,chr(13),''),chr(10),'') as updateuserid  -- 更新人
    ,replace(replace(t.updateorgid,chr(13),''),chr(10),'') as updateorgid  -- 更新机构
    ,t.updatedate as updatedate  -- 更新日期
    ,replace(replace(t.swiftcode,chr(13),''),chr(10),'') as swiftcode  -- swift代码
    ,replace(replace(t.financeorglicence,chr(13),''),chr(10),'') as financeorglicence  -- 金融机构许可证
    ,replace(replace(t.financeorgcode,chr(13),''),chr(10),'') as financeorgcode  -- 金融机构代码
    ,replace(replace(t.countryrisk,chr(13),''),chr(10),'') as countryrisk  -- 国别风险
    ,replace(replace(t.corpid,chr(13),''),chr(10),'') as corpid  -- 法人编号
    ,replace(replace(t.corporgid,chr(13),''),chr(10),'') as corporgid  -- 法人机构编号
    ,replace(replace(t.registerregioncode,chr(13),''),chr(10),'') as registerregioncode  -- 登记地行政区划代码
    ,replace(replace(t.economictype,chr(13),''),chr(10),'') as economictype  -- 经济类型
    ,replace(replace(t.countrycode,chr(13),''),chr(10),'') as countrycode  -- 所在国家(地区)
    ,replace(replace(t.fictitiousperson,chr(13),''),chr(10),'') as fictitiousperson  -- 法定代表人(姓名)
    ,replace(replace(t.fictitiouspersonid,chr(13),''),chr(10),'') as fictitiouspersonid  -- 法定代表人证件号码（事业单位等=身份证号）
    ,replace(replace(t.listingcorpornot,chr(13),''),chr(10),'') as listingcorpornot  -- 是否上市公司
    ,replace(replace(t.hasiebusiness,chr(13),''),chr(10),'') as hasiebusiness  -- 有无进出口经营项目
    ,t.registerdate as registerdate  -- 注册日期
    ,replace(replace(t.mcompanyname,chr(13),''),chr(10),'') as mcompanyname  -- 母公司名称
    ,replace(replace(t.mcompanycerttype,chr(13),''),chr(10),'') as mcompanycerttype  -- 母公司证件类型
    ,replace(replace(t.mcompanycertid,chr(13),''),chr(10),'') as mcompanycertid  -- 母公司证件号码
    ,t.firstloandate as firstloandate  -- 首贷日期
    ,replace(replace(t.subjectbusiness,chr(13),''),chr(10),'') as subjectbusiness  -- 主营业务
    ,replace(replace(t.industrytypeforrs,chr(13),''),chr(10),'') as industrytypeforrs  -- 客户所属行业分类（征信）
    ,replace(replace(t.strategicemergingindustrytype,chr(13),''),chr(10),'') as strategicemergingindustrytype  -- 战略新兴产业类型
    ,replace(replace(t.corporationgrowthstage,chr(13),''),chr(10),'') as corporationgrowthstage  -- 企业成长阶段
    ,replace(replace(t.organiztype,chr(13),''),chr(10),'') as organiztype  -- 组织机构类别
    ,replace(replace(t.orgdetail,chr(13),''),chr(10),'') as orgdetail  -- 组织机构类别细分
    ,replace(replace(t.ifoversea,chr(13),''),chr(10),'') as ifoversea  -- 是否离岸户
    ,replace(replace(t.rwacustomertype,chr(13),''),chr(10),'') as rwacustomertype  -- 加权风险资产客户分类
    ,replace(replace(t.isnewsetup,chr(13),''),chr(10),'') as isnewsetup  -- 是否为新建企业
    ,replace(replace(t.privateent,chr(13),''),chr(10),'') as privateent  -- 是否民营企业
    ,replace(replace(t.bankingsupervision,chr(13),''),chr(10),'') as bankingsupervision  -- 是否银监小企业
    ,replace(replace(t.bankingtype,chr(13),''),chr(10),'') as bankingtype  -- 银监小企业规模
    ,replace(replace(t.isdebt,chr(13),''),chr(10),'') as isdebt  -- 是否为逃废债企业
    ,replace(replace(t.islimit,chr(13),''),chr(10),'') as islimit  -- 是否属于两高行业
    ,replace(replace(t.laborintensiveentflag,chr(13),''),chr(10),'') as laborintensiveentflag  -- 是否劳动密集型企业
    ,replace(replace(t.holdingtype,chr(13),''),chr(10),'') as holdingtype  -- 控股类型
    ,replace(replace(t.iscountrysidenterprise,chr(13),''),chr(10),'') as iscountrysidenterprise  -- 是否农村企业
    ,replace(replace(t.isblack,chr(13),''),chr(10),'') as isblack  -- 是否黑名单客户
    ,replace(replace(t.locality,chr(13),''),chr(10),'') as locality  -- 是否我行认定小企业
    ,replace(replace(t.isfreshcust,chr(13),''),chr(10),'') as isfreshcust  -- 是否绿色信贷客户
    ,replace(replace(t.lmcredittype,chr(13),''),chr(10),'') as lmcredittype  -- 客户洗钱风险分类
    ,replace(replace(t.businessstrategy,chr(13),''),chr(10),'') as businessstrategy  -- 授信策略
    ,replace(replace(t.industrialrestructuringtype,chr(13),''),chr(10),'') as industrialrestructuringtype  -- 客户产业结构调整类型
    ,replace(replace(t.transformationandupgradeid,chr(13),''),chr(10),'') as transformationandupgradeid  -- 工业转型升级标识
    ,replace(replace(t.orgstatus,chr(13),''),chr(10),'') as orgstatus  -- 机构状态
    ,t.onlylimit as onlylimit  -- 单一限额
    ,t.shareholderstructuredate as shareholderstructuredate  -- 股东结构对应日期
    ,replace(replace(t.clyxcustomerid,chr(13),''),chr(10),'') as clyxcustomerid  -- 策略营销客户号
    ,replace(replace(t.chargedepartment,chr(13),''),chr(10),'') as chargedepartment  -- 上级主管单位
    ,replace(replace(t.isrelativetrade,chr(13),''),chr(10),'') as isrelativetrade  -- 是否我行关联交易
    ,replace(replace(t.corpidetitytype,chr(13),''),chr(10),'') as corpidetitytype  -- 征信报送企业身份标识类型
    ,replace(replace(t.fundsource,chr(13),''),chr(10),'') as fundsource  -- 经费来源
    ,replace(replace(t.fiscalsource,chr(13),''),chr(10),'') as fiscalsource  -- 财政补助收入来源
    ,replace(replace(t.serviceupdateresult,chr(13),''),chr(10),'') as serviceupdateresult  -- 客户服务升级分类
    ,replace(replace(t.governmentlevel,chr(13),''),chr(10),'') as governmentlevel  -- 政府等级
    ,replace(replace(t.isrelatedparty,chr(13),''),chr(10),'') as isrelatedparty  -- 是否我行关联方
    ,replace(replace(t.managearea,chr(13),''),chr(10),'') as managearea  -- 政府机构行政区划
    ,replace(replace(t.financecorpid,chr(13),''),chr(10),'') as financecorpid  -- 非现场监管统计机构编码
    ,replace(replace(t.otherorgname,chr(13),''),chr(10),'') as otherorgname  -- 发证机关
    ,t.corpstartdate as corpstartdate  -- 发证日期
    ,replace(replace(t.isdlfr,chr(13),''),chr(10),'') as isdlfr  -- 是否独立法人
    ,replace(replace(t.ispart,chr(13),''),chr(10),'') as ispart  -- 是否我行股东
    ,replace(replace(t.isoverseas,chr(13),''),chr(10),'') as isoverseas  -- 是否海外子行客户
    ,replace(replace(t.authflag,chr(13),''),chr(10),'') as authflag  -- 是否授权
    ,replace(replace(t.isinvestcust,chr(13),''),chr(10),'') as isinvestcust  -- 是否投资类客户
    ,replace(replace(t.distributestatus,chr(13),''),chr(10),'') as distributestatus  -- 分配状态
    ,replace(replace(t.customertype,chr(13),''),chr(10),'') as customertype  -- 客户类型
    ,replace(replace(t.ifsme,chr(13),''),chr(10),'') as ifsme  -- 是否中小企业事业部专营客户
    ,replace(replace(t.fictitiouspersoncertificateid,chr(13),''),chr(10),'') as fictitiouspersoncertificateid  -- 法定代表人证明书标号
    ,replace(replace(t.fictitiousmobile,chr(13),''),chr(10),'') as fictitiousmobile  -- 法定代表人移动电话
    ,replace(replace(t.registeradd,chr(13),''),chr(10),'') as registeradd  -- 注册地址
    ,replace(replace(t.newregioncode,chr(13),''),chr(10),'') as newregioncode  -- 行政区域（风险预警）
    ,replace(replace(t.financedirectorname,chr(13),''),chr(10),'') as financedirectorname  -- 财务总监姓名
    ,replace(replace(t.mobilephone,chr(13),''),chr(10),'') as mobilephone  -- 财务总监移动电话\移动电话
    ,replace(replace(t.loancardpassword,chr(13),''),chr(10),'') as loancardpassword  -- 贷款卡密码
    ,replace(replace(t.projectflag,chr(13),''),chr(10),'') as projectflag  -- 机构目前是否有项目
    ,replace(replace(t.realtyflag,chr(13),''),chr(10),'') as realtyflag  -- 是否从事房地产开发
    ,replace(replace(t.isstrategycustomer,chr(13),''),chr(10),'') as isstrategycustomer  -- 是否战略客户
    ,replace(replace(t.financefiamtel,chr(13),''),chr(10),'') as financefiamtel  -- 财务负责人家庭电话
    ,replace(replace(t.financeothertel,chr(13),''),chr(10),'') as financeothertel  -- 财务负责人其他电话
    ,t.actualcontrollercounts as actualcontrollercounts  -- 实际控制人个数
    ,t.investmencounts as investmencounts  -- 主要出资人个数
    ,replace(replace(t.financetype2,chr(13),''),chr(10),'') as financetype2  -- 金融机构类型
    ,replace(replace(t.greencategory,chr(13),''),chr(10),'') as greencategory  -- 绿色信贷细分类目
    ,replace(replace(t.governmentltype,chr(13),''),chr(10),'') as governmentltype  -- 政府客户类型
    ,replace(replace(t.upbelongcustid,chr(13),''),chr(10),'') as upbelongcustid  -- 上级法人机构编号
    ,replace(replace(t.stateownedentholdingflag,chr(13),''),chr(10),'') as stateownedentholdingflag  -- 是否国企控股
    ,replace(replace(t.acceptbankid,chr(13),''),chr(10),'') as acceptbankid  -- 承兑行行号
    ,replace(replace(t.acceptbankname,chr(13),''),chr(10),'') as acceptbankname  -- 承兑行行名
    ,replace(replace(t.creditinstitutioncode,chr(13),''),chr(10),'') as creditinstitutioncode  -- 机构信用代码
    ,replace(replace(t.societyinstitutioncode,chr(13),''),chr(10),'') as societyinstitutioncode  -- 社会信用代码
    ,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid  -- 客户编号
    ,replace(replace(t.customername,chr(13),''),chr(10),'') as customername  -- 客户名称
    ,replace(replace(t.englishname,chr(13),''),chr(10),'') as englishname  -- 客户英文名
    ,replace(replace(t.licenseno,chr(13),''),chr(10),'') as licenseno  -- 营业执照登记号
    ,t.licensebegin as licensebegin  -- 营业执照登记日
    ,t.licensematurity as licensematurity  -- 营业执照到期日
    ,replace(replace(t.nationaltaxno,chr(13),''),chr(10),'') as nationaltaxno  -- 税务登记证号(国税)
    ,replace(replace(t.landtaxno,chr(13),''),chr(10),'') as landtaxno  -- 税务登记证号(地税)
    ,t.setupdate as setupdate  -- 企业成立日期
    ,replace(replace(t.loancardno,chr(13),''),chr(10),'') as loancardno  -- 中证码
    ,replace(replace(t.loancardflag,chr(13),''),chr(10),'') as loancardflag  -- 中证码是否有效
    ,replace(replace(t.supercorpname,chr(13),''),chr(10),'') as supercorpname  -- 上级公司名称
    ,replace(replace(t.supercertid,chr(13),''),chr(10),'') as supercertid  -- 上级公司组织机构代码
    ,replace(replace(t.supercerttype,chr(13),''),chr(10),'') as supercerttype  -- 上级公司证件类型
    ,replace(replace(t.superloancardno,chr(13),''),chr(10),'') as superloancardno  -- 上级公司贷款卡编号
    ,replace(replace(t.enttype,chr(13),''),chr(10),'') as enttype  -- 客户类型
    ,replace(replace(t.entscale,chr(13),''),chr(10),'') as entscale  -- 企业规模
    ,replace(replace(t.calcuentscale,chr(13),''),chr(10),'') as calcuentscale  -- 企业测算规模
    ,replace(replace(t.orgtype,chr(13),''),chr(10),'') as orgtype  -- 组织类型
    ,replace(replace(t.orgform,chr(13),''),chr(10),'') as orgform  -- 组织形式
    ,replace(replace(t.orgbelong,chr(13),''),chr(10),'') as orgbelong  -- 机构隶属
    ,replace(replace(t.industrytype,chr(13),''),chr(10),'') as industrytype  -- 国标行业分类
    ,replace(replace(t.ecgroupflag,chr(13),''),chr(10),'') as ecgroupflag  -- 是否征信标准集团客户
    ,replace(replace(t.registercurrency,chr(13),''),chr(10),'') as registercurrency  -- 注册资本币种
    ,t.registeramount as registeramount  -- 注册资本
    ,replace(replace(t.financedepttel,chr(13),''),chr(10),'') as financedepttel  -- 财务部联系电话
    ,replace(replace(t.emailadd,chr(13),''),chr(10),'') as emailadd  -- 公司e－mail
    ,replace(replace(t.finarunarea,chr(13),''),chr(10),'') as finarunarea  -- 金融机构经营区域范围
    ,t.finabranchnum as finabranchnum  -- 金融机构一级分支机构数量
    ,replace(replace(t.listingcorptype,chr(13),''),chr(10),'') as listingcorptype  -- 上市公司类型
    ,t.employeenumber as employeenumber  -- 职工人数
    ,t.salesamount as salesamount  -- 销售收入
    ,t.generalassets as generalassets  -- 资产总额
    ,replace(replace(t.entindustrytype,chr(13),''),chr(10),'') as entindustrytype  -- 企业行业类型
    ,replace(replace(t.financetype,chr(13),''),chr(10),'') as financetype  -- 同业客户类型
    ,replace(replace(t.businessscope,chr(13),''),chr(10),'') as businessscope  -- 经营范围
    ,replace(replace(t.customerhistory,chr(13),''),chr(10),'') as customerhistory  -- 历史沿革、管理水平简介
    ,replace(replace(t.importrightsflag,chr(13),''),chr(10),'') as importrightsflag  -- 有无进出口经营权
    ,replace(replace(t.creditlevel,chr(13),''),chr(10),'') as creditlevel  -- 本行即期信用等级
    ,t.workfieldarea as workfieldarea  -- 经营场地面积
    ,replace(replace(t.workfieldfee,chr(13),''),chr(10),'') as workfieldfee  -- 经营场地所有权
    ,replace(replace(t.manageinfo,chr(13),''),chr(10),'') as manageinfo  -- 合法经营情况
    ,replace(replace(t.mainproduction,chr(13),''),chr(10),'') as mainproduction  -- 主要产品情况
    ,replace(replace(t.paidcurrency,chr(13),''),chr(10),'') as paidcurrency  -- 实收币种
    ,t.paidamount as paidamount  -- 实收金额
    ,replace(replace(t.groupflag,chr(13),''),chr(10),'') as groupflag  -- 是否集团标志
    ,t.start_dt as start_dt  -- 开始日期
    ,t.end_dt as end_dt  -- 结束日期
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark  -- 删除标识
    ,t.ratifydate as ratifydate  -- 核准日期
    ,replace(replace(t.commercialregisterno,chr(13),''),chr(10),'') as commercialregisterno  -- 工商注册号
    ,replace(replace(t.taxpayerregisterno,chr(13),''),chr(10),'') as taxpayerregisterno  -- 纳税人识别号
    ,replace(replace(t.survivalstatus,chr(13),''),chr(10),'') as survivalstatus  -- 存续状态
    ,replace(replace(t.environmentrisktype,chr(13),''),chr(10),'') as environmentrisktype  -- 重大环境安全风险分类
    ,replace(replace(t.migtflag,chr(13),''),chr(10),'') as migtflag  -- 迁移标志：crs rcr ilc upl
    ,replace(replace(t.corpregisteradd,chr(13),''),chr(10),'') as corpregisteradd  -- 组织机构代码注册地址
    ,replace(replace(t.corpvaliditydate,chr(13),''),chr(10),'') as corpvaliditydate  -- 组织机构代码有效期
    ,replace(replace(t.platformaffiliatetype,chr(13),''),chr(10),'') as platformaffiliatetype  -- 地方融资平台按隶属关系分类类型
    ,replace(replace(t.platformlawtype,chr(13),''),chr(10),'') as platformlawtype  -- 地方融资平台按法律性质分类类型
    ,replace(replace(t.techcorpidentifytime,chr(13),''),chr(10),'') as techcorpidentifytime  -- 科技型企业认定时间
    ,replace(replace(t.techcorptype,chr(13),''),chr(10),'') as techcorptype  -- 地方融资平台按隶属关系分类类型
    ,replace(replace(t.isgovernmentplarform,chr(13),''),chr(10),'') as isgovernmentplarform  -- 是否政府融资平台
    ,replace(replace(t.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue  -- 迁移数据-参数转换前字段值
    ,replace(replace(t.firstloanflag,chr(13),''),chr(10),'') as firstloanflag  -- 首贷标志
    ,replace(replace(t.actualcontroller,chr(13),''),chr(10),'') as actualcontroller  -- 实际控制人
    ,null as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 时间戳
 from ${iol_schema}.icms_ent_info t--公司客户基本信息
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.icms_ent_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_ent_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);