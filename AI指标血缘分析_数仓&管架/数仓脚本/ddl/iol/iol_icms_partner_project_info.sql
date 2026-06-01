/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_partner_project_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_partner_project_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_partner_project_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_project_info(
    projectno varchar2(64) -- 合作项目编号
    ,partnerid varchar2(64) -- 合作方编号
    ,buydate date -- 买入时间
    ,selldate date -- 卖出时间
    ,partnertype varchar2(36) -- 合作方类型
    ,endreason varchar2(1000) -- 终止原因
    ,remark varchar2(1000) -- 备注
    ,updateuserid varchar2(64) -- 更新人
    ,entrustsum number(24,6) -- 委托金额
    ,isuretype varchar2(36) -- 保险种类
    ,insuredeadline varchar2(64) -- 保险最长期限
    ,projectlimittype varchar2(12) -- 项目额度类型是否有项目额度(代码：1-是2-否)
    ,startdate date -- 项目起始日
    ,orglist varchar2(4000) -- 共享机构
    ,inputuserid varchar2(64) -- 登记人
    ,partnertypesub varchar2(5) -- 合作商类型
    ,gatheringid varchar2(64) -- 收款账号
    ,fundmgraccname varchar2(120) -- 资金监管账户名称
    ,prjintroducer varchar2(200) -- 项目介绍人
    ,partnersumtype varchar2(10) -- 合同是否可循环
    ,depositratelimit number(24,6) -- 开票保证金比例下限(%）
    ,prjaccorgname varchar2(80) -- 开户机构名称
    ,agreementno varchar2(64) -- 合作协议编号
    ,consignorcerttype varchar2(36) -- 委托人证件类型
    ,propertyowner varchar2(64) -- 经营物业产权人
    ,approvestatus varchar2(64) -- 审批状态
    ,inputdate date -- 登记日期
    ,consignorcertid varchar2(32) -- 委托人证件号码
    ,relaprojectno varchar2(64) -- 关联项目编号
    ,inputorgid varchar2(64) -- 登记机构
    ,projectnamee varchar2(200) -- 合作项目名称(英文)
    ,commissionratio number(24,8) -- 佣金比例
    ,creditlevel varchar2(4) -- 等级评定
    ,corporgid varchar2(64) -- 法人机构编号
    ,completeflag varchar2(2) -- 完成标志Yes/No
    ,orgrange varchar2(4000) -- 适用机构范围
    ,coopbankorg varchar2(160) -- 合作银行分支机构用户组
    ,contractno varchar2(72) -- 合作协议
    ,isexception varchar2(10) -- 是否例外额度
    ,projecttype varchar2(36) -- 合作项目类型
    ,paiclupcapital number(24,6) -- 实收资本
    ,org varchar2(64) -- 适用机构
    ,updatedate date -- 更新日期
    ,prjaccorg varchar2(80) -- 项目结算开户机构
    ,cooppattern varchar2(40) -- 合作模式
    ,applytype varchar2(10) -- 申请类型（新发生、续作）
    ,supervisorcom varchar2(200) -- 监理公司
    ,projectnamec varchar2(200) -- 合作项目名称(中文)合作项目名称
    ,vouchtype varchar2(36) -- 主要担保方式
    ,oldcontractno varchar2(64) -- 原协议编号
    ,agencyno varchar2(64) -- 机构编号
    ,totalsum number(24,6) -- 业务最大敞口金额
    ,projectchannel varchar2(80) -- 项目使用渠道
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,expirydate date -- 项目到期日
    ,productlist varchar2(4000) -- 适用产品
    ,propertyaddress varchar2(1000) -- 经营物业地址
    ,currency varchar2(3) -- 币种
    ,registercapital number(24,6) -- 注册资本
    ,guarantysum varchar2(10) -- 单户担保贷款额度
    ,isbankrel varchar2(10) -- 是否我行关联人
    ,impawnagreementinfo varchar2(2000) -- 经营权质押项目协议条款信息
    ,occurtype varchar2(18) -- 发生类型
    ,depositid varchar2(32) -- 存款账号
    ,assetbuyer varchar2(64) -- 资产买方
    ,prjaccno varchar2(80) -- 项目结算账号
    ,dealsum number(24,6) -- 买卖金额
    ,consignortype varchar2(36) -- 委托人类型
    ,projectdescribe varchar2(4000) -- 项目描述
    ,updateorgid varchar2(64) -- 更新机构
    ,consignorcountry varchar2(36) -- 委托人国别
    ,guarantytype varchar2(10) -- 担保方式
    ,guarantyduty number(24,6) -- 担保责任
    ,status varchar2(36) -- 项目状态
    ,costprop number(10,6) -- 费率
    ,fundmgraccno varchar2(64) -- 资金监管账户账号
    ,prjaccname varchar2(200) -- 项目结算账号户名
    ,prjaccbank varchar2(200) -- 项目结算开户银行
    ,consignorname varchar2(160) -- 委托人名称
    ,coopterm number(22) -- 合作期限
    ,capitalratio number(24,8) -- 合作方资本金比例
    ,assetname varchar2(64) -- 资产类型
    ,instruction varchar2(1000) -- 原因说明
    ,assetseller varchar2(64) -- 资产卖方
    ,assetdealtype varchar2(64) -- 资产买卖类型
    ,firstusesum number(24,6) -- 先期启用额度
    ,nominalsum number(24,6) -- 额度名义金额
    ,isloop varchar2(3) -- 是否循环
    ,defaultfusing number(20,2) -- 违约熔断值
    ,defaultwarning number(20,2) -- 违约预警值
    ,isinvolve varchar2(1) -- 
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
grant select on ${iol_schema}.icms_partner_project_info to ${iml_schema};
grant select on ${iol_schema}.icms_partner_project_info to ${icl_schema};
grant select on ${iol_schema}.icms_partner_project_info to ${idl_schema};
grant select on ${iol_schema}.icms_partner_project_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_partner_project_info is '合作方项目基本信息合作方项目本信息';
comment on column ${iol_schema}.icms_partner_project_info.projectno is '合作项目编号';
comment on column ${iol_schema}.icms_partner_project_info.partnerid is '合作方编号';
comment on column ${iol_schema}.icms_partner_project_info.buydate is '买入时间';
comment on column ${iol_schema}.icms_partner_project_info.selldate is '卖出时间';
comment on column ${iol_schema}.icms_partner_project_info.partnertype is '合作方类型';
comment on column ${iol_schema}.icms_partner_project_info.endreason is '终止原因';
comment on column ${iol_schema}.icms_partner_project_info.remark is '备注';
comment on column ${iol_schema}.icms_partner_project_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_partner_project_info.entrustsum is '委托金额';
comment on column ${iol_schema}.icms_partner_project_info.isuretype is '保险种类';
comment on column ${iol_schema}.icms_partner_project_info.insuredeadline is '保险最长期限';
comment on column ${iol_schema}.icms_partner_project_info.projectlimittype is '项目额度类型是否有项目额度(代码：1-是2-否)';
comment on column ${iol_schema}.icms_partner_project_info.startdate is '项目起始日';
comment on column ${iol_schema}.icms_partner_project_info.orglist is '共享机构';
comment on column ${iol_schema}.icms_partner_project_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_partner_project_info.partnertypesub is '合作商类型';
comment on column ${iol_schema}.icms_partner_project_info.gatheringid is '收款账号';
comment on column ${iol_schema}.icms_partner_project_info.fundmgraccname is '资金监管账户名称';
comment on column ${iol_schema}.icms_partner_project_info.prjintroducer is '项目介绍人';
comment on column ${iol_schema}.icms_partner_project_info.partnersumtype is '合同是否可循环';
comment on column ${iol_schema}.icms_partner_project_info.depositratelimit is '开票保证金比例下限(%）';
comment on column ${iol_schema}.icms_partner_project_info.prjaccorgname is '开户机构名称';
comment on column ${iol_schema}.icms_partner_project_info.agreementno is '合作协议编号';
comment on column ${iol_schema}.icms_partner_project_info.consignorcerttype is '委托人证件类型';
comment on column ${iol_schema}.icms_partner_project_info.propertyowner is '经营物业产权人';
comment on column ${iol_schema}.icms_partner_project_info.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_partner_project_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_partner_project_info.consignorcertid is '委托人证件号码';
comment on column ${iol_schema}.icms_partner_project_info.relaprojectno is '关联项目编号';
comment on column ${iol_schema}.icms_partner_project_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_partner_project_info.projectnamee is '合作项目名称(英文)';
comment on column ${iol_schema}.icms_partner_project_info.commissionratio is '佣金比例';
comment on column ${iol_schema}.icms_partner_project_info.creditlevel is '等级评定';
comment on column ${iol_schema}.icms_partner_project_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_partner_project_info.completeflag is '完成标志Yes/No';
comment on column ${iol_schema}.icms_partner_project_info.orgrange is '适用机构范围';
comment on column ${iol_schema}.icms_partner_project_info.coopbankorg is '合作银行分支机构用户组';
comment on column ${iol_schema}.icms_partner_project_info.contractno is '合作协议';
comment on column ${iol_schema}.icms_partner_project_info.isexception is '是否例外额度';
comment on column ${iol_schema}.icms_partner_project_info.projecttype is '合作项目类型';
comment on column ${iol_schema}.icms_partner_project_info.paiclupcapital is '实收资本';
comment on column ${iol_schema}.icms_partner_project_info.org is '适用机构';
comment on column ${iol_schema}.icms_partner_project_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_partner_project_info.prjaccorg is '项目结算开户机构';
comment on column ${iol_schema}.icms_partner_project_info.cooppattern is '合作模式';
comment on column ${iol_schema}.icms_partner_project_info.applytype is '申请类型（新发生、续作）';
comment on column ${iol_schema}.icms_partner_project_info.supervisorcom is '监理公司';
comment on column ${iol_schema}.icms_partner_project_info.projectnamec is '合作项目名称(中文)合作项目名称';
comment on column ${iol_schema}.icms_partner_project_info.vouchtype is '主要担保方式';
comment on column ${iol_schema}.icms_partner_project_info.oldcontractno is '原协议编号';
comment on column ${iol_schema}.icms_partner_project_info.agencyno is '机构编号';
comment on column ${iol_schema}.icms_partner_project_info.totalsum is '业务最大敞口金额';
comment on column ${iol_schema}.icms_partner_project_info.projectchannel is '项目使用渠道';
comment on column ${iol_schema}.icms_partner_project_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_partner_project_info.expirydate is '项目到期日';
comment on column ${iol_schema}.icms_partner_project_info.productlist is '适用产品';
comment on column ${iol_schema}.icms_partner_project_info.propertyaddress is '经营物业地址';
comment on column ${iol_schema}.icms_partner_project_info.currency is '币种';
comment on column ${iol_schema}.icms_partner_project_info.registercapital is '注册资本';
comment on column ${iol_schema}.icms_partner_project_info.guarantysum is '单户担保贷款额度';
comment on column ${iol_schema}.icms_partner_project_info.isbankrel is '是否我行关联人';
comment on column ${iol_schema}.icms_partner_project_info.impawnagreementinfo is '经营权质押项目协议条款信息';
comment on column ${iol_schema}.icms_partner_project_info.occurtype is '发生类型';
comment on column ${iol_schema}.icms_partner_project_info.depositid is '存款账号';
comment on column ${iol_schema}.icms_partner_project_info.assetbuyer is '资产买方';
comment on column ${iol_schema}.icms_partner_project_info.prjaccno is '项目结算账号';
comment on column ${iol_schema}.icms_partner_project_info.dealsum is '买卖金额';
comment on column ${iol_schema}.icms_partner_project_info.consignortype is '委托人类型';
comment on column ${iol_schema}.icms_partner_project_info.projectdescribe is '项目描述';
comment on column ${iol_schema}.icms_partner_project_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_partner_project_info.consignorcountry is '委托人国别';
comment on column ${iol_schema}.icms_partner_project_info.guarantytype is '担保方式';
comment on column ${iol_schema}.icms_partner_project_info.guarantyduty is '担保责任';
comment on column ${iol_schema}.icms_partner_project_info.status is '项目状态';
comment on column ${iol_schema}.icms_partner_project_info.costprop is '费率';
comment on column ${iol_schema}.icms_partner_project_info.fundmgraccno is '资金监管账户账号';
comment on column ${iol_schema}.icms_partner_project_info.prjaccname is '项目结算账号户名';
comment on column ${iol_schema}.icms_partner_project_info.prjaccbank is '项目结算开户银行';
comment on column ${iol_schema}.icms_partner_project_info.consignorname is '委托人名称';
comment on column ${iol_schema}.icms_partner_project_info.coopterm is '合作期限';
comment on column ${iol_schema}.icms_partner_project_info.capitalratio is '合作方资本金比例';
comment on column ${iol_schema}.icms_partner_project_info.assetname is '资产类型';
comment on column ${iol_schema}.icms_partner_project_info.instruction is '原因说明';
comment on column ${iol_schema}.icms_partner_project_info.assetseller is '资产卖方';
comment on column ${iol_schema}.icms_partner_project_info.assetdealtype is '资产买卖类型';
comment on column ${iol_schema}.icms_partner_project_info.firstusesum is '先期启用额度';
comment on column ${iol_schema}.icms_partner_project_info.nominalsum is '额度名义金额';
comment on column ${iol_schema}.icms_partner_project_info.isloop is '是否循环';
comment on column ${iol_schema}.icms_partner_project_info.defaultfusing is '违约熔断值';
comment on column ${iol_schema}.icms_partner_project_info.defaultwarning is '违约预警值';
comment on column ${iol_schema}.icms_partner_project_info.isinvolve is '';
comment on column ${iol_schema}.icms_partner_project_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_partner_project_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_partner_project_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_partner_project_info.etl_timestamp is 'ETL处理时间戳';
