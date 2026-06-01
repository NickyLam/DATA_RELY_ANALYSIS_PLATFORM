/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_guarwarrants
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
create table ${iol_schema}.mims_si_guarwarrants_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_guarwarrants
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_guarwarrants_op purge;
drop table ${iol_schema}.mims_si_guarwarrants_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarwarrants_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_guarwarrants where 0=1;

create table ${iol_schema}.mims_si_guarwarrants_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_guarwarrants where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_guarwarrants_cl(
            seqno -- 
            ,sccode -- 
            ,warrantsno -- 
            ,warrantname -- 
            ,warrantstype -- 
            ,dptcode -- 
            ,startdate -- 
            ,enddate -- 
            ,recorddate -- 
            ,reguser -- 
            ,remark -- 
            ,inbusinessinsid -- 
            ,acontno -- 
            ,contractno -- 
            ,inno -- 
            ,indate -- 
            ,outbusinessinsid -- 
            ,outdate -- 
            ,bowbusinessinsid -- 
            ,bowtdate -- 
            ,defbusinessinsid -- 
            ,defdate -- 
            ,degree -- 
            ,backdate -- 
            ,state -- 
            ,bursary -- 
            ,location -- 
            ,netamount -- 
            ,isunique -- 
            ,updates -- 
            ,flowflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_guarwarrants_op(
            seqno -- 
            ,sccode -- 
            ,warrantsno -- 
            ,warrantname -- 
            ,warrantstype -- 
            ,dptcode -- 
            ,startdate -- 
            ,enddate -- 
            ,recorddate -- 
            ,reguser -- 
            ,remark -- 
            ,inbusinessinsid -- 
            ,acontno -- 
            ,contractno -- 
            ,inno -- 
            ,indate -- 
            ,outbusinessinsid -- 
            ,outdate -- 
            ,bowbusinessinsid -- 
            ,bowtdate -- 
            ,defbusinessinsid -- 
            ,defdate -- 
            ,degree -- 
            ,backdate -- 
            ,state -- 
            ,bursary -- 
            ,location -- 
            ,netamount -- 
            ,isunique -- 
            ,updates -- 
            ,flowflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seqno, o.seqno) as seqno -- 
    ,nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.warrantsno, o.warrantsno) as warrantsno -- 
    ,nvl(n.warrantname, o.warrantname) as warrantname -- 
    ,nvl(n.warrantstype, o.warrantstype) as warrantstype -- 
    ,nvl(n.dptcode, o.dptcode) as dptcode -- 
    ,nvl(n.startdate, o.startdate) as startdate -- 
    ,nvl(n.enddate, o.enddate) as enddate -- 
    ,nvl(n.recorddate, o.recorddate) as recorddate -- 
    ,nvl(n.reguser, o.reguser) as reguser -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.inbusinessinsid, o.inbusinessinsid) as inbusinessinsid -- 
    ,nvl(n.acontno, o.acontno) as acontno -- 
    ,nvl(n.contractno, o.contractno) as contractno -- 
    ,nvl(n.inno, o.inno) as inno -- 
    ,nvl(n.indate, o.indate) as indate -- 
    ,nvl(n.outbusinessinsid, o.outbusinessinsid) as outbusinessinsid -- 
    ,nvl(n.outdate, o.outdate) as outdate -- 
    ,nvl(n.bowbusinessinsid, o.bowbusinessinsid) as bowbusinessinsid -- 
    ,nvl(n.bowtdate, o.bowtdate) as bowtdate -- 
    ,nvl(n.defbusinessinsid, o.defbusinessinsid) as defbusinessinsid -- 
    ,nvl(n.defdate, o.defdate) as defdate -- 
    ,nvl(n.degree, o.degree) as degree -- 
    ,nvl(n.backdate, o.backdate) as backdate -- 
    ,nvl(n.state, o.state) as state -- 
    ,nvl(n.bursary, o.bursary) as bursary -- 
    ,nvl(n.location, o.location) as location -- 
    ,nvl(n.netamount, o.netamount) as netamount -- 
    ,nvl(n.isunique, o.isunique) as isunique -- 
    ,nvl(n.updates, o.updates) as updates -- 
    ,nvl(n.flowflag, o.flowflag) as flowflag -- 
    ,case when
            n.seqno is null
            and n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seqno is null
            and n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seqno is null
            and n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_guarwarrants_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_guarwarrants where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seqno = n.seqno
            and o.sccode = n.sccode
where (
        o.seqno is null
        and o.sccode is null
    )
    or (
        n.seqno is null
        and n.sccode is null
    )
    or (
        o.warrantsno <> n.warrantsno
        or o.warrantname <> n.warrantname
        or o.warrantstype <> n.warrantstype
        or o.dptcode <> n.dptcode
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.recorddate <> n.recorddate
        or o.reguser <> n.reguser
        or o.remark <> n.remark
        or o.inbusinessinsid <> n.inbusinessinsid
        or o.acontno <> n.acontno
        or o.contractno <> n.contractno
        or o.inno <> n.inno
        or o.indate <> n.indate
        or o.outbusinessinsid <> n.outbusinessinsid
        or o.outdate <> n.outdate
        or o.bowbusinessinsid <> n.bowbusinessinsid
        or o.bowtdate <> n.bowtdate
        or o.defbusinessinsid <> n.defbusinessinsid
        or o.defdate <> n.defdate
        or o.degree <> n.degree
        or o.backdate <> n.backdate
        or o.state <> n.state
        or o.bursary <> n.bursary
        or o.location <> n.location
        or o.netamount <> n.netamount
        or o.isunique <> n.isunique
        or o.updates <> n.updates
        or o.flowflag <> n.flowflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_guarwarrants_cl(
            seqno -- 
            ,sccode -- 
            ,warrantsno -- 
            ,warrantname -- 
            ,warrantstype -- 
            ,dptcode -- 
            ,startdate -- 
            ,enddate -- 
            ,recorddate -- 
            ,reguser -- 
            ,remark -- 
            ,inbusinessinsid -- 
            ,acontno -- 
            ,contractno -- 
            ,inno -- 
            ,indate -- 
            ,outbusinessinsid -- 
            ,outdate -- 
            ,bowbusinessinsid -- 
            ,bowtdate -- 
            ,defbusinessinsid -- 
            ,defdate -- 
            ,degree -- 
            ,backdate -- 
            ,state -- 
            ,bursary -- 
            ,location -- 
            ,netamount -- 
            ,isunique -- 
            ,updates -- 
            ,flowflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_guarwarrants_op(
            seqno -- 
            ,sccode -- 
            ,warrantsno -- 
            ,warrantname -- 
            ,warrantstype -- 
            ,dptcode -- 
            ,startdate -- 
            ,enddate -- 
            ,recorddate -- 
            ,reguser -- 
            ,remark -- 
            ,inbusinessinsid -- 
            ,acontno -- 
            ,contractno -- 
            ,inno -- 
            ,indate -- 
            ,outbusinessinsid -- 
            ,outdate -- 
            ,bowbusinessinsid -- 
            ,bowtdate -- 
            ,defbusinessinsid -- 
            ,defdate -- 
            ,degree -- 
            ,backdate -- 
            ,state -- 
            ,bursary -- 
            ,location -- 
            ,netamount -- 
            ,isunique -- 
            ,updates -- 
            ,flowflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seqno -- 
    ,o.sccode -- 
    ,o.warrantsno -- 
    ,o.warrantname -- 
    ,o.warrantstype -- 
    ,o.dptcode -- 
    ,o.startdate -- 
    ,o.enddate -- 
    ,o.recorddate -- 
    ,o.reguser -- 
    ,o.remark -- 
    ,o.inbusinessinsid -- 
    ,o.acontno -- 
    ,o.contractno -- 
    ,o.inno -- 
    ,o.indate -- 
    ,o.outbusinessinsid -- 
    ,o.outdate -- 
    ,o.bowbusinessinsid -- 
    ,o.bowtdate -- 
    ,o.defbusinessinsid -- 
    ,o.defdate -- 
    ,o.degree -- 
    ,o.backdate -- 
    ,o.state -- 
    ,o.bursary -- 
    ,o.location -- 
    ,o.netamount -- 
    ,o.isunique -- 
    ,o.updates -- 
    ,o.flowflag -- 
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
from ${iol_schema}.mims_si_guarwarrants_bk o
    left join ${iol_schema}.mims_si_guarwarrants_op n
        on
            o.seqno = n.seqno
            and o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_guarwarrants_cl d
        on
            o.seqno = d.seqno
            and o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_si_guarwarrants;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_guarwarrants') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_guarwarrants drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_guarwarrants add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_guarwarrants exchange partition p_${batch_date} with table ${iol_schema}.mims_si_guarwarrants_cl;
alter table ${iol_schema}.mims_si_guarwarrants exchange partition p_20991231 with table ${iol_schema}.mims_si_guarwarrants_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_guarwarrants to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_guarwarrants_op purge;
drop table ${iol_schema}.mims_si_guarwarrants_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_guarwarrants_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_guarwarrants',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
