/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_trb_busi
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
drop table ${iol_schema}.tgls_trb_busi_ex purge;
alter table ${iol_schema}.tgls_trb_busi add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_trb_busi truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_trb_busi_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_trb_busi where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_trb_busi_ex(
    stacid -- 账套
    ,systid -- 来源系统编号
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,custcd -- 客户编号
    ,tranbr -- 交易机构编号
    ,acctbr -- 账务机构编号
    ,typecd -- 应税类别
    ,tranam -- 交易金额
    ,smrytx -- 备注
    ,trstat -- 状态（0：未处理1：已处理）
    ,prcscd -- 交易码
    ,vatxrt -- 税率
    ,vatxam -- 税额
    ,pricam -- 净价格
    ,strkdt -- 被冲正业务日期
    ,strksq -- 被冲正业务流水号
    ,strkst -- 流水标识（0：非冲正1：冲正流水2：补账流水）
    ,openam -- 交易金额
    ,prcsna -- 交易码名称
    ,vchrsq -- 传票流水
    ,crcycd -- 币种（交易）
    ,crcyiv -- 币种（开票）
    ,itemcd -- 价税分离科目编号
    ,itemna -- 价税分离科目名称
    ,sperdt -- 价税分离日期
    ,sourst -- 源业务交易流水
    ,sourdt -- 源业务交易日期
    ,soursq -- 源业务交易流水
    ,sourno -- 源业务交易流水序号
    ,prodcd -- 产品编号
    ,serino -- 涉票流水序号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,systid -- 来源系统编号
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,custcd -- 客户编号
    ,tranbr -- 交易机构编号
    ,acctbr -- 账务机构编号
    ,typecd -- 应税类别
    ,tranam -- 交易金额
    ,smrytx -- 备注
    ,trstat -- 状态（0：未处理1：已处理）
    ,prcscd -- 交易码
    ,vatxrt -- 税率
    ,vatxam -- 税额
    ,pricam -- 净价格
    ,strkdt -- 被冲正业务日期
    ,strksq -- 被冲正业务流水号
    ,strkst -- 流水标识（0：非冲正1：冲正流水2：补账流水）
    ,openam -- 交易金额
    ,prcsna -- 交易码名称
    ,vchrsq -- 传票流水
    ,crcycd -- 币种（交易）
    ,crcyiv -- 币种（开票）
    ,itemcd -- 价税分离科目编号
    ,itemna -- 价税分离科目名称
    ,sperdt -- 价税分离日期
    ,sourst -- 源业务交易流水
    ,sourdt -- 源业务交易日期
    ,soursq -- 源业务交易流水
    ,sourno -- 源业务交易流水序号
    ,prodcd -- 产品编号
    ,serino -- 涉票流水序号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_trb_busi
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_trb_busi exchange partition p_${batch_date} with table ${iol_schema}.tgls_trb_busi_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_trb_busi to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_trb_busi_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_trb_busi',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);