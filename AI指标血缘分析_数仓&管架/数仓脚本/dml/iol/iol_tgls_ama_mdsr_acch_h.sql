/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_ama_mdsr_acch_h
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
drop table ${iol_schema}.tgls_ama_mdsr_acch_h_ex purge;
alter table ${iol_schema}.tgls_ama_mdsr_acch_h add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_ama_mdsr_acch_h truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_ama_mdsr_acch_h_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_ama_mdsr_acch_h where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_ama_mdsr_acch_h_ex(
    stacid -- 账套标记
    ,systid -- 来源系统编号
    ,datadt -- 数据日期
    ,transq -- 交易流水
    ,trancd -- 子交易
    ,bathid -- 批次号
    ,loanno -- 单据编号
    ,busitp -- 业务类型
    ,prducd -- 产品编号
    ,bfprducd -- 调整前产品
    ,deptcd -- 账务机构编号
    ,bfdeptcd -- 调整前账务机构
    ,crcycd -- 币种
    ,lnctno -- 合同编号
    ,descpt -- 业务说明
    ,custcd -- 客户编号
    ,custna -- 客户名称
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
    ,amotrbdt -- 摊销开始日期
    ,amotrodt -- 摊销结束日期
    ,acamotrbdt -- 实际摊销开始日期
    ,normpr -- 待摊总金额
    ,amortam -- 本次摊销金额
    ,amortisedam -- 累计摊销金额
    ,amortst -- 摊销状态
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
    ,islast -- 是否交易场景的最后一条，1-是，0-否
    ,tranti -- 时间_x0013_
    ,sortno -- 序号
    ,eventp -- 交易场景
    ,bsnssq -- 全局流水号
    ,tranbr -- 交易机构编号
    ,amortamredu -- 
    ,changst -- 
    ,chrgmd -- 
    ,daynum -- 
    ,desccg -- 
    ,trandt -- 
    ,amorfr -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标记
    ,systid -- 来源系统编号
    ,datadt -- 数据日期
    ,transq -- 交易流水
    ,trancd -- 子交易
    ,bathid -- 批次号
    ,loanno -- 单据编号
    ,busitp -- 业务类型
    ,prducd -- 产品编号
    ,bfprducd -- 调整前产品
    ,deptcd -- 账务机构编号
    ,bfdeptcd -- 调整前账务机构
    ,crcycd -- 币种
    ,lnctno -- 合同编号
    ,descpt -- 业务说明
    ,custcd -- 客户编号
    ,custna -- 客户名称
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
    ,amotrbdt -- 摊销开始日期
    ,amotrodt -- 摊销结束日期
    ,acamotrbdt -- 实际摊销开始日期
    ,normpr -- 待摊总金额
    ,amortam -- 本次摊销金额
    ,amortisedam -- 累计摊销金额
    ,amortst -- 摊销状态
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
    ,islast -- 是否交易场景的最后一条，1-是，0-否
    ,tranti -- 时间_x0013_
    ,sortno -- 序号
    ,eventp -- 交易场景
    ,bsnssq -- 全局流水号
    ,tranbr -- 交易机构编号
    ,amortamredu -- 
    ,changst -- 
    ,chrgmd -- 
    ,daynum -- 
    ,desccg -- 
    ,trandt -- 
    ,amorfr -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_ama_mdsr_acch_h
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_ama_mdsr_acch_h exchange partition p_${batch_date} with table ${iol_schema}.tgls_ama_mdsr_acch_h_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_ama_mdsr_acch_h to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_ama_mdsr_acch_h_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_ama_mdsr_acch_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);