/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_tran_schedule
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
create table ${iol_schema}.osbs_tps_tran_schedule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_tran_schedule;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_tran_schedule_op purge;
drop table ${iol_schema}.osbs_tps_tran_schedule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_tran_schedule_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_tran_schedule where 0=1;

create table ${iol_schema}.osbs_tps_tran_schedule_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_tran_schedule where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_tran_schedule_cl(
            tts_schedule_no -- 计划编号
            ,tts_ecifno -- 统一客户号
            ,tts_submittime -- 计划制定时间
            ,tts_securitytype -- 安全认证方式
            ,tts_type -- 计划类型 0：定时 1：定频
            ,tts_tranfreq -- 交易频率 O:一次D:每天W:每周M:每月P:每季度B=每半年Y=每年
            ,tts_timerrule -- 定时规则
            ,tts_nextexedate -- 下一次执行日期
            ,tts_state -- 预约计划状态 0正常使用 1已完成 2已撤销 3正在执行
            ,tts_begindate -- 定时或定频起始日期
            ,tts_enddate -- 截止日期
            ,tts_canceldate -- 撤销日期
            ,tts_plantimes -- 定制执行次数
            ,tts_exetimes -- 已执行次数
            ,tts_successtimes -- 成功次数
            ,tts_successamt -- 成功金额
            ,tts_failtimes -- 失败次数
            ,tts_failamt -- 失败金额
            ,tts_residuetimes -- 未执行次数
            ,tts_booktype -- 预约属性 B普通预约 H家庭预约
            ,tts_channel -- 渠道
            ,tts_limitname -- 限额属性名
            ,tts_userno -- 用户名
            ,tts_sysflag -- 行内外转账标识
            ,tts_transtype -- 交易类型
            ,tts_ecifname -- 客户名
            ,tts_edittime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_tran_schedule_op(
            tts_schedule_no -- 计划编号
            ,tts_ecifno -- 统一客户号
            ,tts_submittime -- 计划制定时间
            ,tts_securitytype -- 安全认证方式
            ,tts_type -- 计划类型 0：定时 1：定频
            ,tts_tranfreq -- 交易频率 O:一次D:每天W:每周M:每月P:每季度B=每半年Y=每年
            ,tts_timerrule -- 定时规则
            ,tts_nextexedate -- 下一次执行日期
            ,tts_state -- 预约计划状态 0正常使用 1已完成 2已撤销 3正在执行
            ,tts_begindate -- 定时或定频起始日期
            ,tts_enddate -- 截止日期
            ,tts_canceldate -- 撤销日期
            ,tts_plantimes -- 定制执行次数
            ,tts_exetimes -- 已执行次数
            ,tts_successtimes -- 成功次数
            ,tts_successamt -- 成功金额
            ,tts_failtimes -- 失败次数
            ,tts_failamt -- 失败金额
            ,tts_residuetimes -- 未执行次数
            ,tts_booktype -- 预约属性 B普通预约 H家庭预约
            ,tts_channel -- 渠道
            ,tts_limitname -- 限额属性名
            ,tts_userno -- 用户名
            ,tts_sysflag -- 行内外转账标识
            ,tts_transtype -- 交易类型
            ,tts_ecifname -- 客户名
            ,tts_edittime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tts_schedule_no, o.tts_schedule_no) as tts_schedule_no -- 计划编号
    ,nvl(n.tts_ecifno, o.tts_ecifno) as tts_ecifno -- 统一客户号
    ,nvl(n.tts_submittime, o.tts_submittime) as tts_submittime -- 计划制定时间
    ,nvl(n.tts_securitytype, o.tts_securitytype) as tts_securitytype -- 安全认证方式
    ,nvl(n.tts_type, o.tts_type) as tts_type -- 计划类型 0：定时 1：定频
    ,nvl(n.tts_tranfreq, o.tts_tranfreq) as tts_tranfreq -- 交易频率 O:一次D:每天W:每周M:每月P:每季度B=每半年Y=每年
    ,nvl(n.tts_timerrule, o.tts_timerrule) as tts_timerrule -- 定时规则
    ,nvl(n.tts_nextexedate, o.tts_nextexedate) as tts_nextexedate -- 下一次执行日期
    ,nvl(n.tts_state, o.tts_state) as tts_state -- 预约计划状态 0正常使用 1已完成 2已撤销 3正在执行
    ,nvl(n.tts_begindate, o.tts_begindate) as tts_begindate -- 定时或定频起始日期
    ,nvl(n.tts_enddate, o.tts_enddate) as tts_enddate -- 截止日期
    ,nvl(n.tts_canceldate, o.tts_canceldate) as tts_canceldate -- 撤销日期
    ,nvl(n.tts_plantimes, o.tts_plantimes) as tts_plantimes -- 定制执行次数
    ,nvl(n.tts_exetimes, o.tts_exetimes) as tts_exetimes -- 已执行次数
    ,nvl(n.tts_successtimes, o.tts_successtimes) as tts_successtimes -- 成功次数
    ,nvl(n.tts_successamt, o.tts_successamt) as tts_successamt -- 成功金额
    ,nvl(n.tts_failtimes, o.tts_failtimes) as tts_failtimes -- 失败次数
    ,nvl(n.tts_failamt, o.tts_failamt) as tts_failamt -- 失败金额
    ,nvl(n.tts_residuetimes, o.tts_residuetimes) as tts_residuetimes -- 未执行次数
    ,nvl(n.tts_booktype, o.tts_booktype) as tts_booktype -- 预约属性 B普通预约 H家庭预约
    ,nvl(n.tts_channel, o.tts_channel) as tts_channel -- 渠道
    ,nvl(n.tts_limitname, o.tts_limitname) as tts_limitname -- 限额属性名
    ,nvl(n.tts_userno, o.tts_userno) as tts_userno -- 用户名
    ,nvl(n.tts_sysflag, o.tts_sysflag) as tts_sysflag -- 行内外转账标识
    ,nvl(n.tts_transtype, o.tts_transtype) as tts_transtype -- 交易类型
    ,nvl(n.tts_ecifname, o.tts_ecifname) as tts_ecifname -- 客户名
    ,nvl(n.tts_edittime, o.tts_edittime) as tts_edittime -- 修改时间
    ,case when
            n.tts_schedule_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tts_schedule_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tts_schedule_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_tran_schedule_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_tran_schedule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tts_schedule_no = n.tts_schedule_no
where (
        o.tts_schedule_no is null
    )
    or (
        n.tts_schedule_no is null
    )
    or (
        o.tts_ecifno <> n.tts_ecifno
        or o.tts_submittime <> n.tts_submittime
        or o.tts_securitytype <> n.tts_securitytype
        or o.tts_type <> n.tts_type
        or o.tts_tranfreq <> n.tts_tranfreq
        or o.tts_timerrule <> n.tts_timerrule
        or o.tts_nextexedate <> n.tts_nextexedate
        or o.tts_state <> n.tts_state
        or o.tts_begindate <> n.tts_begindate
        or o.tts_enddate <> n.tts_enddate
        or o.tts_canceldate <> n.tts_canceldate
        or o.tts_plantimes <> n.tts_plantimes
        or o.tts_exetimes <> n.tts_exetimes
        or o.tts_successtimes <> n.tts_successtimes
        or o.tts_successamt <> n.tts_successamt
        or o.tts_failtimes <> n.tts_failtimes
        or o.tts_failamt <> n.tts_failamt
        or o.tts_residuetimes <> n.tts_residuetimes
        or o.tts_booktype <> n.tts_booktype
        or o.tts_channel <> n.tts_channel
        or o.tts_limitname <> n.tts_limitname
        or o.tts_userno <> n.tts_userno
        or o.tts_sysflag <> n.tts_sysflag
        or o.tts_transtype <> n.tts_transtype
        or o.tts_ecifname <> n.tts_ecifname
        or o.tts_edittime <> n.tts_edittime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_tran_schedule_cl(
            tts_schedule_no -- 计划编号
            ,tts_ecifno -- 统一客户号
            ,tts_submittime -- 计划制定时间
            ,tts_securitytype -- 安全认证方式
            ,tts_type -- 计划类型 0：定时 1：定频
            ,tts_tranfreq -- 交易频率 O:一次D:每天W:每周M:每月P:每季度B=每半年Y=每年
            ,tts_timerrule -- 定时规则
            ,tts_nextexedate -- 下一次执行日期
            ,tts_state -- 预约计划状态 0正常使用 1已完成 2已撤销 3正在执行
            ,tts_begindate -- 定时或定频起始日期
            ,tts_enddate -- 截止日期
            ,tts_canceldate -- 撤销日期
            ,tts_plantimes -- 定制执行次数
            ,tts_exetimes -- 已执行次数
            ,tts_successtimes -- 成功次数
            ,tts_successamt -- 成功金额
            ,tts_failtimes -- 失败次数
            ,tts_failamt -- 失败金额
            ,tts_residuetimes -- 未执行次数
            ,tts_booktype -- 预约属性 B普通预约 H家庭预约
            ,tts_channel -- 渠道
            ,tts_limitname -- 限额属性名
            ,tts_userno -- 用户名
            ,tts_sysflag -- 行内外转账标识
            ,tts_transtype -- 交易类型
            ,tts_ecifname -- 客户名
            ,tts_edittime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_tran_schedule_op(
            tts_schedule_no -- 计划编号
            ,tts_ecifno -- 统一客户号
            ,tts_submittime -- 计划制定时间
            ,tts_securitytype -- 安全认证方式
            ,tts_type -- 计划类型 0：定时 1：定频
            ,tts_tranfreq -- 交易频率 O:一次D:每天W:每周M:每月P:每季度B=每半年Y=每年
            ,tts_timerrule -- 定时规则
            ,tts_nextexedate -- 下一次执行日期
            ,tts_state -- 预约计划状态 0正常使用 1已完成 2已撤销 3正在执行
            ,tts_begindate -- 定时或定频起始日期
            ,tts_enddate -- 截止日期
            ,tts_canceldate -- 撤销日期
            ,tts_plantimes -- 定制执行次数
            ,tts_exetimes -- 已执行次数
            ,tts_successtimes -- 成功次数
            ,tts_successamt -- 成功金额
            ,tts_failtimes -- 失败次数
            ,tts_failamt -- 失败金额
            ,tts_residuetimes -- 未执行次数
            ,tts_booktype -- 预约属性 B普通预约 H家庭预约
            ,tts_channel -- 渠道
            ,tts_limitname -- 限额属性名
            ,tts_userno -- 用户名
            ,tts_sysflag -- 行内外转账标识
            ,tts_transtype -- 交易类型
            ,tts_ecifname -- 客户名
            ,tts_edittime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tts_schedule_no -- 计划编号
    ,o.tts_ecifno -- 统一客户号
    ,o.tts_submittime -- 计划制定时间
    ,o.tts_securitytype -- 安全认证方式
    ,o.tts_type -- 计划类型 0：定时 1：定频
    ,o.tts_tranfreq -- 交易频率 O:一次D:每天W:每周M:每月P:每季度B=每半年Y=每年
    ,o.tts_timerrule -- 定时规则
    ,o.tts_nextexedate -- 下一次执行日期
    ,o.tts_state -- 预约计划状态 0正常使用 1已完成 2已撤销 3正在执行
    ,o.tts_begindate -- 定时或定频起始日期
    ,o.tts_enddate -- 截止日期
    ,o.tts_canceldate -- 撤销日期
    ,o.tts_plantimes -- 定制执行次数
    ,o.tts_exetimes -- 已执行次数
    ,o.tts_successtimes -- 成功次数
    ,o.tts_successamt -- 成功金额
    ,o.tts_failtimes -- 失败次数
    ,o.tts_failamt -- 失败金额
    ,o.tts_residuetimes -- 未执行次数
    ,o.tts_booktype -- 预约属性 B普通预约 H家庭预约
    ,o.tts_channel -- 渠道
    ,o.tts_limitname -- 限额属性名
    ,o.tts_userno -- 用户名
    ,o.tts_sysflag -- 行内外转账标识
    ,o.tts_transtype -- 交易类型
    ,o.tts_ecifname -- 客户名
    ,o.tts_edittime -- 修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_tps_tran_schedule_bk o
    left join ${iol_schema}.osbs_tps_tran_schedule_op n
        on
            o.tts_schedule_no = n.tts_schedule_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_tran_schedule_cl d
        on
            o.tts_schedule_no = d.tts_schedule_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_tps_tran_schedule;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_tps_tran_schedule exchange partition p_19000101 with table ${iol_schema}.osbs_tps_tran_schedule_cl;
alter table ${iol_schema}.osbs_tps_tran_schedule exchange partition p_20991231 with table ${iol_schema}.osbs_tps_tran_schedule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_tran_schedule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_tran_schedule_op purge;
drop table ${iol_schema}.osbs_tps_tran_schedule_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_tran_schedule_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_tran_schedule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
