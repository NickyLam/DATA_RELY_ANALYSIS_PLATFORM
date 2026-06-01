/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_contract_ret1
CreateDate: 20250626
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);

begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM icms_business_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_business_contract');

  if v_var <> 0 then
    execute immediate 'alter table icms_business_contract drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_business_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_business_contract (
	serialno -- 合同编号
	,bapserialno -- 批复编号
	,relacontractno -- 关联合同编号
	,artificialno -- 文本合同编号
	,customerid -- 客户编号
	,customername -- 客户名称
	,businessflag -- 额度/业务标志
	,oldcontractno -- 关联的旧合同号
	,applytype -- 申请类型
	,occurtype -- 贷款发放类型
	,occurdate -- 签订日期
	,currency -- 额度/业务币种
	,businesssum -- 合同金额
	,putoutsum -- 实际放款金额
	,putoutdate -- 放款日期
	,baseproduct -- 基础产品(额度)基础产品
	,productid -- 产品编号
	,policyid -- 产品政策编号
	,policyversionid -- 产品政策版本编号
	,productclassify -- 产品所属大类
	,termmonth -- 期限(月)
	,termday -- 期限(天)
	,startdate -- 合同开始日期
	,maturity -- 合同到期日期
	,iscycle -- 是否循环(额度)是否循环
	,risktype -- 风险类型(额度)风险类型（一般、低风险）
	,islowrisk -- 是否低风险业务
	,isremotebusiness -- 是否异地业务
	,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
	,fixedrate -- 固定利率
	,baseratetype -- 基准利率类型
	,baserate -- 基准利率
	,ratefloattype -- 利率浮动方式
	,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
	,floatrange -- 浮动幅度
	,executerate -- 执行利率
	,vouchtype -- 主担保方式
	,haveadditionalvouch -- 有无追加担保方式
	,othervouchtype -- 其他担保方式
	,additioncommand -- 其他条件和要求
	,repaytype -- 还款方式码值为：repaytype
	,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
	,repaydate -- 指定还款日
	,settlementaccount -- 结算账号
	,paymenttype -- 支付方式
	,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
	,nationalindustrytype -- 贷款投向行业
	,intraindustrytype -- 行内行业投向
	,purpose -- 用途
	,reservesum -- 预留金额
	,balance -- 合同贷款余额
	,normalbalance -- 正常余额
	,overduebalance -- 逾期/垫款金额
	,dullbalance -- 呆滞余额
	,badbalance -- 呆账余额
	,innerinterestbalance -- 表内欠息余额
	,outerinterestbalance -- 表外欠息余额
	,capitalpenaltybalance -- 逾期罚息余额
	,interestpenaltybalance -- 复息余额
	,overduedays -- 贷款逾期天数
	,owninterestdays -- 欠息天数
	,graceperiod -- 贷款宽限期
	,cancelsum -- 核销本金
	,cancelinterest -- 核销利息
	,predictlostsum -- 预测损失金额
	,reducereservesum -- 计提准备金额
	,badconfirmdate -- 首次认定不良日期
	,classifyresult -- 贷款五级分类
	,classifydate -- 风险分类日期
	,status -- 合同状态
	,finishdate -- 终结日期
	,finishtype -- 终结类型
	,finishflag -- 结清标志
	,contracttype -- 合同类型合同类型(一般合同/虚拟合同)
	,offsheetflag -- 表内外标志
	,belongdept -- 所属条线BelongDept
	,completeflag -- 数据录入完整性标识
	,flowtype -- 流程类型
	,approvestatus -- 审批状态
	,clno -- 额度编号
	,cleffectstatus -- 额度续作状态
	,remark -- 备注
	,operateuserid -- 业务经办人编号
	,operateorgid -- 经办机构
	,operatedate -- 经办日期
	,inputuserid -- 登记人
	,inputorgid -- 登记机构
	,inputdate -- 登记日期
	,updateuserid -- 更新人
	,updateorgid -- 更新机构
	,updatedate -- 更新日期
	,reinforceflag -- 补充标志
	,corporgid -- 法人机构编号
	,payfrequencyunit -- 指定周期单位
	,payfrequency -- 指定周期
	,renewtermdate -- 展期前到期日
	,renewtotalsum -- 展期前金额
	,renewexecuteyearrate -- 展期前执行年利率
	,isbankrel -- 是否我行关联方标志
	,vouchtype3 -- 主要担保方式3
	,vouchtype2 -- 主要担保方式2
	,loanusetype -- 贷款用途
	,totalsum -- 额度敞口金额
	,outstndlmt -- 已占用额度
	,bailratio -- 保证金比例（%）
	,bailsum -- 保证金金额
	,totalbalance -- 敞口余额(元)
	,creditaggreement -- 额度协议流水号
	,vouchtypeinner -- 担保方式（内部口径）
	,executemonthrate -- 执行月利率
	,classifyresulteleven -- 风险分类结果（11级）
	,pigeonholedate -- 归档日期
	,freezeflag -- 冻结标志
	,rateadjustfrequency -- 利率调整周期
	,overduerate -- 逾期执行利率
	,overdueratefloattype -- 逾期利率浮动方式
	,overdueratefloatvalue -- 逾期利率浮动值
	,putoutorgid -- 出账机构编号(核心机构)
	,settlementaccountname -- 结算账户(还款账户)名
	,loanaccountno -- 入账账户
	,loanaccountname -- 贷款入账(收款账户)账户名
	,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
	,bailcurrency -- 保证金币种
	,bailaccount -- 保证金帐号
	,bailtransaccount -- 保证金转出账号
	,migtflag -- 迁移标志：crs rcr ilc upl
	,manageuserid -- 贷后管理人员
	,manageorgid -- 贷后管理机构
	,ispagercontract -- 是否签署纸质合同
	,isoccupycredit -- 是否占用他用额度
	,occupycreditbapserialno -- 他用额度批复流水号
	,occupycredittype -- 他用额度类型
	,remart -- 计量标记
	,creditauthno -- 征信授权影像流水号
	,isquerycreditreport -- 是否自动查询贷后报告
	,authostrdate -- 授权起始日
	,isonlinebusiness -- 是否线上业务：yes-是no/空-否
	,oldstatus -- 备份生效标志
	,oldcreditaggreement -- 使用授信协议号(备份额度合同流水号)
	,migtcustomerid -- 转换前客户号
	,migtbusinesstype -- 转换前产品ID
	,migtoldvalue -- 迁移数据-参数转换前字段值
	,contractnobeforeextend -- 展期前合同
	,pdgratio -- 手续费比率
	,pdgsum -- 手续费金额
	,templeteurl -- 同业模板页面路径
	,templeteno -- 同业模板编号
	,vouchflag -- 有无其他担保方式，HaveNot
	,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
	,advancedmanuflag -- 先进制造业标志（0-否，1-是）
	,cultureindustryflag -- 文化产业标志（0-否，1-是）
	,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
	,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
	,strategicemergingindustrytype -- 战略性新兴产业类型
	,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
	,effectdate -- 合同签订日期
	,statisticstotalbalance -- 统计用敞口余额
	,transformtimes -- 变更次数
	,belongitem -- 所属项下
	,useexposuretype -- 占用敞口类型(UseExposureType)
	,isgxtechent -- 高新技术企业标志
	,isscitechent -- 科技型企业
	,iskctechent -- 科创企业
	,isxxdquota -- 是否营销额度（新兴贷专用）
	,ispensionindustry -- 养老产业标识
	,ifseedloan -- 种业振兴贷款
	,ifcountyloan -- 县城区贷款
	,ifhighindustry -- 是否投向高技术产业
	,numbereconomytype -- 投向数字经济核心产业类型
	,riskapproveamout -- 风控审批可用金额
	,icmsapproveamout -- 信贷审批可用金额
	,ifcapproveamount -- 审批后额度合同金额（IFC专用）
	,ifcapprovebalance -- 数总审批可用金额（IFC专用）
	,issignedcontract -- 是否签订额度合同
	,whethertorestructuretheloan -- 是否重组贷款
	,bdserialno -- 借据号
	,renewstartdate -- 展期起始日
	,secondpayaccount -- 第二还款账号
	,merchordernum -- 订单号
	,applyno -- 房抵贷贷款申请编号
	,pclnominalamount -- 华兴易贷担保可用金额
	,pcloccupyamount -- 华兴易贷担保占用金额
	,comticketrecourseflag -- 商票保贴追索标识（0-否，1-是）
	,bizcontrwthrdisctpers -- 是否贴现人保证金账户（0-否，1-是）
	,subproductname -- 子产品名称
	,renewaltype -- 
	,start_dt -- 开始时间
	,end_dt -- 结束时间
	,id_mark -- 增删标志
	,etl_timestamp -- ETL处理时间戳
)
select
	serialno as serialno -- 合同编号
	,bapserialno as bapserialno -- 批复编号
	,relacontractno as relacontractno -- 关联合同编号
	,artificialno as artificialno -- 文本合同编号
	,customerid as customerid -- 客户编号
	,customername as customername -- 客户名称
	,businessflag as businessflag -- 额度/业务标志
	,oldcontractno as oldcontractno -- 关联的旧合同号
	,applytype as applytype -- 申请类型
	,occurtype as occurtype -- 贷款发放类型
	,occurdate as occurdate -- 签订日期
	,currency as currency -- 额度/业务币种
	,businesssum as businesssum -- 合同金额
	,putoutsum as putoutsum -- 实际放款金额
	,putoutdate as putoutdate -- 放款日期
	,baseproduct as baseproduct -- 基础产品(额度)基础产品
	,productid as productid -- 产品编号
	,policyid as policyid -- 产品政策编号
	,policyversionid as policyversionid -- 产品政策版本编号
	,productclassify as productclassify -- 产品所属大类
	,termmonth as termmonth -- 期限(月)
	,termday as termday -- 期限(天)
	,startdate as startdate -- 合同开始日期
	,maturity as maturity -- 合同到期日期
	,iscycle as iscycle -- 是否循环(额度)是否循环
	,risktype as risktype -- 风险类型(额度)风险类型（一般、低风险）
	,islowrisk as islowrisk -- 是否低风险业务
	,isremotebusiness as isremotebusiness -- 是否异地业务
	,ratemodel as ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
	,fixedrate as fixedrate -- 固定利率
	,baseratetype as baseratetype -- 基准利率类型
	,baserate as baserate -- 基准利率
	,ratefloattype as ratefloattype -- 利率浮动方式
	,rateadjusttype as rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
	,floatrange as floatrange -- 浮动幅度
	,executerate as executerate -- 执行利率
	,vouchtype as vouchtype -- 主担保方式
	,haveadditionalvouch as haveadditionalvouch -- 有无追加担保方式
	,othervouchtype as othervouchtype -- 其他担保方式
	,additioncommand as additioncommand -- 其他条件和要求
	,repaytype as repaytype -- 还款方式码值为：repaytype
	,repaycycle as repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
	,repaydate as repaydate -- 指定还款日
	,settlementaccount as settlementaccount -- 结算账号
	,paymenttype as paymenttype -- 支付方式
	,creditinvest as creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
	,nationalindustrytype as nationalindustrytype -- 贷款投向行业
	,intraindustrytype as intraindustrytype -- 行内行业投向
	,purpose as purpose -- 用途
	,reservesum as reservesum -- 预留金额
	,balance as balance -- 合同贷款余额
	,normalbalance as normalbalance -- 正常余额
	,overduebalance as overduebalance -- 逾期/垫款金额
	,dullbalance as dullbalance -- 呆滞余额
	,badbalance as badbalance -- 呆账余额
	,innerinterestbalance as innerinterestbalance -- 表内欠息余额
	,outerinterestbalance as outerinterestbalance -- 表外欠息余额
	,capitalpenaltybalance as capitalpenaltybalance -- 逾期罚息余额
	,interestpenaltybalance as interestpenaltybalance -- 复息余额
	,overduedays as overduedays -- 贷款逾期天数
	,owninterestdays as owninterestdays -- 欠息天数
	,graceperiod as graceperiod -- 贷款宽限期
	,cancelsum as cancelsum -- 核销本金
	,cancelinterest as cancelinterest -- 核销利息
	,predictlostsum as predictlostsum -- 预测损失金额
	,reducereservesum as reducereservesum -- 计提准备金额
	,badconfirmdate as badconfirmdate -- 首次认定不良日期
	,classifyresult as classifyresult -- 贷款五级分类
	,classifydate as classifydate -- 风险分类日期
	,status as status -- 合同状态
	,finishdate as finishdate -- 终结日期
	,finishtype as finishtype -- 终结类型
	,finishflag as finishflag -- 结清标志
	,contracttype as contracttype -- 合同类型合同类型(一般合同/虚拟合同)
	,offsheetflag as offsheetflag -- 表内外标志
	,belongdept as belongdept -- 所属条线BelongDept
	,completeflag as completeflag -- 数据录入完整性标识
	,flowtype as flowtype -- 流程类型
	,approvestatus as approvestatus -- 审批状态
	,clno as clno -- 额度编号
	,cleffectstatus as cleffectstatus -- 额度续作状态
	,remark as remark -- 备注
	,operateuserid as operateuserid -- 业务经办人编号
	,operateorgid as operateorgid -- 经办机构
	,operatedate as operatedate -- 经办日期
	,inputuserid as inputuserid -- 登记人
	,inputorgid as inputorgid -- 登记机构
	,inputdate as inputdate -- 登记日期
	,updateuserid as updateuserid -- 更新人
	,updateorgid as updateorgid -- 更新机构
	,updatedate as updatedate -- 更新日期
	,reinforceflag as reinforceflag -- 补充标志
	,corporgid as corporgid -- 法人机构编号
	,payfrequencyunit as payfrequencyunit -- 指定周期单位
	,payfrequency as payfrequency -- 指定周期
	,renewtermdate as renewtermdate -- 展期前到期日
	,renewtotalsum as renewtotalsum -- 展期前金额
	,renewexecuteyearrate as renewexecuteyearrate -- 展期前执行年利率
	,isbankrel as isbankrel -- 是否我行关联方标志
	,vouchtype3 as vouchtype3 -- 主要担保方式3
	,vouchtype2 as vouchtype2 -- 主要担保方式2
	,loanusetype as loanusetype -- 贷款用途
	,totalsum as totalsum -- 额度敞口金额
	,outstndlmt as outstndlmt -- 已占用额度
	,bailratio as bailratio -- 保证金比例（%）
	,bailsum as bailsum -- 保证金金额
	,totalbalance as totalbalance -- 敞口余额(元)
	,creditaggreement as creditaggreement -- 额度协议流水号
	,vouchtypeinner as vouchtypeinner -- 担保方式（内部口径）
	,executemonthrate as executemonthrate -- 执行月利率
	,classifyresulteleven as classifyresulteleven -- 风险分类结果（11级）
	,pigeonholedate as pigeonholedate -- 归档日期
	,freezeflag as freezeflag -- 冻结标志
	,rateadjustfrequency as rateadjustfrequency -- 利率调整周期
	,overduerate as overduerate -- 逾期执行利率
	,overdueratefloattype as overdueratefloattype -- 逾期利率浮动方式
	,overdueratefloatvalue as overdueratefloatvalue -- 逾期利率浮动值
	,putoutorgid as putoutorgid -- 出账机构编号(核心机构)
	,settlementaccountname as settlementaccountname -- 结算账户(还款账户)名
	,loanaccountno as loanaccountno -- 入账账户
	,loanaccountname as loanaccountname -- 贷款入账(收款账户)账户名
	,loanaccountorgid as loanaccountorgid -- 贷款入账(收款账户)账户开户机构
	,bailcurrency as bailcurrency -- 保证金币种
	,bailaccount as bailaccount -- 保证金帐号
	,bailtransaccount as bailtransaccount -- 保证金转出账号
	,migtflag as migtflag -- 迁移标志：crs rcr ilc upl
	,manageuserid as manageuserid -- 贷后管理人员
	,manageorgid as manageorgid -- 贷后管理机构
	,ispagercontract as ispagercontract -- 是否签署纸质合同
	,isoccupycredit as isoccupycredit -- 是否占用他用额度
	,occupycreditbapserialno as occupycreditbapserialno -- 他用额度批复流水号
	,occupycredittype as occupycredittype -- 他用额度类型
	,remart as remart -- 计量标记
	,creditauthno as creditauthno -- 征信授权影像流水号
	,isquerycreditreport as isquerycreditreport -- 是否自动查询贷后报告
	,authostrdate as authostrdate -- 授权起始日
	,isonlinebusiness as isonlinebusiness -- 是否线上业务：yes-是no/空-否
	,oldstatus as oldstatus -- 备份生效标志
	,oldcreditaggreement as oldcreditaggreement -- 使用授信协议号(备份额度合同流水号)
	,migtcustomerid as migtcustomerid -- 转换前客户号
	,migtbusinesstype as migtbusinesstype -- 转换前产品ID
	,migtoldvalue as migtoldvalue -- 迁移数据-参数转换前字段值
	,contractnobeforeextend as contractnobeforeextend -- 展期前合同
	,pdgratio as pdgratio -- 手续费比率
	,pdgsum as pdgsum -- 手续费金额
	,templeteurl as templeteurl -- 同业模板页面路径
	,templeteno as templeteno -- 同业模板编号
	,vouchflag as vouchflag -- 有无其他担保方式，HaveNot
	,ratefloatratioorbp as ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
	,advancedmanuflag as advancedmanuflag -- 先进制造业标志（0-否，1-是）
	,cultureindustryflag as cultureindustryflag -- 文化产业标志（0-否，1-是）
	,onlynewentflag as onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
	,onlynewsmallentflag as onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
	,strategicemergingindustrytype as strategicemergingindustrytype -- 战略性新兴产业类型
	,transformationandupgradeid as transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
	,effectdate as effectdate -- 合同签订日期
	,statisticstotalbalance as statisticstotalbalance -- 统计用敞口余额
	,transformtimes as transformtimes -- 变更次数
	,belongitem as belongitem -- 所属项下
	,useexposuretype as useexposuretype -- 占用敞口类型(UseExposureType)
	,isgxtechent as isgxtechent -- 高新技术企业标志
	,isscitechent as isscitechent -- 科技型企业
	,iskctechent as iskctechent -- 科创企业
	,isxxdquota as isxxdquota -- 是否营销额度（新兴贷专用）
	,ispensionindustry as ispensionindustry -- 养老产业标识
	,ifseedloan as ifseedloan -- 种业振兴贷款
	,ifcountyloan as ifcountyloan -- 县城区贷款
	,ifhighindustry as ifhighindustry -- 是否投向高技术产业
	,numbereconomytype as numbereconomytype -- 投向数字经济核心产业类型
	,riskapproveamout as riskapproveamout -- 风控审批可用金额
	,icmsapproveamout as icmsapproveamout -- 信贷审批可用金额
	,ifcapproveamount as ifcapproveamount -- 审批后额度合同金额（IFC专用）
	,ifcapprovebalance as ifcapprovebalance -- 数总审批可用金额（IFC专用）
	,issignedcontract as issignedcontract -- 是否签订额度合同
	,whethertorestructuretheloan as whethertorestructuretheloan -- 是否重组贷款
	,bdserialno as bdserialno -- 借据号
	,renewstartdate as renewstartdate -- 展期起始日
	,secondpayaccount as secondpayaccount -- 第二还款账号
	,merchordernum -- 订单号
	,applyno -- 房抵贷贷款申请编号
	,pclnominalamount -- 华兴易贷担保可用金额
	,pcloccupyamount -- 华兴易贷担保占用金额
	,comticketrecourseflag -- 商票保贴追索标识（0-否，1-是）
	,bizcontrwthrdisctpers -- 是否贴现人保证金账户（0-否，1-是）
	,subproductname -- 子产品名称
	,' ' as renewaltype -- 
	,start_dt as start_dt -- 开始时间
	,end_dt as end_dt -- 结束时间
	,id_mark as id_mark -- 增删标志
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_business_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

