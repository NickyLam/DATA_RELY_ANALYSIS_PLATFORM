/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbdictmap
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
create table ${iol_schema}.ifms_tbdictmap_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbdictmap;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbdictmap_op purge;
drop table ${iol_schema}.ifms_tbdictmap_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbdictmap_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbdictmap where 0=1;

create table ${iol_schema}.ifms_tbdictmap_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbdictmap where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbdictmap_cl(
            templet -- 
            ,key_no -- 
            ,direction -- 
            ,source -- 
            ,val -- 
            ,prompt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbdictmap_op(
            templet -- 
            ,key_no -- 
            ,direction -- 
            ,source -- 
            ,val -- 
            ,prompt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.templet, o.templet) as templet -- 
    ,nvl(n.key_no, o.key_no) as key_no -- 
    ,nvl(n.direction, o.direction) as direction -- 
    ,nvl(n.source, o.source) as source -- 
    ,nvl(n.val, o.val) as val -- 
    ,nvl(n.prompt, o.prompt) as prompt -- 
    ,case when
            n.templet is null
            and n.key_no is null
            and n.direction is null
            and n.source is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.templet is null
            and n.key_no is null
            and n.direction is null
            and n.source is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.templet is null
            and n.key_no is null
            and n.direction is null
            and n.source is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbdictmap_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbdictmap where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.templet = n.templet
            and o.key_no = n.key_no
            and o.direction = n.direction
            and o.source = n.source
where (
        o.templet is null
        and o.key_no is null
        and o.direction is null
        and o.source is null
    )
    or (
        n.templet is null
        and n.key_no is null
        and n.direction is null
        and n.source is null
    )
    or (
        o.val <> n.val
        or o.prompt <> n.prompt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbdictmap_cl(
            templet -- 
            ,key_no -- 
            ,direction -- 
            ,source -- 
            ,val -- 
            ,prompt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbdictmap_op(
            templet -- 
            ,key_no -- 
            ,direction -- 
            ,source -- 
            ,val -- 
            ,prompt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.templet -- 
    ,o.key_no -- 
    ,o.direction -- 
    ,o.source -- 
    ,o.val -- 
    ,o.prompt -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbdictmap_bk o
    left join ${iol_schema}.ifms_tbdictmap_op n
        on
            o.templet = n.templet
            and o.key_no = n.key_no
            and o.direction = n.direction
            and o.source = n.source
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbdictmap_cl d
        on
            o.templet = d.templet
            and o.key_no = d.key_no
            and o.direction = d.direction
            and o.source = d.source
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbdictmap;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbdictmap exchange partition p_19000101 with table ${iol_schema}.ifms_tbdictmap_cl;
alter table ${iol_schema}.ifms_tbdictmap exchange partition p_20991231 with table ${iol_schema}.ifms_tbdictmap_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbdictmap to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbdictmap_op purge;
drop table ${iol_schema}.ifms_tbdictmap_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbdictmap_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbdictmap',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
