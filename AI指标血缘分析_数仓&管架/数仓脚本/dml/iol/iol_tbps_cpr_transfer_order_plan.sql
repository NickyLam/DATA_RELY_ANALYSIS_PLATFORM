/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_transfer_order_plan
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
create table ${iol_schema}.tbps_cpr_transfer_order_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_transfer_order_plan;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_transfer_order_plan_op purge;
drop table ${iol_schema}.tbps_cpr_transfer_order_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_transfer_order_plan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_transfer_order_plan where 0=1;

create table ${iol_schema}.tbps_cpr_transfer_order_plan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_transfer_order_plan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_transfer_order_plan_cl(
            top_orderno -- 预约号
            ,top_trade_flowno -- 流水号
            ,top_transdate -- 计划制定日期
            ,top_timertype -- 定时种类
            ,top_timerfreq -- 定时频率种类
            ,top_timerrule -- 定时或者定频规则
            ,top_state -- 状态
            ,top_begindate -- 定时或定频起始日期
            ,top_enddate -- 结束日期
            ,top_canceldate -- 取消日期
            ,top_ordertimes -- 定制执行次数
            ,top_exetimes -- 已执行次数
            ,top_bookingtype -- 预定类型(a预约发工资b预约转账)
            ,top_cui_ecifno -- 全行统一客户号
            ,top_cui_userno -- 用户顺序号
            ,top_authtype -- 认证方式
            ,top_transauthtype -- 安全工具类型
            ,top_transtime -- 交易时间
            ,top_suctimes -- 成功次数
            ,top_sucamt -- 成功金额
            ,top_failtimes -- 失败次数
            ,top_failamt -- 失败金额
            ,top_remaintimes -- 未执行次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_transfer_order_plan_op(
            top_orderno -- 预约号
            ,top_trade_flowno -- 流水号
            ,top_transdate -- 计划制定日期
            ,top_timertype -- 定时种类
            ,top_timerfreq -- 定时频率种类
            ,top_timerrule -- 定时或者定频规则
            ,top_state -- 状态
            ,top_begindate -- 定时或定频起始日期
            ,top_enddate -- 结束日期
            ,top_canceldate -- 取消日期
            ,top_ordertimes -- 定制执行次数
            ,top_exetimes -- 已执行次数
            ,top_bookingtype -- 预定类型(a预约发工资b预约转账)
            ,top_cui_ecifno -- 全行统一客户号
            ,top_cui_userno -- 用户顺序号
            ,top_authtype -- 认证方式
            ,top_transauthtype -- 安全工具类型
            ,top_transtime -- 交易时间
            ,top_suctimes -- 成功次数
            ,top_sucamt -- 成功金额
            ,top_failtimes -- 失败次数
            ,top_failamt -- 失败金额
            ,top_remaintimes -- 未执行次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.top_orderno, o.top_orderno) as top_orderno -- 预约号
    ,nvl(n.top_trade_flowno, o.top_trade_flowno) as top_trade_flowno -- 流水号
    ,nvl(n.top_transdate, o.top_transdate) as top_transdate -- 计划制定日期
    ,nvl(n.top_timertype, o.top_timertype) as top_timertype -- 定时种类
    ,nvl(n.top_timerfreq, o.top_timerfreq) as top_timerfreq -- 定时频率种类
    ,nvl(n.top_timerrule, o.top_timerrule) as top_timerrule -- 定时或者定频规则
    ,nvl(n.top_state, o.top_state) as top_state -- 状态
    ,nvl(n.top_begindate, o.top_begindate) as top_begindate -- 定时或定频起始日期
    ,nvl(n.top_enddate, o.top_enddate) as top_enddate -- 结束日期
    ,nvl(n.top_canceldate, o.top_canceldate) as top_canceldate -- 取消日期
    ,nvl(n.top_ordertimes, o.top_ordertimes) as top_ordertimes -- 定制执行次数
    ,nvl(n.top_exetimes, o.top_exetimes) as top_exetimes -- 已执行次数
    ,nvl(n.top_bookingtype, o.top_bookingtype) as top_bookingtype -- 预定类型(a预约发工资b预约转账)
    ,nvl(n.top_cui_ecifno, o.top_cui_ecifno) as top_cui_ecifno -- 全行统一客户号
    ,nvl(n.top_cui_userno, o.top_cui_userno) as top_cui_userno -- 用户顺序号
    ,nvl(n.top_authtype, o.top_authtype) as top_authtype -- 认证方式
    ,nvl(n.top_transauthtype, o.top_transauthtype) as top_transauthtype -- 安全工具类型
    ,nvl(n.top_transtime, o.top_transtime) as top_transtime -- 交易时间
    ,nvl(n.top_suctimes, o.top_suctimes) as top_suctimes -- 成功次数
    ,nvl(n.top_sucamt, o.top_sucamt) as top_sucamt -- 成功金额
    ,nvl(n.top_failtimes, o.top_failtimes) as top_failtimes -- 失败次数
    ,nvl(n.top_failamt, o.top_failamt) as top_failamt -- 失败金额
    ,nvl(n.top_remaintimes, o.top_remaintimes) as top_remaintimes -- 未执行次数
    ,case when
            n.top_orderno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.top_orderno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.top_orderno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_transfer_order_plan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_transfer_order_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.top_orderno = n.top_orderno
where (
        o.top_orderno is null
    )
    or (
        n.top_orderno is null
    )
    or (
        o.top_trade_flowno <> n.top_trade_flowno
        or o.top_transdate <> n.top_transdate
        or o.top_timertype <> n.top_timertype
        or o.top_timerfreq <> n.top_timerfreq
        or o.top_timerrule <> n.top_timerrule
        or o.top_state <> n.top_state
        or o.top_begindate <> n.top_begindate
        or o.top_enddate <> n.top_enddate
        or o.top_canceldate <> n.top_canceldate
        or o.top_ordertimes <> n.top_ordertimes
        or o.top_exetimes <> n.top_exetimes
        or o.top_bookingtype <> n.top_bookingtype
        or o.top_cui_ecifno <> n.top_cui_ecifno
        or o.top_cui_userno <> n.top_cui_userno
        or o.top_authtype <> n.top_authtype
        or o.top_transauthtype <> n.top_transauthtype
        or o.top_transtime <> n.top_transtime
        or o.top_suctimes <> n.top_suctimes
        or o.top_sucamt <> n.top_sucamt
        or o.top_failtimes <> n.top_failtimes
        or o.top_failamt <> n.top_failamt
        or o.top_remaintimes <> n.top_remaintimes
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_transfer_order_plan_cl(
            top_orderno -- 预约号
            ,top_trade_flowno -- 流水号
            ,top_transdate -- 计划制定日期
            ,top_timertype -- 定时种类
            ,top_timerfreq -- 定时频率种类
            ,top_timerrule -- 定时或者定频规则
            ,top_state -- 状态
            ,top_begindate -- 定时或定频起始日期
            ,top_enddate -- 结束日期
            ,top_canceldate -- 取消日期
            ,top_ordertimes -- 定制执行次数
            ,top_exetimes -- 已执行次数
            ,top_bookingtype -- 预定类型(a预约发工资b预约转账)
            ,top_cui_ecifno -- 全行统一客户号
            ,top_cui_userno -- 用户顺序号
            ,top_authtype -- 认证方式
            ,top_transauthtype -- 安全工具类型
            ,top_transtime -- 交易时间
            ,top_suctimes -- 成功次数
            ,top_sucamt -- 成功金额
            ,top_failtimes -- 失败次数
            ,top_failamt -- 失败金额
            ,top_remaintimes -- 未执行次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_transfer_order_plan_op(
            top_orderno -- 预约号
            ,top_trade_flowno -- 流水号
            ,top_transdate -- 计划制定日期
            ,top_timertype -- 定时种类
            ,top_timerfreq -- 定时频率种类
            ,top_timerrule -- 定时或者定频规则
            ,top_state -- 状态
            ,top_begindate -- 定时或定频起始日期
            ,top_enddate -- 结束日期
            ,top_canceldate -- 取消日期
            ,top_ordertimes -- 定制执行次数
            ,top_exetimes -- 已执行次数
            ,top_bookingtype -- 预定类型(a预约发工资b预约转账)
            ,top_cui_ecifno -- 全行统一客户号
            ,top_cui_userno -- 用户顺序号
            ,top_authtype -- 认证方式
            ,top_transauthtype -- 安全工具类型
            ,top_transtime -- 交易时间
            ,top_suctimes -- 成功次数
            ,top_sucamt -- 成功金额
            ,top_failtimes -- 失败次数
            ,top_failamt -- 失败金额
            ,top_remaintimes -- 未执行次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.top_orderno -- 预约号
    ,o.top_trade_flowno -- 流水号
    ,o.top_transdate -- 计划制定日期
    ,o.top_timertype -- 定时种类
    ,o.top_timerfreq -- 定时频率种类
    ,o.top_timerrule -- 定时或者定频规则
    ,o.top_state -- 状态
    ,o.top_begindate -- 定时或定频起始日期
    ,o.top_enddate -- 结束日期
    ,o.top_canceldate -- 取消日期
    ,o.top_ordertimes -- 定制执行次数
    ,o.top_exetimes -- 已执行次数
    ,o.top_bookingtype -- 预定类型(a预约发工资b预约转账)
    ,o.top_cui_ecifno -- 全行统一客户号
    ,o.top_cui_userno -- 用户顺序号
    ,o.top_authtype -- 认证方式
    ,o.top_transauthtype -- 安全工具类型
    ,o.top_transtime -- 交易时间
    ,o.top_suctimes -- 成功次数
    ,o.top_sucamt -- 成功金额
    ,o.top_failtimes -- 失败次数
    ,o.top_failamt -- 失败金额
    ,o.top_remaintimes -- 未执行次数
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_transfer_order_plan_bk o
    left join ${iol_schema}.tbps_cpr_transfer_order_plan_op n
        on
            o.top_orderno = n.top_orderno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_transfer_order_plan_cl d
        on
            o.top_orderno = d.top_orderno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_transfer_order_plan;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_transfer_order_plan exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_transfer_order_plan_cl;
alter table ${iol_schema}.tbps_cpr_transfer_order_plan exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_transfer_order_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_transfer_order_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_transfer_order_plan_op purge;
drop table ${iol_schema}.tbps_cpr_transfer_order_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_transfer_order_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_transfer_order_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
