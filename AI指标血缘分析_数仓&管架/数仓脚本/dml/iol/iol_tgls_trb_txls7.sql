/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_trb_txls7
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
drop table ${iol_schema}.tgls_trb_txls7_ex purge;
alter table ${iol_schema}.tgls_trb_txls7 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_trb_txls7 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_trb_txls7_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_trb_txls7 where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_trb_txls7_ex(
    stacid -- 账套
    ,systid -- 来源系统编号
    ,trandt -- 交易日期
    ,tranbr -- 交易机构编号
    ,transq -- 交易流水号
    ,custcd -- 客户编号
    ,busitp -- 业务类别
    ,tranam -- 交易金额
    ,taxbam -- 税额
    ,smrytx -- 备注
    ,status -- 状态
    ,acctbr -- 账务机构编号
    ,vchrsq -- 传票序号
    ,catxtp -- 计税方式
    ,exeptg -- 应税标识——对销项适用
    ,vatxrt -- 税率
    ,pricam -- 交易金额
    ,typecd -- 税目代码
    ,crcycd -- 币种代码
    ,crcysd -- 开票币种
    ,extxam -- 税额（开票币种）
    ,exchrt -- 折算汇率
    ,itemcd -- 价税分离科目编号
    ,itemna -- 价税分离科目名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,systid -- 来源系统编号
    ,trandt -- 交易日期
    ,tranbr -- 交易机构编号
    ,transq -- 交易流水号
    ,custcd -- 客户编号
    ,busitp -- 业务类别
    ,tranam -- 交易金额
    ,taxbam -- 税额
    ,smrytx -- 备注
    ,status -- 状态
    ,acctbr -- 账务机构编号
    ,vchrsq -- 传票序号
    ,catxtp -- 计税方式
    ,exeptg -- 应税标识——对销项适用
    ,vatxrt -- 税率
    ,pricam -- 交易金额
    ,typecd -- 税目代码
    ,crcycd -- 币种代码
    ,crcysd -- 开票币种
    ,extxam -- 税额（开票币种）
    ,exchrt -- 折算汇率
    ,itemcd -- 价税分离科目编号
    ,itemna -- 价税分离科目名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_trb_txls7
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_trb_txls7 exchange partition p_${batch_date} with table ${iol_schema}.tgls_trb_txls7_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_trb_txls7 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_trb_txls7_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_trb_txls7',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);