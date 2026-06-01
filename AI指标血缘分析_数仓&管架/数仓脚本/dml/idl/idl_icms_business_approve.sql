/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_business_approve
CreateDate: 20250527
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_business_approve drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_business_approve add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_business_approve (
etl_dt  --数据日期
,serialno  --批复编号流水号
,baserialno  --申请编号
,originflag  --信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
,relativeserialno  --关联流水号关联流水号(额度申请中最外层额度编号)
,parentserialno  --上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
,sourceserialno  --源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
,customerid  --客户编号
,customername  --客户名称
,applytype  --申请类型申请类型(单一、集团、同业)
,flowtype  --流程类型
,businessflag  --额度/业务标志
,occurtype  --贷款发放类型
,occurdate  --发生日期
,currency  --额度/业务币种
,businesssum  --授信额度
,baseproduct  --基础产品(额度)基础产品
,productid  --产品编号
,policyid  --产品政策编号
,policyversionid  --产品政策版本
,productclassify  --产品所属大类
,termmonth  --期限(月)
,termday  --期限(天)
,startdate  --额度/业务起始日起始日
,maturity  --额度/业务到期日到期日
,isremotebusiness  --是否异地业务
,iscycle  --是否循环(额度)是否循环
,risktype  --风险类型(额度)风险类型（一般、低风险）
,islowrisk  --是否低风险业务
,creditinvest  --授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
,nationalindustrytype  --贷款投向行业
,intraindustrytype  --行内行业投向
,purpose  --用途
,ratemodel  --利率模式利率模式(1固定利率2浮动利率3组合利率)
,fixedrate  --固定利率
,baseratetype  --基准利率类型
,baserate  --基准利率
,ratefloattype  --利率浮动方式
,rateadjusttype  --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
,floatrange  --浮动幅度
,executerate  --执行利率
,vouchtype  --主担保方式
,haveadditionalvouch  --有无追加担保方式
,othervouchtype  --其他担保方式
,additioncommand  --其他条件和要求
,repaytype  --还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
,repaycycle  --还款周期还款周期(1月2季3一次4半年5年6双月)
,repaydate  --指定还款日
,reservesum  --预留金额
,oldcontractno  --关联的旧合同关联的旧的合同号
,clno  --额度编号
,contractflag  --生成合同标志
,approvestatus  --审批状态
,approvetype  --审批方式
,finalapproveopinion  --最终审批意见
,remark  --备注
,completeflag  --数据录入完整性标识
,operateuserid  --业务经办人编号
,operateorgid  --经办机构
,operatedate  --经办日期
,inputuserid  --登记人
,inputorgid  --登记机构
,inputdate  --登记日期
,updateuserid  --更新人
,updateorgid  --更新机构
,updatedate  --更新日期
,belongdept  --所属条线BelongDept
,corporgid  --法人机构编号
,payfrequencyunit  --指定周期单位
,payfrequency  --指定周期
,renewtermdate  --展期前到期日
,renewtotalsum  --展期前金额
,renewexecuteyearrate  --展期前执行年利率
,loanusetype  --贷款用途
,vouchtype2  --担保方式2
,vouchtype3  --担保方式3
,organizetype  --授信组织方式01一般贷款2银团贷款)
,totalsum  --额度敞口金额
,vouchtypeinner  --担保方式（内部口径）
,pigeonholedate  --归档日期
,classifyresulteleven  --风险分类结果（11级）
,reinforceflag  --补登标志
,status  --生效标志
,classifyresult  --贷款五级分类
,classifydate  --风险分类日期
,bailaccount  --保证金账号
,bailtransaccount  --保证金转出账号
,bailcurrency  --保证金币种
,bailratio  --保证金比例（%）
,bailsum  --保证金金额
,rateadjustfrequency  --利率调整周期
,overduerate  --逾期执行利率
,overdueratefloattype  --逾期利率浮动方式
,overdueratefloatvalue  --逾期利率浮动值
,settlementaccountname  --结算账户(还款账户)名
,loanaccountno  --入账账户
,settlementaccount  --结算账号
,migtflag  --迁移标志：crs rcr ilc upl
,migtcustomerid  --转换前客户号
,migtbusinesstype  --转换前产品ID
,migtoldvalue  --迁移数据-参数转换前字段值
,checkyearstatus  --年审进行状态
,vouchflag  --有无其他担保方式，HaveNot
,ratefloatratioorbp  --利率浮动类型（1-按比例2-按点差）
,effectdate  --生效日期
,serialnocn  --中文批复编号
,ispensionindustry  --养老产业标识
,isyeartocheck  --是否需要年审
,sqcheckyeardate  --上期年审日期
,bqcheckyeardate  --本期年审日期
,templeteno  --同业模板编号
,templeteurl  --同业模板页面路径
,whethertorestructuretheloan  --是否重组贷款
,subproductname  --子产品名称

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --批复编号流水号
,replace(replace(t1.baserialno,chr(13),''),chr(10),'') as baserialno --申请编号
,replace(replace(t1.originflag,chr(13),''),chr(10),'') as originflag --信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'') as relativeserialno --关联流水号关联流水号(额度申请中最外层额度编号)
,replace(replace(t1.parentserialno,chr(13),''),chr(10),'') as parentserialno --上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
,replace(replace(t1.sourceserialno,chr(13),''),chr(10),'') as sourceserialno --源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid --客户编号
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername --客户名称
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype --申请类型申请类型(单一、集团、同业)
,replace(replace(t1.flowtype,chr(13),''),chr(10),'') as flowtype --流程类型
,replace(replace(t1.businessflag,chr(13),''),chr(10),'') as businessflag --额度/业务标志
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype --贷款发放类型
,t1.occurdate as occurdate --发生日期
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency --额度/业务币种
,t1.businesssum as businesssum --授信额度
,replace(replace(t1.baseproduct,chr(13),''),chr(10),'') as baseproduct --基础产品(额度)基础产品
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid --产品编号
,replace(replace(t1.policyid,chr(13),''),chr(10),'') as policyid --产品政策编号
,replace(replace(t1.policyversionid,chr(13),''),chr(10),'') as policyversionid --产品政策版本
,replace(replace(t1.productclassify,chr(13),''),chr(10),'') as productclassify --产品所属大类
,t1.termmonth as termmonth --期限(月)
,t1.termday as termday --期限(天)
,t1.startdate as startdate --额度/业务起始日起始日
,t1.maturity as maturity --额度/业务到期日到期日
,replace(replace(t1.isremotebusiness,chr(13),''),chr(10),'') as isremotebusiness --是否异地业务
,replace(replace(t1.iscycle,chr(13),''),chr(10),'') as iscycle --是否循环(额度)是否循环
,replace(replace(t1.risktype,chr(13),''),chr(10),'') as risktype --风险类型(额度)风险类型（一般、低风险）
,replace(replace(t1.islowrisk,chr(13),''),chr(10),'') as islowrisk --是否低风险业务
,replace(replace(t1.creditinvest,chr(13),''),chr(10),'') as creditinvest --授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
,replace(replace(t1.nationalindustrytype,chr(13),''),chr(10),'') as nationalindustrytype --贷款投向行业
,replace(replace(t1.intraindustrytype,chr(13),''),chr(10),'') as intraindustrytype --行内行业投向
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose --用途
,replace(replace(t1.ratemodel,chr(13),''),chr(10),'') as ratemodel --利率模式利率模式(1固定利率2浮动利率3组合利率)
,t1.fixedrate as fixedrate --固定利率
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype --基准利率类型
,t1.baserate as baserate --基准利率
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype --利率浮动方式
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
,t1.floatrange as floatrange --浮动幅度
,t1.executerate as executerate --执行利率
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype --主担保方式
,replace(replace(t1.haveadditionalvouch,chr(13),''),chr(10),'') as haveadditionalvouch --有无追加担保方式
,replace(replace(t1.othervouchtype,chr(13),''),chr(10),'') as othervouchtype --其他担保方式
,replace(replace(t1.additioncommand,chr(13),''),chr(10),'') as additioncommand --其他条件和要求
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype --还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle --还款周期还款周期(1月2季3一次4半年5年6双月)
,t1.repaydate as repaydate --指定还款日
,t1.reservesum as reservesum --预留金额
,replace(replace(t1.oldcontractno,chr(13),''),chr(10),'') as oldcontractno --关联的旧合同关联的旧的合同号
,replace(replace(t1.clno,chr(13),''),chr(10),'') as clno --额度编号
,replace(replace(t1.contractflag,chr(13),''),chr(10),'') as contractflag --生成合同标志
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus --审批状态
,replace(replace(t1.approvetype,chr(13),''),chr(10),'') as approvetype --审批方式
,replace(replace(t1.finalapproveopinion,chr(13),''),chr(10),'') as finalapproveopinion --最终审批意见
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag --数据录入完整性标识
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid --业务经办人编号
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid --经办机构
,t1.operatedate as operatedate --经办日期
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,t1.updatedate as updatedate --更新日期
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept --所属条线BelongDept
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid --法人机构编号
,replace(replace(t1.payfrequencyunit,chr(13),''),chr(10),'') as payfrequencyunit --指定周期单位
,t1.payfrequency as payfrequency --指定周期
,t1.renewtermdate as renewtermdate --展期前到期日
,t1.renewtotalsum as renewtotalsum --展期前金额
,t1.renewexecuteyearrate as renewexecuteyearrate --展期前执行年利率
,replace(replace(t1.loanusetype,chr(13),''),chr(10),'') as loanusetype --贷款用途
,replace(replace(t1.vouchtype2,chr(13),''),chr(10),'') as vouchtype2 --担保方式2
,replace(replace(t1.vouchtype3,chr(13),''),chr(10),'') as vouchtype3 --担保方式3
,replace(replace(t1.organizetype,chr(13),''),chr(10),'') as organizetype --授信组织方式01一般贷款2银团贷款)
,t1.totalsum as totalsum --额度敞口金额
,replace(replace(t1.vouchtypeinner,chr(13),''),chr(10),'') as vouchtypeinner --担保方式（内部口径）
,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'') as pigeonholedate --归档日期
,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'') as classifyresulteleven --风险分类结果（11级）
,replace(replace(t1.reinforceflag,chr(13),''),chr(10),'') as reinforceflag --补登标志
,replace(replace(t1.status,chr(13),''),chr(10),'') as status --生效标志
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult --贷款五级分类
,t1.classifydate as classifydate --风险分类日期
,replace(replace(t1.bailaccount,chr(13),''),chr(10),'') as bailaccount --保证金账号
,replace(replace(t1.bailtransaccount,chr(13),''),chr(10),'') as bailtransaccount --保证金转出账号
,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'') as bailcurrency --保证金币种
,t1.bailratio as bailratio --保证金比例（%）
,t1.bailsum as bailsum --保证金金额
,replace(replace(t1.rateadjustfrequency,chr(13),''),chr(10),'') as rateadjustfrequency --利率调整周期
,t1.overduerate as overduerate --逾期执行利率
,replace(replace(t1.overdueratefloattype,chr(13),''),chr(10),'') as overdueratefloattype --逾期利率浮动方式
,t1.overdueratefloatvalue as overdueratefloatvalue --逾期利率浮动值
,replace(replace(t1.settlementaccountname,chr(13),''),chr(10),'') as settlementaccountname --结算账户(还款账户)名
,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'') as loanaccountno --入账账户
,replace(replace(t1.settlementaccount,chr(13),''),chr(10),'') as settlementaccount --结算账号
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.migtcustomerid,chr(13),''),chr(10),'') as migtcustomerid --转换前客户号
,replace(replace(t1.migtbusinesstype,chr(13),''),chr(10),'') as migtbusinesstype --转换前产品ID
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue --迁移数据-参数转换前字段值
,replace(replace(t1.checkyearstatus,chr(13),''),chr(10),'') as checkyearstatus --年审进行状态
,replace(replace(t1.vouchflag,chr(13),''),chr(10),'') as vouchflag --有无其他担保方式，HaveNot
,replace(replace(t1.ratefloatratioorbp,chr(13),''),chr(10),'') as ratefloatratioorbp --利率浮动类型（1-按比例2-按点差）
,t1.effectdate as effectdate --生效日期
,replace(replace(t1.serialnocn,chr(13),''),chr(10),'') as serialnocn --中文批复编号
,replace(replace(t1.ispensionindustry,chr(13),''),chr(10),'') as ispensionindustry --养老产业标识
,replace(replace(t1.isyeartocheck,chr(13),''),chr(10),'') as isyeartocheck --是否需要年审
,t1.sqcheckyeardate as sqcheckyeardate --上期年审日期
,t1.bqcheckyeardate as bqcheckyeardate --本期年审日期
,replace(replace(t1.templeteno,chr(13),''),chr(10),'') as templeteno --同业模板编号
,replace(replace(t1.templeteurl,chr(13),''),chr(10),'') as templeteurl --同业模板页面路径
,replace(replace(t1.whethertorestructuretheloan,chr(13),''),chr(10),'') as whethertorestructuretheloan --是否重组贷款
,replace(replace(t1.subproductname,chr(13),''),chr(10),'') as subproductname --子产品名称
from ${iol_schema}.icms_business_approve t1    --业务审批基本信息表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_business_approve',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
