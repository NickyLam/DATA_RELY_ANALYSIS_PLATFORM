/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_partner_project_info
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
create table ${iol_schema}.icms_partner_project_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_partner_project_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_partner_project_info_op purge;
drop table ${iol_schema}.icms_partner_project_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_project_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_partner_project_info where 0=1;

create table ${iol_schema}.icms_partner_project_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_partner_project_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_partner_project_info_cl(
            projectno -- 合作项目编号
            ,partnerid -- 合作方编号
            ,buydate -- 买入时间
            ,selldate -- 卖出时间
            ,partnertype -- 合作方类型
            ,endreason -- 终止原因
            ,remark -- 备注
            ,updateuserid -- 更新人
            ,entrustsum -- 委托金额
            ,isuretype -- 保险种类
            ,insuredeadline -- 保险最长期限
            ,projectlimittype -- 项目额度类型是否有项目额度(代码：1-是2-否)
            ,startdate -- 项目起始日
            ,orglist -- 共享机构
            ,inputuserid -- 登记人
            ,partnertypesub -- 合作商类型
            ,gatheringid -- 收款账号
            ,fundmgraccname -- 资金监管账户名称
            ,prjintroducer -- 项目介绍人
            ,partnersumtype -- 合同是否可循环
            ,depositratelimit -- 开票保证金比例下限(%）
            ,prjaccorgname -- 开户机构名称
            ,agreementno -- 合作协议编号
            ,consignorcerttype -- 委托人证件类型
            ,propertyowner -- 经营物业产权人
            ,approvestatus -- 审批状态
            ,inputdate -- 登记日期
            ,consignorcertid -- 委托人证件号码
            ,relaprojectno -- 关联项目编号
            ,inputorgid -- 登记机构
            ,projectnamee -- 合作项目名称(英文)
            ,commissionratio -- 佣金比例
            ,creditlevel -- 等级评定
            ,corporgid -- 法人机构编号
            ,completeflag -- 完成标志Yes/No
            ,orgrange -- 适用机构范围
            ,coopbankorg -- 合作银行分支机构用户组
            ,contractno -- 合作协议
            ,isexception -- 是否例外额度
            ,projecttype -- 合作项目类型
            ,paiclupcapital -- 实收资本
            ,org -- 适用机构
            ,updatedate -- 更新日期
            ,prjaccorg -- 项目结算开户机构
            ,cooppattern -- 合作模式
            ,applytype -- 申请类型（新发生、续作）
            ,supervisorcom -- 监理公司
            ,projectnamec -- 合作项目名称(中文)合作项目名称
            ,vouchtype -- 主要担保方式
            ,oldcontractno -- 原协议编号
            ,agencyno -- 机构编号
            ,totalsum -- 业务最大敞口金额
            ,projectchannel -- 项目使用渠道
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,expirydate -- 项目到期日
            ,productlist -- 适用产品
            ,propertyaddress -- 经营物业地址
            ,currency -- 币种
            ,registercapital -- 注册资本
            ,guarantysum -- 单户担保贷款额度
            ,isbankrel -- 是否我行关联人
            ,impawnagreementinfo -- 经营权质押项目协议条款信息
            ,occurtype -- 发生类型
            ,depositid -- 存款账号
            ,assetbuyer -- 资产买方
            ,prjaccno -- 项目结算账号
            ,dealsum -- 买卖金额
            ,consignortype -- 委托人类型
            ,projectdescribe -- 项目描述
            ,updateorgid -- 更新机构
            ,consignorcountry -- 委托人国别
            ,guarantytype -- 担保方式
            ,guarantyduty -- 担保责任
            ,status -- 项目状态
            ,costprop -- 费率
            ,fundmgraccno -- 资金监管账户账号
            ,prjaccname -- 项目结算账号户名
            ,prjaccbank -- 项目结算开户银行
            ,consignorname -- 委托人名称
            ,coopterm -- 合作期限
            ,capitalratio -- 合作方资本金比例
            ,assetname -- 资产类型
            ,instruction -- 原因说明
            ,assetseller -- 资产卖方
            ,assetdealtype -- 资产买卖类型
            ,firstusesum -- 先期启用额度
            ,nominalsum -- 额度名义金额
            ,isloop -- 是否循环
            ,defaultfusing -- 违约熔断值
            ,defaultwarning -- 违约预警值
            ,isinvolve -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_partner_project_info_op(
            projectno -- 合作项目编号
            ,partnerid -- 合作方编号
            ,buydate -- 买入时间
            ,selldate -- 卖出时间
            ,partnertype -- 合作方类型
            ,endreason -- 终止原因
            ,remark -- 备注
            ,updateuserid -- 更新人
            ,entrustsum -- 委托金额
            ,isuretype -- 保险种类
            ,insuredeadline -- 保险最长期限
            ,projectlimittype -- 项目额度类型是否有项目额度(代码：1-是2-否)
            ,startdate -- 项目起始日
            ,orglist -- 共享机构
            ,inputuserid -- 登记人
            ,partnertypesub -- 合作商类型
            ,gatheringid -- 收款账号
            ,fundmgraccname -- 资金监管账户名称
            ,prjintroducer -- 项目介绍人
            ,partnersumtype -- 合同是否可循环
            ,depositratelimit -- 开票保证金比例下限(%）
            ,prjaccorgname -- 开户机构名称
            ,agreementno -- 合作协议编号
            ,consignorcerttype -- 委托人证件类型
            ,propertyowner -- 经营物业产权人
            ,approvestatus -- 审批状态
            ,inputdate -- 登记日期
            ,consignorcertid -- 委托人证件号码
            ,relaprojectno -- 关联项目编号
            ,inputorgid -- 登记机构
            ,projectnamee -- 合作项目名称(英文)
            ,commissionratio -- 佣金比例
            ,creditlevel -- 等级评定
            ,corporgid -- 法人机构编号
            ,completeflag -- 完成标志Yes/No
            ,orgrange -- 适用机构范围
            ,coopbankorg -- 合作银行分支机构用户组
            ,contractno -- 合作协议
            ,isexception -- 是否例外额度
            ,projecttype -- 合作项目类型
            ,paiclupcapital -- 实收资本
            ,org -- 适用机构
            ,updatedate -- 更新日期
            ,prjaccorg -- 项目结算开户机构
            ,cooppattern -- 合作模式
            ,applytype -- 申请类型（新发生、续作）
            ,supervisorcom -- 监理公司
            ,projectnamec -- 合作项目名称(中文)合作项目名称
            ,vouchtype -- 主要担保方式
            ,oldcontractno -- 原协议编号
            ,agencyno -- 机构编号
            ,totalsum -- 业务最大敞口金额
            ,projectchannel -- 项目使用渠道
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,expirydate -- 项目到期日
            ,productlist -- 适用产品
            ,propertyaddress -- 经营物业地址
            ,currency -- 币种
            ,registercapital -- 注册资本
            ,guarantysum -- 单户担保贷款额度
            ,isbankrel -- 是否我行关联人
            ,impawnagreementinfo -- 经营权质押项目协议条款信息
            ,occurtype -- 发生类型
            ,depositid -- 存款账号
            ,assetbuyer -- 资产买方
            ,prjaccno -- 项目结算账号
            ,dealsum -- 买卖金额
            ,consignortype -- 委托人类型
            ,projectdescribe -- 项目描述
            ,updateorgid -- 更新机构
            ,consignorcountry -- 委托人国别
            ,guarantytype -- 担保方式
            ,guarantyduty -- 担保责任
            ,status -- 项目状态
            ,costprop -- 费率
            ,fundmgraccno -- 资金监管账户账号
            ,prjaccname -- 项目结算账号户名
            ,prjaccbank -- 项目结算开户银行
            ,consignorname -- 委托人名称
            ,coopterm -- 合作期限
            ,capitalratio -- 合作方资本金比例
            ,assetname -- 资产类型
            ,instruction -- 原因说明
            ,assetseller -- 资产卖方
            ,assetdealtype -- 资产买卖类型
            ,firstusesum -- 先期启用额度
            ,nominalsum -- 额度名义金额
            ,isloop -- 是否循环
            ,defaultfusing -- 违约熔断值
            ,defaultwarning -- 违约预警值
            ,isinvolve -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.projectno, o.projectno) as projectno -- 合作项目编号
    ,nvl(n.partnerid, o.partnerid) as partnerid -- 合作方编号
    ,nvl(n.buydate, o.buydate) as buydate -- 买入时间
    ,nvl(n.selldate, o.selldate) as selldate -- 卖出时间
    ,nvl(n.partnertype, o.partnertype) as partnertype -- 合作方类型
    ,nvl(n.endreason, o.endreason) as endreason -- 终止原因
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.entrustsum, o.entrustsum) as entrustsum -- 委托金额
    ,nvl(n.isuretype, o.isuretype) as isuretype -- 保险种类
    ,nvl(n.insuredeadline, o.insuredeadline) as insuredeadline -- 保险最长期限
    ,nvl(n.projectlimittype, o.projectlimittype) as projectlimittype -- 项目额度类型是否有项目额度(代码：1-是2-否)
    ,nvl(n.startdate, o.startdate) as startdate -- 项目起始日
    ,nvl(n.orglist, o.orglist) as orglist -- 共享机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.partnertypesub, o.partnertypesub) as partnertypesub -- 合作商类型
    ,nvl(n.gatheringid, o.gatheringid) as gatheringid -- 收款账号
    ,nvl(n.fundmgraccname, o.fundmgraccname) as fundmgraccname -- 资金监管账户名称
    ,nvl(n.prjintroducer, o.prjintroducer) as prjintroducer -- 项目介绍人
    ,nvl(n.partnersumtype, o.partnersumtype) as partnersumtype -- 合同是否可循环
    ,nvl(n.depositratelimit, o.depositratelimit) as depositratelimit -- 开票保证金比例下限(%）
    ,nvl(n.prjaccorgname, o.prjaccorgname) as prjaccorgname -- 开户机构名称
    ,nvl(n.agreementno, o.agreementno) as agreementno -- 合作协议编号
    ,nvl(n.consignorcerttype, o.consignorcerttype) as consignorcerttype -- 委托人证件类型
    ,nvl(n.propertyowner, o.propertyowner) as propertyowner -- 经营物业产权人
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.consignorcertid, o.consignorcertid) as consignorcertid -- 委托人证件号码
    ,nvl(n.relaprojectno, o.relaprojectno) as relaprojectno -- 关联项目编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.projectnamee, o.projectnamee) as projectnamee -- 合作项目名称(英文)
    ,nvl(n.commissionratio, o.commissionratio) as commissionratio -- 佣金比例
    ,nvl(n.creditlevel, o.creditlevel) as creditlevel -- 等级评定
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 完成标志Yes/No
    ,nvl(n.orgrange, o.orgrange) as orgrange -- 适用机构范围
    ,nvl(n.coopbankorg, o.coopbankorg) as coopbankorg -- 合作银行分支机构用户组
    ,nvl(n.contractno, o.contractno) as contractno -- 合作协议
    ,nvl(n.isexception, o.isexception) as isexception -- 是否例外额度
    ,nvl(n.projecttype, o.projecttype) as projecttype -- 合作项目类型
    ,nvl(n.paiclupcapital, o.paiclupcapital) as paiclupcapital -- 实收资本
    ,nvl(n.org, o.org) as org -- 适用机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.prjaccorg, o.prjaccorg) as prjaccorg -- 项目结算开户机构
    ,nvl(n.cooppattern, o.cooppattern) as cooppattern -- 合作模式
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型（新发生、续作）
    ,nvl(n.supervisorcom, o.supervisorcom) as supervisorcom -- 监理公司
    ,nvl(n.projectnamec, o.projectnamec) as projectnamec -- 合作项目名称(中文)合作项目名称
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主要担保方式
    ,nvl(n.oldcontractno, o.oldcontractno) as oldcontractno -- 原协议编号
    ,nvl(n.agencyno, o.agencyno) as agencyno -- 机构编号
    ,nvl(n.totalsum, o.totalsum) as totalsum -- 业务最大敞口金额
    ,nvl(n.projectchannel, o.projectchannel) as projectchannel -- 项目使用渠道
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 项目到期日
    ,nvl(n.productlist, o.productlist) as productlist -- 适用产品
    ,nvl(n.propertyaddress, o.propertyaddress) as propertyaddress -- 经营物业地址
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.registercapital, o.registercapital) as registercapital -- 注册资本
    ,nvl(n.guarantysum, o.guarantysum) as guarantysum -- 单户担保贷款额度
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否我行关联人
    ,nvl(n.impawnagreementinfo, o.impawnagreementinfo) as impawnagreementinfo -- 经营权质押项目协议条款信息
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生类型
    ,nvl(n.depositid, o.depositid) as depositid -- 存款账号
    ,nvl(n.assetbuyer, o.assetbuyer) as assetbuyer -- 资产买方
    ,nvl(n.prjaccno, o.prjaccno) as prjaccno -- 项目结算账号
    ,nvl(n.dealsum, o.dealsum) as dealsum -- 买卖金额
    ,nvl(n.consignortype, o.consignortype) as consignortype -- 委托人类型
    ,nvl(n.projectdescribe, o.projectdescribe) as projectdescribe -- 项目描述
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.consignorcountry, o.consignorcountry) as consignorcountry -- 委托人国别
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 担保方式
    ,nvl(n.guarantyduty, o.guarantyduty) as guarantyduty -- 担保责任
    ,nvl(n.status, o.status) as status -- 项目状态
    ,nvl(n.costprop, o.costprop) as costprop -- 费率
    ,nvl(n.fundmgraccno, o.fundmgraccno) as fundmgraccno -- 资金监管账户账号
    ,nvl(n.prjaccname, o.prjaccname) as prjaccname -- 项目结算账号户名
    ,nvl(n.prjaccbank, o.prjaccbank) as prjaccbank -- 项目结算开户银行
    ,nvl(n.consignorname, o.consignorname) as consignorname -- 委托人名称
    ,nvl(n.coopterm, o.coopterm) as coopterm -- 合作期限
    ,nvl(n.capitalratio, o.capitalratio) as capitalratio -- 合作方资本金比例
    ,nvl(n.assetname, o.assetname) as assetname -- 资产类型
    ,nvl(n.instruction, o.instruction) as instruction -- 原因说明
    ,nvl(n.assetseller, o.assetseller) as assetseller -- 资产卖方
    ,nvl(n.assetdealtype, o.assetdealtype) as assetdealtype -- 资产买卖类型
    ,nvl(n.firstusesum, o.firstusesum) as firstusesum -- 先期启用额度
    ,nvl(n.nominalsum, o.nominalsum) as nominalsum -- 额度名义金额
    ,nvl(n.isloop, o.isloop) as isloop -- 是否循环
    ,nvl(n.defaultfusing, o.defaultfusing) as defaultfusing -- 违约熔断值
    ,nvl(n.defaultwarning, o.defaultwarning) as defaultwarning -- 违约预警值
    ,nvl(n.isinvolve, o.isinvolve) as isinvolve -- 
    ,case when
            n.projectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.projectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.projectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_partner_project_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_partner_project_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.projectno = n.projectno
where (
        o.projectno is null
    )
    or (
        n.projectno is null
    )
    or (
        o.partnerid <> n.partnerid
        or o.buydate <> n.buydate
        or o.selldate <> n.selldate
        or o.partnertype <> n.partnertype
        or o.endreason <> n.endreason
        or o.remark <> n.remark
        or o.updateuserid <> n.updateuserid
        or o.entrustsum <> n.entrustsum
        or o.isuretype <> n.isuretype
        or o.insuredeadline <> n.insuredeadline
        or o.projectlimittype <> n.projectlimittype
        or o.startdate <> n.startdate
        or o.orglist <> n.orglist
        or o.inputuserid <> n.inputuserid
        or o.partnertypesub <> n.partnertypesub
        or o.gatheringid <> n.gatheringid
        or o.fundmgraccname <> n.fundmgraccname
        or o.prjintroducer <> n.prjintroducer
        or o.partnersumtype <> n.partnersumtype
        or o.depositratelimit <> n.depositratelimit
        or o.prjaccorgname <> n.prjaccorgname
        or o.agreementno <> n.agreementno
        or o.consignorcerttype <> n.consignorcerttype
        or o.propertyowner <> n.propertyowner
        or o.approvestatus <> n.approvestatus
        or o.inputdate <> n.inputdate
        or o.consignorcertid <> n.consignorcertid
        or o.relaprojectno <> n.relaprojectno
        or o.inputorgid <> n.inputorgid
        or o.projectnamee <> n.projectnamee
        or o.commissionratio <> n.commissionratio
        or o.creditlevel <> n.creditlevel
        or o.corporgid <> n.corporgid
        or o.completeflag <> n.completeflag
        or o.orgrange <> n.orgrange
        or o.coopbankorg <> n.coopbankorg
        or o.contractno <> n.contractno
        or o.isexception <> n.isexception
        or o.projecttype <> n.projecttype
        or o.paiclupcapital <> n.paiclupcapital
        or o.org <> n.org
        or o.updatedate <> n.updatedate
        or o.prjaccorg <> n.prjaccorg
        or o.cooppattern <> n.cooppattern
        or o.applytype <> n.applytype
        or o.supervisorcom <> n.supervisorcom
        or o.projectnamec <> n.projectnamec
        or o.vouchtype <> n.vouchtype
        or o.oldcontractno <> n.oldcontractno
        or o.agencyno <> n.agencyno
        or o.totalsum <> n.totalsum
        or o.projectchannel <> n.projectchannel
        or o.migtflag <> n.migtflag
        or o.expirydate <> n.expirydate
        or o.productlist <> n.productlist
        or o.propertyaddress <> n.propertyaddress
        or o.currency <> n.currency
        or o.registercapital <> n.registercapital
        or o.guarantysum <> n.guarantysum
        or o.isbankrel <> n.isbankrel
        or o.impawnagreementinfo <> n.impawnagreementinfo
        or o.occurtype <> n.occurtype
        or o.depositid <> n.depositid
        or o.assetbuyer <> n.assetbuyer
        or o.prjaccno <> n.prjaccno
        or o.dealsum <> n.dealsum
        or o.consignortype <> n.consignortype
        or o.projectdescribe <> n.projectdescribe
        or o.updateorgid <> n.updateorgid
        or o.consignorcountry <> n.consignorcountry
        or o.guarantytype <> n.guarantytype
        or o.guarantyduty <> n.guarantyduty
        or o.status <> n.status
        or o.costprop <> n.costprop
        or o.fundmgraccno <> n.fundmgraccno
        or o.prjaccname <> n.prjaccname
        or o.prjaccbank <> n.prjaccbank
        or o.consignorname <> n.consignorname
        or o.coopterm <> n.coopterm
        or o.capitalratio <> n.capitalratio
        or o.assetname <> n.assetname
        or o.instruction <> n.instruction
        or o.assetseller <> n.assetseller
        or o.assetdealtype <> n.assetdealtype
        or o.firstusesum <> n.firstusesum
        or o.nominalsum <> n.nominalsum
        or o.isloop <> n.isloop
        or o.defaultfusing <> n.defaultfusing
        or o.defaultwarning <> n.defaultwarning
        or o.isinvolve <> n.isinvolve
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_partner_project_info_cl(
            projectno -- 合作项目编号
            ,partnerid -- 合作方编号
            ,buydate -- 买入时间
            ,selldate -- 卖出时间
            ,partnertype -- 合作方类型
            ,endreason -- 终止原因
            ,remark -- 备注
            ,updateuserid -- 更新人
            ,entrustsum -- 委托金额
            ,isuretype -- 保险种类
            ,insuredeadline -- 保险最长期限
            ,projectlimittype -- 项目额度类型是否有项目额度(代码：1-是2-否)
            ,startdate -- 项目起始日
            ,orglist -- 共享机构
            ,inputuserid -- 登记人
            ,partnertypesub -- 合作商类型
            ,gatheringid -- 收款账号
            ,fundmgraccname -- 资金监管账户名称
            ,prjintroducer -- 项目介绍人
            ,partnersumtype -- 合同是否可循环
            ,depositratelimit -- 开票保证金比例下限(%）
            ,prjaccorgname -- 开户机构名称
            ,agreementno -- 合作协议编号
            ,consignorcerttype -- 委托人证件类型
            ,propertyowner -- 经营物业产权人
            ,approvestatus -- 审批状态
            ,inputdate -- 登记日期
            ,consignorcertid -- 委托人证件号码
            ,relaprojectno -- 关联项目编号
            ,inputorgid -- 登记机构
            ,projectnamee -- 合作项目名称(英文)
            ,commissionratio -- 佣金比例
            ,creditlevel -- 等级评定
            ,corporgid -- 法人机构编号
            ,completeflag -- 完成标志Yes/No
            ,orgrange -- 适用机构范围
            ,coopbankorg -- 合作银行分支机构用户组
            ,contractno -- 合作协议
            ,isexception -- 是否例外额度
            ,projecttype -- 合作项目类型
            ,paiclupcapital -- 实收资本
            ,org -- 适用机构
            ,updatedate -- 更新日期
            ,prjaccorg -- 项目结算开户机构
            ,cooppattern -- 合作模式
            ,applytype -- 申请类型（新发生、续作）
            ,supervisorcom -- 监理公司
            ,projectnamec -- 合作项目名称(中文)合作项目名称
            ,vouchtype -- 主要担保方式
            ,oldcontractno -- 原协议编号
            ,agencyno -- 机构编号
            ,totalsum -- 业务最大敞口金额
            ,projectchannel -- 项目使用渠道
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,expirydate -- 项目到期日
            ,productlist -- 适用产品
            ,propertyaddress -- 经营物业地址
            ,currency -- 币种
            ,registercapital -- 注册资本
            ,guarantysum -- 单户担保贷款额度
            ,isbankrel -- 是否我行关联人
            ,impawnagreementinfo -- 经营权质押项目协议条款信息
            ,occurtype -- 发生类型
            ,depositid -- 存款账号
            ,assetbuyer -- 资产买方
            ,prjaccno -- 项目结算账号
            ,dealsum -- 买卖金额
            ,consignortype -- 委托人类型
            ,projectdescribe -- 项目描述
            ,updateorgid -- 更新机构
            ,consignorcountry -- 委托人国别
            ,guarantytype -- 担保方式
            ,guarantyduty -- 担保责任
            ,status -- 项目状态
            ,costprop -- 费率
            ,fundmgraccno -- 资金监管账户账号
            ,prjaccname -- 项目结算账号户名
            ,prjaccbank -- 项目结算开户银行
            ,consignorname -- 委托人名称
            ,coopterm -- 合作期限
            ,capitalratio -- 合作方资本金比例
            ,assetname -- 资产类型
            ,instruction -- 原因说明
            ,assetseller -- 资产卖方
            ,assetdealtype -- 资产买卖类型
            ,firstusesum -- 先期启用额度
            ,nominalsum -- 额度名义金额
            ,isloop -- 是否循环
            ,defaultfusing -- 违约熔断值
            ,defaultwarning -- 违约预警值
            ,isinvolve -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_partner_project_info_op(
            projectno -- 合作项目编号
            ,partnerid -- 合作方编号
            ,buydate -- 买入时间
            ,selldate -- 卖出时间
            ,partnertype -- 合作方类型
            ,endreason -- 终止原因
            ,remark -- 备注
            ,updateuserid -- 更新人
            ,entrustsum -- 委托金额
            ,isuretype -- 保险种类
            ,insuredeadline -- 保险最长期限
            ,projectlimittype -- 项目额度类型是否有项目额度(代码：1-是2-否)
            ,startdate -- 项目起始日
            ,orglist -- 共享机构
            ,inputuserid -- 登记人
            ,partnertypesub -- 合作商类型
            ,gatheringid -- 收款账号
            ,fundmgraccname -- 资金监管账户名称
            ,prjintroducer -- 项目介绍人
            ,partnersumtype -- 合同是否可循环
            ,depositratelimit -- 开票保证金比例下限(%）
            ,prjaccorgname -- 开户机构名称
            ,agreementno -- 合作协议编号
            ,consignorcerttype -- 委托人证件类型
            ,propertyowner -- 经营物业产权人
            ,approvestatus -- 审批状态
            ,inputdate -- 登记日期
            ,consignorcertid -- 委托人证件号码
            ,relaprojectno -- 关联项目编号
            ,inputorgid -- 登记机构
            ,projectnamee -- 合作项目名称(英文)
            ,commissionratio -- 佣金比例
            ,creditlevel -- 等级评定
            ,corporgid -- 法人机构编号
            ,completeflag -- 完成标志Yes/No
            ,orgrange -- 适用机构范围
            ,coopbankorg -- 合作银行分支机构用户组
            ,contractno -- 合作协议
            ,isexception -- 是否例外额度
            ,projecttype -- 合作项目类型
            ,paiclupcapital -- 实收资本
            ,org -- 适用机构
            ,updatedate -- 更新日期
            ,prjaccorg -- 项目结算开户机构
            ,cooppattern -- 合作模式
            ,applytype -- 申请类型（新发生、续作）
            ,supervisorcom -- 监理公司
            ,projectnamec -- 合作项目名称(中文)合作项目名称
            ,vouchtype -- 主要担保方式
            ,oldcontractno -- 原协议编号
            ,agencyno -- 机构编号
            ,totalsum -- 业务最大敞口金额
            ,projectchannel -- 项目使用渠道
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,expirydate -- 项目到期日
            ,productlist -- 适用产品
            ,propertyaddress -- 经营物业地址
            ,currency -- 币种
            ,registercapital -- 注册资本
            ,guarantysum -- 单户担保贷款额度
            ,isbankrel -- 是否我行关联人
            ,impawnagreementinfo -- 经营权质押项目协议条款信息
            ,occurtype -- 发生类型
            ,depositid -- 存款账号
            ,assetbuyer -- 资产买方
            ,prjaccno -- 项目结算账号
            ,dealsum -- 买卖金额
            ,consignortype -- 委托人类型
            ,projectdescribe -- 项目描述
            ,updateorgid -- 更新机构
            ,consignorcountry -- 委托人国别
            ,guarantytype -- 担保方式
            ,guarantyduty -- 担保责任
            ,status -- 项目状态
            ,costprop -- 费率
            ,fundmgraccno -- 资金监管账户账号
            ,prjaccname -- 项目结算账号户名
            ,prjaccbank -- 项目结算开户银行
            ,consignorname -- 委托人名称
            ,coopterm -- 合作期限
            ,capitalratio -- 合作方资本金比例
            ,assetname -- 资产类型
            ,instruction -- 原因说明
            ,assetseller -- 资产卖方
            ,assetdealtype -- 资产买卖类型
            ,firstusesum -- 先期启用额度
            ,nominalsum -- 额度名义金额
            ,isloop -- 是否循环
            ,defaultfusing -- 违约熔断值
            ,defaultwarning -- 违约预警值
            ,isinvolve -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.projectno -- 合作项目编号
    ,o.partnerid -- 合作方编号
    ,o.buydate -- 买入时间
    ,o.selldate -- 卖出时间
    ,o.partnertype -- 合作方类型
    ,o.endreason -- 终止原因
    ,o.remark -- 备注
    ,o.updateuserid -- 更新人
    ,o.entrustsum -- 委托金额
    ,o.isuretype -- 保险种类
    ,o.insuredeadline -- 保险最长期限
    ,o.projectlimittype -- 项目额度类型是否有项目额度(代码：1-是2-否)
    ,o.startdate -- 项目起始日
    ,o.orglist -- 共享机构
    ,o.inputuserid -- 登记人
    ,o.partnertypesub -- 合作商类型
    ,o.gatheringid -- 收款账号
    ,o.fundmgraccname -- 资金监管账户名称
    ,o.prjintroducer -- 项目介绍人
    ,o.partnersumtype -- 合同是否可循环
    ,o.depositratelimit -- 开票保证金比例下限(%）
    ,o.prjaccorgname -- 开户机构名称
    ,o.agreementno -- 合作协议编号
    ,o.consignorcerttype -- 委托人证件类型
    ,o.propertyowner -- 经营物业产权人
    ,o.approvestatus -- 审批状态
    ,o.inputdate -- 登记日期
    ,o.consignorcertid -- 委托人证件号码
    ,o.relaprojectno -- 关联项目编号
    ,o.inputorgid -- 登记机构
    ,o.projectnamee -- 合作项目名称(英文)
    ,o.commissionratio -- 佣金比例
    ,o.creditlevel -- 等级评定
    ,o.corporgid -- 法人机构编号
    ,o.completeflag -- 完成标志Yes/No
    ,o.orgrange -- 适用机构范围
    ,o.coopbankorg -- 合作银行分支机构用户组
    ,o.contractno -- 合作协议
    ,o.isexception -- 是否例外额度
    ,o.projecttype -- 合作项目类型
    ,o.paiclupcapital -- 实收资本
    ,o.org -- 适用机构
    ,o.updatedate -- 更新日期
    ,o.prjaccorg -- 项目结算开户机构
    ,o.cooppattern -- 合作模式
    ,o.applytype -- 申请类型（新发生、续作）
    ,o.supervisorcom -- 监理公司
    ,o.projectnamec -- 合作项目名称(中文)合作项目名称
    ,o.vouchtype -- 主要担保方式
    ,o.oldcontractno -- 原协议编号
    ,o.agencyno -- 机构编号
    ,o.totalsum -- 业务最大敞口金额
    ,o.projectchannel -- 项目使用渠道
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.expirydate -- 项目到期日
    ,o.productlist -- 适用产品
    ,o.propertyaddress -- 经营物业地址
    ,o.currency -- 币种
    ,o.registercapital -- 注册资本
    ,o.guarantysum -- 单户担保贷款额度
    ,o.isbankrel -- 是否我行关联人
    ,o.impawnagreementinfo -- 经营权质押项目协议条款信息
    ,o.occurtype -- 发生类型
    ,o.depositid -- 存款账号
    ,o.assetbuyer -- 资产买方
    ,o.prjaccno -- 项目结算账号
    ,o.dealsum -- 买卖金额
    ,o.consignortype -- 委托人类型
    ,o.projectdescribe -- 项目描述
    ,o.updateorgid -- 更新机构
    ,o.consignorcountry -- 委托人国别
    ,o.guarantytype -- 担保方式
    ,o.guarantyduty -- 担保责任
    ,o.status -- 项目状态
    ,o.costprop -- 费率
    ,o.fundmgraccno -- 资金监管账户账号
    ,o.prjaccname -- 项目结算账号户名
    ,o.prjaccbank -- 项目结算开户银行
    ,o.consignorname -- 委托人名称
    ,o.coopterm -- 合作期限
    ,o.capitalratio -- 合作方资本金比例
    ,o.assetname -- 资产类型
    ,o.instruction -- 原因说明
    ,o.assetseller -- 资产卖方
    ,o.assetdealtype -- 资产买卖类型
    ,o.firstusesum -- 先期启用额度
    ,o.nominalsum -- 额度名义金额
    ,o.isloop -- 是否循环
    ,o.defaultfusing -- 违约熔断值
    ,o.defaultwarning -- 违约预警值
    ,o.isinvolve -- 
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
from ${iol_schema}.icms_partner_project_info_bk o
    left join ${iol_schema}.icms_partner_project_info_op n
        on
            o.projectno = n.projectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_partner_project_info_cl d
        on
            o.projectno = d.projectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_partner_project_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_partner_project_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_partner_project_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_partner_project_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_partner_project_info exchange partition p_${batch_date} with table ${iol_schema}.icms_partner_project_info_cl;
alter table ${iol_schema}.icms_partner_project_info exchange partition p_20991231 with table ${iol_schema}.icms_partner_project_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_partner_project_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_partner_project_info_op purge;
drop table ${iol_schema}.icms_partner_project_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_partner_project_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_partner_project_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
