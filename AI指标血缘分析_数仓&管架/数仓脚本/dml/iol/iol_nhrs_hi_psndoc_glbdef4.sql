/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hi_psndoc_glbdef4
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
create table ${iol_schema}.nhrs_hi_psndoc_glbdef4_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hi_psndoc_glbdef4
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef4_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef4_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_glbdef4_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_glbdef4 where 0=1;

create table ${iol_schema}.nhrs_hi_psndoc_glbdef4_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_glbdef4 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_glbdef4_cl(
            begindate -- 开始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,enddate -- 结束日期
            ,glbdef1 -- 资格名称
            ,glbdef2 -- 取得资格途径
            ,glbdef3 -- 取得时间
            ,glbdef4 -- 批准单位
            ,glbdef5 -- 备注
            ,lastflag -- 最近记录标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_psndoc -- 人员档案主键
            ,pk_psndoc_sub -- 人员子表主键
            ,recordnum -- 记录序号
            ,ts -- 时间戳
            ,dr -- 备用DR
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_glbdef4_op(
            begindate -- 开始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,enddate -- 结束日期
            ,glbdef1 -- 资格名称
            ,glbdef2 -- 取得资格途径
            ,glbdef3 -- 取得时间
            ,glbdef4 -- 批准单位
            ,glbdef5 -- 备注
            ,lastflag -- 最近记录标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_psndoc -- 人员档案主键
            ,pk_psndoc_sub -- 人员子表主键
            ,recordnum -- 记录序号
            ,ts -- 时间戳
            ,dr -- 备用DR
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.begindate, o.begindate) as begindate -- 开始日期
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.enddate, o.enddate) as enddate -- 结束日期
    ,nvl(n.glbdef1, o.glbdef1) as glbdef1 -- 资格名称
    ,nvl(n.glbdef2, o.glbdef2) as glbdef2 -- 取得资格途径
    ,nvl(n.glbdef3, o.glbdef3) as glbdef3 -- 取得时间
    ,nvl(n.glbdef4, o.glbdef4) as glbdef4 -- 批准单位
    ,nvl(n.glbdef5, o.glbdef5) as glbdef5 -- 备注
    ,nvl(n.lastflag, o.lastflag) as lastflag -- 最近记录标志
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员档案主键
    ,nvl(n.pk_psndoc_sub, o.pk_psndoc_sub) as pk_psndoc_sub -- 人员子表主键
    ,nvl(n.recordnum, o.recordnum) as recordnum -- 记录序号
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,case when
            n.pk_psndoc_sub is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_psndoc_sub is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_psndoc_sub is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_hi_psndoc_glbdef4_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hi_psndoc_glbdef4 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
where (
        o.pk_psndoc_sub is null
    )
    or (
        n.pk_psndoc_sub is null
    )
    or (
        o.begindate <> n.begindate
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.enddate <> n.enddate
        or o.glbdef1 <> n.glbdef1
        or o.glbdef2 <> n.glbdef2
        or o.glbdef3 <> n.glbdef3
        or o.glbdef4 <> n.glbdef4
        or o.glbdef5 <> n.glbdef5
        or o.lastflag <> n.lastflag
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.pk_psndoc <> n.pk_psndoc
        or o.recordnum <> n.recordnum
        or o.ts <> n.ts
        or o.dr <> n.dr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_glbdef4_cl(
            begindate -- 开始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,enddate -- 结束日期
            ,glbdef1 -- 资格名称
            ,glbdef2 -- 取得资格途径
            ,glbdef3 -- 取得时间
            ,glbdef4 -- 批准单位
            ,glbdef5 -- 备注
            ,lastflag -- 最近记录标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_psndoc -- 人员档案主键
            ,pk_psndoc_sub -- 人员子表主键
            ,recordnum -- 记录序号
            ,ts -- 时间戳
            ,dr -- 备用DR
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_glbdef4_op(
            begindate -- 开始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,enddate -- 结束日期
            ,glbdef1 -- 资格名称
            ,glbdef2 -- 取得资格途径
            ,glbdef3 -- 取得时间
            ,glbdef4 -- 批准单位
            ,glbdef5 -- 备注
            ,lastflag -- 最近记录标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_psndoc -- 人员档案主键
            ,pk_psndoc_sub -- 人员子表主键
            ,recordnum -- 记录序号
            ,ts -- 时间戳
            ,dr -- 备用DR
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.begindate -- 开始日期
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.enddate -- 结束日期
    ,o.glbdef1 -- 资格名称
    ,o.glbdef2 -- 取得资格途径
    ,o.glbdef3 -- 取得时间
    ,o.glbdef4 -- 批准单位
    ,o.glbdef5 -- 备注
    ,o.lastflag -- 最近记录标志
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.pk_psndoc -- 人员档案主键
    ,o.pk_psndoc_sub -- 人员子表主键
    ,o.recordnum -- 记录序号
    ,o.ts -- 时间戳
    ,o.dr -- 备用DR
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.nhrs_hi_psndoc_glbdef4_bk o
    left join ${iol_schema}.nhrs_hi_psndoc_glbdef4_op n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hi_psndoc_glbdef4_cl d
        on
            o.pk_psndoc_sub = d.pk_psndoc_sub
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_hi_psndoc_glbdef4;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hi_psndoc_glbdef4') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hi_psndoc_glbdef4 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hi_psndoc_glbdef4 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hi_psndoc_glbdef4 exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hi_psndoc_glbdef4_cl;
alter table ${iol_schema}.nhrs_hi_psndoc_glbdef4 exchange partition p_20991231 with table ${iol_schema}.nhrs_hi_psndoc_glbdef4_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef4 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef4_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef4_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef4_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hi_psndoc_glbdef4',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
