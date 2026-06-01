/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BUSINESS_APPROVE_ret1
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
                       FROM ICMS_BUSINESS_APPROVE_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BUSINESS_APPROVE');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BUSINESS_APPROVE drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BUSINESS_APPROVE add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BUSINESS_APPROVE(
            serialno -- 批复编号流水号
            ,baserialno -- 申请编号
            ,originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
            ,relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
            ,parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
            ,sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,applytype -- 申请类型申请类型(单一、集团、同业)
            ,flowtype -- 流程类型
            ,businessflag -- 额度/业务标志
            ,occurtype -- 贷款发放类型
            ,occurdate -- 发生日期
            ,currency -- 额度/业务币种
            ,businesssum -- 授信额度
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 额度/业务起始日起始日
            ,maturity -- 额度/业务到期日到期日
            ,isremotebusiness -- 是否异地业务
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
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
            ,repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,reservesum -- 预留金额
            ,oldcontractno -- 关联的旧合同关联的旧的合同号
            ,clno -- 额度编号
            ,contractflag -- 生成合同标志
            ,approvestatus -- 审批状态
            ,approvetype -- 审批方式
            ,finalapproveopinion -- 最终审批意见
            ,remark -- 备注
            ,completeflag -- 数据录入完整性标识
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongdept -- 所属条线BelongDept
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,loanusetype -- 贷款用途
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,organizetype -- 授信组织方式01一般贷款2银团贷款)
            ,totalsum -- 额度敞口金额
            ,vouchtypeinner -- 担保方式（内部口径）
            ,pigeonholedate -- 归档日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,reinforceflag -- 补登标志
            ,status -- 生效标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,bailaccount -- 保证金账号
            ,bailtransaccount -- 保证金转出账号
            ,bailcurrency -- 保证金币种
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,settlementaccount -- 结算账号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,checkyearstatus -- 年审进行状态
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,effectdate -- 生效日期
            ,serialnocn -- 中文批复编号
            ,ispensionindustry -- 养老产业标识
            ,isyeartocheck -- 
            ,sqcheckyeardate -- 
            ,bqcheckyeardate -- 
            ,templeteno -- 
            ,templeteurl -- 
            ,whethertorestructuretheloan -- 
			,subproductname -- 子产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 批复编号流水号
            ,baserialno -- 申请编号
            ,originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
            ,relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
            ,parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
            ,sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,applytype -- 申请类型申请类型(单一、集团、同业)
            ,flowtype -- 流程类型
            ,businessflag -- 额度/业务标志
            ,occurtype -- 贷款发放类型
            ,occurdate -- 发生日期
            ,currency -- 额度/业务币种
            ,businesssum -- 授信额度
            ,baseproduct -- 基础产品(额度)基础产品
            ,productid -- 产品编号
            ,policyid -- 产品政策编号
            ,policyversionid -- 产品政策版本
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 额度/业务起始日起始日
            ,maturity -- 额度/业务到期日到期日
            ,isremotebusiness -- 是否异地业务
            ,iscycle -- 是否循环(额度)是否循环
            ,risktype -- 风险类型(额度)风险类型（一般、低风险）
            ,islowrisk -- 是否低风险业务
            ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
            ,nationalindustrytype -- 贷款投向行业
            ,intraindustrytype -- 行内行业投向
            ,purpose -- 用途
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
            ,repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
            ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
            ,repaydate -- 指定还款日
            ,reservesum -- 预留金额
            ,oldcontractno -- 关联的旧合同关联的旧的合同号
            ,clno -- 额度编号
            ,contractflag -- 生成合同标志
            ,approvestatus -- 审批状态
            ,approvetype -- 审批方式
            ,finalapproveopinion -- 最终审批意见
            ,remark -- 备注
            ,completeflag -- 数据录入完整性标识
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,belongdept -- 所属条线BelongDept
            ,corporgid -- 法人机构编号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,renewtermdate -- 展期前到期日
            ,renewtotalsum -- 展期前金额
            ,renewexecuteyearrate -- 展期前执行年利率
            ,loanusetype -- 贷款用途
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,organizetype -- 授信组织方式01一般贷款2银团贷款)
            ,totalsum -- 额度敞口金额
            ,vouchtypeinner -- 担保方式（内部口径）
            ,pigeonholedate -- 归档日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,reinforceflag -- 补登标志
            ,status -- 生效标志
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,bailaccount -- 保证金账号
            ,bailtransaccount -- 保证金转出账号
            ,bailcurrency -- 保证金币种
            ,bailratio -- 保证金比例（%）
            ,bailsum -- 保证金金额
            ,rateadjustfrequency -- 利率调整周期
            ,overduerate -- 逾期执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountno -- 入账账户
            ,settlementaccount -- 结算账号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,checkyearstatus -- 年审进行状态
            ,vouchflag -- 有无其他担保方式，HaveNot
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,effectdate -- 生效日期
            ,serialnocn -- 中文批复编号
            ,ispensionindustry -- 养老产业标识
            ,isyeartocheck -- 
            ,sqcheckyeardate -- 
            ,bqcheckyeardate -- 
            ,templeteno -- 
            ,templeteurl -- 
            ,whethertorestructuretheloan -- 
		    ,' ' AS subproductname -- 子产品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BUSINESS_APPROVE_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
