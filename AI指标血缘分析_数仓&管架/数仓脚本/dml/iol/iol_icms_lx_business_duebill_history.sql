/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lx_business_duebill_history
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
drop table ${iol_schema}.icms_lx_business_duebill_history_ex purge;
alter table ${iol_schema}.icms_lx_business_duebill_history add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_lx_business_duebill_history truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_lx_business_duebill_history_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_duebill_history where 0=1;

insert /*+ append */ into ${iol_schema}.icms_lx_business_duebill_history_ex(
    capitalloanno -- 借据号
    ,putoutserialno -- 出账流水号
    ,contractserialno -- 合同流水号
    ,customerid -- 客户号
    ,customername -- 客户名称
    ,status -- 状态
    ,termmonth -- 期限
    ,ratemodel -- 利率模式
    ,baseratetype -- 基准利率类型
    ,baserate -- 基准利率
    ,ratefloattype -- 利率浮动方式
    ,executerate -- 执行利率
    ,overduerate -- 逾期利率
    ,rateadjusttype -- 利率调整方式
    ,rateadjustfrequency -- 利率调整周期
    ,floatrange -- 浮动幅度
    ,overdueratefloattype -- 逾期利率浮动方式
    ,overdueratefloatvalue -- 逾期利率浮动值
    ,classifyresult -- 贷款五级分类
    ,applydate -- 申请日期
    ,startdate -- 开始日期
    ,enddate -- 到期日期
    ,overduedate -- 逾期日期
    ,cleardate -- 结清日期
    ,encashamt -- 借据金额
    ,currency -- 币种
    ,repaymode -- 还款方式
    ,repaycycle -- 还款周期
    ,totalterms -- 总期数
    ,curterm -- 当前期数
    ,repayday -- 还款日
    ,graceday -- 宽限期
    ,loanstatus -- 贷款状态
    ,loanform -- 贷款形态
    ,printotal -- 应还本金
    ,prinrepay -- 已还本金
    ,prinbal -- 正常本金余额
    ,ovdprinbal -- 逾期本金余额
    ,intplan -- 计划利息
    ,inttotal -- 应还利息
    ,intrepay -- 已还利息
    ,intdiscount -- 减免利息
    ,intbal -- 利息余额
    ,ovdintbal -- 逾期利息余额
    ,pnltinttotal -- 应收罚息
    ,pnltintrepay -- 已还罚息
    ,pnltintdiscount -- 减免罚息
    ,pnltintbal -- 罚息余额
    ,prepmtfeerepay -- 已还提前还款手续费
    ,outloanchannelno -- 平台订单号
    ,daysovd -- 逾期天数
    ,interesttransferstatus -- 非应计状态
    ,loanresponsetime -- 支付返回成功时间
    ,writeoffstatus -- 核销状态
    ,writeofftime -- 核销时间
    ,inputdate -- 登记日期
    ,updatedate -- 更新日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,startterm -- 开始期序
    ,endterm -- 结束期序
    ,intrate -- 正常利率
    ,intrateunit -- 正常利率类型
    ,ovdrate -- 罚息利率
    ,ovdrateunit -- 罚息利率类型
    ,prepmtfeerate -- 提前还款手续费率
    ,remart -- 计量标记-资产三分类
    ,dailyint -- 当日计提利息
    ,dailypnltint -- 当日计提罚息
    ,vouchtype -- 主担保方式
    ,repaynum -- 还款账户
    ,repaynumtype -- 还款账户类型
    ,paymentnum -- 入账账户
    ,paymentnumtype -- 入账账户类型
    ,operateuserid -- 经办人
    ,operateorgid -- 经办机构
    ,putoutorgid -- 账务机构
    ,manageorgid -- 管理机构
    ,productid -- 产品编号
    ,loanpurpose -- 投向行业
    ,interesttype -- 计息方式
    ,bankproportion -- 银行出资比例
    ,fivecateadjdate -- 五级分类认定日期
    ,bizdate -- 数据日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    capitalloanno -- 借据号
    ,putoutserialno -- 出账流水号
    ,contractserialno -- 合同流水号
    ,customerid -- 客户号
    ,customername -- 客户名称
    ,status -- 状态
    ,termmonth -- 期限
    ,ratemodel -- 利率模式
    ,baseratetype -- 基准利率类型
    ,baserate -- 基准利率
    ,ratefloattype -- 利率浮动方式
    ,executerate -- 执行利率
    ,overduerate -- 逾期利率
    ,rateadjusttype -- 利率调整方式
    ,rateadjustfrequency -- 利率调整周期
    ,floatrange -- 浮动幅度
    ,overdueratefloattype -- 逾期利率浮动方式
    ,overdueratefloatvalue -- 逾期利率浮动值
    ,classifyresult -- 贷款五级分类
    ,applydate -- 申请日期
    ,startdate -- 开始日期
    ,enddate -- 到期日期
    ,overduedate -- 逾期日期
    ,cleardate -- 结清日期
    ,encashamt -- 借据金额
    ,currency -- 币种
    ,repaymode -- 还款方式
    ,repaycycle -- 还款周期
    ,totalterms -- 总期数
    ,curterm -- 当前期数
    ,repayday -- 还款日
    ,graceday -- 宽限期
    ,loanstatus -- 贷款状态
    ,loanform -- 贷款形态
    ,printotal -- 应还本金
    ,prinrepay -- 已还本金
    ,prinbal -- 正常本金余额
    ,ovdprinbal -- 逾期本金余额
    ,intplan -- 计划利息
    ,inttotal -- 应还利息
    ,intrepay -- 已还利息
    ,intdiscount -- 减免利息
    ,intbal -- 利息余额
    ,ovdintbal -- 逾期利息余额
    ,pnltinttotal -- 应收罚息
    ,pnltintrepay -- 已还罚息
    ,pnltintdiscount -- 减免罚息
    ,pnltintbal -- 罚息余额
    ,prepmtfeerepay -- 已还提前还款手续费
    ,outloanchannelno -- 平台订单号
    ,daysovd -- 逾期天数
    ,interesttransferstatus -- 非应计状态
    ,loanresponsetime -- 支付返回成功时间
    ,writeoffstatus -- 核销状态
    ,writeofftime -- 核销时间
    ,inputdate -- 登记日期
    ,updatedate -- 更新日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,startterm -- 开始期序
    ,endterm -- 结束期序
    ,intrate -- 正常利率
    ,intrateunit -- 正常利率类型
    ,ovdrate -- 罚息利率
    ,ovdrateunit -- 罚息利率类型
    ,prepmtfeerate -- 提前还款手续费率
    ,remart -- 计量标记-资产三分类
    ,dailyint -- 当日计提利息
    ,dailypnltint -- 当日计提罚息
    ,vouchtype -- 主担保方式
    ,repaynum -- 还款账户
    ,repaynumtype -- 还款账户类型
    ,paymentnum -- 入账账户
    ,paymentnumtype -- 入账账户类型
    ,operateuserid -- 经办人
    ,operateorgid -- 经办机构
    ,putoutorgid -- 账务机构
    ,manageorgid -- 管理机构
    ,productid -- 产品编号
    ,loanpurpose -- 投向行业
    ,interesttype -- 计息方式
    ,bankproportion -- 银行出资比例
    ,fivecateadjdate -- 五级分类认定日期
    ,bizdate -- 数据日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_lx_business_duebill_history
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_lx_business_duebill_history exchange partition p_${batch_date} with table ${iol_schema}.icms_lx_business_duebill_history_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lx_business_duebill_history to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_lx_business_duebill_history_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lx_business_duebill_history',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);