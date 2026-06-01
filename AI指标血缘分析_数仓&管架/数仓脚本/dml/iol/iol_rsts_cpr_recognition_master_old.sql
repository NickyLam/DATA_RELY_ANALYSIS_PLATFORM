/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_cpr_recognition_master_old
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
create table ${iol_schema}.rsts_cpr_recognition_master_old_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rsts_cpr_recognition_master_old
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_cpr_recognition_master_old_op purge;
drop table ${iol_schema}.rsts_cpr_recognition_master_old_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_recognition_master_old_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_recognition_master_old where 0=1;

create table ${iol_schema}.rsts_cpr_recognition_master_old_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_recognition_master_old where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rsts_cpr_recognition_master_old_cl(
            uuid -- 指标加工明细ID
            ,serial_no -- 评级流水号
            ,rating_type -- 评级类型
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,final_rating -- 最终等级
            ,reporting_period -- 使用财报期次
            ,reporting_type -- 使用财报类型
            ,rating_effective_time -- 评级生效时间
            ,rating_failure_time -- 评级失效时间
            ,is_effective -- 是否有效
            ,last_serial_no -- 上一次评级流水号
            ,inputs -- 评级记录入参
            ,outputs -- 评级记录出参
            ,is_success -- 是否成功(默认0，1成功，-1失败)
            ,create_time -- 创建时间
            ,spend_time -- 耗时
            ,describe -- 描述
            ,national_industry -- 国标行业
            ,organization -- 所属机构
            ,scene_flag -- 场景标识 0自动违约(写死)，1违约认定(人工二期)，2评级延期，3自动到期，4自动赋值（BBB等），5财报修改,6财报删除
            ,reason -- 原因
            ,migration_time -- 迁移时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rsts_cpr_recognition_master_old_op(
            uuid -- 指标加工明细ID
            ,serial_no -- 评级流水号
            ,rating_type -- 评级类型
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,final_rating -- 最终等级
            ,reporting_period -- 使用财报期次
            ,reporting_type -- 使用财报类型
            ,rating_effective_time -- 评级生效时间
            ,rating_failure_time -- 评级失效时间
            ,is_effective -- 是否有效
            ,last_serial_no -- 上一次评级流水号
            ,inputs -- 评级记录入参
            ,outputs -- 评级记录出参
            ,is_success -- 是否成功(默认0，1成功，-1失败)
            ,create_time -- 创建时间
            ,spend_time -- 耗时
            ,describe -- 描述
            ,national_industry -- 国标行业
            ,organization -- 所属机构
            ,scene_flag -- 场景标识 0自动违约(写死)，1违约认定(人工二期)，2评级延期，3自动到期，4自动赋值（BBB等），5财报修改,6财报删除
            ,reason -- 原因
            ,migration_time -- 迁移时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.uuid, o.uuid) as uuid -- 指标加工明细ID
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 评级流水号
    ,nvl(n.rating_type, o.rating_type) as rating_type -- 评级类型
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.final_rating, o.final_rating) as final_rating -- 最终等级
    ,nvl(n.reporting_period, o.reporting_period) as reporting_period -- 使用财报期次
    ,nvl(n.reporting_type, o.reporting_type) as reporting_type -- 使用财报类型
    ,nvl(n.rating_effective_time, o.rating_effective_time) as rating_effective_time -- 评级生效时间
    ,nvl(n.rating_failure_time, o.rating_failure_time) as rating_failure_time -- 评级失效时间
    ,nvl(n.is_effective, o.is_effective) as is_effective -- 是否有效
    ,nvl(n.last_serial_no, o.last_serial_no) as last_serial_no -- 上一次评级流水号
    ,nvl(n.inputs, o.inputs) as inputs -- 评级记录入参
    ,nvl(n.outputs, o.outputs) as outputs -- 评级记录出参
    ,nvl(n.is_success, o.is_success) as is_success -- 是否成功(默认0，1成功，-1失败)
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.spend_time, o.spend_time) as spend_time -- 耗时
    ,nvl(n.describe, o.describe) as describe -- 描述
    ,nvl(n.national_industry, o.national_industry) as national_industry -- 国标行业
    ,nvl(n.organization, o.organization) as organization -- 所属机构
    ,nvl(n.scene_flag, o.scene_flag) as scene_flag -- 场景标识 0自动违约(写死)，1违约认定(人工二期)，2评级延期，3自动到期，4自动赋值（BBB等），5财报修改,6财报删除
    ,nvl(n.reason, o.reason) as reason -- 原因
    ,nvl(n.migration_time, o.migration_time) as migration_time -- 迁移时间
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
from (select * from ${iol_schema}.rsts_cpr_recognition_master_old_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rsts_cpr_recognition_master_old where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.rating_type <> n.rating_type
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.final_rating <> n.final_rating
        or o.reporting_period <> n.reporting_period
        or o.reporting_type <> n.reporting_type
        or o.rating_effective_time <> n.rating_effective_time
        or o.rating_failure_time <> n.rating_failure_time
        or o.is_effective <> n.is_effective
        or o.last_serial_no <> n.last_serial_no
        or o.inputs <> n.inputs
        or o.outputs <> n.outputs
        or o.is_success <> n.is_success
        or o.create_time <> n.create_time
        or o.spend_time <> n.spend_time
        or o.describe <> n.describe
        or o.national_industry <> n.national_industry
        or o.organization <> n.organization
        or o.scene_flag <> n.scene_flag
        or o.reason <> n.reason
        or o.migration_time <> n.migration_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rsts_cpr_recognition_master_old_cl(
            uuid -- 指标加工明细ID
            ,serial_no -- 评级流水号
            ,rating_type -- 评级类型
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,final_rating -- 最终等级
            ,reporting_period -- 使用财报期次
            ,reporting_type -- 使用财报类型
            ,rating_effective_time -- 评级生效时间
            ,rating_failure_time -- 评级失效时间
            ,is_effective -- 是否有效
            ,last_serial_no -- 上一次评级流水号
            ,inputs -- 评级记录入参
            ,outputs -- 评级记录出参
            ,is_success -- 是否成功(默认0，1成功，-1失败)
            ,create_time -- 创建时间
            ,spend_time -- 耗时
            ,describe -- 描述
            ,national_industry -- 国标行业
            ,organization -- 所属机构
            ,scene_flag -- 场景标识 0自动违约(写死)，1违约认定(人工二期)，2评级延期，3自动到期，4自动赋值（BBB等），5财报修改,6财报删除
            ,reason -- 原因
            ,migration_time -- 迁移时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rsts_cpr_recognition_master_old_op(
            uuid -- 指标加工明细ID
            ,serial_no -- 评级流水号
            ,rating_type -- 评级类型
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,final_rating -- 最终等级
            ,reporting_period -- 使用财报期次
            ,reporting_type -- 使用财报类型
            ,rating_effective_time -- 评级生效时间
            ,rating_failure_time -- 评级失效时间
            ,is_effective -- 是否有效
            ,last_serial_no -- 上一次评级流水号
            ,inputs -- 评级记录入参
            ,outputs -- 评级记录出参
            ,is_success -- 是否成功(默认0，1成功，-1失败)
            ,create_time -- 创建时间
            ,spend_time -- 耗时
            ,describe -- 描述
            ,national_industry -- 国标行业
            ,organization -- 所属机构
            ,scene_flag -- 场景标识 0自动违约(写死)，1违约认定(人工二期)，2评级延期，3自动到期，4自动赋值（BBB等），5财报修改,6财报删除
            ,reason -- 原因
            ,migration_time -- 迁移时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.uuid -- 指标加工明细ID
    ,o.serial_no -- 评级流水号
    ,o.rating_type -- 评级类型
    ,o.cust_no -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.final_rating -- 最终等级
    ,o.reporting_period -- 使用财报期次
    ,o.reporting_type -- 使用财报类型
    ,o.rating_effective_time -- 评级生效时间
    ,o.rating_failure_time -- 评级失效时间
    ,o.is_effective -- 是否有效
    ,o.last_serial_no -- 上一次评级流水号
    ,o.inputs -- 评级记录入参
    ,o.outputs -- 评级记录出参
    ,o.is_success -- 是否成功(默认0，1成功，-1失败)
    ,o.create_time -- 创建时间
    ,o.spend_time -- 耗时
    ,o.describe -- 描述
    ,o.national_industry -- 国标行业
    ,o.organization -- 所属机构
    ,o.scene_flag -- 场景标识 0自动违约(写死)，1违约认定(人工二期)，2评级延期，3自动到期，4自动赋值（BBB等），5财报修改,6财报删除
    ,o.reason -- 原因
    ,o.migration_time -- 迁移时间
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
from ${iol_schema}.rsts_cpr_recognition_master_old_bk o
    left join ${iol_schema}.rsts_cpr_recognition_master_old_op n
        on
            o.uuid = n.uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rsts_cpr_recognition_master_old_cl d
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
--truncate table ${iol_schema}.rsts_cpr_recognition_master_old;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rsts_cpr_recognition_master_old') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rsts_cpr_recognition_master_old drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rsts_cpr_recognition_master_old add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rsts_cpr_recognition_master_old exchange partition p_${batch_date} with table ${iol_schema}.rsts_cpr_recognition_master_old_cl;
alter table ${iol_schema}.rsts_cpr_recognition_master_old exchange partition p_20991231 with table ${iol_schema}.rsts_cpr_recognition_master_old_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_cpr_recognition_master_old to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_cpr_recognition_master_old_op purge;
drop table ${iol_schema}.rsts_cpr_recognition_master_old_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rsts_cpr_recognition_master_old_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_cpr_recognition_master_old',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
