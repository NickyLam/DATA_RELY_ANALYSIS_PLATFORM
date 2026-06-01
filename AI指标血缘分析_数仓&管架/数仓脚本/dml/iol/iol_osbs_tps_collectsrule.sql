/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_collectsrule
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
create table ${iol_schema}.osbs_tps_collectsrule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_collectsrule;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_collectsrule_op purge;
drop table ${iol_schema}.osbs_tps_collectsrule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_collectsrule_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_collectsrule where 0=1;

create table ${iol_schema}.osbs_tps_collectsrule_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_collectsrule where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_collectsrule_cl(
            tcr_collectno -- 计划编号
            ,tcr_transdate -- 计划制定日期
            ,tcr_periodtype -- 定时种类
            ,tcr_periodfreq -- 归集周期
            ,tcr_periodrule -- 归集规则
            ,tcr_periodstate -- 状态
            ,tcr_begindate -- 起始日期
            ,tcr_enddate -- 截止日期
            ,tcr_periodday -- 执行日
            ,tcr_canceldate -- 取消日期
            ,tcr_ecifno -- 客户号
            ,tcr_userno -- 用户号
            ,tcr_authtype -- 客户类型（用于限额）
            ,tcr_ransauthtype -- 安全工具类型
            ,tcr_suctimes -- 执行成功次数
            ,tcr_sucamt -- 成功金额
            ,tcr_failtimes -- 执行失败次数
            ,tcr_failamt -- 失败金额
            ,tcr_ordertimes -- 定制执行次数
            ,tcr_exetimes -- 已执行次数
            ,tcr_remaintimes -- 未执行次数
            ,tcr_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_collectsrule_op(
            tcr_collectno -- 计划编号
            ,tcr_transdate -- 计划制定日期
            ,tcr_periodtype -- 定时种类
            ,tcr_periodfreq -- 归集周期
            ,tcr_periodrule -- 归集规则
            ,tcr_periodstate -- 状态
            ,tcr_begindate -- 起始日期
            ,tcr_enddate -- 截止日期
            ,tcr_periodday -- 执行日
            ,tcr_canceldate -- 取消日期
            ,tcr_ecifno -- 客户号
            ,tcr_userno -- 用户号
            ,tcr_authtype -- 客户类型（用于限额）
            ,tcr_ransauthtype -- 安全工具类型
            ,tcr_suctimes -- 执行成功次数
            ,tcr_sucamt -- 成功金额
            ,tcr_failtimes -- 执行失败次数
            ,tcr_failamt -- 失败金额
            ,tcr_ordertimes -- 定制执行次数
            ,tcr_exetimes -- 已执行次数
            ,tcr_remaintimes -- 未执行次数
            ,tcr_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tcr_collectno, o.tcr_collectno) as tcr_collectno -- 计划编号
    ,nvl(n.tcr_transdate, o.tcr_transdate) as tcr_transdate -- 计划制定日期
    ,nvl(n.tcr_periodtype, o.tcr_periodtype) as tcr_periodtype -- 定时种类
    ,nvl(n.tcr_periodfreq, o.tcr_periodfreq) as tcr_periodfreq -- 归集周期
    ,nvl(n.tcr_periodrule, o.tcr_periodrule) as tcr_periodrule -- 归集规则
    ,nvl(n.tcr_periodstate, o.tcr_periodstate) as tcr_periodstate -- 状态
    ,nvl(n.tcr_begindate, o.tcr_begindate) as tcr_begindate -- 起始日期
    ,nvl(n.tcr_enddate, o.tcr_enddate) as tcr_enddate -- 截止日期
    ,nvl(n.tcr_periodday, o.tcr_periodday) as tcr_periodday -- 执行日
    ,nvl(n.tcr_canceldate, o.tcr_canceldate) as tcr_canceldate -- 取消日期
    ,nvl(n.tcr_ecifno, o.tcr_ecifno) as tcr_ecifno -- 客户号
    ,nvl(n.tcr_userno, o.tcr_userno) as tcr_userno -- 用户号
    ,nvl(n.tcr_authtype, o.tcr_authtype) as tcr_authtype -- 客户类型（用于限额）
    ,nvl(n.tcr_ransauthtype, o.tcr_ransauthtype) as tcr_ransauthtype -- 安全工具类型
    ,nvl(n.tcr_suctimes, o.tcr_suctimes) as tcr_suctimes -- 执行成功次数
    ,nvl(n.tcr_sucamt, o.tcr_sucamt) as tcr_sucamt -- 成功金额
    ,nvl(n.tcr_failtimes, o.tcr_failtimes) as tcr_failtimes -- 执行失败次数
    ,nvl(n.tcr_failamt, o.tcr_failamt) as tcr_failamt -- 失败金额
    ,nvl(n.tcr_ordertimes, o.tcr_ordertimes) as tcr_ordertimes -- 定制执行次数
    ,nvl(n.tcr_exetimes, o.tcr_exetimes) as tcr_exetimes -- 已执行次数
    ,nvl(n.tcr_remaintimes, o.tcr_remaintimes) as tcr_remaintimes -- 未执行次数
    ,nvl(n.tcr_channel, o.tcr_channel) as tcr_channel -- 渠道
    ,case when
            n.tcr_collectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tcr_collectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tcr_collectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_collectsrule_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_collectsrule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tcr_collectno = n.tcr_collectno
where (
        o.tcr_collectno is null
    )
    or (
        n.tcr_collectno is null
    )
    or (
        o.tcr_transdate <> n.tcr_transdate
        or o.tcr_periodtype <> n.tcr_periodtype
        or o.tcr_periodfreq <> n.tcr_periodfreq
        or o.tcr_periodrule <> n.tcr_periodrule
        or o.tcr_periodstate <> n.tcr_periodstate
        or o.tcr_begindate <> n.tcr_begindate
        or o.tcr_enddate <> n.tcr_enddate
        or o.tcr_periodday <> n.tcr_periodday
        or o.tcr_canceldate <> n.tcr_canceldate
        or o.tcr_ecifno <> n.tcr_ecifno
        or o.tcr_userno <> n.tcr_userno
        or o.tcr_authtype <> n.tcr_authtype
        or o.tcr_ransauthtype <> n.tcr_ransauthtype
        or o.tcr_suctimes <> n.tcr_suctimes
        or o.tcr_sucamt <> n.tcr_sucamt
        or o.tcr_failtimes <> n.tcr_failtimes
        or o.tcr_failamt <> n.tcr_failamt
        or o.tcr_ordertimes <> n.tcr_ordertimes
        or o.tcr_exetimes <> n.tcr_exetimes
        or o.tcr_remaintimes <> n.tcr_remaintimes
        or o.tcr_channel <> n.tcr_channel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_collectsrule_cl(
            tcr_collectno -- 计划编号
            ,tcr_transdate -- 计划制定日期
            ,tcr_periodtype -- 定时种类
            ,tcr_periodfreq -- 归集周期
            ,tcr_periodrule -- 归集规则
            ,tcr_periodstate -- 状态
            ,tcr_begindate -- 起始日期
            ,tcr_enddate -- 截止日期
            ,tcr_periodday -- 执行日
            ,tcr_canceldate -- 取消日期
            ,tcr_ecifno -- 客户号
            ,tcr_userno -- 用户号
            ,tcr_authtype -- 客户类型（用于限额）
            ,tcr_ransauthtype -- 安全工具类型
            ,tcr_suctimes -- 执行成功次数
            ,tcr_sucamt -- 成功金额
            ,tcr_failtimes -- 执行失败次数
            ,tcr_failamt -- 失败金额
            ,tcr_ordertimes -- 定制执行次数
            ,tcr_exetimes -- 已执行次数
            ,tcr_remaintimes -- 未执行次数
            ,tcr_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_collectsrule_op(
            tcr_collectno -- 计划编号
            ,tcr_transdate -- 计划制定日期
            ,tcr_periodtype -- 定时种类
            ,tcr_periodfreq -- 归集周期
            ,tcr_periodrule -- 归集规则
            ,tcr_periodstate -- 状态
            ,tcr_begindate -- 起始日期
            ,tcr_enddate -- 截止日期
            ,tcr_periodday -- 执行日
            ,tcr_canceldate -- 取消日期
            ,tcr_ecifno -- 客户号
            ,tcr_userno -- 用户号
            ,tcr_authtype -- 客户类型（用于限额）
            ,tcr_ransauthtype -- 安全工具类型
            ,tcr_suctimes -- 执行成功次数
            ,tcr_sucamt -- 成功金额
            ,tcr_failtimes -- 执行失败次数
            ,tcr_failamt -- 失败金额
            ,tcr_ordertimes -- 定制执行次数
            ,tcr_exetimes -- 已执行次数
            ,tcr_remaintimes -- 未执行次数
            ,tcr_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tcr_collectno -- 计划编号
    ,o.tcr_transdate -- 计划制定日期
    ,o.tcr_periodtype -- 定时种类
    ,o.tcr_periodfreq -- 归集周期
    ,o.tcr_periodrule -- 归集规则
    ,o.tcr_periodstate -- 状态
    ,o.tcr_begindate -- 起始日期
    ,o.tcr_enddate -- 截止日期
    ,o.tcr_periodday -- 执行日
    ,o.tcr_canceldate -- 取消日期
    ,o.tcr_ecifno -- 客户号
    ,o.tcr_userno -- 用户号
    ,o.tcr_authtype -- 客户类型（用于限额）
    ,o.tcr_ransauthtype -- 安全工具类型
    ,o.tcr_suctimes -- 执行成功次数
    ,o.tcr_sucamt -- 成功金额
    ,o.tcr_failtimes -- 执行失败次数
    ,o.tcr_failamt -- 失败金额
    ,o.tcr_ordertimes -- 定制执行次数
    ,o.tcr_exetimes -- 已执行次数
    ,o.tcr_remaintimes -- 未执行次数
    ,o.tcr_channel -- 渠道
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_tps_collectsrule_bk o
    left join ${iol_schema}.osbs_tps_collectsrule_op n
        on
            o.tcr_collectno = n.tcr_collectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_collectsrule_cl d
        on
            o.tcr_collectno = d.tcr_collectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_tps_collectsrule;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_tps_collectsrule exchange partition p_19000101 with table ${iol_schema}.osbs_tps_collectsrule_cl;
alter table ${iol_schema}.osbs_tps_collectsrule exchange partition p_20991231 with table ${iol_schema}.osbs_tps_collectsrule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_collectsrule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_collectsrule_op purge;
drop table ${iol_schema}.osbs_tps_collectsrule_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_collectsrule_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_collectsrule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
