/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_pi_cusbasinfo
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
create table ${iol_schema}.mims_pi_cusbasinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_pi_cusbasinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_pi_cusbasinfo_op purge;
drop table ${iol_schema}.mims_pi_cusbasinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_pi_cusbasinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_pi_cusbasinfo where 0=1;

create table ${iol_schema}.mims_pi_cusbasinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_pi_cusbasinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_pi_cusbasinfo_cl(
            custid -- 
            ,regioncode -- 
            ,custname -- 
            ,custtype -- 
            ,custmgr -- 
            ,deptcode -- 
            ,orgcode -- 
            ,cardtype -- 
            ,cardno -- 
            ,liwacode -- 
            ,inputer -- 
            ,inputdate -- 
            ,modifier -- 
            ,modifydate -- 
            ,custlevel -- 
            ,pd -- 
            ,state -- 
            ,corecustid -- 
            ,barsign -- 
            ,curbal -- 
            ,datasourceflag -- 
            ,ecifcustcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_pi_cusbasinfo_op(
            custid -- 
            ,regioncode -- 
            ,custname -- 
            ,custtype -- 
            ,custmgr -- 
            ,deptcode -- 
            ,orgcode -- 
            ,cardtype -- 
            ,cardno -- 
            ,liwacode -- 
            ,inputer -- 
            ,inputdate -- 
            ,modifier -- 
            ,modifydate -- 
            ,custlevel -- 
            ,pd -- 
            ,state -- 
            ,corecustid -- 
            ,barsign -- 
            ,curbal -- 
            ,datasourceflag -- 
            ,ecifcustcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custid, o.custid) as custid -- 
    ,nvl(n.regioncode, o.regioncode) as regioncode -- 
    ,nvl(n.custname, o.custname) as custname -- 
    ,nvl(n.custtype, o.custtype) as custtype -- 
    ,nvl(n.custmgr, o.custmgr) as custmgr -- 
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 
    ,nvl(n.orgcode, o.orgcode) as orgcode -- 
    ,nvl(n.cardtype, o.cardtype) as cardtype -- 
    ,nvl(n.cardno, o.cardno) as cardno -- 
    ,nvl(n.liwacode, o.liwacode) as liwacode -- 
    ,nvl(n.inputer, o.inputer) as inputer -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.modifydate, o.modifydate) as modifydate -- 
    ,nvl(n.custlevel, o.custlevel) as custlevel -- 
    ,nvl(n.pd, o.pd) as pd -- 
    ,nvl(n.state, o.state) as state -- 
    ,nvl(n.corecustid, o.corecustid) as corecustid -- 
    ,nvl(n.barsign, o.barsign) as barsign -- 
    ,nvl(n.curbal, o.curbal) as curbal -- 
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 
    ,nvl(n.ecifcustcode, o.ecifcustcode) as ecifcustcode -- 
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
from (select * from ${iol_schema}.mims_pi_cusbasinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_pi_cusbasinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.custtype <> n.custtype
        or o.custmgr <> n.custmgr
        or o.deptcode <> n.deptcode
        or o.orgcode <> n.orgcode
        or o.cardtype <> n.cardtype
        or o.cardno <> n.cardno
        or o.liwacode <> n.liwacode
        or o.inputer <> n.inputer
        or o.inputdate <> n.inputdate
        or o.modifier <> n.modifier
        or o.modifydate <> n.modifydate
        or o.custlevel <> n.custlevel
        or o.pd <> n.pd
        or o.state <> n.state
        or o.corecustid <> n.corecustid
        or o.barsign <> n.barsign
        or o.curbal <> n.curbal
        or o.datasourceflag <> n.datasourceflag
        or o.ecifcustcode <> n.ecifcustcode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_pi_cusbasinfo_cl(
            custid -- 
            ,regioncode -- 
            ,custname -- 
            ,custtype -- 
            ,custmgr -- 
            ,deptcode -- 
            ,orgcode -- 
            ,cardtype -- 
            ,cardno -- 
            ,liwacode -- 
            ,inputer -- 
            ,inputdate -- 
            ,modifier -- 
            ,modifydate -- 
            ,custlevel -- 
            ,pd -- 
            ,state -- 
            ,corecustid -- 
            ,barsign -- 
            ,curbal -- 
            ,datasourceflag -- 
            ,ecifcustcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_pi_cusbasinfo_op(
            custid -- 
            ,regioncode -- 
            ,custname -- 
            ,custtype -- 
            ,custmgr -- 
            ,deptcode -- 
            ,orgcode -- 
            ,cardtype -- 
            ,cardno -- 
            ,liwacode -- 
            ,inputer -- 
            ,inputdate -- 
            ,modifier -- 
            ,modifydate -- 
            ,custlevel -- 
            ,pd -- 
            ,state -- 
            ,corecustid -- 
            ,barsign -- 
            ,curbal -- 
            ,datasourceflag -- 
            ,ecifcustcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custid -- 
    ,o.regioncode -- 
    ,o.custname -- 
    ,o.custtype -- 
    ,o.custmgr -- 
    ,o.deptcode -- 
    ,o.orgcode -- 
    ,o.cardtype -- 
    ,o.cardno -- 
    ,o.liwacode -- 
    ,o.inputer -- 
    ,o.inputdate -- 
    ,o.modifier -- 
    ,o.modifydate -- 
    ,o.custlevel -- 
    ,o.pd -- 
    ,o.state -- 
    ,o.corecustid -- 
    ,o.barsign -- 
    ,o.curbal -- 
    ,o.datasourceflag -- 
    ,o.ecifcustcode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_pi_cusbasinfo_bk o
    left join ${iol_schema}.mims_pi_cusbasinfo_op n
        on
            o.custid = n.custid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_pi_cusbasinfo_cl d
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
-- truncate table ${iol_schema}.mims_pi_cusbasinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_pi_cusbasinfo exchange partition p_19000101 with table ${iol_schema}.mims_pi_cusbasinfo_cl;
alter table ${iol_schema}.mims_pi_cusbasinfo exchange partition p_20991231 with table ${iol_schema}.mims_pi_cusbasinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_pi_cusbasinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_pi_cusbasinfo_op purge;
drop table ${iol_schema}.mims_pi_cusbasinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_pi_cusbasinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_pi_cusbasinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
