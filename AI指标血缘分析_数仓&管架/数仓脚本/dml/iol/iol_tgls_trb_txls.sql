/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_trb_txls
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
drop table ${iol_schema}.tgls_trb_txls_ex purge;
alter table ${iol_schema}.tgls_trb_txls add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_trb_txls truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_trb_txls_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_trb_txls where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_trb_txls_ex(
    stacid -- 账套
    ,systid -- 业务来源系统编号
    ,trandt -- 交易日期
    ,tranbr -- 交易机构编号
    ,transq -- 交易流水
    ,acctbr -- 账务机构编号
    ,vchrsq -- 传票序号
    ,custcd -- 客户编号
    ,busitp -- 业务类别
    ,crcycd -- 币种（交易）
    ,tranam -- 交易金额（含税）
    ,vatxrt -- 税率
    ,taxbam -- 税额
    ,pricam -- 交易金额（不含税）
    ,smrytx -- 备注
    ,status -- 状态
    ,catxtp -- 计税方式（s：简易计税n：一般计税）
    ,exeptg -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
    ,typecd -- 税目代码
    ,crcyiv -- 开票币种
    ,exchrt -- 折算汇率
    ,expram -- 净价折算金额
    ,itemcd -- 科目编号
    ,itemna -- 科目名称
    ,extxam -- 税额折算金额
    ,pritem -- 净价科目编号
    ,txitem -- 税额科目编号
    ,serino -- 应税流水序号
    ,prodcd -- 产品编号
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
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,systid -- 业务来源系统编号
    ,trandt -- 交易日期
    ,tranbr -- 交易机构编号
    ,transq -- 交易流水
    ,acctbr -- 账务机构编号
    ,vchrsq -- 传票序号
    ,custcd -- 客户编号
    ,busitp -- 业务类别
    ,crcycd -- 币种（交易）
    ,tranam -- 交易金额（含税）
    ,vatxrt -- 税率
    ,taxbam -- 税额
    ,pricam -- 交易金额（不含税）
    ,smrytx -- 备注
    ,status -- 状态
    ,catxtp -- 计税方式（s：简易计税n：一般计税）
    ,exeptg -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
    ,typecd -- 税目代码
    ,crcyiv -- 开票币种
    ,exchrt -- 折算汇率
    ,expram -- 净价折算金额
    ,itemcd -- 科目编号
    ,itemna -- 科目名称
    ,extxam -- 税额折算金额
    ,pritem -- 净价科目编号
    ,txitem -- 税额科目编号
    ,serino -- 应税流水序号
    ,prodcd -- 产品编号
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
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_trb_txls
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_trb_txls exchange partition p_${batch_date} with table ${iol_schema}.tgls_trb_txls_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_trb_txls to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_trb_txls_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_trb_txls',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);