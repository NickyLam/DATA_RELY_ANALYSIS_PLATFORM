/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_ifm0001t
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
create table ${iol_schema}.mims_yp_ifm0001t_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_yp_ifm0001t;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_ifm0001t_op purge;
drop table ${iol_schema}.mims_yp_ifm0001t_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_ifm0001t_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_ifm0001t where 0=1;

create table ${iol_schema}.mims_yp_ifm0001t_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_ifm0001t where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_ifm0001t_cl(
            sccode -- 
            ,bankacc -- 
            ,serialno -- 
            ,account -- 
            ,clientname -- 
            ,tacode -- 
            ,prdcode -- 
            ,prdname -- 
            ,frozencause -- 
            ,lawno -- 
            ,orgname -- 
            ,enddate -- 
            ,status -- 
            ,taname -- 
            ,statusname -- 
            ,clientno -- 
            ,flag -- 
            ,trandt -- 核心交易日期
            ,transq -- 核心交易流水
            ,acctno -- 保证金账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_ifm0001t_op(
            sccode -- 
            ,bankacc -- 
            ,serialno -- 
            ,account -- 
            ,clientname -- 
            ,tacode -- 
            ,prdcode -- 
            ,prdname -- 
            ,frozencause -- 
            ,lawno -- 
            ,orgname -- 
            ,enddate -- 
            ,status -- 
            ,taname -- 
            ,statusname -- 
            ,clientno -- 
            ,flag -- 
            ,trandt -- 核心交易日期
            ,transq -- 核心交易流水
            ,acctno -- 保证金账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.bankacc, o.bankacc) as bankacc -- 
    ,nvl(n.serialno, o.serialno) as serialno -- 
    ,nvl(n.account, o.account) as account -- 
    ,nvl(n.clientname, o.clientname) as clientname -- 
    ,nvl(n.tacode, o.tacode) as tacode -- 
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 
    ,nvl(n.prdname, o.prdname) as prdname -- 
    ,nvl(n.frozencause, o.frozencause) as frozencause -- 
    ,nvl(n.lawno, o.lawno) as lawno -- 
    ,nvl(n.orgname, o.orgname) as orgname -- 
    ,nvl(n.enddate, o.enddate) as enddate -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.taname, o.taname) as taname -- 
    ,nvl(n.statusname, o.statusname) as statusname -- 
    ,nvl(n.clientno, o.clientno) as clientno -- 
    ,nvl(n.flag, o.flag) as flag -- 
    ,nvl(n.trandt, o.trandt) as trandt -- 核心交易日期
    ,nvl(n.transq, o.transq) as transq -- 核心交易流水
    ,nvl(n.acctno, o.acctno) as acctno -- 保证金账号
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
from (select * from ${iol_schema}.mims_yp_ifm0001t_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_yp_ifm0001t where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.bankacc <> n.bankacc
        or o.serialno <> n.serialno
        or o.account <> n.account
        or o.clientname <> n.clientname
        or o.tacode <> n.tacode
        or o.prdcode <> n.prdcode
        or o.prdname <> n.prdname
        or o.frozencause <> n.frozencause
        or o.lawno <> n.lawno
        or o.orgname <> n.orgname
        or o.enddate <> n.enddate
        or o.status <> n.status
        or o.taname <> n.taname
        or o.statusname <> n.statusname
        or o.clientno <> n.clientno
        or o.flag <> n.flag
        or o.trandt <> n.trandt
        or o.transq <> n.transq
        or o.acctno <> n.acctno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_ifm0001t_cl(
            sccode -- 
            ,bankacc -- 
            ,serialno -- 
            ,account -- 
            ,clientname -- 
            ,tacode -- 
            ,prdcode -- 
            ,prdname -- 
            ,frozencause -- 
            ,lawno -- 
            ,orgname -- 
            ,enddate -- 
            ,status -- 
            ,taname -- 
            ,statusname -- 
            ,clientno -- 
            ,flag -- 
            ,trandt -- 核心交易日期
            ,transq -- 核心交易流水
            ,acctno -- 保证金账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_ifm0001t_op(
            sccode -- 
            ,bankacc -- 
            ,serialno -- 
            ,account -- 
            ,clientname -- 
            ,tacode -- 
            ,prdcode -- 
            ,prdname -- 
            ,frozencause -- 
            ,lawno -- 
            ,orgname -- 
            ,enddate -- 
            ,status -- 
            ,taname -- 
            ,statusname -- 
            ,clientno -- 
            ,flag -- 
            ,trandt -- 核心交易日期
            ,transq -- 核心交易流水
            ,acctno -- 保证金账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.bankacc -- 
    ,o.serialno -- 
    ,o.account -- 
    ,o.clientname -- 
    ,o.tacode -- 
    ,o.prdcode -- 
    ,o.prdname -- 
    ,o.frozencause -- 
    ,o.lawno -- 
    ,o.orgname -- 
    ,o.enddate -- 
    ,o.status -- 
    ,o.taname -- 
    ,o.statusname -- 
    ,o.clientno -- 
    ,o.flag -- 
    ,o.trandt -- 核心交易日期
    ,o.transq -- 核心交易流水
    ,o.acctno -- 保证金账号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_yp_ifm0001t_bk o
    left join ${iol_schema}.mims_yp_ifm0001t_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_yp_ifm0001t_cl d
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
-- truncate table ${iol_schema}.mims_yp_ifm0001t;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_yp_ifm0001t exchange partition p_19000101 with table ${iol_schema}.mims_yp_ifm0001t_cl;
alter table ${iol_schema}.mims_yp_ifm0001t exchange partition p_20991231 with table ${iol_schema}.mims_yp_ifm0001t_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_ifm0001t to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_ifm0001t_op purge;
drop table ${iol_schema}.mims_yp_ifm0001t_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_yp_ifm0001t_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_ifm0001t',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
