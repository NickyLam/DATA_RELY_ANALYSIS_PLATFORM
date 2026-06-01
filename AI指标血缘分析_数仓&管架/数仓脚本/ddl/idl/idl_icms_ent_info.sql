/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_ent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icms_ent_info
whenever sqlerror continue none;
drop table ${idl_schema}.icms_ent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icms_ent_info(
    etl_dt date -- ETL处理日期
    ,basicbank varchar2(200) -- 基本帐户行
    ,basicaccount varchar2(50) -- 基本帐户号
    ,mybank varchar2(80) -- 我行开户行
    ,mybankaccount varchar2(32) -- 我行开户帐号
    ,otherbank varchar2(80) -- 他行开户行
    ,otherbankaccount varchar2(32) -- 他行开户帐号
    ,accountdate date -- 在我行首次开立账户时间
    ,creditdate date -- 与我行建立信贷关系时间
    ,evaluatedate date -- 评估日期
    ,remark varchar2(500) -- 备注
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(12) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,swiftcode varchar2(32) -- swift代码
    ,financeorglicence varchar2(32) -- 金融机构许可证
    ,financeorgcode varchar2(32) -- 金融机构代码
    ,countryrisk varchar2(80) -- 国别风险
    ,corpid varchar2(32) -- 法人编号
    ,corporgid varchar2(32) -- 法人机构编号
    ,registerregioncode varchar2(32) -- 登记地行政区划代码
    ,economictype varchar2(80) -- 经济类型
    ,countrycode varchar2(18) -- 所在国家(地区)
    ,fictitiousperson varchar2(200) -- 法定代表人(姓名)
    ,fictitiouspersonid varchar2(80) -- 法定代表人证件号码（事业单位等=身份证号）
    ,listingcorpornot varchar2(2) -- 是否上市公司
    ,hasiebusiness varchar2(2) -- 有无进出口经营项目
    ,registerdate date -- 注册日期
    ,mcompanyname varchar2(80) -- 母公司名称
    ,mcompanycerttype varchar2(10) -- 母公司证件类型
    ,mcompanycertid varchar2(30) -- 母公司证件号码
    ,firstloandate date -- 首贷日期
    ,subjectbusiness varchar2(2500) -- 主营业务
    ,industrytypeforrs varchar2(18) -- 客户所属行业分类（征信）
    ,strategicemergingindustrytype varchar2(4) -- 战略新兴产业类型
    ,corporationgrowthstage varchar2(4) -- 企业成长阶段
    ,organiztype varchar2(10) -- 组织机构类别
    ,orgdetail varchar2(30) -- 组织机构类别细分
    ,ifoversea varchar2(2) -- 是否离岸户
    ,rwacustomertype varchar2(4) -- 加权风险资产客户分类
    ,isnewsetup varchar2(2) -- 是否为新建企业
    ,privateent varchar2(2) -- 是否民营企业
    ,bankingsupervision varchar2(2) -- 是否银监小企业
    ,bankingtype varchar2(30) -- 银监小企业规模
    ,isdebt varchar2(2) -- 是否为逃废债企业
    ,islimit varchar2(2) -- 是否属于两高行业
    ,laborintensiveentflag varchar2(2) -- 是否劳动密集型企业
    ,holdingtype varchar2(18) -- 控股类型
    ,iscountrysidenterprise varchar2(2) -- 是否农村企业
    ,isblack varchar2(2) -- 是否黑名单客户
    ,locality varchar2(2) -- 是否我行认定小企业
    ,isfreshcust varchar2(2) -- 是否绿色信贷客户
    ,lmcredittype varchar2(4) -- 客户洗钱风险分类
    ,businessstrategy varchar2(4) -- 授信策略
    ,industrialrestructuringtype varchar2(4) -- 客户产业结构调整类型
    ,transformationandupgradeid varchar2(2) -- 工业转型升级标识
    ,orgstatus varchar2(2) -- 部门状态
    ,onlylimit number(24,6) -- 单一限额
    ,shareholderstructuredate date -- 股东结构对应日期
    ,clyxcustomerid varchar2(40) -- 策略营销客户号
    ,chargedepartment varchar2(80) -- 上级主管单位
    ,isrelativetrade varchar2(2) -- 是否我行关联交易
    ,corpidetitytype varchar2(18) -- 征信报送企业身份标识类型
    ,fundsource varchar2(200) -- 经费来源
    ,fiscalsource varchar2(4) -- 财政补助收入来源
    ,serviceupdateresult varchar2(4) -- 客户服务升级分类
    ,governmentlevel varchar2(4) -- 政府等级
    ,isrelatedparty varchar2(2) -- 是否我行关联方
    ,managearea varchar2(200) -- 政府机构行政区划
    ,financecorpid varchar2(32) -- 非现场监管统计机构编码
    ,otherorgname varchar2(80) -- 发证机关
    ,corpstartdate date -- 发证日期
    ,isdlfr varchar2(2) -- 是否独立法人
    ,ispart varchar2(2) -- 是否我行股东
    ,isoverseas varchar2(2) -- 是否海外子行客户
    ,authflag varchar2(2) -- 是否授权
    ,isinvestcust varchar2(2) -- 是否投资类客户
    ,distributestatus varchar2(2) -- 分配状态
    ,customertype varchar2(18) -- 客户类型
    ,ifsme varchar2(2) -- 是否中小企业事业部专营客户
    ,fictitiouspersoncertificateid varchar2(50) -- 法定代表人证明书标号
    ,fictitiousmobile varchar2(50) -- 法定代表人移动电话
    ,registeradd varchar2(400) -- 注册地址
    ,newregioncode varchar2(18) -- 行政区域（风险预警）
    ,financedirectorname varchar2(80) -- 财务总监姓名
    ,mobilephone varchar2(32) -- 财务总监移动电话\移动电话
    ,loancardpassword varchar2(32) -- 贷款卡密码
    ,projectflag varchar2(18) -- 机构目前是否有项目
    ,realtyflag varchar2(18) -- 是否从事房地产开发
    ,isstrategycustomer varchar2(10) -- 是否战略客户
    ,financefiamtel varchar2(30) -- 财务负责人家庭电话
    ,financeothertel varchar2(30) -- 财务负责人其他电话
    ,actualcontrollercounts number(15) -- 实际控制人个数
    ,investmencounts number(15) -- 主要出资人个数
    ,financetype2 varchar2(18) -- 金融机构类型
    ,greencategory varchar2(20) -- 绿色信贷细分类目
    ,governmentltype varchar2(4) -- 政府客户类型
    ,upbelongcustid varchar2(64) -- 上级法人机构编号
    ,stateownedentholdingflag varchar2(2) -- 是否国企控股
    ,acceptbankid varchar2(40) -- 承兑行行号
    ,acceptbankname varchar2(80) -- 承兑行行名
    ,creditinstitutioncode varchar2(2) -- 机构信用代码
    ,societyinstitutioncode varchar2(2) -- 社会信用代码
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,englishname varchar2(80) -- 客户英文名
    ,licenseno varchar2(100) -- 营业执照登记号
    ,licensebegin date -- 营业执照登记日
    ,licensematurity date -- 营业执照到期日
    ,nationaltaxno varchar2(32) -- 税务登记证号(国税)
    ,landtaxno varchar2(32) -- 税务登记证号(地税)
    ,setupdate date -- 企业成立日期
    ,loancardno varchar2(30) -- 中证码
    ,loancardflag varchar2(1) -- 中证码是否有效
    ,supercorpname varchar2(80) -- 上级公司名称
    ,supercertid varchar2(32) -- 上级公司组织机构代码
    ,supercerttype varchar2(18) -- 上级公司证件类型
    ,superloancardno varchar2(32) -- 上级公司贷款卡编号
    ,enttype varchar2(18) -- 客户类型
    ,entscale varchar2(18) -- 企业规模
    ,calcuentscale varchar2(18) -- 企业测算规模
    ,orgtype varchar2(18) -- 组织类型
    ,orgform varchar2(18) -- 组织形式
    ,orgbelong varchar2(80) -- 机构隶属
    ,industrytype varchar2(5) -- 国标行业分类
    ,ecgroupflag varchar2(1) -- 是否征信标准集团客户
    ,registercurrency varchar2(3) -- 注册资本币种
    ,registeramount number(24,6) -- 注册资本
    ,financedepttel varchar2(32) -- 财务部联系电话
    ,emailadd varchar2(400) -- 公司e－mail
    ,finarunarea varchar2(18) -- 金融机构经营区域范围
    ,finabranchnum number(22) -- 金融机构一级分支机构数量
    ,listingcorptype varchar2(80) -- 上市公司类型
    ,employeenumber number(22) -- 职工人数
    ,salesamount number(24,6) -- 销售收入
    ,generalassets number(24,6) -- 资产总额
    ,entindustrytype varchar2(18) -- 企业行业类型
    ,financetype varchar2(7) -- 同业客户类型
    ,businessscope varchar2(4000) -- 经营范围
    ,customerhistory varchar2(1500) -- 历史沿革、管理水平简介
    ,importrightsflag varchar2(6) -- 有无进出口经营权
    ,creditlevel varchar2(32) -- 本行即期信用等级
    ,workfieldarea number(24,6) -- 经营场地面积
    ,workfieldfee varchar2(32) -- 经营场地所有权
    ,manageinfo varchar2(2500) -- 合法经营情况
    ,mainproduction varchar2(1000) -- 主要产品情况
    ,paidcurrency varchar2(3) -- 实收币种
    ,paidamount number(24,6) -- 实收金额
    ,groupflag varchar2(1) -- 是否集团标志
    ,start_dt date -- 开始日期
    ,end_dt date -- 结束日期
    ,id_mark varchar2(10) -- 删除标识
    ,ratifydate date -- 核准日期
    ,commercialregisterno varchar2(32) -- 工商注册号
    ,taxpayerregisterno varchar2(32) -- 纳税人识别号
    ,survivalstatus varchar2(4) -- 存续状态
    ,environmentrisktype varchar2(4) -- 重大环境安全风险分类
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,corpregisteradd varchar2(300) -- 组织机构代码注册地址
    ,corpvaliditydate varchar2(10) -- 组织机构代码有效期
    ,platformaffiliatetype varchar2(18) -- 地方融资平台按隶属关系分类类型
    ,platformlawtype varchar2(18) -- 地方融资平台按法律性质分类类型
    ,techcorpidentifytime varchar2(10) -- 科技型企业认定时间
    ,techcorptype varchar2(1) -- 地方融资平台按隶属关系分类类型
    ,isgovernmentplarform varchar2(10) -- 是否政府融资平台
    ,migtoldvalue varchar2(250) -- 迁移数据-参数转换前字段值
    ,firstloanflag varchar2(1) -- 首贷标志
    ,actualcontroller varchar2(200) -- 实际控制人
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_ent_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_ent_info is '公司客户基本信息';
comment on column ${idl_schema}.icms_ent_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.icms_ent_info.basicbank is '基本帐户行';
comment on column ${idl_schema}.icms_ent_info.basicaccount is '基本帐户号';
comment on column ${idl_schema}.icms_ent_info.mybank is '我行开户行';
comment on column ${idl_schema}.icms_ent_info.mybankaccount is '我行开户帐号';
comment on column ${idl_schema}.icms_ent_info.otherbank is '他行开户行';
comment on column ${idl_schema}.icms_ent_info.otherbankaccount is '他行开户帐号';
comment on column ${idl_schema}.icms_ent_info.accountdate is '在我行首次开立账户时间';
comment on column ${idl_schema}.icms_ent_info.creditdate is '与我行建立信贷关系时间';
comment on column ${idl_schema}.icms_ent_info.evaluatedate is '评估日期';
comment on column ${idl_schema}.icms_ent_info.remark is '备注';
comment on column ${idl_schema}.icms_ent_info.inputuserid is '登记人';
comment on column ${idl_schema}.icms_ent_info.inputorgid is '登记机构';
comment on column ${idl_schema}.icms_ent_info.inputdate is '登记日期';
comment on column ${idl_schema}.icms_ent_info.updateuserid is '更新人';
comment on column ${idl_schema}.icms_ent_info.updateorgid is '更新机构';
comment on column ${idl_schema}.icms_ent_info.updatedate is '更新日期';
comment on column ${idl_schema}.icms_ent_info.swiftcode is 'swift代码';
comment on column ${idl_schema}.icms_ent_info.financeorglicence is '金融机构许可证';
comment on column ${idl_schema}.icms_ent_info.financeorgcode is '金融机构代码';
comment on column ${idl_schema}.icms_ent_info.countryrisk is '国别风险';
comment on column ${idl_schema}.icms_ent_info.corpid is '法人编号';
comment on column ${idl_schema}.icms_ent_info.corporgid is '法人机构编号';
comment on column ${idl_schema}.icms_ent_info.registerregioncode is '登记地行政区划代码';
comment on column ${idl_schema}.icms_ent_info.economictype is '经济类型';
comment on column ${idl_schema}.icms_ent_info.countrycode is '所在国家(地区)';
comment on column ${idl_schema}.icms_ent_info.fictitiousperson is '法定代表人(姓名)';
comment on column ${idl_schema}.icms_ent_info.fictitiouspersonid is '法定代表人证件号码（事业单位等=身份证号）';
comment on column ${idl_schema}.icms_ent_info.listingcorpornot is '是否上市公司';
comment on column ${idl_schema}.icms_ent_info.hasiebusiness is '有无进出口经营项目';
comment on column ${idl_schema}.icms_ent_info.registerdate is '注册日期';
comment on column ${idl_schema}.icms_ent_info.mcompanyname is '母公司名称';
comment on column ${idl_schema}.icms_ent_info.mcompanycerttype is '母公司证件类型';
comment on column ${idl_schema}.icms_ent_info.mcompanycertid is '母公司证件号码';
comment on column ${idl_schema}.icms_ent_info.firstloandate is '首贷日期';
comment on column ${idl_schema}.icms_ent_info.subjectbusiness is '主营业务';
comment on column ${idl_schema}.icms_ent_info.industrytypeforrs is '客户所属行业分类（征信）';
comment on column ${idl_schema}.icms_ent_info.strategicemergingindustrytype is '战略新兴产业类型';
comment on column ${idl_schema}.icms_ent_info.corporationgrowthstage is '企业成长阶段';
comment on column ${idl_schema}.icms_ent_info.organiztype is '组织机构类别';
comment on column ${idl_schema}.icms_ent_info.orgdetail is '组织机构类别细分';
comment on column ${idl_schema}.icms_ent_info.ifoversea is '是否离岸户';
comment on column ${idl_schema}.icms_ent_info.rwacustomertype is '加权风险资产客户分类';
comment on column ${idl_schema}.icms_ent_info.isnewsetup is '是否为新建企业';
comment on column ${idl_schema}.icms_ent_info.privateent is '是否民营企业';
comment on column ${idl_schema}.icms_ent_info.bankingsupervision is '是否银监小企业';
comment on column ${idl_schema}.icms_ent_info.bankingtype is '银监小企业规模';
comment on column ${idl_schema}.icms_ent_info.isdebt is '是否为逃废债企业';
comment on column ${idl_schema}.icms_ent_info.islimit is '是否属于两高行业';
comment on column ${idl_schema}.icms_ent_info.laborintensiveentflag is '是否劳动密集型企业';
comment on column ${idl_schema}.icms_ent_info.holdingtype is '控股类型';
comment on column ${idl_schema}.icms_ent_info.iscountrysidenterprise is '是否农村企业';
comment on column ${idl_schema}.icms_ent_info.isblack is '是否黑名单客户';
comment on column ${idl_schema}.icms_ent_info.locality is '是否我行认定小企业';
comment on column ${idl_schema}.icms_ent_info.isfreshcust is '是否绿色信贷客户';
comment on column ${idl_schema}.icms_ent_info.lmcredittype is '客户洗钱风险分类';
comment on column ${idl_schema}.icms_ent_info.businessstrategy is '授信策略';
comment on column ${idl_schema}.icms_ent_info.industrialrestructuringtype is '客户产业结构调整类型';
comment on column ${idl_schema}.icms_ent_info.transformationandupgradeid is '工业转型升级标识';
comment on column ${idl_schema}.icms_ent_info.orgstatus is '部门状态';
comment on column ${idl_schema}.icms_ent_info.onlylimit is '单一限额';
comment on column ${idl_schema}.icms_ent_info.shareholderstructuredate is '股东结构对应日期';
comment on column ${idl_schema}.icms_ent_info.clyxcustomerid is '策略营销客户号';
comment on column ${idl_schema}.icms_ent_info.chargedepartment is '上级主管单位';
comment on column ${idl_schema}.icms_ent_info.isrelativetrade is '是否我行关联交易';
comment on column ${idl_schema}.icms_ent_info.corpidetitytype is '征信报送企业身份标识类型';
comment on column ${idl_schema}.icms_ent_info.fundsource is '经费来源';
comment on column ${idl_schema}.icms_ent_info.fiscalsource is '财政补助收入来源';
comment on column ${idl_schema}.icms_ent_info.serviceupdateresult is '客户服务升级分类';
comment on column ${idl_schema}.icms_ent_info.governmentlevel is '政府等级';
comment on column ${idl_schema}.icms_ent_info.isrelatedparty is '是否我行关联方';
comment on column ${idl_schema}.icms_ent_info.managearea is '政府机构行政区划';
comment on column ${idl_schema}.icms_ent_info.financecorpid is '非现场监管统计机构编码';
comment on column ${idl_schema}.icms_ent_info.otherorgname is '发证机关';
comment on column ${idl_schema}.icms_ent_info.corpstartdate is '发证日期';
comment on column ${idl_schema}.icms_ent_info.isdlfr is '是否独立法人';
comment on column ${idl_schema}.icms_ent_info.ispart is '是否我行股东';
comment on column ${idl_schema}.icms_ent_info.isoverseas is '是否海外子行客户';
comment on column ${idl_schema}.icms_ent_info.authflag is '是否授权';
comment on column ${idl_schema}.icms_ent_info.isinvestcust is '是否投资类客户';
comment on column ${idl_schema}.icms_ent_info.distributestatus is '分配状态';
comment on column ${idl_schema}.icms_ent_info.customertype is '客户类型';
comment on column ${idl_schema}.icms_ent_info.ifsme is '是否中小企业事业部专营客户';
comment on column ${idl_schema}.icms_ent_info.fictitiouspersoncertificateid is '法定代表人证明书标号';
comment on column ${idl_schema}.icms_ent_info.fictitiousmobile is '法定代表人移动电话';
comment on column ${idl_schema}.icms_ent_info.registeradd is '注册地址';
comment on column ${idl_schema}.icms_ent_info.newregioncode is '行政区域（风险预警）';
comment on column ${idl_schema}.icms_ent_info.financedirectorname is '财务总监姓名';
comment on column ${idl_schema}.icms_ent_info.mobilephone is '财务总监移动电话\移动电话';
comment on column ${idl_schema}.icms_ent_info.loancardpassword is '贷款卡密码';
comment on column ${idl_schema}.icms_ent_info.projectflag is '机构目前是否有项目';
comment on column ${idl_schema}.icms_ent_info.realtyflag is '是否从事房地产开发';
comment on column ${idl_schema}.icms_ent_info.isstrategycustomer is '是否战略客户';
comment on column ${idl_schema}.icms_ent_info.financefiamtel is '财务负责人家庭电话';
comment on column ${idl_schema}.icms_ent_info.financeothertel is '财务负责人其他电话';
comment on column ${idl_schema}.icms_ent_info.actualcontrollercounts is '实际控制人个数';
comment on column ${idl_schema}.icms_ent_info.investmencounts is '主要出资人个数';
comment on column ${idl_schema}.icms_ent_info.financetype2 is '金融机构类型';
comment on column ${idl_schema}.icms_ent_info.greencategory is '绿色信贷细分类目';
comment on column ${idl_schema}.icms_ent_info.governmentltype is '政府客户类型';
comment on column ${idl_schema}.icms_ent_info.upbelongcustid is '上级法人机构编号';
comment on column ${idl_schema}.icms_ent_info.stateownedentholdingflag is '是否国企控股';
comment on column ${idl_schema}.icms_ent_info.acceptbankid is '承兑行行号';
comment on column ${idl_schema}.icms_ent_info.acceptbankname is '承兑行行名';
comment on column ${idl_schema}.icms_ent_info.creditinstitutioncode is '机构信用代码';
comment on column ${idl_schema}.icms_ent_info.societyinstitutioncode is '社会信用代码';
comment on column ${idl_schema}.icms_ent_info.customerid is '客户编号';
comment on column ${idl_schema}.icms_ent_info.customername is '客户名称';
comment on column ${idl_schema}.icms_ent_info.englishname is '客户英文名';
comment on column ${idl_schema}.icms_ent_info.licenseno is '营业执照登记号';
comment on column ${idl_schema}.icms_ent_info.licensebegin is '营业执照登记日';
comment on column ${idl_schema}.icms_ent_info.licensematurity is '营业执照到期日';
comment on column ${idl_schema}.icms_ent_info.nationaltaxno is '税务登记证号(国税)';
comment on column ${idl_schema}.icms_ent_info.landtaxno is '税务登记证号(地税)';
comment on column ${idl_schema}.icms_ent_info.setupdate is '企业成立日期';
comment on column ${idl_schema}.icms_ent_info.loancardno is '中证码';
comment on column ${idl_schema}.icms_ent_info.loancardflag is '中证码是否有效';
comment on column ${idl_schema}.icms_ent_info.supercorpname is '上级公司名称';
comment on column ${idl_schema}.icms_ent_info.supercertid is '上级公司组织机构代码';
comment on column ${idl_schema}.icms_ent_info.supercerttype is '上级公司证件类型';
comment on column ${idl_schema}.icms_ent_info.superloancardno is '上级公司贷款卡编号';
comment on column ${idl_schema}.icms_ent_info.enttype is '客户类型';
comment on column ${idl_schema}.icms_ent_info.entscale is '企业规模';
comment on column ${idl_schema}.icms_ent_info.calcuentscale is '企业测算规模';
comment on column ${idl_schema}.icms_ent_info.orgtype is '组织类型';
comment on column ${idl_schema}.icms_ent_info.orgform is '组织形式';
comment on column ${idl_schema}.icms_ent_info.orgbelong is '机构隶属';
comment on column ${idl_schema}.icms_ent_info.industrytype is '国标行业分类';
comment on column ${idl_schema}.icms_ent_info.ecgroupflag is '是否征信标准集团客户';
comment on column ${idl_schema}.icms_ent_info.registercurrency is '注册资本币种';
comment on column ${idl_schema}.icms_ent_info.registeramount is '注册资本';
comment on column ${idl_schema}.icms_ent_info.financedepttel is '财务部联系电话';
comment on column ${idl_schema}.icms_ent_info.emailadd is '公司e－mail';
comment on column ${idl_schema}.icms_ent_info.finarunarea is '金融机构经营区域范围';
comment on column ${idl_schema}.icms_ent_info.finabranchnum is '金融机构一级分支机构数量';
comment on column ${idl_schema}.icms_ent_info.listingcorptype is '上市公司类型';
comment on column ${idl_schema}.icms_ent_info.employeenumber is '职工人数';
comment on column ${idl_schema}.icms_ent_info.salesamount is '销售收入';
comment on column ${idl_schema}.icms_ent_info.generalassets is '资产总额';
comment on column ${idl_schema}.icms_ent_info.entindustrytype is '企业行业类型';
comment on column ${idl_schema}.icms_ent_info.financetype is '同业客户类型';
comment on column ${idl_schema}.icms_ent_info.businessscope is '经营范围';
comment on column ${idl_schema}.icms_ent_info.customerhistory is '历史沿革、管理水平简介';
comment on column ${idl_schema}.icms_ent_info.importrightsflag is '有无进出口经营权';
comment on column ${idl_schema}.icms_ent_info.creditlevel is '本行即期信用等级';
comment on column ${idl_schema}.icms_ent_info.workfieldarea is '经营场地面积';
comment on column ${idl_schema}.icms_ent_info.workfieldfee is '经营场地所有权';
comment on column ${idl_schema}.icms_ent_info.manageinfo is '合法经营情况';
comment on column ${idl_schema}.icms_ent_info.mainproduction is '主要产品情况';
comment on column ${idl_schema}.icms_ent_info.paidcurrency is '实收币种';
comment on column ${idl_schema}.icms_ent_info.paidamount is '实收金额';
comment on column ${idl_schema}.icms_ent_info.groupflag is '是否集团标志';
comment on column ${idl_schema}.icms_ent_info.start_dt is '开始日期';
comment on column ${idl_schema}.icms_ent_info.end_dt is '结束日期';
comment on column ${idl_schema}.icms_ent_info.id_mark is '删除标识';
comment on column ${idl_schema}.icms_ent_info.ratifydate is '核准日期';
comment on column ${idl_schema}.icms_ent_info.commercialregisterno is '工商注册号';
comment on column ${idl_schema}.icms_ent_info.taxpayerregisterno is '纳税人识别号';
comment on column ${idl_schema}.icms_ent_info.survivalstatus is '存续状态';
comment on column ${idl_schema}.icms_ent_info.environmentrisktype is '重大环境安全风险分类';
comment on column ${idl_schema}.icms_ent_info.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_ent_info.corpregisteradd is '组织机构代码注册地址';
comment on column ${idl_schema}.icms_ent_info.corpvaliditydate is '组织机构代码有效期';
comment on column ${idl_schema}.icms_ent_info.platformaffiliatetype is '地方融资平台按隶属关系分类类型';
comment on column ${idl_schema}.icms_ent_info.platformlawtype is '地方融资平台按法律性质分类类型';
comment on column ${idl_schema}.icms_ent_info.techcorpidentifytime is '科技型企业认定时间';
comment on column ${idl_schema}.icms_ent_info.techcorptype is '地方融资平台按隶属关系分类类型';
comment on column ${idl_schema}.icms_ent_info.isgovernmentplarform is '是否政府融资平台';
comment on column ${idl_schema}.icms_ent_info.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${idl_schema}.icms_ent_info.firstloanflag is '首贷标志';
comment on column ${idl_schema}.icms_ent_info.actualcontroller is '实际控制人';
comment on column ${idl_schema}.icms_ent_info.job_cd is '任务代码';
comment on column ${idl_schema}.icms_ent_info.etl_timestamp is 'ETL处理时间戳';