/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_business_contract
CreateDate: 20240924
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_business_contract drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_business_contract add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_business_contract (
etl_dt  --ETL处理日期
,currency  --额度/业务币种
,businesssum  --合同金额
,putoutsum  --实际出账金额
,putoutdate  --出账日期
,baseproduct  --基础产品(额度);基础产品
,productid  --产品编号
,policyid  --产品政策编号
,policyversionid  --产品政策版本编号
,productclassify  --产品所属大类
,termmonth  --期限(月)
,termday  --期限(天)
,startdate  --合同起始日
,maturity  --合同到期日
,iscycle  --是否循环(额度);是否循环
,risktype  --风险类型(额度);风险类型（一般、低风险）
,islowrisk  --是否低风险业务
,isremotebusiness  --是否异地业务
,ratemodel  --利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
,fixedrate  --固定利率
,baseratetype  --基准利率类型
,baserate  --基准利率
,ratefloattype  --利率浮动类型;浮动利率类型
,rateadjusttype  --利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
,floatrange  --浮动幅度
,executerate  --执行利率
,vouchtype  --主要担保方式
,haveadditionalvouch  --有无追加担保方式
,othervouchtype  --其他担保方式
,additioncommand  --其他条件和要求
,repaytype  --还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
,repaycycle  --还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
,repaydate  --指定还款日
,settlementaccount  --结算账号
,paymenttype  --支付方式
,creditinvest  --授信投向;授信投向(01绿色贷款；02两高一剩（可多选）；03ppp贷款)
,nationalindustrytype  --国标行业投向
,intraindustrytype  --行内行业投向
,purpose  --用途
,reservesum  --预留金额
,balance  --合同余额
,normalbalance  --正常余额
,overduebalance  --逾期/垫款金额
,dullbalance  --呆滞余额
,badbalance  --呆账余额
,innerinterestbalance  --表内欠息余额
,outerinterestbalance  --表外欠息余额
,capitalpenaltybalance  --逾期罚息余额
,interestpenaltybalance  --复息余额
,overduedays  --逾期天数
,owninterestdays  --欠息天数
,graceperiod  --贷款宽限期
,cancelsum  --核销本金
,cancelinterest  --核销利息
,predictlostsum  --预测损失金额
,reducereservesum  --计提准备金额
,badconfirmdate  --首次认定不良日期
,classifyresult  --风险分类结果（五级）
,classifydate  --风险分类日期
,status  --合同状态
,finishdate  --终结日期
,finishtype  --终结类型
,finishflag  --结清标志
,contracttype  --合同类型;合同类型(一般合同/虚拟合同)
,offsheetflag  --表内外标志
,belongdept  --所属条线
,completeflag  --数据录入完整性标识
,flowtype  --流程类型
,approvestatus  --审批状态
,clno  --额度编号
,cleffectstatus  --额度续作状态
,remark  --备注
,operateuserid  --经办人
,operateorgid  --经办机构
,operatedate  --经办日期
,inputuserid  --登记人
,inputorgid  --登记机构
,inputdate  --登记日期
,updateuserid  --更新人
,updateorgid  --更新机构
,updatedate  --更新日期
,reinforceflag  --补充标志
,corporgid  --法人机构编号
,payfrequencyunit  --指定周期单位
,payfrequency  --指定周期
,renewtermdate  --展期前到期日
,renewtotalsum  --展期前金额
,renewexecuteyearrate  --展期前执行年利率
,isbankrel  --是否我行关联方
,vouchtype3  --主要担保方式3
,vouchtype2  --主要担保方式2
,loanusetype  --借款用途类型
,totalsum  --额度敞口金额
,outstndlmt  --已占用额度
,bailratio  --保证金比例（%）
,bailsum  --保证金金额
,totalbalance  --敞口余额(元)
,creditaggreement  --额度协议流水号
,vouchtypeinner  --担保方式（内部口径）
,executemonthrate  --执行月利率
,classifyresulteleven  --风险分类结果（11级）
,oldcreditaggreement  --使用授信协议号(备份额度合同流水号)
,pigeonholedate  --归档日期
,freezeflag  --冻结标志
,rateadjustfrequency  --利率调整周期
,overduerate  --逾期执行利率
,overdueratefloattype  --逾期利率浮动方式
,overdueratefloatvalue  --逾期利率浮动值
,putoutorgid  --出账机构编号(核心机构)
,settlementaccountname  --结算账户(还款账户)名
,loanaccountno  --入账账户
,loanaccountname  --贷款入账(收款账户)账户名
,loanaccountorgid  --贷款入账(收款账户)账户开户机构
,serialno  --合同编号
,bapserialno  --批复编号
,relacontractno  --关联合同编号
,artificialno  --文本合同编号
,customerid  --客户编号
,customername  --客户名称
,businessflag  --额度/业务标志
,oldcontractno  --关联的旧合同号
,applytype  --申请类型
,occurtype  --发生类型
,occurdate  --发生日期
,start_dt  --开始日期
,end_dt  --结束日期
,id_mark  --删除标识
,remart  --计量标记
,bailcurrency  --保证金币种
,authostrdate  --授权起始日
,creditauthno  --征信授权影像流水号
,migtflag  --迁移标志：crs rcr ilc upl
,bailaccount  --保证金帐号
,occupycreditbapserialno  --他用额度批复流水号
,bailtransaccount  --保证金转出账号
,occupycredittype  --他用额度类型
,ispagercontract  --是否签署纸质合同
,manageuserid  --贷后管理人员
,manageorgid  --贷后管理机构
,isquerycreditreport  --是否自动查询贷后报告
,isoccupycredit  --是否占用他用额度
,oldstatus  --备份生效标志
,isonlinebusiness  --是否线上业务：yes-是no/空-否
,migtoldvalue  --迁移数据-参数转换前字段值
,contractnobeforeextend  --展期前合同
,pdgratio  --手续费比率
,pdgsum  --手续费金额
,templeteurl  --同业模板页面路径
,templeteno  --同业模板编号
,migtcustomerid  --转换前客户号
,migtbusinesstype  --转换前产品ID
,vouchflag  --有无其他担保方式，HaveNot
,ratefloatratioorbp  --利率浮动类型（1-按比例2-按点差）
,issignedcontract  --是否签订额度合同
,useexposuretype --

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency --额度/业务币种
,t1.businesssum as businesssum --合同金额
,t1.putoutsum as putoutsum --实际出账金额
,t1.putoutdate as putoutdate --出账日期
,replace(replace(t1.baseproduct,chr(13),''),chr(10),'') as baseproduct --基础产品(额度);基础产品
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid --产品编号
,replace(replace(t1.policyid,chr(13),''),chr(10),'') as policyid --产品政策编号
,replace(replace(t1.policyversionid,chr(13),''),chr(10),'') as policyversionid --产品政策版本编号
,replace(replace(t1.productclassify,chr(13),''),chr(10),'') as productclassify --产品所属大类
,t1.termmonth as termmonth --期限(月)
,t1.termday as termday --期限(天)
,t1.startdate as startdate --合同起始日
,t1.maturity as maturity --合同到期日
,replace(replace(t1.iscycle,chr(13),''),chr(10),'') as iscycle --是否循环(额度);是否循环
,replace(replace(t1.risktype,chr(13),''),chr(10),'') as risktype --风险类型(额度);风险类型（一般、低风险）
,replace(replace(t1.islowrisk,chr(13),''),chr(10),'') as islowrisk --是否低风险业务
,replace(replace(t1.isremotebusiness,chr(13),''),chr(10),'') as isremotebusiness --是否异地业务
,replace(replace(t1.ratemodel,chr(13),''),chr(10),'') as ratemodel --利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
,t1.fixedrate as fixedrate --固定利率
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype --基准利率类型
,t1.baserate as baserate --基准利率
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype --利率浮动类型;浮动利率类型
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype --利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
,t1.floatrange as floatrange --浮动幅度
,t1.executerate as executerate --执行利率
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype --主要担保方式
,replace(replace(t1.haveadditionalvouch,chr(13),''),chr(10),'') as haveadditionalvouch --有无追加担保方式
,replace(replace(t1.othervouchtype,chr(13),''),chr(10),'') as othervouchtype --其他担保方式
,replace(replace(t1.additioncommand,chr(13),''),chr(10),'') as additioncommand --其他条件和要求
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype --还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle --还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
,t1.repaydate as repaydate --指定还款日
,replace(replace(t1.settlementaccount,chr(13),''),chr(10),'') as settlementaccount --结算账号
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype --支付方式
,replace(replace(t1.creditinvest,chr(13),''),chr(10),'') as creditinvest --授信投向;授信投向(01绿色贷款；02两高一剩（可多选）；03ppp贷款)
,replace(replace(t1.nationalindustrytype,chr(13),''),chr(10),'') as nationalindustrytype --国标行业投向
,replace(replace(t1.intraindustrytype,chr(13),''),chr(10),'') as intraindustrytype --行内行业投向
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose --用途
,t1.reservesum as reservesum --预留金额
,t1.balance as balance --合同余额
,t1.normalbalance as normalbalance --正常余额
,t1.overduebalance as overduebalance --逾期/垫款金额
,t1.dullbalance as dullbalance --呆滞余额
,t1.badbalance as badbalance --呆账余额
,t1.innerinterestbalance as innerinterestbalance --表内欠息余额
,t1.outerinterestbalance as outerinterestbalance --表外欠息余额
,t1.capitalpenaltybalance as capitalpenaltybalance --逾期罚息余额
,t1.interestpenaltybalance as interestpenaltybalance --复息余额
,t1.overduedays as overduedays --逾期天数
,t1.owninterestdays as owninterestdays --欠息天数
,t1.graceperiod as graceperiod --贷款宽限期
,t1.cancelsum as cancelsum --核销本金
,t1.cancelinterest as cancelinterest --核销利息
,t1.predictlostsum as predictlostsum --预测损失金额
,t1.reducereservesum as reducereservesum --计提准备金额
,t1.badconfirmdate as badconfirmdate --首次认定不良日期
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult --风险分类结果（五级）
,t1.classifydate as classifydate --风险分类日期
,replace(replace(t1.status,chr(13),''),chr(10),'') as status --合同状态
,t1.finishdate as finishdate --终结日期
,replace(replace(t1.finishtype,chr(13),''),chr(10),'') as finishtype --终结类型
,replace(replace(t1.finishflag,chr(13),''),chr(10),'') as finishflag --结清标志
,replace(replace(t1.contracttype,chr(13),''),chr(10),'') as contracttype --合同类型;合同类型(一般合同/虚拟合同)
,replace(replace(t1.offsheetflag,chr(13),''),chr(10),'') as offsheetflag --表内外标志
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept --所属条线
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag --数据录入完整性标识
,replace(replace(t1.flowtype,chr(13),''),chr(10),'') as flowtype --流程类型
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus --审批状态
,replace(replace(t1.clno,chr(13),''),chr(10),'') as clno --额度编号
,replace(replace(t1.cleffectstatus,chr(13),''),chr(10),'') as cleffectstatus --额度续作状态
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid --经办人
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid --经办机构
,t1.operatedate as operatedate --经办日期
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,t1.updatedate as updatedate --更新日期
,replace(replace(t1.reinforceflag,chr(13),''),chr(10),'') as reinforceflag --补充标志
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid --法人机构编号
,replace(replace(t1.payfrequencyunit,chr(13),''),chr(10),'') as payfrequencyunit --指定周期单位
,t1.payfrequency as payfrequency --指定周期
,t1.renewtermdate as renewtermdate --展期前到期日
,t1.renewtotalsum as renewtotalsum --展期前金额
,t1.renewexecuteyearrate as renewexecuteyearrate --展期前执行年利率
,replace(replace(t1.isbankrel,chr(13),''),chr(10),'') as isbankrel --是否我行关联方
,replace(replace(t1.vouchtype3,chr(13),''),chr(10),'') as vouchtype3 --主要担保方式3
,replace(replace(t1.vouchtype2,chr(13),''),chr(10),'') as vouchtype2 --主要担保方式2
,replace(replace(t1.loanusetype,chr(13),''),chr(10),'') as loanusetype --借款用途类型
,t1.totalsum as totalsum --额度敞口金额
,t1.outstndlmt as outstndlmt --已占用额度
,t1.bailratio as bailratio --保证金比例（%）
,t1.bailsum as bailsum --保证金金额
,t1.totalbalance as totalbalance --敞口余额(元)
,replace(replace(t1.creditaggreement,chr(13),''),chr(10),'') as creditaggreement --额度协议流水号
,replace(replace(t1.vouchtypeinner,chr(13),''),chr(10),'') as vouchtypeinner --担保方式（内部口径）
,t1.executemonthrate as executemonthrate --执行月利率
,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'') as classifyresulteleven --风险分类结果（11级）
,replace(replace(t1.oldcreditaggreement,chr(13),''),chr(10),'') as oldcreditaggreement --使用授信协议号(备份额度合同流水号)
,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'') as pigeonholedate --归档日期
,replace(replace(t1.freezeflag,chr(13),''),chr(10),'') as freezeflag --冻结标志
,replace(replace(t1.rateadjustfrequency,chr(13),''),chr(10),'') as rateadjustfrequency --利率调整周期
,t1.overduerate as overduerate --逾期执行利率
,replace(replace(t1.overdueratefloattype,chr(13),''),chr(10),'') as overdueratefloattype --逾期利率浮动方式
,t1.overdueratefloatvalue as overdueratefloatvalue --逾期利率浮动值
,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'') as putoutorgid --出账机构编号(核心机构)
,replace(replace(t1.settlementaccountname,chr(13),''),chr(10),'') as settlementaccountname --结算账户(还款账户)名
,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'') as loanaccountno --入账账户
,replace(replace(t1.loanaccountname,chr(13),''),chr(10),'') as loanaccountname --贷款入账(收款账户)账户名
,replace(replace(t1.loanaccountorgid,chr(13),''),chr(10),'') as loanaccountorgid --贷款入账(收款账户)账户开户机构
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --合同编号
,replace(replace(t1.bapserialno,chr(13),''),chr(10),'') as bapserialno --批复编号
,replace(replace(t1.relacontractno,chr(13),''),chr(10),'') as relacontractno --关联合同编号
,replace(replace(t1.artificialno,chr(13),''),chr(10),'') as artificialno --文本合同编号
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid --客户编号
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername --客户名称
,replace(replace(t1.businessflag,chr(13),''),chr(10),'') as businessflag --额度/业务标志
,replace(replace(t1.oldcontractno,chr(13),''),chr(10),'') as oldcontractno --关联的旧合同号
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype --申请类型
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype --发生类型
,t1.occurdate as occurdate --发生日期
,t1.start_dt as start_dt --开始日期
,t1.end_dt as end_dt --结束日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --删除标识
,replace(replace(t1.remart,chr(13),''),chr(10),'') as remart --计量标记
,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'') as bailcurrency --保证金币种
,replace(replace(t1.authostrdate,chr(13),''),chr(10),'') as authostrdate --授权起始日
,replace(replace(t1.creditauthno,chr(13),''),chr(10),'') as creditauthno --征信授权影像流水号
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.bailaccount,chr(13),''),chr(10),'') as bailaccount --保证金帐号
,replace(replace(t1.occupycreditbapserialno,chr(13),''),chr(10),'') as occupycreditbapserialno --他用额度批复流水号
,replace(replace(t1.bailtransaccount,chr(13),''),chr(10),'') as bailtransaccount --保证金转出账号
,replace(replace(t1.occupycredittype,chr(13),''),chr(10),'') as occupycredittype --他用额度类型
,replace(replace(t1.ispagercontract,chr(13),''),chr(10),'') as ispagercontract --是否签署纸质合同
,replace(replace(t1.manageuserid,chr(13),''),chr(10),'') as manageuserid --贷后管理人员
,replace(replace(t1.manageorgid,chr(13),''),chr(10),'') as manageorgid --贷后管理机构
,replace(replace(t1.isquerycreditreport,chr(13),''),chr(10),'') as isquerycreditreport --是否自动查询贷后报告
,replace(replace(t1.isoccupycredit,chr(13),''),chr(10),'') as isoccupycredit --是否占用他用额度
,replace(replace(t1.oldstatus,chr(13),''),chr(10),'') as oldstatus --备份生效标志
,replace(replace(t1.isonlinebusiness,chr(13),''),chr(10),'') as isonlinebusiness --是否线上业务：yes-是no/空-否
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue --迁移数据-参数转换前字段值
,replace(replace(t1.contractnobeforeextend,chr(13),''),chr(10),'') as contractnobeforeextend --展期前合同
,t1.pdgratio as pdgratio --手续费比率
,t1.pdgsum as pdgsum --手续费金额
,replace(replace(t1.templeteurl,chr(13),''),chr(10),'') as templeteurl --同业模板页面路径
,replace(replace(t1.templeteno,chr(13),''),chr(10),'') as templeteno --同业模板编号
,replace(replace(t1.migtcustomerid,chr(13),''),chr(10),'') as migtcustomerid --转换前客户号
,replace(replace(t1.migtbusinesstype,chr(13),''),chr(10),'') as migtbusinesstype --转换前产品ID
,replace(replace(t1.vouchflag,chr(13),''),chr(10),'') as vouchflag --有无其他担保方式，HaveNot
,replace(replace(t1.ratefloatratioorbp,chr(13),''),chr(10),'') as ratefloatratioorbp --利率浮动类型（1-按比例2-按点差）
,replace(replace(t1.issignedcontract,chr(13),''),chr(10),'') as issignedcontract --是否签订额度合同
,replace(replace(t1.useexposuretype,chr(13),''),chr(10),'') as useexposuretype --

from ${iol_schema}.icms_business_contract t1    --合同信息表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_business_contract',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
