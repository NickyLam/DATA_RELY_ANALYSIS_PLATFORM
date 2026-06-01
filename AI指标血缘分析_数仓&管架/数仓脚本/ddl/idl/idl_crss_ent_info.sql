/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crss_ent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.crss_ent_info
whenever sqlerror continue none;
drop table ${idl_schema}.crss_ent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.crss_ent_info(
    etl_dt date -- 数据日期   
    ,customerid varchar2(32) --    
    ,corpid varchar2(32) --    
    ,enterprisename varchar2(80) --    
    ,englishname varchar2(100) --    
    ,fictitiousperson varchar2(100) --    
    ,orgnature varchar2(18) --    
    ,financetype varchar2(18) --    
    ,enterprisebelong varchar2(18) --    
    ,industrytype varchar2(18) --    
    ,industrytype1 varchar2(18) --    
    ,industrytype2 varchar2(18) --    
    ,private varchar2(18) --    
    ,economytype varchar2(18) --    
    ,orgtype varchar2(18) --    
    ,mostbusiness varchar2(800) --    
    ,budgettype varchar2(18) --    
    ,rccurrency varchar2(18) --    
    ,registercapital number(24,6) --    
    ,pccurrency varchar2(18) --    
    ,paiclupcapital number(24,6) --    
    ,fundsource varchar2(200) --    
    ,totalassets number(24,6) --    
    ,netassets number(24,6) --    
    ,annualincome number(24,6) --    
    ,scope varchar2(18) --    
    ,limit number(24,6) --    
    ,creditdate varchar2(10) --    
    ,licenseno varchar2(32) --    
    ,licensedate varchar2(10) --    
    ,licensematurity varchar2(10) --    
    ,setupdate varchar2(10) --    
    ,inspectionyear varchar2(10) --    
    ,locksituation varchar2(200) --    
    ,taxno varchar2(32) --    
    ,banklicense varchar2(32) --    
    ,bankid varchar2(32) --    
    ,managearea varchar2(200) --    
    ,banchamount number --    
    ,exchangeid varchar2(32) --    
    ,registeradd varchar2(200) --    
    ,chargedepartment varchar2(80) --    
    ,officeadd varchar2(200) --    
    ,officezip varchar2(32) --    
    ,countrycode varchar2(18) --    
    ,regioncode varchar2(18) --    
    ,villagecode varchar2(18) --    
    ,villagename varchar2(80) --    
    ,relativetype varchar2(200) --    
    ,officetel varchar2(50) --    
    ,officefax varchar2(50) --    
    ,webadd varchar2(80) --    
    ,emailadd varchar2(80) --    
    ,employeenumber number --    
    ,mainproduction varchar2(200) --    
    ,newtechcorpornot varchar2(18) --    
    ,listingcorpornot varchar2(18) --    
    ,hasieright varchar2(18) --    
    ,hasdirectorate varchar2(18) --    
    ,basicbank varchar2(80) --    
    ,basicaccount varchar2(32) --    
    ,manageinfo varchar2(800) --    
    ,customerhistory varchar2(4000) --    
    ,projectflag varchar2(18) --    
    ,realtyflag varchar2(18) --    
    ,workfieldarea number --    
    ,workfieldfee varchar2(18) --    
    ,accountdate varchar2(10) --    
    ,loancardno varchar2(32) --    
    ,loancardpassword varchar2(32) --    
    ,loancardinsyear varchar2(10) --    
    ,loancardinsresult varchar2(200) --    
    ,loanflag varchar2(18) --    
    ,financeornot varchar2(18) --    
    ,financebelong varchar2(18) --    
    ,creditbelong varchar2(18) --    
    ,creditlevel varchar2(80) --    
    ,evaluatedate varchar2(10) --    
    ,othercreditlevel varchar2(80) --    
    ,otherevaluatedate varchar2(10) --    
    ,otherorgname varchar2(80) --    
    ,inputorgid varchar2(32) --    
    ,inputuserid varchar2(32) --    
    ,inputdate varchar2(10) --    
    ,updateorgid varchar2(32) --    
    ,updateuserid varchar2(32) --    
    ,updatedate varchar2(10) --    
    ,remark varchar2(200) --    
    ,taxno1 varchar2(32) --    
    ,fictitiouspersonid varchar2(80) --    
    ,groupflag varchar2(18) --    
    ,evaluatelevel varchar2(18) --    
    ,mybank varchar2(80) --    
    ,mybankaccount varchar2(32) --    
    ,otherbank varchar2(80) --    
    ,otherbankaccount varchar2(32) --    
    ,tempsaveflag varchar2(18) --    
    ,financedepttel varchar2(32) --    
    ,ecgroupflag varchar2(18) --    
    ,supercorpname varchar2(80) --    
    ,superloancardno varchar2(32) --    
    ,supercerttype varchar2(18) --    
    ,smeindustrytype varchar2(10) --    
    ,sellsum number(24,6) --    
    ,supercertid varchar2(32) --    
    ,isblack varchar2(32) -- 是否黑名单客户   
    ,isdebt varchar2(8) --    
    ,isstrategycustomer varchar2(10) --    
    ,ifoversea varchar2(10) --    
    ,serviceupdateresult varchar2(18) --    
    ,rwacustomertype varchar2(80) --    
    ,businessstrategy varchar2(18) --    
    ,isnewsetup varchar2(18) --    
    ,isrelative varchar2(18) --    
    ,ifsme varchar2(2) --    
    ,locality varchar2(4) --    
    ,subjectbusiness varchar2(800) --    
    ,islimit varchar2(18) --    
    ,privateent varchar2(10) --    
    ,bankingsupervision varchar2(4) --    
    ,holdingtype varchar2(18) --    
    ,fiscalsource varchar2(18) --    
    ,lmcredittype varchar2(1) -- 客户洗钱风险分类   
    ,onlycapital varchar2(24) --    
    ,stratagemflag varchar2(18) -- 战略客户标志   
    ,isrelatedparty varchar2(10) -- 是否关联方   
    ,fictitiouspersoncertificateid varchar2(50) -- 法定代表人证明书编号   
    ,corpstartdate varchar2(10) -- 组织机构代码起始日   
    ,corpvaliditydate varchar2(10) -- 组织机构代码有效期   
    ,corpregisteradd varchar2(200) -- 组织机构代码注册地址   
    ,registerdate varchar2(10) -- 注册日期   
    ,financedirectorname varchar2(80) -- 财务总监姓名   
    ,mobilephone varchar2(32) -- 财务总监移动电话   
    ,mfcustomerid varchar2(32) -- CIF客户号   
    ,custtp varchar2(2) -- 客户类型   
    ,custst varchar2(2) -- 客户状态   
    ,iscred varchar2(1) -- 是否授信客户   
    ,ispart varchar2(1) -- 是否我行股东   
    ,orgown varchar2(100) -- 机构隶属   
    ,budgtp varchar2(80) -- 预算形式   
    ,ntlycd varchar2(7) -- 国别   
    ,crylev varchar2(1) -- 行业类型(国标)   
    ,mainfg varchar2(1) -- 是否主证件号   
    ,validt varchar2(8) -- 证件有效期   
    ,liisau varchar2(100) -- 发证机关   
    ,others varchar2(50) -- 证件其他信息   
    ,idtfst varchar2(1) -- 证件状态   
    ,idcdad varchar2(200) -- 证件户籍地址   
    ,contna varchar2(100) -- 联系人姓名   
    ,idtftp varchar2(1) -- 联系人证件类型   
    ,idtfno varchar2(30) -- 联系人证件号码   
    ,cmainf varchar2(1) -- 是否主联系方式   
    ,hometl varchar2(50) -- 家庭电话   
    ,othrtl varchar2(50) -- 其他电话   
    ,caiwno varchar2(40) -- 财务负责人证件号码   
    ,caiwtp varchar2(1) -- 财务证件类型   
    ,offitl varchar2(50) -- 单位电话   
    ,mobitl varchar2(50) -- 移动电话   
    ,fictitiousmobile varchar2(50) -- 法定代表人移动电话   
    ,fictitiousduty varchar2(80) -- 法定代表人职务   
    ,finalevaluatedate varchar2(10) -- 评级日期   
    ,iscountrysidenterprise varchar2(1) -- 是否农村企业   
    ,financialgroupscope varchar2(200) -- 商圈客户规模   
    ,financialgroupposition varchar2(200) -- 商圈客户行业地位   
    ,industrialrestructuringtype varchar2(1) -- 客户产业结构调整类型：1-鼓励，2-限制，3-淘汰   
    ,transformationandupgradeid varchar2(1) -- 工业转型升级标识：1-是，2-否   
    ,strategicemergingindustrytype varchar2(1) -- 战略新兴产业类型：1-节能环保，2-新一代信息技术，3-生物医药，4-高端装备制造，5-新能源，6-新材料，7-新能源汽车   
    ,creditinstitutioncode varchar2(18) -- 机构信用代码   
    ,parentcompanyofficeadd varchar2(200) -- 集团客户母公司国内办公地址   
    ,officeaddupdatedate varchar2(10) -- 更新办公地址日期   
    ,listingcorporation varchar2(10) -- 上市公司类型：1-A股上市、2-B股上市、3-H股上市、4-海外上市   
    ,shareholderstructuredate varchar2(10) -- 股东结构对应日期   
    ,hasiebusiness varchar2(1) -- 有无进出口经营项目：1-是，2-否   
    ,orgdetail varchar2(30) -- 组织机构类别细分   
    ,orgstatus varchar2(2) -- 机构状态   
    ,organiztype varchar2(10) -- 组织机构类别   
    ,documenttype varchar2(10) -- 证件类型   
    ,documentno varchar2(30) -- 证件号码   
    ,financefiamtel varchar2(30) -- 财务负责人家庭电话   
    ,financeothertel varchar2(30) -- 财务负责人其他电话   
    ,bankingtype varchar2(10) -- 银监小企业规模   
    ,societyinstitutioncode varchar2(18) -- 社会信用代码   
    ,commercialregno varchar2(18) -- 商事与非商事登记证号   
    ,clyxcustomerid varchar2(40) -- 策略营销客户号   
    ,onlylimit number(24,6) -- 单一限额   
    ,scopecalculate varchar2(18) -- 企业规模_系统计算   
    ,raterisklevel varchar2(20) -- 内评客户评级   
    ,industrytypeproportion number(16,2) -- 第一大主营业务占比   
    ,industrytypeproportion1 number(16,2) -- 第二大主营业务占比   
    ,industrytypeproportion2 number(16,2) -- 第三大主营业务占比   
    ,isfreshcust varchar2(2) -- 是否绿色信贷客户   
    ,jtbbname varchar2(80) -- 集团本部名称   
    ,mcompanyname varchar2(80) -- 母公司名称   
    ,mcompanycerttype varchar2(10) -- 母公司证件类型   
    ,mcompanycertid varchar2(30) -- 母公司证件号码   
    ,acceptbankid varchar2(40) -- 承兑行行号   
    ,acceptbankname varchar2(40) -- 承兑行行名   
    ,isdlfr varchar2(2) -- 是否独立法人   
    ,outdate varchar2(10) -- 准入名单退出时间   
    ,outmsg varchar2(100) -- 准入名单退出原因   
    ,creditdebtlimit number(24,6) -- 信用债限额   
    ,currencyfundlimit number(24,6) -- 货币基金限额   
    ,currencyfundused number(22,6) -- 额度占用金额   
    ,creditdebtused number(22,6) -- 额度占用金额   
    ,iseduhealth varchar2(10) -- 是否文教健康   
    ,ishewpackard varchar2(10) -- 是否惠普型   
    ,corporationgrowthstage varchar2(5) -- 企业成长阶段   
    ,laborintensiveentflag varchar2(5) -- 劳动密集型企业标志   
    ,start_dt date -- 开始日期   
    ,end_dt date -- 结束日期   
    ,id_mark varchar2(10) -- 删除标识   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crss_ent_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.crss_ent_info is '企业基本信息';
comment on column ${idl_schema}.crss_ent_info.etl_dt is '数据日期';
comment on column ${idl_schema}.crss_ent_info.customerid is '';
comment on column ${idl_schema}.crss_ent_info.corpid is '';
comment on column ${idl_schema}.crss_ent_info.enterprisename is '';
comment on column ${idl_schema}.crss_ent_info.englishname is '';
comment on column ${idl_schema}.crss_ent_info.fictitiousperson is '';
comment on column ${idl_schema}.crss_ent_info.orgnature is '';
comment on column ${idl_schema}.crss_ent_info.financetype is '';
comment on column ${idl_schema}.crss_ent_info.enterprisebelong is '';
comment on column ${idl_schema}.crss_ent_info.industrytype is '';
comment on column ${idl_schema}.crss_ent_info.industrytype1 is '';
comment on column ${idl_schema}.crss_ent_info.industrytype2 is '';
comment on column ${idl_schema}.crss_ent_info.private is '';
comment on column ${idl_schema}.crss_ent_info.economytype is '';
comment on column ${idl_schema}.crss_ent_info.orgtype is '';
comment on column ${idl_schema}.crss_ent_info.mostbusiness is '';
comment on column ${idl_schema}.crss_ent_info.budgettype is '';
comment on column ${idl_schema}.crss_ent_info.rccurrency is '';
comment on column ${idl_schema}.crss_ent_info.registercapital is '';
comment on column ${idl_schema}.crss_ent_info.pccurrency is '';
comment on column ${idl_schema}.crss_ent_info.paiclupcapital is '';
comment on column ${idl_schema}.crss_ent_info.fundsource is '';
comment on column ${idl_schema}.crss_ent_info.totalassets is '';
comment on column ${idl_schema}.crss_ent_info.netassets is '';
comment on column ${idl_schema}.crss_ent_info.annualincome is '';
comment on column ${idl_schema}.crss_ent_info.scope is '';
comment on column ${idl_schema}.crss_ent_info.limit is '';
comment on column ${idl_schema}.crss_ent_info.creditdate is '';
comment on column ${idl_schema}.crss_ent_info.licenseno is '';
comment on column ${idl_schema}.crss_ent_info.licensedate is '';
comment on column ${idl_schema}.crss_ent_info.licensematurity is '';
comment on column ${idl_schema}.crss_ent_info.setupdate is '';
comment on column ${idl_schema}.crss_ent_info.inspectionyear is '';
comment on column ${idl_schema}.crss_ent_info.locksituation is '';
comment on column ${idl_schema}.crss_ent_info.taxno is '';
comment on column ${idl_schema}.crss_ent_info.banklicense is '';
comment on column ${idl_schema}.crss_ent_info.bankid is '';
comment on column ${idl_schema}.crss_ent_info.managearea is '';
comment on column ${idl_schema}.crss_ent_info.banchamount is '';
comment on column ${idl_schema}.crss_ent_info.exchangeid is '';
comment on column ${idl_schema}.crss_ent_info.registeradd is '';
comment on column ${idl_schema}.crss_ent_info.chargedepartment is '';
comment on column ${idl_schema}.crss_ent_info.officeadd is '';
comment on column ${idl_schema}.crss_ent_info.officezip is '';
comment on column ${idl_schema}.crss_ent_info.countrycode is '';
comment on column ${idl_schema}.crss_ent_info.regioncode is '';
comment on column ${idl_schema}.crss_ent_info.villagecode is '';
comment on column ${idl_schema}.crss_ent_info.villagename is '';
comment on column ${idl_schema}.crss_ent_info.relativetype is '';
comment on column ${idl_schema}.crss_ent_info.officetel is '';
comment on column ${idl_schema}.crss_ent_info.officefax is '';
comment on column ${idl_schema}.crss_ent_info.webadd is '';
comment on column ${idl_schema}.crss_ent_info.emailadd is '';
comment on column ${idl_schema}.crss_ent_info.employeenumber is '';
comment on column ${idl_schema}.crss_ent_info.mainproduction is '';
comment on column ${idl_schema}.crss_ent_info.newtechcorpornot is '';
comment on column ${idl_schema}.crss_ent_info.listingcorpornot is '';
comment on column ${idl_schema}.crss_ent_info.hasieright is '';
comment on column ${idl_schema}.crss_ent_info.hasdirectorate is '';
comment on column ${idl_schema}.crss_ent_info.basicbank is '';
comment on column ${idl_schema}.crss_ent_info.basicaccount is '';
comment on column ${idl_schema}.crss_ent_info.manageinfo is '';
comment on column ${idl_schema}.crss_ent_info.customerhistory is '';
comment on column ${idl_schema}.crss_ent_info.projectflag is '';
comment on column ${idl_schema}.crss_ent_info.realtyflag is '';
comment on column ${idl_schema}.crss_ent_info.workfieldarea is '';
comment on column ${idl_schema}.crss_ent_info.workfieldfee is '';
comment on column ${idl_schema}.crss_ent_info.accountdate is '';
comment on column ${idl_schema}.crss_ent_info.loancardno is '';
comment on column ${idl_schema}.crss_ent_info.loancardpassword is '';
comment on column ${idl_schema}.crss_ent_info.loancardinsyear is '';
comment on column ${idl_schema}.crss_ent_info.loancardinsresult is '';
comment on column ${idl_schema}.crss_ent_info.loanflag is '';
comment on column ${idl_schema}.crss_ent_info.financeornot is '';
comment on column ${idl_schema}.crss_ent_info.financebelong is '';
comment on column ${idl_schema}.crss_ent_info.creditbelong is '';
comment on column ${idl_schema}.crss_ent_info.creditlevel is '';
comment on column ${idl_schema}.crss_ent_info.evaluatedate is '';
comment on column ${idl_schema}.crss_ent_info.othercreditlevel is '';
comment on column ${idl_schema}.crss_ent_info.otherevaluatedate is '';
comment on column ${idl_schema}.crss_ent_info.otherorgname is '';
comment on column ${idl_schema}.crss_ent_info.inputorgid is '';
comment on column ${idl_schema}.crss_ent_info.inputuserid is '';
comment on column ${idl_schema}.crss_ent_info.inputdate is '';
comment on column ${idl_schema}.crss_ent_info.updateorgid is '';
comment on column ${idl_schema}.crss_ent_info.updateuserid is '';
comment on column ${idl_schema}.crss_ent_info.updatedate is '';
comment on column ${idl_schema}.crss_ent_info.remark is '';
comment on column ${idl_schema}.crss_ent_info.taxno1 is '';
comment on column ${idl_schema}.crss_ent_info.fictitiouspersonid is '';
comment on column ${idl_schema}.crss_ent_info.groupflag is '';
comment on column ${idl_schema}.crss_ent_info.evaluatelevel is '';
comment on column ${idl_schema}.crss_ent_info.mybank is '';
comment on column ${idl_schema}.crss_ent_info.mybankaccount is '';
comment on column ${idl_schema}.crss_ent_info.otherbank is '';
comment on column ${idl_schema}.crss_ent_info.otherbankaccount is '';
comment on column ${idl_schema}.crss_ent_info.tempsaveflag is '';
comment on column ${idl_schema}.crss_ent_info.financedepttel is '';
comment on column ${idl_schema}.crss_ent_info.ecgroupflag is '';
comment on column ${idl_schema}.crss_ent_info.supercorpname is '';
comment on column ${idl_schema}.crss_ent_info.superloancardno is '';
comment on column ${idl_schema}.crss_ent_info.supercerttype is '';
comment on column ${idl_schema}.crss_ent_info.smeindustrytype is '';
comment on column ${idl_schema}.crss_ent_info.sellsum is '';
comment on column ${idl_schema}.crss_ent_info.supercertid is '';
comment on column ${idl_schema}.crss_ent_info.isblack is '是否黑名单客户';
comment on column ${idl_schema}.crss_ent_info.isdebt is '';
comment on column ${idl_schema}.crss_ent_info.isstrategycustomer is '';
comment on column ${idl_schema}.crss_ent_info.ifoversea is '';
comment on column ${idl_schema}.crss_ent_info.serviceupdateresult is '';
comment on column ${idl_schema}.crss_ent_info.rwacustomertype is '';
comment on column ${idl_schema}.crss_ent_info.businessstrategy is '';
comment on column ${idl_schema}.crss_ent_info.isnewsetup is '';
comment on column ${idl_schema}.crss_ent_info.isrelative is '';
comment on column ${idl_schema}.crss_ent_info.ifsme is '';
comment on column ${idl_schema}.crss_ent_info.locality is '';
comment on column ${idl_schema}.crss_ent_info.subjectbusiness is '';
comment on column ${idl_schema}.crss_ent_info.islimit is '';
comment on column ${idl_schema}.crss_ent_info.privateent is '';
comment on column ${idl_schema}.crss_ent_info.bankingsupervision is '';
comment on column ${idl_schema}.crss_ent_info.holdingtype is '';
comment on column ${idl_schema}.crss_ent_info.fiscalsource is '';
comment on column ${idl_schema}.crss_ent_info.lmcredittype is '客户洗钱风险分类';
comment on column ${idl_schema}.crss_ent_info.onlycapital is '';
comment on column ${idl_schema}.crss_ent_info.stratagemflag is '战略客户标志';
comment on column ${idl_schema}.crss_ent_info.isrelatedparty is '是否关联方';
comment on column ${idl_schema}.crss_ent_info.fictitiouspersoncertificateid is '法定代表人证明书编号';
comment on column ${idl_schema}.crss_ent_info.corpstartdate is '组织机构代码起始日';
comment on column ${idl_schema}.crss_ent_info.corpvaliditydate is '组织机构代码有效期';
comment on column ${idl_schema}.crss_ent_info.corpregisteradd is '组织机构代码注册地址';
comment on column ${idl_schema}.crss_ent_info.registerdate is '注册日期';
comment on column ${idl_schema}.crss_ent_info.financedirectorname is '财务总监姓名';
comment on column ${idl_schema}.crss_ent_info.mobilephone is '财务总监移动电话';
comment on column ${idl_schema}.crss_ent_info.mfcustomerid is 'CIF客户号';
comment on column ${idl_schema}.crss_ent_info.custtp is '客户类型';
comment on column ${idl_schema}.crss_ent_info.custst is '客户状态';
comment on column ${idl_schema}.crss_ent_info.iscred is '是否授信客户';
comment on column ${idl_schema}.crss_ent_info.ispart is '是否我行股东';
comment on column ${idl_schema}.crss_ent_info.orgown is '机构隶属';
comment on column ${idl_schema}.crss_ent_info.budgtp is '预算形式';
comment on column ${idl_schema}.crss_ent_info.ntlycd is '国别';
comment on column ${idl_schema}.crss_ent_info.crylev is '行业类型(国标)';
comment on column ${idl_schema}.crss_ent_info.mainfg is '是否主证件号';
comment on column ${idl_schema}.crss_ent_info.validt is '证件有效期';
comment on column ${idl_schema}.crss_ent_info.liisau is '发证机关';
comment on column ${idl_schema}.crss_ent_info.others is '证件其他信息';
comment on column ${idl_schema}.crss_ent_info.idtfst is '证件状态';
comment on column ${idl_schema}.crss_ent_info.idcdad is '证件户籍地址';
comment on column ${idl_schema}.crss_ent_info.contna is '联系人姓名';
comment on column ${idl_schema}.crss_ent_info.idtftp is '联系人证件类型';
comment on column ${idl_schema}.crss_ent_info.idtfno is '联系人证件号码';
comment on column ${idl_schema}.crss_ent_info.cmainf is '是否主联系方式';
comment on column ${idl_schema}.crss_ent_info.hometl is '家庭电话';
comment on column ${idl_schema}.crss_ent_info.othrtl is '其他电话';
comment on column ${idl_schema}.crss_ent_info.caiwno is '财务负责人证件号码';
comment on column ${idl_schema}.crss_ent_info.caiwtp is '财务证件类型';
comment on column ${idl_schema}.crss_ent_info.offitl is '单位电话';
comment on column ${idl_schema}.crss_ent_info.mobitl is '移动电话';
comment on column ${idl_schema}.crss_ent_info.fictitiousmobile is '法定代表人移动电话';
comment on column ${idl_schema}.crss_ent_info.fictitiousduty is '法定代表人职务';
comment on column ${idl_schema}.crss_ent_info.finalevaluatedate is '评级日期';
comment on column ${idl_schema}.crss_ent_info.iscountrysidenterprise is '是否农村企业';
comment on column ${idl_schema}.crss_ent_info.financialgroupscope is '商圈客户规模';
comment on column ${idl_schema}.crss_ent_info.financialgroupposition is '商圈客户行业地位';
comment on column ${idl_schema}.crss_ent_info.industrialrestructuringtype is '客户产业结构调整类型：1-鼓励，2-限制，3-淘汰';
comment on column ${idl_schema}.crss_ent_info.transformationandupgradeid is '工业转型升级标识：1-是，2-否';
comment on column ${idl_schema}.crss_ent_info.strategicemergingindustrytype is '战略新兴产业类型：1-节能环保，2-新一代信息技术，3-生物医药，4-高端装备制造，5-新能源，6-新材料，7-新能源汽车';
comment on column ${idl_schema}.crss_ent_info.creditinstitutioncode is '机构信用代码';
comment on column ${idl_schema}.crss_ent_info.parentcompanyofficeadd is '集团客户母公司国内办公地址';
comment on column ${idl_schema}.crss_ent_info.officeaddupdatedate is '更新办公地址日期';
comment on column ${idl_schema}.crss_ent_info.listingcorporation is '上市公司类型：1-A股上市、2-B股上市、3-H股上市、4-海外上市';
comment on column ${idl_schema}.crss_ent_info.shareholderstructuredate is '股东结构对应日期';
comment on column ${idl_schema}.crss_ent_info.hasiebusiness is '有无进出口经营项目：1-是，2-否';
comment on column ${idl_schema}.crss_ent_info.orgdetail is '组织机构类别细分';
comment on column ${idl_schema}.crss_ent_info.orgstatus is '机构状态';
comment on column ${idl_schema}.crss_ent_info.organiztype is '组织机构类别';
comment on column ${idl_schema}.crss_ent_info.documenttype is '证件类型';
comment on column ${idl_schema}.crss_ent_info.documentno is '证件号码';
comment on column ${idl_schema}.crss_ent_info.financefiamtel is '财务负责人家庭电话';
comment on column ${idl_schema}.crss_ent_info.financeothertel is '财务负责人其他电话';
comment on column ${idl_schema}.crss_ent_info.bankingtype is '银监小企业规模';
comment on column ${idl_schema}.crss_ent_info.societyinstitutioncode is '社会信用代码';
comment on column ${idl_schema}.crss_ent_info.commercialregno is '商事与非商事登记证号';
comment on column ${idl_schema}.crss_ent_info.clyxcustomerid is '策略营销客户号';
comment on column ${idl_schema}.crss_ent_info.onlylimit is '单一限额';
comment on column ${idl_schema}.crss_ent_info.scopecalculate is '企业规模_系统计算';
comment on column ${idl_schema}.crss_ent_info.raterisklevel is '内评客户评级';
comment on column ${idl_schema}.crss_ent_info.industrytypeproportion is '第一大主营业务占比';
comment on column ${idl_schema}.crss_ent_info.industrytypeproportion1 is '第二大主营业务占比';
comment on column ${idl_schema}.crss_ent_info.industrytypeproportion2 is '第三大主营业务占比';
comment on column ${idl_schema}.crss_ent_info.isfreshcust is '是否绿色信贷客户';
comment on column ${idl_schema}.crss_ent_info.jtbbname is '集团本部名称';
comment on column ${idl_schema}.crss_ent_info.mcompanyname is '母公司名称';
comment on column ${idl_schema}.crss_ent_info.mcompanycerttype is '母公司证件类型';
comment on column ${idl_schema}.crss_ent_info.mcompanycertid is '母公司证件号码';
comment on column ${idl_schema}.crss_ent_info.acceptbankid is '承兑行行号';
comment on column ${idl_schema}.crss_ent_info.acceptbankname is '承兑行行名';
comment on column ${idl_schema}.crss_ent_info.isdlfr is '是否独立法人';
comment on column ${idl_schema}.crss_ent_info.outdate is '准入名单退出时间';
comment on column ${idl_schema}.crss_ent_info.outmsg is '准入名单退出原因';
comment on column ${idl_schema}.crss_ent_info.creditdebtlimit is '信用债限额';
comment on column ${idl_schema}.crss_ent_info.currencyfundlimit is '货币基金限额';
comment on column ${idl_schema}.crss_ent_info.currencyfundused is '额度占用金额';
comment on column ${idl_schema}.crss_ent_info.creditdebtused is '额度占用金额';
comment on column ${idl_schema}.crss_ent_info.iseduhealth is '是否文教健康';
comment on column ${idl_schema}.crss_ent_info.ishewpackard is '是否惠普型';
comment on column ${idl_schema}.crss_ent_info.corporationgrowthstage is '企业成长阶段';
comment on column ${idl_schema}.crss_ent_info.laborintensiveentflag is '劳动密集型企业标志';
comment on column ${idl_schema}.crss_ent_info.start_dt is '开始日期';
comment on column ${idl_schema}.crss_ent_info.end_dt is '结束日期';
comment on column ${idl_schema}.crss_ent_info.id_mark is '删除标识';
comment on column ${idl_schema}.crss_ent_info.etl_timestamp is '数据处理时间';