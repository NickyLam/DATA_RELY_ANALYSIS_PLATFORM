/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fea
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
create table ${iol_schema}.isbs_fea_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fea;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fea_op purge;
drop table ${iol_schema}.isbs_fea_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fea_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fea where 0=1;

create table ${iol_schema}.isbs_fea_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fea where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fea_cl(
            currency_code -- 
            ,ver -- 
            ,actiondesc -- 
            ,en_code -- 
            ,business_date -- 
            ,accountno -- 
            ,limit_type -- 
            ,account_cata -- 
            ,actiontype -- 
            ,file_number -- 
            ,amtype -- 
            ,account_limit -- 
            ,business_date2 -- 
            ,fea_type -- 
            ,remark -- 
            ,account_type -- 
            ,branch_code -- 
            ,en_name -- 
            ,inr -- 
            ,accountstat -- 
            ,branch_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fea_op(
            currency_code -- 
            ,ver -- 
            ,actiondesc -- 
            ,en_code -- 
            ,business_date -- 
            ,accountno -- 
            ,limit_type -- 
            ,account_cata -- 
            ,actiontype -- 
            ,file_number -- 
            ,amtype -- 
            ,account_limit -- 
            ,business_date2 -- 
            ,fea_type -- 
            ,remark -- 
            ,account_type -- 
            ,branch_code -- 
            ,en_name -- 
            ,inr -- 
            ,accountstat -- 
            ,branch_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.currency_code, o.currency_code) as currency_code -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.actiondesc, o.actiondesc) as actiondesc -- 
    ,nvl(n.en_code, o.en_code) as en_code -- 
    ,nvl(n.business_date, o.business_date) as business_date -- 
    ,nvl(n.accountno, o.accountno) as accountno -- 
    ,nvl(n.limit_type, o.limit_type) as limit_type -- 
    ,nvl(n.account_cata, o.account_cata) as account_cata -- 
    ,nvl(n.actiontype, o.actiontype) as actiontype -- 
    ,nvl(n.file_number, o.file_number) as file_number -- 
    ,nvl(n.amtype, o.amtype) as amtype -- 
    ,nvl(n.account_limit, o.account_limit) as account_limit -- 
    ,nvl(n.business_date2, o.business_date2) as business_date2 -- 
    ,nvl(n.fea_type, o.fea_type) as fea_type -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.account_type, o.account_type) as account_type -- 
    ,nvl(n.branch_code, o.branch_code) as branch_code -- 
    ,nvl(n.en_name, o.en_name) as en_name -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.accountstat, o.accountstat) as accountstat -- 
    ,nvl(n.branch_name, o.branch_name) as branch_name -- 
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
from (select * from ${iol_schema}.isbs_fea_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fea where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.currency_code <> n.currency_code
        or o.ver <> n.ver
        or o.actiondesc <> n.actiondesc
        or o.en_code <> n.en_code
        or o.business_date <> n.business_date
        or o.accountno <> n.accountno
        or o.limit_type <> n.limit_type
        or o.account_cata <> n.account_cata
        or o.actiontype <> n.actiontype
        or o.file_number <> n.file_number
        or o.amtype <> n.amtype
        or o.account_limit <> n.account_limit
        or o.business_date2 <> n.business_date2
        or o.fea_type <> n.fea_type
        or o.remark <> n.remark
        or o.account_type <> n.account_type
        or o.branch_code <> n.branch_code
        or o.en_name <> n.en_name
        or o.accountstat <> n.accountstat
        or o.branch_name <> n.branch_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fea_cl(
            currency_code -- 
            ,ver -- 
            ,actiondesc -- 
            ,en_code -- 
            ,business_date -- 
            ,accountno -- 
            ,limit_type -- 
            ,account_cata -- 
            ,actiontype -- 
            ,file_number -- 
            ,amtype -- 
            ,account_limit -- 
            ,business_date2 -- 
            ,fea_type -- 
            ,remark -- 
            ,account_type -- 
            ,branch_code -- 
            ,en_name -- 
            ,inr -- 
            ,accountstat -- 
            ,branch_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fea_op(
            currency_code -- 
            ,ver -- 
            ,actiondesc -- 
            ,en_code -- 
            ,business_date -- 
            ,accountno -- 
            ,limit_type -- 
            ,account_cata -- 
            ,actiontype -- 
            ,file_number -- 
            ,amtype -- 
            ,account_limit -- 
            ,business_date2 -- 
            ,fea_type -- 
            ,remark -- 
            ,account_type -- 
            ,branch_code -- 
            ,en_name -- 
            ,inr -- 
            ,accountstat -- 
            ,branch_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.currency_code -- 
    ,o.ver -- 
    ,o.actiondesc -- 
    ,o.en_code -- 
    ,o.business_date -- 
    ,o.accountno -- 
    ,o.limit_type -- 
    ,o.account_cata -- 
    ,o.actiontype -- 
    ,o.file_number -- 
    ,o.amtype -- 
    ,o.account_limit -- 
    ,o.business_date2 -- 
    ,o.fea_type -- 
    ,o.remark -- 
    ,o.account_type -- 
    ,o.branch_code -- 
    ,o.en_name -- 
    ,o.inr -- 
    ,o.accountstat -- 
    ,o.branch_name -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_fea_bk o
    left join ${iol_schema}.isbs_fea_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fea_cl d
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
-- truncate table ${iol_schema}.isbs_fea;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_fea exchange partition p_19000101 with table ${iol_schema}.isbs_fea_cl;
alter table ${iol_schema}.isbs_fea exchange partition p_20991231 with table ${iol_schema}.isbs_fea_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fea to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fea_op purge;
drop table ${iol_schema}.isbs_fea_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fea_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fea',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
