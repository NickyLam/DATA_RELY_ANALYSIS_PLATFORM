/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BAP_CL_INFO_ret1
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
                       FROM ICMS_BAP_CL_INFO_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BAP_CL_INFO');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BAP_CL_INFO drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BAP_CL_INFO add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BAP_CL_INFO(
            serialno -- 流水号
            ,refbankname -- 参贷行行号
            ,agentbankname -- 代理行行号
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,nominalsum -- 额度名义金额
            ,landusecertid -- 国有土地使用证号
            ,thirdpartyzip1 -- 公积金贷款手续费比例%
            ,outclassifyorg -- 外部评级机构
            ,creditarea -- 授信区域
            ,isbillapply -- 是否新增银承额度专项贴现
            ,hostbankno -- 主办行行号
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,totalsumtypart -- 同业敞口金额(元)
            ,businesssumentpart -- 公司额度金额(元)
            ,mainlevelorg -- 主体评级机构
            ,otherlimittype -- 他用额度类型
            ,approveopinion -- 最终审批意见
            ,describe2 -- 项目座落位置
            ,fundsource -- 资金来源
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupynominalsum -- 已用名义金额自动计算)
            ,belonggroupapproveno -- 集团批复编号
            ,lngotimes -- 借新还旧次数
            ,playtype -- 参与方式
            ,flag1 -- 是否为项下业务提供保证担保
            ,investway -- 投资方式
            ,hxtyoperateorg -- 归口管理部门
            ,isfinancialcredit -- 是否商圈授信
            ,sqdkze -- 申请银团贷款总额(元)
            ,constructionarea -- 项目总面积（平方米）
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,drtimes -- 债务重组次数
            ,usewithoutcondition -- 能否直接使用额度)
            ,othercondition -- 额度使用条件\集群客户授信方案
            ,creditauthno -- 征信授权影像流水号
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,rateopinion -- 客户评级
            ,hxtyclassifylevel -- 债项分类
            ,lineclass -- 额度种类综合/专项/其他)
            ,refbankno -- 参贷行行号
            ,thirdpartyid1 -- 建设用地规划可证号
            ,thirdpartyid2 -- 建设工程规划许可证号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,termtype -- 期限申请类型额度)
            ,outclassifydate -- 外部评级日期
            ,iscreditincrement -- 是否有增信
            ,dlcdbz -- 代理参贷标志
            ,publishsum -- 本次发行金额
            ,availablenominalsum -- 可用名义金额
            ,availableexposuresum -- 可用敞口金额
            ,otherlimitno -- 他用额度流水号
            ,totalsumentpart -- 公司敞口金额(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,agentbankno -- 代理行行号
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,otherlimitownerid -- 他用额度所有人
            ,thirdparty1 -- 销(预)售许可证号
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,issme -- 是否小微企业贷款
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,bizextendedterm -- 额度下业务延展期限月)
            ,otherlimitflag -- 是否占用他用额度
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,currencyrange -- 项下业务币种范围
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,isyeartocheck -- 是否需要年审
            ,isgreenfinance -- 是否为绿色信贷融资
            ,outclassifylevel -- 外部债项评级
            ,investtarget -- 投资标的
            ,approvepubsum -- 批准发行总额
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,bailratio -- 保证金比例%
            ,bailsum -- 保证金金额（元）
            ,transcount -- 交易对手个数
            ,hxtymainratelevel -- 外部主体评级
            ,businesssumtypart -- 同业额度金额(元)
            ,islikeloan -- 是否类信贷
            ,authvouchtype -- 授权权限_担保方式
            ,approveopinion6 -- 贷后要求
            ,projectname -- 项目名称
            ,publicorg -- 发行场所
            ,termday -- 零（天）
            ,thirdpartyid3 -- 最高成数%
            ,migtflag -- 
            ,thirdpartyadd1 -- 最长期限(年)
            ,isestatefinance -- 是否涉及房地产融资
            ,financialcreditowner -- 集群客户专项额度所有人
            ,approveopinion1 -- 最终审批意见2
            ,approvedate -- 批复日期
            ,isyhcustomer -- 是否优合授信客户
            ,exposuresum -- 额度敞口金额
            ,sqcheckyeardate -- 上期年审日期
            ,describe1 -- 项下业务主要担保方式
            ,thirdparty3 -- 建筑工程施工可证号
            ,hostbankname -- 主办行行名
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,latestusedate -- 额度最迟使用日期
            ,flag2 -- 是否为项下业务承担回购责任
            ,gurantymonth -- 担保期限(月)
            ,isgovernfinance -- 是否涉及政府类融资
            ,approveopinion7 -- 贷后要求补充说明
            ,bqcheckyeardate -- 本期年审日期
            ,onlineamount -- 线上额度(元)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,mainleveldate -- 主体评级日期
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ifapprove -- 是否人工填写标志
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,custraterisklevel -- 客户内评评级结果
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,antimoneylaunderlevel -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,refbankname -- 参贷行行号
            ,agentbankname -- 代理行行号
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,nominalsum -- 额度名义金额
            ,landusecertid -- 国有土地使用证号
            ,thirdpartyzip1 -- 公积金贷款手续费比例%
            ,outclassifyorg -- 外部评级机构
            ,creditarea -- 授信区域
            ,isbillapply -- 是否新增银承额度专项贴现
            ,hostbankno -- 主办行行号
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,totalsumtypart -- 同业敞口金额(元)
            ,businesssumentpart -- 公司额度金额(元)
            ,mainlevelorg -- 主体评级机构
            ,otherlimittype -- 他用额度类型
            ,approveopinion -- 最终审批意见
            ,describe2 -- 项目座落位置
            ,fundsource -- 资金来源
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupynominalsum -- 已用名义金额自动计算)
            ,belonggroupapproveno -- 集团批复编号
            ,lngotimes -- 借新还旧次数
            ,playtype -- 参与方式
            ,flag1 -- 是否为项下业务提供保证担保
            ,investway -- 投资方式
            ,hxtyoperateorg -- 归口管理部门
            ,isfinancialcredit -- 是否商圈授信
            ,sqdkze -- 申请银团贷款总额(元)
            ,constructionarea -- 项目总面积（平方米）
            ,financialmodel -- 集群客户操作模式、风险管理及控制方案
            ,drtimes -- 债务重组次数
            ,usewithoutcondition -- 能否直接使用额度)
            ,othercondition -- 额度使用条件\集群客户授信方案
            ,creditauthno -- 征信授权影像流水号
            ,manageid -- 管理人客户号
            ,istrans -- 是否转授信
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,rateopinion -- 客户评级
            ,hxtyclassifylevel -- 债项分类
            ,lineclass -- 额度种类综合/专项/其他)
            ,refbankno -- 参贷行行号
            ,thirdpartyid1 -- 建设用地规划可证号
            ,thirdpartyid2 -- 建设工程规划许可证号
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,termtype -- 期限申请类型额度)
            ,outclassifydate -- 外部评级日期
            ,iscreditincrement -- 是否有增信
            ,dlcdbz -- 代理参贷标志
            ,publishsum -- 本次发行金额
            ,availablenominalsum -- 可用名义金额
            ,availableexposuresum -- 可用敞口金额
            ,otherlimitno -- 他用额度流水号
            ,totalsumentpart -- 公司敞口金额(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,agentbankno -- 代理行行号
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,otherlimitownerid -- 他用额度所有人
            ,thirdparty1 -- 销(预)售许可证号
            ,issmeandretail -- 是否我行小微企业并且走零售条线
            ,issme -- 是否小微企业贷款
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,bizextendedterm -- 额度下业务延展期限月)
            ,otherlimitflag -- 是否占用他用额度
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,currencyrange -- 项下业务币种范围
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,isyeartocheck -- 是否需要年审
            ,isgreenfinance -- 是否为绿色信贷融资
            ,outclassifylevel -- 外部债项评级
            ,investtarget -- 投资标的
            ,approvepubsum -- 批准发行总额
            ,financialcreditserialno -- 集群客户专项额度流水号
            ,bailratio -- 保证金比例%
            ,bailsum -- 保证金金额（元）
            ,transcount -- 交易对手个数
            ,hxtymainratelevel -- 外部主体评级
            ,businesssumtypart -- 同业额度金额(元)
            ,islikeloan -- 是否类信贷
            ,authvouchtype -- 授权权限_担保方式
            ,approveopinion6 -- 贷后要求
            ,projectname -- 项目名称
            ,publicorg -- 发行场所
            ,termday -- 零（天）
            ,thirdpartyid3 -- 最高成数%
            ,migtflag -- 
            ,thirdpartyadd1 -- 最长期限(年)
            ,isestatefinance -- 是否涉及房地产融资
            ,financialcreditowner -- 集群客户专项额度所有人
            ,approveopinion1 -- 最终审批意见2
            ,approvedate -- 批复日期
            ,isyhcustomer -- 是否优合授信客户
            ,exposuresum -- 额度敞口金额
            ,sqcheckyeardate -- 上期年审日期
            ,describe1 -- 项下业务主要担保方式
            ,thirdparty3 -- 建筑工程施工可证号
            ,hostbankname -- 主办行行名
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,suremodel -- 是否总行认定模式
            ,managename -- 管理人名称
            ,ispubliccredit -- 是否公开授信额度)
            ,latestusedate -- 额度最迟使用日期
            ,flag2 -- 是否为项下业务承担回购责任
            ,gurantymonth -- 担保期限(月)
            ,isgovernfinance -- 是否涉及政府类融资
            ,approveopinion7 -- 贷后要求补充说明
            ,bqcheckyeardate -- 本期年审日期
            ,onlineamount -- 线上额度(元)
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,mainleveldate -- 主体评级日期
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,phaseopinion -- 主动批量-授信方案意见
            ,finishflag -- 主动批量-授信方案确认标志
            ,ifapprove -- 是否人工填写标志
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
            ,contractreq -- 需落实到合同、协议中的特殊要求
            ,custraterisklevel -- 客户内评评级结果
            ,islikelowrisk -- 是否类低风险
            ,loanmanagereq -- 贷后管理要求
            ,payreq -- 授信方案
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,' ' AS isjoinlimits -- 
            ,0 AS otherlimitamount -- 
            ,' ' AS iscollectionagency -- 
            ,' ' AS antimoneylaunderlevel -- 
            ,' ' AS islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BAP_CL_INFO_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
