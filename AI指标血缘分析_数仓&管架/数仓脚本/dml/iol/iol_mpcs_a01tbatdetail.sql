/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a01tbatdetail
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
drop table ${iol_schema}.mpcs_a01tbatdetail_ex purge;
alter table ${iol_schema}.mpcs_a01tbatdetail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a01tbatdetail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a01tbatdetail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a01tbatdetail where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a01tbatdetail_ex(
    batchdt -- 批次日期
    ,batchno -- 批次流水
    ,fntdt -- 前置日期
    ,fntseqno -- 前置流水
    ,trntype -- 处理类型00－扣款05－入账10－解冻并扣款15－入账并冻结20－解冻25－冻结此类型是站在[明细账户]的角度定义.
    ,prdcd -- 产品代码
    ,recordno -- 记录编号
    ,bgndt -- 缴费起始日期
    ,enddt -- 缴费结束日期
    ,trnmonth -- 缴费月数
    ,payacctno -- 明细账号
    ,trnamt -- 交易金额
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,amt4 -- 备用金额4
    ,paytype -- 扣款模式0－可用余额必须大于等于请求金额,不够则失败1－可用余额大余零则处理,等于零则失败处理类型为:00时需送
    ,memocd -- 摘要代码
    ,dt1 -- 备用日期1
    ,prtmemocd -- 打印摘要
    ,oppoacctno -- 代理账号记账对手方账号
    ,payacctname -- 明细账号户名
    ,freezedt -- 原止付交易日期
    ,freezeno -- 原止付交易流水
    ,succamt -- 成功金额
    ,hostseqno -- 核心交易流水
    ,hostseqdt -- 核心交易日期
    ,rspcd -- 响应码
    ,rspmsg -- 响应信息
    ,otherbankno -- 他行联行号
    ,addword -- 附言
    ,orderid -- 订单标识
    ,upptranseqno -- 交易流水号
    ,trndate -- 中台交易日期
    ,glob_seq_num -- 全局流水号
    ,srv_cllpty_trx_seq -- 交易流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    batchdt -- 批次日期
    ,batchno -- 批次流水
    ,fntdt -- 前置日期
    ,fntseqno -- 前置流水
    ,trntype -- 处理类型00－扣款05－入账10－解冻并扣款15－入账并冻结20－解冻25－冻结此类型是站在[明细账户]的角度定义.
    ,prdcd -- 产品代码
    ,recordno -- 记录编号
    ,bgndt -- 缴费起始日期
    ,enddt -- 缴费结束日期
    ,trnmonth -- 缴费月数
    ,payacctno -- 明细账号
    ,trnamt -- 交易金额
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,amt4 -- 备用金额4
    ,paytype -- 扣款模式0－可用余额必须大于等于请求金额,不够则失败1－可用余额大余零则处理,等于零则失败处理类型为:00时需送
    ,memocd -- 摘要代码
    ,dt1 -- 备用日期1
    ,prtmemocd -- 打印摘要
    ,oppoacctno -- 代理账号记账对手方账号
    ,payacctname -- 明细账号户名
    ,freezedt -- 原止付交易日期
    ,freezeno -- 原止付交易流水
    ,succamt -- 成功金额
    ,hostseqno -- 核心交易流水
    ,hostseqdt -- 核心交易日期
    ,rspcd -- 响应码
    ,rspmsg -- 响应信息
    ,otherbankno -- 他行联行号
    ,addword -- 附言
    ,orderid -- 订单标识
    ,upptranseqno -- 交易流水号
    ,trndate -- 中台交易日期
    ,glob_seq_num -- 全局流水号
    ,srv_cllpty_trx_seq -- 交易流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a01tbatdetail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a01tbatdetail exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a01tbatdetail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a01tbatdetail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a01tbatdetail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a01tbatdetail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);