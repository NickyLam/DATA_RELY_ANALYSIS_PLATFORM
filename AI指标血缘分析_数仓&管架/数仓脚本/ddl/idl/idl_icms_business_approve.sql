/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_business_approve
CreateDate: 20250527
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_business_approve purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_business_approve(
etl_dt date --数据日期
,serialno varchar2(64) --批复编号流水号
,baserialno varchar2(64) --申请编号
,originflag varchar2(12) --信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
,relativeserialno varchar2(64) --关联流水号关联流水号(额度申请中最外层额度编号)
,parentserialno varchar2(64) --上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
,sourceserialno varchar2(64) --源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
,customerid varchar2(16) --客户编号
,customername varchar2(200) --客户名称
,applytype varchar2(64) --申请类型申请类型(单一、集团、同业)
,flowtype varchar2(64) --流程类型
,businessflag varchar2(6) --额度/业务标志
,occurtype varchar2(4) --贷款发放类型
,occurdate date --发生日期
,currency varchar2(3) --额度/业务币种
,businesssum number(24,6) --授信额度
,baseproduct varchar2(2000) --基础产品(额度)基础产品
,productid varchar2(32) --产品编号
,policyid varchar2(64) --产品政策编号
,policyversionid varchar2(64) --产品政策版本
,productclassify varchar2(36) --产品所属大类
,termmonth number(22) --期限(月)
,termday number(22) --期限(天)
,startdate date --额度/业务起始日起始日
,maturity date --额度/业务到期日到期日
,isremotebusiness varchar2(2) --是否异地业务
,iscycle varchar2(2) --是否循环(额度)是否循环
,risktype varchar2(36) --风险类型(额度)风险类型（一般、低风险）
,islowrisk varchar2(36) --是否低风险业务
,creditinvest varchar2(64) --授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
,nationalindustrytype varchar2(5) --贷款投向行业
,intraindustrytype varchar2(64) --行内行业投向
,purpose varchar2(1000) --用途
,ratemodel varchar2(18) --利率模式利率模式(1固定利率2浮动利率3组合利率)
,fixedrate number(15,8) --固定利率
,baseratetype varchar2(5) --基准利率类型
,baserate number(15,8) --基准利率
,ratefloattype varchar2(36) --利率浮动方式
,rateadjusttype varchar2(4) --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
,floatrange number(10,6) --浮动幅度
,executerate number(15,8) --执行利率
,vouchtype varchar2(1) --主担保方式
,haveadditionalvouch varchar2(2) --有无追加担保方式
,othervouchtype varchar2(32) --其他担保方式
,additioncommand varchar2(1000) --其他条件和要求
,repaytype varchar2(4) --还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
,repaycycle varchar2(36) --还款周期还款周期(1月2季3一次4半年5年6双月)
,repaydate number(22) --指定还款日
,reservesum number(24,6) --预留金额
,oldcontractno varchar2(64) --关联的旧合同关联的旧的合同号
,clno varchar2(64) --额度编号
,contractflag varchar2(12) --生成合同标志
,approvestatus varchar2(64) --审批状态
,approvetype varchar2(36) --审批方式
,finalapproveopinion varchar2(4000) --最终审批意见
,remark varchar2(4000) --备注
,completeflag varchar2(2) --数据录入完整性标识
,operateuserid varchar2(8) --业务经办人编号
,operateorgid varchar2(64) --经办机构
,operatedate date --经办日期
,inputuserid varchar2(64) --登记人
,inputorgid varchar2(64) --登记机构
,inputdate date --登记日期
,updateuserid varchar2(64) --更新人
,updateorgid varchar2(64) --更新机构
,updatedate date --更新日期
,belongdept varchar2(36) --所属条线BelongDept
,corporgid varchar2(64) --法人机构编号
,payfrequencyunit varchar2(36) --指定周期单位
,payfrequency number(22) --指定周期
,renewtermdate date --展期前到期日
,renewtotalsum number(24,6) --展期前金额
,renewexecuteyearrate number(10,6) --展期前执行年利率
,loanusetype varchar2(6) --贷款用途
,vouchtype2 varchar2(36) --担保方式2
,vouchtype3 varchar2(36) --担保方式3
,organizetype varchar2(36) --授信组织方式01一般贷款2银团贷款)
,totalsum number(24,6) --额度敞口金额
,vouchtypeinner varchar2(36) --担保方式（内部口径）
,pigeonholedate varchar2(10) --归档日期
,classifyresulteleven varchar2(18) --风险分类结果（11级）
,reinforceflag varchar2(5) --补登标志
,status varchar2(3) --生效标志
,classifyresult varchar2(72) --贷款五级分类
,classifydate date --风险分类日期
,bailaccount varchar2(80) --保证金账号
,bailtransaccount varchar2(80) --保证金转出账号
,bailcurrency varchar2(36) --保证金币种
,bailratio number(10,6) --保证金比例（%）
,bailsum number(24,6) --保证金金额
,rateadjustfrequency varchar2(72) --利率调整周期
,overduerate number(15,8) --逾期执行利率
,overdueratefloattype varchar2(72) --逾期利率浮动方式
,overdueratefloatvalue number(10,6) --逾期利率浮动值
,settlementaccountname varchar2(160) --结算账户(还款账户)名
,loanaccountno varchar2(64) --入账账户
,settlementaccount varchar2(128) --结算账号
,migtflag varchar2(80) --迁移标志：crs rcr ilc upl
,migtcustomerid varchar2(64) --转换前客户号
,migtbusinesstype varchar2(64) --转换前产品ID
,migtoldvalue varchar2(250) --迁移数据-参数转换前字段值
,checkyearstatus varchar2(2) --年审进行状态
,vouchflag varchar2(2) --有无其他担保方式，HaveNot
,ratefloatratioorbp varchar2(1) --利率浮动类型（1-按比例2-按点差）
,effectdate date --生效日期
,serialnocn varchar2(100) --中文批复编号
,ispensionindustry varchar2(10) --养老产业标识
,isyeartocheck varchar2(4) --是否需要年审
,sqcheckyeardate date --上期年审日期
,bqcheckyeardate date --本期年审日期
,templeteno varchar2(48) --同业模板编号
,templeteurl varchar2(64) --同业模板页面路径
,whethertorestructuretheloan varchar2(2) --是否重组贷款
,subproductname varchar2(10) --子产品名称

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_business_approve to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_business_approve is '业务审批基本信息表';
comment on column ${idl_schema}.icms_business_approve.etl_dt is '数据日期';
comment on column ${idl_schema}.icms_business_approve.serialno is '批复编号流水号';
comment on column ${idl_schema}.icms_business_approve.baserialno is '申请编号';
comment on column ${idl_schema}.icms_business_approve.originflag is '信息类型信息类型(用于区分额度申请中是否为最外层额度信息)';
comment on column ${idl_schema}.icms_business_approve.relativeserialno is '关联流水号关联流水号(额度申请中最外层额度编号)';
comment on column ${idl_schema}.icms_business_approve.parentserialno is '上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)';
comment on column ${idl_schema}.icms_business_approve.sourceserialno is '源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)';
comment on column ${idl_schema}.icms_business_approve.customerid is '客户编号';
comment on column ${idl_schema}.icms_business_approve.customername is '客户名称';
comment on column ${idl_schema}.icms_business_approve.applytype is '申请类型申请类型(单一、集团、同业)';
comment on column ${idl_schema}.icms_business_approve.flowtype is '流程类型';
comment on column ${idl_schema}.icms_business_approve.businessflag is '额度/业务标志';
comment on column ${idl_schema}.icms_business_approve.occurtype is '贷款发放类型';
comment on column ${idl_schema}.icms_business_approve.occurdate is '发生日期';
comment on column ${idl_schema}.icms_business_approve.currency is '额度/业务币种';
comment on column ${idl_schema}.icms_business_approve.businesssum is '授信额度';
comment on column ${idl_schema}.icms_business_approve.baseproduct is '基础产品(额度)基础产品';
comment on column ${idl_schema}.icms_business_approve.productid is '产品编号';
comment on column ${idl_schema}.icms_business_approve.policyid is '产品政策编号';
comment on column ${idl_schema}.icms_business_approve.policyversionid is '产品政策版本';
comment on column ${idl_schema}.icms_business_approve.productclassify is '产品所属大类';
comment on column ${idl_schema}.icms_business_approve.termmonth is '期限(月)';
comment on column ${idl_schema}.icms_business_approve.termday is '期限(天)';
comment on column ${idl_schema}.icms_business_approve.startdate is '额度/业务起始日起始日';
comment on column ${idl_schema}.icms_business_approve.maturity is '额度/业务到期日到期日';
comment on column ${idl_schema}.icms_business_approve.isremotebusiness is '是否异地业务';
comment on column ${idl_schema}.icms_business_approve.iscycle is '是否循环(额度)是否循环';
comment on column ${idl_schema}.icms_business_approve.risktype is '风险类型(额度)风险类型（一般、低风险）';
comment on column ${idl_schema}.icms_business_approve.islowrisk is '是否低风险业务';
comment on column ${idl_schema}.icms_business_approve.creditinvest is '授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)';
comment on column ${idl_schema}.icms_business_approve.nationalindustrytype is '贷款投向行业';
comment on column ${idl_schema}.icms_business_approve.intraindustrytype is '行内行业投向';
comment on column ${idl_schema}.icms_business_approve.purpose is '用途';
comment on column ${idl_schema}.icms_business_approve.ratemodel is '利率模式利率模式(1固定利率2浮动利率3组合利率)';
comment on column ${idl_schema}.icms_business_approve.fixedrate is '固定利率';
comment on column ${idl_schema}.icms_business_approve.baseratetype is '基准利率类型';
comment on column ${idl_schema}.icms_business_approve.baserate is '基准利率';
comment on column ${idl_schema}.icms_business_approve.ratefloattype is '利率浮动方式';
comment on column ${idl_schema}.icms_business_approve.rateadjusttype is '利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)';
comment on column ${idl_schema}.icms_business_approve.floatrange is '浮动幅度';
comment on column ${idl_schema}.icms_business_approve.executerate is '执行利率';
comment on column ${idl_schema}.icms_business_approve.vouchtype is '主担保方式';
comment on column ${idl_schema}.icms_business_approve.haveadditionalvouch is '有无追加担保方式';
comment on column ${idl_schema}.icms_business_approve.othervouchtype is '其他担保方式';
comment on column ${idl_schema}.icms_business_approve.additioncommand is '其他条件和要求';
comment on column ${idl_schema}.icms_business_approve.repaytype is '还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)';
comment on column ${idl_schema}.icms_business_approve.repaycycle is '还款周期还款周期(1月2季3一次4半年5年6双月)';
comment on column ${idl_schema}.icms_business_approve.repaydate is '指定还款日';
comment on column ${idl_schema}.icms_business_approve.reservesum is '预留金额';
comment on column ${idl_schema}.icms_business_approve.oldcontractno is '关联的旧合同关联的旧的合同号';
comment on column ${idl_schema}.icms_business_approve.clno is '额度编号';
comment on column ${idl_schema}.icms_business_approve.contractflag is '生成合同标志';
comment on column ${idl_schema}.icms_business_approve.approvestatus is '审批状态';
comment on column ${idl_schema}.icms_business_approve.approvetype is '审批方式';
comment on column ${idl_schema}.icms_business_approve.finalapproveopinion is '最终审批意见';
comment on column ${idl_schema}.icms_business_approve.remark is '备注';
comment on column ${idl_schema}.icms_business_approve.completeflag is '数据录入完整性标识';
comment on column ${idl_schema}.icms_business_approve.operateuserid is '业务经办人编号';
comment on column ${idl_schema}.icms_business_approve.operateorgid is '经办机构';
comment on column ${idl_schema}.icms_business_approve.operatedate is '经办日期';
comment on column ${idl_schema}.icms_business_approve.inputuserid is '登记人';
comment on column ${idl_schema}.icms_business_approve.inputorgid is '登记机构';
comment on column ${idl_schema}.icms_business_approve.inputdate is '登记日期';
comment on column ${idl_schema}.icms_business_approve.updateuserid is '更新人';
comment on column ${idl_schema}.icms_business_approve.updateorgid is '更新机构';
comment on column ${idl_schema}.icms_business_approve.updatedate is '更新日期';
comment on column ${idl_schema}.icms_business_approve.belongdept is '所属条线BelongDept';
comment on column ${idl_schema}.icms_business_approve.corporgid is '法人机构编号';
comment on column ${idl_schema}.icms_business_approve.payfrequencyunit is '指定周期单位';
comment on column ${idl_schema}.icms_business_approve.payfrequency is '指定周期';
comment on column ${idl_schema}.icms_business_approve.renewtermdate is '展期前到期日';
comment on column ${idl_schema}.icms_business_approve.renewtotalsum is '展期前金额';
comment on column ${idl_schema}.icms_business_approve.renewexecuteyearrate is '展期前执行年利率';
comment on column ${idl_schema}.icms_business_approve.loanusetype is '贷款用途';
comment on column ${idl_schema}.icms_business_approve.vouchtype2 is '担保方式2';
comment on column ${idl_schema}.icms_business_approve.vouchtype3 is '担保方式3';
comment on column ${idl_schema}.icms_business_approve.organizetype is '授信组织方式01一般贷款2银团贷款)';
comment on column ${idl_schema}.icms_business_approve.totalsum is '额度敞口金额';
comment on column ${idl_schema}.icms_business_approve.vouchtypeinner is '担保方式（内部口径）';
comment on column ${idl_schema}.icms_business_approve.pigeonholedate is '归档日期';
comment on column ${idl_schema}.icms_business_approve.classifyresulteleven is '风险分类结果（11级）';
comment on column ${idl_schema}.icms_business_approve.reinforceflag is '补登标志';
comment on column ${idl_schema}.icms_business_approve.status is '生效标志';
comment on column ${idl_schema}.icms_business_approve.classifyresult is '贷款五级分类';
comment on column ${idl_schema}.icms_business_approve.classifydate is '风险分类日期';
comment on column ${idl_schema}.icms_business_approve.bailaccount is '保证金账号';
comment on column ${idl_schema}.icms_business_approve.bailtransaccount is '保证金转出账号';
comment on column ${idl_schema}.icms_business_approve.bailcurrency is '保证金币种';
comment on column ${idl_schema}.icms_business_approve.bailratio is '保证金比例（%）';
comment on column ${idl_schema}.icms_business_approve.bailsum is '保证金金额';
comment on column ${idl_schema}.icms_business_approve.rateadjustfrequency is '利率调整周期';
comment on column ${idl_schema}.icms_business_approve.overduerate is '逾期执行利率';
comment on column ${idl_schema}.icms_business_approve.overdueratefloattype is '逾期利率浮动方式';
comment on column ${idl_schema}.icms_business_approve.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${idl_schema}.icms_business_approve.settlementaccountname is '结算账户(还款账户)名';
comment on column ${idl_schema}.icms_business_approve.loanaccountno is '入账账户';
comment on column ${idl_schema}.icms_business_approve.settlementaccount is '结算账号';
comment on column ${idl_schema}.icms_business_approve.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_business_approve.migtcustomerid is '转换前客户号';
comment on column ${idl_schema}.icms_business_approve.migtbusinesstype is '转换前产品ID';
comment on column ${idl_schema}.icms_business_approve.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${idl_schema}.icms_business_approve.checkyearstatus is '年审进行状态';
comment on column ${idl_schema}.icms_business_approve.vouchflag is '有无其他担保方式，HaveNot';
comment on column ${idl_schema}.icms_business_approve.ratefloatratioorbp is '利率浮动类型（1-按比例2-按点差）';
comment on column ${idl_schema}.icms_business_approve.effectdate is '生效日期';
comment on column ${idl_schema}.icms_business_approve.serialnocn is '中文批复编号';
comment on column ${idl_schema}.icms_business_approve.ispensionindustry is '养老产业标识';
comment on column ${idl_schema}.icms_business_approve.isyeartocheck is '是否需要年审';
comment on column ${idl_schema}.icms_business_approve.sqcheckyeardate is '上期年审日期';
comment on column ${idl_schema}.icms_business_approve.bqcheckyeardate is '本期年审日期';
comment on column ${idl_schema}.icms_business_approve.templeteno is '同业模板编号';
comment on column ${idl_schema}.icms_business_approve.templeteurl is '同业模板页面路径';
comment on column ${idl_schema}.icms_business_approve.whethertorestructuretheloan is '是否重组贷款';
comment on column ${idl_schema}.icms_business_approve.subproductname is '子产品名称';

