/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_ci_cusbasinfo
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
create table ${iol_schema}.mims_ci_cusbasinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_ci_cusbasinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_ci_cusbasinfo_op purge;
drop table ${iol_schema}.mims_ci_cusbasinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_ci_cusbasinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_ci_cusbasinfo where 0=1;

create table ${iol_schema}.mims_ci_cusbasinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_ci_cusbasinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_ci_cusbasinfo_cl(
            custid -- 
            ,regioncode -- 
            ,custcname -- 
            ,orgcertcode -- 
            ,interindustry -- 
            ,thisindustry -- 
            ,custscale -- 
            ,custmgr -- 
            ,deptcode -- 
            ,orgcode -- 
            ,state -- 
            ,custtype -- 
            ,custlevel -- 
            ,pd -- 
            ,inputdate -- 
            ,inputer -- 
            ,modifydate -- 
            ,modifier -- 
            ,curbal -- 
            ,liwacode -- 
            ,corecustid -- 
            ,barsign -- 
            ,datasourceflag -- 
            ,establishdate -- 
            ,ecifcustcode -- 
            ,certificatetype -- 
            ,regstarea -- 
            ,subscribecapital -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_ci_cusbasinfo_op(
            custid -- 
            ,regioncode -- 
            ,custcname -- 
            ,orgcertcode -- 
            ,interindustry -- 
            ,thisindustry -- 
            ,custscale -- 
            ,custmgr -- 
            ,deptcode -- 
            ,orgcode -- 
            ,state -- 
            ,custtype -- 
            ,custlevel -- 
            ,pd -- 
            ,inputdate -- 
            ,inputer -- 
            ,modifydate -- 
            ,modifier -- 
            ,curbal -- 
            ,liwacode -- 
            ,corecustid -- 
            ,barsign -- 
            ,datasourceflag -- 
            ,establishdate -- 
            ,ecifcustcode -- 
            ,certificatetype -- 
            ,regstarea -- 
            ,subscribecapital -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custid, o.custid) as custid -- 
    ,nvl(n.regioncode, o.regioncode) as regioncode -- 
    ,nvl(n.custcname, o.custcname) as custcname -- 
    ,nvl(n.orgcertcode, o.orgcertcode) as orgcertcode -- 
    ,nvl(n.interindustry, o.interindustry) as interindustry -- 
    ,nvl(n.thisindustry, o.thisindustry) as thisindustry -- 
    ,nvl(n.custscale, o.custscale) as custscale -- 
    ,nvl(n.custmgr, o.custmgr) as custmgr -- 
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 
    ,nvl(n.orgcode, o.orgcode) as orgcode -- 
    ,nvl(n.state, o.state) as state -- 
    ,nvl(n.custtype, o.custtype) as custtype -- 
    ,nvl(n.custlevel, o.custlevel) as custlevel -- 
    ,nvl(n.pd, o.pd) as pd -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 
    ,nvl(n.inputer, o.inputer) as inputer -- 
    ,nvl(n.modifydate, o.modifydate) as modifydate -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.curbal, o.curbal) as curbal -- 
    ,nvl(n.liwacode, o.liwacode) as liwacode -- 
    ,nvl(n.corecustid, o.corecustid) as corecustid -- 
    ,nvl(n.barsign, o.barsign) as barsign -- 
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 
    ,nvl(n.establishdate, o.establishdate) as establishdate -- 
    ,nvl(n.ecifcustcode, o.ecifcustcode) as ecifcustcode -- 
    ,nvl(n.certificatetype, o.certificatetype) as certificatetype -- 
    ,nvl(n.regstarea, o.regstarea) as regstarea -- 
    ,nvl(n.subscribecapital, o.subscribecapital) as subscribecapital -- 
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
from (select * from ${iol_schema}.mims_ci_cusbasinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_ci_cusbasinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.custcname <> n.custcname
        or o.orgcertcode <> n.orgcertcode
        or o.interindustry <> n.interindustry
        or o.thisindustry <> n.thisindustry
        or o.custscale <> n.custscale
        or o.custmgr <> n.custmgr
        or o.deptcode <> n.deptcode
        or o.orgcode <> n.orgcode
        or o.state <> n.state
        or o.custtype <> n.custtype
        or o.custlevel <> n.custlevel
        or o.pd <> n.pd
        or o.inputdate <> n.inputdate
        or o.inputer <> n.inputer
        or o.modifydate <> n.modifydate
        or o.modifier <> n.modifier
        or o.curbal <> n.curbal
        or o.liwacode <> n.liwacode
        or o.corecustid <> n.corecustid
        or o.barsign <> n.barsign
        or o.datasourceflag <> n.datasourceflag
        or o.establishdate <> n.establishdate
        or o.ecifcustcode <> n.ecifcustcode
        or o.certificatetype <> n.certificatetype
        or o.regstarea <> n.regstarea
        or o.subscribecapital <> n.subscribecapital
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_ci_cusbasinfo_cl(
            custid -- 
            ,regioncode -- 
            ,custcname -- 
            ,orgcertcode -- 
            ,interindustry -- 
            ,thisindustry -- 
            ,custscale -- 
            ,custmgr -- 
            ,deptcode -- 
            ,orgcode -- 
            ,state -- 
            ,custtype -- 
            ,custlevel -- 
            ,pd -- 
            ,inputdate -- 
            ,inputer -- 
            ,modifydate -- 
            ,modifier -- 
            ,curbal -- 
            ,liwacode -- 
            ,corecustid -- 
            ,barsign -- 
            ,datasourceflag -- 
            ,establishdate -- 
            ,ecifcustcode -- 
            ,certificatetype -- 
            ,regstarea -- 
            ,subscribecapital -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_ci_cusbasinfo_op(
            custid -- 
            ,regioncode -- 
            ,custcname -- 
            ,orgcertcode -- 
            ,interindustry -- 
            ,thisindustry -- 
            ,custscale -- 
            ,custmgr -- 
            ,deptcode -- 
            ,orgcode -- 
            ,state -- 
            ,custtype -- 
            ,custlevel -- 
            ,pd -- 
            ,inputdate -- 
            ,inputer -- 
            ,modifydate -- 
            ,modifier -- 
            ,curbal -- 
            ,liwacode -- 
            ,corecustid -- 
            ,barsign -- 
            ,datasourceflag -- 
            ,establishdate -- 
            ,ecifcustcode -- 
            ,certificatetype -- 
            ,regstarea -- 
            ,subscribecapital -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custid -- 
    ,o.regioncode -- 
    ,o.custcname -- 
    ,o.orgcertcode -- 
    ,o.interindustry -- 
    ,o.thisindustry -- 
    ,o.custscale -- 
    ,o.custmgr -- 
    ,o.deptcode -- 
    ,o.orgcode -- 
    ,o.state -- 
    ,o.custtype -- 
    ,o.custlevel -- 
    ,o.pd -- 
    ,o.inputdate -- 
    ,o.inputer -- 
    ,o.modifydate -- 
    ,o.modifier -- 
    ,o.curbal -- 
    ,o.liwacode -- 
    ,o.corecustid -- 
    ,o.barsign -- 
    ,o.datasourceflag -- 
    ,o.establishdate -- 
    ,o.ecifcustcode -- 
    ,o.certificatetype -- 
    ,o.regstarea -- 
    ,o.subscribecapital -- 
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
from ${iol_schema}.mims_ci_cusbasinfo_bk o
    left join ${iol_schema}.mims_ci_cusbasinfo_op n
        on
            o.custid = n.custid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_ci_cusbasinfo_cl d
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
--truncate table ${iol_schema}.mims_ci_cusbasinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_ci_cusbasinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_ci_cusbasinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_ci_cusbasinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_ci_cusbasinfo exchange partition p_${batch_date} with table ${iol_schema}.mims_ci_cusbasinfo_cl;
alter table ${iol_schema}.mims_ci_cusbasinfo exchange partition p_20991231 with table ${iol_schema}.mims_ci_cusbasinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_ci_cusbasinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_ci_cusbasinfo_op purge;
drop table ${iol_schema}.mims_ci_cusbasinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_ci_cusbasinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_ci_cusbasinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
