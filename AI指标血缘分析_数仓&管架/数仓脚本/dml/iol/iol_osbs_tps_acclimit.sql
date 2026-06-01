/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_acclimit
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
create table ${iol_schema}.osbs_tps_acclimit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_acclimit;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_acclimit_op purge;
drop table ${iol_schema}.osbs_tps_acclimit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_acclimit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_acclimit where 0=1;

create table ${iol_schema}.osbs_tps_acclimit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_acclimit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_acclimit_cl(
            tal_accno -- 账号
            ,tal_ecifno -- 客户号
            ,tal_userno -- 用户顺序号
            ,tal_limitattribute -- 限额属性名
            ,tal_attributevalue -- 属性值
            ,tal_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_acclimit_op(
            tal_accno -- 账号
            ,tal_ecifno -- 客户号
            ,tal_userno -- 用户顺序号
            ,tal_limitattribute -- 限额属性名
            ,tal_attributevalue -- 属性值
            ,tal_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tal_accno, o.tal_accno) as tal_accno -- 账号
    ,nvl(n.tal_ecifno, o.tal_ecifno) as tal_ecifno -- 客户号
    ,nvl(n.tal_userno, o.tal_userno) as tal_userno -- 用户顺序号
    ,nvl(n.tal_limitattribute, o.tal_limitattribute) as tal_limitattribute -- 限额属性名
    ,nvl(n.tal_attributevalue, o.tal_attributevalue) as tal_attributevalue -- 属性值
    ,nvl(n.tal_channel, o.tal_channel) as tal_channel -- 渠道
    ,case when
            n.tal_accno is null
            and n.tal_ecifno is null
            and n.tal_limitattribute is null
            and n.tal_channel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tal_accno is null
            and n.tal_ecifno is null
            and n.tal_limitattribute is null
            and n.tal_channel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tal_accno is null
            and n.tal_ecifno is null
            and n.tal_limitattribute is null
            and n.tal_channel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_acclimit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_acclimit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tal_accno = n.tal_accno
            and o.tal_ecifno = n.tal_ecifno
            and o.tal_limitattribute = n.tal_limitattribute
            and o.tal_channel = n.tal_channel
where (
        o.tal_accno is null
        and o.tal_ecifno is null
        and o.tal_limitattribute is null
        and o.tal_channel is null
    )
    or (
        n.tal_accno is null
        and n.tal_ecifno is null
        and n.tal_limitattribute is null
        and n.tal_channel is null
    )
    or (
        o.tal_userno <> n.tal_userno
        or o.tal_attributevalue <> n.tal_attributevalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_acclimit_cl(
            tal_accno -- 账号
            ,tal_ecifno -- 客户号
            ,tal_userno -- 用户顺序号
            ,tal_limitattribute -- 限额属性名
            ,tal_attributevalue -- 属性值
            ,tal_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_acclimit_op(
            tal_accno -- 账号
            ,tal_ecifno -- 客户号
            ,tal_userno -- 用户顺序号
            ,tal_limitattribute -- 限额属性名
            ,tal_attributevalue -- 属性值
            ,tal_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tal_accno -- 账号
    ,o.tal_ecifno -- 客户号
    ,o.tal_userno -- 用户顺序号
    ,o.tal_limitattribute -- 限额属性名
    ,o.tal_attributevalue -- 属性值
    ,o.tal_channel -- 渠道
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_tps_acclimit_bk o
    left join ${iol_schema}.osbs_tps_acclimit_op n
        on
            o.tal_accno = n.tal_accno
            and o.tal_ecifno = n.tal_ecifno
            and o.tal_limitattribute = n.tal_limitattribute
            and o.tal_channel = n.tal_channel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_acclimit_cl d
        on
            o.tal_accno = d.tal_accno
            and o.tal_ecifno = d.tal_ecifno
            and o.tal_limitattribute = d.tal_limitattribute
            and o.tal_channel = d.tal_channel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_tps_acclimit;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_tps_acclimit exchange partition p_19000101 with table ${iol_schema}.osbs_tps_acclimit_cl;
alter table ${iol_schema}.osbs_tps_acclimit exchange partition p_20991231 with table ${iol_schema}.osbs_tps_acclimit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_acclimit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_acclimit_op purge;
drop table ${iol_schema}.osbs_tps_acclimit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_acclimit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_acclimit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
