/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_valueinfo
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
create table ${iol_schema}.mims_si_valueinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_valueinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_valueinfo_op purge;
drop table ${iol_schema}.mims_si_valueinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_valueinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_valueinfo where 0=1;

create table ${iol_schema}.mims_si_valueinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_valueinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_valueinfo_cl(
            sccode -- 
            ,evalmode -- 
            ,evaldate -- 
            ,curreny -- 
            ,rate -- 
            ,outevalexpdate -- 
            ,outevaldeptcode -- 
            ,outevalmethod -- 
            ,outevalflag -- 
            ,outevalamt1 -- 
            ,outevaldate -- 
            ,outevalamt -- 
            ,evalamt -- 
            ,evalamt2 -- 
            ,businessinsid -- 
            ,confmamt -- 
            ,condate -- 
            ,firstoutevalamt -- 
            ,firstevalamt -- 
            ,firstconfmamt -- 
            ,startbusinessinsid -- 
            ,state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_valueinfo_op(
            sccode -- 
            ,evalmode -- 
            ,evaldate -- 
            ,curreny -- 
            ,rate -- 
            ,outevalexpdate -- 
            ,outevaldeptcode -- 
            ,outevalmethod -- 
            ,outevalflag -- 
            ,outevalamt1 -- 
            ,outevaldate -- 
            ,outevalamt -- 
            ,evalamt -- 
            ,evalamt2 -- 
            ,businessinsid -- 
            ,confmamt -- 
            ,condate -- 
            ,firstoutevalamt -- 
            ,firstevalamt -- 
            ,firstconfmamt -- 
            ,startbusinessinsid -- 
            ,state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.evalmode, o.evalmode) as evalmode -- 
    ,nvl(n.evaldate, o.evaldate) as evaldate -- 
    ,nvl(n.curreny, o.curreny) as curreny -- 
    ,nvl(n.rate, o.rate) as rate -- 
    ,nvl(n.outevalexpdate, o.outevalexpdate) as outevalexpdate -- 
    ,nvl(n.outevaldeptcode, o.outevaldeptcode) as outevaldeptcode -- 
    ,nvl(n.outevalmethod, o.outevalmethod) as outevalmethod -- 
    ,nvl(n.outevalflag, o.outevalflag) as outevalflag -- 
    ,nvl(n.outevalamt1, o.outevalamt1) as outevalamt1 -- 
    ,nvl(n.outevaldate, o.outevaldate) as outevaldate -- 
    ,nvl(n.outevalamt, o.outevalamt) as outevalamt -- 
    ,nvl(n.evalamt, o.evalamt) as evalamt -- 
    ,nvl(n.evalamt2, o.evalamt2) as evalamt2 -- 
    ,nvl(n.businessinsid, o.businessinsid) as businessinsid -- 
    ,nvl(n.confmamt, o.confmamt) as confmamt -- 
    ,nvl(n.condate, o.condate) as condate -- 
    ,nvl(n.firstoutevalamt, o.firstoutevalamt) as firstoutevalamt -- 
    ,nvl(n.firstevalamt, o.firstevalamt) as firstevalamt -- 
    ,nvl(n.firstconfmamt, o.firstconfmamt) as firstconfmamt -- 
    ,nvl(n.startbusinessinsid, o.startbusinessinsid) as startbusinessinsid -- 
    ,nvl(n.state, o.state) as state -- 
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_valueinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_valueinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.evalmode <> n.evalmode
        or o.evaldate <> n.evaldate
        or o.curreny <> n.curreny
        or o.rate <> n.rate
        or o.outevalexpdate <> n.outevalexpdate
        or o.outevaldeptcode <> n.outevaldeptcode
        or o.outevalmethod <> n.outevalmethod
        or o.outevalflag <> n.outevalflag
        or o.outevalamt1 <> n.outevalamt1
        or o.outevaldate <> n.outevaldate
        or o.outevalamt <> n.outevalamt
        or o.evalamt <> n.evalamt
        or o.evalamt2 <> n.evalamt2
        or o.businessinsid <> n.businessinsid
        or o.confmamt <> n.confmamt
        or o.condate <> n.condate
        or o.firstoutevalamt <> n.firstoutevalamt
        or o.firstevalamt <> n.firstevalamt
        or o.firstconfmamt <> n.firstconfmamt
        or o.startbusinessinsid <> n.startbusinessinsid
        or o.state <> n.state
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_valueinfo_cl(
            sccode -- 
            ,evalmode -- 
            ,evaldate -- 
            ,curreny -- 
            ,rate -- 
            ,outevalexpdate -- 
            ,outevaldeptcode -- 
            ,outevalmethod -- 
            ,outevalflag -- 
            ,outevalamt1 -- 
            ,outevaldate -- 
            ,outevalamt -- 
            ,evalamt -- 
            ,evalamt2 -- 
            ,businessinsid -- 
            ,confmamt -- 
            ,condate -- 
            ,firstoutevalamt -- 
            ,firstevalamt -- 
            ,firstconfmamt -- 
            ,startbusinessinsid -- 
            ,state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_valueinfo_op(
            sccode -- 
            ,evalmode -- 
            ,evaldate -- 
            ,curreny -- 
            ,rate -- 
            ,outevalexpdate -- 
            ,outevaldeptcode -- 
            ,outevalmethod -- 
            ,outevalflag -- 
            ,outevalamt1 -- 
            ,outevaldate -- 
            ,outevalamt -- 
            ,evalamt -- 
            ,evalamt2 -- 
            ,businessinsid -- 
            ,confmamt -- 
            ,condate -- 
            ,firstoutevalamt -- 
            ,firstevalamt -- 
            ,firstconfmamt -- 
            ,startbusinessinsid -- 
            ,state -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.evalmode -- 
    ,o.evaldate -- 
    ,o.curreny -- 
    ,o.rate -- 
    ,o.outevalexpdate -- 
    ,o.outevaldeptcode -- 
    ,o.outevalmethod -- 
    ,o.outevalflag -- 
    ,o.outevalamt1 -- 
    ,o.outevaldate -- 
    ,o.outevalamt -- 
    ,o.evalamt -- 
    ,o.evalamt2 -- 
    ,o.businessinsid -- 
    ,o.confmamt -- 
    ,o.condate -- 
    ,o.firstoutevalamt -- 
    ,o.firstevalamt -- 
    ,o.firstconfmamt -- 
    ,o.startbusinessinsid -- 
    ,o.state -- 
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
from ${iol_schema}.mims_si_valueinfo_bk o
    left join ${iol_schema}.mims_si_valueinfo_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_valueinfo_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_si_valueinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_valueinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_valueinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_valueinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_valueinfo exchange partition p_${batch_date} with table ${iol_schema}.mims_si_valueinfo_cl;
alter table ${iol_schema}.mims_si_valueinfo exchange partition p_20991231 with table ${iol_schema}.mims_si_valueinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_valueinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_valueinfo_op purge;
drop table ${iol_schema}.mims_si_valueinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_valueinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_valueinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
