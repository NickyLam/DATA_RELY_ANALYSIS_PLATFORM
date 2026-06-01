/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_wfe
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
create table ${iol_schema}.isbs_wfe_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_wfe
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_wfe_op purge;
drop table ${iol_schema}.isbs_wfe_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_wfe_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_wfe where 0=1;

create table ${iol_schema}.isbs_wfe_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_wfe where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_wfe_cl(
            wfsinr -- 
            ,wfssub -- 
            ,srv -- 
            ,sta -- 
            ,rtycnt -- 
            ,tardattim -- 
            ,ssninr -- 
            ,dattim -- 
            ,txt -- 
            ,manflg -- 
            ,opndur -- 
            ,waidur -- 
            ,retdur -- 
            ,hdldur -- 
            ,bchkeyinr -- 
            ,txt2 -- 
            ,itfinr -- 
            ,coreinr -- 
            ,czinr -- 
            ,itfdate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_wfe_op(
            wfsinr -- 
            ,wfssub -- 
            ,srv -- 
            ,sta -- 
            ,rtycnt -- 
            ,tardattim -- 
            ,ssninr -- 
            ,dattim -- 
            ,txt -- 
            ,manflg -- 
            ,opndur -- 
            ,waidur -- 
            ,retdur -- 
            ,hdldur -- 
            ,bchkeyinr -- 
            ,txt2 -- 
            ,itfinr -- 
            ,coreinr -- 
            ,czinr -- 
            ,itfdate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.wfsinr, o.wfsinr) as wfsinr -- 
    ,nvl(n.wfssub, o.wfssub) as wfssub -- 
    ,nvl(n.srv, o.srv) as srv -- 
    ,nvl(n.sta, o.sta) as sta -- 
    ,nvl(n.rtycnt, o.rtycnt) as rtycnt -- 
    ,nvl(n.tardattim, o.tardattim) as tardattim -- 
    ,nvl(n.ssninr, o.ssninr) as ssninr -- 
    ,nvl(n.dattim, o.dattim) as dattim -- 
    ,nvl(n.txt, o.txt) as txt -- 
    ,nvl(n.manflg, o.manflg) as manflg -- 
    ,nvl(n.opndur, o.opndur) as opndur -- 
    ,nvl(n.waidur, o.waidur) as waidur -- 
    ,nvl(n.retdur, o.retdur) as retdur -- 
    ,nvl(n.hdldur, o.hdldur) as hdldur -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.txt2, o.txt2) as txt2 -- 
    ,nvl(n.itfinr, o.itfinr) as itfinr -- 
    ,nvl(n.coreinr, o.coreinr) as coreinr -- 
    ,nvl(n.czinr, o.czinr) as czinr -- 
    ,nvl(n.itfdate, o.itfdate) as itfdate -- 
    ,case when
            n.wfsinr is null
            and n.wfssub is null
            and n.srv is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.wfsinr is null
            and n.wfssub is null
            and n.srv is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.wfsinr is null
            and n.wfssub is null
            and n.srv is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_wfe_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_wfe where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.wfsinr = n.wfsinr
            and o.wfssub = n.wfssub
            and o.srv = n.srv
where (
        o.wfsinr is null
        and o.wfssub is null
        and o.srv is null
    )
    or (
        n.wfsinr is null
        and n.wfssub is null
        and n.srv is null
    )
    or (
        o.sta <> n.sta
        or o.rtycnt <> n.rtycnt
        or o.tardattim <> n.tardattim
        or o.ssninr <> n.ssninr
        or o.dattim <> n.dattim
        or o.txt <> n.txt
        or o.manflg <> n.manflg
        or o.opndur <> n.opndur
        or o.waidur <> n.waidur
        or o.retdur <> n.retdur
        or o.hdldur <> n.hdldur
        or o.bchkeyinr <> n.bchkeyinr
        or o.txt2 <> n.txt2
        or o.itfinr <> n.itfinr
        or o.coreinr <> n.coreinr
        or o.czinr <> n.czinr
        or o.itfdate <> n.itfdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_wfe_cl(
            wfsinr -- 
            ,wfssub -- 
            ,srv -- 
            ,sta -- 
            ,rtycnt -- 
            ,tardattim -- 
            ,ssninr -- 
            ,dattim -- 
            ,txt -- 
            ,manflg -- 
            ,opndur -- 
            ,waidur -- 
            ,retdur -- 
            ,hdldur -- 
            ,bchkeyinr -- 
            ,txt2 -- 
            ,itfinr -- 
            ,coreinr -- 
            ,czinr -- 
            ,itfdate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_wfe_op(
            wfsinr -- 
            ,wfssub -- 
            ,srv -- 
            ,sta -- 
            ,rtycnt -- 
            ,tardattim -- 
            ,ssninr -- 
            ,dattim -- 
            ,txt -- 
            ,manflg -- 
            ,opndur -- 
            ,waidur -- 
            ,retdur -- 
            ,hdldur -- 
            ,bchkeyinr -- 
            ,txt2 -- 
            ,itfinr -- 
            ,coreinr -- 
            ,czinr -- 
            ,itfdate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.wfsinr -- 
    ,o.wfssub -- 
    ,o.srv -- 
    ,o.sta -- 
    ,o.rtycnt -- 
    ,o.tardattim -- 
    ,o.ssninr -- 
    ,o.dattim -- 
    ,o.txt -- 
    ,o.manflg -- 
    ,o.opndur -- 
    ,o.waidur -- 
    ,o.retdur -- 
    ,o.hdldur -- 
    ,o.bchkeyinr -- 
    ,o.txt2 -- 
    ,o.itfinr -- 
    ,o.coreinr -- 
    ,o.czinr -- 
    ,o.itfdate -- 
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
from ${iol_schema}.isbs_wfe_bk o
    left join ${iol_schema}.isbs_wfe_op n
        on
            o.wfsinr = n.wfsinr
            and o.wfssub = n.wfssub
            and o.srv = n.srv
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_wfe_cl d
        on
            o.wfsinr = d.wfsinr
            and o.wfssub = d.wfssub
            and o.srv = d.srv
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_wfe;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_wfe') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_wfe drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_wfe add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_wfe exchange partition p_${batch_date} with table ${iol_schema}.isbs_wfe_cl;
alter table ${iol_schema}.isbs_wfe exchange partition p_20991231 with table ${iol_schema}.isbs_wfe_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_wfe to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_wfe_op purge;
drop table ${iol_schema}.isbs_wfe_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_wfe_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_wfe',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
