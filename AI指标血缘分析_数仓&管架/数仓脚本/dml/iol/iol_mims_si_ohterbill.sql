/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_ohterbill
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
create table ${iol_schema}.mims_si_ohterbill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_ohterbill;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_ohterbill_op purge;
drop table ${iol_schema}.mims_si_ohterbill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_ohterbill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_ohterbill where 0=1;

create table ${iol_schema}.mims_si_ohterbill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_ohterbill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_ohterbill_cl(
            sccode -- 
            ,notecode -- 
            ,notetype -- 
            ,remitter -- 
            ,remittercode -- 
            ,remittertype -- 
            ,remitteropenacount -- 
            ,remitteraccount -- 
            ,acceptor -- 
            ,acceptortype -- 
            ,payee -- 
            ,payeetype -- 
            ,isbillbhand -- 
            ,billbhandname -- 
            ,billbhandtype -- 
            ,faceamount -- 
            ,startdate -- 
            ,enddate -- 
            ,remittercountry -- 
            ,remitterrating -- 
            ,acceptorcountry -- 
            ,acceptorrating -- 
            ,remark -- 
            ,ischecks -- 
            ,ishavecheck -- 
            ,isbankpaste -- 
            ,bankpastename -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_ohterbill_op(
            sccode -- 
            ,notecode -- 
            ,notetype -- 
            ,remitter -- 
            ,remittercode -- 
            ,remittertype -- 
            ,remitteropenacount -- 
            ,remitteraccount -- 
            ,acceptor -- 
            ,acceptortype -- 
            ,payee -- 
            ,payeetype -- 
            ,isbillbhand -- 
            ,billbhandname -- 
            ,billbhandtype -- 
            ,faceamount -- 
            ,startdate -- 
            ,enddate -- 
            ,remittercountry -- 
            ,remitterrating -- 
            ,acceptorcountry -- 
            ,acceptorrating -- 
            ,remark -- 
            ,ischecks -- 
            ,ishavecheck -- 
            ,isbankpaste -- 
            ,bankpastename -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.notecode, o.notecode) as notecode -- 
    ,nvl(n.notetype, o.notetype) as notetype -- 
    ,nvl(n.remitter, o.remitter) as remitter -- 
    ,nvl(n.remittercode, o.remittercode) as remittercode -- 
    ,nvl(n.remittertype, o.remittertype) as remittertype -- 
    ,nvl(n.remitteropenacount, o.remitteropenacount) as remitteropenacount -- 
    ,nvl(n.remitteraccount, o.remitteraccount) as remitteraccount -- 
    ,nvl(n.acceptor, o.acceptor) as acceptor -- 
    ,nvl(n.acceptortype, o.acceptortype) as acceptortype -- 
    ,nvl(n.payee, o.payee) as payee -- 
    ,nvl(n.payeetype, o.payeetype) as payeetype -- 
    ,nvl(n.isbillbhand, o.isbillbhand) as isbillbhand -- 
    ,nvl(n.billbhandname, o.billbhandname) as billbhandname -- 
    ,nvl(n.billbhandtype, o.billbhandtype) as billbhandtype -- 
    ,nvl(n.faceamount, o.faceamount) as faceamount -- 
    ,nvl(n.startdate, o.startdate) as startdate -- 
    ,nvl(n.enddate, o.enddate) as enddate -- 
    ,nvl(n.remittercountry, o.remittercountry) as remittercountry -- 
    ,nvl(n.remitterrating, o.remitterrating) as remitterrating -- 
    ,nvl(n.acceptorcountry, o.acceptorcountry) as acceptorcountry -- 
    ,nvl(n.acceptorrating, o.acceptorrating) as acceptorrating -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.ischecks, o.ischecks) as ischecks -- 
    ,nvl(n.ishavecheck, o.ishavecheck) as ishavecheck -- 
    ,nvl(n.isbankpaste, o.isbankpaste) as isbankpaste -- 
    ,nvl(n.bankpastename, o.bankpastename) as bankpastename -- 
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_ohterbill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_ohterbill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.notecode <> n.notecode
        or o.notetype <> n.notetype
        or o.remitter <> n.remitter
        or o.remittercode <> n.remittercode
        or o.remittertype <> n.remittertype
        or o.remitteropenacount <> n.remitteropenacount
        or o.remitteraccount <> n.remitteraccount
        or o.acceptor <> n.acceptor
        or o.acceptortype <> n.acceptortype
        or o.payee <> n.payee
        or o.payeetype <> n.payeetype
        or o.isbillbhand <> n.isbillbhand
        or o.billbhandname <> n.billbhandname
        or o.billbhandtype <> n.billbhandtype
        or o.faceamount <> n.faceamount
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.remittercountry <> n.remittercountry
        or o.remitterrating <> n.remitterrating
        or o.acceptorcountry <> n.acceptorcountry
        or o.acceptorrating <> n.acceptorrating
        or o.remark <> n.remark
        or o.ischecks <> n.ischecks
        or o.ishavecheck <> n.ishavecheck
        or o.isbankpaste <> n.isbankpaste
        or o.bankpastename <> n.bankpastename
        or o.tdcurrency <> n.tdcurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_ohterbill_cl(
            sccode -- 
            ,notecode -- 
            ,notetype -- 
            ,remitter -- 
            ,remittercode -- 
            ,remittertype -- 
            ,remitteropenacount -- 
            ,remitteraccount -- 
            ,acceptor -- 
            ,acceptortype -- 
            ,payee -- 
            ,payeetype -- 
            ,isbillbhand -- 
            ,billbhandname -- 
            ,billbhandtype -- 
            ,faceamount -- 
            ,startdate -- 
            ,enddate -- 
            ,remittercountry -- 
            ,remitterrating -- 
            ,acceptorcountry -- 
            ,acceptorrating -- 
            ,remark -- 
            ,ischecks -- 
            ,ishavecheck -- 
            ,isbankpaste -- 
            ,bankpastename -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_ohterbill_op(
            sccode -- 
            ,notecode -- 
            ,notetype -- 
            ,remitter -- 
            ,remittercode -- 
            ,remittertype -- 
            ,remitteropenacount -- 
            ,remitteraccount -- 
            ,acceptor -- 
            ,acceptortype -- 
            ,payee -- 
            ,payeetype -- 
            ,isbillbhand -- 
            ,billbhandname -- 
            ,billbhandtype -- 
            ,faceamount -- 
            ,startdate -- 
            ,enddate -- 
            ,remittercountry -- 
            ,remitterrating -- 
            ,acceptorcountry -- 
            ,acceptorrating -- 
            ,remark -- 
            ,ischecks -- 
            ,ishavecheck -- 
            ,isbankpaste -- 
            ,bankpastename -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.notecode -- 
    ,o.notetype -- 
    ,o.remitter -- 
    ,o.remittercode -- 
    ,o.remittertype -- 
    ,o.remitteropenacount -- 
    ,o.remitteraccount -- 
    ,o.acceptor -- 
    ,o.acceptortype -- 
    ,o.payee -- 
    ,o.payeetype -- 
    ,o.isbillbhand -- 
    ,o.billbhandname -- 
    ,o.billbhandtype -- 
    ,o.faceamount -- 
    ,o.startdate -- 
    ,o.enddate -- 
    ,o.remittercountry -- 
    ,o.remitterrating -- 
    ,o.acceptorcountry -- 
    ,o.acceptorrating -- 
    ,o.remark -- 
    ,o.ischecks -- 
    ,o.ishavecheck -- 
    ,o.isbankpaste -- 
    ,o.bankpastename -- 
    ,o.tdcurrency -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_ohterbill_bk o
    left join ${iol_schema}.mims_si_ohterbill_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_ohterbill_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_ohterbill;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_ohterbill exchange partition p_19000101 with table ${iol_schema}.mims_si_ohterbill_cl;
alter table ${iol_schema}.mims_si_ohterbill exchange partition p_20991231 with table ${iol_schema}.mims_si_ohterbill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_ohterbill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_ohterbill_op purge;
drop table ${iol_schema}.mims_si_ohterbill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_ohterbill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_ohterbill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
