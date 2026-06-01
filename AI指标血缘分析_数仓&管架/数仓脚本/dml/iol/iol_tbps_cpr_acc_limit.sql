/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_acc_limit
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
create table ${iol_schema}.tbps_cpr_acc_limit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_acc_limit;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_acc_limit_op purge;
drop table ${iol_schema}.tbps_cpr_acc_limit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_acc_limit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_acc_limit where 0=1;

create table ${iol_schema}.tbps_cpr_acc_limit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_acc_limit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_acc_limit_cl(
            cal_ecifno -- 客户号
            ,cal_accno -- 账号
            ,cal_userno -- 用户顺序号
            ,cal_argname -- 属性名
            ,cal_argvalue -- 属性值
            ,cal_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_acc_limit_op(
            cal_ecifno -- 客户号
            ,cal_accno -- 账号
            ,cal_userno -- 用户顺序号
            ,cal_argname -- 属性名
            ,cal_argvalue -- 属性值
            ,cal_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cal_ecifno, o.cal_ecifno) as cal_ecifno -- 客户号
    ,nvl(n.cal_accno, o.cal_accno) as cal_accno -- 账号
    ,nvl(n.cal_userno, o.cal_userno) as cal_userno -- 用户顺序号
    ,nvl(n.cal_argname, o.cal_argname) as cal_argname -- 属性名
    ,nvl(n.cal_argvalue, o.cal_argvalue) as cal_argvalue -- 属性值
    ,nvl(n.cal_channel, o.cal_channel) as cal_channel -- 渠道
    ,case when
            n.cal_accno is null
            and n.cal_argname is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cal_accno is null
            and n.cal_argname is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cal_accno is null
            and n.cal_argname is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_acc_limit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_acc_limit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cal_accno = n.cal_accno
            and o.cal_argname = n.cal_argname
where (
        o.cal_accno is null
        and o.cal_argname is null
    )
    or (
        n.cal_accno is null
        and n.cal_argname is null
    )
    or (
        o.cal_ecifno <> n.cal_ecifno
        or o.cal_userno <> n.cal_userno
        or o.cal_argvalue <> n.cal_argvalue
        or o.cal_channel <> n.cal_channel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_acc_limit_cl(
            cal_ecifno -- 客户号
            ,cal_accno -- 账号
            ,cal_userno -- 用户顺序号
            ,cal_argname -- 属性名
            ,cal_argvalue -- 属性值
            ,cal_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_acc_limit_op(
            cal_ecifno -- 客户号
            ,cal_accno -- 账号
            ,cal_userno -- 用户顺序号
            ,cal_argname -- 属性名
            ,cal_argvalue -- 属性值
            ,cal_channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cal_ecifno -- 客户号
    ,o.cal_accno -- 账号
    ,o.cal_userno -- 用户顺序号
    ,o.cal_argname -- 属性名
    ,o.cal_argvalue -- 属性值
    ,o.cal_channel -- 渠道
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_acc_limit_bk o
    left join ${iol_schema}.tbps_cpr_acc_limit_op n
        on
            o.cal_accno = n.cal_accno
            and o.cal_argname = n.cal_argname
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_acc_limit_cl d
        on
            o.cal_accno = d.cal_accno
            and o.cal_argname = d.cal_argname
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_acc_limit;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_acc_limit exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_acc_limit_cl;
alter table ${iol_schema}.tbps_cpr_acc_limit exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_acc_limit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_acc_limit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_acc_limit_op purge;
drop table ${iol_schema}.tbps_cpr_acc_limit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_acc_limit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_acc_limit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
