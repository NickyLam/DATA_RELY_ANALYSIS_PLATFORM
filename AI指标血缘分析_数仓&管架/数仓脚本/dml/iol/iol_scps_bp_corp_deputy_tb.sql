/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_corp_deputy_tb
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
create table ${iol_schema}.scps_bp_corp_deputy_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_corp_deputy_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_corp_deputy_tb_op purge;
drop table ${iol_schema}.scps_bp_corp_deputy_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_corp_deputy_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_corp_deputy_tb where 0=1;

create table ${iol_schema}.scps_bp_corp_deputy_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_corp_deputy_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_corp_deputy_tb_cl(
            id -- 
            ,task_id -- 任务号（esc的订单号）
            ,tr_date -- 交易日期
            ,pre_reason -- 落地流程银行原因
            ,double_notlocal -- 是否双异地（1-是，0-否）
            ,video_check_result -- 双录视频审核结果（1-通过，0-不通过）
            ,ot_frozsq -- 止付流水号
            ,ot_trandt -- 止付日期
            ,frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
            ,video_nopass_reason -- 双录视频审核不通过原因
            ,pad_return_result -- 退件原因
            ,pad_flag -- 流程标记：1-pad1.0,2-pad2.0
            ,ori_content_id -- 原始图片批次号
            ,order_num -- 渠道订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_corp_deputy_tb_op(
            id -- 
            ,task_id -- 任务号（esc的订单号）
            ,tr_date -- 交易日期
            ,pre_reason -- 落地流程银行原因
            ,double_notlocal -- 是否双异地（1-是，0-否）
            ,video_check_result -- 双录视频审核结果（1-通过，0-不通过）
            ,ot_frozsq -- 止付流水号
            ,ot_trandt -- 止付日期
            ,frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
            ,video_nopass_reason -- 双录视频审核不通过原因
            ,pad_return_result -- 退件原因
            ,pad_flag -- 流程标记：1-pad1.0,2-pad2.0
            ,ori_content_id -- 原始图片批次号
            ,order_num -- 渠道订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.task_id, o.task_id) as task_id -- 任务号（esc的订单号）
    ,nvl(n.tr_date, o.tr_date) as tr_date -- 交易日期
    ,nvl(n.pre_reason, o.pre_reason) as pre_reason -- 落地流程银行原因
    ,nvl(n.double_notlocal, o.double_notlocal) as double_notlocal -- 是否双异地（1-是，0-否）
    ,nvl(n.video_check_result, o.video_check_result) as video_check_result -- 双录视频审核结果（1-通过，0-不通过）
    ,nvl(n.ot_frozsq, o.ot_frozsq) as ot_frozsq -- 止付流水号
    ,nvl(n.ot_trandt, o.ot_trandt) as ot_trandt -- 止付日期
    ,nvl(n.frozen_flag, o.frozen_flag) as frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
    ,nvl(n.video_nopass_reason, o.video_nopass_reason) as video_nopass_reason -- 双录视频审核不通过原因
    ,nvl(n.pad_return_result, o.pad_return_result) as pad_return_result -- 退件原因
    ,nvl(n.pad_flag, o.pad_flag) as pad_flag -- 流程标记：1-pad1.0,2-pad2.0
    ,nvl(n.ori_content_id, o.ori_content_id) as ori_content_id -- 原始图片批次号
    ,nvl(n.order_num, o.order_num) as order_num -- 渠道订单号
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_corp_deputy_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_corp_deputy_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.task_id <> n.task_id
        or o.tr_date <> n.tr_date
        or o.pre_reason <> n.pre_reason
        or o.double_notlocal <> n.double_notlocal
        or o.video_check_result <> n.video_check_result
        or o.ot_frozsq <> n.ot_frozsq
        or o.ot_trandt <> n.ot_trandt
        or o.frozen_flag <> n.frozen_flag
        or o.video_nopass_reason <> n.video_nopass_reason
        or o.pad_return_result <> n.pad_return_result
        or o.pad_flag <> n.pad_flag
        or o.ori_content_id <> n.ori_content_id
        or o.order_num <> n.order_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_corp_deputy_tb_cl(
            id -- 
            ,task_id -- 任务号（esc的订单号）
            ,tr_date -- 交易日期
            ,pre_reason -- 落地流程银行原因
            ,double_notlocal -- 是否双异地（1-是，0-否）
            ,video_check_result -- 双录视频审核结果（1-通过，0-不通过）
            ,ot_frozsq -- 止付流水号
            ,ot_trandt -- 止付日期
            ,frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
            ,video_nopass_reason -- 双录视频审核不通过原因
            ,pad_return_result -- 退件原因
            ,pad_flag -- 流程标记：1-pad1.0,2-pad2.0
            ,ori_content_id -- 原始图片批次号
            ,order_num -- 渠道订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_corp_deputy_tb_op(
            id -- 
            ,task_id -- 任务号（esc的订单号）
            ,tr_date -- 交易日期
            ,pre_reason -- 落地流程银行原因
            ,double_notlocal -- 是否双异地（1-是，0-否）
            ,video_check_result -- 双录视频审核结果（1-通过，0-不通过）
            ,ot_frozsq -- 止付流水号
            ,ot_trandt -- 止付日期
            ,frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
            ,video_nopass_reason -- 双录视频审核不通过原因
            ,pad_return_result -- 退件原因
            ,pad_flag -- 流程标记：1-pad1.0,2-pad2.0
            ,ori_content_id -- 原始图片批次号
            ,order_num -- 渠道订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.task_id -- 任务号（esc的订单号）
    ,o.tr_date -- 交易日期
    ,o.pre_reason -- 落地流程银行原因
    ,o.double_notlocal -- 是否双异地（1-是，0-否）
    ,o.video_check_result -- 双录视频审核结果（1-通过，0-不通过）
    ,o.ot_frozsq -- 止付流水号
    ,o.ot_trandt -- 止付日期
    ,o.frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
    ,o.video_nopass_reason -- 双录视频审核不通过原因
    ,o.pad_return_result -- 退件原因
    ,o.pad_flag -- 流程标记：1-pad1.0,2-pad2.0
    ,o.ori_content_id -- 原始图片批次号
    ,o.order_num -- 渠道订单号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.scps_bp_corp_deputy_tb_bk o
    left join ${iol_schema}.scps_bp_corp_deputy_tb_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_corp_deputy_tb_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_corp_deputy_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_corp_deputy_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_corp_deputy_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_corp_deputy_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_corp_deputy_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_corp_deputy_tb_cl;
alter table ${iol_schema}.scps_bp_corp_deputy_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_corp_deputy_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_corp_deputy_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_corp_deputy_tb_op purge;
drop table ${iol_schema}.scps_bp_corp_deputy_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_corp_deputy_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_corp_deputy_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
