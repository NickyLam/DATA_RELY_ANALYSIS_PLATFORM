/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_partner
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
create table ${iol_schema}.icms_customer_partner_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_partner
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_partner_op purge;
drop table ${iol_schema}.icms_customer_partner_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_partner_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_partner where 0=1;

create table ${iol_schema}.icms_customer_partner_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_partner where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_partner_cl(
            partnerid -- 合作方编号
            ,industrytype -- 行业类型
            ,partnername -- 合作方名称
            ,partnerenttype -- 合作企业类型
            ,fictitiouscerttype -- 法人代表证件类型
            ,address -- 地址
            ,partnertypesub -- 合作商类型
            ,status -- 合作方状态
            ,customertype -- 客户类型机构类型（代码：1-法人企业2-非法人企业3-事业单位4-社会团体5-党政机关6-其他）
            ,taxpayeridentino -- 纳税人识别号
            ,basaccbank -- 基本存款账户开户行
            ,finaprincipal -- 财务部负责人
            ,comtype -- 机构类别
            ,projectnumber -- 合作项目数量
            ,certid -- 证件号码
            ,fictitiousperson -- 法人代表姓名
            ,finacomtel -- 财务部联系人单位电话
            ,applytotalamt -- 总额度
            ,coopenddate -- 合作结束日期
            ,authenticatelicense -- 司法鉴定许可证号
            ,authevaluatornum -- 具备司法鉴定资格人数
            ,basicaccount -- 基本账户账号
            ,midsigncode -- 中征码
            ,bailratio -- 保证金比例
            ,payday -- 代偿天数
            ,industryname -- 行业名称
            ,orgcode -- 组织机构代码
            ,basaccdate -- 基本账户开户日期
            ,cooptype -- 合作方式
            ,landevaluatornum -- 土地估价师人数
            ,familyzip -- 家庭地址邮编
            ,weburl -- 网址
            ,finacontactpeople -- 财务部联系人
            ,claimoverdueday -- 理赔逾期天数
            ,updatedate -- 更新日期
            ,paiclupcapital -- 实收资本
            ,applynum -- 拟申请人数
            ,customerscale -- 企业规模客户类型（代码：1-大型企业2-中型企业）
            ,repaypersontype -- 还款责任人类型
            ,familytel -- 家庭联系电话
            ,remark -- 备注
            ,basicbank -- 基本账户开户行
            ,comholdstkamt -- 拥有我行股份金额
            ,cusbankrel -- 客户与我行关联关系
            ,faxcode -- 传真
            ,businesslicenceenddate -- 营业执照到期日期
            ,coopbusiness -- 拟合作业务
            ,businessmanager -- 业务联系人
            ,realtyevaluateauthlevel -- 相关资质
            ,officezip -- 邮编
            ,investtype -- 投资主体
            ,orgcodeenddate -- 组织机构登记到期日期
            ,inputorgid -- 登记机构
            ,officeadd -- 公司地址
            ,repaypersonidentity -- 还款责任人身份类型
            ,businesslicencestartdate -- 营业执照登记日期
            ,qualificationlicense -- 房地产评估机构资质证书
            ,landevalregisterlicense -- 土地评估中介机构注册证书
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,isdiffcust -- 是否异地客户
            ,worknum -- 从业人数
            ,creditlevelenddate -- 信用等级到期日期
            ,corporgid -- 法人机构编号
            ,applyavgamt -- 拟申请平均额度
            ,creditleveldate -- 信用评定日期
            ,basacclicence -- 基本存款账户开户许可证编号
            ,unittype -- 单位性质
            ,coopstartdate -- 合作起始日期
            ,updateuserid -- 更新人
            ,coopterm -- 合作期限（月）
            ,orgcodestartdate -- 组织机构登记日期
            ,registercurrency -- 注册币种
            ,finamobiletel -- 财务部联系人手机号码（短信通知）
            ,businesslicence -- 营业执照
            ,officetel -- 公司联系电话
            ,inputdate -- 登记日期
            ,coreentcustid -- 核心企业客户号
            ,qualifictionmaturity -- 房地产资质证书有效期限
            ,certcountry -- 证件国别
            ,certtype -- 证件类型
            ,realtyevaluateauthyear -- 相关资质有效期
            ,isbancredit -- 是否授信暂禁
            ,inputuserid -- 登记人
            ,projecttype -- 合作项目类型
            ,userange -- 共享范围
            ,managebrand -- 经营品牌
            ,fictitiouscert -- 法人代表证件编号
            ,landevalregistermaturity -- 土地评估中介机构注册证书有效期
            ,houseevaluatornum -- 注册房地产评估师人数
            ,updateorgid -- 更新机构
            ,iscreditlimit -- 是否授信暂禁
            ,cooporg -- 合作机构
            ,accountorg -- 账户机构
            ,completeflag -- 完整性标识
            ,mostbusiness -- 经营范围
            ,firstcooperationdate -- 首次合作时间
            ,comholdtype -- 控股类型
            ,assetsum -- 资产总额
            ,evaluatedate -- 企业评级日期
            ,compstartdate -- 企业成立日期
            ,iscreditcust -- 是否我行授信客户
            ,basaccflg -- 基本存款账户是否在我行
            ,approvestatus -- 流程审批状态
            ,registerdate -- 注册时间
            ,familyadd -- 家庭地址
            ,repaypersoncerttype -- 相关还款责任人证件类型
            ,email -- EMAIL
            ,businessincome -- 营业收入（万元）
            ,creditlevel -- 信用等级(内部)
            ,basaccno -- 基本存款账户账号
            ,userangeorg -- 适用机构范围编号
            ,maxcreditlimit -- 最高合作额度
            ,registeradd -- 注册地址
            ,registercapital -- 注册资金
            ,authenticatelicensedate -- 司法鉴定许可证发证日期
            ,partnertype -- 合作方类型
            ,evaluateresult -- 企业评级结果
            ,repaypersoncertid -- 还款责任人证件号码
            ,repaypersonname -- 还款责任人名称
            ,fusingoverdue -- 熔断逾期率
            ,msgphone -- 短信接收人手机号
            ,warnoverdue -- 预警逾期率
            ,consumptionloanlimit -- 消费类贷款额度
            ,guaranteelimit100p -- 100%担保额度
            ,loanguaranteelimit5y -- 5年期贷款担保额度
            ,totalguaranteelimit -- 担保总额度
            ,guaranteeproportion -- 
            ,maxguaranteeamount -- 
            ,isguarantee -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_partner_op(
            partnerid -- 合作方编号
            ,industrytype -- 行业类型
            ,partnername -- 合作方名称
            ,partnerenttype -- 合作企业类型
            ,fictitiouscerttype -- 法人代表证件类型
            ,address -- 地址
            ,partnertypesub -- 合作商类型
            ,status -- 合作方状态
            ,customertype -- 客户类型机构类型（代码：1-法人企业2-非法人企业3-事业单位4-社会团体5-党政机关6-其他）
            ,taxpayeridentino -- 纳税人识别号
            ,basaccbank -- 基本存款账户开户行
            ,finaprincipal -- 财务部负责人
            ,comtype -- 机构类别
            ,projectnumber -- 合作项目数量
            ,certid -- 证件号码
            ,fictitiousperson -- 法人代表姓名
            ,finacomtel -- 财务部联系人单位电话
            ,applytotalamt -- 总额度
            ,coopenddate -- 合作结束日期
            ,authenticatelicense -- 司法鉴定许可证号
            ,authevaluatornum -- 具备司法鉴定资格人数
            ,basicaccount -- 基本账户账号
            ,midsigncode -- 中征码
            ,bailratio -- 保证金比例
            ,payday -- 代偿天数
            ,industryname -- 行业名称
            ,orgcode -- 组织机构代码
            ,basaccdate -- 基本账户开户日期
            ,cooptype -- 合作方式
            ,landevaluatornum -- 土地估价师人数
            ,familyzip -- 家庭地址邮编
            ,weburl -- 网址
            ,finacontactpeople -- 财务部联系人
            ,claimoverdueday -- 理赔逾期天数
            ,updatedate -- 更新日期
            ,paiclupcapital -- 实收资本
            ,applynum -- 拟申请人数
            ,customerscale -- 企业规模客户类型（代码：1-大型企业2-中型企业）
            ,repaypersontype -- 还款责任人类型
            ,familytel -- 家庭联系电话
            ,remark -- 备注
            ,basicbank -- 基本账户开户行
            ,comholdstkamt -- 拥有我行股份金额
            ,cusbankrel -- 客户与我行关联关系
            ,faxcode -- 传真
            ,businesslicenceenddate -- 营业执照到期日期
            ,coopbusiness -- 拟合作业务
            ,businessmanager -- 业务联系人
            ,realtyevaluateauthlevel -- 相关资质
            ,officezip -- 邮编
            ,investtype -- 投资主体
            ,orgcodeenddate -- 组织机构登记到期日期
            ,inputorgid -- 登记机构
            ,officeadd -- 公司地址
            ,repaypersonidentity -- 还款责任人身份类型
            ,businesslicencestartdate -- 营业执照登记日期
            ,qualificationlicense -- 房地产评估机构资质证书
            ,landevalregisterlicense -- 土地评估中介机构注册证书
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,isdiffcust -- 是否异地客户
            ,worknum -- 从业人数
            ,creditlevelenddate -- 信用等级到期日期
            ,corporgid -- 法人机构编号
            ,applyavgamt -- 拟申请平均额度
            ,creditleveldate -- 信用评定日期
            ,basacclicence -- 基本存款账户开户许可证编号
            ,unittype -- 单位性质
            ,coopstartdate -- 合作起始日期
            ,updateuserid -- 更新人
            ,coopterm -- 合作期限（月）
            ,orgcodestartdate -- 组织机构登记日期
            ,registercurrency -- 注册币种
            ,finamobiletel -- 财务部联系人手机号码（短信通知）
            ,businesslicence -- 营业执照
            ,officetel -- 公司联系电话
            ,inputdate -- 登记日期
            ,coreentcustid -- 核心企业客户号
            ,qualifictionmaturity -- 房地产资质证书有效期限
            ,certcountry -- 证件国别
            ,certtype -- 证件类型
            ,realtyevaluateauthyear -- 相关资质有效期
            ,isbancredit -- 是否授信暂禁
            ,inputuserid -- 登记人
            ,projecttype -- 合作项目类型
            ,userange -- 共享范围
            ,managebrand -- 经营品牌
            ,fictitiouscert -- 法人代表证件编号
            ,landevalregistermaturity -- 土地评估中介机构注册证书有效期
            ,houseevaluatornum -- 注册房地产评估师人数
            ,updateorgid -- 更新机构
            ,iscreditlimit -- 是否授信暂禁
            ,cooporg -- 合作机构
            ,accountorg -- 账户机构
            ,completeflag -- 完整性标识
            ,mostbusiness -- 经营范围
            ,firstcooperationdate -- 首次合作时间
            ,comholdtype -- 控股类型
            ,assetsum -- 资产总额
            ,evaluatedate -- 企业评级日期
            ,compstartdate -- 企业成立日期
            ,iscreditcust -- 是否我行授信客户
            ,basaccflg -- 基本存款账户是否在我行
            ,approvestatus -- 流程审批状态
            ,registerdate -- 注册时间
            ,familyadd -- 家庭地址
            ,repaypersoncerttype -- 相关还款责任人证件类型
            ,email -- EMAIL
            ,businessincome -- 营业收入（万元）
            ,creditlevel -- 信用等级(内部)
            ,basaccno -- 基本存款账户账号
            ,userangeorg -- 适用机构范围编号
            ,maxcreditlimit -- 最高合作额度
            ,registeradd -- 注册地址
            ,registercapital -- 注册资金
            ,authenticatelicensedate -- 司法鉴定许可证发证日期
            ,partnertype -- 合作方类型
            ,evaluateresult -- 企业评级结果
            ,repaypersoncertid -- 还款责任人证件号码
            ,repaypersonname -- 还款责任人名称
            ,fusingoverdue -- 熔断逾期率
            ,msgphone -- 短信接收人手机号
            ,warnoverdue -- 预警逾期率
            ,consumptionloanlimit -- 消费类贷款额度
            ,guaranteelimit100p -- 100%担保额度
            ,loanguaranteelimit5y -- 5年期贷款担保额度
            ,totalguaranteelimit -- 担保总额度
            ,guaranteeproportion -- 
            ,maxguaranteeamount -- 
            ,isguarantee -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.partnerid, o.partnerid) as partnerid -- 合作方编号
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 行业类型
    ,nvl(n.partnername, o.partnername) as partnername -- 合作方名称
    ,nvl(n.partnerenttype, o.partnerenttype) as partnerenttype -- 合作企业类型
    ,nvl(n.fictitiouscerttype, o.fictitiouscerttype) as fictitiouscerttype -- 法人代表证件类型
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.partnertypesub, o.partnertypesub) as partnertypesub -- 合作商类型
    ,nvl(n.status, o.status) as status -- 合作方状态
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型机构类型（代码：1-法人企业2-非法人企业3-事业单位4-社会团体5-党政机关6-其他）
    ,nvl(n.taxpayeridentino, o.taxpayeridentino) as taxpayeridentino -- 纳税人识别号
    ,nvl(n.basaccbank, o.basaccbank) as basaccbank -- 基本存款账户开户行
    ,nvl(n.finaprincipal, o.finaprincipal) as finaprincipal -- 财务部负责人
    ,nvl(n.comtype, o.comtype) as comtype -- 机构类别
    ,nvl(n.projectnumber, o.projectnumber) as projectnumber -- 合作项目数量
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.fictitiousperson, o.fictitiousperson) as fictitiousperson -- 法人代表姓名
    ,nvl(n.finacomtel, o.finacomtel) as finacomtel -- 财务部联系人单位电话
    ,nvl(n.applytotalamt, o.applytotalamt) as applytotalamt -- 总额度
    ,nvl(n.coopenddate, o.coopenddate) as coopenddate -- 合作结束日期
    ,nvl(n.authenticatelicense, o.authenticatelicense) as authenticatelicense -- 司法鉴定许可证号
    ,nvl(n.authevaluatornum, o.authevaluatornum) as authevaluatornum -- 具备司法鉴定资格人数
    ,nvl(n.basicaccount, o.basicaccount) as basicaccount -- 基本账户账号
    ,nvl(n.midsigncode, o.midsigncode) as midsigncode -- 中征码
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例
    ,nvl(n.payday, o.payday) as payday -- 代偿天数
    ,nvl(n.industryname, o.industryname) as industryname -- 行业名称
    ,nvl(n.orgcode, o.orgcode) as orgcode -- 组织机构代码
    ,nvl(n.basaccdate, o.basaccdate) as basaccdate -- 基本账户开户日期
    ,nvl(n.cooptype, o.cooptype) as cooptype -- 合作方式
    ,nvl(n.landevaluatornum, o.landevaluatornum) as landevaluatornum -- 土地估价师人数
    ,nvl(n.familyzip, o.familyzip) as familyzip -- 家庭地址邮编
    ,nvl(n.weburl, o.weburl) as weburl -- 网址
    ,nvl(n.finacontactpeople, o.finacontactpeople) as finacontactpeople -- 财务部联系人
    ,nvl(n.claimoverdueday, o.claimoverdueday) as claimoverdueday -- 理赔逾期天数
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.paiclupcapital, o.paiclupcapital) as paiclupcapital -- 实收资本
    ,nvl(n.applynum, o.applynum) as applynum -- 拟申请人数
    ,nvl(n.customerscale, o.customerscale) as customerscale -- 企业规模客户类型（代码：1-大型企业2-中型企业）
    ,nvl(n.repaypersontype, o.repaypersontype) as repaypersontype -- 还款责任人类型
    ,nvl(n.familytel, o.familytel) as familytel -- 家庭联系电话
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.basicbank, o.basicbank) as basicbank -- 基本账户开户行
    ,nvl(n.comholdstkamt, o.comholdstkamt) as comholdstkamt -- 拥有我行股份金额
    ,nvl(n.cusbankrel, o.cusbankrel) as cusbankrel -- 客户与我行关联关系
    ,nvl(n.faxcode, o.faxcode) as faxcode -- 传真
    ,nvl(n.businesslicenceenddate, o.businesslicenceenddate) as businesslicenceenddate -- 营业执照到期日期
    ,nvl(n.coopbusiness, o.coopbusiness) as coopbusiness -- 拟合作业务
    ,nvl(n.businessmanager, o.businessmanager) as businessmanager -- 业务联系人
    ,nvl(n.realtyevaluateauthlevel, o.realtyevaluateauthlevel) as realtyevaluateauthlevel -- 相关资质
    ,nvl(n.officezip, o.officezip) as officezip -- 邮编
    ,nvl(n.investtype, o.investtype) as investtype -- 投资主体
    ,nvl(n.orgcodeenddate, o.orgcodeenddate) as orgcodeenddate -- 组织机构登记到期日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.officeadd, o.officeadd) as officeadd -- 公司地址
    ,nvl(n.repaypersonidentity, o.repaypersonidentity) as repaypersonidentity -- 还款责任人身份类型
    ,nvl(n.businesslicencestartdate, o.businesslicencestartdate) as businesslicencestartdate -- 营业执照登记日期
    ,nvl(n.qualificationlicense, o.qualificationlicense) as qualificationlicense -- 房地产评估机构资质证书
    ,nvl(n.landevalregisterlicense, o.landevalregisterlicense) as landevalregisterlicense -- 土地评估中介机构注册证书
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.isdiffcust, o.isdiffcust) as isdiffcust -- 是否异地客户
    ,nvl(n.worknum, o.worknum) as worknum -- 从业人数
    ,nvl(n.creditlevelenddate, o.creditlevelenddate) as creditlevelenddate -- 信用等级到期日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.applyavgamt, o.applyavgamt) as applyavgamt -- 拟申请平均额度
    ,nvl(n.creditleveldate, o.creditleveldate) as creditleveldate -- 信用评定日期
    ,nvl(n.basacclicence, o.basacclicence) as basacclicence -- 基本存款账户开户许可证编号
    ,nvl(n.unittype, o.unittype) as unittype -- 单位性质
    ,nvl(n.coopstartdate, o.coopstartdate) as coopstartdate -- 合作起始日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.coopterm, o.coopterm) as coopterm -- 合作期限（月）
    ,nvl(n.orgcodestartdate, o.orgcodestartdate) as orgcodestartdate -- 组织机构登记日期
    ,nvl(n.registercurrency, o.registercurrency) as registercurrency -- 注册币种
    ,nvl(n.finamobiletel, o.finamobiletel) as finamobiletel -- 财务部联系人手机号码（短信通知）
    ,nvl(n.businesslicence, o.businesslicence) as businesslicence -- 营业执照
    ,nvl(n.officetel, o.officetel) as officetel -- 公司联系电话
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.coreentcustid, o.coreentcustid) as coreentcustid -- 核心企业客户号
    ,nvl(n.qualifictionmaturity, o.qualifictionmaturity) as qualifictionmaturity -- 房地产资质证书有效期限
    ,nvl(n.certcountry, o.certcountry) as certcountry -- 证件国别
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.realtyevaluateauthyear, o.realtyevaluateauthyear) as realtyevaluateauthyear -- 相关资质有效期
    ,nvl(n.isbancredit, o.isbancredit) as isbancredit -- 是否授信暂禁
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.projecttype, o.projecttype) as projecttype -- 合作项目类型
    ,nvl(n.userange, o.userange) as userange -- 共享范围
    ,nvl(n.managebrand, o.managebrand) as managebrand -- 经营品牌
    ,nvl(n.fictitiouscert, o.fictitiouscert) as fictitiouscert -- 法人代表证件编号
    ,nvl(n.landevalregistermaturity, o.landevalregistermaturity) as landevalregistermaturity -- 土地评估中介机构注册证书有效期
    ,nvl(n.houseevaluatornum, o.houseevaluatornum) as houseevaluatornum -- 注册房地产评估师人数
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.iscreditlimit, o.iscreditlimit) as iscreditlimit -- 是否授信暂禁
    ,nvl(n.cooporg, o.cooporg) as cooporg -- 合作机构
    ,nvl(n.accountorg, o.accountorg) as accountorg -- 账户机构
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 完整性标识
    ,nvl(n.mostbusiness, o.mostbusiness) as mostbusiness -- 经营范围
    ,nvl(n.firstcooperationdate, o.firstcooperationdate) as firstcooperationdate -- 首次合作时间
    ,nvl(n.comholdtype, o.comholdtype) as comholdtype -- 控股类型
    ,nvl(n.assetsum, o.assetsum) as assetsum -- 资产总额
    ,nvl(n.evaluatedate, o.evaluatedate) as evaluatedate -- 企业评级日期
    ,nvl(n.compstartdate, o.compstartdate) as compstartdate -- 企业成立日期
    ,nvl(n.iscreditcust, o.iscreditcust) as iscreditcust -- 是否我行授信客户
    ,nvl(n.basaccflg, o.basaccflg) as basaccflg -- 基本存款账户是否在我行
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 流程审批状态
    ,nvl(n.registerdate, o.registerdate) as registerdate -- 注册时间
    ,nvl(n.familyadd, o.familyadd) as familyadd -- 家庭地址
    ,nvl(n.repaypersoncerttype, o.repaypersoncerttype) as repaypersoncerttype -- 相关还款责任人证件类型
    ,nvl(n.email, o.email) as email -- EMAIL
    ,nvl(n.businessincome, o.businessincome) as businessincome -- 营业收入（万元）
    ,nvl(n.creditlevel, o.creditlevel) as creditlevel -- 信用等级(内部)
    ,nvl(n.basaccno, o.basaccno) as basaccno -- 基本存款账户账号
    ,nvl(n.userangeorg, o.userangeorg) as userangeorg -- 适用机构范围编号
    ,nvl(n.maxcreditlimit, o.maxcreditlimit) as maxcreditlimit -- 最高合作额度
    ,nvl(n.registeradd, o.registeradd) as registeradd -- 注册地址
    ,nvl(n.registercapital, o.registercapital) as registercapital -- 注册资金
    ,nvl(n.authenticatelicensedate, o.authenticatelicensedate) as authenticatelicensedate -- 司法鉴定许可证发证日期
    ,nvl(n.partnertype, o.partnertype) as partnertype -- 合作方类型
    ,nvl(n.evaluateresult, o.evaluateresult) as evaluateresult -- 企业评级结果
    ,nvl(n.repaypersoncertid, o.repaypersoncertid) as repaypersoncertid -- 还款责任人证件号码
    ,nvl(n.repaypersonname, o.repaypersonname) as repaypersonname -- 还款责任人名称
    ,nvl(n.fusingoverdue, o.fusingoverdue) as fusingoverdue -- 熔断逾期率
    ,nvl(n.msgphone, o.msgphone) as msgphone -- 短信接收人手机号
    ,nvl(n.warnoverdue, o.warnoverdue) as warnoverdue -- 预警逾期率
    ,nvl(n.consumptionloanlimit, o.consumptionloanlimit) as consumptionloanlimit -- 消费类贷款额度
    ,nvl(n.guaranteelimit100p, o.guaranteelimit100p) as guaranteelimit100p -- 100%担保额度
    ,nvl(n.loanguaranteelimit5y, o.loanguaranteelimit5y) as loanguaranteelimit5y -- 5年期贷款担保额度
    ,nvl(n.totalguaranteelimit, o.totalguaranteelimit) as totalguaranteelimit -- 担保总额度
    ,nvl(n.guaranteeproportion, o.guaranteeproportion) as guaranteeproportion -- 
    ,nvl(n.maxguaranteeamount, o.maxguaranteeamount) as maxguaranteeamount -- 
    ,nvl(n.isguarantee, o.isguarantee) as isguarantee -- 
    ,case when
            n.partnerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.partnerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.partnerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_partner_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_partner where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.partnerid = n.partnerid
where (
        o.partnerid is null
    )
    or (
        n.partnerid is null
    )
    or (
        o.industrytype <> n.industrytype
        or o.partnername <> n.partnername
        or o.partnerenttype <> n.partnerenttype
        or o.fictitiouscerttype <> n.fictitiouscerttype
        or o.address <> n.address
        or o.partnertypesub <> n.partnertypesub
        or o.status <> n.status
        or o.customertype <> n.customertype
        or o.taxpayeridentino <> n.taxpayeridentino
        or o.basaccbank <> n.basaccbank
        or o.finaprincipal <> n.finaprincipal
        or o.comtype <> n.comtype
        or o.projectnumber <> n.projectnumber
        or o.certid <> n.certid
        or o.fictitiousperson <> n.fictitiousperson
        or o.finacomtel <> n.finacomtel
        or o.applytotalamt <> n.applytotalamt
        or o.coopenddate <> n.coopenddate
        or o.authenticatelicense <> n.authenticatelicense
        or o.authevaluatornum <> n.authevaluatornum
        or o.basicaccount <> n.basicaccount
        or o.midsigncode <> n.midsigncode
        or o.bailratio <> n.bailratio
        or o.payday <> n.payday
        or o.industryname <> n.industryname
        or o.orgcode <> n.orgcode
        or o.basaccdate <> n.basaccdate
        or o.cooptype <> n.cooptype
        or o.landevaluatornum <> n.landevaluatornum
        or o.familyzip <> n.familyzip
        or o.weburl <> n.weburl
        or o.finacontactpeople <> n.finacontactpeople
        or o.claimoverdueday <> n.claimoverdueday
        or o.updatedate <> n.updatedate
        or o.paiclupcapital <> n.paiclupcapital
        or o.applynum <> n.applynum
        or o.customerscale <> n.customerscale
        or o.repaypersontype <> n.repaypersontype
        or o.familytel <> n.familytel
        or o.remark <> n.remark
        or o.basicbank <> n.basicbank
        or o.comholdstkamt <> n.comholdstkamt
        or o.cusbankrel <> n.cusbankrel
        or o.faxcode <> n.faxcode
        or o.businesslicenceenddate <> n.businesslicenceenddate
        or o.coopbusiness <> n.coopbusiness
        or o.businessmanager <> n.businessmanager
        or o.realtyevaluateauthlevel <> n.realtyevaluateauthlevel
        or o.officezip <> n.officezip
        or o.investtype <> n.investtype
        or o.orgcodeenddate <> n.orgcodeenddate
        or o.inputorgid <> n.inputorgid
        or o.officeadd <> n.officeadd
        or o.repaypersonidentity <> n.repaypersonidentity
        or o.businesslicencestartdate <> n.businesslicencestartdate
        or o.qualificationlicense <> n.qualificationlicense
        or o.landevalregisterlicense <> n.landevalregisterlicense
        or o.customerid <> n.customerid
        or o.migtflag <> n.migtflag
        or o.isdiffcust <> n.isdiffcust
        or o.worknum <> n.worknum
        or o.creditlevelenddate <> n.creditlevelenddate
        or o.corporgid <> n.corporgid
        or o.applyavgamt <> n.applyavgamt
        or o.creditleveldate <> n.creditleveldate
        or o.basacclicence <> n.basacclicence
        or o.unittype <> n.unittype
        or o.coopstartdate <> n.coopstartdate
        or o.updateuserid <> n.updateuserid
        or o.coopterm <> n.coopterm
        or o.orgcodestartdate <> n.orgcodestartdate
        or o.registercurrency <> n.registercurrency
        or o.finamobiletel <> n.finamobiletel
        or o.businesslicence <> n.businesslicence
        or o.officetel <> n.officetel
        or o.inputdate <> n.inputdate
        or o.coreentcustid <> n.coreentcustid
        or o.qualifictionmaturity <> n.qualifictionmaturity
        or o.certcountry <> n.certcountry
        or o.certtype <> n.certtype
        or o.realtyevaluateauthyear <> n.realtyevaluateauthyear
        or o.isbancredit <> n.isbancredit
        or o.inputuserid <> n.inputuserid
        or o.projecttype <> n.projecttype
        or o.userange <> n.userange
        or o.managebrand <> n.managebrand
        or o.fictitiouscert <> n.fictitiouscert
        or o.landevalregistermaturity <> n.landevalregistermaturity
        or o.houseevaluatornum <> n.houseevaluatornum
        or o.updateorgid <> n.updateorgid
        or o.iscreditlimit <> n.iscreditlimit
        or o.cooporg <> n.cooporg
        or o.accountorg <> n.accountorg
        or o.completeflag <> n.completeflag
        or o.mostbusiness <> n.mostbusiness
        or o.firstcooperationdate <> n.firstcooperationdate
        or o.comholdtype <> n.comholdtype
        or o.assetsum <> n.assetsum
        or o.evaluatedate <> n.evaluatedate
        or o.compstartdate <> n.compstartdate
        or o.iscreditcust <> n.iscreditcust
        or o.basaccflg <> n.basaccflg
        or o.approvestatus <> n.approvestatus
        or o.registerdate <> n.registerdate
        or o.familyadd <> n.familyadd
        or o.repaypersoncerttype <> n.repaypersoncerttype
        or o.email <> n.email
        or o.businessincome <> n.businessincome
        or o.creditlevel <> n.creditlevel
        or o.basaccno <> n.basaccno
        or o.userangeorg <> n.userangeorg
        or o.maxcreditlimit <> n.maxcreditlimit
        or o.registeradd <> n.registeradd
        or o.registercapital <> n.registercapital
        or o.authenticatelicensedate <> n.authenticatelicensedate
        or o.partnertype <> n.partnertype
        or o.evaluateresult <> n.evaluateresult
        or o.repaypersoncertid <> n.repaypersoncertid
        or o.repaypersonname <> n.repaypersonname
        or o.fusingoverdue <> n.fusingoverdue
        or o.msgphone <> n.msgphone
        or o.warnoverdue <> n.warnoverdue
        or o.consumptionloanlimit <> n.consumptionloanlimit
        or o.guaranteelimit100p <> n.guaranteelimit100p
        or o.loanguaranteelimit5y <> n.loanguaranteelimit5y
        or o.totalguaranteelimit <> n.totalguaranteelimit
        or o.guaranteeproportion <> n.guaranteeproportion
        or o.maxguaranteeamount <> n.maxguaranteeamount
        or o.isguarantee <> n.isguarantee
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_partner_cl(
            partnerid -- 合作方编号
            ,industrytype -- 行业类型
            ,partnername -- 合作方名称
            ,partnerenttype -- 合作企业类型
            ,fictitiouscerttype -- 法人代表证件类型
            ,address -- 地址
            ,partnertypesub -- 合作商类型
            ,status -- 合作方状态
            ,customertype -- 客户类型机构类型（代码：1-法人企业2-非法人企业3-事业单位4-社会团体5-党政机关6-其他）
            ,taxpayeridentino -- 纳税人识别号
            ,basaccbank -- 基本存款账户开户行
            ,finaprincipal -- 财务部负责人
            ,comtype -- 机构类别
            ,projectnumber -- 合作项目数量
            ,certid -- 证件号码
            ,fictitiousperson -- 法人代表姓名
            ,finacomtel -- 财务部联系人单位电话
            ,applytotalamt -- 总额度
            ,coopenddate -- 合作结束日期
            ,authenticatelicense -- 司法鉴定许可证号
            ,authevaluatornum -- 具备司法鉴定资格人数
            ,basicaccount -- 基本账户账号
            ,midsigncode -- 中征码
            ,bailratio -- 保证金比例
            ,payday -- 代偿天数
            ,industryname -- 行业名称
            ,orgcode -- 组织机构代码
            ,basaccdate -- 基本账户开户日期
            ,cooptype -- 合作方式
            ,landevaluatornum -- 土地估价师人数
            ,familyzip -- 家庭地址邮编
            ,weburl -- 网址
            ,finacontactpeople -- 财务部联系人
            ,claimoverdueday -- 理赔逾期天数
            ,updatedate -- 更新日期
            ,paiclupcapital -- 实收资本
            ,applynum -- 拟申请人数
            ,customerscale -- 企业规模客户类型（代码：1-大型企业2-中型企业）
            ,repaypersontype -- 还款责任人类型
            ,familytel -- 家庭联系电话
            ,remark -- 备注
            ,basicbank -- 基本账户开户行
            ,comholdstkamt -- 拥有我行股份金额
            ,cusbankrel -- 客户与我行关联关系
            ,faxcode -- 传真
            ,businesslicenceenddate -- 营业执照到期日期
            ,coopbusiness -- 拟合作业务
            ,businessmanager -- 业务联系人
            ,realtyevaluateauthlevel -- 相关资质
            ,officezip -- 邮编
            ,investtype -- 投资主体
            ,orgcodeenddate -- 组织机构登记到期日期
            ,inputorgid -- 登记机构
            ,officeadd -- 公司地址
            ,repaypersonidentity -- 还款责任人身份类型
            ,businesslicencestartdate -- 营业执照登记日期
            ,qualificationlicense -- 房地产评估机构资质证书
            ,landevalregisterlicense -- 土地评估中介机构注册证书
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,isdiffcust -- 是否异地客户
            ,worknum -- 从业人数
            ,creditlevelenddate -- 信用等级到期日期
            ,corporgid -- 法人机构编号
            ,applyavgamt -- 拟申请平均额度
            ,creditleveldate -- 信用评定日期
            ,basacclicence -- 基本存款账户开户许可证编号
            ,unittype -- 单位性质
            ,coopstartdate -- 合作起始日期
            ,updateuserid -- 更新人
            ,coopterm -- 合作期限（月）
            ,orgcodestartdate -- 组织机构登记日期
            ,registercurrency -- 注册币种
            ,finamobiletel -- 财务部联系人手机号码（短信通知）
            ,businesslicence -- 营业执照
            ,officetel -- 公司联系电话
            ,inputdate -- 登记日期
            ,coreentcustid -- 核心企业客户号
            ,qualifictionmaturity -- 房地产资质证书有效期限
            ,certcountry -- 证件国别
            ,certtype -- 证件类型
            ,realtyevaluateauthyear -- 相关资质有效期
            ,isbancredit -- 是否授信暂禁
            ,inputuserid -- 登记人
            ,projecttype -- 合作项目类型
            ,userange -- 共享范围
            ,managebrand -- 经营品牌
            ,fictitiouscert -- 法人代表证件编号
            ,landevalregistermaturity -- 土地评估中介机构注册证书有效期
            ,houseevaluatornum -- 注册房地产评估师人数
            ,updateorgid -- 更新机构
            ,iscreditlimit -- 是否授信暂禁
            ,cooporg -- 合作机构
            ,accountorg -- 账户机构
            ,completeflag -- 完整性标识
            ,mostbusiness -- 经营范围
            ,firstcooperationdate -- 首次合作时间
            ,comholdtype -- 控股类型
            ,assetsum -- 资产总额
            ,evaluatedate -- 企业评级日期
            ,compstartdate -- 企业成立日期
            ,iscreditcust -- 是否我行授信客户
            ,basaccflg -- 基本存款账户是否在我行
            ,approvestatus -- 流程审批状态
            ,registerdate -- 注册时间
            ,familyadd -- 家庭地址
            ,repaypersoncerttype -- 相关还款责任人证件类型
            ,email -- EMAIL
            ,businessincome -- 营业收入（万元）
            ,creditlevel -- 信用等级(内部)
            ,basaccno -- 基本存款账户账号
            ,userangeorg -- 适用机构范围编号
            ,maxcreditlimit -- 最高合作额度
            ,registeradd -- 注册地址
            ,registercapital -- 注册资金
            ,authenticatelicensedate -- 司法鉴定许可证发证日期
            ,partnertype -- 合作方类型
            ,evaluateresult -- 企业评级结果
            ,repaypersoncertid -- 还款责任人证件号码
            ,repaypersonname -- 还款责任人名称
            ,fusingoverdue -- 熔断逾期率
            ,msgphone -- 短信接收人手机号
            ,warnoverdue -- 预警逾期率
            ,consumptionloanlimit -- 消费类贷款额度
            ,guaranteelimit100p -- 100%担保额度
            ,loanguaranteelimit5y -- 5年期贷款担保额度
            ,totalguaranteelimit -- 担保总额度
            ,guaranteeproportion -- 
            ,maxguaranteeamount -- 
            ,isguarantee -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_partner_op(
            partnerid -- 合作方编号
            ,industrytype -- 行业类型
            ,partnername -- 合作方名称
            ,partnerenttype -- 合作企业类型
            ,fictitiouscerttype -- 法人代表证件类型
            ,address -- 地址
            ,partnertypesub -- 合作商类型
            ,status -- 合作方状态
            ,customertype -- 客户类型机构类型（代码：1-法人企业2-非法人企业3-事业单位4-社会团体5-党政机关6-其他）
            ,taxpayeridentino -- 纳税人识别号
            ,basaccbank -- 基本存款账户开户行
            ,finaprincipal -- 财务部负责人
            ,comtype -- 机构类别
            ,projectnumber -- 合作项目数量
            ,certid -- 证件号码
            ,fictitiousperson -- 法人代表姓名
            ,finacomtel -- 财务部联系人单位电话
            ,applytotalamt -- 总额度
            ,coopenddate -- 合作结束日期
            ,authenticatelicense -- 司法鉴定许可证号
            ,authevaluatornum -- 具备司法鉴定资格人数
            ,basicaccount -- 基本账户账号
            ,midsigncode -- 中征码
            ,bailratio -- 保证金比例
            ,payday -- 代偿天数
            ,industryname -- 行业名称
            ,orgcode -- 组织机构代码
            ,basaccdate -- 基本账户开户日期
            ,cooptype -- 合作方式
            ,landevaluatornum -- 土地估价师人数
            ,familyzip -- 家庭地址邮编
            ,weburl -- 网址
            ,finacontactpeople -- 财务部联系人
            ,claimoverdueday -- 理赔逾期天数
            ,updatedate -- 更新日期
            ,paiclupcapital -- 实收资本
            ,applynum -- 拟申请人数
            ,customerscale -- 企业规模客户类型（代码：1-大型企业2-中型企业）
            ,repaypersontype -- 还款责任人类型
            ,familytel -- 家庭联系电话
            ,remark -- 备注
            ,basicbank -- 基本账户开户行
            ,comholdstkamt -- 拥有我行股份金额
            ,cusbankrel -- 客户与我行关联关系
            ,faxcode -- 传真
            ,businesslicenceenddate -- 营业执照到期日期
            ,coopbusiness -- 拟合作业务
            ,businessmanager -- 业务联系人
            ,realtyevaluateauthlevel -- 相关资质
            ,officezip -- 邮编
            ,investtype -- 投资主体
            ,orgcodeenddate -- 组织机构登记到期日期
            ,inputorgid -- 登记机构
            ,officeadd -- 公司地址
            ,repaypersonidentity -- 还款责任人身份类型
            ,businesslicencestartdate -- 营业执照登记日期
            ,qualificationlicense -- 房地产评估机构资质证书
            ,landevalregisterlicense -- 土地评估中介机构注册证书
            ,customerid -- 客户编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,isdiffcust -- 是否异地客户
            ,worknum -- 从业人数
            ,creditlevelenddate -- 信用等级到期日期
            ,corporgid -- 法人机构编号
            ,applyavgamt -- 拟申请平均额度
            ,creditleveldate -- 信用评定日期
            ,basacclicence -- 基本存款账户开户许可证编号
            ,unittype -- 单位性质
            ,coopstartdate -- 合作起始日期
            ,updateuserid -- 更新人
            ,coopterm -- 合作期限（月）
            ,orgcodestartdate -- 组织机构登记日期
            ,registercurrency -- 注册币种
            ,finamobiletel -- 财务部联系人手机号码（短信通知）
            ,businesslicence -- 营业执照
            ,officetel -- 公司联系电话
            ,inputdate -- 登记日期
            ,coreentcustid -- 核心企业客户号
            ,qualifictionmaturity -- 房地产资质证书有效期限
            ,certcountry -- 证件国别
            ,certtype -- 证件类型
            ,realtyevaluateauthyear -- 相关资质有效期
            ,isbancredit -- 是否授信暂禁
            ,inputuserid -- 登记人
            ,projecttype -- 合作项目类型
            ,userange -- 共享范围
            ,managebrand -- 经营品牌
            ,fictitiouscert -- 法人代表证件编号
            ,landevalregistermaturity -- 土地评估中介机构注册证书有效期
            ,houseevaluatornum -- 注册房地产评估师人数
            ,updateorgid -- 更新机构
            ,iscreditlimit -- 是否授信暂禁
            ,cooporg -- 合作机构
            ,accountorg -- 账户机构
            ,completeflag -- 完整性标识
            ,mostbusiness -- 经营范围
            ,firstcooperationdate -- 首次合作时间
            ,comholdtype -- 控股类型
            ,assetsum -- 资产总额
            ,evaluatedate -- 企业评级日期
            ,compstartdate -- 企业成立日期
            ,iscreditcust -- 是否我行授信客户
            ,basaccflg -- 基本存款账户是否在我行
            ,approvestatus -- 流程审批状态
            ,registerdate -- 注册时间
            ,familyadd -- 家庭地址
            ,repaypersoncerttype -- 相关还款责任人证件类型
            ,email -- EMAIL
            ,businessincome -- 营业收入（万元）
            ,creditlevel -- 信用等级(内部)
            ,basaccno -- 基本存款账户账号
            ,userangeorg -- 适用机构范围编号
            ,maxcreditlimit -- 最高合作额度
            ,registeradd -- 注册地址
            ,registercapital -- 注册资金
            ,authenticatelicensedate -- 司法鉴定许可证发证日期
            ,partnertype -- 合作方类型
            ,evaluateresult -- 企业评级结果
            ,repaypersoncertid -- 还款责任人证件号码
            ,repaypersonname -- 还款责任人名称
            ,fusingoverdue -- 熔断逾期率
            ,msgphone -- 短信接收人手机号
            ,warnoverdue -- 预警逾期率
            ,consumptionloanlimit -- 消费类贷款额度
            ,guaranteelimit100p -- 100%担保额度
            ,loanguaranteelimit5y -- 5年期贷款担保额度
            ,totalguaranteelimit -- 担保总额度
            ,guaranteeproportion -- 
            ,maxguaranteeamount -- 
            ,isguarantee -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.partnerid -- 合作方编号
    ,o.industrytype -- 行业类型
    ,o.partnername -- 合作方名称
    ,o.partnerenttype -- 合作企业类型
    ,o.fictitiouscerttype -- 法人代表证件类型
    ,o.address -- 地址
    ,o.partnertypesub -- 合作商类型
    ,o.status -- 合作方状态
    ,o.customertype -- 客户类型机构类型（代码：1-法人企业2-非法人企业3-事业单位4-社会团体5-党政机关6-其他）
    ,o.taxpayeridentino -- 纳税人识别号
    ,o.basaccbank -- 基本存款账户开户行
    ,o.finaprincipal -- 财务部负责人
    ,o.comtype -- 机构类别
    ,o.projectnumber -- 合作项目数量
    ,o.certid -- 证件号码
    ,o.fictitiousperson -- 法人代表姓名
    ,o.finacomtel -- 财务部联系人单位电话
    ,o.applytotalamt -- 总额度
    ,o.coopenddate -- 合作结束日期
    ,o.authenticatelicense -- 司法鉴定许可证号
    ,o.authevaluatornum -- 具备司法鉴定资格人数
    ,o.basicaccount -- 基本账户账号
    ,o.midsigncode -- 中征码
    ,o.bailratio -- 保证金比例
    ,o.payday -- 代偿天数
    ,o.industryname -- 行业名称
    ,o.orgcode -- 组织机构代码
    ,o.basaccdate -- 基本账户开户日期
    ,o.cooptype -- 合作方式
    ,o.landevaluatornum -- 土地估价师人数
    ,o.familyzip -- 家庭地址邮编
    ,o.weburl -- 网址
    ,o.finacontactpeople -- 财务部联系人
    ,o.claimoverdueday -- 理赔逾期天数
    ,o.updatedate -- 更新日期
    ,o.paiclupcapital -- 实收资本
    ,o.applynum -- 拟申请人数
    ,o.customerscale -- 企业规模客户类型（代码：1-大型企业2-中型企业）
    ,o.repaypersontype -- 还款责任人类型
    ,o.familytel -- 家庭联系电话
    ,o.remark -- 备注
    ,o.basicbank -- 基本账户开户行
    ,o.comholdstkamt -- 拥有我行股份金额
    ,o.cusbankrel -- 客户与我行关联关系
    ,o.faxcode -- 传真
    ,o.businesslicenceenddate -- 营业执照到期日期
    ,o.coopbusiness -- 拟合作业务
    ,o.businessmanager -- 业务联系人
    ,o.realtyevaluateauthlevel -- 相关资质
    ,o.officezip -- 邮编
    ,o.investtype -- 投资主体
    ,o.orgcodeenddate -- 组织机构登记到期日期
    ,o.inputorgid -- 登记机构
    ,o.officeadd -- 公司地址
    ,o.repaypersonidentity -- 还款责任人身份类型
    ,o.businesslicencestartdate -- 营业执照登记日期
    ,o.qualificationlicense -- 房地产评估机构资质证书
    ,o.landevalregisterlicense -- 土地评估中介机构注册证书
    ,o.customerid -- 客户编号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.isdiffcust -- 是否异地客户
    ,o.worknum -- 从业人数
    ,o.creditlevelenddate -- 信用等级到期日期
    ,o.corporgid -- 法人机构编号
    ,o.applyavgamt -- 拟申请平均额度
    ,o.creditleveldate -- 信用评定日期
    ,o.basacclicence -- 基本存款账户开户许可证编号
    ,o.unittype -- 单位性质
    ,o.coopstartdate -- 合作起始日期
    ,o.updateuserid -- 更新人
    ,o.coopterm -- 合作期限（月）
    ,o.orgcodestartdate -- 组织机构登记日期
    ,o.registercurrency -- 注册币种
    ,o.finamobiletel -- 财务部联系人手机号码（短信通知）
    ,o.businesslicence -- 营业执照
    ,o.officetel -- 公司联系电话
    ,o.inputdate -- 登记日期
    ,o.coreentcustid -- 核心企业客户号
    ,o.qualifictionmaturity -- 房地产资质证书有效期限
    ,o.certcountry -- 证件国别
    ,o.certtype -- 证件类型
    ,o.realtyevaluateauthyear -- 相关资质有效期
    ,o.isbancredit -- 是否授信暂禁
    ,o.inputuserid -- 登记人
    ,o.projecttype -- 合作项目类型
    ,o.userange -- 共享范围
    ,o.managebrand -- 经营品牌
    ,o.fictitiouscert -- 法人代表证件编号
    ,o.landevalregistermaturity -- 土地评估中介机构注册证书有效期
    ,o.houseevaluatornum -- 注册房地产评估师人数
    ,o.updateorgid -- 更新机构
    ,o.iscreditlimit -- 是否授信暂禁
    ,o.cooporg -- 合作机构
    ,o.accountorg -- 账户机构
    ,o.completeflag -- 完整性标识
    ,o.mostbusiness -- 经营范围
    ,o.firstcooperationdate -- 首次合作时间
    ,o.comholdtype -- 控股类型
    ,o.assetsum -- 资产总额
    ,o.evaluatedate -- 企业评级日期
    ,o.compstartdate -- 企业成立日期
    ,o.iscreditcust -- 是否我行授信客户
    ,o.basaccflg -- 基本存款账户是否在我行
    ,o.approvestatus -- 流程审批状态
    ,o.registerdate -- 注册时间
    ,o.familyadd -- 家庭地址
    ,o.repaypersoncerttype -- 相关还款责任人证件类型
    ,o.email -- EMAIL
    ,o.businessincome -- 营业收入（万元）
    ,o.creditlevel -- 信用等级(内部)
    ,o.basaccno -- 基本存款账户账号
    ,o.userangeorg -- 适用机构范围编号
    ,o.maxcreditlimit -- 最高合作额度
    ,o.registeradd -- 注册地址
    ,o.registercapital -- 注册资金
    ,o.authenticatelicensedate -- 司法鉴定许可证发证日期
    ,o.partnertype -- 合作方类型
    ,o.evaluateresult -- 企业评级结果
    ,o.repaypersoncertid -- 还款责任人证件号码
    ,o.repaypersonname -- 还款责任人名称
    ,o.fusingoverdue -- 熔断逾期率
    ,o.msgphone -- 短信接收人手机号
    ,o.warnoverdue -- 预警逾期率
    ,o.consumptionloanlimit -- 消费类贷款额度
    ,o.guaranteelimit100p -- 100%担保额度
    ,o.loanguaranteelimit5y -- 5年期贷款担保额度
    ,o.totalguaranteelimit -- 担保总额度
    ,o.guaranteeproportion -- 
    ,o.maxguaranteeamount -- 
    ,o.isguarantee -- 
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
from ${iol_schema}.icms_customer_partner_bk o
    left join ${iol_schema}.icms_customer_partner_op n
        on
            o.partnerid = n.partnerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_partner_cl d
        on
            o.partnerid = d.partnerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_partner;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_partner') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_partner drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_partner add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_partner exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_partner_cl;
alter table ${iol_schema}.icms_customer_partner exchange partition p_20991231 with table ${iol_schema}.icms_customer_partner_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_partner to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_partner_op purge;
drop table ${iol_schema}.icms_customer_partner_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_partner_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_partner',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
