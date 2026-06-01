/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_ami_loan_acct
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
drop table ${iol_schema}.tgls_ami_loan_acct_ex purge;
alter table ${iol_schema}.tgls_ami_loan_acct add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_ami_loan_acct truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_ami_loan_acct_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_ami_loan_acct where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_ami_loan_acct_ex(
    stacid -- 账套
    ,systid -- 来源系统编号
    ,datadt -- 数据日期
    ,bathid -- 批次号
    ,loanno -- 贷款账户编号
    ,debtno -- 贷款借据编号
    ,busitp -- 业务类型
    ,prducd -- 产品编号
    ,crcycd -- 币种
    ,lnctno -- 合同编号
    ,odlnno -- 旧贷款账户编号
    ,descpt -- 贷款说明
    ,deptcd -- 贷款网点
    ,accrtg -- 应计标识
    ,amortg -- 摊销标识
    ,extetg -- 展期标识
    ,secutg -- 资产证券化状态
    ,incotg -- 撤并标识
    ,dscttg -- 贴息标识
    ,adittg -- 预收息标识
    ,status -- 贷款状态,01-正常，02-结清，03-核销
    ,ratenr -- 正常利率
    ,ratecy -- 正常利率周期
    ,ovdurt -- 逾期利率
    ,ovducy -- 逾期利率周期
    ,compra -- 复利利率
    ,compcy -- 复利利率周期
    ,gracrt -- 宽限期利率
    ,graccy -- 宽限期利率周期
    ,amorfr -- 摊销频度
    ,stindt -- 起息日
    ,nesedt -- 下期结息日
    ,exindt -- 展期到期日
    ,gracdy -- 宽限期
    ,intetg -- 计息标志
    ,custcd -- 客户代码
    ,custna -- 客户名称
    ,drafcd -- 承兑人代码
    ,drafna -- 承兑人名称
    ,riskcd -- 贷款五级分类
    ,phascd -- 贷款阶段
    ,devaam -- 贷款减值金额
    ,credco -- 贷前费用
    ,issudt -- 贷款放款日期
    ,actuam -- 实际发放金额
    ,issuam -- 贷款放款金额
    ,expidt -- 贷款到期日期
    ,retuwy -- 还本付息方式
    ,recocy -- 本金付款周期
    ,recofr -- 本金付款频率
    ,reincy -- 利息付款周期
    ,reinfr -- 利息付款频率
    ,necodt -- 下次还本日
    ,neredt -- 下次还息日
    ,prodp1 -- 产品属性1
    ,prodp2 -- 产品属性2
    ,prodp3 -- 产品属性3
    ,prodp4 -- 产品属性4
    ,prodp5 -- 产品属性5
    ,prodp6 -- 产品属性6
    ,prodp7 -- 产品属性7
    ,prodp8 -- 产品属性8
    ,prodp9 -- 产品属性9
    ,prodpa -- 产品属性10
    ,normpr -- 正常本金
    ,ovdupr -- 逾期本金
    ,dullpr -- 呆滞本金
    ,reacin -- 应收应计利息
    ,coacin -- 催收应计利息
    ,recede -- 应收欠息
    ,collde -- 催收欠息
    ,reacpe -- 应收应计罚息
    ,coacpe -- 催收应计罚息
    ,recepe -- 应收罚息
    ,collpe -- 催收罚息
    ,accoin -- 应计复息
    ,compin -- 复息
    ,accuso -- 应计贴息
    ,receso -- 应收贴息
    ,prepin -- 待摊利息
    ,veripr -- 核销本金
    ,veriin -- 核销利息
    ,income -- 利息收入
    ,overin -- 催收贴息
    ,hvvein -- 已核销本金利息
    ,amou01 -- 金额01
    ,amou02 -- 金额02
    ,amou03 -- 金额03
    ,amou04 -- 金额04
    ,amou05 -- 金额05
    ,amou06 -- 金额06
    ,amou07 -- 金额07
    ,attra1 -- 附加属性1
    ,attra2 -- 附加属性2
    ,attra3 -- 附加属性3
    ,attra4 -- 附加属性4
    ,attra5 -- 附加属性5
    ,attra6 -- 附加属性6
    ,attra7 -- 附加属性7
    ,attra8 -- 附加属性8
    ,attra9 -- 附加属性9
    ,attraa -- 附加属性10
    ,puprtg -- 客户类型
    ,tranti -- 时间
    ,amou08 -- 金额08
    ,amou09 -- 金额09
    ,amou10 -- 金额10
    ,amou11 -- 金额11
    ,amou12 -- 金额12
    ,amou13 -- 金额13
    ,amou14 -- 金额14
    ,amou15 -- 金额15
    ,amou16 -- 金额16
    ,amou17 -- 金额17
    ,amou18 -- 金额18
    ,amou19 -- 金额19
    ,amou20 -- 金额20
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,systid -- 来源系统编号
    ,datadt -- 数据日期
    ,bathid -- 批次号
    ,loanno -- 贷款账户编号
    ,debtno -- 贷款借据编号
    ,busitp -- 业务类型
    ,prducd -- 产品编号
    ,crcycd -- 币种
    ,lnctno -- 合同编号
    ,odlnno -- 旧贷款账户编号
    ,descpt -- 贷款说明
    ,deptcd -- 贷款网点
    ,accrtg -- 应计标识
    ,amortg -- 摊销标识
    ,extetg -- 展期标识
    ,secutg -- 资产证券化状态
    ,incotg -- 撤并标识
    ,dscttg -- 贴息标识
    ,adittg -- 预收息标识
    ,status -- 贷款状态,01-正常，02-结清，03-核销
    ,ratenr -- 正常利率
    ,ratecy -- 正常利率周期
    ,ovdurt -- 逾期利率
    ,ovducy -- 逾期利率周期
    ,compra -- 复利利率
    ,compcy -- 复利利率周期
    ,gracrt -- 宽限期利率
    ,graccy -- 宽限期利率周期
    ,amorfr -- 摊销频度
    ,stindt -- 起息日
    ,nesedt -- 下期结息日
    ,exindt -- 展期到期日
    ,gracdy -- 宽限期
    ,intetg -- 计息标志
    ,custcd -- 客户代码
    ,custna -- 客户名称
    ,drafcd -- 承兑人代码
    ,drafna -- 承兑人名称
    ,riskcd -- 贷款五级分类
    ,phascd -- 贷款阶段
    ,devaam -- 贷款减值金额
    ,credco -- 贷前费用
    ,issudt -- 贷款放款日期
    ,actuam -- 实际发放金额
    ,issuam -- 贷款放款金额
    ,expidt -- 贷款到期日期
    ,retuwy -- 还本付息方式
    ,recocy -- 本金付款周期
    ,recofr -- 本金付款频率
    ,reincy -- 利息付款周期
    ,reinfr -- 利息付款频率
    ,necodt -- 下次还本日
    ,neredt -- 下次还息日
    ,prodp1 -- 产品属性1
    ,prodp2 -- 产品属性2
    ,prodp3 -- 产品属性3
    ,prodp4 -- 产品属性4
    ,prodp5 -- 产品属性5
    ,prodp6 -- 产品属性6
    ,prodp7 -- 产品属性7
    ,prodp8 -- 产品属性8
    ,prodp9 -- 产品属性9
    ,prodpa -- 产品属性10
    ,normpr -- 正常本金
    ,ovdupr -- 逾期本金
    ,dullpr -- 呆滞本金
    ,reacin -- 应收应计利息
    ,coacin -- 催收应计利息
    ,recede -- 应收欠息
    ,collde -- 催收欠息
    ,reacpe -- 应收应计罚息
    ,coacpe -- 催收应计罚息
    ,recepe -- 应收罚息
    ,collpe -- 催收罚息
    ,accoin -- 应计复息
    ,compin -- 复息
    ,accuso -- 应计贴息
    ,receso -- 应收贴息
    ,prepin -- 待摊利息
    ,veripr -- 核销本金
    ,veriin -- 核销利息
    ,income -- 利息收入
    ,overin -- 催收贴息
    ,hvvein -- 已核销本金利息
    ,amou01 -- 金额01
    ,amou02 -- 金额02
    ,amou03 -- 金额03
    ,amou04 -- 金额04
    ,amou05 -- 金额05
    ,amou06 -- 金额06
    ,amou07 -- 金额07
    ,attra1 -- 附加属性1
    ,attra2 -- 附加属性2
    ,attra3 -- 附加属性3
    ,attra4 -- 附加属性4
    ,attra5 -- 附加属性5
    ,attra6 -- 附加属性6
    ,attra7 -- 附加属性7
    ,attra8 -- 附加属性8
    ,attra9 -- 附加属性9
    ,attraa -- 附加属性10
    ,puprtg -- 客户类型
    ,tranti -- 时间
    ,amou08 -- 金额08
    ,amou09 -- 金额09
    ,amou10 -- 金额10
    ,amou11 -- 金额11
    ,amou12 -- 金额12
    ,amou13 -- 金额13
    ,amou14 -- 金额14
    ,amou15 -- 金额15
    ,amou16 -- 金额16
    ,amou17 -- 金额17
    ,amou18 -- 金额18
    ,amou19 -- 金额19
    ,amou20 -- 金额20
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_ami_loan_acct
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_ami_loan_acct exchange partition p_${batch_date} with table ${iol_schema}.tgls_ami_loan_acct_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_ami_loan_acct to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_ami_loan_acct_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_ami_loan_acct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);