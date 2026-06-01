/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_sys_department
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
create table ${iol_schema}.mims_sys_department_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_sys_department;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_sys_department_op purge;
drop table ${iol_schema}.mims_sys_department_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_sys_department_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_sys_department where 0=1;

create table ${iol_schema}.mims_sys_department_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_sys_department where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_sys_department_cl(
            deptcode -- 
            ,superdeptcode -- 
            ,deptname -- 
            ,deptdesc -- 
            ,flag -- 
            ,level_code -- 
            ,branchcode -- 
            ,depttype -- 
            ,deptseq -- 
            ,busiaddress -- 
            ,postcode -- 
            ,createdate -- 
            ,areacode -- 
            ,bline -- 
            ,supercode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_sys_department_op(
            deptcode -- 
            ,superdeptcode -- 
            ,deptname -- 
            ,deptdesc -- 
            ,flag -- 
            ,level_code -- 
            ,branchcode -- 
            ,depttype -- 
            ,deptseq -- 
            ,busiaddress -- 
            ,postcode -- 
            ,createdate -- 
            ,areacode -- 
            ,bline -- 
            ,supercode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deptcode, o.deptcode) as deptcode -- 
    ,nvl(n.superdeptcode, o.superdeptcode) as superdeptcode -- 
    ,nvl(n.deptname, o.deptname) as deptname -- 
    ,nvl(n.deptdesc, o.deptdesc) as deptdesc -- 
    ,nvl(n.flag, o.flag) as flag -- 
    ,nvl(n.level_code, o.level_code) as level_code -- 
    ,nvl(n.branchcode, o.branchcode) as branchcode -- 
    ,nvl(n.depttype, o.depttype) as depttype -- 
    ,nvl(n.deptseq, o.deptseq) as deptseq -- 
    ,nvl(n.busiaddress, o.busiaddress) as busiaddress -- 
    ,nvl(n.postcode, o.postcode) as postcode -- 
    ,nvl(n.createdate, o.createdate) as createdate -- 
    ,nvl(n.areacode, o.areacode) as areacode -- 
    ,nvl(n.bline, o.bline) as bline -- 
    ,nvl(n.supercode, o.supercode) as supercode -- 
    ,case when
            n.deptcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deptcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deptcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_sys_department_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_sys_department where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deptcode = n.deptcode
where (
        o.deptcode is null
    )
    or (
        n.deptcode is null
    )
    or (
        o.superdeptcode <> n.superdeptcode
        or o.deptname <> n.deptname
        or o.deptdesc <> n.deptdesc
        or o.flag <> n.flag
        or o.level_code <> n.level_code
        or o.branchcode <> n.branchcode
        or o.depttype <> n.depttype
        or o.deptseq <> n.deptseq
        or o.busiaddress <> n.busiaddress
        or o.postcode <> n.postcode
        or o.createdate <> n.createdate
        or o.areacode <> n.areacode
        or o.bline <> n.bline
        or o.supercode <> n.supercode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_sys_department_cl(
            deptcode -- 
            ,superdeptcode -- 
            ,deptname -- 
            ,deptdesc -- 
            ,flag -- 
            ,level_code -- 
            ,branchcode -- 
            ,depttype -- 
            ,deptseq -- 
            ,busiaddress -- 
            ,postcode -- 
            ,createdate -- 
            ,areacode -- 
            ,bline -- 
            ,supercode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_sys_department_op(
            deptcode -- 
            ,superdeptcode -- 
            ,deptname -- 
            ,deptdesc -- 
            ,flag -- 
            ,level_code -- 
            ,branchcode -- 
            ,depttype -- 
            ,deptseq -- 
            ,busiaddress -- 
            ,postcode -- 
            ,createdate -- 
            ,areacode -- 
            ,bline -- 
            ,supercode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deptcode -- 
    ,o.superdeptcode -- 
    ,o.deptname -- 
    ,o.deptdesc -- 
    ,o.flag -- 
    ,o.level_code -- 
    ,o.branchcode -- 
    ,o.depttype -- 
    ,o.deptseq -- 
    ,o.busiaddress -- 
    ,o.postcode -- 
    ,o.createdate -- 
    ,o.areacode -- 
    ,o.bline -- 
    ,o.supercode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_sys_department_bk o
    left join ${iol_schema}.mims_sys_department_op n
        on
            o.deptcode = n.deptcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_sys_department_cl d
        on
            o.deptcode = d.deptcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_sys_department;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_sys_department exchange partition p_19000101 with table ${iol_schema}.mims_sys_department_cl;
alter table ${iol_schema}.mims_sys_department exchange partition p_20991231 with table ${iol_schema}.mims_sys_department_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_sys_department to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_sys_department_op purge;
drop table ${iol_schema}.mims_sys_department_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_sys_department_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_sys_department',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
