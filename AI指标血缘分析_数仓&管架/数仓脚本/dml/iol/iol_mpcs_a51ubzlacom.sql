/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubzlacom
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
drop table ${iol_schema}.mpcs_a51ubzlacom_ex purge;
alter table ${iol_schema}.mpcs_a51ubzlacom add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a51ubzlacom;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a51ubzlacom_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a51ubzlacom where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a51ubzlacom_ex(
    acqinstid -- 代理机构标识码
    ,fwdinstid -- 发送机构标识码
    ,systrace -- 系统跟踪号
    ,transtime -- 交易传输时间
    ,transdate -- 交易日期
    ,priacct -- 主账号
    ,transamt -- 交易金额
    ,acceptamt -- 部分代收时的承兑金额
    ,handfee -- 持卡人交易手续费
    ,msgtype -- 报文类型
    ,procecode -- 交易类型码
    ,mchnttype -- 商户类型
    ,acptermnlid -- 受卡机终端标识码
    ,accptrid -- 受卡方标识码
    ,retrivarefnum -- 检索参考号
    ,servicecode -- 服务点条件码
    ,authridresp -- 授权应答码
    ,rcvinstid -- 接收机构标识码
    ,oldsystrace -- 原始交易的系统跟踪号
    ,respcode -- 交易返回码
    ,posentrymode -- 服务点输入方式码
    ,duehandchrg -- 应付交换费
    ,rcvhandchrg -- 收交换费
    ,covhangchrg -- 转接清算费
    ,sindouchflg -- 单双转换标志
    ,cardseqno -- 卡片序列号
    ,termable -- 终端读取能力
    ,iccode -- ic卡条件代码
    ,oldtranstime -- 原始交易日期时间
    ,issurinstid -- 发卡机构标识码
    ,transarea -- 交易地域标志
    ,termtype -- 终端类型
    ,ectflg -- eci标志
    ,addfee -- 分期付款附加手续费
    ,other -- 其他信息
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acqinstid -- 代理机构标识码
    ,fwdinstid -- 发送机构标识码
    ,systrace -- 系统跟踪号
    ,transtime -- 交易传输时间
    ,transdate -- 交易日期
    ,priacct -- 主账号
    ,transamt -- 交易金额
    ,acceptamt -- 部分代收时的承兑金额
    ,handfee -- 持卡人交易手续费
    ,msgtype -- 报文类型
    ,procecode -- 交易类型码
    ,mchnttype -- 商户类型
    ,acptermnlid -- 受卡机终端标识码
    ,accptrid -- 受卡方标识码
    ,retrivarefnum -- 检索参考号
    ,servicecode -- 服务点条件码
    ,authridresp -- 授权应答码
    ,rcvinstid -- 接收机构标识码
    ,oldsystrace -- 原始交易的系统跟踪号
    ,respcode -- 交易返回码
    ,posentrymode -- 服务点输入方式码
    ,duehandchrg -- 应付交换费
    ,rcvhandchrg -- 收交换费
    ,covhangchrg -- 转接清算费
    ,sindouchflg -- 单双转换标志
    ,cardseqno -- 卡片序列号
    ,termable -- 终端读取能力
    ,iccode -- ic卡条件代码
    ,oldtranstime -- 原始交易日期时间
    ,issurinstid -- 发卡机构标识码
    ,transarea -- 交易地域标志
    ,termtype -- 终端类型
    ,ectflg -- eci标志
    ,addfee -- 分期付款附加手续费
    ,other -- 其他信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubzlacom
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a51ubzlacom exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a51ubzlacom_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubzlacom to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a51ubzlacom_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubzlacom',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);