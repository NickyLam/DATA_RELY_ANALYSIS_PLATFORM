/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_apply(
    serialno varchar2(64) -- 授信编号流水号
    ,repaycycle varchar2(36) -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,productclassify varchar2(36) -- 产品所属大类
    ,intraindustrytype varchar2(64) -- 行内行业投向
    ,operateuserid varchar2(8) -- 经办人
    ,originflag varchar2(12) -- 信息类型信息类型(用于区分额度申请中是否为最外层额度信息)
    ,bailratio number(10,6) -- 保证金比例（%）
    ,risktype varchar2(36) -- 风险类型(额度)风险类型（一般、低风险）
    ,inputuserid varchar2(64) -- 登记人
    ,classifyresult varchar2(36) -- 风险分类结果（5级）
    ,overduerate number(15,8) -- 逾期执行利率
    ,baseratetype varchar2(5) -- 基准利率类型
    ,approvetype varchar2(36) -- 审批方式
    ,productid varchar2(32) -- 产品编号
    ,executerate number(15,8) -- 执行利率
    ,businessflag varchar2(6) -- 额度/业务标志
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,clno varchar2(64) -- 额度编号
    ,renewtotalsum number(24,6) -- 展期前金额
    ,currency varchar2(3) -- 额度/业务币种
    ,vouchtype2 varchar2(36) -- 担保方式2
    ,belongdept varchar2(36) -- 所属条线BelongDept
    ,occurdate date -- 发生日期
    ,operateorgid varchar2(64) -- 经办机构
    ,bailaccount varchar2(40) -- 保证金账号
    ,baserate number(15,8) -- 基准利率
    ,customerid varchar2(16) -- 客户编号
    ,settlementaccountname varchar2(80) -- 结算账户(还款账户)号
    ,remark varchar2(4000) -- 备注
    ,flowtype varchar2(64) -- 流程类型
    ,baseproduct varchar2(2000) -- 基础产品(额度)基础产品
    ,approvestatus varchar2(64) -- 审批状态
    ,termmonth number(22) -- 期限(月)
    ,additioncommand varchar2(1000) -- 其他条件和要求
    ,bailsum number(24,6) -- 保证金金额
    ,ratemodel varchar2(18) -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
    ,vouchtypeinner varchar2(2) -- 担保方式（内部口径）
    ,repaytype varchar2(4) -- 还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)
    ,programno varchar2(160) -- 关联重组方案编号
    ,customername varchar2(200) -- 客户名称
    ,rateadjusttype varchar2(4) -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,overdueratefloattype nvarchar2(36) -- 逾期利率浮动方式
    ,overdueratefloatvalue number(22,0) -- 逾期利率浮动值
    ,totalsum number(24,6) -- 额度敞口金额
    ,termday number(22) -- 期限(天)
    ,floatrange number(15,8) -- 浮动幅度
    ,renewexecuteyearrate number(10,6) -- 展期前执行年利率
    ,parentserialno varchar2(64) -- 上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)
    ,policyid varchar2(64) -- 产品政策编号
    ,maturity date -- 额度/业务到期日到期日
    ,rateadjustfrequency varchar2(72) -- 利率调整周期
    ,repaydate number(22) -- 指定还款日
    ,startdate date -- 额度/业务起始日起始日
    ,iscycle varchar2(3) -- 是否循环(额度)是否循环
    ,ratefloattype varchar2(36) -- 利率浮动类型浮动利率类型
    ,oldcontractno varchar2(32) -- 关联的旧的合同编号关联的旧的合同号
    ,payfrequencyunit varchar2(36) -- 指定周期单位
    ,relativeserialno varchar2(64) -- 关联流水号关联流水号(额度申请中最外层额度编号)
    ,loanaccountname varchar2(32) -- 入账账户名称
    ,vouchtype varchar2(1) -- 主要担保方式
    ,haveadditionalvouch varchar2(4) -- 有无追加担保方式
    ,updatedate date -- 更新日期
    ,classifydate date -- 风险分类日期
    ,putoutorgid varchar2(72) -- 出账机构编号(核心机构)
    ,nationalindustrytype varchar2(32) -- 国标行业投向
    ,occurtype varchar2(4) -- 发生类型
    ,organizetype varchar2(36) -- 授信组织方式01一般贷款2银团贷款)
    ,isremotebusiness varchar2(2) -- 是否异地业务
    ,islowrisk varchar2(2) -- 是否低风险业务
    ,othervouchtype varchar2(32) -- 其他担保方式
    ,sourceserialno varchar2(64) -- 源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)
    ,bailtransaccount varchar2(40) -- 保证金转出账号
    ,vouchtype3 varchar2(36) -- 担保方式3
    ,operatedate date -- 经办日期
    ,inputorgid varchar2(64) -- 登记机构
    ,loanusetype varchar2(6) -- 借款用途类型
    ,inputdate date -- 登记日期
    ,payfrequency number(22) -- 指定周期
    ,applytype varchar2(64) -- 申请类型申请类型(单一、集团、同业)
    ,settlementaccount varchar2(64) -- 结算账户(还款账户)名
    ,completeflag varchar2(2) -- 数据录入完整性标识
    ,policyversionid varchar2(64) -- 产品政策版本
    ,trueorfalse varchar2(1) -- 是否引入大数据
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,renewtermdate date -- 展期前到期日
    ,bailcurrency varchar2(18) -- 保证金币种
    ,loanaccountno varchar2(32) -- 入账账户
    ,classifyresulteleven varchar2(18) -- 风险分类结果（11级）
    ,loanaccountbankno varchar2(50) -- 入账账户开户行行号
    ,hascreateapprove varchar2(18) -- 是否登记批复
    ,reservesum number(24,6) -- 预留金额
    ,adjusttype varchar2(10) -- 调整类型(零售-额度调整码值：AdjustWay(冻结、解冻、终止))
    ,businesssum number(24,6) -- 申请金额
    ,pigeonholedate varchar2(10) -- 归档日期
    ,creditinvest varchar2(64) -- 授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
    ,purpose varchar2(1000) -- 用途
    ,fixedrate number(15,8) -- 固定利率
    ,corporgid varchar2(64) -- 法人机构编号
    ,migtoldvalue varchar2(250) -- 迁移数据-参数转换前字段值
    ,templeteno varchar2(48) -- 同业模板编号
    ,templeteurl varchar2(64) -- 同业模板页面路径
    ,vouchflag varchar2(2) -- 有无其他担保方式，HaveNot
    ,ratefloatratioorbp varchar2(1) -- 利率浮动类型（1-按比例2-按点差）
    ,ispensionindustry varchar2(10) -- 养老产业标识
    ,migtcustomerid varchar2(64) -- 转换前客户号
    ,migtbusinesstype varchar2(64) -- 转换前产品ID
    ,ratevaluemodel varchar2(18) -- 利率取值模式
    ,prdparametermodel number(15,8) -- 产品参数利率
    ,personalizationmodel number(15,8) -- 个性化利率
    ,childcustname varchar2(120) -- 子公司名称
    ,whethertorestructuretheloan varchar2(2) -- 是否重组贷款
    ,businessmodel varchar2(64) -- 业务模式
    ,precisionmarket varchar2(2) -- 精准营销识别信息是否齐全
    ,rateretail varchar2(2) -- 评级零售小企业标识 1-是 0-否
    ,subproductname varchar2(10) -- 子产品名称
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_business_apply to ${iml_schema};
grant select on ${iol_schema}.icms_business_apply to ${icl_schema};
grant select on ${iol_schema}.icms_business_apply to ${idl_schema};
grant select on ${iol_schema}.icms_business_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_apply is '业务申请基本信息表业务申请基本信息表';
comment on column ${iol_schema}.icms_business_apply.serialno is '授信编号流水号';
comment on column ${iol_schema}.icms_business_apply.repaycycle is '还款周期还款周期(1月2季3一次4半年5年6双月)';
comment on column ${iol_schema}.icms_business_apply.productclassify is '产品所属大类';
comment on column ${iol_schema}.icms_business_apply.intraindustrytype is '行内行业投向';
comment on column ${iol_schema}.icms_business_apply.operateuserid is '经办人';
comment on column ${iol_schema}.icms_business_apply.originflag is '信息类型信息类型(用于区分额度申请中是否为最外层额度信息)';
comment on column ${iol_schema}.icms_business_apply.bailratio is '保证金比例（%）';
comment on column ${iol_schema}.icms_business_apply.risktype is '风险类型(额度)风险类型（一般、低风险）';
comment on column ${iol_schema}.icms_business_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_business_apply.classifyresult is '风险分类结果（5级）';
comment on column ${iol_schema}.icms_business_apply.overduerate is '逾期执行利率';
comment on column ${iol_schema}.icms_business_apply.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_business_apply.approvetype is '审批方式';
comment on column ${iol_schema}.icms_business_apply.productid is '产品编号';
comment on column ${iol_schema}.icms_business_apply.executerate is '执行利率';
comment on column ${iol_schema}.icms_business_apply.businessflag is '额度/业务标志';
comment on column ${iol_schema}.icms_business_apply.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_business_apply.clno is '额度编号';
comment on column ${iol_schema}.icms_business_apply.renewtotalsum is '展期前金额';
comment on column ${iol_schema}.icms_business_apply.currency is '额度/业务币种';
comment on column ${iol_schema}.icms_business_apply.vouchtype2 is '担保方式2';
comment on column ${iol_schema}.icms_business_apply.belongdept is '所属条线BelongDept';
comment on column ${iol_schema}.icms_business_apply.occurdate is '发生日期';
comment on column ${iol_schema}.icms_business_apply.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_business_apply.bailaccount is '保证金账号';
comment on column ${iol_schema}.icms_business_apply.baserate is '基准利率';
comment on column ${iol_schema}.icms_business_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_business_apply.settlementaccountname is '结算账户(还款账户)号';
comment on column ${iol_schema}.icms_business_apply.remark is '备注';
comment on column ${iol_schema}.icms_business_apply.flowtype is '流程类型';
comment on column ${iol_schema}.icms_business_apply.baseproduct is '基础产品(额度)基础产品';
comment on column ${iol_schema}.icms_business_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_business_apply.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_business_apply.additioncommand is '其他条件和要求';
comment on column ${iol_schema}.icms_business_apply.bailsum is '保证金金额';
comment on column ${iol_schema}.icms_business_apply.ratemodel is '利率模式利率模式(1固定利率2浮动利率3组合利率)';
comment on column ${iol_schema}.icms_business_apply.vouchtypeinner is '担保方式（内部口径）';
comment on column ${iol_schema}.icms_business_apply.repaytype is '还款方式还款方式(01等额本金02等额本息03按期付息到期还款04标准按期付息到期还本（还款周期按季、半年、年还款日在3、6、9、12月）05利随本清06灵活等额本息07组合还款)';
comment on column ${iol_schema}.icms_business_apply.programno is '关联重组方案编号';
comment on column ${iol_schema}.icms_business_apply.customername is '客户名称';
comment on column ${iol_schema}.icms_business_apply.rateadjusttype is '利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)';
comment on column ${iol_schema}.icms_business_apply.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_business_apply.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${iol_schema}.icms_business_apply.totalsum is '额度敞口金额';
comment on column ${iol_schema}.icms_business_apply.termday is '期限(天)';
comment on column ${iol_schema}.icms_business_apply.floatrange is '浮动幅度';
comment on column ${iol_schema}.icms_business_apply.renewexecuteyearrate is '展期前执行年利率';
comment on column ${iol_schema}.icms_business_apply.parentserialno is '上层节点流水号上层节点流水号(该节点在额度、子额度、业务层级中对应的上层流水号)';
comment on column ${iol_schema}.icms_business_apply.policyid is '产品政策编号';
comment on column ${iol_schema}.icms_business_apply.maturity is '额度/业务到期日到期日';
comment on column ${iol_schema}.icms_business_apply.rateadjustfrequency is '利率调整周期';
comment on column ${iol_schema}.icms_business_apply.repaydate is '指定还款日';
comment on column ${iol_schema}.icms_business_apply.startdate is '额度/业务起始日起始日';
comment on column ${iol_schema}.icms_business_apply.iscycle is '是否循环(额度)是否循环';
comment on column ${iol_schema}.icms_business_apply.ratefloattype is '利率浮动类型浮动利率类型';
comment on column ${iol_schema}.icms_business_apply.oldcontractno is '关联的旧的合同编号关联的旧的合同号';
comment on column ${iol_schema}.icms_business_apply.payfrequencyunit is '指定周期单位';
comment on column ${iol_schema}.icms_business_apply.relativeserialno is '关联流水号关联流水号(额度申请中最外层额度编号)';
comment on column ${iol_schema}.icms_business_apply.loanaccountname is '入账账户名称';
comment on column ${iol_schema}.icms_business_apply.vouchtype is '主要担保方式';
comment on column ${iol_schema}.icms_business_apply.haveadditionalvouch is '有无追加担保方式';
comment on column ${iol_schema}.icms_business_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_business_apply.classifydate is '风险分类日期';
comment on column ${iol_schema}.icms_business_apply.putoutorgid is '出账机构编号(核心机构)';
comment on column ${iol_schema}.icms_business_apply.nationalindustrytype is '国标行业投向';
comment on column ${iol_schema}.icms_business_apply.occurtype is '发生类型';
comment on column ${iol_schema}.icms_business_apply.organizetype is '授信组织方式01一般贷款2银团贷款)';
comment on column ${iol_schema}.icms_business_apply.isremotebusiness is '是否异地业务';
comment on column ${iol_schema}.icms_business_apply.islowrisk is '是否低风险业务';
comment on column ${iol_schema}.icms_business_apply.othervouchtype is '其他担保方式';
comment on column ${iol_schema}.icms_business_apply.sourceserialno is '源信息流水号源信息流水号(拷贝得到该i条信息的源信息流水号，用于痕迹保留)';
comment on column ${iol_schema}.icms_business_apply.bailtransaccount is '保证金转出账号';
comment on column ${iol_schema}.icms_business_apply.vouchtype3 is '担保方式3';
comment on column ${iol_schema}.icms_business_apply.operatedate is '经办日期';
comment on column ${iol_schema}.icms_business_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_business_apply.loanusetype is '借款用途类型';
comment on column ${iol_schema}.icms_business_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_business_apply.payfrequency is '指定周期';
comment on column ${iol_schema}.icms_business_apply.applytype is '申请类型申请类型(单一、集团、同业)';
comment on column ${iol_schema}.icms_business_apply.settlementaccount is '结算账户(还款账户)名';
comment on column ${iol_schema}.icms_business_apply.completeflag is '数据录入完整性标识';
comment on column ${iol_schema}.icms_business_apply.policyversionid is '产品政策版本';
comment on column ${iol_schema}.icms_business_apply.trueorfalse is '是否引入大数据';
comment on column ${iol_schema}.icms_business_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_business_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_business_apply.renewtermdate is '展期前到期日';
comment on column ${iol_schema}.icms_business_apply.bailcurrency is '保证金币种';
comment on column ${iol_schema}.icms_business_apply.loanaccountno is '入账账户';
comment on column ${iol_schema}.icms_business_apply.classifyresulteleven is '风险分类结果（11级）';
comment on column ${iol_schema}.icms_business_apply.loanaccountbankno is '入账账户开户行行号';
comment on column ${iol_schema}.icms_business_apply.hascreateapprove is '是否登记批复';
comment on column ${iol_schema}.icms_business_apply.reservesum is '预留金额';
comment on column ${iol_schema}.icms_business_apply.adjusttype is '调整类型(零售-额度调整码值：AdjustWay(冻结、解冻、终止))';
comment on column ${iol_schema}.icms_business_apply.businesssum is '申请金额';
comment on column ${iol_schema}.icms_business_apply.pigeonholedate is '归档日期';
comment on column ${iol_schema}.icms_business_apply.creditinvest is '授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)';
comment on column ${iol_schema}.icms_business_apply.purpose is '用途';
comment on column ${iol_schema}.icms_business_apply.fixedrate is '固定利率';
comment on column ${iol_schema}.icms_business_apply.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_business_apply.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${iol_schema}.icms_business_apply.templeteno is '同业模板编号';
comment on column ${iol_schema}.icms_business_apply.templeteurl is '同业模板页面路径';
comment on column ${iol_schema}.icms_business_apply.vouchflag is '有无其他担保方式，HaveNot';
comment on column ${iol_schema}.icms_business_apply.ratefloatratioorbp is '利率浮动类型（1-按比例2-按点差）';
comment on column ${iol_schema}.icms_business_apply.ispensionindustry is '养老产业标识';
comment on column ${iol_schema}.icms_business_apply.migtcustomerid is '转换前客户号';
comment on column ${iol_schema}.icms_business_apply.migtbusinesstype is '转换前产品ID';
comment on column ${iol_schema}.icms_business_apply.ratevaluemodel is '利率取值模式';
comment on column ${iol_schema}.icms_business_apply.prdparametermodel is '产品参数利率';
comment on column ${iol_schema}.icms_business_apply.personalizationmodel is '个性化利率';
comment on column ${iol_schema}.icms_business_apply.childcustname is '子公司名称';
comment on column ${iol_schema}.icms_business_apply.whethertorestructuretheloan is '是否重组贷款';
comment on column ${iol_schema}.icms_business_apply.businessmodel is '业务模式';
comment on column ${iol_schema}.icms_business_apply.precisionmarket is '精准营销识别信息是否齐全';
comment on column ${iol_schema}.icms_business_apply.rateretail is '评级零售小企业标识 1-是 0-否';
comment on column ${iol_schema}.icms_business_apply.subproductname is '子产品名称';
comment on column ${iol_schema}.icms_business_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_apply.etl_timestamp is 'ETL处理时间戳';
