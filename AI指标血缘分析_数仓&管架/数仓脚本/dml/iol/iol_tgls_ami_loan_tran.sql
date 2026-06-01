/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_ami_loan_tran
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
drop table ${iol_schema}.tgls_ami_loan_tran_ex purge;
alter table ${iol_schema}.tgls_ami_loan_tran add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_ami_loan_tran truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_ami_loan_tran_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_ami_loan_tran where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_ami_loan_tran_ex(
    stacid -- 账套
    ,systid -- 来源系统编号
    ,datadt -- 数据日期
    ,bathid -- 批次号
    ,loanno -- 贷款账户编号
    ,transq -- 交易流水
    ,evensq -- 交易事件序号
    ,errotg -- 错误标志
    ,erromg -- 错误信息
    ,odlnno -- 旧贷款账户编号
    ,crcycd -- 币种
    ,busitp -- 业务类型
    ,prducd -- 产品编号
    ,deptcd -- 贷款网点
    ,flowno -- 柜员流水
    ,trandt -- 交易日期
    ,tranbr -- 交易机构编号
    ,accrtg -- 应计标识
    ,status -- 贷款状态,01-正常，02-结清，03-核销
    ,eventp -- 交易场景
    ,evencd -- 交易码
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
    ,attra1 -- 渠道编号
    ,attra2 -- 附加属性2
    ,attra3 -- 附加属性3
    ,attra4 -- 附加属性4
    ,attra5 -- 附加属性5
    ,attra6 -- 附加属性6
    ,attra7 -- 附加属性7
    ,attra8 -- 附加属性8
    ,attra9 -- 附加属性9
    ,attraa -- 附加属性10
    ,netrsq -- 新交易流水
    ,tranti -- 时间
    ,dealtg -- 处理状态，‘a’-待处理，1-成功，2-失败
    ,evetdn -- 交易方向
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,systid -- 来源系统编号
    ,datadt -- 数据日期
    ,bathid -- 批次号
    ,loanno -- 贷款账户编号
    ,transq -- 交易流水
    ,evensq -- 交易事件序号
    ,errotg -- 错误标志
    ,erromg -- 错误信息
    ,odlnno -- 旧贷款账户编号
    ,crcycd -- 币种
    ,busitp -- 业务类型
    ,prducd -- 产品编号
    ,deptcd -- 贷款网点
    ,flowno -- 柜员流水
    ,trandt -- 交易日期
    ,tranbr -- 交易机构编号
    ,accrtg -- 应计标识
    ,status -- 贷款状态,01-正常，02-结清，03-核销
    ,eventp -- 交易场景
    ,evencd -- 交易码
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
    ,attra1 -- 渠道编号
    ,attra2 -- 附加属性2
    ,attra3 -- 附加属性3
    ,attra4 -- 附加属性4
    ,attra5 -- 附加属性5
    ,attra6 -- 附加属性6
    ,attra7 -- 附加属性7
    ,attra8 -- 附加属性8
    ,attra9 -- 附加属性9
    ,attraa -- 附加属性10
    ,netrsq -- 新交易流水
    ,tranti -- 时间
    ,dealtg -- 处理状态，‘a’-待处理，1-成功，2-失败
    ,evetdn -- 交易方向
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_ami_loan_tran
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_ami_loan_tran exchange partition p_${batch_date} with table ${iol_schema}.tgls_ami_loan_tran_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_ami_loan_tran to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_ami_loan_tran_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_ami_loan_tran',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);