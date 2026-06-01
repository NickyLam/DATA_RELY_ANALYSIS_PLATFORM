/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_CL_CREDIT_INFO_ret1
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
                       FROM ICMS_CL_CREDIT_INFO_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_CL_CREDIT_INFO');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_CL_CREDIT_INFO drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_CL_CREDIT_INFO add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_CL_CREDIT_INFO(
            loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
            ,additioncommand -- 其他条件和要求
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,createdway -- 创建方式:审批/系统
            ,reservedamount -- 预留金额
            ,purpose -- 用途
            ,status -- 状态
            ,adjustnominalamount -- 串用名义金额
            ,explain -- 冻结、解冻、终结说明
            ,latestusedate -- 额度最迟使用日期
            ,occurway -- 发生方式
            ,totalpayment -- 累计放款
            ,operateorgid -- 经办机构
            ,reservedcustomerid -- 预留客户编号
            ,nominalamount -- 名义金额
            ,updateorgid -- 最后更新机构
            ,riskexposuresum -- 初始一般敞口金额
            ,execexposureamount -- 执行敞口金额
            ,freezestatus -- 冻结状态已冻结、未冻结）
            ,singlebizmostamount -- 明细额度下业务单笔最大金额
            ,assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
            ,creditphase -- 当前授信阶段
            ,suboccupynominalbalance -- 下层授信名义余额占用汇总
            ,operateuserid -- 经办人
            ,leftprenominalamount -- 剩余预占名义金额
            ,inputorgid -- 登记机构
            ,availablebusinesstype -- 适用业务品种
            ,prenominalamount -- 预占名义金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,nominalbalance -- 授信名义余额
            ,dedicatedflag -- 授信专用标志
            ,availablereservedamount -- 可用预留金额
            ,currencyrange -- 项下业务币种范围
            ,credittype -- 额度品种
            ,sourcesystem -- 最初来源系统
            ,businessoccupynominalamount -- 下层的业务占用名义金额汇总
            ,istrans -- 是否转授信标志
            ,availableexposureamount -- 可用敞口金额
            ,latestartdateunderlowercredit -- 项下下层授信最迟起始日
            ,availablenominalamount -- 可用名义金额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,loweroccupyuppernominalamount -- 下层占用上层授信名义金额
            ,currency -- 币种
            ,exposureamount -- 敞口金额
            ,occupyflag -- 占用标识
            ,suboccupyexposurebalance -- 下层授信敞口余额占用汇总
            ,adjustexposureamount -- 串用敞口金额
            ,exposurebalance -- 授信敞口余额
            ,inputuserid -- 登记人
            ,maxperioddayunderlowercredit -- 项下下层授信最长期限日）
            ,totalrepayment -- 累计还款
            ,lineclass -- 额度种类综合/专项/其他)
            ,leftpreexposureamount -- 剩余预占敞口金额
            ,freezeexposureamount -- 冻结敞口金额
            ,inputdate -- 登记日期
            ,ispubliccredit -- 是否公开授信
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,execnominalamount -- 执行名义金额
            ,freezenominalamount -- 冻结名义金额
            ,creditno -- 额度系统业务编号
            ,assignoccupyuppernominalamount -- 指定占用上层授信名义金额
            ,lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
            ,businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
            ,lowriskexposuresum -- 类低风险敞口金额
            ,timelimitmonth -- 期限月
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,preexposureamount -- 预占敞口金额
            ,effectivedate -- 生效日期
            ,lockflag -- 锁定标识Y/N
            ,timelimitday -- 期限日
            ,onlineamount -- 初始线上额度
            ,sourcecreditno -- 最初来源额度编号
            ,manageuserid -- 管理人
            ,updateuserid -- 最后更新人
            ,customerid -- 客户编号
            ,manageorgid -- 管理机构
            ,earlystartdateunderlowercredit -- 项下下层授信最早起始日
            ,maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
            ,usableamountcalcflag -- 可用金额计算标志
            ,guarantyway -- 担保方式
            ,updatedate -- 最后更新日期
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,canbeextractedundercredit -- 额度项下是否可直接提款Y或N
            ,expiredate -- 到期日
            ,remark -- 备注
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,pledgesum -- 抵质押物金额
            ,isexempt -- 是否豁免
            ,onlinebusinessamount -- 
            ,onlinebusinessbalance -- 
            ,lowoccupynominalamountonline -- 
            ,lowoccupyexposureamountonline -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,icmsapproveamout -- 
            ,bapserialno -- 
            ,occupycreditno -- 
            ,riskapproveamout -- 
            ,iscollectionagency -- 
            ,nbgkamount -- 
            ,nbgkoccupyamount -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
            ,additioncommand -- 其他条件和要求
            ,availablelowriskexposuresum -- 类低风险可用敞口金额
            ,createdway -- 创建方式:审批/系统
            ,reservedamount -- 预留金额
            ,purpose -- 用途
            ,status -- 状态
            ,adjustnominalamount -- 串用名义金额
            ,explain -- 冻结、解冻、终结说明
            ,latestusedate -- 额度最迟使用日期
            ,occurway -- 发生方式
            ,totalpayment -- 累计放款
            ,operateorgid -- 经办机构
            ,reservedcustomerid -- 预留客户编号
            ,nominalamount -- 名义金额
            ,updateorgid -- 最后更新机构
            ,riskexposuresum -- 初始一般敞口金额
            ,execexposureamount -- 执行敞口金额
            ,freezestatus -- 冻结状态已冻结、未冻结）
            ,singlebizmostamount -- 明细额度下业务单笔最大金额
            ,assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
            ,creditphase -- 当前授信阶段
            ,suboccupynominalbalance -- 下层授信名义余额占用汇总
            ,operateuserid -- 经办人
            ,leftprenominalamount -- 剩余预占名义金额
            ,inputorgid -- 登记机构
            ,availablebusinesstype -- 适用业务品种
            ,prenominalamount -- 预占名义金额
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,nominalbalance -- 授信名义余额
            ,dedicatedflag -- 授信专用标志
            ,availablereservedamount -- 可用预留金额
            ,currencyrange -- 项下业务币种范围
            ,credittype -- 额度品种
            ,sourcesystem -- 最初来源系统
            ,businessoccupynominalamount -- 下层的业务占用名义金额汇总
            ,istrans -- 是否转授信标志
            ,availableexposureamount -- 可用敞口金额
            ,latestartdateunderlowercredit -- 项下下层授信最迟起始日
            ,availablenominalamount -- 可用名义金额
            ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
            ,loweroccupyuppernominalamount -- 下层占用上层授信名义金额
            ,currency -- 币种
            ,exposureamount -- 敞口金额
            ,occupyflag -- 占用标识
            ,suboccupyexposurebalance -- 下层授信敞口余额占用汇总
            ,adjustexposureamount -- 串用敞口金额
            ,exposurebalance -- 授信敞口余额
            ,inputuserid -- 登记人
            ,maxperioddayunderlowercredit -- 项下下层授信最长期限日）
            ,totalrepayment -- 累计还款
            ,lineclass -- 额度种类综合/专项/其他)
            ,leftpreexposureamount -- 剩余预占敞口金额
            ,freezeexposureamount -- 冻结敞口金额
            ,inputdate -- 登记日期
            ,ispubliccredit -- 是否公开授信
            ,availableriskexposuresum -- 一般风险可用敞口金额
            ,execnominalamount -- 执行名义金额
            ,freezenominalamount -- 冻结名义金额
            ,creditno -- 额度系统业务编号
            ,assignoccupyuppernominalamount -- 指定占用上层授信名义金额
            ,lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
            ,businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
            ,lowriskexposuresum -- 类低风险敞口金额
            ,timelimitmonth -- 期限月
            ,recyclable -- 可循环标志Y/N
            ,actualexpiredate -- 实际终结日
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,preexposureamount -- 预占敞口金额
            ,effectivedate -- 生效日期
            ,lockflag -- 锁定标识Y/N
            ,timelimitday -- 期限日
            ,onlineamount -- 初始线上额度
            ,sourcecreditno -- 最初来源额度编号
            ,manageuserid -- 管理人
            ,updateuserid -- 最后更新人
            ,customerid -- 客户编号
            ,manageorgid -- 管理机构
            ,earlystartdateunderlowercredit -- 项下下层授信最早起始日
            ,maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
            ,usableamountcalcflag -- 可用金额计算标志
            ,guarantyway -- 担保方式
            ,updatedate -- 最后更新日期
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,slowreleaseexposureamount -- 可缓释敞口金额
            ,canbeextractedundercredit -- 额度项下是否可直接提款Y或N
            ,expiredate -- 到期日
            ,remark -- 备注
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,pledgesum -- 抵质押物金额
            ,isexempt -- 是否豁免
            ,0 AS onlinebusinessamount -- 
            ,0 AS onlinebusinessbalance -- 
            ,0 AS lowoccupynominalamountonline -- 
            ,0 AS lowoccupyexposureamountonline -- 
            ,' ' AS isjoinlimits -- 
            ,0 AS otherlimitamount -- 
            ,0 AS icmsapproveamout -- 
            ,' ' AS bapserialno -- 
            ,' ' AS occupycreditno -- 
            ,0 AS riskapproveamout -- 
            ,' ' AS iscollectionagency -- 
            ,0 AS nbgkamount -- 
            ,0 AS nbgkoccupyamount -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_CL_CREDIT_INFO_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
