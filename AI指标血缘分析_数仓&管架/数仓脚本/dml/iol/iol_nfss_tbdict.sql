/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbdict
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
create table ${iol_schema}.nfss_tbdict_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbdict;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbdict_op purge;
drop table ${iol_schema}.nfss_tbdict_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbdict_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbdict where 0=1;

create table ${iol_schema}.nfss_tbdict_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbdict where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbdict_cl(
            hs_key -- 
            ,key_name -- 
            ,val -- 
            ,prompt -- 
            ,kernal_flag -- 
            ,belong_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbdict_op(
            hs_key -- 
            ,key_name -- 
            ,val -- 
            ,prompt -- 
            ,kernal_flag -- 
            ,belong_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.hs_key, o.hs_key) as hs_key -- 
    ,nvl(n.key_name, o.key_name) as key_name -- 
    ,nvl(n.val, o.val) as val -- 
    ,nvl(n.prompt, o.prompt) as prompt -- 
    ,nvl(n.kernal_flag, o.kernal_flag) as kernal_flag -- 
    ,nvl(n.belong_type, o.belong_type) as belong_type -- 
    ,case when
            n.hs_key is null
            and n.key_name is null
            and n.val is null
            and n.prompt is null
            and n.belong_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.hs_key is null
            and n.key_name is null
            and n.val is null
            and n.prompt is null
            and n.belong_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.hs_key is null
            and n.key_name is null
            and n.val is null
            and n.prompt is null
            and n.belong_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbdict_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbdict where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.hs_key = n.hs_key
            and o.key_name = n.key_name
            and o.val = n.val
            and o.prompt = n.prompt
            and o.belong_type = n.belong_type
where (
        o.hs_key is null
        and o.key_name is null
        and o.val is null
        and o.prompt is null
        and o.belong_type is null
    )
    or (
        n.hs_key is null
        and n.key_name is null
        and n.val is null
        and n.prompt is null
        and n.belong_type is null
    )
    or (
        o.kernal_flag <> n.kernal_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbdict_cl(
            hs_key -- 
            ,key_name -- 
            ,val -- 
            ,prompt -- 
            ,kernal_flag -- 
            ,belong_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbdict_op(
            hs_key -- 
            ,key_name -- 
            ,val -- 
            ,prompt -- 
            ,kernal_flag -- 
            ,belong_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.hs_key -- 
    ,o.key_name -- 
    ,o.val -- 
    ,o.prompt -- 
    ,o.kernal_flag -- 
    ,o.belong_type -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbdict_bk o
    left join ${iol_schema}.nfss_tbdict_op n
        on
            o.hs_key = n.hs_key
            and o.key_name = n.key_name
            and o.val = n.val
            and o.prompt = n.prompt
            and o.belong_type = n.belong_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbdict_cl d
        on
            o.hs_key = d.hs_key
            and o.key_name = d.key_name
            and o.val = d.val
            and o.prompt = d.prompt
            and o.belong_type = d.belong_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbdict;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbdict exchange partition p_19000101 with table ${iol_schema}.nfss_tbdict_cl;
alter table ${iol_schema}.nfss_tbdict exchange partition p_20991231 with table ${iol_schema}.nfss_tbdict_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbdict to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbdict_op purge;
drop table ${iol_schema}.nfss_tbdict_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbdict_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbdict',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
