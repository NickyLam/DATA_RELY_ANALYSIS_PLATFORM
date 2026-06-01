/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_CUSTOMER_PARTNER_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_CUSTOMER_PARTNER_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_CUSTOMER_PARTNER');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_CUSTOMER_PARTNER drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_CUSTOMER_PARTNER add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_CUSTOMER_PARTNER(
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
            ,0 AS guaranteeproportion -- 
            ,0 AS maxguaranteeamount -- 
            ,' ' AS isguarantee -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_CUSTOMER_PARTNER_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
