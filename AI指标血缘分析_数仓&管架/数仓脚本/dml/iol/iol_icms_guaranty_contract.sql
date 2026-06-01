/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_guaranty_contract
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
create table ${iol_schema}.icms_guaranty_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_guaranty_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_guaranty_contract_op purge;
drop table ${iol_schema}.icms_guaranty_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_guaranty_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_guaranty_contract where 0=1;

create table ${iol_schema}.icms_guaranty_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_guaranty_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_guaranty_contract_cl(
            guarantyno -- 担保合同编号
            ,registationcode -- 注册国家/地区代码
            ,checkguarantymanb -- 核保人二）
            ,inputorgid -- 登记机构
            ,creditorgid -- 债权人机构代码
            ,partyblegalperson -- 借款人法定代表人
            ,signdate -- 协议签定日期
            ,checkguarantyman2 -- 核保人（二）
            ,iscustody -- 是否代保管
            ,currency3 -- 担保债务币种2
            ,begindate -- 合同生效日
            ,checkguarantydate -- 核保日期
            ,secondcreditcurrency -- 被授信币种2
            ,financeitem7 -- 债务权益比率（当期总负债／当期净资产）不高于
            ,reception -- 接待人姓名
            ,channelflag -- 渠道标志
            ,guarbalance -- 可用余额
            ,authostrdate -- 授权起始日
            ,guarantyorsum -- 保证人净资产
            ,pigeonholedate -- 归档日
            ,maincontractsum -- 主合同金额
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,totalcopies -- 合同总份数
            ,partybpostcode -- 借款人邮编
            ,shortorg -- 机构简称
            ,guarantyinfo -- 担保物概况
            ,firstcreditsum -- 被授信金额一
            ,contractsum1 -- 担保债务本金1
            ,creditorgname -- 债权人机构名称
            ,contractname -- 合同名称1
            ,guarantystyle -- 担保方式
            ,istranguaranty -- 是否包含反担保措施
            ,thirdcreditsum -- 被授信金额3
            ,quoteguarantyquotano -- 引入担保额度流水号
            ,partybfax -- 借款人传真
            ,guarantyphone -- 保证人电话
            ,ypguarantorid -- 押品系统保证人id
            ,enddate -- 合同到期日
            ,otherdescsribe -- 其它特别约定
            ,contractno1 -- 合同号1
            ,maincontractcurrency -- 主合同币种
            ,otherguarantyperiod2 -- 其他保证期间2
            ,partyaprincipal -- 贷款人负责人
            ,guarantyvalue -- 担保总金额
            ,industrytype -- 所属行业类型
            ,thirdcreditparty -- 被授信人3
            ,creditauthno -- 征信查询授权书编号
            ,begintime -- 担保起始日
            ,certtype -- 担保人证件类型
            ,guarterm -- 担保期限(月)
            ,econtracttype -- 电子合同类型
            ,firstcreditcurrency -- 被授信币种一
            ,printflag -- 追加担保合同打印标志
            ,othername -- 其他名称
            ,financeitem6 -- 负债率（当期总负债／当期总资产）不高于
            ,customerid -- 被担保人客户号
            ,contractname2 -- 合同名称2
            ,partybcerttype -- 借款人证件种类
            ,guarantycurrency -- 担保币种
            ,usesum -- 已担保金额
            ,endtime -- 担保到期日
            ,currency4 -- 担保债务币种3
            ,currency2 -- 合同币种2
            ,guarantyopinion -- 担保意见
            ,contractno2 -- 合同号2
            ,customerownership -- 客户所有制类型
            ,otherguarantyrange -- 其他担保范围
            ,textmaincontractno -- 主合同文本编号
            ,guarantyaddress -- 保证人地址
            ,isinuse -- 添加维护标志1正常2不维护
            ,inputdate -- 登记日期
            ,thirdcreditcurrency -- 被授信币种3
            ,partyacopies -- 甲方执合同份数
            ,quoteguarantyquota -- 是否占用担保额度
            ,enterprisescope -- 企业规模
            ,guarantyrange -- 担保范围
            ,obligeeid -- 权利人客户编号
            ,contractword2 -- 合同机构简称+编号类型2
            ,certid -- 担保人证件号码
            ,orgname -- 机构名称
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,residentflag -- 居民标志
            ,guarantorid -- 担保人编号
            ,guaranteeform -- 保证担保形式
            ,receptionduty -- 接待人职务
            ,firstcreditparty -- 被授信人一
            ,contractsum2 -- 合同本金2
            ,compensatetype -- 清偿处理方式
            ,partyaduty -- 贷款人负责人职务
            ,guartorcate -- 担保人类别
            ,bailratio -- 保证金比例
            ,otherguarantyperiod1 -- 其他保证期间1
            ,updateuserid -- 更新人
            ,guarantyfax -- 保证人传真
            ,partybname -- 借款人名称
            ,updateorgid -- 更新机构
            ,partyaphone -- 债权人电话
            ,issaveowner -- 是否直接向我行担保
            ,partybphone -- 借款人电话
            ,commondate -- 通用日期
            ,contractsum3 -- 担保债务金额
            ,ectempsaveflag -- 暂存标志
            ,transfercreditrange -- 被转贷款人范围
            ,partybcertid -- 借款人证件号码
            ,contractsum4 -- 担保债务金额3
            ,secondcreditsum -- 被授信金额2
            ,otherparties -- 其余各方当事人及有关登记部门
            ,checkguarantymana -- 核保人一）
            ,updatedate -- 更新日期
            ,partyaaddress -- 贷款人地址
            ,ecodepartmentcode -- 国民经济部门
            ,vouchtype -- 主担保方式
            ,preserialno -- 被拷贝的担保流水号
            ,partybduty -- 借款人法定代表人职务
            ,guarantorname -- 担保人名称
            ,loancardno -- 担保人贷款卡编号
            ,secondcreditparty -- 被授信人2
            ,otherpromise -- 约定其他事项
            ,notarizationflag -- 是否强制执行公证
            ,partybaddress -- 借款人地址
            ,contractword -- 合同机构简称+编号类型1
            ,guarantytype -- 一般担保合同、最高额担保合同
            ,guarantystatus -- 担保合同状态
            ,inputuserid -- 登记人
            ,guarantyperiod -- 保证期间
            ,newregioncode -- 注册地行政区划代码
            ,creditaggreement -- 额度协议流水号
            ,currency1 -- 担保债务币种1
            ,guarantytype2 -- 担保类型分类
            ,corporgid -- 法人机构编号
            ,obligeename -- 权利人名称
            ,partyafax -- 贷款人传真
            ,textcontractno -- 文本合同编号
            ,maincontractname -- 主合同名称
            ,remark -- 备注
            ,customerriskactualrate -- 客户风险实际抵质押率
            ,approvalandpledgerate -- 审批抵质押率
            ,maximumguarability -- 保证人保证能力上限
            ,isguarantyplatformloan -- 是否政府性融资担保公司保证（1-是，2-否）
            ,isbackguaranty -- 是否反担保
            ,clno -- 
            ,mortgagereceiptno -- 
            ,encumbranceno -- 
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,netasset -- 保证人净资产
            ,netassetcurrency -- 保证人净资产币种
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,letterno -- 保函编号/备用信用证编号
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别/开证国别
            ,lettersum -- 保函金额/备用信用证金额
            ,lettercurrency -- 保函币种/备用信用证币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_guaranty_contract_op(
            guarantyno -- 担保合同编号
            ,registationcode -- 注册国家/地区代码
            ,checkguarantymanb -- 核保人二）
            ,inputorgid -- 登记机构
            ,creditorgid -- 债权人机构代码
            ,partyblegalperson -- 借款人法定代表人
            ,signdate -- 协议签定日期
            ,checkguarantyman2 -- 核保人（二）
            ,iscustody -- 是否代保管
            ,currency3 -- 担保债务币种2
            ,begindate -- 合同生效日
            ,checkguarantydate -- 核保日期
            ,secondcreditcurrency -- 被授信币种2
            ,financeitem7 -- 债务权益比率（当期总负债／当期净资产）不高于
            ,reception -- 接待人姓名
            ,channelflag -- 渠道标志
            ,guarbalance -- 可用余额
            ,authostrdate -- 授权起始日
            ,guarantyorsum -- 保证人净资产
            ,pigeonholedate -- 归档日
            ,maincontractsum -- 主合同金额
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,totalcopies -- 合同总份数
            ,partybpostcode -- 借款人邮编
            ,shortorg -- 机构简称
            ,guarantyinfo -- 担保物概况
            ,firstcreditsum -- 被授信金额一
            ,contractsum1 -- 担保债务本金1
            ,creditorgname -- 债权人机构名称
            ,contractname -- 合同名称1
            ,guarantystyle -- 担保方式
            ,istranguaranty -- 是否包含反担保措施
            ,thirdcreditsum -- 被授信金额3
            ,quoteguarantyquotano -- 引入担保额度流水号
            ,partybfax -- 借款人传真
            ,guarantyphone -- 保证人电话
            ,ypguarantorid -- 押品系统保证人id
            ,enddate -- 合同到期日
            ,otherdescsribe -- 其它特别约定
            ,contractno1 -- 合同号1
            ,maincontractcurrency -- 主合同币种
            ,otherguarantyperiod2 -- 其他保证期间2
            ,partyaprincipal -- 贷款人负责人
            ,guarantyvalue -- 担保总金额
            ,industrytype -- 所属行业类型
            ,thirdcreditparty -- 被授信人3
            ,creditauthno -- 征信查询授权书编号
            ,begintime -- 担保起始日
            ,certtype -- 担保人证件类型
            ,guarterm -- 担保期限(月)
            ,econtracttype -- 电子合同类型
            ,firstcreditcurrency -- 被授信币种一
            ,printflag -- 追加担保合同打印标志
            ,othername -- 其他名称
            ,financeitem6 -- 负债率（当期总负债／当期总资产）不高于
            ,customerid -- 被担保人客户号
            ,contractname2 -- 合同名称2
            ,partybcerttype -- 借款人证件种类
            ,guarantycurrency -- 担保币种
            ,usesum -- 已担保金额
            ,endtime -- 担保到期日
            ,currency4 -- 担保债务币种3
            ,currency2 -- 合同币种2
            ,guarantyopinion -- 担保意见
            ,contractno2 -- 合同号2
            ,customerownership -- 客户所有制类型
            ,otherguarantyrange -- 其他担保范围
            ,textmaincontractno -- 主合同文本编号
            ,guarantyaddress -- 保证人地址
            ,isinuse -- 添加维护标志1正常2不维护
            ,inputdate -- 登记日期
            ,thirdcreditcurrency -- 被授信币种3
            ,partyacopies -- 甲方执合同份数
            ,quoteguarantyquota -- 是否占用担保额度
            ,enterprisescope -- 企业规模
            ,guarantyrange -- 担保范围
            ,obligeeid -- 权利人客户编号
            ,contractword2 -- 合同机构简称+编号类型2
            ,certid -- 担保人证件号码
            ,orgname -- 机构名称
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,residentflag -- 居民标志
            ,guarantorid -- 担保人编号
            ,guaranteeform -- 保证担保形式
            ,receptionduty -- 接待人职务
            ,firstcreditparty -- 被授信人一
            ,contractsum2 -- 合同本金2
            ,compensatetype -- 清偿处理方式
            ,partyaduty -- 贷款人负责人职务
            ,guartorcate -- 担保人类别
            ,bailratio -- 保证金比例
            ,otherguarantyperiod1 -- 其他保证期间1
            ,updateuserid -- 更新人
            ,guarantyfax -- 保证人传真
            ,partybname -- 借款人名称
            ,updateorgid -- 更新机构
            ,partyaphone -- 债权人电话
            ,issaveowner -- 是否直接向我行担保
            ,partybphone -- 借款人电话
            ,commondate -- 通用日期
            ,contractsum3 -- 担保债务金额
            ,ectempsaveflag -- 暂存标志
            ,transfercreditrange -- 被转贷款人范围
            ,partybcertid -- 借款人证件号码
            ,contractsum4 -- 担保债务金额3
            ,secondcreditsum -- 被授信金额2
            ,otherparties -- 其余各方当事人及有关登记部门
            ,checkguarantymana -- 核保人一）
            ,updatedate -- 更新日期
            ,partyaaddress -- 贷款人地址
            ,ecodepartmentcode -- 国民经济部门
            ,vouchtype -- 主担保方式
            ,preserialno -- 被拷贝的担保流水号
            ,partybduty -- 借款人法定代表人职务
            ,guarantorname -- 担保人名称
            ,loancardno -- 担保人贷款卡编号
            ,secondcreditparty -- 被授信人2
            ,otherpromise -- 约定其他事项
            ,notarizationflag -- 是否强制执行公证
            ,partybaddress -- 借款人地址
            ,contractword -- 合同机构简称+编号类型1
            ,guarantytype -- 一般担保合同、最高额担保合同
            ,guarantystatus -- 担保合同状态
            ,inputuserid -- 登记人
            ,guarantyperiod -- 保证期间
            ,newregioncode -- 注册地行政区划代码
            ,creditaggreement -- 额度协议流水号
            ,currency1 -- 担保债务币种1
            ,guarantytype2 -- 担保类型分类
            ,corporgid -- 法人机构编号
            ,obligeename -- 权利人名称
            ,partyafax -- 贷款人传真
            ,textcontractno -- 文本合同编号
            ,maincontractname -- 主合同名称
            ,remark -- 备注
            ,customerriskactualrate -- 客户风险实际抵质押率
            ,approvalandpledgerate -- 审批抵质押率
            ,maximumguarability -- 保证人保证能力上限
            ,isguarantyplatformloan -- 是否政府性融资担保公司保证（1-是，2-否）
            ,isbackguaranty -- 是否反担保
            ,clno -- 
            ,mortgagereceiptno -- 
            ,encumbranceno -- 
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,netasset -- 保证人净资产
            ,netassetcurrency -- 保证人净资产币种
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,letterno -- 保函编号/备用信用证编号
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别/开证国别
            ,lettersum -- 保函金额/备用信用证金额
            ,lettercurrency -- 保函币种/备用信用证币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.guarantyno, o.guarantyno) as guarantyno -- 担保合同编号
    ,nvl(n.registationcode, o.registationcode) as registationcode -- 注册国家/地区代码
    ,nvl(n.checkguarantymanb, o.checkguarantymanb) as checkguarantymanb -- 核保人二）
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.creditorgid, o.creditorgid) as creditorgid -- 债权人机构代码
    ,nvl(n.partyblegalperson, o.partyblegalperson) as partyblegalperson -- 借款人法定代表人
    ,nvl(n.signdate, o.signdate) as signdate -- 协议签定日期
    ,nvl(n.checkguarantyman2, o.checkguarantyman2) as checkguarantyman2 -- 核保人（二）
    ,nvl(n.iscustody, o.iscustody) as iscustody -- 是否代保管
    ,nvl(n.currency3, o.currency3) as currency3 -- 担保债务币种2
    ,nvl(n.begindate, o.begindate) as begindate -- 合同生效日
    ,nvl(n.checkguarantydate, o.checkguarantydate) as checkguarantydate -- 核保日期
    ,nvl(n.secondcreditcurrency, o.secondcreditcurrency) as secondcreditcurrency -- 被授信币种2
    ,nvl(n.financeitem7, o.financeitem7) as financeitem7 -- 债务权益比率（当期总负债／当期净资产）不高于
    ,nvl(n.reception, o.reception) as reception -- 接待人姓名
    ,nvl(n.channelflag, o.channelflag) as channelflag -- 渠道标志
    ,nvl(n.guarbalance, o.guarbalance) as guarbalance -- 可用余额
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权起始日
    ,nvl(n.guarantyorsum, o.guarantyorsum) as guarantyorsum -- 保证人净资产
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日
    ,nvl(n.maincontractsum, o.maincontractsum) as maincontractsum -- 主合同金额
    ,nvl(n.isquerycreditreport, o.isquerycreditreport) as isquerycreditreport -- 是否自动查询贷后报告
    ,nvl(n.totalcopies, o.totalcopies) as totalcopies -- 合同总份数
    ,nvl(n.partybpostcode, o.partybpostcode) as partybpostcode -- 借款人邮编
    ,nvl(n.shortorg, o.shortorg) as shortorg -- 机构简称
    ,nvl(n.guarantyinfo, o.guarantyinfo) as guarantyinfo -- 担保物概况
    ,nvl(n.firstcreditsum, o.firstcreditsum) as firstcreditsum -- 被授信金额一
    ,nvl(n.contractsum1, o.contractsum1) as contractsum1 -- 担保债务本金1
    ,nvl(n.creditorgname, o.creditorgname) as creditorgname -- 债权人机构名称
    ,nvl(n.contractname, o.contractname) as contractname -- 合同名称1
    ,nvl(n.guarantystyle, o.guarantystyle) as guarantystyle -- 担保方式
    ,nvl(n.istranguaranty, o.istranguaranty) as istranguaranty -- 是否包含反担保措施
    ,nvl(n.thirdcreditsum, o.thirdcreditsum) as thirdcreditsum -- 被授信金额3
    ,nvl(n.quoteguarantyquotano, o.quoteguarantyquotano) as quoteguarantyquotano -- 引入担保额度流水号
    ,nvl(n.partybfax, o.partybfax) as partybfax -- 借款人传真
    ,nvl(n.guarantyphone, o.guarantyphone) as guarantyphone -- 保证人电话
    ,nvl(n.ypguarantorid, o.ypguarantorid) as ypguarantorid -- 押品系统保证人id
    ,nvl(n.enddate, o.enddate) as enddate -- 合同到期日
    ,nvl(n.otherdescsribe, o.otherdescsribe) as otherdescsribe -- 其它特别约定
    ,nvl(n.contractno1, o.contractno1) as contractno1 -- 合同号1
    ,nvl(n.maincontractcurrency, o.maincontractcurrency) as maincontractcurrency -- 主合同币种
    ,nvl(n.otherguarantyperiod2, o.otherguarantyperiod2) as otherguarantyperiod2 -- 其他保证期间2
    ,nvl(n.partyaprincipal, o.partyaprincipal) as partyaprincipal -- 贷款人负责人
    ,nvl(n.guarantyvalue, o.guarantyvalue) as guarantyvalue -- 担保总金额
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 所属行业类型
    ,nvl(n.thirdcreditparty, o.thirdcreditparty) as thirdcreditparty -- 被授信人3
    ,nvl(n.creditauthno, o.creditauthno) as creditauthno -- 征信查询授权书编号
    ,nvl(n.begintime, o.begintime) as begintime -- 担保起始日
    ,nvl(n.certtype, o.certtype) as certtype -- 担保人证件类型
    ,nvl(n.guarterm, o.guarterm) as guarterm -- 担保期限(月)
    ,nvl(n.econtracttype, o.econtracttype) as econtracttype -- 电子合同类型
    ,nvl(n.firstcreditcurrency, o.firstcreditcurrency) as firstcreditcurrency -- 被授信币种一
    ,nvl(n.printflag, o.printflag) as printflag -- 追加担保合同打印标志
    ,nvl(n.othername, o.othername) as othername -- 其他名称
    ,nvl(n.financeitem6, o.financeitem6) as financeitem6 -- 负债率（当期总负债／当期总资产）不高于
    ,nvl(n.customerid, o.customerid) as customerid -- 被担保人客户号
    ,nvl(n.contractname2, o.contractname2) as contractname2 -- 合同名称2
    ,nvl(n.partybcerttype, o.partybcerttype) as partybcerttype -- 借款人证件种类
    ,nvl(n.guarantycurrency, o.guarantycurrency) as guarantycurrency -- 担保币种
    ,nvl(n.usesum, o.usesum) as usesum -- 已担保金额
    ,nvl(n.endtime, o.endtime) as endtime -- 担保到期日
    ,nvl(n.currency4, o.currency4) as currency4 -- 担保债务币种3
    ,nvl(n.currency2, o.currency2) as currency2 -- 合同币种2
    ,nvl(n.guarantyopinion, o.guarantyopinion) as guarantyopinion -- 担保意见
    ,nvl(n.contractno2, o.contractno2) as contractno2 -- 合同号2
    ,nvl(n.customerownership, o.customerownership) as customerownership -- 客户所有制类型
    ,nvl(n.otherguarantyrange, o.otherguarantyrange) as otherguarantyrange -- 其他担保范围
    ,nvl(n.textmaincontractno, o.textmaincontractno) as textmaincontractno -- 主合同文本编号
    ,nvl(n.guarantyaddress, o.guarantyaddress) as guarantyaddress -- 保证人地址
    ,nvl(n.isinuse, o.isinuse) as isinuse -- 添加维护标志1正常2不维护
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.thirdcreditcurrency, o.thirdcreditcurrency) as thirdcreditcurrency -- 被授信币种3
    ,nvl(n.partyacopies, o.partyacopies) as partyacopies -- 甲方执合同份数
    ,nvl(n.quoteguarantyquota, o.quoteguarantyquota) as quoteguarantyquota -- 是否占用担保额度
    ,nvl(n.enterprisescope, o.enterprisescope) as enterprisescope -- 企业规模
    ,nvl(n.guarantyrange, o.guarantyrange) as guarantyrange -- 担保范围
    ,nvl(n.obligeeid, o.obligeeid) as obligeeid -- 权利人客户编号
    ,nvl(n.contractword2, o.contractword2) as contractword2 -- 合同机构简称+编号类型2
    ,nvl(n.certid, o.certid) as certid -- 担保人证件号码
    ,nvl(n.orgname, o.orgname) as orgname -- 机构名称
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.residentflag, o.residentflag) as residentflag -- 居民标志
    ,nvl(n.guarantorid, o.guarantorid) as guarantorid -- 担保人编号
    ,nvl(n.guaranteeform, o.guaranteeform) as guaranteeform -- 保证担保形式
    ,nvl(n.receptionduty, o.receptionduty) as receptionduty -- 接待人职务
    ,nvl(n.firstcreditparty, o.firstcreditparty) as firstcreditparty -- 被授信人一
    ,nvl(n.contractsum2, o.contractsum2) as contractsum2 -- 合同本金2
    ,nvl(n.compensatetype, o.compensatetype) as compensatetype -- 清偿处理方式
    ,nvl(n.partyaduty, o.partyaduty) as partyaduty -- 贷款人负责人职务
    ,nvl(n.guartorcate, o.guartorcate) as guartorcate -- 担保人类别
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例
    ,nvl(n.otherguarantyperiod1, o.otherguarantyperiod1) as otherguarantyperiod1 -- 其他保证期间1
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.guarantyfax, o.guarantyfax) as guarantyfax -- 保证人传真
    ,nvl(n.partybname, o.partybname) as partybname -- 借款人名称
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.partyaphone, o.partyaphone) as partyaphone -- 债权人电话
    ,nvl(n.issaveowner, o.issaveowner) as issaveowner -- 是否直接向我行担保
    ,nvl(n.partybphone, o.partybphone) as partybphone -- 借款人电话
    ,nvl(n.commondate, o.commondate) as commondate -- 通用日期
    ,nvl(n.contractsum3, o.contractsum3) as contractsum3 -- 担保债务金额
    ,nvl(n.ectempsaveflag, o.ectempsaveflag) as ectempsaveflag -- 暂存标志
    ,nvl(n.transfercreditrange, o.transfercreditrange) as transfercreditrange -- 被转贷款人范围
    ,nvl(n.partybcertid, o.partybcertid) as partybcertid -- 借款人证件号码
    ,nvl(n.contractsum4, o.contractsum4) as contractsum4 -- 担保债务金额3
    ,nvl(n.secondcreditsum, o.secondcreditsum) as secondcreditsum -- 被授信金额2
    ,nvl(n.otherparties, o.otherparties) as otherparties -- 其余各方当事人及有关登记部门
    ,nvl(n.checkguarantymana, o.checkguarantymana) as checkguarantymana -- 核保人一）
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.partyaaddress, o.partyaaddress) as partyaaddress -- 贷款人地址
    ,nvl(n.ecodepartmentcode, o.ecodepartmentcode) as ecodepartmentcode -- 国民经济部门
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主担保方式
    ,nvl(n.preserialno, o.preserialno) as preserialno -- 被拷贝的担保流水号
    ,nvl(n.partybduty, o.partybduty) as partybduty -- 借款人法定代表人职务
    ,nvl(n.guarantorname, o.guarantorname) as guarantorname -- 担保人名称
    ,nvl(n.loancardno, o.loancardno) as loancardno -- 担保人贷款卡编号
    ,nvl(n.secondcreditparty, o.secondcreditparty) as secondcreditparty -- 被授信人2
    ,nvl(n.otherpromise, o.otherpromise) as otherpromise -- 约定其他事项
    ,nvl(n.notarizationflag, o.notarizationflag) as notarizationflag -- 是否强制执行公证
    ,nvl(n.partybaddress, o.partybaddress) as partybaddress -- 借款人地址
    ,nvl(n.contractword, o.contractword) as contractword -- 合同机构简称+编号类型1
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 一般担保合同、最高额担保合同
    ,nvl(n.guarantystatus, o.guarantystatus) as guarantystatus -- 担保合同状态
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.guarantyperiod, o.guarantyperiod) as guarantyperiod -- 保证期间
    ,nvl(n.newregioncode, o.newregioncode) as newregioncode -- 注册地行政区划代码
    ,nvl(n.creditaggreement, o.creditaggreement) as creditaggreement -- 额度协议流水号
    ,nvl(n.currency1, o.currency1) as currency1 -- 担保债务币种1
    ,nvl(n.guarantytype2, o.guarantytype2) as guarantytype2 -- 担保类型分类
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.obligeename, o.obligeename) as obligeename -- 权利人名称
    ,nvl(n.partyafax, o.partyafax) as partyafax -- 贷款人传真
    ,nvl(n.textcontractno, o.textcontractno) as textcontractno -- 文本合同编号
    ,nvl(n.maincontractname, o.maincontractname) as maincontractname -- 主合同名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.customerriskactualrate, o.customerriskactualrate) as customerriskactualrate -- 客户风险实际抵质押率
    ,nvl(n.approvalandpledgerate, o.approvalandpledgerate) as approvalandpledgerate -- 审批抵质押率
    ,nvl(n.maximumguarability, o.maximumguarability) as maximumguarability -- 保证人保证能力上限
    ,nvl(n.isguarantyplatformloan, o.isguarantyplatformloan) as isguarantyplatformloan -- 是否政府性融资担保公司保证（1-是，2-否）
    ,nvl(n.isbackguaranty, o.isbackguaranty) as isbackguaranty -- 是否反担保
    ,nvl(n.clno, o.clno) as clno -- 
    ,nvl(n.mortgagereceiptno, o.mortgagereceiptno) as mortgagereceiptno -- 
    ,nvl(n.encumbranceno, o.encumbranceno) as encumbranceno -- 
    ,nvl(n.registcountryresult, o.registcountryresult) as registcountryresult -- 保证人注册地所在国家或地区外部评级结果
    ,nvl(n.outratingdate, o.outratingdate) as outratingdate -- 保证人外部评级日期
    ,nvl(n.outratingresult, o.outratingresult) as outratingresult -- 保证人外部评级结果
    ,nvl(n.inratingdate, o.inratingdate) as inratingdate -- 保证人内部评级日期
    ,nvl(n.inratingresult, o.inratingresult) as inratingresult -- 保证人内部评级结果
    ,nvl(n.guarcash, o.guarcash) as guarcash -- 担保公司保证金金额
    ,nvl(n.isstage, o.isstage) as isstage -- 是否阶段性担保
    ,nvl(n.insuranceno, o.insuranceno) as insuranceno -- 保证保险保单号码
    ,nvl(n.purpose, o.purpose) as purpose -- 保证目的
    ,nvl(n.independence, o.independence) as independence -- 保证人担保独立性
    ,nvl(n.netasset, o.netasset) as netasset -- 保证人净资产
    ,nvl(n.netassetcurrency, o.netassetcurrency) as netassetcurrency -- 保证人净资产币种
    ,nvl(n.orgtype, o.orgtype) as orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
    ,nvl(n.iscancel, o.iscancel) as iscancel -- 是否不可撤销
    ,nvl(n.letterno, o.letterno) as letterno -- 保函编号/备用信用证编号
    ,nvl(n.lettertype, o.lettertype) as lettertype -- 保函类型
    ,nvl(n.lettercontry, o.lettercontry) as lettercontry -- 证书开具国别/开证国别
    ,nvl(n.lettersum, o.lettersum) as lettersum -- 保函金额/备用信用证金额
    ,nvl(n.lettercurrency, o.lettercurrency) as lettercurrency -- 保函币种/备用信用证币种
    ,case when
            n.guarantyno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.guarantyno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.guarantyno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_guaranty_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_guaranty_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.guarantyno = n.guarantyno
where (
        o.guarantyno is null
    )
    or (
        n.guarantyno is null
    )
    or (
        o.registationcode <> n.registationcode
        or o.checkguarantymanb <> n.checkguarantymanb
        or o.inputorgid <> n.inputorgid
        or o.creditorgid <> n.creditorgid
        or o.partyblegalperson <> n.partyblegalperson
        or o.signdate <> n.signdate
        or o.checkguarantyman2 <> n.checkguarantyman2
        or o.iscustody <> n.iscustody
        or o.currency3 <> n.currency3
        or o.begindate <> n.begindate
        or o.checkguarantydate <> n.checkguarantydate
        or o.secondcreditcurrency <> n.secondcreditcurrency
        or o.financeitem7 <> n.financeitem7
        or o.reception <> n.reception
        or o.channelflag <> n.channelflag
        or o.guarbalance <> n.guarbalance
        or o.authostrdate <> n.authostrdate
        or o.guarantyorsum <> n.guarantyorsum
        or o.pigeonholedate <> n.pigeonholedate
        or o.maincontractsum <> n.maincontractsum
        or o.isquerycreditreport <> n.isquerycreditreport
        or o.totalcopies <> n.totalcopies
        or o.partybpostcode <> n.partybpostcode
        or o.shortorg <> n.shortorg
        or o.guarantyinfo <> n.guarantyinfo
        or o.firstcreditsum <> n.firstcreditsum
        or o.contractsum1 <> n.contractsum1
        or o.creditorgname <> n.creditorgname
        or o.contractname <> n.contractname
        or o.guarantystyle <> n.guarantystyle
        or o.istranguaranty <> n.istranguaranty
        or o.thirdcreditsum <> n.thirdcreditsum
        or o.quoteguarantyquotano <> n.quoteguarantyquotano
        or o.partybfax <> n.partybfax
        or o.guarantyphone <> n.guarantyphone
        or o.ypguarantorid <> n.ypguarantorid
        or o.enddate <> n.enddate
        or o.otherdescsribe <> n.otherdescsribe
        or o.contractno1 <> n.contractno1
        or o.maincontractcurrency <> n.maincontractcurrency
        or o.otherguarantyperiod2 <> n.otherguarantyperiod2
        or o.partyaprincipal <> n.partyaprincipal
        or o.guarantyvalue <> n.guarantyvalue
        or o.industrytype <> n.industrytype
        or o.thirdcreditparty <> n.thirdcreditparty
        or o.creditauthno <> n.creditauthno
        or o.begintime <> n.begintime
        or o.certtype <> n.certtype
        or o.guarterm <> n.guarterm
        or o.econtracttype <> n.econtracttype
        or o.firstcreditcurrency <> n.firstcreditcurrency
        or o.printflag <> n.printflag
        or o.othername <> n.othername
        or o.financeitem6 <> n.financeitem6
        or o.customerid <> n.customerid
        or o.contractname2 <> n.contractname2
        or o.partybcerttype <> n.partybcerttype
        or o.guarantycurrency <> n.guarantycurrency
        or o.usesum <> n.usesum
        or o.endtime <> n.endtime
        or o.currency4 <> n.currency4
        or o.currency2 <> n.currency2
        or o.guarantyopinion <> n.guarantyopinion
        or o.contractno2 <> n.contractno2
        or o.customerownership <> n.customerownership
        or o.otherguarantyrange <> n.otherguarantyrange
        or o.textmaincontractno <> n.textmaincontractno
        or o.guarantyaddress <> n.guarantyaddress
        or o.isinuse <> n.isinuse
        or o.inputdate <> n.inputdate
        or o.thirdcreditcurrency <> n.thirdcreditcurrency
        or o.partyacopies <> n.partyacopies
        or o.quoteguarantyquota <> n.quoteguarantyquota
        or o.enterprisescope <> n.enterprisescope
        or o.guarantyrange <> n.guarantyrange
        or o.obligeeid <> n.obligeeid
        or o.contractword2 <> n.contractword2
        or o.certid <> n.certid
        or o.orgname <> n.orgname
        or o.migtflag <> n.migtflag
        or o.residentflag <> n.residentflag
        or o.guarantorid <> n.guarantorid
        or o.guaranteeform <> n.guaranteeform
        or o.receptionduty <> n.receptionduty
        or o.firstcreditparty <> n.firstcreditparty
        or o.contractsum2 <> n.contractsum2
        or o.compensatetype <> n.compensatetype
        or o.partyaduty <> n.partyaduty
        or o.guartorcate <> n.guartorcate
        or o.bailratio <> n.bailratio
        or o.otherguarantyperiod1 <> n.otherguarantyperiod1
        or o.updateuserid <> n.updateuserid
        or o.guarantyfax <> n.guarantyfax
        or o.partybname <> n.partybname
        or o.updateorgid <> n.updateorgid
        or o.partyaphone <> n.partyaphone
        or o.issaveowner <> n.issaveowner
        or o.partybphone <> n.partybphone
        or o.commondate <> n.commondate
        or o.contractsum3 <> n.contractsum3
        or o.ectempsaveflag <> n.ectempsaveflag
        or o.transfercreditrange <> n.transfercreditrange
        or o.partybcertid <> n.partybcertid
        or o.contractsum4 <> n.contractsum4
        or o.secondcreditsum <> n.secondcreditsum
        or o.otherparties <> n.otherparties
        or o.checkguarantymana <> n.checkguarantymana
        or o.updatedate <> n.updatedate
        or o.partyaaddress <> n.partyaaddress
        or o.ecodepartmentcode <> n.ecodepartmentcode
        or o.vouchtype <> n.vouchtype
        or o.preserialno <> n.preserialno
        or o.partybduty <> n.partybduty
        or o.guarantorname <> n.guarantorname
        or o.loancardno <> n.loancardno
        or o.secondcreditparty <> n.secondcreditparty
        or o.otherpromise <> n.otherpromise
        or o.notarizationflag <> n.notarizationflag
        or o.partybaddress <> n.partybaddress
        or o.contractword <> n.contractword
        or o.guarantytype <> n.guarantytype
        or o.guarantystatus <> n.guarantystatus
        or o.inputuserid <> n.inputuserid
        or o.guarantyperiod <> n.guarantyperiod
        or o.newregioncode <> n.newregioncode
        or o.creditaggreement <> n.creditaggreement
        or o.currency1 <> n.currency1
        or o.guarantytype2 <> n.guarantytype2
        or o.corporgid <> n.corporgid
        or o.obligeename <> n.obligeename
        or o.partyafax <> n.partyafax
        or o.textcontractno <> n.textcontractno
        or o.maincontractname <> n.maincontractname
        or o.remark <> n.remark
        or o.customerriskactualrate <> n.customerriskactualrate
        or o.approvalandpledgerate <> n.approvalandpledgerate
        or o.maximumguarability <> n.maximumguarability
        or o.isguarantyplatformloan <> n.isguarantyplatformloan
        or o.isbackguaranty <> n.isbackguaranty
        or o.clno <> n.clno
        or o.mortgagereceiptno <> n.mortgagereceiptno
        or o.encumbranceno <> n.encumbranceno
        or o.registcountryresult <> n.registcountryresult
        or o.outratingdate <> n.outratingdate
        or o.outratingresult <> n.outratingresult
        or o.inratingdate <> n.inratingdate
        or o.inratingresult <> n.inratingresult
        or o.guarcash <> n.guarcash
        or o.isstage <> n.isstage
        or o.insuranceno <> n.insuranceno
        or o.purpose <> n.purpose
        or o.independence <> n.independence
        or o.netasset <> n.netasset
        or o.netassetcurrency <> n.netassetcurrency
        or o.orgtype <> n.orgtype
        or o.iscancel <> n.iscancel
        or o.letterno <> n.letterno
        or o.lettertype <> n.lettertype
        or o.lettercontry <> n.lettercontry
        or o.lettersum <> n.lettersum
        or o.lettercurrency <> n.lettercurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_guaranty_contract_cl(
            guarantyno -- 担保合同编号
            ,registationcode -- 注册国家/地区代码
            ,checkguarantymanb -- 核保人二）
            ,inputorgid -- 登记机构
            ,creditorgid -- 债权人机构代码
            ,partyblegalperson -- 借款人法定代表人
            ,signdate -- 协议签定日期
            ,checkguarantyman2 -- 核保人（二）
            ,iscustody -- 是否代保管
            ,currency3 -- 担保债务币种2
            ,begindate -- 合同生效日
            ,checkguarantydate -- 核保日期
            ,secondcreditcurrency -- 被授信币种2
            ,financeitem7 -- 债务权益比率（当期总负债／当期净资产）不高于
            ,reception -- 接待人姓名
            ,channelflag -- 渠道标志
            ,guarbalance -- 可用余额
            ,authostrdate -- 授权起始日
            ,guarantyorsum -- 保证人净资产
            ,pigeonholedate -- 归档日
            ,maincontractsum -- 主合同金额
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,totalcopies -- 合同总份数
            ,partybpostcode -- 借款人邮编
            ,shortorg -- 机构简称
            ,guarantyinfo -- 担保物概况
            ,firstcreditsum -- 被授信金额一
            ,contractsum1 -- 担保债务本金1
            ,creditorgname -- 债权人机构名称
            ,contractname -- 合同名称1
            ,guarantystyle -- 担保方式
            ,istranguaranty -- 是否包含反担保措施
            ,thirdcreditsum -- 被授信金额3
            ,quoteguarantyquotano -- 引入担保额度流水号
            ,partybfax -- 借款人传真
            ,guarantyphone -- 保证人电话
            ,ypguarantorid -- 押品系统保证人id
            ,enddate -- 合同到期日
            ,otherdescsribe -- 其它特别约定
            ,contractno1 -- 合同号1
            ,maincontractcurrency -- 主合同币种
            ,otherguarantyperiod2 -- 其他保证期间2
            ,partyaprincipal -- 贷款人负责人
            ,guarantyvalue -- 担保总金额
            ,industrytype -- 所属行业类型
            ,thirdcreditparty -- 被授信人3
            ,creditauthno -- 征信查询授权书编号
            ,begintime -- 担保起始日
            ,certtype -- 担保人证件类型
            ,guarterm -- 担保期限(月)
            ,econtracttype -- 电子合同类型
            ,firstcreditcurrency -- 被授信币种一
            ,printflag -- 追加担保合同打印标志
            ,othername -- 其他名称
            ,financeitem6 -- 负债率（当期总负债／当期总资产）不高于
            ,customerid -- 被担保人客户号
            ,contractname2 -- 合同名称2
            ,partybcerttype -- 借款人证件种类
            ,guarantycurrency -- 担保币种
            ,usesum -- 已担保金额
            ,endtime -- 担保到期日
            ,currency4 -- 担保债务币种3
            ,currency2 -- 合同币种2
            ,guarantyopinion -- 担保意见
            ,contractno2 -- 合同号2
            ,customerownership -- 客户所有制类型
            ,otherguarantyrange -- 其他担保范围
            ,textmaincontractno -- 主合同文本编号
            ,guarantyaddress -- 保证人地址
            ,isinuse -- 添加维护标志1正常2不维护
            ,inputdate -- 登记日期
            ,thirdcreditcurrency -- 被授信币种3
            ,partyacopies -- 甲方执合同份数
            ,quoteguarantyquota -- 是否占用担保额度
            ,enterprisescope -- 企业规模
            ,guarantyrange -- 担保范围
            ,obligeeid -- 权利人客户编号
            ,contractword2 -- 合同机构简称+编号类型2
            ,certid -- 担保人证件号码
            ,orgname -- 机构名称
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,residentflag -- 居民标志
            ,guarantorid -- 担保人编号
            ,guaranteeform -- 保证担保形式
            ,receptionduty -- 接待人职务
            ,firstcreditparty -- 被授信人一
            ,contractsum2 -- 合同本金2
            ,compensatetype -- 清偿处理方式
            ,partyaduty -- 贷款人负责人职务
            ,guartorcate -- 担保人类别
            ,bailratio -- 保证金比例
            ,otherguarantyperiod1 -- 其他保证期间1
            ,updateuserid -- 更新人
            ,guarantyfax -- 保证人传真
            ,partybname -- 借款人名称
            ,updateorgid -- 更新机构
            ,partyaphone -- 债权人电话
            ,issaveowner -- 是否直接向我行担保
            ,partybphone -- 借款人电话
            ,commondate -- 通用日期
            ,contractsum3 -- 担保债务金额
            ,ectempsaveflag -- 暂存标志
            ,transfercreditrange -- 被转贷款人范围
            ,partybcertid -- 借款人证件号码
            ,contractsum4 -- 担保债务金额3
            ,secondcreditsum -- 被授信金额2
            ,otherparties -- 其余各方当事人及有关登记部门
            ,checkguarantymana -- 核保人一）
            ,updatedate -- 更新日期
            ,partyaaddress -- 贷款人地址
            ,ecodepartmentcode -- 国民经济部门
            ,vouchtype -- 主担保方式
            ,preserialno -- 被拷贝的担保流水号
            ,partybduty -- 借款人法定代表人职务
            ,guarantorname -- 担保人名称
            ,loancardno -- 担保人贷款卡编号
            ,secondcreditparty -- 被授信人2
            ,otherpromise -- 约定其他事项
            ,notarizationflag -- 是否强制执行公证
            ,partybaddress -- 借款人地址
            ,contractword -- 合同机构简称+编号类型1
            ,guarantytype -- 一般担保合同、最高额担保合同
            ,guarantystatus -- 担保合同状态
            ,inputuserid -- 登记人
            ,guarantyperiod -- 保证期间
            ,newregioncode -- 注册地行政区划代码
            ,creditaggreement -- 额度协议流水号
            ,currency1 -- 担保债务币种1
            ,guarantytype2 -- 担保类型分类
            ,corporgid -- 法人机构编号
            ,obligeename -- 权利人名称
            ,partyafax -- 贷款人传真
            ,textcontractno -- 文本合同编号
            ,maincontractname -- 主合同名称
            ,remark -- 备注
            ,customerriskactualrate -- 客户风险实际抵质押率
            ,approvalandpledgerate -- 审批抵质押率
            ,maximumguarability -- 保证人保证能力上限
            ,isguarantyplatformloan -- 是否政府性融资担保公司保证（1-是，2-否）
            ,isbackguaranty -- 是否反担保
            ,clno -- 
            ,mortgagereceiptno -- 
            ,encumbranceno -- 
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,netasset -- 保证人净资产
            ,netassetcurrency -- 保证人净资产币种
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,letterno -- 保函编号/备用信用证编号
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别/开证国别
            ,lettersum -- 保函金额/备用信用证金额
            ,lettercurrency -- 保函币种/备用信用证币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_guaranty_contract_op(
            guarantyno -- 担保合同编号
            ,registationcode -- 注册国家/地区代码
            ,checkguarantymanb -- 核保人二）
            ,inputorgid -- 登记机构
            ,creditorgid -- 债权人机构代码
            ,partyblegalperson -- 借款人法定代表人
            ,signdate -- 协议签定日期
            ,checkguarantyman2 -- 核保人（二）
            ,iscustody -- 是否代保管
            ,currency3 -- 担保债务币种2
            ,begindate -- 合同生效日
            ,checkguarantydate -- 核保日期
            ,secondcreditcurrency -- 被授信币种2
            ,financeitem7 -- 债务权益比率（当期总负债／当期净资产）不高于
            ,reception -- 接待人姓名
            ,channelflag -- 渠道标志
            ,guarbalance -- 可用余额
            ,authostrdate -- 授权起始日
            ,guarantyorsum -- 保证人净资产
            ,pigeonholedate -- 归档日
            ,maincontractsum -- 主合同金额
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,totalcopies -- 合同总份数
            ,partybpostcode -- 借款人邮编
            ,shortorg -- 机构简称
            ,guarantyinfo -- 担保物概况
            ,firstcreditsum -- 被授信金额一
            ,contractsum1 -- 担保债务本金1
            ,creditorgname -- 债权人机构名称
            ,contractname -- 合同名称1
            ,guarantystyle -- 担保方式
            ,istranguaranty -- 是否包含反担保措施
            ,thirdcreditsum -- 被授信金额3
            ,quoteguarantyquotano -- 引入担保额度流水号
            ,partybfax -- 借款人传真
            ,guarantyphone -- 保证人电话
            ,ypguarantorid -- 押品系统保证人id
            ,enddate -- 合同到期日
            ,otherdescsribe -- 其它特别约定
            ,contractno1 -- 合同号1
            ,maincontractcurrency -- 主合同币种
            ,otherguarantyperiod2 -- 其他保证期间2
            ,partyaprincipal -- 贷款人负责人
            ,guarantyvalue -- 担保总金额
            ,industrytype -- 所属行业类型
            ,thirdcreditparty -- 被授信人3
            ,creditauthno -- 征信查询授权书编号
            ,begintime -- 担保起始日
            ,certtype -- 担保人证件类型
            ,guarterm -- 担保期限(月)
            ,econtracttype -- 电子合同类型
            ,firstcreditcurrency -- 被授信币种一
            ,printflag -- 追加担保合同打印标志
            ,othername -- 其他名称
            ,financeitem6 -- 负债率（当期总负债／当期总资产）不高于
            ,customerid -- 被担保人客户号
            ,contractname2 -- 合同名称2
            ,partybcerttype -- 借款人证件种类
            ,guarantycurrency -- 担保币种
            ,usesum -- 已担保金额
            ,endtime -- 担保到期日
            ,currency4 -- 担保债务币种3
            ,currency2 -- 合同币种2
            ,guarantyopinion -- 担保意见
            ,contractno2 -- 合同号2
            ,customerownership -- 客户所有制类型
            ,otherguarantyrange -- 其他担保范围
            ,textmaincontractno -- 主合同文本编号
            ,guarantyaddress -- 保证人地址
            ,isinuse -- 添加维护标志1正常2不维护
            ,inputdate -- 登记日期
            ,thirdcreditcurrency -- 被授信币种3
            ,partyacopies -- 甲方执合同份数
            ,quoteguarantyquota -- 是否占用担保额度
            ,enterprisescope -- 企业规模
            ,guarantyrange -- 担保范围
            ,obligeeid -- 权利人客户编号
            ,contractword2 -- 合同机构简称+编号类型2
            ,certid -- 担保人证件号码
            ,orgname -- 机构名称
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,residentflag -- 居民标志
            ,guarantorid -- 担保人编号
            ,guaranteeform -- 保证担保形式
            ,receptionduty -- 接待人职务
            ,firstcreditparty -- 被授信人一
            ,contractsum2 -- 合同本金2
            ,compensatetype -- 清偿处理方式
            ,partyaduty -- 贷款人负责人职务
            ,guartorcate -- 担保人类别
            ,bailratio -- 保证金比例
            ,otherguarantyperiod1 -- 其他保证期间1
            ,updateuserid -- 更新人
            ,guarantyfax -- 保证人传真
            ,partybname -- 借款人名称
            ,updateorgid -- 更新机构
            ,partyaphone -- 债权人电话
            ,issaveowner -- 是否直接向我行担保
            ,partybphone -- 借款人电话
            ,commondate -- 通用日期
            ,contractsum3 -- 担保债务金额
            ,ectempsaveflag -- 暂存标志
            ,transfercreditrange -- 被转贷款人范围
            ,partybcertid -- 借款人证件号码
            ,contractsum4 -- 担保债务金额3
            ,secondcreditsum -- 被授信金额2
            ,otherparties -- 其余各方当事人及有关登记部门
            ,checkguarantymana -- 核保人一）
            ,updatedate -- 更新日期
            ,partyaaddress -- 贷款人地址
            ,ecodepartmentcode -- 国民经济部门
            ,vouchtype -- 主担保方式
            ,preserialno -- 被拷贝的担保流水号
            ,partybduty -- 借款人法定代表人职务
            ,guarantorname -- 担保人名称
            ,loancardno -- 担保人贷款卡编号
            ,secondcreditparty -- 被授信人2
            ,otherpromise -- 约定其他事项
            ,notarizationflag -- 是否强制执行公证
            ,partybaddress -- 借款人地址
            ,contractword -- 合同机构简称+编号类型1
            ,guarantytype -- 一般担保合同、最高额担保合同
            ,guarantystatus -- 担保合同状态
            ,inputuserid -- 登记人
            ,guarantyperiod -- 保证期间
            ,newregioncode -- 注册地行政区划代码
            ,creditaggreement -- 额度协议流水号
            ,currency1 -- 担保债务币种1
            ,guarantytype2 -- 担保类型分类
            ,corporgid -- 法人机构编号
            ,obligeename -- 权利人名称
            ,partyafax -- 贷款人传真
            ,textcontractno -- 文本合同编号
            ,maincontractname -- 主合同名称
            ,remark -- 备注
            ,customerriskactualrate -- 客户风险实际抵质押率
            ,approvalandpledgerate -- 审批抵质押率
            ,maximumguarability -- 保证人保证能力上限
            ,isguarantyplatformloan -- 是否政府性融资担保公司保证（1-是，2-否）
            ,isbackguaranty -- 是否反担保
            ,clno -- 
            ,mortgagereceiptno -- 
            ,encumbranceno -- 
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,netasset -- 保证人净资产
            ,netassetcurrency -- 保证人净资产币种
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,letterno -- 保函编号/备用信用证编号
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别/开证国别
            ,lettersum -- 保函金额/备用信用证金额
            ,lettercurrency -- 保函币种/备用信用证币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.guarantyno -- 担保合同编号
    ,o.registationcode -- 注册国家/地区代码
    ,o.checkguarantymanb -- 核保人二）
    ,o.inputorgid -- 登记机构
    ,o.creditorgid -- 债权人机构代码
    ,o.partyblegalperson -- 借款人法定代表人
    ,o.signdate -- 协议签定日期
    ,o.checkguarantyman2 -- 核保人（二）
    ,o.iscustody -- 是否代保管
    ,o.currency3 -- 担保债务币种2
    ,o.begindate -- 合同生效日
    ,o.checkguarantydate -- 核保日期
    ,o.secondcreditcurrency -- 被授信币种2
    ,o.financeitem7 -- 债务权益比率（当期总负债／当期净资产）不高于
    ,o.reception -- 接待人姓名
    ,o.channelflag -- 渠道标志
    ,o.guarbalance -- 可用余额
    ,o.authostrdate -- 授权起始日
    ,o.guarantyorsum -- 保证人净资产
    ,o.pigeonholedate -- 归档日
    ,o.maincontractsum -- 主合同金额
    ,o.isquerycreditreport -- 是否自动查询贷后报告
    ,o.totalcopies -- 合同总份数
    ,o.partybpostcode -- 借款人邮编
    ,o.shortorg -- 机构简称
    ,o.guarantyinfo -- 担保物概况
    ,o.firstcreditsum -- 被授信金额一
    ,o.contractsum1 -- 担保债务本金1
    ,o.creditorgname -- 债权人机构名称
    ,o.contractname -- 合同名称1
    ,o.guarantystyle -- 担保方式
    ,o.istranguaranty -- 是否包含反担保措施
    ,o.thirdcreditsum -- 被授信金额3
    ,o.quoteguarantyquotano -- 引入担保额度流水号
    ,o.partybfax -- 借款人传真
    ,o.guarantyphone -- 保证人电话
    ,o.ypguarantorid -- 押品系统保证人id
    ,o.enddate -- 合同到期日
    ,o.otherdescsribe -- 其它特别约定
    ,o.contractno1 -- 合同号1
    ,o.maincontractcurrency -- 主合同币种
    ,o.otherguarantyperiod2 -- 其他保证期间2
    ,o.partyaprincipal -- 贷款人负责人
    ,o.guarantyvalue -- 担保总金额
    ,o.industrytype -- 所属行业类型
    ,o.thirdcreditparty -- 被授信人3
    ,o.creditauthno -- 征信查询授权书编号
    ,o.begintime -- 担保起始日
    ,o.certtype -- 担保人证件类型
    ,o.guarterm -- 担保期限(月)
    ,o.econtracttype -- 电子合同类型
    ,o.firstcreditcurrency -- 被授信币种一
    ,o.printflag -- 追加担保合同打印标志
    ,o.othername -- 其他名称
    ,o.financeitem6 -- 负债率（当期总负债／当期总资产）不高于
    ,o.customerid -- 被担保人客户号
    ,o.contractname2 -- 合同名称2
    ,o.partybcerttype -- 借款人证件种类
    ,o.guarantycurrency -- 担保币种
    ,o.usesum -- 已担保金额
    ,o.endtime -- 担保到期日
    ,o.currency4 -- 担保债务币种3
    ,o.currency2 -- 合同币种2
    ,o.guarantyopinion -- 担保意见
    ,o.contractno2 -- 合同号2
    ,o.customerownership -- 客户所有制类型
    ,o.otherguarantyrange -- 其他担保范围
    ,o.textmaincontractno -- 主合同文本编号
    ,o.guarantyaddress -- 保证人地址
    ,o.isinuse -- 添加维护标志1正常2不维护
    ,o.inputdate -- 登记日期
    ,o.thirdcreditcurrency -- 被授信币种3
    ,o.partyacopies -- 甲方执合同份数
    ,o.quoteguarantyquota -- 是否占用担保额度
    ,o.enterprisescope -- 企业规模
    ,o.guarantyrange -- 担保范围
    ,o.obligeeid -- 权利人客户编号
    ,o.contractword2 -- 合同机构简称+编号类型2
    ,o.certid -- 担保人证件号码
    ,o.orgname -- 机构名称
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.residentflag -- 居民标志
    ,o.guarantorid -- 担保人编号
    ,o.guaranteeform -- 保证担保形式
    ,o.receptionduty -- 接待人职务
    ,o.firstcreditparty -- 被授信人一
    ,o.contractsum2 -- 合同本金2
    ,o.compensatetype -- 清偿处理方式
    ,o.partyaduty -- 贷款人负责人职务
    ,o.guartorcate -- 担保人类别
    ,o.bailratio -- 保证金比例
    ,o.otherguarantyperiod1 -- 其他保证期间1
    ,o.updateuserid -- 更新人
    ,o.guarantyfax -- 保证人传真
    ,o.partybname -- 借款人名称
    ,o.updateorgid -- 更新机构
    ,o.partyaphone -- 债权人电话
    ,o.issaveowner -- 是否直接向我行担保
    ,o.partybphone -- 借款人电话
    ,o.commondate -- 通用日期
    ,o.contractsum3 -- 担保债务金额
    ,o.ectempsaveflag -- 暂存标志
    ,o.transfercreditrange -- 被转贷款人范围
    ,o.partybcertid -- 借款人证件号码
    ,o.contractsum4 -- 担保债务金额3
    ,o.secondcreditsum -- 被授信金额2
    ,o.otherparties -- 其余各方当事人及有关登记部门
    ,o.checkguarantymana -- 核保人一）
    ,o.updatedate -- 更新日期
    ,o.partyaaddress -- 贷款人地址
    ,o.ecodepartmentcode -- 国民经济部门
    ,o.vouchtype -- 主担保方式
    ,o.preserialno -- 被拷贝的担保流水号
    ,o.partybduty -- 借款人法定代表人职务
    ,o.guarantorname -- 担保人名称
    ,o.loancardno -- 担保人贷款卡编号
    ,o.secondcreditparty -- 被授信人2
    ,o.otherpromise -- 约定其他事项
    ,o.notarizationflag -- 是否强制执行公证
    ,o.partybaddress -- 借款人地址
    ,o.contractword -- 合同机构简称+编号类型1
    ,o.guarantytype -- 一般担保合同、最高额担保合同
    ,o.guarantystatus -- 担保合同状态
    ,o.inputuserid -- 登记人
    ,o.guarantyperiod -- 保证期间
    ,o.newregioncode -- 注册地行政区划代码
    ,o.creditaggreement -- 额度协议流水号
    ,o.currency1 -- 担保债务币种1
    ,o.guarantytype2 -- 担保类型分类
    ,o.corporgid -- 法人机构编号
    ,o.obligeename -- 权利人名称
    ,o.partyafax -- 贷款人传真
    ,o.textcontractno -- 文本合同编号
    ,o.maincontractname -- 主合同名称
    ,o.remark -- 备注
    ,o.customerriskactualrate -- 客户风险实际抵质押率
    ,o.approvalandpledgerate -- 审批抵质押率
    ,o.maximumguarability -- 保证人保证能力上限
    ,o.isguarantyplatformloan -- 是否政府性融资担保公司保证（1-是，2-否）
    ,o.isbackguaranty -- 是否反担保
    ,o.clno -- 
    ,o.mortgagereceiptno -- 
    ,o.encumbranceno -- 
    ,o.registcountryresult -- 保证人注册地所在国家或地区外部评级结果
    ,o.outratingdate -- 保证人外部评级日期
    ,o.outratingresult -- 保证人外部评级结果
    ,o.inratingdate -- 保证人内部评级日期
    ,o.inratingresult -- 保证人内部评级结果
    ,o.guarcash -- 担保公司保证金金额
    ,o.isstage -- 是否阶段性担保
    ,o.insuranceno -- 保证保险保单号码
    ,o.purpose -- 保证目的
    ,o.independence -- 保证人担保独立性
    ,o.netasset -- 保证人净资产
    ,o.netassetcurrency -- 保证人净资产币种
    ,o.orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
    ,o.iscancel -- 是否不可撤销
    ,o.letterno -- 保函编号/备用信用证编号
    ,o.lettertype -- 保函类型
    ,o.lettercontry -- 证书开具国别/开证国别
    ,o.lettersum -- 保函金额/备用信用证金额
    ,o.lettercurrency -- 保函币种/备用信用证币种
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
from ${iol_schema}.icms_guaranty_contract_bk o
    left join ${iol_schema}.icms_guaranty_contract_op n
        on
            o.guarantyno = n.guarantyno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_guaranty_contract_cl d
        on
            o.guarantyno = d.guarantyno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_guaranty_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_guaranty_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_guaranty_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_guaranty_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_guaranty_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_guaranty_contract_cl;
alter table ${iol_schema}.icms_guaranty_contract exchange partition p_20991231 with table ${iol_schema}.icms_guaranty_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_guaranty_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_guaranty_contract_op purge;
drop table ${iol_schema}.icms_guaranty_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_guaranty_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_guaranty_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
