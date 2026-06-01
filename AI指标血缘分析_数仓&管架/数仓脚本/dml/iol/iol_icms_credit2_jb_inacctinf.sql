/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_credit2_jb_inacctinf
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
drop table ${iol_schema}.icms_credit2_jb_inacctinf_ex purge;
alter table ${iol_schema}.icms_credit2_jb_inacctinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_credit2_jb_inacctinf;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_credit2_jb_inacctinf_ex nologging
compress
as
select * from ${iol_schema}.icms_credit2_jb_inacctinf where 0=1;

insert /*+ append */ into ${iol_schema}.icms_credit2_jb_inacctinf_ex(
    fivecateadjdate -- 五级分类认定日期
    ,opendate -- 开户日期
    ,specefctdate -- 分期额度生效日期
    ,rptdate -- 信息报告日期
    ,acctspectrstdspnsgmt_updflag -- 特殊交易说明段上报标志
    ,loanamt -- 借款金额
    ,repayfreqcy -- 还款频率
    ,fundsou -- 业务经营类型
    ,pridacctbal -- 本期账单余额
    ,oved31_60princ -- 逾期31-60天未归还本金
    ,rpyprct -- 实际还款百分比
    ,name -- 借款人姓名
    ,idtype -- 借款人证件类型
    ,acctbsinfsgmt_updflag -- 基本信息信息段上报标志
    ,origcreditorinfsgmt_updflag -- 初始债权说明段上报标志
    ,usedamt -- 已使用额度
    ,ovedprinc180 -- 逾期180天以上未归还本金
    ,acctmthlyblginfsgmt_updflag -- 月度表现信息段上报标志
    ,guarmode -- 担保方式
    ,mcc -- 授信协议标识码
    ,rltrepymtinfsgmt_updflag -- 相关还款责任人段上报标志
    ,acctcode -- 账户标识码
    ,rptdatecode -- 报告时点说明代码
    ,busidtllines -- 借贷业务种类细分
    ,totoverd -- 当前逾期总额
    ,cagoftrdinfdata -- 特殊交易说明段
    ,acctcredline -- 信用额度
    ,initcredname -- 初始债权人名称
    ,specline -- 大额专项分期额度
    ,firsthouloanflag -- 是否为首套住房贷款
    ,origdbtcate -- 原债务种类
    ,extra_info -- 扩展字段
    ,rpystatus -- 当前还款状态
    ,overdprinc -- 当前逾期本金
    ,oved61_90princ -- 逾期61-90天未归还本金
    ,acctcredsgmt_updflag -- 授信额度信息段上报标志
    ,specprdsgmt_updflag -- 大额专项分期信息段上报标志
    ,creditid -- 卡片标识号
    ,latrpyamt -- 最近一次实际还款金额
    ,actrpyamt -- 本月实际还款金额
    ,repaymode -- 还款方式
    ,initcredorgnm -- 初始债权人机构代码
    ,idnum -- 借款人证件号码
    ,repayprd -- 还款期数
    ,specenddate -- 分期额度到期日期
    ,create_time -- 入库时间
    ,busilines -- 借贷业务大类
    ,loanform -- 贷款发放形式
    ,acctbal -- 余额
    ,infrectype -- 信息记录类型
    ,loanconcode -- 贷款合同编号
    ,ccnm -- 抵质押合同个数
    ,cagoftrdnm -- 交易个数
    ,notisubal -- 未出单的大额专项分期余额
    ,applybusidist -- 业务申请地行政区划代码
    ,othrepyguarway -- 其他还款保证方式
    ,remrepprd -- 剩余还款期数
    ,fivecate -- 五级分类
    ,motgacltalctrctinfsgmt_updflag -- 抵质押物信息段上报标志
    ,oved91_180princ -- 逾期91-180天未归还本金
    ,acctdbtinfsgmt_updflag -- 非月度表现信息段上报标志
    ,month -- 月份
    ,currpyamt -- 本月应还款金额
    ,overdprd -- 当前逾期期数
    ,ovedrawbaove180 -- 透支180天以上未还余额
    ,settdate -- 结算/应还款日
    ,flag -- 分次放款标志
    ,cy -- 币种
    ,duedate -- 到期日期
    ,closedate -- 账户关闭日期
    ,usedinstamt -- 已用分期金额
    ,mngmtorgcode -- 业务管理机构代码
    ,rltrepymtnm -- 责任人个数
    ,accttype -- 账户类型
    ,assettrandflag -- 资产转让标志
    ,initrpysts -- 债权转移时的还款状态
    ,latrpydate -- 最近一次实际还款日期
    ,rltrepymtinfdata -- 相关还款责任人段
    ,cccinfdata -- 抵质押物信息段
    ,acctstatus -- 账户状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    fivecateadjdate -- 五级分类认定日期
    ,opendate -- 开户日期
    ,specefctdate -- 分期额度生效日期
    ,rptdate -- 信息报告日期
    ,acctspectrstdspnsgmt_updflag -- 特殊交易说明段上报标志
    ,loanamt -- 借款金额
    ,repayfreqcy -- 还款频率
    ,fundsou -- 业务经营类型
    ,pridacctbal -- 本期账单余额
    ,oved31_60princ -- 逾期31-60天未归还本金
    ,rpyprct -- 实际还款百分比
    ,name -- 借款人姓名
    ,idtype -- 借款人证件类型
    ,acctbsinfsgmt_updflag -- 基本信息信息段上报标志
    ,origcreditorinfsgmt_updflag -- 初始债权说明段上报标志
    ,usedamt -- 已使用额度
    ,ovedprinc180 -- 逾期180天以上未归还本金
    ,acctmthlyblginfsgmt_updflag -- 月度表现信息段上报标志
    ,guarmode -- 担保方式
    ,mcc -- 授信协议标识码
    ,rltrepymtinfsgmt_updflag -- 相关还款责任人段上报标志
    ,acctcode -- 账户标识码
    ,rptdatecode -- 报告时点说明代码
    ,busidtllines -- 借贷业务种类细分
    ,totoverd -- 当前逾期总额
    ,cagoftrdinfdata -- 特殊交易说明段
    ,acctcredline -- 信用额度
    ,initcredname -- 初始债权人名称
    ,specline -- 大额专项分期额度
    ,firsthouloanflag -- 是否为首套住房贷款
    ,origdbtcate -- 原债务种类
    ,extra_info -- 扩展字段
    ,rpystatus -- 当前还款状态
    ,overdprinc -- 当前逾期本金
    ,oved61_90princ -- 逾期61-90天未归还本金
    ,acctcredsgmt_updflag -- 授信额度信息段上报标志
    ,specprdsgmt_updflag -- 大额专项分期信息段上报标志
    ,creditid -- 卡片标识号
    ,latrpyamt -- 最近一次实际还款金额
    ,actrpyamt -- 本月实际还款金额
    ,repaymode -- 还款方式
    ,initcredorgnm -- 初始债权人机构代码
    ,idnum -- 借款人证件号码
    ,repayprd -- 还款期数
    ,specenddate -- 分期额度到期日期
    ,create_time -- 入库时间
    ,busilines -- 借贷业务大类
    ,loanform -- 贷款发放形式
    ,acctbal -- 余额
    ,infrectype -- 信息记录类型
    ,loanconcode -- 贷款合同编号
    ,ccnm -- 抵质押合同个数
    ,cagoftrdnm -- 交易个数
    ,notisubal -- 未出单的大额专项分期余额
    ,applybusidist -- 业务申请地行政区划代码
    ,othrepyguarway -- 其他还款保证方式
    ,remrepprd -- 剩余还款期数
    ,fivecate -- 五级分类
    ,motgacltalctrctinfsgmt_updflag -- 抵质押物信息段上报标志
    ,oved91_180princ -- 逾期91-180天未归还本金
    ,acctdbtinfsgmt_updflag -- 非月度表现信息段上报标志
    ,month -- 月份
    ,currpyamt -- 本月应还款金额
    ,overdprd -- 当前逾期期数
    ,ovedrawbaove180 -- 透支180天以上未还余额
    ,settdate -- 结算/应还款日
    ,flag -- 分次放款标志
    ,cy -- 币种
    ,duedate -- 到期日期
    ,closedate -- 账户关闭日期
    ,usedinstamt -- 已用分期金额
    ,mngmtorgcode -- 业务管理机构代码
    ,rltrepymtnm -- 责任人个数
    ,accttype -- 账户类型
    ,assettrandflag -- 资产转让标志
    ,initrpysts -- 债权转移时的还款状态
    ,latrpydate -- 最近一次实际还款日期
    ,rltrepymtinfdata -- 相关还款责任人段
    ,cccinfdata -- 抵质押物信息段
    ,acctstatus -- 账户状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_credit2_jb_inacctinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_credit2_jb_inacctinf exchange partition p_${batch_date} with table ${iol_schema}.icms_credit2_jb_inacctinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_credit2_jb_inacctinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_credit2_jb_inacctinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_credit2_jb_inacctinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);