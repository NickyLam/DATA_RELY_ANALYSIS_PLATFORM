/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tsys_role_right
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
create table ${iol_schema}.ifms_tsys_role_right_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tsys_role_right;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tsys_role_right_op purge;
drop table ${iol_schema}.ifms_tsys_role_right_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_role_right_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tsys_role_right where 0=1;

create table ${iol_schema}.ifms_tsys_role_right_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tsys_role_right where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tsys_role_right_cl(
            trans_code -- 
            ,sub_trans_code -- 
            ,role_code -- 
            ,create_by -- 
            ,create_date -- 
            ,begin_date -- 
            ,end_date -- 
            ,right_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tsys_role_right_op(
            trans_code -- 
            ,sub_trans_code -- 
            ,role_code -- 
            ,create_by -- 
            ,create_date -- 
            ,begin_date -- 
            ,end_date -- 
            ,right_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trans_code, o.trans_code) as trans_code -- 
    ,nvl(n.sub_trans_code, o.sub_trans_code) as sub_trans_code -- 
    ,nvl(n.role_code, o.role_code) as role_code -- 
    ,nvl(n.create_by, o.create_by) as create_by -- 
    ,nvl(n.create_date, o.create_date) as create_date -- 
    ,nvl(n.begin_date, o.begin_date) as begin_date -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,nvl(n.right_flag, o.right_flag) as right_flag -- 
    ,case when
            n.trans_code is null
            and n.sub_trans_code is null
            and n.role_code is null
            and n.begin_date is null
            and n.end_date is null
            and n.right_flag is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trans_code is null
            and n.sub_trans_code is null
            and n.role_code is null
            and n.begin_date is null
            and n.end_date is null
            and n.right_flag is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trans_code is null
            and n.sub_trans_code is null
            and n.role_code is null
            and n.begin_date is null
            and n.end_date is null
            and n.right_flag is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tsys_role_right_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tsys_role_right where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trans_code = n.trans_code
            and o.sub_trans_code = n.sub_trans_code
            and o.role_code = n.role_code
            and o.begin_date = n.begin_date
            and o.end_date = n.end_date
            and o.right_flag = n.right_flag
where (
        o.trans_code is null
        and o.sub_trans_code is null
        and o.role_code is null
        and o.begin_date is null
        and o.end_date is null
        and o.right_flag is null
    )
    or (
        n.trans_code is null
        and n.sub_trans_code is null
        and n.role_code is null
        and n.begin_date is null
        and n.end_date is null
        and n.right_flag is null
    )
    or (
        o.create_by <> n.create_by
        or o.create_date <> n.create_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tsys_role_right_cl(
            trans_code -- 
            ,sub_trans_code -- 
            ,role_code -- 
            ,create_by -- 
            ,create_date -- 
            ,begin_date -- 
            ,end_date -- 
            ,right_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tsys_role_right_op(
            trans_code -- 
            ,sub_trans_code -- 
            ,role_code -- 
            ,create_by -- 
            ,create_date -- 
            ,begin_date -- 
            ,end_date -- 
            ,right_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trans_code -- 
    ,o.sub_trans_code -- 
    ,o.role_code -- 
    ,o.create_by -- 
    ,o.create_date -- 
    ,o.begin_date -- 
    ,o.end_date -- 
    ,o.right_flag -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tsys_role_right_bk o
    left join ${iol_schema}.ifms_tsys_role_right_op n
        on
            o.trans_code = n.trans_code
            and o.sub_trans_code = n.sub_trans_code
            and o.role_code = n.role_code
            and o.begin_date = n.begin_date
            and o.end_date = n.end_date
            and o.right_flag = n.right_flag
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tsys_role_right_cl d
        on
            o.trans_code = d.trans_code
            and o.sub_trans_code = d.sub_trans_code
            and o.role_code = d.role_code
            and o.begin_date = d.begin_date
            and o.end_date = d.end_date
            and o.right_flag = d.right_flag
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tsys_role_right;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tsys_role_right exchange partition p_19000101 with table ${iol_schema}.ifms_tsys_role_right_cl;
alter table ${iol_schema}.ifms_tsys_role_right exchange partition p_20991231 with table ${iol_schema}.ifms_tsys_role_right_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tsys_role_right to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tsys_role_right_op purge;
drop table ${iol_schema}.ifms_tsys_role_right_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tsys_role_right_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tsys_role_right',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
