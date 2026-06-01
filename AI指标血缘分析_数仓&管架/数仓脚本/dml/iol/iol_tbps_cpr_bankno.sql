/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_bankno
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
create table ${iol_schema}.tbps_cpr_bankno_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_bankno;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_bankno_op purge;
drop table ${iol_schema}.tbps_cpr_bankno_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_bankno_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_bankno where 0=1;

create table ${iol_schema}.tbps_cpr_bankno_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_bankno where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_bankno_cl(
            pbo_bankno -- 行号
            ,pbo_banktype -- 行别
            ,pbo_standardid -- 智慧路由标准行号id(所属行联行号)
            ,pbo_channel -- 通道分类
            ,pbo_citycode -- 城市代码
            ,pbo_provincecode -- 省及直辖市
            ,pbo_fromdate -- 生效日期
            ,pbo_thrudate -- 失效日期
            ,pbo_bankname -- 行名
            ,pbo_stt -- 状态有效：valid;失效：invalid
            ,pbo_updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_bankno_op(
            pbo_bankno -- 行号
            ,pbo_banktype -- 行别
            ,pbo_standardid -- 智慧路由标准行号id(所属行联行号)
            ,pbo_channel -- 通道分类
            ,pbo_citycode -- 城市代码
            ,pbo_provincecode -- 省及直辖市
            ,pbo_fromdate -- 生效日期
            ,pbo_thrudate -- 失效日期
            ,pbo_bankname -- 行名
            ,pbo_stt -- 状态有效：valid;失效：invalid
            ,pbo_updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pbo_bankno, o.pbo_bankno) as pbo_bankno -- 行号
    ,nvl(n.pbo_banktype, o.pbo_banktype) as pbo_banktype -- 行别
    ,nvl(n.pbo_standardid, o.pbo_standardid) as pbo_standardid -- 智慧路由标准行号id(所属行联行号)
    ,nvl(n.pbo_channel, o.pbo_channel) as pbo_channel -- 通道分类
    ,nvl(n.pbo_citycode, o.pbo_citycode) as pbo_citycode -- 城市代码
    ,nvl(n.pbo_provincecode, o.pbo_provincecode) as pbo_provincecode -- 省及直辖市
    ,nvl(n.pbo_fromdate, o.pbo_fromdate) as pbo_fromdate -- 生效日期
    ,nvl(n.pbo_thrudate, o.pbo_thrudate) as pbo_thrudate -- 失效日期
    ,nvl(n.pbo_bankname, o.pbo_bankname) as pbo_bankname -- 行名
    ,nvl(n.pbo_stt, o.pbo_stt) as pbo_stt -- 状态有效：valid;失效：invalid
    ,nvl(n.pbo_updatedate, o.pbo_updatedate) as pbo_updatedate -- 更新日期
    ,case when
            n.pbo_bankno is null
            and n.pbo_channel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pbo_bankno is null
            and n.pbo_channel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pbo_bankno is null
            and n.pbo_channel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_bankno_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_bankno where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pbo_bankno = n.pbo_bankno
            and o.pbo_channel = n.pbo_channel
where (
        o.pbo_bankno is null
        and o.pbo_channel is null
    )
    or (
        n.pbo_bankno is null
        and n.pbo_channel is null
    )
    or (
        o.pbo_banktype <> n.pbo_banktype
        or o.pbo_standardid <> n.pbo_standardid
        or o.pbo_citycode <> n.pbo_citycode
        or o.pbo_provincecode <> n.pbo_provincecode
        or o.pbo_fromdate <> n.pbo_fromdate
        or o.pbo_thrudate <> n.pbo_thrudate
        or o.pbo_bankname <> n.pbo_bankname
        or o.pbo_stt <> n.pbo_stt
        or o.pbo_updatedate <> n.pbo_updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_bankno_cl(
            pbo_bankno -- 行号
            ,pbo_banktype -- 行别
            ,pbo_standardid -- 智慧路由标准行号id(所属行联行号)
            ,pbo_channel -- 通道分类
            ,pbo_citycode -- 城市代码
            ,pbo_provincecode -- 省及直辖市
            ,pbo_fromdate -- 生效日期
            ,pbo_thrudate -- 失效日期
            ,pbo_bankname -- 行名
            ,pbo_stt -- 状态有效：valid;失效：invalid
            ,pbo_updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_bankno_op(
            pbo_bankno -- 行号
            ,pbo_banktype -- 行别
            ,pbo_standardid -- 智慧路由标准行号id(所属行联行号)
            ,pbo_channel -- 通道分类
            ,pbo_citycode -- 城市代码
            ,pbo_provincecode -- 省及直辖市
            ,pbo_fromdate -- 生效日期
            ,pbo_thrudate -- 失效日期
            ,pbo_bankname -- 行名
            ,pbo_stt -- 状态有效：valid;失效：invalid
            ,pbo_updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pbo_bankno -- 行号
    ,o.pbo_banktype -- 行别
    ,o.pbo_standardid -- 智慧路由标准行号id(所属行联行号)
    ,o.pbo_channel -- 通道分类
    ,o.pbo_citycode -- 城市代码
    ,o.pbo_provincecode -- 省及直辖市
    ,o.pbo_fromdate -- 生效日期
    ,o.pbo_thrudate -- 失效日期
    ,o.pbo_bankname -- 行名
    ,o.pbo_stt -- 状态有效：valid;失效：invalid
    ,o.pbo_updatedate -- 更新日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_bankno_bk o
    left join ${iol_schema}.tbps_cpr_bankno_op n
        on
            o.pbo_bankno = n.pbo_bankno
            and o.pbo_channel = n.pbo_channel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_bankno_cl d
        on
            o.pbo_bankno = d.pbo_bankno
            and o.pbo_channel = d.pbo_channel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_bankno;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_bankno exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_bankno_cl;
alter table ${iol_schema}.tbps_cpr_bankno exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_bankno_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_bankno to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_bankno_op purge;
drop table ${iol_schema}.tbps_cpr_bankno_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_bankno_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_bankno',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
