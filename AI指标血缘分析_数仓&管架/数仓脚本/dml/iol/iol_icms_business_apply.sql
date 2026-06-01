/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_apply
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_business_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_apply_op purge;
drop table ${iol_schema}.icms_business_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_apply where 0=1;

create table ${iol_schema}.icms_business_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_apply_cl(
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
    else
        into ${iol_schema}.icms_business_apply_op(
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
    nvl(n.serialno, o.serialno) as serialno -- 授信编号流水号
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,nvl(n.productclassify, o.productclassify) as productclassify -- 产品所属大类
    ,nvl(n.intraindustrytype, o.intraindustrytype) as intraindustrytype -- 行内行业投向
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.originflag, o.originflag) as originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
    ,nvl(n.bailratio, o.bailratio) as bailratio -- 保证金比例（%）
    ,nvl(n.risktype, o.risktype) as risktype -- 风险类型(额度)风险类型（一般、低风险）
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 风险分类结果（5级）
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期执行利率
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.approvetype, o.approvetype) as approvetype -- 审批方式
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 额度/业务标志
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.clno, o.clno) as clno -- 额度编号
    ,nvl(n.renewtotalsum, o.renewtotalsum) as renewtotalsum -- 展期前金额
    ,nvl(n.currency, o.currency) as currency -- 额度/业务币种
    ,nvl(n.vouchtype2, o.vouchtype2) as vouchtype2 -- 担保方式2
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线BelongDept
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.bailaccount, o.bailaccount) as bailaccount -- 保证金账号
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.settlementaccountname, o.settlementaccountname) as settlementaccountname -- 结算账户(还款账户)号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.flowtype, o.flowtype) as flowtype -- 流程类型
    ,nvl(n.baseproduct, o.baseproduct) as baseproduct -- 基础产品(额度)基础产品
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.additioncommand, o.additioncommand) as additioncommand -- 其他条件和要求
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 保证金金额
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,nvl(n.vouchtypeinner, o.vouchtypeinner) as vouchtypeinner -- 担保方式（内部口径）
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
    ,nvl(n.programno, o.programno) as programno -- 关联重组方案编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动值
    ,nvl(n.totalsum, o.totalsum) as totalsum -- 额度敞口金额
    ,nvl(n.termday, o.termday) as termday -- 期限(天)
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 浮动幅度
    ,nvl(n.renewexecuteyearrate, o.renewexecuteyearrate) as renewexecuteyearrate -- 展期前执行年利率
    ,nvl(n.parentserialno, o.parentserialno) as parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
    ,nvl(n.policyid, o.policyid) as policyid -- 产品政策编号
    ,nvl(n.maturity, o.maturity) as maturity -- 额度/业务到期日到期日
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 指定还款日
    ,nvl(n.startdate, o.startdate) as startdate -- 额度/业务起始日起始日
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 是否循环(额度)是否循环
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动类型浮动利率类型
    ,nvl(n.oldcontractno, o.oldcontractno) as oldcontractno -- 关联的旧的合同编号关联的旧的合同号
    ,nvl(n.payfrequencyunit, o.payfrequencyunit) as payfrequencyunit -- 指定周期单位
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
    ,nvl(n.loanaccountname, o.loanaccountname) as loanaccountname -- 入账账户名称
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主要担保方式
    ,nvl(n.haveadditionalvouch, o.haveadditionalvouch) as haveadditionalvouch -- 有无追加担保方式
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.classifydate, o.classifydate) as classifydate -- 风险分类日期
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 出账机构编号(核心机构)
    ,nvl(n.nationalindustrytype, o.nationalindustrytype) as nationalindustrytype -- 国标行业投向
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生类型
    ,nvl(n.organizetype, o.organizetype) as organizetype -- 授信组织方式01一般贷款2银团贷款)
    ,nvl(n.isremotebusiness, o.isremotebusiness) as isremotebusiness -- 是否异地业务
    ,nvl(n.islowrisk, o.islowrisk) as islowrisk -- 是否低风险业务
    ,nvl(n.othervouchtype, o.othervouchtype) as othervouchtype -- 其他担保方式
    ,nvl(n.sourceserialno, o.sourceserialno) as sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
    ,nvl(n.bailtransaccount, o.bailtransaccount) as bailtransaccount -- 保证金转出账号
    ,nvl(n.vouchtype3, o.vouchtype3) as vouchtype3 -- 担保方式3
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 借款用途类型
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.payfrequency, o.payfrequency) as payfrequency -- 指定周期
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型申请类型(单一、集团、同业)
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账户(还款账户)名
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性标识
    ,nvl(n.policyversionid, o.policyversionid) as policyversionid -- 产品政策版本
    ,nvl(n.trueorfalse, o.trueorfalse) as trueorfalse -- 是否引入大数据
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.renewtermdate, o.renewtermdate) as renewtermdate -- 展期前到期日
    ,nvl(n.bailcurrency, o.bailcurrency) as bailcurrency -- 保证金币种
    ,nvl(n.loanaccountno, o.loanaccountno) as loanaccountno -- 入账账户
    ,nvl(n.classifyresulteleven, o.classifyresulteleven) as classifyresulteleven -- 风险分类结果（11级）
    ,nvl(n.loanaccountbankno, o.loanaccountbankno) as loanaccountbankno -- 入账账户开户行行号
    ,nvl(n.hascreateapprove, o.hascreateapprove) as hascreateapprove -- 是否登记批复
    ,nvl(n.reservesum, o.reservesum) as reservesum -- 预留金额
    ,nvl(n.adjusttype, o.adjusttype) as adjusttype -- 调整类型(零售-额度调整码值：AdjustWay(冻结、解冻、终止))
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 申请金额
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.creditinvest, o.creditinvest) as creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.fixedrate, o.fixedrate) as fixedrate -- 固定利率
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.templeteno, o.templeteno) as templeteno -- 同业模板编号
    ,nvl(n.templeteurl, o.templeteurl) as templeteurl -- 同业模板页面路径
    ,nvl(n.vouchflag, o.vouchflag) as vouchflag -- 有无其他担保方式，HaveNot
    ,nvl(n.ratefloatratioorbp, o.ratefloatratioorbp) as ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,nvl(n.ispensionindustry, o.ispensionindustry) as ispensionindustry -- 养老产业标识
    ,nvl(n.migtcustomerid, o.migtcustomerid) as migtcustomerid -- 转换前客户号
    ,nvl(n.migtbusinesstype, o.migtbusinesstype) as migtbusinesstype -- 转换前产品ID
    ,nvl(n.ratevaluemodel, o.ratevaluemodel) as ratevaluemodel -- 利率取值模式
    ,nvl(n.prdparametermodel, o.prdparametermodel) as prdparametermodel -- 产品参数利率
    ,nvl(n.personalizationmodel, o.personalizationmodel) as personalizationmodel -- 个性化利率
    ,nvl(n.childcustname, o.childcustname) as childcustname -- 子公司名称
    ,nvl(n.whethertorestructuretheloan, o.whethertorestructuretheloan) as whethertorestructuretheloan -- 是否重组贷款
    ,nvl(n.businessmodel, o.businessmodel) as businessmodel -- 业务模式
    ,nvl(n.precisionmarket, o.precisionmarket) as precisionmarket -- 精准营销识别信息是否齐全
    ,nvl(n.rateretail, o.rateretail) as rateretail -- 评级零售小企业标识 1-是 0-否
    ,nvl(n.subproductname, o.subproductname) as subproductname -- 子产品名称
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_business_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.repaycycle <> n.repaycycle
        or o.productclassify <> n.productclassify
        or o.intraindustrytype <> n.intraindustrytype
        or o.operateuserid <> n.operateuserid
        or o.originflag <> n.originflag
        or o.bailratio <> n.bailratio
        or o.risktype <> n.risktype
        or o.inputuserid <> n.inputuserid
        or o.classifyresult <> n.classifyresult
        or o.overduerate <> n.overduerate
        or o.baseratetype <> n.baseratetype
        or o.approvetype <> n.approvetype
        or o.productid <> n.productid
        or o.executerate <> n.executerate
        or o.businessflag <> n.businessflag
        or o.migtflag <> n.migtflag
        or o.clno <> n.clno
        or o.renewtotalsum <> n.renewtotalsum
        or o.currency <> n.currency
        or o.vouchtype2 <> n.vouchtype2
        or o.belongdept <> n.belongdept
        or o.occurdate <> n.occurdate
        or o.operateorgid <> n.operateorgid
        or o.bailaccount <> n.bailaccount
        or o.baserate <> n.baserate
        or o.customerid <> n.customerid
        or o.settlementaccountname <> n.settlementaccountname
        or o.remark <> n.remark
        or o.flowtype <> n.flowtype
        or o.baseproduct <> n.baseproduct
        or o.approvestatus <> n.approvestatus
        or o.termmonth <> n.termmonth
        or o.additioncommand <> n.additioncommand
        or o.bailsum <> n.bailsum
        or o.ratemodel <> n.ratemodel
        or o.vouchtypeinner <> n.vouchtypeinner
        or o.repaytype <> n.repaytype
        or o.programno <> n.programno
        or o.customername <> n.customername
        or o.rateadjusttype <> n.rateadjusttype
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.totalsum <> n.totalsum
        or o.termday <> n.termday
        or o.floatrange <> n.floatrange
        or o.renewexecuteyearrate <> n.renewexecuteyearrate
        or o.parentserialno <> n.parentserialno
        or o.policyid <> n.policyid
        or o.maturity <> n.maturity
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.repaydate <> n.repaydate
        or o.startdate <> n.startdate
        or o.iscycle <> n.iscycle
        or o.ratefloattype <> n.ratefloattype
        or o.oldcontractno <> n.oldcontractno
        or o.payfrequencyunit <> n.payfrequencyunit
        or o.relativeserialno <> n.relativeserialno
        or o.loanaccountname <> n.loanaccountname
        or o.vouchtype <> n.vouchtype
        or o.haveadditionalvouch <> n.haveadditionalvouch
        or o.updatedate <> n.updatedate
        or o.classifydate <> n.classifydate
        or o.putoutorgid <> n.putoutorgid
        or o.nationalindustrytype <> n.nationalindustrytype
        or o.occurtype <> n.occurtype
        or o.organizetype <> n.organizetype
        or o.isremotebusiness <> n.isremotebusiness
        or o.islowrisk <> n.islowrisk
        or o.othervouchtype <> n.othervouchtype
        or o.sourceserialno <> n.sourceserialno
        or o.bailtransaccount <> n.bailtransaccount
        or o.vouchtype3 <> n.vouchtype3
        or o.operatedate <> n.operatedate
        or o.inputorgid <> n.inputorgid
        or o.loanusetype <> n.loanusetype
        or o.inputdate <> n.inputdate
        or o.payfrequency <> n.payfrequency
        or o.applytype <> n.applytype
        or o.settlementaccount <> n.settlementaccount
        or o.completeflag <> n.completeflag
        or o.policyversionid <> n.policyversionid
        or o.trueorfalse <> n.trueorfalse
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.renewtermdate <> n.renewtermdate
        or o.bailcurrency <> n.bailcurrency
        or o.loanaccountno <> n.loanaccountno
        or o.classifyresulteleven <> n.classifyresulteleven
        or o.loanaccountbankno <> n.loanaccountbankno
        or o.hascreateapprove <> n.hascreateapprove
        or o.reservesum <> n.reservesum
        or o.adjusttype <> n.adjusttype
        or o.businesssum <> n.businesssum
        or o.pigeonholedate <> n.pigeonholedate
        or o.creditinvest <> n.creditinvest
        or o.purpose <> n.purpose
        or o.fixedrate <> n.fixedrate
        or o.corporgid <> n.corporgid
        or o.migtoldvalue <> n.migtoldvalue
        or o.templeteno <> n.templeteno
        or o.templeteurl <> n.templeteurl
        or o.vouchflag <> n.vouchflag
        or o.ratefloatratioorbp <> n.ratefloatratioorbp
        or o.ispensionindustry <> n.ispensionindustry
        or o.migtcustomerid <> n.migtcustomerid
        or o.migtbusinesstype <> n.migtbusinesstype
        or o.ratevaluemodel <> n.ratevaluemodel
        or o.prdparametermodel <> n.prdparametermodel
        or o.personalizationmodel <> n.personalizationmodel
        or o.childcustname <> n.childcustname
        or o.whethertorestructuretheloan <> n.whethertorestructuretheloan
        or o.businessmodel <> n.businessmodel
        or o.precisionmarket <> n.precisionmarket
        or o.rateretail <> n.rateretail
        or o.subproductname <> n.subproductname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_apply_cl(
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
    else
        into ${iol_schema}.icms_business_apply_op(
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
    o.serialno -- 授信编号流水号
    ,o.repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,o.productclassify -- 产品所属大类
    ,o.intraindustrytype -- 行内行业投向
    ,o.operateuserid -- 经办人
    ,o.originflag -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
    ,o.bailratio -- 保证金比例（%）
    ,o.risktype -- 风险类型(额度)风险类型（一般、低风险）
    ,o.inputuserid -- 登记人
    ,o.classifyresult -- 风险分类结果（5级）
    ,o.overduerate -- 逾期执行利率
    ,o.baseratetype -- 基准利率类型
    ,o.approvetype -- 审批方式
    ,o.productid -- 产品编号
    ,o.executerate -- 执行利率
    ,o.businessflag -- 额度/业务标志
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.clno -- 额度编号
    ,o.renewtotalsum -- 展期前金额
    ,o.currency -- 额度/业务币种
    ,o.vouchtype2 -- 担保方式2
    ,o.belongdept -- 所属条线BelongDept
    ,o.occurdate -- 发生日期
    ,o.operateorgid -- 经办机构
    ,o.bailaccount -- 保证金账号
    ,o.baserate -- 基准利率
    ,o.customerid -- 客户编号
    ,o.settlementaccountname -- 结算账户(还款账户)号
    ,o.remark -- 备注
    ,o.flowtype -- 流程类型
    ,o.baseproduct -- 基础产品(额度)基础产品
    ,o.approvestatus -- 审批状态
    ,o.termmonth -- 期限(月)
    ,o.additioncommand -- 其他条件和要求
    ,o.bailsum -- 保证金金额
    ,o.ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,o.vouchtypeinner -- 担保方式（内部口径）
    ,o.repaytype -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
    ,o.programno -- 关联重组方案编号
    ,o.customername -- 客户名称
    ,o.rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动值
    ,o.totalsum -- 额度敞口金额
    ,o.termday -- 期限(天)
    ,o.floatrange -- 浮动幅度
    ,o.renewexecuteyearrate -- 展期前执行年利率
    ,o.parentserialno -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
    ,o.policyid -- 产品政策编号
    ,o.maturity -- 额度/业务到期日到期日
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.repaydate -- 指定还款日
    ,o.startdate -- 额度/业务起始日起始日
    ,o.iscycle -- 是否循环(额度)是否循环
    ,o.ratefloattype -- 利率浮动类型浮动利率类型
    ,o.oldcontractno -- 关联的旧的合同编号关联的旧的合同号
    ,o.payfrequencyunit -- 指定周期单位
    ,o.relativeserialno -- 关联流水号关联流水号(额度申请中最外层额度编号)
    ,o.loanaccountname -- 入账账户名称
    ,o.vouchtype -- 主要担保方式
    ,o.haveadditionalvouch -- 有无追加担保方式
    ,o.updatedate -- 更新日期
    ,o.classifydate -- 风险分类日期
    ,o.putoutorgid -- 出账机构编号(核心机构)
    ,o.nationalindustrytype -- 国标行业投向
    ,o.occurtype -- 发生类型
    ,o.organizetype -- 授信组织方式01一般贷款2银团贷款)
    ,o.isremotebusiness -- 是否异地业务
    ,o.islowrisk -- 是否低风险业务
    ,o.othervouchtype -- 其他担保方式
    ,o.sourceserialno -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
    ,o.bailtransaccount -- 保证金转出账号
    ,o.vouchtype3 -- 担保方式3
    ,o.operatedate -- 经办日期
    ,o.inputorgid -- 登记机构
    ,o.loanusetype -- 借款用途类型
    ,o.inputdate -- 登记日期
    ,o.payfrequency -- 指定周期
    ,o.applytype -- 申请类型申请类型(单一、集团、同业)
    ,o.settlementaccount -- 结算账户(还款账户)名
    ,o.completeflag -- 数据录入完整性标识
    ,o.policyversionid -- 产品政策版本
    ,o.trueorfalse -- 是否引入大数据
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.renewtermdate -- 展期前到期日
    ,o.bailcurrency -- 保证金币种
    ,o.loanaccountno -- 入账账户
    ,o.classifyresulteleven -- 风险分类结果（11级）
    ,o.loanaccountbankno -- 入账账户开户行行号
    ,o.hascreateapprove -- 是否登记批复
    ,o.reservesum -- 预留金额
    ,o.adjusttype -- 调整类型(零售-额度调整码值：AdjustWay(冻结、解冻、终止))
    ,o.businesssum -- 申请金额
    ,o.pigeonholedate -- 归档日期
    ,o.creditinvest -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,o.purpose -- 用途
    ,o.fixedrate -- 固定利率
    ,o.corporgid -- 法人机构编号
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.templeteno -- 同业模板编号
    ,o.templeteurl -- 同业模板页面路径
    ,o.vouchflag -- 有无其他担保方式，HaveNot
    ,o.ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
    ,o.ispensionindustry -- 养老产业标识
    ,o.migtcustomerid -- 转换前客户号
    ,o.migtbusinesstype -- 转换前产品ID
    ,o.ratevaluemodel -- 利率取值模式
    ,o.prdparametermodel -- 产品参数利率
    ,o.personalizationmodel -- 个性化利率
    ,o.childcustname -- 子公司名称
    ,o.whethertorestructuretheloan -- 是否重组贷款
    ,o.businessmodel -- 业务模式
    ,o.precisionmarket -- 精准营销识别信息是否齐全
    ,o.rateretail -- 评级零售小企业标识 1-是 0-否
    ,o.subproductname -- 子产品名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_business_apply_bk o
    left join ${iol_schema}.icms_business_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_apply_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_business_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_business_apply_cl;
alter table ${iol_schema}.icms_business_apply exchange partition p_20991231 with table ${iol_schema}.icms_business_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_apply_op purge;
drop table ${iol_schema}.icms_business_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
