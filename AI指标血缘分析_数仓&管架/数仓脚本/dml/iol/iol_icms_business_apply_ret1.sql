/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_apply_ret1
CreateDate: 20250331
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
                       FROM icms_business_apply_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_business_apply');

  if v_var <> 0 then
    execute immediate 'alter table icms_business_apply drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_business_apply add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_business_apply (
    serialno -- 授信编号流水号
    ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,productclassify -- 产品所属大类
    ,intraindustrytype -- 行内行业投向
    ,operateuserid -- 经办人
    ,originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
    ,bailratio -- 保证金比例（%）
    ,risktype -- 风险类型(额度)风险类型（一般、低风险）
    ,inputuserid -- 登记人
    ,classifyresult -- 风险分类结果（5级）
    ,overduerate -- 逾期执行利率
    ,baseratetype -- 基准利率类型
    ,approvetype -- 审批方式
    ,productid -- 产品编号
    ,executerate -- 执行利率
    ,businessflag -- 额度/业务标志
    ,migtflag -- 迁移标志：crs rcr ilc upl
    ,clno -- 额度编号
    ,renewtotalsum -- 展期前金额
    ,currency -- 额度/业务币种
    ,vouchtype2 -- 担保方式2
    ,belongdept -- 所属条线BelongDept
    ,occurdate -- 发生日期
    ,operateorgid -- 经办机构
    ,bailaccount -- 保证金账号
    ,baserate -- 基准利率
    ,customerid -- 客户编号
    ,settlementaccountname -- 结算账户(还款账户)号
    ,remark -- 备注
    ,flowtype -- 流程类型
    ,baseproduct -- 基础产品(额度)基础产品
    ,approvestatus -- 审批状态
    ,termmonth -- 期限(月)
    ,additioncommand -- 其他条件和要求
    ,bailsum -- 保证金金额
    ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,vouchtypeinner -- 担保方式（内部口径）
    ,repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
    ,programno -- 关联重组方案编号
    ,customername -- 客户名称
    ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,overdueratefloattype -- 逾期利率浮动方式
    ,overdueratefloatvalue -- 逾期利率浮动值
    ,totalsum -- 额度敞口金额
    ,termday -- 期限(天)
    ,floatrange -- 浮动幅度
    ,renewexecuteyearrate -- 展期前执行年利率
    ,parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
    ,policyid -- 产品政策编号
    ,maturity -- 额度/业务到期日到期日
    ,rateadjustfrequency -- 利率调整周期
    ,repaydate -- 指定还款日
    ,startdate -- 额度/业务起始日起始日
    ,iscycle -- 是否循环(额度)是否循环
    ,ratefloattype -- 利率浮动类型浮动利率类型
    ,oldcontractno -- 关联的旧的合同编号关联的旧的合同号
    ,payfrequencyunit -- 指定周期单位
    ,relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
    ,loanaccountname -- 入账账户名称
    ,vouchtype -- 主要担保方式
    ,haveadditionalvouch -- 有无追加担保方式
    ,updatedate -- 更新日期
    ,classifydate -- 风险分类日期
    ,putoutorgid -- 出账机构编号(核心机构)
    ,nationalindustrytype -- 国标行业投向
    ,occurtype -- 发生类型
    ,organizetype -- 授信组织方式01一般贷款2银团贷款)
    ,isremotebusiness -- 是否异地业务
    ,islowrisk -- 是否低风险业务
    ,othervouchtype -- 其他担保方式
    ,sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
    ,bailtransaccount -- 保证金转出账号
    ,vouchtype3 -- 担保方式3
    ,operatedate -- 经办日期
    ,inputorgid -- 登记机构
    ,loanusetype -- 借款用途类型
    ,inputdate -- 登记日期
    ,payfrequency -- 指定周期
    ,applytype -- 申请类型申请类型(单一、集团、同业)
    ,settlementaccount -- 结算账户(还款账户)名
    ,completeflag -- 数据录入完整性标识
    ,policyversionid -- 产品政策版本
    ,trueorfalse -- 是否引入大数据
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,renewtermdate -- 展期前到期日
    ,bailcurrency -- 保证金币种
    ,loanaccountno -- 入账账户
    ,classifyresulteleven -- 风险分类结果（11级）
    ,loanaccountbankno -- 入账账户开户行行号
    ,hascreateapprove -- 是否登记批复
    ,reservesum -- 预留金额
    ,adjusttype -- 调整类型(零售-额度调整码值：AdjustWay(冻结、解冻、终止))
    ,businesssum -- 申请金额
    ,pigeonholedate -- 归档日期
    ,creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,purpose -- 用途
    ,fixedrate -- 固定利率
    ,corporgid -- 法人机构编号
    ,migtoldvalue -- 迁移数据-参数转换前字段值
    ,templeteno -- 同业模板编号
    ,templeteurl -- 同业模板页面路径
    ,vouchflag -- 有无其他担保方式，HaveNot
    ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,ispensionindustry -- 养老产业标识
    ,migtcustomerid -- 转换前客户号
    ,migtbusinesstype -- 转换前产品ID
    ,ratevaluemodel -- 利率取值模式
    ,prdparametermodel -- 产品参数利率
    ,personalizationmodel -- 个性化利率
    ,childcustname -- 子公司名称
    ,whethertorestructuretheloan -- 是否重组贷款
    ,businessmodel -- 业务模式
    ,precisionmarket -- 精准营销识别信息是否齐全
    ,rateretail -- 评级零售小企业标识 1-是 0-否
	,subproductname -- 子产品名称
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno as serialno -- 授信编号流水号
    ,repaycycle as repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,productclassify as productclassify -- 产品所属大类
    ,intraindustrytype as intraindustrytype -- 行内行业投向
    ,operateuserid as operateuserid -- 经办人
    ,originflag as originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
    ,bailratio as bailratio -- 保证金比例（%）
    ,risktype as risktype -- 风险类型(额度)风险类型（一般、低风险）
    ,inputuserid as inputuserid -- 登记人
    ,classifyresult as classifyresult -- 风险分类结果（5级）
    ,overduerate as overduerate -- 逾期执行利率
    ,baseratetype as baseratetype -- 基准利率类型
    ,approvetype as approvetype -- 审批方式
    ,productid as productid -- 产品编号
    ,executerate as executerate -- 执行利率
    ,businessflag as businessflag -- 额度/业务标志
    ,migtflag as migtflag -- 迁移标志：crs rcr ilc upl
    ,clno as clno -- 额度编号
    ,renewtotalsum as renewtotalsum -- 展期前金额
    ,currency as currency -- 额度/业务币种
    ,vouchtype2 as vouchtype2 -- 担保方式2
    ,belongdept as belongdept -- 所属条线BelongDept
    ,occurdate as occurdate -- 发生日期
    ,operateorgid as operateorgid -- 经办机构
    ,bailaccount as bailaccount -- 保证金账号
    ,baserate as baserate -- 基准利率
    ,customerid as customerid -- 客户编号
    ,settlementaccountname as settlementaccountname -- 结算账户(还款账户)号
    ,remark as remark -- 备注
    ,flowtype as flowtype -- 流程类型
    ,baseproduct as baseproduct -- 基础产品(额度)基础产品
    ,approvestatus as approvestatus -- 审批状态
    ,termmonth as termmonth -- 期限(月)
    ,additioncommand as additioncommand -- 其他条件和要求
    ,bailsum as bailsum -- 保证金金额
    ,ratemodel as ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,vouchtypeinner as vouchtypeinner -- 担保方式（内部口径）
    ,repaytype as repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
    ,programno as programno -- 关联重组方案编号
    ,customername as customername -- 客户名称
    ,rateadjusttype as rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,overdueratefloattype as overdueratefloattype -- 逾期利率浮动方式
    ,overdueratefloatvalue as overdueratefloatvalue -- 逾期利率浮动值
    ,totalsum as totalsum -- 额度敞口金额
    ,termday as termday -- 期限(天)
    ,floatrange as floatrange -- 浮动幅度
    ,renewexecuteyearrate as renewexecuteyearrate -- 展期前执行年利率
    ,parentserialno as parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
    ,policyid as policyid -- 产品政策编号
    ,maturity as maturity -- 额度/业务到期日到期日
    ,rateadjustfrequency as rateadjustfrequency -- 利率调整周期
    ,repaydate as repaydate -- 指定还款日
    ,startdate as startdate -- 额度/业务起始日起始日
    ,iscycle as iscycle -- 是否循环(额度)是否循环
    ,ratefloattype as ratefloattype -- 利率浮动类型浮动利率类型
    ,oldcontractno as oldcontractno -- 关联的旧的合同编号关联的旧的合同号
    ,payfrequencyunit as payfrequencyunit -- 指定周期单位
    ,relativeserialno as relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
    ,loanaccountname as loanaccountname -- 入账账户名称
    ,vouchtype as vouchtype -- 主要担保方式
    ,haveadditionalvouch as haveadditionalvouch -- 有无追加担保方式
    ,updatedate as updatedate -- 更新日期
    ,classifydate as classifydate -- 风险分类日期
    ,putoutorgid as putoutorgid -- 出账机构编号(核心机构)
    ,nationalindustrytype as nationalindustrytype -- 国标行业投向
    ,occurtype as occurtype -- 发生类型
    ,organizetype as organizetype -- 授信组织方式01一般贷款2银团贷款)
    ,isremotebusiness as isremotebusiness -- 是否异地业务
    ,islowrisk as islowrisk -- 是否低风险业务
    ,othervouchtype as othervouchtype -- 其他担保方式
    ,sourceserialno as sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
    ,bailtransaccount as bailtransaccount -- 保证金转出账号
    ,vouchtype3 as vouchtype3 -- 担保方式3
    ,operatedate as operatedate -- 经办日期
    ,inputorgid as inputorgid -- 登记机构
    ,loanusetype as loanusetype -- 借款用途类型
    ,inputdate as inputdate -- 登记日期
    ,payfrequency as payfrequency -- 指定周期
    ,applytype as applytype -- 申请类型申请类型(单一、集团、同业)
    ,settlementaccount as settlementaccount -- 结算账户(还款账户)名
    ,completeflag as completeflag -- 数据录入完整性标识
    ,policyversionid as policyversionid -- 产品政策版本
    ,trueorfalse as trueorfalse -- 是否引入大数据
    ,updateuserid as updateuserid -- 更新人
    ,updateorgid as updateorgid -- 更新机构
    ,renewtermdate as renewtermdate -- 展期前到期日
    ,bailcurrency as bailcurrency -- 保证金币种
    ,loanaccountno as loanaccountno -- 入账账户
    ,classifyresulteleven as classifyresulteleven -- 风险分类结果（11级）
    ,loanaccountbankno as loanaccountbankno -- 入账账户开户行行号
    ,hascreateapprove as hascreateapprove -- 是否登记批复
    ,reservesum as reservesum -- 预留金额
    ,adjusttype as adjusttype -- 调整类型(零售-额度调整码值：AdjustWay(冻结、解冻、终止))
    ,businesssum as businesssum -- 申请金额
    ,pigeonholedate as pigeonholedate -- 归档日期
    ,creditinvest as creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,purpose as purpose -- 用途
    ,fixedrate as fixedrate -- 固定利率
    ,corporgid as corporgid -- 法人机构编号
    ,migtoldvalue as migtoldvalue -- 迁移数据-参数转换前字段值
    ,templeteno as templeteno -- 同业模板编号
    ,templeteurl as templeteurl -- 同业模板页面路径
    ,vouchflag as vouchflag -- 有无其他担保方式，HaveNot
    ,ratefloatratioorbp as ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,ispensionindustry as ispensionindustry -- 养老产业标识
    ,migtcustomerid as migtcustomerid -- 转换前客户号
    ,migtbusinesstype as migtbusinesstype -- 转换前产品ID
    ,ratevaluemodel as ratevaluemodel -- 利率取值模式
    ,prdparametermodel as prdparametermodel -- 产品参数利率
    ,personalizationmodel as personalizationmodel -- 个性化利率
    ,childcustname as childcustname -- 子公司名称
    ,whethertorestructuretheloan as whethertorestructuretheloan -- 是否重组贷款
    ,businessmodel -- 业务模式
    ,precisionmarket -- 精准营销识别信息是否齐全
    ,rateretail -- 评级零售小企业标识 1-是 0-否
    ,' ' as subproductname -- 子产品名称
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_business_apply_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

