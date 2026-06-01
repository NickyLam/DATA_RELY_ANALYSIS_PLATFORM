/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_slc
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
create table ${iol_schema}.mims_si_slc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_slc;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_slc_op purge;
drop table ${iol_schema}.mims_si_slc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_slc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_slc where 0=1;

create table ${iol_schema}.mims_si_slc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_slc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_slc_cl(
            sccode -- 
            ,slcno -- 
            ,slccountry -- 
            ,orgname -- 
            ,orgtype -- 
            ,outratingresult -- 
            ,outratingdate -- 
            ,remark -- 
            ,inratingresult -- 
            ,intatingdate -- 
            ,registcountry -- 
            ,registcountryresult -- 
            ,slcmoney -- 
            ,iscancel -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_slc_op(
            sccode -- 
            ,slcno -- 
            ,slccountry -- 
            ,orgname -- 
            ,orgtype -- 
            ,outratingresult -- 
            ,outratingdate -- 
            ,remark -- 
            ,inratingresult -- 
            ,intatingdate -- 
            ,registcountry -- 
            ,registcountryresult -- 
            ,slcmoney -- 
            ,iscancel -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.slcno, o.slcno) as slcno -- 
    ,nvl(n.slccountry, o.slccountry) as slccountry -- 
    ,nvl(n.orgname, o.orgname) as orgname -- 
    ,nvl(n.orgtype, o.orgtype) as orgtype -- 
    ,nvl(n.outratingresult, o.outratingresult) as outratingresult -- 
    ,nvl(n.outratingdate, o.outratingdate) as outratingdate -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.inratingresult, o.inratingresult) as inratingresult -- 
    ,nvl(n.intatingdate, o.intatingdate) as intatingdate -- 
    ,nvl(n.registcountry, o.registcountry) as registcountry -- 
    ,nvl(n.registcountryresult, o.registcountryresult) as registcountryresult -- 
    ,nvl(n.slcmoney, o.slcmoney) as slcmoney -- 
    ,nvl(n.iscancel, o.iscancel) as iscancel -- 
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 
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
from (select * from ${iol_schema}.mims_si_slc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_slc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.slcno <> n.slcno
        or o.slccountry <> n.slccountry
        or o.orgname <> n.orgname
        or o.orgtype <> n.orgtype
        or o.outratingresult <> n.outratingresult
        or o.outratingdate <> n.outratingdate
        or o.remark <> n.remark
        or o.inratingresult <> n.inratingresult
        or o.intatingdate <> n.intatingdate
        or o.registcountry <> n.registcountry
        or o.registcountryresult <> n.registcountryresult
        or o.slcmoney <> n.slcmoney
        or o.iscancel <> n.iscancel
        or o.tdcurrency <> n.tdcurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_slc_cl(
            sccode -- 
            ,slcno -- 
            ,slccountry -- 
            ,orgname -- 
            ,orgtype -- 
            ,outratingresult -- 
            ,outratingdate -- 
            ,remark -- 
            ,inratingresult -- 
            ,intatingdate -- 
            ,registcountry -- 
            ,registcountryresult -- 
            ,slcmoney -- 
            ,iscancel -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_slc_op(
            sccode -- 
            ,slcno -- 
            ,slccountry -- 
            ,orgname -- 
            ,orgtype -- 
            ,outratingresult -- 
            ,outratingdate -- 
            ,remark -- 
            ,inratingresult -- 
            ,intatingdate -- 
            ,registcountry -- 
            ,registcountryresult -- 
            ,slcmoney -- 
            ,iscancel -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.slcno -- 
    ,o.slccountry -- 
    ,o.orgname -- 
    ,o.orgtype -- 
    ,o.outratingresult -- 
    ,o.outratingdate -- 
    ,o.remark -- 
    ,o.inratingresult -- 
    ,o.intatingdate -- 
    ,o.registcountry -- 
    ,o.registcountryresult -- 
    ,o.slcmoney -- 
    ,o.iscancel -- 
    ,o.tdcurrency -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_slc_bk o
    left join ${iol_schema}.mims_si_slc_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_slc_cl d
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
-- truncate table ${iol_schema}.mims_si_slc;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_slc exchange partition p_19000101 with table ${iol_schema}.mims_si_slc_cl;
alter table ${iol_schema}.mims_si_slc exchange partition p_20991231 with table ${iol_schema}.mims_si_slc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_slc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_slc_op purge;
drop table ${iol_schema}.mims_si_slc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_slc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_slc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
