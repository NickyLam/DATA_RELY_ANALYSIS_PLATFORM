/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_business_contract
CreateDate: 20240924
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_business_contract purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_business_contract(
etl_dt date --ETL处理日期
,currency varchar2(3) --额度/业务币种
,businesssum number(24,6) --合同金额
,putoutsum number(24,6) --实际出账金额
,putoutdate date --出账日期
,baseproduct varchar2(2000) --基础产品(额度);基础产品
,productid varchar2(32) --产品编号
,policyid varchar2(64) --产品政策编号
,policyversionid varchar2(64) --产品政策版本编号
,productclassify varchar2(36) --产品所属大类
,termmonth number(22) --期限(月)
,termday number(22) --期限(天)
,startdate date --合同起始日
,maturity date --合同到期日
,iscycle varchar2(5) --是否循环(额度);是否循环
,risktype varchar2(36) --风险类型(额度);风险类型（一般、低风险）
,islowrisk varchar2(2) --是否低风险业务
,isremotebusiness varchar2(2) --是否异地业务
,ratemodel varchar2(18) --利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
,fixedrate number(15,8) --固定利率
,baseratetype varchar2(5) --基准利率类型
,baserate number(15,8) --基准利率
,ratefloattype varchar2(36) --利率浮动类型;浮动利率类型
,rateadjusttype varchar2(4) --利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
,floatrange number(15,8) --浮动幅度
,executerate number(15,8) --执行利率
,vouchtype varchar2(1) --主要担保方式
,haveadditionalvouch varchar2(2) --有无追加担保方式
,othervouchtype varchar2(32) --其他担保方式
,additioncommand varchar2(1000) --其他条件和要求
,repaytype varchar2(4) --还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
,repaycycle varchar2(36) --还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
,repaydate number(22) --指定还款日
,settlementaccount varchar2(32) --结算账号
,paymenttype varchar2(36) --支付方式
,creditinvest varchar2(64) --授信投向;授信投向(01绿色贷款；02两高一剩（可多选）；03ppp贷款)
,nationalindustrytype varchar2(5) --国标行业投向
,intraindustrytype varchar2(64) --行内行业投向
,purpose varchar2(1000) --用途
,reservesum number(24,6) --预留金额
,balance number(24,6) --合同余额
,normalbalance number(24,6) --正常余额
,overduebalance number(24,6) --逾期/垫款金额
,dullbalance number(24,6) --呆滞余额
,badbalance number(24,6) --呆账余额
,innerinterestbalance number(24,6) --表内欠息余额
,outerinterestbalance number(24,6) --表外欠息余额
,capitalpenaltybalance number(24,6) --逾期罚息余额
,interestpenaltybalance number(24,6) --复息余额
,overduedays number(22) --逾期天数
,owninterestdays number(22) --欠息天数
,graceperiod number(22) --贷款宽限期
,cancelsum number(24,6) --核销本金
,cancelinterest number(24,6) --核销利息
,predictlostsum number(24,6) --预测损失金额
,reducereservesum number(24,6) --计提准备金额
,badconfirmdate date --首次认定不良日期
,classifyresult varchar2(2) --风险分类结果（五级）
,classifydate date --风险分类日期
,status varchar2(48) --合同状态
,finishdate date --终结日期
,finishtype varchar2(64) --终结类型
,finishflag varchar2(2) --结清标志
,contracttype varchar2(36) --合同类型;合同类型(一般合同/虚拟合同)
,offsheetflag varchar2(36) --表内外标志
,belongdept varchar2(36) --所属条线
,completeflag varchar2(2) --数据录入完整性标识
,flowtype varchar2(64) --流程类型
,approvestatus varchar2(64) --审批状态
,clno varchar2(64) --额度编号
,cleffectstatus varchar2(36) --额度续作状态
,remark varchar2(3000) --备注
,operateuserid varchar2(8) --经办人
,operateorgid varchar2(64) --经办机构
,operatedate date --经办日期
,inputuserid varchar2(64) --登记人
,inputorgid varchar2(64) --登记机构
,inputdate date --登记日期
,updateuserid varchar2(64) --更新人
,updateorgid varchar2(64) --更新机构
,updatedate date --更新日期
,reinforceflag varchar2(12) --补充标志
,corporgid varchar2(64) --法人机构编号
,payfrequencyunit varchar2(36) --指定周期单位
,payfrequency number(22) --指定周期
,renewtermdate date --展期前到期日
,renewtotalsum number(24,6) --展期前金额
,renewexecuteyearrate number(10,6) --展期前执行年利率
,isbankrel varchar2(4) --是否我行关联方
,vouchtype3 varchar2(8) --主要担保方式3
,vouchtype2 varchar2(8) --主要担保方式2
,loanusetype varchar2(6) --借款用途类型
,totalsum number(24,6) --额度敞口金额
,outstndlmt number(24,6) --已占用额度
,bailratio number(10,6) --保证金比例（%）
,bailsum number(24,6) --保证金金额
,totalbalance number(24,6) --敞口余额(元)
,creditaggreement varchar2(64) --额度协议流水号
,vouchtypeinner varchar2(36) --担保方式（内部口径）
,executemonthrate number(10,6) --执行月利率
,classifyresulteleven varchar2(36) --风险分类结果（11级）
,oldcreditaggreement varchar2(32) --使用授信协议号(备份额度合同流水号)
,pigeonholedate varchar2(20) --归档日期
,freezeflag varchar2(2) --冻结标志
,rateadjustfrequency varchar2(72) --利率调整周期
,overduerate number(15,8) --逾期执行利率
,overdueratefloattype varchar2(72) --逾期利率浮动方式
,overdueratefloatvalue number(22) --逾期利率浮动值
,putoutorgid varchar2(64) --出账机构编号(核心机构)
,settlementaccountname varchar2(160) --结算账户(还款账户)名
,loanaccountno varchar2(64) --入账账户
,loanaccountname varchar2(160) --贷款入账(收款账户)账户名
,loanaccountorgid varchar2(64) --贷款入账(收款账户)账户开户机构
,serialno varchar2(30) --合同编号
,bapserialno varchar2(64) --批复编号
,relacontractno varchar2(64) --关联合同编号
,artificialno varchar2(300) --文本合同编号
,customerid varchar2(16) --客户编号
,customername varchar2(200) --客户名称
,businessflag varchar2(6) --额度/业务标志
,oldcontractno varchar2(64) --关联的旧合同号
,applytype varchar2(64) --申请类型
,occurtype varchar2(4) --发生类型
,occurdate date --发生日期
,start_dt date --开始日期
,end_dt date --结束日期
,id_mark varchar2(10) --删除标识
,remart varchar2(20) --计量标记
,bailcurrency varchar2(18) --保证金币种
,authostrdate varchar2(20) --授权起始日
,creditauthno varchar2(40) --征信授权影像流水号
,migtflag varchar2(80) --迁移标志：crs rcr ilc upl
,bailaccount varchar2(40) --保证金帐号
,occupycreditbapserialno varchar2(32) --他用额度批复流水号
,bailtransaccount varchar2(40) --保证金转出账号
,occupycredittype varchar2(18) --他用额度类型
,ispagercontract varchar2(1) --是否签署纸质合同
,manageuserid varchar2(32) --贷后管理人员
,manageorgid varchar2(32) --贷后管理机构
,isquerycreditreport varchar2(10) --是否自动查询贷后报告
,isoccupycredit varchar2(1) --是否占用他用额度
,oldstatus varchar2(3) --备份生效标志
,isonlinebusiness varchar2(4) --是否线上业务：yes-是no/空-否
,migtoldvalue varchar2(250) --迁移数据-参数转换前字段值
,contractnobeforeextend varchar2(32) --展期前合同
,pdgratio number(24,6) --手续费比率
,pdgsum number(24,6) --手续费金额
,templeteurl varchar2(64) --同业模板页面路径
,templeteno varchar2(48) --同业模板编号
,migtcustomerid varchar2(64) --转换前客户号
,migtbusinesstype varchar2(64) --转换前产品ID
,vouchflag varchar2(2) --有无其他担保方式，HaveNot
,ratefloatratioorbp varchar2(1) --利率浮动类型（1-按比例2-按点差）
,issignedcontract varchar2(2) --是否签订额度合同
,useexposuretype varchar2(20) --

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_business_contract to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_business_contract is '合同信息表';

comment on column ${idl_schema}.icms_business_contract.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.icms_business_contract.currency is '额度/业务币种';
comment on column ${idl_schema}.icms_business_contract.businesssum is '合同金额';
comment on column ${idl_schema}.icms_business_contract.putoutsum is '实际出账金额';
comment on column ${idl_schema}.icms_business_contract.putoutdate is '出账日期';
comment on column ${idl_schema}.icms_business_contract.baseproduct is '基础产品(额度);基础产品';
comment on column ${idl_schema}.icms_business_contract.productid is '产品编号';
comment on column ${idl_schema}.icms_business_contract.policyid is '产品政策编号';
comment on column ${idl_schema}.icms_business_contract.policyversionid is '产品政策版本编号';
comment on column ${idl_schema}.icms_business_contract.productclassify is '产品所属大类';
comment on column ${idl_schema}.icms_business_contract.termmonth is '期限(月)';
comment on column ${idl_schema}.icms_business_contract.termday is '期限(天)';
comment on column ${idl_schema}.icms_business_contract.startdate is '合同起始日';
comment on column ${idl_schema}.icms_business_contract.maturity is '合同到期日';
comment on column ${idl_schema}.icms_business_contract.iscycle is '是否循环(额度);是否循环';
comment on column ${idl_schema}.icms_business_contract.risktype is '风险类型(额度);风险类型（一般、低风险）';
comment on column ${idl_schema}.icms_business_contract.islowrisk is '是否低风险业务';
comment on column ${idl_schema}.icms_business_contract.isremotebusiness is '是否异地业务';
comment on column ${idl_schema}.icms_business_contract.ratemodel is '利率模式;利率模式(1固定利率；2浮动利率；3组合利率)';
comment on column ${idl_schema}.icms_business_contract.fixedrate is '固定利率';
comment on column ${idl_schema}.icms_business_contract.baseratetype is '基准利率类型';
comment on column ${idl_schema}.icms_business_contract.baserate is '基准利率';
comment on column ${idl_schema}.icms_business_contract.ratefloattype is '利率浮动类型;浮动利率类型';
comment on column ${idl_schema}.icms_business_contract.rateadjusttype is '利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)';
comment on column ${idl_schema}.icms_business_contract.floatrange is '浮动幅度';
comment on column ${idl_schema}.icms_business_contract.executerate is '执行利率';
comment on column ${idl_schema}.icms_business_contract.vouchtype is '主要担保方式';
comment on column ${idl_schema}.icms_business_contract.haveadditionalvouch is '有无追加担保方式';
comment on column ${idl_schema}.icms_business_contract.othervouchtype is '其他担保方式';
comment on column ${idl_schema}.icms_business_contract.additioncommand is '其他条件和要求';
comment on column ${idl_schema}.icms_business_contract.repaytype is '还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)';
comment on column ${idl_schema}.icms_business_contract.repaycycle is '还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)';
comment on column ${idl_schema}.icms_business_contract.repaydate is '指定还款日';
comment on column ${idl_schema}.icms_business_contract.settlementaccount is '结算账号';
comment on column ${idl_schema}.icms_business_contract.paymenttype is '支付方式';
comment on column ${idl_schema}.icms_business_contract.creditinvest is '授信投向;授信投向(01绿色贷款；02两高一剩（可多选）；03ppp贷款)';
comment on column ${idl_schema}.icms_business_contract.nationalindustrytype is '国标行业投向';
comment on column ${idl_schema}.icms_business_contract.intraindustrytype is '行内行业投向';
comment on column ${idl_schema}.icms_business_contract.purpose is '用途';
comment on column ${idl_schema}.icms_business_contract.reservesum is '预留金额';
comment on column ${idl_schema}.icms_business_contract.balance is '合同余额';
comment on column ${idl_schema}.icms_business_contract.normalbalance is '正常余额';
comment on column ${idl_schema}.icms_business_contract.overduebalance is '逾期/垫款金额';
comment on column ${idl_schema}.icms_business_contract.dullbalance is '呆滞余额';
comment on column ${idl_schema}.icms_business_contract.badbalance is '呆账余额';
comment on column ${idl_schema}.icms_business_contract.innerinterestbalance is '表内欠息余额';
comment on column ${idl_schema}.icms_business_contract.outerinterestbalance is '表外欠息余额';
comment on column ${idl_schema}.icms_business_contract.capitalpenaltybalance is '逾期罚息余额';
comment on column ${idl_schema}.icms_business_contract.interestpenaltybalance is '复息余额';
comment on column ${idl_schema}.icms_business_contract.overduedays is '逾期天数';
comment on column ${idl_schema}.icms_business_contract.owninterestdays is '欠息天数';
comment on column ${idl_schema}.icms_business_contract.graceperiod is '贷款宽限期';
comment on column ${idl_schema}.icms_business_contract.cancelsum is '核销本金';
comment on column ${idl_schema}.icms_business_contract.cancelinterest is '核销利息';
comment on column ${idl_schema}.icms_business_contract.predictlostsum is '预测损失金额';
comment on column ${idl_schema}.icms_business_contract.reducereservesum is '计提准备金额';
comment on column ${idl_schema}.icms_business_contract.badconfirmdate is '首次认定不良日期';
comment on column ${idl_schema}.icms_business_contract.classifyresult is '风险分类结果（五级）';
comment on column ${idl_schema}.icms_business_contract.classifydate is '风险分类日期';
comment on column ${idl_schema}.icms_business_contract.status is '合同状态';
comment on column ${idl_schema}.icms_business_contract.finishdate is '终结日期';
comment on column ${idl_schema}.icms_business_contract.finishtype is '终结类型';
comment on column ${idl_schema}.icms_business_contract.finishflag is '结清标志';
comment on column ${idl_schema}.icms_business_contract.contracttype is '合同类型;合同类型(一般合同/虚拟合同)';
comment on column ${idl_schema}.icms_business_contract.offsheetflag is '表内外标志';
comment on column ${idl_schema}.icms_business_contract.belongdept is '所属条线';
comment on column ${idl_schema}.icms_business_contract.completeflag is '数据录入完整性标识';
comment on column ${idl_schema}.icms_business_contract.flowtype is '流程类型';
comment on column ${idl_schema}.icms_business_contract.approvestatus is '审批状态';
comment on column ${idl_schema}.icms_business_contract.clno is '额度编号';
comment on column ${idl_schema}.icms_business_contract.cleffectstatus is '额度续作状态';
comment on column ${idl_schema}.icms_business_contract.remark is '备注';
comment on column ${idl_schema}.icms_business_contract.operateuserid is '经办人';
comment on column ${idl_schema}.icms_business_contract.operateorgid is '经办机构';
comment on column ${idl_schema}.icms_business_contract.operatedate is '经办日期';
comment on column ${idl_schema}.icms_business_contract.inputuserid is '登记人';
comment on column ${idl_schema}.icms_business_contract.inputorgid is '登记机构';
comment on column ${idl_schema}.icms_business_contract.inputdate is '登记日期';
comment on column ${idl_schema}.icms_business_contract.updateuserid is '更新人';
comment on column ${idl_schema}.icms_business_contract.updateorgid is '更新机构';
comment on column ${idl_schema}.icms_business_contract.updatedate is '更新日期';
comment on column ${idl_schema}.icms_business_contract.reinforceflag is '补充标志';
comment on column ${idl_schema}.icms_business_contract.corporgid is '法人机构编号';
comment on column ${idl_schema}.icms_business_contract.payfrequencyunit is '指定周期单位';
comment on column ${idl_schema}.icms_business_contract.payfrequency is '指定周期';
comment on column ${idl_schema}.icms_business_contract.renewtermdate is '展期前到期日';
comment on column ${idl_schema}.icms_business_contract.renewtotalsum is '展期前金额';
comment on column ${idl_schema}.icms_business_contract.renewexecuteyearrate is '展期前执行年利率';
comment on column ${idl_schema}.icms_business_contract.isbankrel is '是否我行关联方';
comment on column ${idl_schema}.icms_business_contract.vouchtype3 is '主要担保方式3';
comment on column ${idl_schema}.icms_business_contract.vouchtype2 is '主要担保方式2';
comment on column ${idl_schema}.icms_business_contract.loanusetype is '借款用途类型';
comment on column ${idl_schema}.icms_business_contract.totalsum is '额度敞口金额';
comment on column ${idl_schema}.icms_business_contract.outstndlmt is '已占用额度';
comment on column ${idl_schema}.icms_business_contract.bailratio is '保证金比例（%）';
comment on column ${idl_schema}.icms_business_contract.bailsum is '保证金金额';
comment on column ${idl_schema}.icms_business_contract.totalbalance is '敞口余额(元)';
comment on column ${idl_schema}.icms_business_contract.creditaggreement is '额度协议流水号';
comment on column ${idl_schema}.icms_business_contract.vouchtypeinner is '担保方式（内部口径）';
comment on column ${idl_schema}.icms_business_contract.executemonthrate is '执行月利率';
comment on column ${idl_schema}.icms_business_contract.classifyresulteleven is '风险分类结果（11级）';
comment on column ${idl_schema}.icms_business_contract.oldcreditaggreement is '使用授信协议号(备份额度合同流水号)';
comment on column ${idl_schema}.icms_business_contract.pigeonholedate is '归档日期';
comment on column ${idl_schema}.icms_business_contract.freezeflag is '冻结标志';
comment on column ${idl_schema}.icms_business_contract.rateadjustfrequency is '利率调整周期';
comment on column ${idl_schema}.icms_business_contract.overduerate is '逾期执行利率';
comment on column ${idl_schema}.icms_business_contract.overdueratefloattype is '逾期利率浮动方式';
comment on column ${idl_schema}.icms_business_contract.overdueratefloatvalue is '逾期利率浮动值';
comment on column ${idl_schema}.icms_business_contract.putoutorgid is '出账机构编号(核心机构)';
comment on column ${idl_schema}.icms_business_contract.settlementaccountname is '结算账户(还款账户)名';
comment on column ${idl_schema}.icms_business_contract.loanaccountno is '入账账户';
comment on column ${idl_schema}.icms_business_contract.loanaccountname is '贷款入账(收款账户)账户名';
comment on column ${idl_schema}.icms_business_contract.loanaccountorgid is '贷款入账(收款账户)账户开户机构';
comment on column ${idl_schema}.icms_business_contract.serialno is '合同编号';
comment on column ${idl_schema}.icms_business_contract.bapserialno is '批复编号';
comment on column ${idl_schema}.icms_business_contract.relacontractno is '关联合同编号';
comment on column ${idl_schema}.icms_business_contract.artificialno is '文本合同编号';
comment on column ${idl_schema}.icms_business_contract.customerid is '客户编号';
comment on column ${idl_schema}.icms_business_contract.customername is '客户名称';
comment on column ${idl_schema}.icms_business_contract.businessflag is '额度/业务标志';
comment on column ${idl_schema}.icms_business_contract.oldcontractno is '关联的旧合同号';
comment on column ${idl_schema}.icms_business_contract.applytype is '申请类型';
comment on column ${idl_schema}.icms_business_contract.occurtype is '发生类型';
comment on column ${idl_schema}.icms_business_contract.occurdate is '发生日期';
comment on column ${idl_schema}.icms_business_contract.start_dt is '开始日期';
comment on column ${idl_schema}.icms_business_contract.end_dt is '结束日期';
comment on column ${idl_schema}.icms_business_contract.id_mark is '删除标识';
comment on column ${idl_schema}.icms_business_contract.remart is '计量标记';
comment on column ${idl_schema}.icms_business_contract.bailcurrency is '保证金币种';
comment on column ${idl_schema}.icms_business_contract.authostrdate is '授权起始日';
comment on column ${idl_schema}.icms_business_contract.creditauthno is '征信授权影像流水号';
comment on column ${idl_schema}.icms_business_contract.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_business_contract.bailaccount is '保证金帐号';
comment on column ${idl_schema}.icms_business_contract.occupycreditbapserialno is '他用额度批复流水号';
comment on column ${idl_schema}.icms_business_contract.bailtransaccount is '保证金转出账号';
comment on column ${idl_schema}.icms_business_contract.occupycredittype is '他用额度类型';
comment on column ${idl_schema}.icms_business_contract.ispagercontract is '是否签署纸质合同';
comment on column ${idl_schema}.icms_business_contract.manageuserid is '贷后管理人员';
comment on column ${idl_schema}.icms_business_contract.manageorgid is '贷后管理机构';
comment on column ${idl_schema}.icms_business_contract.isquerycreditreport is '是否自动查询贷后报告';
comment on column ${idl_schema}.icms_business_contract.isoccupycredit is '是否占用他用额度';
comment on column ${idl_schema}.icms_business_contract.oldstatus is '备份生效标志';
comment on column ${idl_schema}.icms_business_contract.isonlinebusiness is '是否线上业务：yes-是no/空-否';
comment on column ${idl_schema}.icms_business_contract.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${idl_schema}.icms_business_contract.contractnobeforeextend is '展期前合同';
comment on column ${idl_schema}.icms_business_contract.pdgratio is '手续费比率';
comment on column ${idl_schema}.icms_business_contract.pdgsum is '手续费金额';
comment on column ${idl_schema}.icms_business_contract.templeteurl is '同业模板页面路径';
comment on column ${idl_schema}.icms_business_contract.templeteno is '同业模板编号';
comment on column ${idl_schema}.icms_business_contract.migtcustomerid is '转换前客户号';
comment on column ${idl_schema}.icms_business_contract.migtbusinesstype is '转换前产品ID';
comment on column ${idl_schema}.icms_business_contract.vouchflag is '有无其他担保方式，HaveNot';
comment on column ${idl_schema}.icms_business_contract.ratefloatratioorbp is '利率浮动类型（1-按比例2-按点差）';
comment on column ${idl_schema}.icms_business_contract.issignedcontract is '是否签订额度合同';
comment on column ${idl_schema}.icms_business_contract.useexposuretype is '';

