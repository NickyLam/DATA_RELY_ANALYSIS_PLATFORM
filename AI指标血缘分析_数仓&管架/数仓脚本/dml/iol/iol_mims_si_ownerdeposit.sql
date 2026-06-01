/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_ownerdeposit
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
create table ${iol_schema}.mims_si_ownerdeposit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_ownerdeposit;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_ownerdeposit_op purge;
drop table ${iol_schema}.mims_si_ownerdeposit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_ownerdeposit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_ownerdeposit where 0=1;

create table ${iol_schema}.mims_si_ownerdeposit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_ownerdeposit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_ownerdeposit_cl(
            sccode -- 
            ,certificatecode -- 
            ,stoppaymentmoney -- 
            ,account -- 
            ,startdate -- 
            ,enddate -- 
            ,duedate -- 
            ,rate -- 
            ,money -- 
            ,remark -- 
            ,childaccount -- 
            ,stoppayaccount -- 
            ,tdcurrency -- 
            ,deposittype -- 存单类型
            ,buyaccount -- 认购账号
            ,depositaccount -- 存款账号
            ,valuedate -- 起息日
            ,amt -- 金额
            ,prodcode -- 产品编号
            ,prodname -- 产品名称
            ,payinterest -- 付息方式
            ,liabaccount -- 负债账号
            ,ptyid -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_ownerdeposit_op(
            sccode -- 
            ,certificatecode -- 
            ,stoppaymentmoney -- 
            ,account -- 
            ,startdate -- 
            ,enddate -- 
            ,duedate -- 
            ,rate -- 
            ,money -- 
            ,remark -- 
            ,childaccount -- 
            ,stoppayaccount -- 
            ,tdcurrency -- 
            ,deposittype -- 存单类型
            ,buyaccount -- 认购账号
            ,depositaccount -- 存款账号
            ,valuedate -- 起息日
            ,amt -- 金额
            ,prodcode -- 产品编号
            ,prodname -- 产品名称
            ,payinterest -- 付息方式
            ,liabaccount -- 负债账号
            ,ptyid -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.certificatecode, o.certificatecode) as certificatecode -- 
    ,nvl(n.stoppaymentmoney, o.stoppaymentmoney) as stoppaymentmoney -- 
    ,nvl(n.account, o.account) as account -- 
    ,nvl(n.startdate, o.startdate) as startdate -- 
    ,nvl(n.enddate, o.enddate) as enddate -- 
    ,nvl(n.duedate, o.duedate) as duedate -- 
    ,nvl(n.rate, o.rate) as rate -- 
    ,nvl(n.money, o.money) as money -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.childaccount, o.childaccount) as childaccount -- 
    ,nvl(n.stoppayaccount, o.stoppayaccount) as stoppayaccount -- 
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 
    ,nvl(n.deposittype, o.deposittype) as deposittype -- 存单类型
    ,nvl(n.buyaccount, o.buyaccount) as buyaccount -- 认购账号
    ,nvl(n.depositaccount, o.depositaccount) as depositaccount -- 存款账号
    ,nvl(n.valuedate, o.valuedate) as valuedate -- 起息日
    ,nvl(n.amt, o.amt) as amt -- 金额
    ,nvl(n.prodcode, o.prodcode) as prodcode -- 产品编号
    ,nvl(n.prodname, o.prodname) as prodname -- 产品名称
    ,nvl(n.payinterest, o.payinterest) as payinterest -- 付息方式
    ,nvl(n.liabaccount, o.liabaccount) as liabaccount -- 负债账号
    ,nvl(n.ptyid, o.ptyid) as ptyid -- 客户号
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
from (select * from ${iol_schema}.mims_si_ownerdeposit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_ownerdeposit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.certificatecode <> n.certificatecode
        or o.stoppaymentmoney <> n.stoppaymentmoney
        or o.account <> n.account
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.duedate <> n.duedate
        or o.rate <> n.rate
        or o.money <> n.money
        or o.remark <> n.remark
        or o.childaccount <> n.childaccount
        or o.stoppayaccount <> n.stoppayaccount
        or o.tdcurrency <> n.tdcurrency
        or o.deposittype <> n.deposittype
        or o.buyaccount <> n.buyaccount
        or o.depositaccount <> n.depositaccount
        or o.valuedate <> n.valuedate
        or o.amt <> n.amt
        or o.prodcode <> n.prodcode
        or o.prodname <> n.prodname
        or o.payinterest <> n.payinterest
        or o.liabaccount <> n.liabaccount
        or o.ptyid <> n.ptyid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_ownerdeposit_cl(
            sccode -- 
            ,certificatecode -- 
            ,stoppaymentmoney -- 
            ,account -- 
            ,startdate -- 
            ,enddate -- 
            ,duedate -- 
            ,rate -- 
            ,money -- 
            ,remark -- 
            ,childaccount -- 
            ,stoppayaccount -- 
            ,tdcurrency -- 
            ,deposittype -- 存单类型
            ,buyaccount -- 认购账号
            ,depositaccount -- 存款账号
            ,valuedate -- 起息日
            ,amt -- 金额
            ,prodcode -- 产品编号
            ,prodname -- 产品名称
            ,payinterest -- 付息方式
            ,liabaccount -- 负债账号
            ,ptyid -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_ownerdeposit_op(
            sccode -- 
            ,certificatecode -- 
            ,stoppaymentmoney -- 
            ,account -- 
            ,startdate -- 
            ,enddate -- 
            ,duedate -- 
            ,rate -- 
            ,money -- 
            ,remark -- 
            ,childaccount -- 
            ,stoppayaccount -- 
            ,tdcurrency -- 
            ,deposittype -- 存单类型
            ,buyaccount -- 认购账号
            ,depositaccount -- 存款账号
            ,valuedate -- 起息日
            ,amt -- 金额
            ,prodcode -- 产品编号
            ,prodname -- 产品名称
            ,payinterest -- 付息方式
            ,liabaccount -- 负债账号
            ,ptyid -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.certificatecode -- 
    ,o.stoppaymentmoney -- 
    ,o.account -- 
    ,o.startdate -- 
    ,o.enddate -- 
    ,o.duedate -- 
    ,o.rate -- 
    ,o.money -- 
    ,o.remark -- 
    ,o.childaccount -- 
    ,o.stoppayaccount -- 
    ,o.tdcurrency -- 
    ,o.deposittype -- 存单类型
    ,o.buyaccount -- 认购账号
    ,o.depositaccount -- 存款账号
    ,o.valuedate -- 起息日
    ,o.amt -- 金额
    ,o.prodcode -- 产品编号
    ,o.prodname -- 产品名称
    ,o.payinterest -- 付息方式
    ,o.liabaccount -- 负债账号
    ,o.ptyid -- 客户号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_ownerdeposit_bk o
    left join ${iol_schema}.mims_si_ownerdeposit_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_ownerdeposit_cl d
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
-- truncate table ${iol_schema}.mims_si_ownerdeposit;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_ownerdeposit exchange partition p_19000101 with table ${iol_schema}.mims_si_ownerdeposit_cl;
alter table ${iol_schema}.mims_si_ownerdeposit exchange partition p_20991231 with table ${iol_schema}.mims_si_ownerdeposit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_ownerdeposit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_ownerdeposit_op purge;
drop table ${iol_schema}.mims_si_ownerdeposit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_ownerdeposit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_ownerdeposit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
