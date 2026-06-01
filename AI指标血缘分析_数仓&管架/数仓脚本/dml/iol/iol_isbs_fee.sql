/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fee
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
create table ${iol_schema}.isbs_fee_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fee
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fee_op purge;
drop table ${iol_schema}.isbs_fee_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fee_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fee where 0=1;

create table ${iol_schema}.isbs_fee_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fee where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fee_cl(
            grpcod -- 
            ,etgextkey -- 
            ,cod -- 
            ,dscmodflg -- 
            ,vatflg -- 
            ,trmtyp -- 
            ,dtacod -- 
            ,sftcod -- 
            ,staflg -- 
            ,ver -- 
            ,begdat -- 
            ,reltir -- 
            ,accacr -- 
            ,rol -- 
            ,eno -- 
            ,enddat -- 
            ,incflg -- 
            ,reltrn -- 
            ,acc -- 
            ,inr -- 
            ,feetyp -- 费率类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fee_op(
            grpcod -- 
            ,etgextkey -- 
            ,cod -- 
            ,dscmodflg -- 
            ,vatflg -- 
            ,trmtyp -- 
            ,dtacod -- 
            ,sftcod -- 
            ,staflg -- 
            ,ver -- 
            ,begdat -- 
            ,reltir -- 
            ,accacr -- 
            ,rol -- 
            ,eno -- 
            ,enddat -- 
            ,incflg -- 
            ,reltrn -- 
            ,acc -- 
            ,inr -- 
            ,feetyp -- 费率类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grpcod, o.grpcod) as grpcod -- 
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 
    ,nvl(n.cod, o.cod) as cod -- 
    ,nvl(n.dscmodflg, o.dscmodflg) as dscmodflg -- 
    ,nvl(n.vatflg, o.vatflg) as vatflg -- 
    ,nvl(n.trmtyp, o.trmtyp) as trmtyp -- 
    ,nvl(n.dtacod, o.dtacod) as dtacod -- 
    ,nvl(n.sftcod, o.sftcod) as sftcod -- 
    ,nvl(n.staflg, o.staflg) as staflg -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.begdat, o.begdat) as begdat -- 
    ,nvl(n.reltir, o.reltir) as reltir -- 
    ,nvl(n.accacr, o.accacr) as accacr -- 
    ,nvl(n.rol, o.rol) as rol -- 
    ,nvl(n.eno, o.eno) as eno -- 
    ,nvl(n.enddat, o.enddat) as enddat -- 
    ,nvl(n.incflg, o.incflg) as incflg -- 
    ,nvl(n.reltrn, o.reltrn) as reltrn -- 
    ,nvl(n.acc, o.acc) as acc -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.feetyp, o.feetyp) as feetyp -- 费率类型
    ,case when
            n.inr is null
            and n.feetyp is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
            and n.feetyp is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
            and n.feetyp is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_fee_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fee where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
            and o.feetyp = n.feetyp
where (
        o.inr is null
        and o.feetyp is null
    )
    or (
        n.inr is null
        and n.feetyp is null
    )
    or (
        o.grpcod <> n.grpcod
        or o.etgextkey <> n.etgextkey
        or o.cod <> n.cod
        or o.dscmodflg <> n.dscmodflg
        or o.vatflg <> n.vatflg
        or o.trmtyp <> n.trmtyp
        or o.dtacod <> n.dtacod
        or o.sftcod <> n.sftcod
        or o.staflg <> n.staflg
        or o.ver <> n.ver
        or o.begdat <> n.begdat
        or o.reltir <> n.reltir
        or o.accacr <> n.accacr
        or o.rol <> n.rol
        or o.eno <> n.eno
        or o.enddat <> n.enddat
        or o.incflg <> n.incflg
        or o.reltrn <> n.reltrn
        or o.acc <> n.acc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fee_cl(
            grpcod -- 
            ,etgextkey -- 
            ,cod -- 
            ,dscmodflg -- 
            ,vatflg -- 
            ,trmtyp -- 
            ,dtacod -- 
            ,sftcod -- 
            ,staflg -- 
            ,ver -- 
            ,begdat -- 
            ,reltir -- 
            ,accacr -- 
            ,rol -- 
            ,eno -- 
            ,enddat -- 
            ,incflg -- 
            ,reltrn -- 
            ,acc -- 
            ,inr -- 
            ,feetyp -- 费率类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fee_op(
            grpcod -- 
            ,etgextkey -- 
            ,cod -- 
            ,dscmodflg -- 
            ,vatflg -- 
            ,trmtyp -- 
            ,dtacod -- 
            ,sftcod -- 
            ,staflg -- 
            ,ver -- 
            ,begdat -- 
            ,reltir -- 
            ,accacr -- 
            ,rol -- 
            ,eno -- 
            ,enddat -- 
            ,incflg -- 
            ,reltrn -- 
            ,acc -- 
            ,inr -- 
            ,feetyp -- 费率类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grpcod -- 
    ,o.etgextkey -- 
    ,o.cod -- 
    ,o.dscmodflg -- 
    ,o.vatflg -- 
    ,o.trmtyp -- 
    ,o.dtacod -- 
    ,o.sftcod -- 
    ,o.staflg -- 
    ,o.ver -- 
    ,o.begdat -- 
    ,o.reltir -- 
    ,o.accacr -- 
    ,o.rol -- 
    ,o.eno -- 
    ,o.enddat -- 
    ,o.incflg -- 
    ,o.reltrn -- 
    ,o.acc -- 
    ,o.inr -- 
    ,o.feetyp -- 费率类型
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
from ${iol_schema}.isbs_fee_bk o
    left join ${iol_schema}.isbs_fee_op n
        on
            o.inr = n.inr
            and o.feetyp = n.feetyp
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fee_cl d
        on
            o.inr = d.inr
            and o.feetyp = d.feetyp
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_fee;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_fee') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_fee drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_fee add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_fee exchange partition p_${batch_date} with table ${iol_schema}.isbs_fee_cl;
alter table ${iol_schema}.isbs_fee exchange partition p_20991231 with table ${iol_schema}.isbs_fee_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fee to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fee_op purge;
drop table ${iol_schema}.isbs_fee_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fee_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fee',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
