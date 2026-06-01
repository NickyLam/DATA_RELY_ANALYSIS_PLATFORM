/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fcp
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
create table ${iol_schema}.isbs_fcp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fcp;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fcp_op purge;
drop table ${iol_schema}.isbs_fcp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fcp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fcp where 0=1;

create table ${iol_schema}.isbs_fcp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fcp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fcp_cl(
            dat2 -- 
            ,sepinr -- 
            ,amt -- 
            ,modflg -- 
            ,inr -- 
            ,xrfcur -- 
            ,payptyinr -- 
            ,srctrninr -- 
            ,dbttxt -- 
            ,dat1 -- 
            ,rpltrninr -- 
            ,cur -- 
            ,payrol -- 
            ,dondat -- 
            ,paytxt -- 
            ,objinr -- 
            ,dontrninr -- 
            ,advdat -- 
            ,dbtrol -- 
            ,advtrninr -- 
            ,rpldat -- 
            ,dbtptyinr -- 
            ,objtyp -- 
            ,xrfamt -- 
            ,srcdat -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fcp_op(
            dat2 -- 
            ,sepinr -- 
            ,amt -- 
            ,modflg -- 
            ,inr -- 
            ,xrfcur -- 
            ,payptyinr -- 
            ,srctrninr -- 
            ,dbttxt -- 
            ,dat1 -- 
            ,rpltrninr -- 
            ,cur -- 
            ,payrol -- 
            ,dondat -- 
            ,paytxt -- 
            ,objinr -- 
            ,dontrninr -- 
            ,advdat -- 
            ,dbtrol -- 
            ,advtrninr -- 
            ,rpldat -- 
            ,dbtptyinr -- 
            ,objtyp -- 
            ,xrfamt -- 
            ,srcdat -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dat2, o.dat2) as dat2 -- 
    ,nvl(n.sepinr, o.sepinr) as sepinr -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.modflg, o.modflg) as modflg -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.xrfcur, o.xrfcur) as xrfcur -- 
    ,nvl(n.payptyinr, o.payptyinr) as payptyinr -- 
    ,nvl(n.srctrninr, o.srctrninr) as srctrninr -- 
    ,nvl(n.dbttxt, o.dbttxt) as dbttxt -- 
    ,nvl(n.dat1, o.dat1) as dat1 -- 
    ,nvl(n.rpltrninr, o.rpltrninr) as rpltrninr -- 
    ,nvl(n.cur, o.cur) as cur -- 
    ,nvl(n.payrol, o.payrol) as payrol -- 
    ,nvl(n.dondat, o.dondat) as dondat -- 
    ,nvl(n.paytxt, o.paytxt) as paytxt -- 
    ,nvl(n.objinr, o.objinr) as objinr -- 
    ,nvl(n.dontrninr, o.dontrninr) as dontrninr -- 
    ,nvl(n.advdat, o.advdat) as advdat -- 
    ,nvl(n.dbtrol, o.dbtrol) as dbtrol -- 
    ,nvl(n.advtrninr, o.advtrninr) as advtrninr -- 
    ,nvl(n.rpldat, o.rpldat) as rpldat -- 
    ,nvl(n.dbtptyinr, o.dbtptyinr) as dbtptyinr -- 
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 
    ,nvl(n.xrfamt, o.xrfamt) as xrfamt -- 
    ,nvl(n.srcdat, o.srcdat) as srcdat -- 
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_fcp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fcp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.dat2 <> n.dat2
        or o.sepinr <> n.sepinr
        or o.amt <> n.amt
        or o.modflg <> n.modflg
        or o.xrfcur <> n.xrfcur
        or o.payptyinr <> n.payptyinr
        or o.srctrninr <> n.srctrninr
        or o.dbttxt <> n.dbttxt
        or o.dat1 <> n.dat1
        or o.rpltrninr <> n.rpltrninr
        or o.cur <> n.cur
        or o.payrol <> n.payrol
        or o.dondat <> n.dondat
        or o.paytxt <> n.paytxt
        or o.objinr <> n.objinr
        or o.dontrninr <> n.dontrninr
        or o.advdat <> n.advdat
        or o.dbtrol <> n.dbtrol
        or o.advtrninr <> n.advtrninr
        or o.rpldat <> n.rpldat
        or o.dbtptyinr <> n.dbtptyinr
        or o.objtyp <> n.objtyp
        or o.xrfamt <> n.xrfamt
        or o.srcdat <> n.srcdat
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fcp_cl(
            dat2 -- 
            ,sepinr -- 
            ,amt -- 
            ,modflg -- 
            ,inr -- 
            ,xrfcur -- 
            ,payptyinr -- 
            ,srctrninr -- 
            ,dbttxt -- 
            ,dat1 -- 
            ,rpltrninr -- 
            ,cur -- 
            ,payrol -- 
            ,dondat -- 
            ,paytxt -- 
            ,objinr -- 
            ,dontrninr -- 
            ,advdat -- 
            ,dbtrol -- 
            ,advtrninr -- 
            ,rpldat -- 
            ,dbtptyinr -- 
            ,objtyp -- 
            ,xrfamt -- 
            ,srcdat -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fcp_op(
            dat2 -- 
            ,sepinr -- 
            ,amt -- 
            ,modflg -- 
            ,inr -- 
            ,xrfcur -- 
            ,payptyinr -- 
            ,srctrninr -- 
            ,dbttxt -- 
            ,dat1 -- 
            ,rpltrninr -- 
            ,cur -- 
            ,payrol -- 
            ,dondat -- 
            ,paytxt -- 
            ,objinr -- 
            ,dontrninr -- 
            ,advdat -- 
            ,dbtrol -- 
            ,advtrninr -- 
            ,rpldat -- 
            ,dbtptyinr -- 
            ,objtyp -- 
            ,xrfamt -- 
            ,srcdat -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dat2 -- 
    ,o.sepinr -- 
    ,o.amt -- 
    ,o.modflg -- 
    ,o.inr -- 
    ,o.xrfcur -- 
    ,o.payptyinr -- 
    ,o.srctrninr -- 
    ,o.dbttxt -- 
    ,o.dat1 -- 
    ,o.rpltrninr -- 
    ,o.cur -- 
    ,o.payrol -- 
    ,o.dondat -- 
    ,o.paytxt -- 
    ,o.objinr -- 
    ,o.dontrninr -- 
    ,o.advdat -- 
    ,o.dbtrol -- 
    ,o.advtrninr -- 
    ,o.rpldat -- 
    ,o.dbtptyinr -- 
    ,o.objtyp -- 
    ,o.xrfamt -- 
    ,o.srcdat -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_fcp_bk o
    left join ${iol_schema}.isbs_fcp_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fcp_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_fcp;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_fcp exchange partition p_19000101 with table ${iol_schema}.isbs_fcp_cl;
alter table ${iol_schema}.isbs_fcp exchange partition p_20991231 with table ${iol_schema}.isbs_fcp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fcp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fcp_op purge;
drop table ${iol_schema}.isbs_fcp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fcp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fcp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
