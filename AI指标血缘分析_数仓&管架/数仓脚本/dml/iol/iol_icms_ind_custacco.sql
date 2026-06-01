/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_custacco
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
create table ${iol_schema}.icms_ind_custacco_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_custacco
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_custacco_op purge;
drop table ${iol_schema}.icms_ind_custacco_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_custacco_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_custacco where 0=1;

create table ${iol_schema}.icms_ind_custacco_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_custacco where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_custacco_cl(
            customerid -- 
            ,serialno -- 
            ,relativeaccount -- 
            ,accountname -- 
            ,accountbank -- 
            ,updatedate -- 
            ,updateorgid -- 
            ,accountnumber -- 
            ,inputuserid -- 
            ,inputdate -- 
            ,inputorgid -- 
            ,accumulate -- 
            ,updateuserid -- 
            ,accounttype -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_custacco_op(
            customerid -- 
            ,serialno -- 
            ,relativeaccount -- 
            ,accountname -- 
            ,accountbank -- 
            ,updatedate -- 
            ,updateorgid -- 
            ,accountnumber -- 
            ,inputuserid -- 
            ,inputdate -- 
            ,inputorgid -- 
            ,accumulate -- 
            ,updateuserid -- 
            ,accounttype -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 
    ,nvl(n.serialno, o.serialno) as serialno -- 
    ,nvl(n.relativeaccount, o.relativeaccount) as relativeaccount -- 
    ,nvl(n.accountname, o.accountname) as accountname -- 
    ,nvl(n.accountbank, o.accountbank) as accountbank -- 
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 
    ,nvl(n.accountnumber, o.accountnumber) as accountnumber -- 
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 
    ,nvl(n.accumulate, o.accumulate) as accumulate -- 
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,case when
            n.customerid is null
            and n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
            and n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
            and n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ind_custacco_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_custacco where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
            and o.serialno = n.serialno
where (
        o.customerid is null
        and o.serialno is null
    )
    or (
        n.customerid is null
        and n.serialno is null
    )
    or (
        o.relativeaccount <> n.relativeaccount
        or o.accountname <> n.accountname
        or o.accountbank <> n.accountbank
        or o.updatedate <> n.updatedate
        or o.updateorgid <> n.updateorgid
        or o.accountnumber <> n.accountnumber
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.inputorgid <> n.inputorgid
        or o.accumulate <> n.accumulate
        or o.updateuserid <> n.updateuserid
        or o.accounttype <> n.accounttype
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_custacco_cl(
            customerid -- 
            ,serialno -- 
            ,relativeaccount -- 
            ,accountname -- 
            ,accountbank -- 
            ,updatedate -- 
            ,updateorgid -- 
            ,accountnumber -- 
            ,inputuserid -- 
            ,inputdate -- 
            ,inputorgid -- 
            ,accumulate -- 
            ,updateuserid -- 
            ,accounttype -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_custacco_op(
            customerid -- 
            ,serialno -- 
            ,relativeaccount -- 
            ,accountname -- 
            ,accountbank -- 
            ,updatedate -- 
            ,updateorgid -- 
            ,accountnumber -- 
            ,inputuserid -- 
            ,inputdate -- 
            ,inputorgid -- 
            ,accumulate -- 
            ,updateuserid -- 
            ,accounttype -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 
    ,o.serialno -- 
    ,o.relativeaccount -- 
    ,o.accountname -- 
    ,o.accountbank -- 
    ,o.updatedate -- 
    ,o.updateorgid -- 
    ,o.accountnumber -- 
    ,o.inputuserid -- 
    ,o.inputdate -- 
    ,o.inputorgid -- 
    ,o.accumulate -- 
    ,o.updateuserid -- 
    ,o.accounttype -- 
    ,o.remark -- 
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
from ${iol_schema}.icms_ind_custacco_bk o
    left join ${iol_schema}.icms_ind_custacco_op n
        on
            o.customerid = n.customerid
            and o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_custacco_cl d
        on
            o.customerid = d.customerid
            and o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ind_custacco;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_custacco') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_custacco drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_custacco add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_custacco exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_custacco_cl;
alter table ${iol_schema}.icms_ind_custacco exchange partition p_20991231 with table ${iol_schema}.icms_ind_custacco_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_custacco to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_custacco_op purge;
drop table ${iol_schema}.icms_ind_custacco_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_custacco_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_custacco',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
