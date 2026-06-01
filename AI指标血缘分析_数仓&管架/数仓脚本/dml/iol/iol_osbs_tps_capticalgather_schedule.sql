/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_capticalgather_schedule
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
create table ${iol_schema}.osbs_tps_capticalgather_schedule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_capticalgather_schedule;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_capticalgather_schedule_op purge;
drop table ${iol_schema}.osbs_tps_capticalgather_schedule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_capticalgather_schedule_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_capticalgather_schedule where 0=1;

create table ${iol_schema}.osbs_tps_capticalgather_schedule_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_capticalgather_schedule where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_capticalgather_schedule_cl(
            tgs_capticalgather_no -- 资金归集编号
            ,tgs_ecifno -- 统一客户号
            ,tgs_userno -- 用户顺序号
            ,tgs_submitdate -- 计划制定日期
            ,tgs_type -- 定时种类
            ,tgs_tranfreq -- 交易频率
            ,tgs_periodrule -- 归集规则
            ,tts_nextexedate -- 下一次执行日期
            ,tgs_state -- 状态
            ,tgs_begindate -- 起始日期
            ,tgs_enddate -- 截止日期
            ,tgs_periodday -- 执行日
            ,tgs_canceldate -- 取消日期
            ,tgs_transtime -- 计划制定时间
            ,tgs_authtype -- 客户类型（用于限额）
            ,tgs_transauthtype -- 安全工具类型
            ,tgs_successtimes -- 执行成功次数
            ,tgs_successamt -- 成功金额
            ,tgs_failtimes -- 执行失败次数
            ,tgs_failamt -- 失败金额
            ,tgs_plantimes -- 计划执行次数
            ,tgs_exetimes -- 已执行次数
            ,tgs_residuetimes -- 未执行次数
            ,tgs_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_capticalgather_schedule_op(
            tgs_capticalgather_no -- 资金归集编号
            ,tgs_ecifno -- 统一客户号
            ,tgs_userno -- 用户顺序号
            ,tgs_submitdate -- 计划制定日期
            ,tgs_type -- 定时种类
            ,tgs_tranfreq -- 交易频率
            ,tgs_periodrule -- 归集规则
            ,tts_nextexedate -- 下一次执行日期
            ,tgs_state -- 状态
            ,tgs_begindate -- 起始日期
            ,tgs_enddate -- 截止日期
            ,tgs_periodday -- 执行日
            ,tgs_canceldate -- 取消日期
            ,tgs_transtime -- 计划制定时间
            ,tgs_authtype -- 客户类型（用于限额）
            ,tgs_transauthtype -- 安全工具类型
            ,tgs_successtimes -- 执行成功次数
            ,tgs_successamt -- 成功金额
            ,tgs_failtimes -- 执行失败次数
            ,tgs_failamt -- 失败金额
            ,tgs_plantimes -- 计划执行次数
            ,tgs_exetimes -- 已执行次数
            ,tgs_residuetimes -- 未执行次数
            ,tgs_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tgs_capticalgather_no, o.tgs_capticalgather_no) as tgs_capticalgather_no -- 资金归集编号
    ,nvl(n.tgs_ecifno, o.tgs_ecifno) as tgs_ecifno -- 统一客户号
    ,nvl(n.tgs_userno, o.tgs_userno) as tgs_userno -- 用户顺序号
    ,nvl(n.tgs_submitdate, o.tgs_submitdate) as tgs_submitdate -- 计划制定日期
    ,nvl(n.tgs_type, o.tgs_type) as tgs_type -- 定时种类
    ,nvl(n.tgs_tranfreq, o.tgs_tranfreq) as tgs_tranfreq -- 交易频率
    ,nvl(n.tgs_periodrule, o.tgs_periodrule) as tgs_periodrule -- 归集规则
    ,nvl(n.tts_nextexedate, o.tts_nextexedate) as tts_nextexedate -- 下一次执行日期
    ,nvl(n.tgs_state, o.tgs_state) as tgs_state -- 状态
    ,nvl(n.tgs_begindate, o.tgs_begindate) as tgs_begindate -- 起始日期
    ,nvl(n.tgs_enddate, o.tgs_enddate) as tgs_enddate -- 截止日期
    ,nvl(n.tgs_periodday, o.tgs_periodday) as tgs_periodday -- 执行日
    ,nvl(n.tgs_canceldate, o.tgs_canceldate) as tgs_canceldate -- 取消日期
    ,nvl(n.tgs_transtime, o.tgs_transtime) as tgs_transtime -- 计划制定时间
    ,nvl(n.tgs_authtype, o.tgs_authtype) as tgs_authtype -- 客户类型（用于限额）
    ,nvl(n.tgs_transauthtype, o.tgs_transauthtype) as tgs_transauthtype -- 安全工具类型
    ,nvl(n.tgs_successtimes, o.tgs_successtimes) as tgs_successtimes -- 执行成功次数
    ,nvl(n.tgs_successamt, o.tgs_successamt) as tgs_successamt -- 成功金额
    ,nvl(n.tgs_failtimes, o.tgs_failtimes) as tgs_failtimes -- 执行失败次数
    ,nvl(n.tgs_failamt, o.tgs_failamt) as tgs_failamt -- 失败金额
    ,nvl(n.tgs_plantimes, o.tgs_plantimes) as tgs_plantimes -- 计划执行次数
    ,nvl(n.tgs_exetimes, o.tgs_exetimes) as tgs_exetimes -- 已执行次数
    ,nvl(n.tgs_residuetimes, o.tgs_residuetimes) as tgs_residuetimes -- 未执行次数
    ,nvl(n.tgs_channel, o.tgs_channel) as tgs_channel -- 渠道
    ,case when
            n.tgs_capticalgather_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tgs_capticalgather_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tgs_capticalgather_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_capticalgather_schedule_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_capticalgather_schedule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tgs_capticalgather_no = n.tgs_capticalgather_no
where (
        o.tgs_capticalgather_no is null
    )
    or (
        n.tgs_capticalgather_no is null
    )
    or (
        o.tgs_ecifno <> n.tgs_ecifno
        or o.tgs_userno <> n.tgs_userno
        or o.tgs_submitdate <> n.tgs_submitdate
        or o.tgs_type <> n.tgs_type
        or o.tgs_tranfreq <> n.tgs_tranfreq
        or o.tgs_periodrule <> n.tgs_periodrule
        or o.tts_nextexedate <> n.tts_nextexedate
        or o.tgs_state <> n.tgs_state
        or o.tgs_begindate <> n.tgs_begindate
        or o.tgs_enddate <> n.tgs_enddate
        or o.tgs_periodday <> n.tgs_periodday
        or o.tgs_canceldate <> n.tgs_canceldate
        or o.tgs_transtime <> n.tgs_transtime
        or o.tgs_authtype <> n.tgs_authtype
        or o.tgs_transauthtype <> n.tgs_transauthtype
        or o.tgs_successtimes <> n.tgs_successtimes
        or o.tgs_successamt <> n.tgs_successamt
        or o.tgs_failtimes <> n.tgs_failtimes
        or o.tgs_failamt <> n.tgs_failamt
        or o.tgs_plantimes <> n.tgs_plantimes
        or o.tgs_exetimes <> n.tgs_exetimes
        or o.tgs_residuetimes <> n.tgs_residuetimes
        or o.tgs_channel <> n.tgs_channel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_capticalgather_schedule_cl(
            tgs_capticalgather_no -- 资金归集编号
            ,tgs_ecifno -- 统一客户号
            ,tgs_userno -- 用户顺序号
            ,tgs_submitdate -- 计划制定日期
            ,tgs_type -- 定时种类
            ,tgs_tranfreq -- 交易频率
            ,tgs_periodrule -- 归集规则
            ,tts_nextexedate -- 下一次执行日期
            ,tgs_state -- 状态
            ,tgs_begindate -- 起始日期
            ,tgs_enddate -- 截止日期
            ,tgs_periodday -- 执行日
            ,tgs_canceldate -- 取消日期
            ,tgs_transtime -- 计划制定时间
            ,tgs_authtype -- 客户类型（用于限额）
            ,tgs_transauthtype -- 安全工具类型
            ,tgs_successtimes -- 执行成功次数
            ,tgs_successamt -- 成功金额
            ,tgs_failtimes -- 执行失败次数
            ,tgs_failamt -- 失败金额
            ,tgs_plantimes -- 计划执行次数
            ,tgs_exetimes -- 已执行次数
            ,tgs_residuetimes -- 未执行次数
            ,tgs_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_capticalgather_schedule_op(
            tgs_capticalgather_no -- 资金归集编号
            ,tgs_ecifno -- 统一客户号
            ,tgs_userno -- 用户顺序号
            ,tgs_submitdate -- 计划制定日期
            ,tgs_type -- 定时种类
            ,tgs_tranfreq -- 交易频率
            ,tgs_periodrule -- 归集规则
            ,tts_nextexedate -- 下一次执行日期
            ,tgs_state -- 状态
            ,tgs_begindate -- 起始日期
            ,tgs_enddate -- 截止日期
            ,tgs_periodday -- 执行日
            ,tgs_canceldate -- 取消日期
            ,tgs_transtime -- 计划制定时间
            ,tgs_authtype -- 客户类型（用于限额）
            ,tgs_transauthtype -- 安全工具类型
            ,tgs_successtimes -- 执行成功次数
            ,tgs_successamt -- 成功金额
            ,tgs_failtimes -- 执行失败次数
            ,tgs_failamt -- 失败金额
            ,tgs_plantimes -- 计划执行次数
            ,tgs_exetimes -- 已执行次数
            ,tgs_residuetimes -- 未执行次数
            ,tgs_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tgs_capticalgather_no -- 资金归集编号
    ,o.tgs_ecifno -- 统一客户号
    ,o.tgs_userno -- 用户顺序号
    ,o.tgs_submitdate -- 计划制定日期
    ,o.tgs_type -- 定时种类
    ,o.tgs_tranfreq -- 交易频率
    ,o.tgs_periodrule -- 归集规则
    ,o.tts_nextexedate -- 下一次执行日期
    ,o.tgs_state -- 状态
    ,o.tgs_begindate -- 起始日期
    ,o.tgs_enddate -- 截止日期
    ,o.tgs_periodday -- 执行日
    ,o.tgs_canceldate -- 取消日期
    ,o.tgs_transtime -- 计划制定时间
    ,o.tgs_authtype -- 客户类型（用于限额）
    ,o.tgs_transauthtype -- 安全工具类型
    ,o.tgs_successtimes -- 执行成功次数
    ,o.tgs_successamt -- 成功金额
    ,o.tgs_failtimes -- 执行失败次数
    ,o.tgs_failamt -- 失败金额
    ,o.tgs_plantimes -- 计划执行次数
    ,o.tgs_exetimes -- 已执行次数
    ,o.tgs_residuetimes -- 未执行次数
    ,o.tgs_channel -- 渠道
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_tps_capticalgather_schedule_bk o
    left join ${iol_schema}.osbs_tps_capticalgather_schedule_op n
        on
            o.tgs_capticalgather_no = n.tgs_capticalgather_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_capticalgather_schedule_cl d
        on
            o.tgs_capticalgather_no = d.tgs_capticalgather_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_tps_capticalgather_schedule;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_tps_capticalgather_schedule exchange partition p_19000101 with table ${iol_schema}.osbs_tps_capticalgather_schedule_cl;
alter table ${iol_schema}.osbs_tps_capticalgather_schedule exchange partition p_20991231 with table ${iol_schema}.osbs_tps_capticalgather_schedule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_capticalgather_schedule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_capticalgather_schedule_op purge;
drop table ${iol_schema}.osbs_tps_capticalgather_schedule_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_capticalgather_schedule_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_capticalgather_schedule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
