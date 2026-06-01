/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_batch_flow
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.tbps_cpr_batch_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_batch_flow;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_batch_flow_op purge;
drop table ${iol_schema}.tbps_cpr_batch_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_batch_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_batch_flow where 0=1;

create table ${iol_schema}.tbps_cpr_batch_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_batch_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_batch_flow_cl(
            bfl_batchno -- 批次号
            ,bfl_trade_flowno -- 流水号
            ,bfl_ecifno -- 全行统一客户号
            ,bfl_userno -- 录入操作员
            ,bfl_username -- 录入操作员姓名
            ,bfl_valuedate -- 预约日期
            ,bfl_currency -- 币种
            ,bfl_payacc -- 付款方账号
            ,bfl_payname -- 付款方户名
            ,bfl_paynode -- 付款方网点
            ,bfl_transauthtype -- 安全工具类型
            ,bfl_totalcount -- 总笔数
            ,bfl_totalamount -- 总金额
            ,bfl_successcount -- 成功笔数
            ,bfl_successamount -- 成功金额
            ,bfl_failcount -- 失败笔数
            ,bfl_failamount -- 失败金额
            ,bfl_fee -- 费用
            ,bfl_transdate -- 交易日期
            ,bfl_transtime -- 交易时间
            ,bfl_schedulestarttime -- 定时启动时间
            ,bfl_scheduleendtime -- 定时结束时间
            ,bfl_bsncode -- 交易代码
            ,bfl_stt -- 批量状态
            ,bfl_filename -- 文件名
            ,bfl_isnextday -- 是否下一执行日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_batch_flow_op(
            bfl_batchno -- 批次号
            ,bfl_trade_flowno -- 流水号
            ,bfl_ecifno -- 全行统一客户号
            ,bfl_userno -- 录入操作员
            ,bfl_username -- 录入操作员姓名
            ,bfl_valuedate -- 预约日期
            ,bfl_currency -- 币种
            ,bfl_payacc -- 付款方账号
            ,bfl_payname -- 付款方户名
            ,bfl_paynode -- 付款方网点
            ,bfl_transauthtype -- 安全工具类型
            ,bfl_totalcount -- 总笔数
            ,bfl_totalamount -- 总金额
            ,bfl_successcount -- 成功笔数
            ,bfl_successamount -- 成功金额
            ,bfl_failcount -- 失败笔数
            ,bfl_failamount -- 失败金额
            ,bfl_fee -- 费用
            ,bfl_transdate -- 交易日期
            ,bfl_transtime -- 交易时间
            ,bfl_schedulestarttime -- 定时启动时间
            ,bfl_scheduleendtime -- 定时结束时间
            ,bfl_bsncode -- 交易代码
            ,bfl_stt -- 批量状态
            ,bfl_filename -- 文件名
            ,bfl_isnextday -- 是否下一执行日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bfl_batchno, o.bfl_batchno) as bfl_batchno -- 批次号
    ,nvl(n.bfl_trade_flowno, o.bfl_trade_flowno) as bfl_trade_flowno -- 流水号
    ,nvl(n.bfl_ecifno, o.bfl_ecifno) as bfl_ecifno -- 全行统一客户号
    ,nvl(n.bfl_userno, o.bfl_userno) as bfl_userno -- 录入操作员
    ,nvl(n.bfl_username, o.bfl_username) as bfl_username -- 录入操作员姓名
    ,nvl(n.bfl_valuedate, o.bfl_valuedate) as bfl_valuedate -- 预约日期
    ,nvl(n.bfl_currency, o.bfl_currency) as bfl_currency -- 币种
    ,nvl(n.bfl_payacc, o.bfl_payacc) as bfl_payacc -- 付款方账号
    ,nvl(n.bfl_payname, o.bfl_payname) as bfl_payname -- 付款方户名
    ,nvl(n.bfl_paynode, o.bfl_paynode) as bfl_paynode -- 付款方网点
    ,nvl(n.bfl_transauthtype, o.bfl_transauthtype) as bfl_transauthtype -- 安全工具类型
    ,nvl(n.bfl_totalcount, o.bfl_totalcount) as bfl_totalcount -- 总笔数
    ,nvl(n.bfl_totalamount, o.bfl_totalamount) as bfl_totalamount -- 总金额
    ,nvl(n.bfl_successcount, o.bfl_successcount) as bfl_successcount -- 成功笔数
    ,nvl(n.bfl_successamount, o.bfl_successamount) as bfl_successamount -- 成功金额
    ,nvl(n.bfl_failcount, o.bfl_failcount) as bfl_failcount -- 失败笔数
    ,nvl(n.bfl_failamount, o.bfl_failamount) as bfl_failamount -- 失败金额
    ,nvl(n.bfl_fee, o.bfl_fee) as bfl_fee -- 费用
    ,nvl(n.bfl_transdate, o.bfl_transdate) as bfl_transdate -- 交易日期
    ,nvl(n.bfl_transtime, o.bfl_transtime) as bfl_transtime -- 交易时间
    ,nvl(n.bfl_schedulestarttime, o.bfl_schedulestarttime) as bfl_schedulestarttime -- 定时启动时间
    ,nvl(n.bfl_scheduleendtime, o.bfl_scheduleendtime) as bfl_scheduleendtime -- 定时结束时间
    ,nvl(n.bfl_bsncode, o.bfl_bsncode) as bfl_bsncode -- 交易代码
    ,nvl(n.bfl_stt, o.bfl_stt) as bfl_stt -- 批量状态
    ,nvl(n.bfl_filename, o.bfl_filename) as bfl_filename -- 文件名
    ,nvl(n.bfl_isnextday, o.bfl_isnextday) as bfl_isnextday -- 是否下一执行日
    ,case when
            n.bfl_batchno is null
            and n.bfl_trade_flowno is null
            and n.bfl_ecifno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bfl_batchno is null
            and n.bfl_trade_flowno is null
            and n.bfl_ecifno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bfl_batchno is null
            and n.bfl_trade_flowno is null
            and n.bfl_ecifno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_batch_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_batch_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bfl_batchno = n.bfl_batchno
            and o.bfl_trade_flowno = n.bfl_trade_flowno
            and o.bfl_ecifno = n.bfl_ecifno
where (
        o.bfl_batchno is null
        and o.bfl_trade_flowno is null
        and o.bfl_ecifno is null
    )
    or (
        n.bfl_batchno is null
        and n.bfl_trade_flowno is null
        and n.bfl_ecifno is null
    )
    or (
        o.bfl_userno <> n.bfl_userno
        or o.bfl_username <> n.bfl_username
        or o.bfl_valuedate <> n.bfl_valuedate
        or o.bfl_currency <> n.bfl_currency
        or o.bfl_payacc <> n.bfl_payacc
        or o.bfl_payname <> n.bfl_payname
        or o.bfl_paynode <> n.bfl_paynode
        or o.bfl_transauthtype <> n.bfl_transauthtype
        or o.bfl_totalcount <> n.bfl_totalcount
        or o.bfl_totalamount <> n.bfl_totalamount
        or o.bfl_successcount <> n.bfl_successcount
        or o.bfl_successamount <> n.bfl_successamount
        or o.bfl_failcount <> n.bfl_failcount
        or o.bfl_failamount <> n.bfl_failamount
        or o.bfl_fee <> n.bfl_fee
        or o.bfl_transdate <> n.bfl_transdate
        or o.bfl_transtime <> n.bfl_transtime
        or o.bfl_schedulestarttime <> n.bfl_schedulestarttime
        or o.bfl_scheduleendtime <> n.bfl_scheduleendtime
        or o.bfl_bsncode <> n.bfl_bsncode
        or o.bfl_stt <> n.bfl_stt
        or o.bfl_filename <> n.bfl_filename
        or o.bfl_isnextday <> n.bfl_isnextday
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_batch_flow_cl(
            bfl_batchno -- 批次号
            ,bfl_trade_flowno -- 流水号
            ,bfl_ecifno -- 全行统一客户号
            ,bfl_userno -- 录入操作员
            ,bfl_username -- 录入操作员姓名
            ,bfl_valuedate -- 预约日期
            ,bfl_currency -- 币种
            ,bfl_payacc -- 付款方账号
            ,bfl_payname -- 付款方户名
            ,bfl_paynode -- 付款方网点
            ,bfl_transauthtype -- 安全工具类型
            ,bfl_totalcount -- 总笔数
            ,bfl_totalamount -- 总金额
            ,bfl_successcount -- 成功笔数
            ,bfl_successamount -- 成功金额
            ,bfl_failcount -- 失败笔数
            ,bfl_failamount -- 失败金额
            ,bfl_fee -- 费用
            ,bfl_transdate -- 交易日期
            ,bfl_transtime -- 交易时间
            ,bfl_schedulestarttime -- 定时启动时间
            ,bfl_scheduleendtime -- 定时结束时间
            ,bfl_bsncode -- 交易代码
            ,bfl_stt -- 批量状态
            ,bfl_filename -- 文件名
            ,bfl_isnextday -- 是否下一执行日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_batch_flow_op(
            bfl_batchno -- 批次号
            ,bfl_trade_flowno -- 流水号
            ,bfl_ecifno -- 全行统一客户号
            ,bfl_userno -- 录入操作员
            ,bfl_username -- 录入操作员姓名
            ,bfl_valuedate -- 预约日期
            ,bfl_currency -- 币种
            ,bfl_payacc -- 付款方账号
            ,bfl_payname -- 付款方户名
            ,bfl_paynode -- 付款方网点
            ,bfl_transauthtype -- 安全工具类型
            ,bfl_totalcount -- 总笔数
            ,bfl_totalamount -- 总金额
            ,bfl_successcount -- 成功笔数
            ,bfl_successamount -- 成功金额
            ,bfl_failcount -- 失败笔数
            ,bfl_failamount -- 失败金额
            ,bfl_fee -- 费用
            ,bfl_transdate -- 交易日期
            ,bfl_transtime -- 交易时间
            ,bfl_schedulestarttime -- 定时启动时间
            ,bfl_scheduleendtime -- 定时结束时间
            ,bfl_bsncode -- 交易代码
            ,bfl_stt -- 批量状态
            ,bfl_filename -- 文件名
            ,bfl_isnextday -- 是否下一执行日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bfl_batchno -- 批次号
    ,o.bfl_trade_flowno -- 流水号
    ,o.bfl_ecifno -- 全行统一客户号
    ,o.bfl_userno -- 录入操作员
    ,o.bfl_username -- 录入操作员姓名
    ,o.bfl_valuedate -- 预约日期
    ,o.bfl_currency -- 币种
    ,o.bfl_payacc -- 付款方账号
    ,o.bfl_payname -- 付款方户名
    ,o.bfl_paynode -- 付款方网点
    ,o.bfl_transauthtype -- 安全工具类型
    ,o.bfl_totalcount -- 总笔数
    ,o.bfl_totalamount -- 总金额
    ,o.bfl_successcount -- 成功笔数
    ,o.bfl_successamount -- 成功金额
    ,o.bfl_failcount -- 失败笔数
    ,o.bfl_failamount -- 失败金额
    ,o.bfl_fee -- 费用
    ,o.bfl_transdate -- 交易日期
    ,o.bfl_transtime -- 交易时间
    ,o.bfl_schedulestarttime -- 定时启动时间
    ,o.bfl_scheduleendtime -- 定时结束时间
    ,o.bfl_bsncode -- 交易代码
    ,o.bfl_stt -- 批量状态
    ,o.bfl_filename -- 文件名
    ,o.bfl_isnextday -- 是否下一执行日
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_batch_flow_bk o
    left join ${iol_schema}.tbps_cpr_batch_flow_op n
        on
            o.bfl_batchno = n.bfl_batchno
            and o.bfl_trade_flowno = n.bfl_trade_flowno
            and o.bfl_ecifno = n.bfl_ecifno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_batch_flow_cl d
        on
            o.bfl_batchno = d.bfl_batchno
            and o.bfl_trade_flowno = d.bfl_trade_flowno
            and o.bfl_ecifno = d.bfl_ecifno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_batch_flow;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_batch_flow exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_batch_flow_cl;
alter table ${iol_schema}.tbps_cpr_batch_flow exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_batch_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_batch_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_batch_flow_op purge;
drop table ${iol_schema}.tbps_cpr_batch_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_batch_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_batch_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
