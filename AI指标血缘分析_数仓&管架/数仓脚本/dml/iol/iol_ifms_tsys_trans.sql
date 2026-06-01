/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tsys_trans
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
create table ${iol_schema}.ifms_tsys_trans_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tsys_trans;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tsys_trans_op purge;
drop table ${iol_schema}.ifms_tsys_trans_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_trans_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tsys_trans where 0=1;

create table ${iol_schema}.ifms_tsys_trans_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tsys_trans where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tsys_trans_cl(
            trans_code -- 
            ,trans_name -- 
            ,kind_code -- 
            ,model_code -- 
            ,remark -- 
            ,ext_field_1 -- 
            ,ext_field_2 -- 
            ,ext_field_3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tsys_trans_op(
            trans_code -- 
            ,trans_name -- 
            ,kind_code -- 
            ,model_code -- 
            ,remark -- 
            ,ext_field_1 -- 
            ,ext_field_2 -- 
            ,ext_field_3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trans_code, o.trans_code) as trans_code -- 
    ,nvl(n.trans_name, o.trans_name) as trans_name -- 
    ,nvl(n.kind_code, o.kind_code) as kind_code -- 
    ,nvl(n.model_code, o.model_code) as model_code -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.ext_field_1, o.ext_field_1) as ext_field_1 -- 
    ,nvl(n.ext_field_2, o.ext_field_2) as ext_field_2 -- 
    ,nvl(n.ext_field_3, o.ext_field_3) as ext_field_3 -- 
    ,case when
            n.trans_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trans_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trans_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tsys_trans_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tsys_trans where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trans_code = n.trans_code
where (
        o.trans_code is null
    )
    or (
        n.trans_code is null
    )
    or (
        o.trans_name <> n.trans_name
        or o.kind_code <> n.kind_code
        or o.model_code <> n.model_code
        or o.remark <> n.remark
        or o.ext_field_1 <> n.ext_field_1
        or o.ext_field_2 <> n.ext_field_2
        or o.ext_field_3 <> n.ext_field_3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tsys_trans_cl(
            trans_code -- 
            ,trans_name -- 
            ,kind_code -- 
            ,model_code -- 
            ,remark -- 
            ,ext_field_1 -- 
            ,ext_field_2 -- 
            ,ext_field_3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tsys_trans_op(
            trans_code -- 
            ,trans_name -- 
            ,kind_code -- 
            ,model_code -- 
            ,remark -- 
            ,ext_field_1 -- 
            ,ext_field_2 -- 
            ,ext_field_3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trans_code -- 
    ,o.trans_name -- 
    ,o.kind_code -- 
    ,o.model_code -- 
    ,o.remark -- 
    ,o.ext_field_1 -- 
    ,o.ext_field_2 -- 
    ,o.ext_field_3 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tsys_trans_bk o
    left join ${iol_schema}.ifms_tsys_trans_op n
        on
            o.trans_code = n.trans_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tsys_trans_cl d
        on
            o.trans_code = d.trans_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tsys_trans;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tsys_trans exchange partition p_19000101 with table ${iol_schema}.ifms_tsys_trans_cl;
alter table ${iol_schema}.ifms_tsys_trans exchange partition p_20991231 with table ${iol_schema}.ifms_tsys_trans_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tsys_trans to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tsys_trans_op purge;
drop table ${iol_schema}.ifms_tsys_trans_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tsys_trans_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tsys_trans',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
