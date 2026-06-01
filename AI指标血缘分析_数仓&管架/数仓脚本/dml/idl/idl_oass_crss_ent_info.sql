/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_ent_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.oass_crss_ent_info drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_ent_info drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_ent_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_ent_info (
    etl_dt  -- 数据日期
    ,customerid  -- 
    ,corpid  -- 
    ,enterprisename  -- 
    ,englishname  -- 
    ,fictitiousperson  -- 
    ,orgnature  -- 
    ,financetype  -- 
    ,enterprisebelong  -- 
    ,industrytype  -- 
    ,industrytype1  -- 
    ,industrytype2  -- 
    ,private  -- 
    ,economytype  -- 
    ,orgtype  -- 
    ,mostbusiness  -- 
    ,budgettype  -- 
    ,rccurrency  -- 
    ,registercapital  -- 
    ,pccurrency  -- 
    ,paiclupcapital  -- 
    ,fundsource  -- 
    ,totalassets  -- 
    ,netassets  -- 
    ,annualincome  -- 
    ,scope  -- 
    ,limit  -- 
    ,creditdate  -- 
    ,licenseno  -- 
    ,licensedate  -- 
    ,licensematurity  -- 
    ,setupdate  -- 
    ,inspectionyear  -- 
    ,locksituation  -- 
    ,taxno  -- 
    ,banklicense  -- 
    ,bankid  -- 
    ,managearea  -- 
    ,banchamount  -- 
    ,exchangeid  -- 
    ,registeradd  -- 
    ,chargedepartment  -- 
    ,officeadd  -- 
    ,officezip  -- 
    ,countrycode  -- 
    ,regioncode  -- 
    ,villagecode  -- 
    ,villagename  -- 
    ,relativetype  -- 
    ,officetel  -- 
    ,officefax  -- 
    ,webadd  -- 
    ,emailadd  -- 
    ,employeenumber  -- 
    ,mainproduction  -- 
    ,newtechcorpornot  -- 
    ,listingcorpornot  -- 
    ,hasieright  -- 
    ,hasdirectorate  -- 
    ,basicbank  -- 
    ,basicaccount  -- 
    ,manageinfo  -- 
    ,customerhistory  -- 
    ,projectflag  -- 
    ,realtyflag  -- 
    ,workfieldarea  -- 
    ,workfieldfee  -- 
    ,accountdate  -- 
    ,loancardno  -- 
    ,loancardpassword  -- 
    ,loancardinsyear  -- 
    ,loancardinsresult  -- 
    ,loanflag  -- 
    ,financeornot  -- 
    ,financebelong  -- 
    ,creditbelong  -- 
    ,creditlevel  -- 
    ,evaluatedate  -- 
    ,othercreditlevel  -- 
    ,otherevaluatedate  -- 
    ,otherorgname  -- 
    ,inputorgid  -- 
    ,inputuserid  -- 
    ,inputdate  -- 
    ,updateorgid  -- 
    ,updateuserid  -- 
    ,updatedate  -- 
    ,remark  -- 
    ,taxno1  -- 
    ,fictitiouspersonid  -- 
    ,groupflag  -- 
    ,evaluatelevel  -- 
    ,mybank  -- 
    ,mybankaccount  -- 
    ,otherbank  -- 
    ,otherbankaccount  -- 
    ,tempsaveflag  -- 
    ,financedepttel  -- 
    ,ecgroupflag  -- 
    ,supercorpname  -- 
    ,superloancardno  -- 
    ,supercerttype  -- 
    ,smeindustrytype  -- 
    ,sellsum  -- 
    ,supercertid  -- 
    ,isblack  -- 是否黑名单客户
    ,isdebt  -- 
    ,isstrategycustomer  -- 
    ,ifoversea  -- 
    ,serviceupdateresult  -- 
    ,rwacustomertype  -- 
    ,businessstrategy  -- 
    ,isnewsetup  -- 
    ,isrelative  -- 
    ,ifsme  -- 
    ,locality  -- 
    ,subjectbusiness  -- 
    ,islimit  -- 
    ,privateent  -- 
    ,bankingsupervision  -- 
    ,holdingtype  -- 
    ,fiscalsource  -- 
    ,lmcredittype  -- 客户洗钱风险分类
    ,onlycapital  -- 
    ,stratagemflag  -- 战略客户标志
    ,isrelatedparty  -- 是否关联方
    ,fictitiouspersoncertificateid  -- 法定代表人证明书编号
    ,corpstartdate  -- 组织机构代码起始日
    ,corpvaliditydate  -- 组织机构代码有效期
    ,corpregisteradd  -- 组织机构代码注册地址
    ,registerdate  -- 注册日期
    ,financedirectorname  -- 财务总监姓名
    ,mobilephone  -- 财务总监移动电话
    ,mfcustomerid  -- CIF客户号
    ,custtp  -- 客户类型
    ,custst  -- 客户状态
    ,iscred  -- 是否授信客户
    ,ispart  -- 是否我行股东
    ,orgown  -- 机构隶属
    ,budgtp  -- 预算形式
    ,ntlycd  -- 国别
    ,crylev  -- 行业类型(国标)
    ,mainfg  -- 是否主证件号
    ,validt  -- 证件有效期
    ,liisau  -- 发证机关
    ,others  -- 证件其他信息
    ,idtfst  -- 证件状态
    ,idcdad  -- 证件户籍地址
    ,contna  -- 联系人姓名
    ,idtftp  -- 联系人证件类型
    ,idtfno  -- 联系人证件号码
    ,cmainf  -- 是否主联系方式
    ,hometl  -- 家庭电话
    ,othrtl  -- 其他电话
    ,caiwno  -- 财务负责人证件号码
    ,caiwtp  -- 财务证件类型
    ,offitl  -- 单位电话
    ,mobitl  -- 移动电话
    ,fictitiousmobile  -- 法定代表人移动电话
    ,fictitiousduty  -- 法定代表人职务
    ,finalevaluatedate  -- 评级日期
    ,iscountrysidenterprise  -- 是否农村企业
    ,financialgroupscope  -- 商圈客户规模
    ,financialgroupposition  -- 商圈客户行业地位
    ,industrialrestructuringtype  -- 客户产业结构调整类型：1-鼓励，2-限制，3-淘汰
    ,transformationandupgradeid  -- 工业转型升级标识：1-是，2-否
    ,strategicemergingindustrytype  -- 战略新兴产业类型：1-节能环保，2-新一代信息技术，3-生物医药，4-高端装备制造，5-新能源，6-新材料，7-新能源汽车
    ,creditinstitutioncode  -- 机构信用代码
    ,parentcompanyofficeadd  -- 集团客户母公司国内办公地址
    ,officeaddupdatedate  -- 更新办公地址日期
    ,listingcorporation  -- 上市公司类型：1-A股上市、2-B股上市、3-H股上市、4-海外上市
    ,shareholderstructuredate  -- 股东结构对应日期
    ,hasiebusiness  -- 有无进出口经营项目：1-是，2-否
    ,orgdetail  -- 组织机构类别细分
    ,orgstatus  -- 机构状态
    ,organiztype  -- 组织机构类别
    ,documenttype  -- 证件类型
    ,documentno  -- 证件号码
    ,financefiamtel  -- 财务负责人家庭电话
    ,financeothertel  -- 财务负责人其他电话
    ,bankingtype  -- 银监小企业规模
    ,societyinstitutioncode  -- 社会信用代码
    ,commercialregno  -- 商事与非商事登记证号
    ,clyxcustomerid  -- 策略营销客户号
    ,onlylimit  -- 单一限额
    ,scopecalculate  -- 企业规模_系统计算
    ,raterisklevel  -- 内评客户评级
    ,industrytypeproportion  -- 第一大主营业务占比
    ,industrytypeproportion1  -- 第二大主营业务占比
    ,industrytypeproportion2  -- 第三大主营业务占比
    ,isfreshcust  -- 是否绿色信贷客户
    ,jtbbname  -- 集团本部名称
    ,mcompanyname  -- 母公司名称
    ,mcompanycerttype  -- 母公司证件类型
    ,mcompanycertid  -- 母公司证件号码
    ,acceptbankid  -- 承兑行行号
    ,acceptbankname  -- 承兑行行名
    ,isdlfr  -- 是否独立法人
    ,outdate  -- 准入名单退出时间
    ,outmsg  -- 准入名单退出原因
    ,creditdebtlimit  -- 信用债限额
    ,currencyfundlimit  -- 货币基金限额
    ,currencyfundused  -- 额度占用金额
    ,creditdebtused  -- 额度占用金额
    ,start_dt  -- 
    ,end_dt  -- 
    ,id_mark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.corpid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.enterprisename,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.englishname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fictitiousperson,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.orgnature,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.financetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.enterprisebelong,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.industrytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.industrytype1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.industrytype2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.private,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.economytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.orgtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mostbusiness,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.budgettype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rccurrency,chr(13),''),chr(10),'')  -- 
    ,t1.registercapital  -- 
    ,replace(replace(t1.pccurrency,chr(13),''),chr(10),'')  -- 
    ,t1.paiclupcapital  -- 
    ,replace(replace(t1.fundsource,chr(13),''),chr(10),'')  -- 
    ,t1.totalassets  -- 
    ,t1.netassets  -- 
    ,t1.annualincome  -- 
    ,replace(replace(t1.scope,chr(13),''),chr(10),'')  -- 
    ,t1.limit  -- 
    ,replace(replace(t1.creditdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.licenseno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.licensedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.licensematurity,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.setupdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inspectionyear,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.locksituation,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.taxno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.banklicense,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bankid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.managearea,chr(13),''),chr(10),'')  -- 
    ,t1.banchamount  -- 
    ,replace(replace(t1.exchangeid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.registeradd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chargedepartment,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.officeadd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.officezip,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.countrycode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.regioncode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.villagecode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.villagename,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.officetel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.officefax,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.webadd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.emailadd,chr(13),''),chr(10),'')  -- 
    ,t1.employeenumber  -- 
    ,replace(replace(t1.mainproduction,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.newtechcorpornot,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.listingcorpornot,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.hasieright,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.hasdirectorate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.basicbank,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.basicaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.manageinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customerhistory,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.projectflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.realtyflag,chr(13),''),chr(10),'')  -- 
    ,t1.workfieldarea  -- 
    ,replace(replace(t1.workfieldfee,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accountdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loancardno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loancardpassword,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loancardinsyear,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loancardinsresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.financeornot,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.financebelong,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditbelong,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditlevel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.evaluatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.othercreditlevel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherevaluatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherorgname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updateorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updateuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.taxno1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fictitiouspersonid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.groupflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.evaluatelevel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mybank,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mybankaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherbank,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherbankaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.financedepttel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ecgroupflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.supercorpname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.superloancardno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.supercerttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.smeindustrytype,chr(13),''),chr(10),'')  -- 
    ,t1.sellsum  -- 
    ,replace(replace(t1.supercertid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isblack,chr(13),''),chr(10),'')  -- 是否黑名单客户
    ,replace(replace(t1.isdebt,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isstrategycustomer,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ifoversea,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.serviceupdateresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rwacustomertype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businessstrategy,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isnewsetup,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isrelative,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ifsme,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.locality,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.subjectbusiness,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.islimit,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.privateent,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bankingsupervision,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.holdingtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fiscalsource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.lmcredittype,chr(13),''),chr(10),'')  -- 客户洗钱风险分类
    ,replace(replace(t1.onlycapital,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.stratagemflag,chr(13),''),chr(10),'')  -- 战略客户标志
    ,replace(replace(t1.isrelatedparty,chr(13),''),chr(10),'')  -- 是否关联方
    ,replace(replace(t1.fictitiouspersoncertificateid,chr(13),''),chr(10),'')  -- 法定代表人证明书编号
    ,replace(replace(t1.corpstartdate,chr(13),''),chr(10),'')  -- 组织机构代码起始日
    ,replace(replace(t1.corpvaliditydate,chr(13),''),chr(10),'')  -- 组织机构代码有效期
    ,replace(replace(t1.corpregisteradd,chr(13),''),chr(10),'')  -- 组织机构代码注册地址
    ,replace(replace(t1.registerdate,chr(13),''),chr(10),'')  -- 注册日期
    ,replace(replace(t1.financedirectorname,chr(13),''),chr(10),'')  -- 财务总监姓名
    ,replace(replace(t1.mobilephone,chr(13),''),chr(10),'')  -- 财务总监移动电话
    ,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'')  -- CIF客户号
    ,replace(replace(t1.custtp,chr(13),''),chr(10),'')  -- 客户类型
    ,replace(replace(t1.custst,chr(13),''),chr(10),'')  -- 客户状态
    ,replace(replace(t1.iscred,chr(13),''),chr(10),'')  -- 是否授信客户
    ,replace(replace(t1.ispart,chr(13),''),chr(10),'')  -- 是否我行股东
    ,replace(replace(t1.orgown,chr(13),''),chr(10),'')  -- 机构隶属
    ,replace(replace(t1.budgtp,chr(13),''),chr(10),'')  -- 预算形式
    ,replace(replace(t1.ntlycd,chr(13),''),chr(10),'')  -- 国别
    ,replace(replace(t1.crylev,chr(13),''),chr(10),'')  -- 行业类型(国标)
    ,replace(replace(t1.mainfg,chr(13),''),chr(10),'')  -- 是否主证件号
    ,replace(replace(t1.validt,chr(13),''),chr(10),'')  -- 证件有效期
    ,replace(replace(t1.liisau,chr(13),''),chr(10),'')  -- 发证机关
    ,replace(replace(t1.others,chr(13),''),chr(10),'')  -- 证件其他信息
    ,replace(replace(t1.idtfst,chr(13),''),chr(10),'')  -- 证件状态
    ,replace(replace(t1.idcdad,chr(13),''),chr(10),'')  -- 证件户籍地址
    ,replace(replace(t1.contna,chr(13),''),chr(10),'')  -- 联系人姓名
    ,replace(replace(t1.idtftp,chr(13),''),chr(10),'')  -- 联系人证件类型
    ,replace(replace(t1.idtfno,chr(13),''),chr(10),'')  -- 联系人证件号码
    ,replace(replace(t1.cmainf,chr(13),''),chr(10),'')  -- 是否主联系方式
    ,replace(replace(t1.hometl,chr(13),''),chr(10),'')  -- 家庭电话
    ,replace(replace(t1.othrtl,chr(13),''),chr(10),'')  -- 其他电话
    ,replace(replace(t1.caiwno,chr(13),''),chr(10),'')  -- 财务负责人证件号码
    ,replace(replace(t1.caiwtp,chr(13),''),chr(10),'')  -- 财务证件类型
    ,replace(replace(t1.offitl,chr(13),''),chr(10),'')  -- 单位电话
    ,replace(replace(t1.mobitl,chr(13),''),chr(10),'')  -- 移动电话
    ,replace(replace(t1.fictitiousmobile,chr(13),''),chr(10),'')  -- 法定代表人移动电话
    ,replace(replace(t1.fictitiousduty,chr(13),''),chr(10),'')  -- 法定代表人职务
    ,replace(replace(t1.finalevaluatedate,chr(13),''),chr(10),'')  -- 评级日期
    ,replace(replace(t1.iscountrysidenterprise,chr(13),''),chr(10),'')  -- 是否农村企业
    ,replace(replace(t1.financialgroupscope,chr(13),''),chr(10),'')  -- 商圈客户规模
    ,replace(replace(t1.financialgroupposition,chr(13),''),chr(10),'')  -- 商圈客户行业地位
    ,replace(replace(t1.industrialrestructuringtype,chr(13),''),chr(10),'')  -- 客户产业结构调整类型：1-鼓励，2-限制，3-淘汰
    ,replace(replace(t1.transformationandupgradeid,chr(13),''),chr(10),'')  -- 工业转型升级标识：1-是，2-否
    ,replace(replace(t1.strategicemergingindustrytype,chr(13),''),chr(10),'')  -- 战略新兴产业类型：1-节能环保，2-新一代信息技术，3-生物医药，4-高端装备制造，5-新能源，6-新材料，7-新能源汽车
    ,replace(replace(t1.creditinstitutioncode,chr(13),''),chr(10),'')  -- 机构信用代码
    ,replace(replace(t1.parentcompanyofficeadd,chr(13),''),chr(10),'')  -- 集团客户母公司国内办公地址
    ,replace(replace(t1.officeaddupdatedate,chr(13),''),chr(10),'')  -- 更新办公地址日期
    ,replace(replace(t1.listingcorporation,chr(13),''),chr(10),'')  -- 上市公司类型：1-A股上市、2-B股上市、3-H股上市、4-海外上市
    ,replace(replace(t1.shareholderstructuredate,chr(13),''),chr(10),'')  -- 股东结构对应日期
    ,replace(replace(t1.hasiebusiness,chr(13),''),chr(10),'')  -- 有无进出口经营项目：1-是，2-否
    ,replace(replace(t1.orgdetail,chr(13),''),chr(10),'')  -- 组织机构类别细分
    ,replace(replace(t1.orgstatus,chr(13),''),chr(10),'')  -- 机构状态
    ,replace(replace(t1.organiztype,chr(13),''),chr(10),'')  -- 组织机构类别
    ,replace(replace(t1.documenttype,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(t1.documentno,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.financefiamtel,chr(13),''),chr(10),'')  -- 财务负责人家庭电话
    ,replace(replace(t1.financeothertel,chr(13),''),chr(10),'')  -- 财务负责人其他电话
    ,replace(replace(t1.bankingtype,chr(13),''),chr(10),'')  -- 银监小企业规模
    ,replace(replace(t1.societyinstitutioncode,chr(13),''),chr(10),'')  -- 社会信用代码
    ,replace(replace(t1.commercialregno,chr(13),''),chr(10),'')  -- 商事与非商事登记证号
    ,replace(replace(t1.clyxcustomerid,chr(13),''),chr(10),'')  -- 策略营销客户号
    ,t1.onlylimit  -- 单一限额
    ,replace(replace(t1.scopecalculate,chr(13),''),chr(10),'')  -- 企业规模_系统计算
    ,replace(replace(t1.raterisklevel,chr(13),''),chr(10),'')  -- 内评客户评级
    ,t1.industrytypeproportion  -- 第一大主营业务占比
    ,t1.industrytypeproportion1  -- 第二大主营业务占比
    ,t1.industrytypeproportion2  -- 第三大主营业务占比
    ,replace(replace(t1.isfreshcust,chr(13),''),chr(10),'')  -- 是否绿色信贷客户
    ,replace(replace(t1.jtbbname,chr(13),''),chr(10),'')  -- 集团本部名称
    ,replace(replace(t1.mcompanyname,chr(13),''),chr(10),'')  -- 母公司名称
    ,replace(replace(t1.mcompanycerttype,chr(13),''),chr(10),'')  -- 母公司证件类型
    ,replace(replace(t1.mcompanycertid,chr(13),''),chr(10),'')  -- 母公司证件号码
    ,replace(replace(t1.acceptbankid,chr(13),''),chr(10),'')  -- 承兑行行号
    ,replace(replace(t1.acceptbankname,chr(13),''),chr(10),'')  -- 承兑行行名
    ,replace(replace(t1.isdlfr,chr(13),''),chr(10),'')  -- 是否独立法人
    ,replace(replace(t1.outdate,chr(13),''),chr(10),'')  -- 准入名单退出时间
    ,replace(replace(t1.outmsg,chr(13),''),chr(10),'')  -- 准入名单退出原因
    ,t1.creditdebtlimit  -- 信用债限额
    ,t1.currencyfundlimit  -- 货币基金限额
    ,t1.currencyfundused  -- 额度占用金额
    ,t1.creditdebtused  -- 额度占用金额
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_ent_info t1    --企业基本信息
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_ent_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);