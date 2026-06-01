/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_ob_list_collection
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
create table ${iol_schema}.ccdb_ob_list_collection_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccdb_ob_list_collection
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_ob_list_collection_op purge;
drop table ${iol_schema}.ccdb_ob_list_collection_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_ob_list_collection_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_ob_list_collection where 0=1;

create table ${iol_schema}.ccdb_ob_list_collection_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_ob_list_collection where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_ob_list_collection_cl(
            task_code -- 任务编号
            ,code -- 主键
            ,work_tel -- 单位电话
            ,home_tel -- 家庭电话
            ,phone -- 联系电话
            ,cust_name -- 客户姓名
            ,cust_no -- 客户号
            ,days -- 日期-最大逾期天数(催收)
            ,money -- 金额-合计逾期金额(催收)
            ,call_result -- 外呼结果
            ,call_status -- 外呼状态
            ,create_date -- 创建时间
            ,creator_code -- 创建人用户号
            ,creator_name -- 创建姓名
            ,last_call_time -- 最后呼叫时间
            ,data_stat -- 数据状态
            ,call_id -- 最后的呼叫流水号
            ,succ_tel -- 呼叫成功号码
            ,fail_code -- 呼叫结果原因码
            ,max_call_count -- 最大呼叫次数
            ,call_count -- 已呼叫次数
            ,call_data -- 播报内容
            ,batch_date -- 跑批日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_ob_list_collection_op(
            task_code -- 任务编号
            ,code -- 主键
            ,work_tel -- 单位电话
            ,home_tel -- 家庭电话
            ,phone -- 联系电话
            ,cust_name -- 客户姓名
            ,cust_no -- 客户号
            ,days -- 日期-最大逾期天数(催收)
            ,money -- 金额-合计逾期金额(催收)
            ,call_result -- 外呼结果
            ,call_status -- 外呼状态
            ,create_date -- 创建时间
            ,creator_code -- 创建人用户号
            ,creator_name -- 创建姓名
            ,last_call_time -- 最后呼叫时间
            ,data_stat -- 数据状态
            ,call_id -- 最后的呼叫流水号
            ,succ_tel -- 呼叫成功号码
            ,fail_code -- 呼叫结果原因码
            ,max_call_count -- 最大呼叫次数
            ,call_count -- 已呼叫次数
            ,call_data -- 播报内容
            ,batch_date -- 跑批日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_code, o.task_code) as task_code -- 任务编号
    ,nvl(n.code, o.code) as code -- 主键
    ,nvl(n.work_tel, o.work_tel) as work_tel -- 单位电话
    ,nvl(n.home_tel, o.home_tel) as home_tel -- 家庭电话
    ,nvl(n.phone, o.phone) as phone -- 联系电话
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户姓名
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.days, o.days) as days -- 日期-最大逾期天数(催收)
    ,nvl(n.money, o.money) as money -- 金额-合计逾期金额(催收)
    ,nvl(n.call_result, o.call_result) as call_result -- 外呼结果
    ,nvl(n.call_status, o.call_status) as call_status -- 外呼状态
    ,nvl(n.create_date, o.create_date) as create_date -- 创建时间
    ,nvl(n.creator_code, o.creator_code) as creator_code -- 创建人用户号
    ,nvl(n.creator_name, o.creator_name) as creator_name -- 创建姓名
    ,nvl(n.last_call_time, o.last_call_time) as last_call_time -- 最后呼叫时间
    ,nvl(n.data_stat, o.data_stat) as data_stat -- 数据状态
    ,nvl(n.call_id, o.call_id) as call_id -- 最后的呼叫流水号
    ,nvl(n.succ_tel, o.succ_tel) as succ_tel -- 呼叫成功号码
    ,nvl(n.fail_code, o.fail_code) as fail_code -- 呼叫结果原因码
    ,nvl(n.max_call_count, o.max_call_count) as max_call_count -- 最大呼叫次数
    ,nvl(n.call_count, o.call_count) as call_count -- 已呼叫次数
    ,nvl(n.call_data, o.call_data) as call_data -- 播报内容
    ,nvl(n.batch_date, o.batch_date) as batch_date -- 跑批日期
    ,case when
            n.task_code is null
            and n.code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.task_code is null
            and n.code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.task_code is null
            and n.code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccdb_ob_list_collection_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ccdb_ob_list_collection where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.task_code = n.task_code
            and o.code = n.code
where (
        o.task_code is null
        and o.code is null
    )
    or (
        n.task_code is null
        and n.code is null
    )
    or (
        o.work_tel <> n.work_tel
        or o.home_tel <> n.home_tel
        or o.phone <> n.phone
        or o.cust_name <> n.cust_name
        or o.cust_no <> n.cust_no
        or o.days <> n.days
        or o.money <> n.money
        or o.call_result <> n.call_result
        or o.call_status <> n.call_status
        or o.create_date <> n.create_date
        or o.creator_code <> n.creator_code
        or o.creator_name <> n.creator_name
        or o.last_call_time <> n.last_call_time
        or o.data_stat <> n.data_stat
        or o.call_id <> n.call_id
        or o.succ_tel <> n.succ_tel
        or o.fail_code <> n.fail_code
        or o.max_call_count <> n.max_call_count
        or o.call_count <> n.call_count
        or o.call_data <> n.call_data
        or o.batch_date <> n.batch_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_ob_list_collection_cl(
            task_code -- 任务编号
            ,code -- 主键
            ,work_tel -- 单位电话
            ,home_tel -- 家庭电话
            ,phone -- 联系电话
            ,cust_name -- 客户姓名
            ,cust_no -- 客户号
            ,days -- 日期-最大逾期天数(催收)
            ,money -- 金额-合计逾期金额(催收)
            ,call_result -- 外呼结果
            ,call_status -- 外呼状态
            ,create_date -- 创建时间
            ,creator_code -- 创建人用户号
            ,creator_name -- 创建姓名
            ,last_call_time -- 最后呼叫时间
            ,data_stat -- 数据状态
            ,call_id -- 最后的呼叫流水号
            ,succ_tel -- 呼叫成功号码
            ,fail_code -- 呼叫结果原因码
            ,max_call_count -- 最大呼叫次数
            ,call_count -- 已呼叫次数
            ,call_data -- 播报内容
            ,batch_date -- 跑批日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_ob_list_collection_op(
            task_code -- 任务编号
            ,code -- 主键
            ,work_tel -- 单位电话
            ,home_tel -- 家庭电话
            ,phone -- 联系电话
            ,cust_name -- 客户姓名
            ,cust_no -- 客户号
            ,days -- 日期-最大逾期天数(催收)
            ,money -- 金额-合计逾期金额(催收)
            ,call_result -- 外呼结果
            ,call_status -- 外呼状态
            ,create_date -- 创建时间
            ,creator_code -- 创建人用户号
            ,creator_name -- 创建姓名
            ,last_call_time -- 最后呼叫时间
            ,data_stat -- 数据状态
            ,call_id -- 最后的呼叫流水号
            ,succ_tel -- 呼叫成功号码
            ,fail_code -- 呼叫结果原因码
            ,max_call_count -- 最大呼叫次数
            ,call_count -- 已呼叫次数
            ,call_data -- 播报内容
            ,batch_date -- 跑批日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_code -- 任务编号
    ,o.code -- 主键
    ,o.work_tel -- 单位电话
    ,o.home_tel -- 家庭电话
    ,o.phone -- 联系电话
    ,o.cust_name -- 客户姓名
    ,o.cust_no -- 客户号
    ,o.days -- 日期-最大逾期天数(催收)
    ,o.money -- 金额-合计逾期金额(催收)
    ,o.call_result -- 外呼结果
    ,o.call_status -- 外呼状态
    ,o.create_date -- 创建时间
    ,o.creator_code -- 创建人用户号
    ,o.creator_name -- 创建姓名
    ,o.last_call_time -- 最后呼叫时间
    ,o.data_stat -- 数据状态
    ,o.call_id -- 最后的呼叫流水号
    ,o.succ_tel -- 呼叫成功号码
    ,o.fail_code -- 呼叫结果原因码
    ,o.max_call_count -- 最大呼叫次数
    ,o.call_count -- 已呼叫次数
    ,o.call_data -- 播报内容
    ,o.batch_date -- 跑批日期
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
from ${iol_schema}.ccdb_ob_list_collection_bk o
    left join ${iol_schema}.ccdb_ob_list_collection_op n
        on
            o.task_code = n.task_code
            and o.code = n.code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ccdb_ob_list_collection_cl d
        on
            o.task_code = d.task_code
            and o.code = d.code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccdb_ob_list_collection;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ccdb_ob_list_collection') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ccdb_ob_list_collection drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ccdb_ob_list_collection add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ccdb_ob_list_collection exchange partition p_${batch_date} with table ${iol_schema}.ccdb_ob_list_collection_cl;
alter table ${iol_schema}.ccdb_ob_list_collection exchange partition p_20991231 with table ${iol_schema}.ccdb_ob_list_collection_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_ob_list_collection to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_ob_list_collection_op purge;
drop table ${iol_schema}.ccdb_ob_list_collection_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccdb_ob_list_collection_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_ob_list_collection',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
