/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_evalcompanyinfo
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
create table ${iol_schema}.mims_yp_evalcompanyinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_yp_evalcompanyinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_evalcompanyinfo_op purge;
drop table ${iol_schema}.mims_yp_evalcompanyinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_evalcompanyinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_evalcompanyinfo where 0=1;

create table ${iol_schema}.mims_yp_evalcompanyinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_evalcompanyinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_evalcompanyinfo_cl(
            extcustid -- 
            ,extcustcname -- 
            ,orgcertcode -- 
            ,licenseid -- 
            ,enrolmoney -- 
            ,thebegindate -- 
            ,thecompanyenddate -- 
            ,begindate -- 
            ,contactname -- 
            ,contacttell -- 
            ,contactphone -- 
            ,barsign -- 
            ,deptcode -- 
            ,address -- 
            ,modifydate -- 
            ,modifyinstruction -- 
            ,outdate -- 
            ,outstruction -- 
            ,status -- 
            ,approvestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_evalcompanyinfo_op(
            extcustid -- 
            ,extcustcname -- 
            ,orgcertcode -- 
            ,licenseid -- 
            ,enrolmoney -- 
            ,thebegindate -- 
            ,thecompanyenddate -- 
            ,begindate -- 
            ,contactname -- 
            ,contacttell -- 
            ,contactphone -- 
            ,barsign -- 
            ,deptcode -- 
            ,address -- 
            ,modifydate -- 
            ,modifyinstruction -- 
            ,outdate -- 
            ,outstruction -- 
            ,status -- 
            ,approvestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.extcustid, o.extcustid) as extcustid -- 
    ,nvl(n.extcustcname, o.extcustcname) as extcustcname -- 
    ,nvl(n.orgcertcode, o.orgcertcode) as orgcertcode -- 
    ,nvl(n.licenseid, o.licenseid) as licenseid -- 
    ,nvl(n.enrolmoney, o.enrolmoney) as enrolmoney -- 
    ,nvl(n.thebegindate, o.thebegindate) as thebegindate -- 
    ,nvl(n.thecompanyenddate, o.thecompanyenddate) as thecompanyenddate -- 
    ,nvl(n.begindate, o.begindate) as begindate -- 
    ,nvl(n.contactname, o.contactname) as contactname -- 
    ,nvl(n.contacttell, o.contacttell) as contacttell -- 
    ,nvl(n.contactphone, o.contactphone) as contactphone -- 
    ,nvl(n.barsign, o.barsign) as barsign -- 
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.modifydate, o.modifydate) as modifydate -- 
    ,nvl(n.modifyinstruction, o.modifyinstruction) as modifyinstruction -- 
    ,nvl(n.outdate, o.outdate) as outdate -- 
    ,nvl(n.outstruction, o.outstruction) as outstruction -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 
    ,case when
            n.extcustid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.extcustid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.extcustid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_yp_evalcompanyinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_yp_evalcompanyinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.extcustid = n.extcustid
where (
        o.extcustid is null
    )
    or (
        n.extcustid is null
    )
    or (
        o.extcustcname <> n.extcustcname
        or o.orgcertcode <> n.orgcertcode
        or o.licenseid <> n.licenseid
        or o.enrolmoney <> n.enrolmoney
        or o.thebegindate <> n.thebegindate
        or o.thecompanyenddate <> n.thecompanyenddate
        or o.begindate <> n.begindate
        or o.contactname <> n.contactname
        or o.contacttell <> n.contacttell
        or o.contactphone <> n.contactphone
        or o.barsign <> n.barsign
        or o.deptcode <> n.deptcode
        or o.address <> n.address
        or o.modifydate <> n.modifydate
        or o.modifyinstruction <> n.modifyinstruction
        or o.outdate <> n.outdate
        or o.outstruction <> n.outstruction
        or o.status <> n.status
        or o.approvestatus <> n.approvestatus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_evalcompanyinfo_cl(
            extcustid -- 
            ,extcustcname -- 
            ,orgcertcode -- 
            ,licenseid -- 
            ,enrolmoney -- 
            ,thebegindate -- 
            ,thecompanyenddate -- 
            ,begindate -- 
            ,contactname -- 
            ,contacttell -- 
            ,contactphone -- 
            ,barsign -- 
            ,deptcode -- 
            ,address -- 
            ,modifydate -- 
            ,modifyinstruction -- 
            ,outdate -- 
            ,outstruction -- 
            ,status -- 
            ,approvestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_evalcompanyinfo_op(
            extcustid -- 
            ,extcustcname -- 
            ,orgcertcode -- 
            ,licenseid -- 
            ,enrolmoney -- 
            ,thebegindate -- 
            ,thecompanyenddate -- 
            ,begindate -- 
            ,contactname -- 
            ,contacttell -- 
            ,contactphone -- 
            ,barsign -- 
            ,deptcode -- 
            ,address -- 
            ,modifydate -- 
            ,modifyinstruction -- 
            ,outdate -- 
            ,outstruction -- 
            ,status -- 
            ,approvestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.extcustid -- 
    ,o.extcustcname -- 
    ,o.orgcertcode -- 
    ,o.licenseid -- 
    ,o.enrolmoney -- 
    ,o.thebegindate -- 
    ,o.thecompanyenddate -- 
    ,o.begindate -- 
    ,o.contactname -- 
    ,o.contacttell -- 
    ,o.contactphone -- 
    ,o.barsign -- 
    ,o.deptcode -- 
    ,o.address -- 
    ,o.modifydate -- 
    ,o.modifyinstruction -- 
    ,o.outdate -- 
    ,o.outstruction -- 
    ,o.status -- 
    ,o.approvestatus -- 
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
from ${iol_schema}.mims_yp_evalcompanyinfo_bk o
    left join ${iol_schema}.mims_yp_evalcompanyinfo_op n
        on
            o.extcustid = n.extcustid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_yp_evalcompanyinfo_cl d
        on
            o.extcustid = d.extcustid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_yp_evalcompanyinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_yp_evalcompanyinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_yp_evalcompanyinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_yp_evalcompanyinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_yp_evalcompanyinfo exchange partition p_${batch_date} with table ${iol_schema}.mims_yp_evalcompanyinfo_cl;
alter table ${iol_schema}.mims_yp_evalcompanyinfo exchange partition p_20991231 with table ${iol_schema}.mims_yp_evalcompanyinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_evalcompanyinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_evalcompanyinfo_op purge;
drop table ${iol_schema}.mims_yp_evalcompanyinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_yp_evalcompanyinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_evalcompanyinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
