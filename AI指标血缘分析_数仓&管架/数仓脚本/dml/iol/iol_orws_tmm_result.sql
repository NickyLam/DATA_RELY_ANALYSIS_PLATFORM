/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_tmm_result
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
create table ${iol_schema}.orws_tmm_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_tmm_result;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_tmm_result_op purge;
drop table ${iol_schema}.orws_tmm_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_tmm_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_tmm_result where 0=1;

create table ${iol_schema}.orws_tmm_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_tmm_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_tmm_result_cl(
            id -- 
            ,commissioning_id -- 
            ,biz_date -- 
            ,biz_organ_id -- 
            ,biz_emp_no -- 
            ,img_info -- 
            ,found_date -- 
            ,handle_date -- 
            ,handle_user_id -- 
            ,handle_position_id -- 
            ,handle_organ_id -- 
            ,handle_result -- 
            ,biz_info -- 
            ,cancel_reason -- 
            ,problem_id -- 
            ,problem_state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_tmm_result_op(
            id -- 
            ,commissioning_id -- 
            ,biz_date -- 
            ,biz_organ_id -- 
            ,biz_emp_no -- 
            ,img_info -- 
            ,found_date -- 
            ,handle_date -- 
            ,handle_user_id -- 
            ,handle_position_id -- 
            ,handle_organ_id -- 
            ,handle_result -- 
            ,biz_info -- 
            ,cancel_reason -- 
            ,problem_id -- 
            ,problem_state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.commissioning_id, o.commissioning_id) as commissioning_id -- 
    ,nvl(n.biz_date, o.biz_date) as biz_date -- 
    ,nvl(n.biz_organ_id, o.biz_organ_id) as biz_organ_id -- 
    ,nvl(n.biz_emp_no, o.biz_emp_no) as biz_emp_no -- 
    ,nvl(n.img_info, o.img_info) as img_info -- 
    ,nvl(n.found_date, o.found_date) as found_date -- 
    ,nvl(n.handle_date, o.handle_date) as handle_date -- 
    ,nvl(n.handle_user_id, o.handle_user_id) as handle_user_id -- 
    ,nvl(n.handle_position_id, o.handle_position_id) as handle_position_id -- 
    ,nvl(n.handle_organ_id, o.handle_organ_id) as handle_organ_id -- 
    ,nvl(n.handle_result, o.handle_result) as handle_result -- 
    ,nvl(n.biz_info, o.biz_info) as biz_info -- 
    ,nvl(n.cancel_reason, o.cancel_reason) as cancel_reason -- 
    ,nvl(n.problem_id, o.problem_id) as problem_id -- 
    ,nvl(n.problem_state, o.problem_state) as problem_state -- 
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
from (select * from ${iol_schema}.orws_tmm_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_tmm_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.commissioning_id <> n.commissioning_id
        or o.biz_date <> n.biz_date
        or o.biz_organ_id <> n.biz_organ_id
        or o.biz_emp_no <> n.biz_emp_no
        or o.img_info <> n.img_info
        or o.found_date <> n.found_date
        or o.handle_date <> n.handle_date
        or o.handle_user_id <> n.handle_user_id
        or o.handle_position_id <> n.handle_position_id
        or o.handle_organ_id <> n.handle_organ_id
        or o.handle_result <> n.handle_result
        or o.biz_info <> n.biz_info
        or o.cancel_reason <> n.cancel_reason
        or o.problem_id <> n.problem_id
        or o.problem_state <> n.problem_state
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_tmm_result_cl(
            id -- 
            ,commissioning_id -- 
            ,biz_date -- 
            ,biz_organ_id -- 
            ,biz_emp_no -- 
            ,img_info -- 
            ,found_date -- 
            ,handle_date -- 
            ,handle_user_id -- 
            ,handle_position_id -- 
            ,handle_organ_id -- 
            ,handle_result -- 
            ,biz_info -- 
            ,cancel_reason -- 
            ,problem_id -- 
            ,problem_state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_tmm_result_op(
            id -- 
            ,commissioning_id -- 
            ,biz_date -- 
            ,biz_organ_id -- 
            ,biz_emp_no -- 
            ,img_info -- 
            ,found_date -- 
            ,handle_date -- 
            ,handle_user_id -- 
            ,handle_position_id -- 
            ,handle_organ_id -- 
            ,handle_result -- 
            ,biz_info -- 
            ,cancel_reason -- 
            ,problem_id -- 
            ,problem_state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.commissioning_id -- 
    ,o.biz_date -- 
    ,o.biz_organ_id -- 
    ,o.biz_emp_no -- 
    ,o.img_info -- 
    ,o.found_date -- 
    ,o.handle_date -- 
    ,o.handle_user_id -- 
    ,o.handle_position_id -- 
    ,o.handle_organ_id -- 
    ,o.handle_result -- 
    ,o.biz_info -- 
    ,o.cancel_reason -- 
    ,o.problem_id -- 
    ,o.problem_state -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.orws_tmm_result_bk o
    left join ${iol_schema}.orws_tmm_result_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_tmm_result_cl d
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
-- truncate table ${iol_schema}.orws_tmm_result;

-- 4.2 exchange partition
alter table ${iol_schema}.orws_tmm_result exchange partition p_19000101 with table ${iol_schema}.orws_tmm_result_cl;
alter table ${iol_schema}.orws_tmm_result exchange partition p_20991231 with table ${iol_schema}.orws_tmm_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_tmm_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_tmm_result_op purge;
drop table ${iol_schema}.orws_tmm_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_tmm_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_tmm_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
