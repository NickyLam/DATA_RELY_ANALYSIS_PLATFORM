/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_loan_detail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_loan_detail_ex purge;
alter table ${iol_schema}.icms_wyd_loan_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_loan_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_loan_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_loan_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_loan_detail_ex(
    datadt -- 数据日期
    ,ietmcd -- 科目号
    ,orgid -- 机构号
    ,lendingref -- 借据号
    ,contractno -- 借款合同号
    ,applyno -- 申请号
    ,loantype -- 贷款种类
    ,agrrelflg -- 是否涉农贷款
    ,subsidizedflg -- 是否贴息贷款
    ,agrrelprop -- 涉农贷款性质
    ,agrspttype -- 支农贷款类型
    ,realestatetype -- 房地产类型
    ,laidoffloantype -- 下岗失业人员小额贷款类型
    ,custid -- 客户号
    ,custidtype -- 客户证件类型
    ,custidno -- 客户证件号码
    ,custname -- 客户名称
    ,loanpurpose -- 投向行业
    ,cardstate -- 账户状态
    ,startdate -- 发放日期
    ,maturitydate -- 到期日期
    ,schmaturitydate -- 约定到期日期
    ,graceperiod -- 宽限期
    ,rate -- 执行利率
    ,baserate -- 基准利率
    ,ccycd -- 币种
    ,amount -- 发放金额
    ,balance -- 贷款余额
    ,paymentfeq -- 还款频率
    ,payway -- 支付方式
    ,repricingdate -- 下一利率重定价日
    ,ratetype -- 利率类型
    ,overduetype -- 逾期分类
    ,overduedays -- 逾期天数
    ,intrtyp -- 计息标志
    ,interest -- 应收利息
    ,prinoddate -- 本金逾期日期
    ,prinodamt -- 欠本金额
    ,intoddate -- 利息逾期日期
    ,intodamt -- 欠息金额
    ,subsidizedint -- 应收贴息
    ,actsubsidizedint -- 实收贴息
    ,fundsource -- 贷款资金来源
    ,extensionflg -- 是否展期
    ,extensionamt -- 展期金额
    ,extensionstart -- 展期起始日期
    ,extensionmaturity -- 展期到期日期
    ,recomflg -- 是否重组贷款
    ,recomdate -- 重组日期
    ,bondamt -- 保证金金额
    ,capitalfund -- 资本金比例
    ,housenum -- 已有住房套数
    ,tenementfee -- 月物业费
    ,personaddloanflg -- 是否个人住房抵押追加贷款
    ,managementflag -- 是否经营性物业贷款
    ,smelttype -- 铝冶炼细分
    ,strategytype -- 战略新兴产业类型
    ,upgradeflg -- 工作转型升级标识
    ,generalreserve -- 一般减值准备
    ,specialprep -- 特殊减值准备
    ,prespe -- 专项减值准备
    ,reserve -- 减值准备
    ,housebuycount -- 购买住房面积
    ,usedlocat -- 贷款资金使用位置
    ,ratefloattype -- 利率浮动类型
    ,guartype -- 担保方式
    ,originalmaturitym -- 原始期限_月
    ,originalmaturityd -- 原始期限_日
    ,remainingmaturitym -- 剩余期限_月
    ,remainingmaturityd -- 剩余期限_日
    ,beginloangrade -- 年初五级分类
    ,poverdueamt -- 逾期总金额
    ,agecd -- 账龄
    ,pcanceldate -- 撤销日期
    ,pinitterm -- 总期数
    ,repricingmaturitym -- 利率重定价期限_月
    ,repricingmaturityd -- 利率重定价期限_日
    ,culturesign -- 文化产业标识
    ,activatedate -- 入账日期
    ,pmtduedate -- 本期应还款日期
    ,bankgroupid -- 银团编号
    ,terminatedate -- 终止日期
    ,serno -- 相关业务编号
    ,insurancepaymentflag -- 保险代偿标志
    ,insurancepaymentdate -- 保险代偿日期
    ,insurancepaymentprin -- 保险代偿本金
    ,insurancepaymentfee -- 保险代偿利息
    ,terminatereasoncd -- 终止原因
    ,assetplanno -- 资管计划No
    ,assettransferorg -- 合作机构
    ,assettransferamt -- 资产转让金额
    ,assettransferflag -- 资产转让标记
    ,assettransferdate -- 资产转让日期
    ,interestpaidamt -- 应计利息冲抵金额
    ,interestallpaiddate -- 应计利息全部冲抵日期
    ,eventflag -- 事件标志
    ,eventdate -- 事件日期
    ,loantypestage -- 贷款类型
    ,productstcode -- 子产品代码
    ,pcurrterm -- 当前期数
    ,bondccy -- 保证金币种
    ,typeofcust -- 客户类型
    ,paidoutdate -- 结清日期
    ,wtodate -- 核销日期
    ,cardno -- cnc卡号
    ,limitreportno -- 授信协议号
    ,bgrepodate -- 银团回购日期
    ,loanprocessflag -- 借据状态
    ,claimeddate -- 状态变更日期
    ,relativeddloanno -- 无还本续贷借据
    ,monthrate -- 月息率
    ,packetdate -- 封包日期
    ,packetbalance -- 封包金额
    ,coreenterprisename -- 核心企业名称
    ,coreprojectid -- 项目编号
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 五级分类
    ,classifyresulteleven -- 十级分类
    ,inreceivebalance -- 应收利息余额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    datadt -- 数据日期
    ,ietmcd -- 科目号
    ,orgid -- 机构号
    ,lendingref -- 借据号
    ,contractno -- 借款合同号
    ,applyno -- 申请号
    ,loantype -- 贷款种类
    ,agrrelflg -- 是否涉农贷款
    ,subsidizedflg -- 是否贴息贷款
    ,agrrelprop -- 涉农贷款性质
    ,agrspttype -- 支农贷款类型
    ,realestatetype -- 房地产类型
    ,laidoffloantype -- 下岗失业人员小额贷款类型
    ,custid -- 客户号
    ,custidtype -- 客户证件类型
    ,custidno -- 客户证件号码
    ,custname -- 客户名称
    ,loanpurpose -- 投向行业
    ,cardstate -- 账户状态
    ,startdate -- 发放日期
    ,maturitydate -- 到期日期
    ,schmaturitydate -- 约定到期日期
    ,graceperiod -- 宽限期
    ,rate -- 执行利率
    ,baserate -- 基准利率
    ,ccycd -- 币种
    ,amount -- 发放金额
    ,balance -- 贷款余额
    ,paymentfeq -- 还款频率
    ,payway -- 支付方式
    ,repricingdate -- 下一利率重定价日
    ,ratetype -- 利率类型
    ,overduetype -- 逾期分类
    ,overduedays -- 逾期天数
    ,intrtyp -- 计息标志
    ,interest -- 应收利息
    ,prinoddate -- 本金逾期日期
    ,prinodamt -- 欠本金额
    ,intoddate -- 利息逾期日期
    ,intodamt -- 欠息金额
    ,subsidizedint -- 应收贴息
    ,actsubsidizedint -- 实收贴息
    ,fundsource -- 贷款资金来源
    ,extensionflg -- 是否展期
    ,extensionamt -- 展期金额
    ,extensionstart -- 展期起始日期
    ,extensionmaturity -- 展期到期日期
    ,recomflg -- 是否重组贷款
    ,recomdate -- 重组日期
    ,bondamt -- 保证金金额
    ,capitalfund -- 资本金比例
    ,housenum -- 已有住房套数
    ,tenementfee -- 月物业费
    ,personaddloanflg -- 是否个人住房抵押追加贷款
    ,managementflag -- 是否经营性物业贷款
    ,smelttype -- 铝冶炼细分
    ,strategytype -- 战略新兴产业类型
    ,upgradeflg -- 工作转型升级标识
    ,generalreserve -- 一般减值准备
    ,specialprep -- 特殊减值准备
    ,prespe -- 专项减值准备
    ,reserve -- 减值准备
    ,housebuycount -- 购买住房面积
    ,usedlocat -- 贷款资金使用位置
    ,ratefloattype -- 利率浮动类型
    ,guartype -- 担保方式
    ,originalmaturitym -- 原始期限_月
    ,originalmaturityd -- 原始期限_日
    ,remainingmaturitym -- 剩余期限_月
    ,remainingmaturityd -- 剩余期限_日
    ,beginloangrade -- 年初五级分类
    ,poverdueamt -- 逾期总金额
    ,agecd -- 账龄
    ,pcanceldate -- 撤销日期
    ,pinitterm -- 总期数
    ,repricingmaturitym -- 利率重定价期限_月
    ,repricingmaturityd -- 利率重定价期限_日
    ,culturesign -- 文化产业标识
    ,activatedate -- 入账日期
    ,pmtduedate -- 本期应还款日期
    ,bankgroupid -- 银团编号
    ,terminatedate -- 终止日期
    ,serno -- 相关业务编号
    ,insurancepaymentflag -- 保险代偿标志
    ,insurancepaymentdate -- 保险代偿日期
    ,insurancepaymentprin -- 保险代偿本金
    ,insurancepaymentfee -- 保险代偿利息
    ,terminatereasoncd -- 终止原因
    ,assetplanno -- 资管计划No
    ,assettransferorg -- 合作机构
    ,assettransferamt -- 资产转让金额
    ,assettransferflag -- 资产转让标记
    ,assettransferdate -- 资产转让日期
    ,interestpaidamt -- 应计利息冲抵金额
    ,interestallpaiddate -- 应计利息全部冲抵日期
    ,eventflag -- 事件标志
    ,eventdate -- 事件日期
    ,loantypestage -- 贷款类型
    ,productstcode -- 子产品代码
    ,pcurrterm -- 当前期数
    ,bondccy -- 保证金币种
    ,typeofcust -- 客户类型
    ,paidoutdate -- 结清日期
    ,wtodate -- 核销日期
    ,cardno -- cnc卡号
    ,limitreportno -- 授信协议号
    ,bgrepodate -- 银团回购日期
    ,loanprocessflag -- 借据状态
    ,claimeddate -- 状态变更日期
    ,relativeddloanno -- 无还本续贷借据
    ,monthrate -- 月息率
    ,packetdate -- 封包日期
    ,packetbalance -- 封包金额
    ,coreenterprisename -- 核心企业名称
    ,coreprojectid -- 项目编号
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 五级分类
    ,classifyresulteleven -- 十级分类
    ,inreceivebalance -- 应收利息余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_loan_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_loan_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_loan_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_loan_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_loan_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_loan_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);