/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_partner
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_partner
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_partner purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_partner(
    partnerid varchar2(64) -- 合作方编号
    ,industrytype varchar2(8) -- 行业类型
    ,partnername varchar2(500) -- 合作方名称
    ,partnerenttype varchar2(36) -- 合作企业类型
    ,fictitiouscerttype varchar2(36) -- 法人代表证件类型
    ,address varchar2(1000) -- 地址
    ,partnertypesub varchar2(10) -- 合作商类型
    ,status varchar2(36) -- 合作方状态
    ,customertype varchar2(36) -- 客户类型机构类型（代码：1-法人企业2-非法人企业3-事业单位4-社会团体5-党政机关6-其他）
    ,taxpayeridentino varchar2(60) -- 纳税人识别号
    ,basaccbank varchar2(160) -- 基本存款账户开户行
    ,finaprincipal varchar2(100) -- 财务部负责人
    ,comtype varchar2(5) -- 机构类别
    ,projectnumber number(22) -- 合作项目数量
    ,certid varchar2(60) -- 证件号码
    ,fictitiousperson varchar2(200) -- 法人代表姓名
    ,finacomtel varchar2(30) -- 财务部联系人单位电话
    ,applytotalamt number(22,0) -- 总额度
    ,coopenddate date -- 合作结束日期
    ,authenticatelicense varchar2(64) -- 司法鉴定许可证号
    ,authevaluatornum number(22) -- 具备司法鉴定资格人数
    ,basicaccount varchar2(64) -- 基本账户账号
    ,midsigncode varchar2(30) -- 中征码
    ,bailratio number(10,0) -- 保证金比例
    ,payday number(5,0) -- 代偿天数
    ,industryname varchar2(200) -- 行业名称
    ,orgcode varchar2(30) -- 组织机构代码
    ,basaccdate date -- 基本账户开户日期
    ,cooptype varchar2(4) -- 合作方式
    ,landevaluatornum number(22) -- 土地估价师人数
    ,familyzip varchar2(36) -- 家庭地址邮编
    ,weburl varchar2(80) -- 网址
    ,finacontactpeople varchar2(100) -- 财务部联系人
    ,claimoverdueday number(5,0) -- 理赔逾期天数
    ,updatedate date -- 更新日期
    ,paiclupcapital number(24,6) -- 实收资本
    ,applynum number(22,0) -- 拟申请人数
    ,customerscale varchar2(36) -- 企业规模客户类型（代码：1-大型企业2-中型企业）
    ,repaypersontype varchar2(5) -- 还款责任人类型
    ,familytel varchar2(64) -- 家庭联系电话
    ,remark varchar2(2000) -- 备注
    ,basicbank varchar2(64) -- 基本账户开户行
    ,comholdstkamt number(24,6) -- 拥有我行股份金额
    ,cusbankrel varchar2(20) -- 客户与我行关联关系
    ,faxcode varchar2(25) -- 传真
    ,businesslicenceenddate date -- 营业执照到期日期
    ,coopbusiness varchar2(250) -- 拟合作业务
    ,businessmanager varchar2(64) -- 业务联系人
    ,realtyevaluateauthlevel varchar2(36) -- 相关资质
    ,officezip varchar2(36) -- 邮编
    ,investtype varchar2(2) -- 投资主体
    ,orgcodeenddate date -- 组织机构登记到期日期
    ,inputorgid varchar2(12) -- 登记机构
    ,officeadd varchar2(1000) -- 公司地址
    ,repaypersonidentity varchar2(5) -- 还款责任人身份类型
    ,businesslicencestartdate date -- 营业执照登记日期
    ,qualificationlicense varchar2(64) -- 房地产评估机构资质证书
    ,landevalregisterlicense varchar2(64) -- 土地评估中介机构注册证书
    ,customerid varchar2(16) -- 客户编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,isdiffcust varchar2(5) -- 是否异地客户
    ,worknum number(22,0) -- 从业人数
    ,creditlevelenddate date -- 信用等级到期日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,applyavgamt number(22,0) -- 拟申请平均额度
    ,creditleveldate date -- 信用评定日期
    ,basacclicence varchar2(40) -- 基本存款账户开户许可证编号
    ,unittype varchar2(5) -- 单位性质
    ,coopstartdate date -- 合作起始日期
    ,updateuserid varchar2(64) -- 更新人
    ,coopterm number(22) -- 合作期限（月）
    ,orgcodestartdate date -- 组织机构登记日期
    ,registercurrency varchar2(36) -- 注册币种
    ,finamobiletel varchar2(30) -- 财务部联系人手机号码（短信通知）
    ,businesslicence varchar2(32) -- 营业执照
    ,officetel varchar2(64) -- 公司联系电话
    ,inputdate date -- 登记日期
    ,coreentcustid varchar2(32) -- 核心企业客户号
    ,qualifictionmaturity date -- 房地产资质证书有效期限
    ,certcountry varchar2(36) -- 证件国别
    ,certtype varchar2(36) -- 证件类型
    ,realtyevaluateauthyear number(22) -- 相关资质有效期
    ,isbancredit varchar2(2) -- 是否授信暂禁
    ,inputuserid varchar2(64) -- 登记人
    ,projecttype varchar2(3) -- 合作项目类型
    ,userange varchar2(30) -- 共享范围
    ,managebrand varchar2(64) -- 经营品牌
    ,fictitiouscert varchar2(64) -- 法人代表证件编号
    ,landevalregistermaturity date -- 土地评估中介机构注册证书有效期
    ,houseevaluatornum number(22) -- 注册房地产评估师人数
    ,updateorgid varchar2(64) -- 更新机构
    ,iscreditlimit varchar2(2) -- 是否授信暂禁
    ,cooporg varchar2(100) -- 合作机构
    ,accountorg varchar2(100) -- 账户机构
    ,completeflag varchar2(2) -- 完整性标识
    ,mostbusiness varchar2(3000) -- 经营范围
    ,firstcooperationdate date -- 首次合作时间
    ,comholdtype varchar2(5) -- 控股类型
    ,assetsum number(20,2) -- 资产总额
    ,evaluatedate date -- 企业评级日期
    ,compstartdate date -- 企业成立日期
    ,iscreditcust varchar2(2) -- 是否我行授信客户
    ,basaccflg varchar2(2) -- 基本存款账户是否在我行
    ,approvestatus varchar2(64) -- 流程审批状态
    ,registerdate date -- 注册时间
    ,familyadd varchar2(1000) -- 家庭地址
    ,repaypersoncerttype varchar2(5) -- 相关还款责任人证件类型
    ,email varchar2(80) -- EMAIL
    ,businessincome number(22,0) -- 营业收入（万元）
    ,creditlevel varchar2(4) -- 信用等级(内部)
    ,basaccno varchar2(64) -- 基本存款账户账号
    ,userangeorg varchar2(1000) -- 适用机构范围编号
    ,maxcreditlimit number(24,6) -- 最高合作额度
    ,registeradd varchar2(1000) -- 注册地址
    ,registercapital number(24,6) -- 注册资金
    ,authenticatelicensedate date -- 司法鉴定许可证发证日期
    ,partnertype varchar2(36) -- 合作方类型
    ,evaluateresult varchar2(36) -- 企业评级结果
    ,repaypersoncertid varchar2(32) -- 还款责任人证件号码
    ,repaypersonname varchar2(100) -- 还款责任人名称
    ,fusingoverdue number(24,8) -- 熔断逾期率
    ,msgphone varchar2(30) -- 短信接收人手机号
    ,warnoverdue number(24,8) -- 预警逾期率
    ,consumptionloanlimit number(20,2) -- 消费类贷款额度
    ,guaranteelimit100p number(20,2) -- 100%担保额度
    ,loanguaranteelimit5y number(20,2) -- 5年期贷款担保额度
    ,totalguaranteelimit number(20,2) -- 担保总额度
    ,guaranteeproportion number(10,6) -- 
    ,maxguaranteeamount number(24,6) -- 
    ,isguarantee varchar2(1) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_customer_partner to ${iml_schema};
grant select on ${iol_schema}.icms_customer_partner to ${icl_schema};
grant select on ${iol_schema}.icms_customer_partner to ${idl_schema};
grant select on ${iol_schema}.icms_customer_partner to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_partner is '合作方客户合作方客户';
comment on column ${iol_schema}.icms_customer_partner.partnerid is '合作方编号';
comment on column ${iol_schema}.icms_customer_partner.industrytype is '行业类型';
comment on column ${iol_schema}.icms_customer_partner.partnername is '合作方名称';
comment on column ${iol_schema}.icms_customer_partner.partnerenttype is '合作企业类型';
comment on column ${iol_schema}.icms_customer_partner.fictitiouscerttype is '法人代表证件类型';
comment on column ${iol_schema}.icms_customer_partner.address is '地址';
comment on column ${iol_schema}.icms_customer_partner.partnertypesub is '合作商类型';
comment on column ${iol_schema}.icms_customer_partner.status is '合作方状态';
comment on column ${iol_schema}.icms_customer_partner.customertype is '客户类型机构类型（代码：1-法人企业2-非法人企业3-事业单位4-社会团体5-党政机关6-其他）';
comment on column ${iol_schema}.icms_customer_partner.taxpayeridentino is '纳税人识别号';
comment on column ${iol_schema}.icms_customer_partner.basaccbank is '基本存款账户开户行';
comment on column ${iol_schema}.icms_customer_partner.finaprincipal is '财务部负责人';
comment on column ${iol_schema}.icms_customer_partner.comtype is '机构类别';
comment on column ${iol_schema}.icms_customer_partner.projectnumber is '合作项目数量';
comment on column ${iol_schema}.icms_customer_partner.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_partner.fictitiousperson is '法人代表姓名';
comment on column ${iol_schema}.icms_customer_partner.finacomtel is '财务部联系人单位电话';
comment on column ${iol_schema}.icms_customer_partner.applytotalamt is '总额度';
comment on column ${iol_schema}.icms_customer_partner.coopenddate is '合作结束日期';
comment on column ${iol_schema}.icms_customer_partner.authenticatelicense is '司法鉴定许可证号';
comment on column ${iol_schema}.icms_customer_partner.authevaluatornum is '具备司法鉴定资格人数';
comment on column ${iol_schema}.icms_customer_partner.basicaccount is '基本账户账号';
comment on column ${iol_schema}.icms_customer_partner.midsigncode is '中征码';
comment on column ${iol_schema}.icms_customer_partner.bailratio is '保证金比例';
comment on column ${iol_schema}.icms_customer_partner.payday is '代偿天数';
comment on column ${iol_schema}.icms_customer_partner.industryname is '行业名称';
comment on column ${iol_schema}.icms_customer_partner.orgcode is '组织机构代码';
comment on column ${iol_schema}.icms_customer_partner.basaccdate is '基本账户开户日期';
comment on column ${iol_schema}.icms_customer_partner.cooptype is '合作方式';
comment on column ${iol_schema}.icms_customer_partner.landevaluatornum is '土地估价师人数';
comment on column ${iol_schema}.icms_customer_partner.familyzip is '家庭地址邮编';
comment on column ${iol_schema}.icms_customer_partner.weburl is '网址';
comment on column ${iol_schema}.icms_customer_partner.finacontactpeople is '财务部联系人';
comment on column ${iol_schema}.icms_customer_partner.claimoverdueday is '理赔逾期天数';
comment on column ${iol_schema}.icms_customer_partner.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_partner.paiclupcapital is '实收资本';
comment on column ${iol_schema}.icms_customer_partner.applynum is '拟申请人数';
comment on column ${iol_schema}.icms_customer_partner.customerscale is '企业规模客户类型（代码：1-大型企业2-中型企业）';
comment on column ${iol_schema}.icms_customer_partner.repaypersontype is '还款责任人类型';
comment on column ${iol_schema}.icms_customer_partner.familytel is '家庭联系电话';
comment on column ${iol_schema}.icms_customer_partner.remark is '备注';
comment on column ${iol_schema}.icms_customer_partner.basicbank is '基本账户开户行';
comment on column ${iol_schema}.icms_customer_partner.comholdstkamt is '拥有我行股份金额';
comment on column ${iol_schema}.icms_customer_partner.cusbankrel is '客户与我行关联关系';
comment on column ${iol_schema}.icms_customer_partner.faxcode is '传真';
comment on column ${iol_schema}.icms_customer_partner.businesslicenceenddate is '营业执照到期日期';
comment on column ${iol_schema}.icms_customer_partner.coopbusiness is '拟合作业务';
comment on column ${iol_schema}.icms_customer_partner.businessmanager is '业务联系人';
comment on column ${iol_schema}.icms_customer_partner.realtyevaluateauthlevel is '相关资质';
comment on column ${iol_schema}.icms_customer_partner.officezip is '邮编';
comment on column ${iol_schema}.icms_customer_partner.investtype is '投资主体';
comment on column ${iol_schema}.icms_customer_partner.orgcodeenddate is '组织机构登记到期日期';
comment on column ${iol_schema}.icms_customer_partner.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_partner.officeadd is '公司地址';
comment on column ${iol_schema}.icms_customer_partner.repaypersonidentity is '还款责任人身份类型';
comment on column ${iol_schema}.icms_customer_partner.businesslicencestartdate is '营业执照登记日期';
comment on column ${iol_schema}.icms_customer_partner.qualificationlicense is '房地产评估机构资质证书';
comment on column ${iol_schema}.icms_customer_partner.landevalregisterlicense is '土地评估中介机构注册证书';
comment on column ${iol_schema}.icms_customer_partner.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_partner.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_partner.isdiffcust is '是否异地客户';
comment on column ${iol_schema}.icms_customer_partner.worknum is '从业人数';
comment on column ${iol_schema}.icms_customer_partner.creditlevelenddate is '信用等级到期日期';
comment on column ${iol_schema}.icms_customer_partner.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_partner.applyavgamt is '拟申请平均额度';
comment on column ${iol_schema}.icms_customer_partner.creditleveldate is '信用评定日期';
comment on column ${iol_schema}.icms_customer_partner.basacclicence is '基本存款账户开户许可证编号';
comment on column ${iol_schema}.icms_customer_partner.unittype is '单位性质';
comment on column ${iol_schema}.icms_customer_partner.coopstartdate is '合作起始日期';
comment on column ${iol_schema}.icms_customer_partner.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_partner.coopterm is '合作期限（月）';
comment on column ${iol_schema}.icms_customer_partner.orgcodestartdate is '组织机构登记日期';
comment on column ${iol_schema}.icms_customer_partner.registercurrency is '注册币种';
comment on column ${iol_schema}.icms_customer_partner.finamobiletel is '财务部联系人手机号码（短信通知）';
comment on column ${iol_schema}.icms_customer_partner.businesslicence is '营业执照';
comment on column ${iol_schema}.icms_customer_partner.officetel is '公司联系电话';
comment on column ${iol_schema}.icms_customer_partner.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_partner.coreentcustid is '核心企业客户号';
comment on column ${iol_schema}.icms_customer_partner.qualifictionmaturity is '房地产资质证书有效期限';
comment on column ${iol_schema}.icms_customer_partner.certcountry is '证件国别';
comment on column ${iol_schema}.icms_customer_partner.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_partner.realtyevaluateauthyear is '相关资质有效期';
comment on column ${iol_schema}.icms_customer_partner.isbancredit is '是否授信暂禁';
comment on column ${iol_schema}.icms_customer_partner.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_partner.projecttype is '合作项目类型';
comment on column ${iol_schema}.icms_customer_partner.userange is '共享范围';
comment on column ${iol_schema}.icms_customer_partner.managebrand is '经营品牌';
comment on column ${iol_schema}.icms_customer_partner.fictitiouscert is '法人代表证件编号';
comment on column ${iol_schema}.icms_customer_partner.landevalregistermaturity is '土地评估中介机构注册证书有效期';
comment on column ${iol_schema}.icms_customer_partner.houseevaluatornum is '注册房地产评估师人数';
comment on column ${iol_schema}.icms_customer_partner.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_partner.iscreditlimit is '是否授信暂禁';
comment on column ${iol_schema}.icms_customer_partner.cooporg is '合作机构';
comment on column ${iol_schema}.icms_customer_partner.accountorg is '账户机构';
comment on column ${iol_schema}.icms_customer_partner.completeflag is '完整性标识';
comment on column ${iol_schema}.icms_customer_partner.mostbusiness is '经营范围';
comment on column ${iol_schema}.icms_customer_partner.firstcooperationdate is '首次合作时间';
comment on column ${iol_schema}.icms_customer_partner.comholdtype is '控股类型';
comment on column ${iol_schema}.icms_customer_partner.assetsum is '资产总额';
comment on column ${iol_schema}.icms_customer_partner.evaluatedate is '企业评级日期';
comment on column ${iol_schema}.icms_customer_partner.compstartdate is '企业成立日期';
comment on column ${iol_schema}.icms_customer_partner.iscreditcust is '是否我行授信客户';
comment on column ${iol_schema}.icms_customer_partner.basaccflg is '基本存款账户是否在我行';
comment on column ${iol_schema}.icms_customer_partner.approvestatus is '流程审批状态';
comment on column ${iol_schema}.icms_customer_partner.registerdate is '注册时间';
comment on column ${iol_schema}.icms_customer_partner.familyadd is '家庭地址';
comment on column ${iol_schema}.icms_customer_partner.repaypersoncerttype is '相关还款责任人证件类型';
comment on column ${iol_schema}.icms_customer_partner.email is 'EMAIL';
comment on column ${iol_schema}.icms_customer_partner.businessincome is '营业收入（万元）';
comment on column ${iol_schema}.icms_customer_partner.creditlevel is '信用等级(内部)';
comment on column ${iol_schema}.icms_customer_partner.basaccno is '基本存款账户账号';
comment on column ${iol_schema}.icms_customer_partner.userangeorg is '适用机构范围编号';
comment on column ${iol_schema}.icms_customer_partner.maxcreditlimit is '最高合作额度';
comment on column ${iol_schema}.icms_customer_partner.registeradd is '注册地址';
comment on column ${iol_schema}.icms_customer_partner.registercapital is '注册资金';
comment on column ${iol_schema}.icms_customer_partner.authenticatelicensedate is '司法鉴定许可证发证日期';
comment on column ${iol_schema}.icms_customer_partner.partnertype is '合作方类型';
comment on column ${iol_schema}.icms_customer_partner.evaluateresult is '企业评级结果';
comment on column ${iol_schema}.icms_customer_partner.repaypersoncertid is '还款责任人证件号码';
comment on column ${iol_schema}.icms_customer_partner.repaypersonname is '还款责任人名称';
comment on column ${iol_schema}.icms_customer_partner.fusingoverdue is '熔断逾期率';
comment on column ${iol_schema}.icms_customer_partner.msgphone is '短信接收人手机号';
comment on column ${iol_schema}.icms_customer_partner.warnoverdue is '预警逾期率';
comment on column ${iol_schema}.icms_customer_partner.consumptionloanlimit is '消费类贷款额度';
comment on column ${iol_schema}.icms_customer_partner.guaranteelimit100p is '100%担保额度';
comment on column ${iol_schema}.icms_customer_partner.loanguaranteelimit5y is '5年期贷款担保额度';
comment on column ${iol_schema}.icms_customer_partner.totalguaranteelimit is '担保总额度';
comment on column ${iol_schema}.icms_customer_partner.guaranteeproportion is '';
comment on column ${iol_schema}.icms_customer_partner.maxguaranteeamount is '';
comment on column ${iol_schema}.icms_customer_partner.isguarantee is '';
comment on column ${iol_schema}.icms_customer_partner.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_partner.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_partner.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_partner.etl_timestamp is 'ETL处理时间戳';
