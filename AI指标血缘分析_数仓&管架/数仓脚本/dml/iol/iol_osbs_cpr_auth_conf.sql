/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_cpr_auth_conf
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
create table ${iol_schema}.osbs_cpr_auth_conf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_cpr_auth_conf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_cpr_auth_conf_op purge;
drop table ${iol_schema}.osbs_cpr_auth_conf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_cpr_auth_conf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_cpr_auth_conf where 0=1;

create table ${iol_schema}.osbs_cpr_auth_conf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_cpr_auth_conf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_cpr_auth_conf_cl(
            cac_seqno -- 序号
            ,cac_ecifno -- 全行统一客户号
            ,cac_currency -- 币种(默认CNY)
            ,cac_accno -- 账号
            ,cac_groupid -- 功能分组编号
            ,cac_minamount -- 起点金额
            ,cac_maxamount -- 结束金额
            ,cac_channel -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_cpr_auth_conf_op(
            cac_seqno -- 序号
            ,cac_ecifno -- 全行统一客户号
            ,cac_currency -- 币种(默认CNY)
            ,cac_accno -- 账号
            ,cac_groupid -- 功能分组编号
            ,cac_minamount -- 起点金额
            ,cac_maxamount -- 结束金额
            ,cac_channel -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cac_seqno, o.cac_seqno) as cac_seqno -- 序号
    ,nvl(n.cac_ecifno, o.cac_ecifno) as cac_ecifno -- 全行统一客户号
    ,nvl(n.cac_currency, o.cac_currency) as cac_currency -- 币种(默认CNY)
    ,nvl(n.cac_accno, o.cac_accno) as cac_accno -- 账号
    ,nvl(n.cac_groupid, o.cac_groupid) as cac_groupid -- 功能分组编号
    ,nvl(n.cac_minamount, o.cac_minamount) as cac_minamount -- 起点金额
    ,nvl(n.cac_maxamount, o.cac_maxamount) as cac_maxamount -- 结束金额
    ,nvl(n.cac_channel, o.cac_channel) as cac_channel -- 
    ,case when
            n.cac_seqno is null
            and n.cac_ecifno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cac_seqno is null
            and n.cac_ecifno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cac_seqno is null
            and n.cac_ecifno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_cpr_auth_conf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_cpr_auth_conf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cac_seqno = n.cac_seqno
            and o.cac_ecifno = n.cac_ecifno
where (
        o.cac_seqno is null
        and o.cac_ecifno is null
    )
    or (
        n.cac_seqno is null
        and n.cac_ecifno is null
    )
    or (
        o.cac_currency <> n.cac_currency
        or o.cac_accno <> n.cac_accno
        or o.cac_groupid <> n.cac_groupid
        or o.cac_minamount <> n.cac_minamount
        or o.cac_maxamount <> n.cac_maxamount
        or o.cac_channel <> n.cac_channel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_cpr_auth_conf_cl(
            cac_seqno -- 序号
            ,cac_ecifno -- 全行统一客户号
            ,cac_currency -- 币种(默认CNY)
            ,cac_accno -- 账号
            ,cac_groupid -- 功能分组编号
            ,cac_minamount -- 起点金额
            ,cac_maxamount -- 结束金额
            ,cac_channel -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_cpr_auth_conf_op(
            cac_seqno -- 序号
            ,cac_ecifno -- 全行统一客户号
            ,cac_currency -- 币种(默认CNY)
            ,cac_accno -- 账号
            ,cac_groupid -- 功能分组编号
            ,cac_minamount -- 起点金额
            ,cac_maxamount -- 结束金额
            ,cac_channel -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cac_seqno -- 序号
    ,o.cac_ecifno -- 全行统一客户号
    ,o.cac_currency -- 币种(默认CNY)
    ,o.cac_accno -- 账号
    ,o.cac_groupid -- 功能分组编号
    ,o.cac_minamount -- 起点金额
    ,o.cac_maxamount -- 结束金额
    ,o.cac_channel -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_cpr_auth_conf_bk o
    left join ${iol_schema}.osbs_cpr_auth_conf_op n
        on
            o.cac_seqno = n.cac_seqno
            and o.cac_ecifno = n.cac_ecifno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_cpr_auth_conf_cl d
        on
            o.cac_seqno = d.cac_seqno
            and o.cac_ecifno = d.cac_ecifno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_cpr_auth_conf;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_cpr_auth_conf exchange partition p_19000101 with table ${iol_schema}.osbs_cpr_auth_conf_cl;
alter table ${iol_schema}.osbs_cpr_auth_conf exchange partition p_20991231 with table ${iol_schema}.osbs_cpr_auth_conf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_cpr_auth_conf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_cpr_auth_conf_op purge;
drop table ${iol_schema}.osbs_cpr_auth_conf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_cpr_auth_conf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_cpr_auth_conf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
