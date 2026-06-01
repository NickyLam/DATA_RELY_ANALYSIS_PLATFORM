/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BC_CL_INFO_ret1
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
                       FROM ICMS_BC_CL_INFO_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BC_CL_INFO');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BC_CL_INFO drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BC_CL_INFO add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BC_CL_INFO(
            serialno -- 流水号
            ,lineclass -- 额度种类综合/专项/其他)
            ,currencyrange -- 项下业务币种范围
            ,lngotimes -- 借新还旧次数
            ,occupynominalsum -- 已用名义金额自动计算)
            ,afterloanuserid -- 贷后管理人员
            ,creditflowtype -- 授信业务流程类型
            ,creditarea -- 授信区域
            ,approvalsuggestion -- 建议审批等级
            ,useterm -- 额度项下业务最迟到期日期
            ,freezeflag -- 冻结标志
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,limitusecondition -- 额度使用条件
            ,classifytype2 -- 风险暴露分类
            ,bizextendedterm -- 额度下业务延展期限月)
            ,outclassifydate -- 外部评级日期
            ,termtype -- 期限申请类型额度)
            ,availablenominalsum -- 可用名义金额
            ,afterloanorgid -- 贷后管理机构
            ,outclassifyorg -- 外部评级机构
            ,investway -- 投资方式
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,guarantybailsubaccount -- 押品转保证金子户号
            ,isrz -- 是否融资合同
            ,isgovernfinance -- 是否涉及政府类融资
            ,isgreenfinance -- 是否为绿色信贷融资
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,usewithoutcondition -- 能否直接使用额度)
            ,businesstype2 -- 专业贷款分类
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,availableexposuresum -- 可用敞口金额
            ,syndicatetotalsum -- 银团贷款总金额
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,migtflag -- 
            ,istrans -- 是否转授信
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,otherlimitflag -- 是否占用他用额度
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,exposuresum -- 额度敞口金额
            ,putoutorgid -- 放贷机构
            ,riskexposuresum -- 其中，一般风险敞口金额(元)
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,onlineamount -- 线上额度(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,ispubliccredit -- 是否公开授信额度)
            ,creditauthno -- 征信授权影像流水号
            ,islikeloan -- 是否类信贷
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,drtimes -- 债务重组次数
            ,guarantybailaccount -- 押品转保证金账号
            ,nominalsum -- 额度名义金额
            ,latestusedate -- 额度最迟使用日期
            ,outclassifylevel -- 外部债项评级
            ,isestatefinance -- 是否涉及房地产融资
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,hxtyoperateorg -- 归口管理部门
            ,classifyresulteleven -- 债项分类
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,mainlevelorg -- 主体评级机构
            ,mainleveldate -- 主体评级日期
            ,purpose -- 资金用途
            ,investtarget -- 投资标的
            ,publicorg -- 发行场所
            ,approvepubsum -- 批准发行总额
            ,publishsum -- 本次发行金额
            ,issuername -- 发行人名称
            ,issuerid -- 发行人编号
            ,originalname -- 原始权益人名称
            ,originalid -- 原始权益人编号
            ,channelname -- 通道方名称
            ,channelid -- 通道方编号
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,ispenetrate -- 是否可穿透
            ,moneyindustryt -- 资金投向行业
            ,supplychain -- 供应链业务单占核心企业额度
            ,islikelowrisk -- 是否类低风险
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,lmttyp -- 同业额度合同-额度类型
            ,sqdkze -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,lineclass -- 额度种类综合/专项/其他)
            ,currencyrange -- 项下业务币种范围
            ,lngotimes -- 借新还旧次数
            ,occupynominalsum -- 已用名义金额自动计算)
            ,afterloanuserid -- 贷后管理人员
            ,creditflowtype -- 授信业务流程类型
            ,creditarea -- 授信区域
            ,approvalsuggestion -- 建议审批等级
            ,useterm -- 额度项下业务最迟到期日期
            ,freezeflag -- 冻结标志
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,limitusecondition -- 额度使用条件
            ,classifytype2 -- 风险暴露分类
            ,bizextendedterm -- 额度下业务延展期限月)
            ,outclassifydate -- 外部评级日期
            ,termtype -- 期限申请类型额度)
            ,availablenominalsum -- 可用名义金额
            ,afterloanorgid -- 贷后管理机构
            ,outclassifyorg -- 外部评级机构
            ,investway -- 投资方式
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,guarantybailsubaccount -- 押品转保证金子户号
            ,isrz -- 是否融资合同
            ,isgovernfinance -- 是否涉及政府类融资
            ,isgreenfinance -- 是否为绿色信贷融资
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,usewithoutcondition -- 能否直接使用额度)
            ,businesstype2 -- 专业贷款分类
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,availableexposuresum -- 可用敞口金额
            ,syndicatetotalsum -- 银团贷款总金额
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,migtflag -- 
            ,istrans -- 是否转授信
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,otherlimitflag -- 是否占用他用额度
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,exposuresum -- 额度敞口金额
            ,putoutorgid -- 放贷机构
            ,riskexposuresum -- 其中，一般风险敞口金额(元)
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,onlineamount -- 线上额度(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,ispubliccredit -- 是否公开授信额度)
            ,creditauthno -- 征信授权影像流水号
            ,islikeloan -- 是否类信贷
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,drtimes -- 债务重组次数
            ,guarantybailaccount -- 押品转保证金账号
            ,nominalsum -- 额度名义金额
            ,latestusedate -- 额度最迟使用日期
            ,outclassifylevel -- 外部债项评级
            ,isestatefinance -- 是否涉及房地产融资
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,hxtyoperateorg -- 归口管理部门
            ,classifyresulteleven -- 债项分类
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,mainlevelorg -- 主体评级机构
            ,mainleveldate -- 主体评级日期
            ,purpose -- 资金用途
            ,investtarget -- 投资标的
            ,publicorg -- 发行场所
            ,approvepubsum -- 批准发行总额
            ,publishsum -- 本次发行金额
            ,issuername -- 发行人名称
            ,issuerid -- 发行人编号
            ,originalname -- 原始权益人名称
            ,originalid -- 原始权益人编号
            ,channelname -- 通道方名称
            ,channelid -- 通道方编号
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,ispenetrate -- 是否可穿透
            ,moneyindustryt -- 资金投向行业
            ,supplychain -- 供应链业务单占核心企业额度
            ,islikelowrisk -- 是否类低风险
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,lmttyp -- 同业额度合同-额度类型
            ,0 AS sqdkze -- 
            ,' ' AS isjoinlimits -- 
            ,0 AS otherlimitamount -- 
            ,' ' AS iscollectionagency -- 
            ,' ' AS islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BC_CL_INFO_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
