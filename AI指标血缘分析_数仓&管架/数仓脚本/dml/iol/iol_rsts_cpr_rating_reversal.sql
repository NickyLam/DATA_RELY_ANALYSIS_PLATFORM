/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_cpr_rating_reversal
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
create table ${iol_schema}.rsts_cpr_rating_reversal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rsts_cpr_rating_reversal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_cpr_rating_reversal_op purge;
drop table ${iol_schema}.rsts_cpr_rating_reversal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_rating_reversal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_rating_reversal where 0=1;

create table ${iol_schema}.rsts_cpr_rating_reversal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_rating_reversal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rsts_cpr_rating_reversal_cl(
            uuid -- 指标加工明细ID
            ,serial_no -- 评级流水号
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,machine_rating -- 机评等级
            ,rating_model -- 评级模型
            ,reversal_time -- 推翻时间
            ,is_final_rating -- 是否最终认定评级
            ,reversal_reason -- 评级推翻原因
            ,reversal_rating -- 推翻后评级等级
            ,reversal_cust_no -- 推翻人用户ID
            ,reversal_cust_name -- 推翻人名称
            ,reversal_cust_post -- 推翻人岗位
            ,reversal_cust_dept -- 推翻人部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rsts_cpr_rating_reversal_op(
            uuid -- 指标加工明细ID
            ,serial_no -- 评级流水号
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,machine_rating -- 机评等级
            ,rating_model -- 评级模型
            ,reversal_time -- 推翻时间
            ,is_final_rating -- 是否最终认定评级
            ,reversal_reason -- 评级推翻原因
            ,reversal_rating -- 推翻后评级等级
            ,reversal_cust_no -- 推翻人用户ID
            ,reversal_cust_name -- 推翻人名称
            ,reversal_cust_post -- 推翻人岗位
            ,reversal_cust_dept -- 推翻人部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.uuid, o.uuid) as uuid -- 指标加工明细ID
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 评级流水号
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.machine_rating, o.machine_rating) as machine_rating -- 机评等级
    ,nvl(n.rating_model, o.rating_model) as rating_model -- 评级模型
    ,nvl(n.reversal_time, o.reversal_time) as reversal_time -- 推翻时间
    ,nvl(n.is_final_rating, o.is_final_rating) as is_final_rating -- 是否最终认定评级
    ,nvl(n.reversal_reason, o.reversal_reason) as reversal_reason -- 评级推翻原因
    ,nvl(n.reversal_rating, o.reversal_rating) as reversal_rating -- 推翻后评级等级
    ,nvl(n.reversal_cust_no, o.reversal_cust_no) as reversal_cust_no -- 推翻人用户ID
    ,nvl(n.reversal_cust_name, o.reversal_cust_name) as reversal_cust_name -- 推翻人名称
    ,nvl(n.reversal_cust_post, o.reversal_cust_post) as reversal_cust_post -- 推翻人岗位
    ,nvl(n.reversal_cust_dept, o.reversal_cust_dept) as reversal_cust_dept -- 推翻人部门
    ,case when
            n.uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rsts_cpr_rating_reversal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rsts_cpr_rating_reversal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.uuid = n.uuid
where (
        o.uuid is null
    )
    or (
        n.uuid is null
    )
    or (
        o.serial_no <> n.serial_no
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.machine_rating <> n.machine_rating
        or o.rating_model <> n.rating_model
        or o.reversal_time <> n.reversal_time
        or o.is_final_rating <> n.is_final_rating
        or o.reversal_reason <> n.reversal_reason
        or o.reversal_rating <> n.reversal_rating
        or o.reversal_cust_no <> n.reversal_cust_no
        or o.reversal_cust_name <> n.reversal_cust_name
        or o.reversal_cust_post <> n.reversal_cust_post
        or o.reversal_cust_dept <> n.reversal_cust_dept
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rsts_cpr_rating_reversal_cl(
            uuid -- 指标加工明细ID
            ,serial_no -- 评级流水号
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,machine_rating -- 机评等级
            ,rating_model -- 评级模型
            ,reversal_time -- 推翻时间
            ,is_final_rating -- 是否最终认定评级
            ,reversal_reason -- 评级推翻原因
            ,reversal_rating -- 推翻后评级等级
            ,reversal_cust_no -- 推翻人用户ID
            ,reversal_cust_name -- 推翻人名称
            ,reversal_cust_post -- 推翻人岗位
            ,reversal_cust_dept -- 推翻人部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rsts_cpr_rating_reversal_op(
            uuid -- 指标加工明细ID
            ,serial_no -- 评级流水号
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,machine_rating -- 机评等级
            ,rating_model -- 评级模型
            ,reversal_time -- 推翻时间
            ,is_final_rating -- 是否最终认定评级
            ,reversal_reason -- 评级推翻原因
            ,reversal_rating -- 推翻后评级等级
            ,reversal_cust_no -- 推翻人用户ID
            ,reversal_cust_name -- 推翻人名称
            ,reversal_cust_post -- 推翻人岗位
            ,reversal_cust_dept -- 推翻人部门
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.uuid -- 指标加工明细ID
    ,o.serial_no -- 评级流水号
    ,o.cust_no -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.machine_rating -- 机评等级
    ,o.rating_model -- 评级模型
    ,o.reversal_time -- 推翻时间
    ,o.is_final_rating -- 是否最终认定评级
    ,o.reversal_reason -- 评级推翻原因
    ,o.reversal_rating -- 推翻后评级等级
    ,o.reversal_cust_no -- 推翻人用户ID
    ,o.reversal_cust_name -- 推翻人名称
    ,o.reversal_cust_post -- 推翻人岗位
    ,o.reversal_cust_dept -- 推翻人部门
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
from ${iol_schema}.rsts_cpr_rating_reversal_bk o
    left join ${iol_schema}.rsts_cpr_rating_reversal_op n
        on
            o.uuid = n.uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rsts_cpr_rating_reversal_cl d
        on
            o.uuid = d.uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rsts_cpr_rating_reversal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rsts_cpr_rating_reversal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rsts_cpr_rating_reversal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rsts_cpr_rating_reversal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rsts_cpr_rating_reversal exchange partition p_${batch_date} with table ${iol_schema}.rsts_cpr_rating_reversal_cl;
alter table ${iol_schema}.rsts_cpr_rating_reversal exchange partition p_20991231 with table ${iol_schema}.rsts_cpr_rating_reversal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_cpr_rating_reversal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_cpr_rating_reversal_op purge;
drop table ${iol_schema}.rsts_cpr_rating_reversal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rsts_cpr_rating_reversal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_cpr_rating_reversal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
