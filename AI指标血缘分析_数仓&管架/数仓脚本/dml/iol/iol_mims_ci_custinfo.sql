/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_ci_custinfo
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
create table ${iol_schema}.mims_ci_custinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_ci_custinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_ci_custinfo_op purge;
drop table ${iol_schema}.mims_ci_custinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_ci_custinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_ci_custinfo where 0=1;

create table ${iol_schema}.mims_ci_custinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_ci_custinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_ci_custinfo_cl(
            custid -- 
            ,regioncode -- 
            ,custname -- 
            ,custflag -- 
            ,creditlevel -- 
            ,pd -- 
            ,lnbal -- 
            ,custmgr -- 
            ,deptcode -- 
            ,regionlayout -- 
            ,branchname -- 
            ,effectflag -- 
            ,branchcode -- 
            ,custscale -- 
            ,interindustry -- 
            ,thisindustry -- 
            ,deptname -- 
            ,cardtype -- 
            ,cardid -- 
            ,barsign -- 
            ,corecustid -- 
            ,datasourceflag -- 
            ,establishdate -- 
            ,ecifcustcode -- 
            ,regstarea -- 
            ,subscribecapital -- 
            ,guarmoney -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_ci_custinfo_op(
            custid -- 
            ,regioncode -- 
            ,custname -- 
            ,custflag -- 
            ,creditlevel -- 
            ,pd -- 
            ,lnbal -- 
            ,custmgr -- 
            ,deptcode -- 
            ,regionlayout -- 
            ,branchname -- 
            ,effectflag -- 
            ,branchcode -- 
            ,custscale -- 
            ,interindustry -- 
            ,thisindustry -- 
            ,deptname -- 
            ,cardtype -- 
            ,cardid -- 
            ,barsign -- 
            ,corecustid -- 
            ,datasourceflag -- 
            ,establishdate -- 
            ,ecifcustcode -- 
            ,regstarea -- 
            ,subscribecapital -- 
            ,guarmoney -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custid, o.custid) as custid -- 
    ,nvl(n.regioncode, o.regioncode) as regioncode -- 
    ,nvl(n.custname, o.custname) as custname -- 
    ,nvl(n.custflag, o.custflag) as custflag -- 
    ,nvl(n.creditlevel, o.creditlevel) as creditlevel -- 
    ,nvl(n.pd, o.pd) as pd -- 
    ,nvl(n.lnbal, o.lnbal) as lnbal -- 
    ,nvl(n.custmgr, o.custmgr) as custmgr -- 
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 
    ,nvl(n.regionlayout, o.regionlayout) as regionlayout -- 
    ,nvl(n.branchname, o.branchname) as branchname -- 
    ,nvl(n.effectflag, o.effectflag) as effectflag -- 
    ,nvl(n.branchcode, o.branchcode) as branchcode -- 
    ,nvl(n.custscale, o.custscale) as custscale -- 
    ,nvl(n.interindustry, o.interindustry) as interindustry -- 
    ,nvl(n.thisindustry, o.thisindustry) as thisindustry -- 
    ,nvl(n.deptname, o.deptname) as deptname -- 
    ,nvl(n.cardtype, o.cardtype) as cardtype -- 
    ,nvl(n.cardid, o.cardid) as cardid -- 
    ,nvl(n.barsign, o.barsign) as barsign -- 
    ,nvl(n.corecustid, o.corecustid) as corecustid -- 
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 
    ,nvl(n.establishdate, o.establishdate) as establishdate -- 
    ,nvl(n.ecifcustcode, o.ecifcustcode) as ecifcustcode -- 
    ,nvl(n.regstarea, o.regstarea) as regstarea -- 
    ,nvl(n.subscribecapital, o.subscribecapital) as subscribecapital -- 
    ,nvl(n.guarmoney, o.guarmoney) as guarmoney -- 
    ,case when
            n.custid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_ci_custinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_ci_custinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custid = n.custid
where (
        o.custid is null
    )
    or (
        n.custid is null
    )
    or (
        o.regioncode <> n.regioncode
        or o.custname <> n.custname
        or o.custflag <> n.custflag
        or o.creditlevel <> n.creditlevel
        or o.pd <> n.pd
        or o.lnbal <> n.lnbal
        or o.custmgr <> n.custmgr
        or o.deptcode <> n.deptcode
        or o.regionlayout <> n.regionlayout
        or o.branchname <> n.branchname
        or o.effectflag <> n.effectflag
        or o.branchcode <> n.branchcode
        or o.custscale <> n.custscale
        or o.interindustry <> n.interindustry
        or o.thisindustry <> n.thisindustry
        or o.deptname <> n.deptname
        or o.cardtype <> n.cardtype
        or o.cardid <> n.cardid
        or o.barsign <> n.barsign
        or o.corecustid <> n.corecustid
        or o.datasourceflag <> n.datasourceflag
        or o.establishdate <> n.establishdate
        or o.ecifcustcode <> n.ecifcustcode
        or o.regstarea <> n.regstarea
        or o.subscribecapital <> n.subscribecapital
        or o.guarmoney <> n.guarmoney
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_ci_custinfo_cl(
            custid -- 
            ,regioncode -- 
            ,custname -- 
            ,custflag -- 
            ,creditlevel -- 
            ,pd -- 
            ,lnbal -- 
            ,custmgr -- 
            ,deptcode -- 
            ,regionlayout -- 
            ,branchname -- 
            ,effectflag -- 
            ,branchcode -- 
            ,custscale -- 
            ,interindustry -- 
            ,thisindustry -- 
            ,deptname -- 
            ,cardtype -- 
            ,cardid -- 
            ,barsign -- 
            ,corecustid -- 
            ,datasourceflag -- 
            ,establishdate -- 
            ,ecifcustcode -- 
            ,regstarea -- 
            ,subscribecapital -- 
            ,guarmoney -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_ci_custinfo_op(
            custid -- 
            ,regioncode -- 
            ,custname -- 
            ,custflag -- 
            ,creditlevel -- 
            ,pd -- 
            ,lnbal -- 
            ,custmgr -- 
            ,deptcode -- 
            ,regionlayout -- 
            ,branchname -- 
            ,effectflag -- 
            ,branchcode -- 
            ,custscale -- 
            ,interindustry -- 
            ,thisindustry -- 
            ,deptname -- 
            ,cardtype -- 
            ,cardid -- 
            ,barsign -- 
            ,corecustid -- 
            ,datasourceflag -- 
            ,establishdate -- 
            ,ecifcustcode -- 
            ,regstarea -- 
            ,subscribecapital -- 
            ,guarmoney -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custid -- 
    ,o.regioncode -- 
    ,o.custname -- 
    ,o.custflag -- 
    ,o.creditlevel -- 
    ,o.pd -- 
    ,o.lnbal -- 
    ,o.custmgr -- 
    ,o.deptcode -- 
    ,o.regionlayout -- 
    ,o.branchname -- 
    ,o.effectflag -- 
    ,o.branchcode -- 
    ,o.custscale -- 
    ,o.interindustry -- 
    ,o.thisindustry -- 
    ,o.deptname -- 
    ,o.cardtype -- 
    ,o.cardid -- 
    ,o.barsign -- 
    ,o.corecustid -- 
    ,o.datasourceflag -- 
    ,o.establishdate -- 
    ,o.ecifcustcode -- 
    ,o.regstarea -- 
    ,o.subscribecapital -- 
    ,o.guarmoney -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_ci_custinfo_bk o
    left join ${iol_schema}.mims_ci_custinfo_op n
        on
            o.custid = n.custid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_ci_custinfo_cl d
        on
            o.custid = d.custid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_ci_custinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_ci_custinfo exchange partition p_19000101 with table ${iol_schema}.mims_ci_custinfo_cl;
alter table ${iol_schema}.mims_ci_custinfo exchange partition p_20991231 with table ${iol_schema}.mims_ci_custinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_ci_custinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_ci_custinfo_op purge;
drop table ${iol_schema}.mims_ci_custinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_ci_custinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_ci_custinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
