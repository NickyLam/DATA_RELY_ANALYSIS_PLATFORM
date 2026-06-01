/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1stfintranlist
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
drop table ${iol_schema}.mpcs_a1stfintranlist_ex purge;
alter table ${iol_schema}.mpcs_a1stfintranlist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a1stfintranlist;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1stfintranlist_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a1stfintranlist where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1stfintranlist_ex(
    syscd -- 系统码
    ,mainseq -- 中台流水
    ,transdt -- 中台日期
    ,transtm -- 中台时间
    ,businesstrace -- 行内业务序号
    ,pckno -- 报文类型
    ,hosttrcd -- 金融交易码
    ,fronttrcd -- 中台交易码
    ,magebrn -- 管理机构
    ,brcno -- 交易机构
    ,userid -- 柜员
    ,trntp -- 交易类型:1-记账，2-冲账
    ,status -- 状态:1-成功，E-失败
    ,hostdate -- 金融交易日期
    ,hostnbr -- 金融交易流水
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,incoacct -- 收款人账号
    ,inconame -- 收款人名称
    ,dataid -- 支付流水号
    ,orgdataid -- 原支付流水号
    ,errcode -- 返回代码
    ,errms -- 返回信息
    ,transamt -- 交易金额
    ,abscde -- 记账分录
    ,colldt -- 对账日期
    ,colsts -- 对账状态
    ,batchid -- 交易批次号
    ,changtime -- 更新时间
    ,globalseqno -- 全局流水号
    ,chnid -- 渠道编号
    ,revreason -- 冲正原因
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    syscd -- 系统码
    ,mainseq -- 中台流水
    ,transdt -- 中台日期
    ,transtm -- 中台时间
    ,businesstrace -- 行内业务序号
    ,pckno -- 报文类型
    ,hosttrcd -- 金融交易码
    ,fronttrcd -- 中台交易码
    ,magebrn -- 管理机构
    ,brcno -- 交易机构
    ,userid -- 柜员
    ,trntp -- 交易类型:1-记账，2-冲账
    ,status -- 状态:1-成功，E-失败
    ,hostdate -- 金融交易日期
    ,hostnbr -- 金融交易流水
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,incoacct -- 收款人账号
    ,inconame -- 收款人名称
    ,dataid -- 支付流水号
    ,orgdataid -- 原支付流水号
    ,errcode -- 返回代码
    ,errms -- 返回信息
    ,transamt -- 交易金额
    ,abscde -- 记账分录
    ,colldt -- 对账日期
    ,colsts -- 对账状态
    ,batchid -- 交易批次号
    ,changtime -- 更新时间
    ,globalseqno -- 全局流水号
    ,chnid -- 渠道编号
    ,revreason -- 冲正原因
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1stfintranlist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1stfintranlist exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1stfintranlist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1stfintranlist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1stfintranlist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1stfintranlist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);