/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_guaranty_contract
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
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
                       FROM icms_guaranty_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_guaranty_contract');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_guaranty_contract drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_guaranty_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_guaranty_contract(
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
    ,' ' as clno -- 
    ,' ' as mortgagereceiptno -- 
    ,' ' as encumbranceno -- 
    ,' ' as registcountryresult -- 保证人注册地所在国家或地区外部评级结果
    ,to_date('00010101','yyyymmdd') as outratingdate -- 保证人外部评级日期
    ,' ' as outratingresult -- 保证人外部评级结果
    ,to_date('00010101','yyyymmdd') as inratingdate -- 保证人内部评级日期
    ,' ' as inratingresult -- 保证人内部评级结果
    ,0 as guarcash -- 担保公司保证金金额
    ,' ' as isstage -- 是否阶段性担保
    ,' ' as insuranceno -- 保证保险保单号码
    ,' ' as purpose -- 保证目的
    ,' ' as independence -- 保证人担保独立性
    ,0 as netasset -- 保证人净资产
    ,' ' as netassetcurrency -- 保证人净资产币种
    ,' ' as orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
    ,' ' as iscancel -- 是否不可撤销
    ,' ' as letterno -- 保函编号/备用信用证编号
    ,' ' as lettertype -- 保函类型
    ,' ' as lettercontry -- 证书开具国别/开证国别
    ,0 as lettersum -- 保函金额/备用信用证金额
    ,' ' as lettercurrency -- 保函币种/备用信用证币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from icms_guaranty_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
