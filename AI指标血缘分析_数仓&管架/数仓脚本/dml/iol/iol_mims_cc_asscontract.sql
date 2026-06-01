/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_cc_asscontract
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
create table ${iol_schema}.mims_cc_asscontract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_cc_asscontract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_cc_asscontract_op purge;
drop table ${iol_schema}.mims_cc_asscontract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_cc_asscontract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_cc_asscontract where 0=1;

create table ${iol_schema}.mims_cc_asscontract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_cc_asscontract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_cc_asscontract_cl(
            asscontno -- 
            ,assconttype -- 
            ,asscustid -- 
            ,assregioncode -- 
            ,asscusttype -- 
            ,custlevel -- 
            ,assamt -- 
            ,currency -- 
            ,assamtrmb -- 
            ,startdate -- 
            ,enddate -- 
            ,effectedstate -- 
            ,endstate -- 
            ,createdate -- 
            ,creater -- 
            ,modifydate -- 
            ,modifier -- 
            ,ishighestbondedcontract -- 
            ,datasourceflag -- 
            ,barsign -- 
            ,contype -- 
            ,txtasscontno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_cc_asscontract_op(
            asscontno -- 
            ,assconttype -- 
            ,asscustid -- 
            ,assregioncode -- 
            ,asscusttype -- 
            ,custlevel -- 
            ,assamt -- 
            ,currency -- 
            ,assamtrmb -- 
            ,startdate -- 
            ,enddate -- 
            ,effectedstate -- 
            ,endstate -- 
            ,createdate -- 
            ,creater -- 
            ,modifydate -- 
            ,modifier -- 
            ,ishighestbondedcontract -- 
            ,datasourceflag -- 
            ,barsign -- 
            ,contype -- 
            ,txtasscontno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asscontno, o.asscontno) as asscontno -- 
    ,nvl(n.assconttype, o.assconttype) as assconttype -- 
    ,nvl(n.asscustid, o.asscustid) as asscustid -- 
    ,nvl(n.assregioncode, o.assregioncode) as assregioncode -- 
    ,nvl(n.asscusttype, o.asscusttype) as asscusttype -- 
    ,nvl(n.custlevel, o.custlevel) as custlevel -- 
    ,nvl(n.assamt, o.assamt) as assamt -- 
    ,nvl(n.currency, o.currency) as currency -- 
    ,nvl(n.assamtrmb, o.assamtrmb) as assamtrmb -- 
    ,nvl(n.startdate, o.startdate) as startdate -- 
    ,nvl(n.enddate, o.enddate) as enddate -- 
    ,nvl(n.effectedstate, o.effectedstate) as effectedstate -- 
    ,nvl(n.endstate, o.endstate) as endstate -- 
    ,nvl(n.createdate, o.createdate) as createdate -- 
    ,nvl(n.creater, o.creater) as creater -- 
    ,nvl(n.modifydate, o.modifydate) as modifydate -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.ishighestbondedcontract, o.ishighestbondedcontract) as ishighestbondedcontract -- 
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 
    ,nvl(n.barsign, o.barsign) as barsign -- 
    ,nvl(n.contype, o.contype) as contype -- 
    ,nvl(n.txtasscontno, o.txtasscontno) as txtasscontno -- 
    ,case when
            n.asscontno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asscontno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asscontno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_cc_asscontract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_cc_asscontract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.asscontno = n.asscontno
where (
        o.asscontno is null
    )
    or (
        n.asscontno is null
    )
    or (
        o.assconttype <> n.assconttype
        or o.asscustid <> n.asscustid
        or o.assregioncode <> n.assregioncode
        or o.asscusttype <> n.asscusttype
        or o.custlevel <> n.custlevel
        or o.assamt <> n.assamt
        or o.currency <> n.currency
        or o.assamtrmb <> n.assamtrmb
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.effectedstate <> n.effectedstate
        or o.endstate <> n.endstate
        or o.createdate <> n.createdate
        or o.creater <> n.creater
        or o.modifydate <> n.modifydate
        or o.modifier <> n.modifier
        or o.ishighestbondedcontract <> n.ishighestbondedcontract
        or o.datasourceflag <> n.datasourceflag
        or o.barsign <> n.barsign
        or o.contype <> n.contype
        or o.txtasscontno <> n.txtasscontno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_cc_asscontract_cl(
            asscontno -- 
            ,assconttype -- 
            ,asscustid -- 
            ,assregioncode -- 
            ,asscusttype -- 
            ,custlevel -- 
            ,assamt -- 
            ,currency -- 
            ,assamtrmb -- 
            ,startdate -- 
            ,enddate -- 
            ,effectedstate -- 
            ,endstate -- 
            ,createdate -- 
            ,creater -- 
            ,modifydate -- 
            ,modifier -- 
            ,ishighestbondedcontract -- 
            ,datasourceflag -- 
            ,barsign -- 
            ,contype -- 
            ,txtasscontno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_cc_asscontract_op(
            asscontno -- 
            ,assconttype -- 
            ,asscustid -- 
            ,assregioncode -- 
            ,asscusttype -- 
            ,custlevel -- 
            ,assamt -- 
            ,currency -- 
            ,assamtrmb -- 
            ,startdate -- 
            ,enddate -- 
            ,effectedstate -- 
            ,endstate -- 
            ,createdate -- 
            ,creater -- 
            ,modifydate -- 
            ,modifier -- 
            ,ishighestbondedcontract -- 
            ,datasourceflag -- 
            ,barsign -- 
            ,contype -- 
            ,txtasscontno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asscontno -- 
    ,o.assconttype -- 
    ,o.asscustid -- 
    ,o.assregioncode -- 
    ,o.asscusttype -- 
    ,o.custlevel -- 
    ,o.assamt -- 
    ,o.currency -- 
    ,o.assamtrmb -- 
    ,o.startdate -- 
    ,o.enddate -- 
    ,o.effectedstate -- 
    ,o.endstate -- 
    ,o.createdate -- 
    ,o.creater -- 
    ,o.modifydate -- 
    ,o.modifier -- 
    ,o.ishighestbondedcontract -- 
    ,o.datasourceflag -- 
    ,o.barsign -- 
    ,o.contype -- 
    ,o.txtasscontno -- 
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
from ${iol_schema}.mims_cc_asscontract_bk o
    left join ${iol_schema}.mims_cc_asscontract_op n
        on
            o.asscontno = n.asscontno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_cc_asscontract_cl d
        on
            o.asscontno = d.asscontno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_cc_asscontract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_cc_asscontract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_cc_asscontract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_cc_asscontract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_cc_asscontract exchange partition p_${batch_date} with table ${iol_schema}.mims_cc_asscontract_cl;
alter table ${iol_schema}.mims_cc_asscontract exchange partition p_20991231 with table ${iol_schema}.mims_cc_asscontract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_cc_asscontract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_cc_asscontract_op purge;
drop table ${iol_schema}.mims_cc_asscontract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_cc_asscontract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_cc_asscontract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
