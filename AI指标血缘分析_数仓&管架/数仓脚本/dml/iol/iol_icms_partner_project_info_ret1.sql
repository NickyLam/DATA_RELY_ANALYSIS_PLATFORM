/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_PARTNER_PROJECT_INFO_ret1
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
                       FROM ICMS_PARTNER_PROJECT_INFO_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_PARTNER_PROJECT_INFO');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_PARTNER_PROJECT_INFO drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_PARTNER_PROJECT_INFO add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_PARTNER_PROJECT_INFO(
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
            ,' ' AS isinvolve -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_PARTNER_PROJECT_INFO_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
