/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_insurance
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
create table ${iol_schema}.mims_si_insurance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_insurance;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_insurance_op purge;
drop table ${iol_schema}.mims_si_insurance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_insurance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_insurance where 0=1;

create table ${iol_schema}.mims_si_insurance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_insurance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_insurance_cl(
            sccode -- 
            ,incode -- 
            ,inno -- 
            ,insurname -- 
            ,insurcode -- 
            ,isfullguar -- 
            ,insumn -- 
            ,stdate -- 
            ,eddate -- 
            ,efdate -- 
            ,underwriters1 -- 
            ,underwriters2 -- 
            ,operatorid -- 
            ,optdate -- 
            ,updates -- 
            ,state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_insurance_op(
            sccode -- 
            ,incode -- 
            ,inno -- 
            ,insurname -- 
            ,insurcode -- 
            ,isfullguar -- 
            ,insumn -- 
            ,stdate -- 
            ,eddate -- 
            ,efdate -- 
            ,underwriters1 -- 
            ,underwriters2 -- 
            ,operatorid -- 
            ,optdate -- 
            ,updates -- 
            ,state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.incode, o.incode) as incode -- 
    ,nvl(n.inno, o.inno) as inno -- 
    ,nvl(n.insurname, o.insurname) as insurname -- 
    ,nvl(n.insurcode, o.insurcode) as insurcode -- 
    ,nvl(n.isfullguar, o.isfullguar) as isfullguar -- 
    ,nvl(n.insumn, o.insumn) as insumn -- 
    ,nvl(n.stdate, o.stdate) as stdate -- 
    ,nvl(n.eddate, o.eddate) as eddate -- 
    ,nvl(n.efdate, o.efdate) as efdate -- 
    ,nvl(n.underwriters1, o.underwriters1) as underwriters1 -- 
    ,nvl(n.underwriters2, o.underwriters2) as underwriters2 -- 
    ,nvl(n.operatorid, o.operatorid) as operatorid -- 
    ,nvl(n.optdate, o.optdate) as optdate -- 
    ,nvl(n.updates, o.updates) as updates -- 
    ,nvl(n.state, o.state) as state -- 
    ,case when
            n.sccode is null
            and n.incode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
            and n.incode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
            and n.incode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_insurance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_insurance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
            and o.incode = n.incode
where (
        o.sccode is null
        and o.incode is null
    )
    or (
        n.sccode is null
        and n.incode is null
    )
    or (
        o.inno <> n.inno
        or o.insurname <> n.insurname
        or o.insurcode <> n.insurcode
        or o.isfullguar <> n.isfullguar
        or o.insumn <> n.insumn
        or o.stdate <> n.stdate
        or o.eddate <> n.eddate
        or o.efdate <> n.efdate
        or o.underwriters1 <> n.underwriters1
        or o.underwriters2 <> n.underwriters2
        or o.operatorid <> n.operatorid
        or o.optdate <> n.optdate
        or o.updates <> n.updates
        or o.state <> n.state
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_insurance_cl(
            sccode -- 
            ,incode -- 
            ,inno -- 
            ,insurname -- 
            ,insurcode -- 
            ,isfullguar -- 
            ,insumn -- 
            ,stdate -- 
            ,eddate -- 
            ,efdate -- 
            ,underwriters1 -- 
            ,underwriters2 -- 
            ,operatorid -- 
            ,optdate -- 
            ,updates -- 
            ,state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_insurance_op(
            sccode -- 
            ,incode -- 
            ,inno -- 
            ,insurname -- 
            ,insurcode -- 
            ,isfullguar -- 
            ,insumn -- 
            ,stdate -- 
            ,eddate -- 
            ,efdate -- 
            ,underwriters1 -- 
            ,underwriters2 -- 
            ,operatorid -- 
            ,optdate -- 
            ,updates -- 
            ,state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.incode -- 
    ,o.inno -- 
    ,o.insurname -- 
    ,o.insurcode -- 
    ,o.isfullguar -- 
    ,o.insumn -- 
    ,o.stdate -- 
    ,o.eddate -- 
    ,o.efdate -- 
    ,o.underwriters1 -- 
    ,o.underwriters2 -- 
    ,o.operatorid -- 
    ,o.optdate -- 
    ,o.updates -- 
    ,o.state -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_insurance_bk o
    left join ${iol_schema}.mims_si_insurance_op n
        on
            o.sccode = n.sccode
            and o.incode = n.incode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_insurance_cl d
        on
            o.sccode = d.sccode
            and o.incode = d.incode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_insurance;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_insurance exchange partition p_19000101 with table ${iol_schema}.mims_si_insurance_cl;
alter table ${iol_schema}.mims_si_insurance exchange partition p_20991231 with table ${iol_schema}.mims_si_insurance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_insurance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_insurance_op purge;
drop table ${iol_schema}.mims_si_insurance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_insurance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_insurance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
