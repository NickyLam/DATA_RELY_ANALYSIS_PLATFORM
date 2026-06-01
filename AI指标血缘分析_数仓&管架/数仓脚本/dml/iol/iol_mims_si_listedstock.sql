/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_listedstock
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
create table ${iol_schema}.mims_si_listedstock_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_listedstock;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_listedstock_op purge;
drop table ${iol_schema}.mims_si_listedstock_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_listedstock_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_listedstock where 0=1;

create table ${iol_schema}.mims_si_listedstock_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_listedstock where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_listedstock_cl(
            sccode -- 
            ,stockcode -- 
            ,stockname -- 
            ,companyname -- 
            ,isborrower -- 
            ,profits -- 
            ,isnromal -- 
            ,bourse -- 
            ,ispublic -- 
            ,exponent -- 
            ,shareamount -- 
            ,stockamount -- 
            ,persharemarketprice -- 
            ,profitmoney -- 
            ,warningline -- 
            ,persharevalue -- 
            ,liquidateline -- 
            ,totalvalue -- 
            ,duedate -- 
            ,remark -- 
            ,tdcurrency -- 
            ,stockidc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_listedstock_op(
            sccode -- 
            ,stockcode -- 
            ,stockname -- 
            ,companyname -- 
            ,isborrower -- 
            ,profits -- 
            ,isnromal -- 
            ,bourse -- 
            ,ispublic -- 
            ,exponent -- 
            ,shareamount -- 
            ,stockamount -- 
            ,persharemarketprice -- 
            ,profitmoney -- 
            ,warningline -- 
            ,persharevalue -- 
            ,liquidateline -- 
            ,totalvalue -- 
            ,duedate -- 
            ,remark -- 
            ,tdcurrency -- 
            ,stockidc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.stockcode, o.stockcode) as stockcode -- 
    ,nvl(n.stockname, o.stockname) as stockname -- 
    ,nvl(n.companyname, o.companyname) as companyname -- 
    ,nvl(n.isborrower, o.isborrower) as isborrower -- 
    ,nvl(n.profits, o.profits) as profits -- 
    ,nvl(n.isnromal, o.isnromal) as isnromal -- 
    ,nvl(n.bourse, o.bourse) as bourse -- 
    ,nvl(n.ispublic, o.ispublic) as ispublic -- 
    ,nvl(n.exponent, o.exponent) as exponent -- 
    ,nvl(n.shareamount, o.shareamount) as shareamount -- 
    ,nvl(n.stockamount, o.stockamount) as stockamount -- 
    ,nvl(n.persharemarketprice, o.persharemarketprice) as persharemarketprice -- 
    ,nvl(n.profitmoney, o.profitmoney) as profitmoney -- 
    ,nvl(n.warningline, o.warningline) as warningline -- 
    ,nvl(n.persharevalue, o.persharevalue) as persharevalue -- 
    ,nvl(n.liquidateline, o.liquidateline) as liquidateline -- 
    ,nvl(n.totalvalue, o.totalvalue) as totalvalue -- 
    ,nvl(n.duedate, o.duedate) as duedate -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 
    ,nvl(n.stockidc, o.stockidc) as stockidc -- 
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
from (select * from ${iol_schema}.mims_si_listedstock_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_listedstock where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.stockcode <> n.stockcode
        or o.stockname <> n.stockname
        or o.companyname <> n.companyname
        or o.isborrower <> n.isborrower
        or o.profits <> n.profits
        or o.isnromal <> n.isnromal
        or o.bourse <> n.bourse
        or o.ispublic <> n.ispublic
        or o.exponent <> n.exponent
        or o.shareamount <> n.shareamount
        or o.stockamount <> n.stockamount
        or o.persharemarketprice <> n.persharemarketprice
        or o.profitmoney <> n.profitmoney
        or o.warningline <> n.warningline
        or o.persharevalue <> n.persharevalue
        or o.liquidateline <> n.liquidateline
        or o.totalvalue <> n.totalvalue
        or o.duedate <> n.duedate
        or o.remark <> n.remark
        or o.tdcurrency <> n.tdcurrency
        or o.stockidc <> n.stockidc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_listedstock_cl(
            sccode -- 
            ,stockcode -- 
            ,stockname -- 
            ,companyname -- 
            ,isborrower -- 
            ,profits -- 
            ,isnromal -- 
            ,bourse -- 
            ,ispublic -- 
            ,exponent -- 
            ,shareamount -- 
            ,stockamount -- 
            ,persharemarketprice -- 
            ,profitmoney -- 
            ,warningline -- 
            ,persharevalue -- 
            ,liquidateline -- 
            ,totalvalue -- 
            ,duedate -- 
            ,remark -- 
            ,tdcurrency -- 
            ,stockidc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_listedstock_op(
            sccode -- 
            ,stockcode -- 
            ,stockname -- 
            ,companyname -- 
            ,isborrower -- 
            ,profits -- 
            ,isnromal -- 
            ,bourse -- 
            ,ispublic -- 
            ,exponent -- 
            ,shareamount -- 
            ,stockamount -- 
            ,persharemarketprice -- 
            ,profitmoney -- 
            ,warningline -- 
            ,persharevalue -- 
            ,liquidateline -- 
            ,totalvalue -- 
            ,duedate -- 
            ,remark -- 
            ,tdcurrency -- 
            ,stockidc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.stockcode -- 
    ,o.stockname -- 
    ,o.companyname -- 
    ,o.isborrower -- 
    ,o.profits -- 
    ,o.isnromal -- 
    ,o.bourse -- 
    ,o.ispublic -- 
    ,o.exponent -- 
    ,o.shareamount -- 
    ,o.stockamount -- 
    ,o.persharemarketprice -- 
    ,o.profitmoney -- 
    ,o.warningline -- 
    ,o.persharevalue -- 
    ,o.liquidateline -- 
    ,o.totalvalue -- 
    ,o.duedate -- 
    ,o.remark -- 
    ,o.tdcurrency -- 
    ,o.stockidc -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_listedstock_bk o
    left join ${iol_schema}.mims_si_listedstock_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_listedstock_cl d
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
-- truncate table ${iol_schema}.mims_si_listedstock;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_listedstock exchange partition p_19000101 with table ${iol_schema}.mims_si_listedstock_cl;
alter table ${iol_schema}.mims_si_listedstock exchange partition p_20991231 with table ${iol_schema}.mims_si_listedstock_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_listedstock to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_listedstock_op purge;
drop table ${iol_schema}.mims_si_listedstock_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_listedstock_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_listedstock',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
