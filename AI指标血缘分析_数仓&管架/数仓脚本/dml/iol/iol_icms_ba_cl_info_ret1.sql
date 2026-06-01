/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ba_cl_info_ret1
CreateDate: 20250529
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
                       FROM icms_ba_cl_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_ba_cl_info');

  if v_var <> 0 then
    execute immediate 'alter table icms_ba_cl_info drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_ba_cl_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_ba_cl_info (
    serialno -- 流水号
    ,outclassifydate -- 外部评级日期
    ,totalsumentpart -- 公司敞口金额(元)
    ,dlcdbz -- 代理参贷标志
    ,investtarget -- 投资标的
    ,othercondition -- 额度使用条件
    ,iscreditincrement -- 是否有增信
    ,hxtymainratelevel -- 外部主体评级
    ,migtflag -- 迁移标志：CRS RCR ILC UPL
    ,channelname -- 通道方名称
    ,isbillapply -- 是否新增银承额度专项贴现
    ,refbankname -- 参贷行行号
    ,isgovernfinance -- 是否涉及政府类融资
    ,lngotimes -- 借新还旧次数
    ,mainlevelorg -- 主体评级机构
    ,singlebizmostamount -- 额度下业务单笔最大金额
    ,riskexposuresum -- 其中，一般风险敞口限额
    ,nominalsum -- 额度名义金额
    ,isestatefinance -- 是否涉及房地产融资
    ,bizextendedterm -- 额度下业务延展期限月)
    ,availableexposuresum -- 可用敞口金额
    ,islikeloan -- 是否类信贷
    ,publishsum -- 本次发行金额
    ,bizmostmortgagerate -- 额度下业务最高抵质押率
    ,isfinancialcredit -- 是否商圈授信
    ,investway -- 投资方式
    ,fundsource -- 资金来源
    ,playtype -- 参与方式
    ,termtype -- 期限申请类型额度)
    ,lineclass -- 额度种类综合/专项/其他)
    ,suremodel -- 是否总行认定模式
    ,managename -- 管理人名称
    ,manageid -- 管理人客户号
    ,istrans -- 是否转授信
    ,belonggroupapproveno -- 集团批复编号
    ,financialcreditowner -- 集群客户专项额度所有人
    ,issmeandretail -- 是否我行小微企业并且走零售条线
    ,originalname -- 原始权益人名称
    ,ispubliccredit -- 是否公开授信额度)
    ,occupynominalsum -- 已用授信额度
    ,moneyindustryt -- 资金投向行业
    ,bizbailinitialrate -- 额度下业务初始保证金比例
    ,transcount -- 交易对手个数
    ,maxnominalamount -- 单一最高授信额度名义金额
    ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,bizlowestfloatrate -- 额度下业务利率最低浮动
    ,occupyexposuresum -- 已用敞口金额自动计算)
    ,totalsumtypart -- 同业敞口金额(元)
    ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
    ,latestusedate -- 额度最迟使用日期
    ,isgreenfinance -- 是否为绿色信贷融资
    ,otherlimitownerid -- 他用额度所有人
    ,availablenominalsum -- 可用名义金额
    ,hostbankname -- 主办行行名
    ,authvouchtype -- 授权权限_担保方式
    ,isquerycreditreport -- 是否自动查询贷后报告
    ,mainleveldate -- 主体评级日期
    ,usewithoutcondition -- 能否直接使用额度)
    ,isbeltroadfinance -- 是否为一带一路建设投融资
    ,otherlimittype -- 他用额度类型
    ,sqdkze -- 申请银团贷款总额(元)
    ,outclassifylevel -- 外部债项评级
    ,jxhjcontractno -- 借新还旧原合同
    ,businesssumentpart -- 公司授信额度(元)
    ,currencyrange -- 项下业务币种范围
    ,isconsumerfinance -- 是否为消费服务类融资
    ,drtimes -- 债务重组次数
    ,exposuresum -- 额度敞口金额
    ,classifyresulteleven -- 债项分类
    ,issuername -- 发行人名称
    ,financialcreditserialno -- 集群客户专项额度流水号
    ,hxtyoperateorg -- 归口管理部门
    ,issme -- 是否小微企业贷款
    ,hostbankno -- 主办行行号
    ,agentbankname -- 代理行行号
    ,otherlimitno -- 他用额度流水号
    ,creditauthno -- 征信授权影像流水号
    ,agentbankno -- 代理行行号
    ,approvepubsum -- 批准发行总额
    ,outclassifyorg -- 外部评级机构名称
    ,creditarea -- 授信区域
    ,publicorg -- 发行场所
    ,isyhcustomer -- 是否优合授信客户
    ,onlineamount -- 线上额度(元)
    ,refbankno -- 参贷行行号
    ,otherlimitflag -- 是否占用他用额度
    ,hxtyclassifylevel -- 债项分类
    ,businesssumtypart -- 同业授信额度(元)
    ,authostrdate -- 授权起始日
    ,bizlongestterm -- 额度下业务最长期限月)
    ,financialmodel -- 集群客户操作模式、风险管理及控制方案
    ,channelid -- 通道方编号
    ,maxexposureamount -- 单一最高授信额度敞口金额
    ,changetype -- 变更原因
    ,originalid -- 原始权益人编号
    ,issuernameid -- 发行人编号
    ,phaseopinion -- 主动批量-授信方案意见
    ,finishflag -- 主动批量-授信方案确认标志
    ,ispenetrate -- 是否可穿透
    ,ifapprove -- 是否人工填写标志
    ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,contractreq -- 需落实到合同、协议中的特殊要求
    ,islikelowrisk -- 是否类低风险
    ,loanmanagereq -- 贷后管理要求
    ,payreq -- 授信方案
    ,focuslendtype -- 集中放款业务类型
    ,isinnovate -- 是否创新业务
    ,issupplychainfinance -- 是否供应链金融业务
    ,isprojectfinancing -- 是否项目融资
    ,custraterisklevel -- 客户内评评级结果
    ,onlineapprovallimit -- 线上审批额度
    ,oastatus -- OA审批状态
    ,isjoinlimits -- 是否纳入单一客户或集团的限额
    ,otherlimitamount -- 他用额度占用金额
    ,proborrowerattr -- 借款人属性
    ,proborrowerincome -- 借款人收入特征
    ,proborrowerdebt -- 借款人偿债特征
    ,proassetscontrol -- 资产控制
    ,prorevenuecontrol -- 收入控制
    ,projfinancingtype -- 项目融资类型
    ,mercfinancingobject -- 商品融资对象
    ,itemsfinancingtype -- 物品融资类型
    ,isonlineapprove -- 是否线上化审批
    ,guaranteecompanyname -- 见保即贷业务担保公司
    ,runentyearincome -- 流水推算的年销售收入
    ,lastyearentyearincome -- 纳税申报资料反映的上年度收入
    ,yearincomerate -- 预计销售收入年增长率
    ,operationloanbalanceskr -- 实控人经营性贷款余额
    ,otherworkcaptial -- 其他渠道提供的营运资金
    ,isrelatedcompany -- 借款企业是否为担保公司的关联企业:1是0否
    ,subjectbusiness -- 主营业务
    ,enterpriseamt -- 借款企业在我行有效额度
    ,riskapproveamout -- 风控最终审批金额
    ,riskapprovestatus -- 风控最终状态
    ,riskterm -- 风控最终审批期限
    ,isbranchbusiness -- 是否分行权限内业务
    ,bondingcompanyinamt -- 意向担保金额
    ,guarcompanyterm -- 担保公司推送期限
    ,comptaxgrade -- 企业纳税等级
    ,issignchange -- 经营情况是否发生重大变化
    ,isothersignclassify -- 是否存在其他重大风险
    ,batchcustomertype -- 批量授信客户类型
    ,ishxdanbaoloan -- 是否为华兴担保贷:1-是0-否
    ,enttermduedate -- 企业营业期限到期日
    ,hxdanbaocustomername -- 华兴担保贷担保公司名称
    ,hxdanbaocertid -- 华兴担保贷担保公司证件号码
    ,scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
    ,actualenttype -- 实际企业类型
    ,actualbusinesstype -- 实际业务类型
    ,externalstatus -- 外部数据状态
    ,externaldate -- 外部数据日期
    ,baseproducttype -- 基础资产类型
    ,baseproducttypeiscycle -- 基础资产是否涉及循环购买
    ,customerprojectrole -- 受信人项目角色
    ,isautomanagelimit -- 是否主动管理类额度
    ,customerproductrole -- 受信人在产品中的角色
    ,dbinvesttermmonth -- 单笔投资期限
    ,isbankbilldiscount -- 是否银票贴现
    ,creditmodel -- 额度类型
    ,actualbaseproducttype -- 资产证券化业务子类
    ,isstateenttype -- 是否国有企业标识(0否1是)
    ,iscityinvestbond -- 是否城投债(0否1是)
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno as serialno -- 流水号
    ,outclassifydate as outclassifydate -- 外部评级日期
    ,totalsumentpart as totalsumentpart -- 公司敞口金额(元)
    ,dlcdbz as dlcdbz -- 代理参贷标志
    ,investtarget as investtarget -- 投资标的
    ,othercondition as othercondition -- 额度使用条件
    ,iscreditincrement as iscreditincrement -- 是否有增信
    ,hxtymainratelevel as hxtymainratelevel -- 外部主体评级
    ,migtflag as migtflag -- 迁移标志：CRS RCR ILC UPL
    ,channelname as channelname -- 通道方名称
    ,isbillapply as isbillapply -- 是否新增银承额度专项贴现
    ,refbankname as refbankname -- 参贷行行号
    ,isgovernfinance as isgovernfinance -- 是否涉及政府类融资
    ,lngotimes as lngotimes -- 借新还旧次数
    ,mainlevelorg as mainlevelorg -- 主体评级机构
    ,singlebizmostamount as singlebizmostamount -- 额度下业务单笔最大金额
    ,riskexposuresum as riskexposuresum -- 其中，一般风险敞口限额
    ,nominalsum as nominalsum -- 额度名义金额
    ,isestatefinance as isestatefinance -- 是否涉及房地产融资
    ,bizextendedterm as bizextendedterm -- 额度下业务延展期限月)
    ,availableexposuresum as availableexposuresum -- 可用敞口金额
    ,islikeloan as islikeloan -- 是否类信贷
    ,publishsum as publishsum -- 本次发行金额
    ,bizmostmortgagerate as bizmostmortgagerate -- 额度下业务最高抵质押率
    ,isfinancialcredit as isfinancialcredit -- 是否商圈授信
    ,investway as investway -- 投资方式
    ,fundsource as fundsource -- 资金来源
    ,playtype as playtype -- 参与方式
    ,termtype as termtype -- 期限申请类型额度)
    ,lineclass as lineclass -- 额度种类综合/专项/其他)
    ,suremodel as suremodel -- 是否总行认定模式
    ,managename as managename -- 管理人名称
    ,manageid as manageid -- 管理人客户号
    ,istrans as istrans -- 是否转授信
    ,belonggroupapproveno as belonggroupapproveno -- 集团批复编号
    ,financialcreditowner as financialcreditowner -- 集群客户专项额度所有人
    ,issmeandretail as issmeandretail -- 是否我行小微企业并且走零售条线
    ,originalname as originalname -- 原始权益人名称
    ,ispubliccredit as ispubliccredit -- 是否公开授信额度)
    ,occupynominalsum as occupynominalsum -- 已用授信额度
    ,moneyindustryt as moneyindustryt -- 资金投向行业
    ,bizbailinitialrate as bizbailinitialrate -- 额度下业务初始保证金比例
    ,transcount as transcount -- 交易对手个数
    ,maxnominalamount as maxnominalamount -- 单一最高授信额度名义金额
    ,lowriskexposuresum as lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,bizlowestfloatrate as bizlowestfloatrate -- 额度下业务利率最低浮动
    ,occupyexposuresum as occupyexposuresum -- 已用敞口金额自动计算)
    ,totalsumtypart as totalsumtypart -- 同业敞口金额(元)
    ,linecontrolmode as linecontrolmode -- 集团额度管控模式超额分配/全额分配)
    ,latestusedate as latestusedate -- 额度最迟使用日期
    ,isgreenfinance as isgreenfinance -- 是否为绿色信贷融资
    ,otherlimitownerid as otherlimitownerid -- 他用额度所有人
    ,availablenominalsum as availablenominalsum -- 可用名义金额
    ,hostbankname as hostbankname -- 主办行行名
    ,authvouchtype as authvouchtype -- 授权权限_担保方式
    ,isquerycreditreport as isquerycreditreport -- 是否自动查询贷后报告
    ,mainleveldate as mainleveldate -- 主体评级日期
    ,usewithoutcondition as usewithoutcondition -- 能否直接使用额度)
    ,isbeltroadfinance as isbeltroadfinance -- 是否为一带一路建设投融资
    ,otherlimittype as otherlimittype -- 他用额度类型
    ,sqdkze as sqdkze -- 申请银团贷款总额(元)
    ,outclassifylevel as outclassifylevel -- 外部债项评级
    ,jxhjcontractno as jxhjcontractno -- 借新还旧原合同
    ,businesssumentpart as businesssumentpart -- 公司授信额度(元)
    ,currencyrange as currencyrange -- 项下业务币种范围
    ,isconsumerfinance as isconsumerfinance -- 是否为消费服务类融资
    ,drtimes as drtimes -- 债务重组次数
    ,exposuresum as exposuresum -- 额度敞口金额
    ,classifyresulteleven as classifyresulteleven -- 债项分类
    ,issuername as issuername -- 发行人名称
    ,financialcreditserialno as financialcreditserialno -- 集群客户专项额度流水号
    ,hxtyoperateorg as hxtyoperateorg -- 归口管理部门
    ,issme as issme -- 是否小微企业贷款
    ,hostbankno as hostbankno -- 主办行行号
    ,agentbankname as agentbankname -- 代理行行号
    ,otherlimitno as otherlimitno -- 他用额度流水号
    ,creditauthno as creditauthno -- 征信授权影像流水号
    ,agentbankno as agentbankno -- 代理行行号
    ,approvepubsum as approvepubsum -- 批准发行总额
    ,outclassifyorg as outclassifyorg -- 外部评级机构名称
    ,creditarea as creditarea -- 授信区域
    ,publicorg as publicorg -- 发行场所
    ,isyhcustomer as isyhcustomer -- 是否优合授信客户
    ,onlineamount as onlineamount -- 线上额度(元)
    ,refbankno as refbankno -- 参贷行行号
    ,otherlimitflag as otherlimitflag -- 是否占用他用额度
    ,hxtyclassifylevel as hxtyclassifylevel -- 债项分类
    ,businesssumtypart as businesssumtypart -- 同业授信额度(元)
    ,authostrdate as authostrdate -- 授权起始日
    ,bizlongestterm as bizlongestterm -- 额度下业务最长期限月)
    ,financialmodel as financialmodel -- 集群客户操作模式、风险管理及控制方案
    ,channelid as channelid -- 通道方编号
    ,maxexposureamount as maxexposureamount -- 单一最高授信额度敞口金额
    ,changetype as changetype -- 变更原因
    ,originalid as originalid -- 原始权益人编号
    ,issuernameid as issuernameid -- 发行人编号
    ,phaseopinion as phaseopinion -- 主动批量-授信方案意见
    ,finishflag as finishflag -- 主动批量-授信方案确认标志
    ,ispenetrate as ispenetrate -- 是否可穿透
    ,ifapprove as ifapprove -- 是否人工填写标志
    ,afterpayreq as afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,contractreq as contractreq -- 需落实到合同、协议中的特殊要求
    ,islikelowrisk as islikelowrisk -- 是否类低风险
    ,loanmanagereq as loanmanagereq -- 贷后管理要求
    ,payreq as payreq -- 授信方案
    ,focuslendtype as focuslendtype -- 集中放款业务类型
    ,isinnovate as isinnovate -- 是否创新业务
    ,issupplychainfinance as issupplychainfinance -- 是否供应链金融业务
    ,isprojectfinancing as isprojectfinancing -- 是否项目融资
    ,custraterisklevel as custraterisklevel -- 客户内评评级结果
    ,onlineapprovallimit as onlineapprovallimit -- 线上审批额度
    ,oastatus as oastatus -- OA审批状态
    ,isjoinlimits as isjoinlimits -- 是否纳入单一客户或集团的限额
    ,otherlimitamount as otherlimitamount -- 他用额度占用金额
    ,proborrowerattr as proborrowerattr -- 借款人属性
    ,proborrowerincome as proborrowerincome -- 借款人收入特征
    ,proborrowerdebt as proborrowerdebt -- 借款人偿债特征
    ,proassetscontrol as proassetscontrol -- 资产控制
    ,prorevenuecontrol as prorevenuecontrol -- 收入控制
    ,projfinancingtype as projfinancingtype -- 项目融资类型
    ,mercfinancingobject as mercfinancingobject -- 商品融资对象
    ,itemsfinancingtype as itemsfinancingtype -- 物品融资类型
    ,isonlineapprove as isonlineapprove -- 是否线上化审批
    ,guaranteecompanyname as guaranteecompanyname -- 见保即贷业务担保公司
    ,runentyearincome as runentyearincome -- 流水推算的年销售收入
    ,lastyearentyearincome as lastyearentyearincome -- 纳税申报资料反映的上年度收入
    ,yearincomerate as yearincomerate -- 预计销售收入年增长率
    ,operationloanbalanceskr as operationloanbalanceskr -- 实控人经营性贷款余额
    ,otherworkcaptial as otherworkcaptial -- 其他渠道提供的营运资金
    ,isrelatedcompany as isrelatedcompany -- 借款企业是否为担保公司的关联企业:1是0否
    ,subjectbusiness as subjectbusiness -- 主营业务
    ,enterpriseamt as enterpriseamt -- 借款企业在我行有效额度
    ,riskapproveamout as riskapproveamout -- 风控最终审批金额
    ,riskapprovestatus as riskapprovestatus -- 风控最终状态
    ,riskterm as riskterm -- 风控最终审批期限
    ,isbranchbusiness as isbranchbusiness -- 是否分行权限内业务
    ,bondingcompanyinamt as bondingcompanyinamt -- 意向担保金额
    ,guarcompanyterm as guarcompanyterm -- 担保公司推送期限
    ,comptaxgrade as comptaxgrade -- 企业纳税等级
    ,' ' as issignchange -- 经营情况是否发生重大变化
    ,' ' as isothersignclassify -- 是否存在其他重大风险
    ,' ' as batchcustomertype -- 批量授信客户类型
    ,' ' as ishxdanbaoloan -- 是否为华兴担保贷:1-是0-否
    ,to_date('00010101','yyyymmdd') as enttermduedate -- 企业营业期限到期日
    ,' ' as hxdanbaocustomername -- 华兴担保贷担保公司名称
    ,' ' as hxdanbaocertid -- 华兴担保贷担保公司证件号码
    ,' ' as scanstatus -- 扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
    ,' ' as actualenttype -- 实际企业类型
    ,' ' as actualbusinesstype -- 实际业务类型
    ,' ' as externalstatus -- 外部数据状态
    ,to_date('00010101','yyyymmdd') as externaldate -- 外部数据日期
    ,' ' as baseproducttype -- 基础资产类型
    ,' ' as baseproducttypeiscycle -- 基础资产是否涉及循环购买
    ,' ' as customerprojectrole -- 受信人项目角色
    ,' ' as isautomanagelimit -- 是否主动管理类额度
    ,' ' as customerproductrole -- 受信人在产品中的角色
    ,' ' as dbinvesttermmonth -- 单笔投资期限
    ,' ' as isbankbilldiscount -- 是否银票贴现
    ,' ' as creditmodel -- 额度类型
    ,' ' as actualbaseproducttype -- 资产证券化业务子类
    ,' ' as isstateenttype -- 是否国有企业标识(0否1是)
    ,' ' as iscityinvestbond -- 是否城投债(0否1是)
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ba_cl_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

