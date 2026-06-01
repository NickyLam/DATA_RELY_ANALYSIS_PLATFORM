/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hi_psndoc_glbdef5
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
create table ${iol_schema}.nhrs_hi_psndoc_glbdef5_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hi_psndoc_glbdef5
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef5_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef5_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_glbdef5_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_glbdef5 where 0=1;

create table ${iol_schema}.nhrs_hi_psndoc_glbdef5_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_glbdef5 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_glbdef5_cl(
            pk_psndoc_sub -- 人员子表主键
            ,pk_psndoc -- 人员档案主键
            ,begindate -- 开始日期
            ,enddate -- 结束日期
            ,recordnum -- 记录序号
            ,lastflag -- 最近记录标志
            ,creator -- 创建人
            ,creationtime -- 创建时间
            ,modifier -- 修改人
            ,modifiedtime -- 修改时间
            ,glbdef1 -- 工作单位
            ,glbdef2 -- 部门
            ,glbdef3 -- 岗位
            ,glbdef4 -- 证明人
            ,glbdef11 -- 职务
            ,glbdef5 -- 工作城市
            ,glbdef6 -- 离职原因
            ,glbdef7 -- 证明人电话
            ,glbdef9 -- 备注
            ,glbdef10 -- 是否进行背景调查
            ,ts -- 时间戳
            ,dr -- 备用DR
            ,glbdef8 -- 备用GLBDEF8
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_glbdef5_op(
            pk_psndoc_sub -- 人员子表主键
            ,pk_psndoc -- 人员档案主键
            ,begindate -- 开始日期
            ,enddate -- 结束日期
            ,recordnum -- 记录序号
            ,lastflag -- 最近记录标志
            ,creator -- 创建人
            ,creationtime -- 创建时间
            ,modifier -- 修改人
            ,modifiedtime -- 修改时间
            ,glbdef1 -- 工作单位
            ,glbdef2 -- 部门
            ,glbdef3 -- 岗位
            ,glbdef4 -- 证明人
            ,glbdef11 -- 职务
            ,glbdef5 -- 工作城市
            ,glbdef6 -- 离职原因
            ,glbdef7 -- 证明人电话
            ,glbdef9 -- 备注
            ,glbdef10 -- 是否进行背景调查
            ,ts -- 时间戳
            ,dr -- 备用DR
            ,glbdef8 -- 备用GLBDEF8
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_psndoc_sub, o.pk_psndoc_sub) as pk_psndoc_sub -- 人员子表主键
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员档案主键
    ,nvl(n.begindate, o.begindate) as begindate -- 开始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 结束日期
    ,nvl(n.recordnum, o.recordnum) as recordnum -- 记录序号
    ,nvl(n.lastflag, o.lastflag) as lastflag -- 最近记录标志
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.glbdef1, o.glbdef1) as glbdef1 -- 工作单位
    ,nvl(n.glbdef2, o.glbdef2) as glbdef2 -- 部门
    ,nvl(n.glbdef3, o.glbdef3) as glbdef3 -- 岗位
    ,nvl(n.glbdef4, o.glbdef4) as glbdef4 -- 证明人
    ,nvl(n.glbdef11, o.glbdef11) as glbdef11 -- 职务
    ,nvl(n.glbdef5, o.glbdef5) as glbdef5 -- 工作城市
    ,nvl(n.glbdef6, o.glbdef6) as glbdef6 -- 离职原因
    ,nvl(n.glbdef7, o.glbdef7) as glbdef7 -- 证明人电话
    ,nvl(n.glbdef9, o.glbdef9) as glbdef9 -- 备注
    ,nvl(n.glbdef10, o.glbdef10) as glbdef10 -- 是否进行背景调查
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.glbdef8, o.glbdef8) as glbdef8 -- 备用GLBDEF8
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
from (select * from ${iol_schema}.nhrs_hi_psndoc_glbdef5_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hi_psndoc_glbdef5 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
where (
        o.pk_psndoc_sub is null
    )
    or (
        n.pk_psndoc_sub is null
    )
    or (
        o.pk_psndoc <> n.pk_psndoc
        or o.begindate <> n.begindate
        or o.enddate <> n.enddate
        or o.recordnum <> n.recordnum
        or o.lastflag <> n.lastflag
        or o.creator <> n.creator
        or o.creationtime <> n.creationtime
        or o.modifier <> n.modifier
        or o.modifiedtime <> n.modifiedtime
        or o.glbdef1 <> n.glbdef1
        or o.glbdef2 <> n.glbdef2
        or o.glbdef3 <> n.glbdef3
        or o.glbdef4 <> n.glbdef4
        or o.glbdef11 <> n.glbdef11
        or o.glbdef5 <> n.glbdef5
        or o.glbdef6 <> n.glbdef6
        or o.glbdef7 <> n.glbdef7
        or o.glbdef9 <> n.glbdef9
        or o.glbdef10 <> n.glbdef10
        or o.ts <> n.ts
        or o.dr <> n.dr
        or o.glbdef8 <> n.glbdef8
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_glbdef5_cl(
            pk_psndoc_sub -- 人员子表主键
            ,pk_psndoc -- 人员档案主键
            ,begindate -- 开始日期
            ,enddate -- 结束日期
            ,recordnum -- 记录序号
            ,lastflag -- 最近记录标志
            ,creator -- 创建人
            ,creationtime -- 创建时间
            ,modifier -- 修改人
            ,modifiedtime -- 修改时间
            ,glbdef1 -- 工作单位
            ,glbdef2 -- 部门
            ,glbdef3 -- 岗位
            ,glbdef4 -- 证明人
            ,glbdef11 -- 职务
            ,glbdef5 -- 工作城市
            ,glbdef6 -- 离职原因
            ,glbdef7 -- 证明人电话
            ,glbdef9 -- 备注
            ,glbdef10 -- 是否进行背景调查
            ,ts -- 时间戳
            ,dr -- 备用DR
            ,glbdef8 -- 备用GLBDEF8
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_glbdef5_op(
            pk_psndoc_sub -- 人员子表主键
            ,pk_psndoc -- 人员档案主键
            ,begindate -- 开始日期
            ,enddate -- 结束日期
            ,recordnum -- 记录序号
            ,lastflag -- 最近记录标志
            ,creator -- 创建人
            ,creationtime -- 创建时间
            ,modifier -- 修改人
            ,modifiedtime -- 修改时间
            ,glbdef1 -- 工作单位
            ,glbdef2 -- 部门
            ,glbdef3 -- 岗位
            ,glbdef4 -- 证明人
            ,glbdef11 -- 职务
            ,glbdef5 -- 工作城市
            ,glbdef6 -- 离职原因
            ,glbdef7 -- 证明人电话
            ,glbdef9 -- 备注
            ,glbdef10 -- 是否进行背景调查
            ,ts -- 时间戳
            ,dr -- 备用DR
            ,glbdef8 -- 备用GLBDEF8
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_psndoc_sub -- 人员子表主键
    ,o.pk_psndoc -- 人员档案主键
    ,o.begindate -- 开始日期
    ,o.enddate -- 结束日期
    ,o.recordnum -- 记录序号
    ,o.lastflag -- 最近记录标志
    ,o.creator -- 创建人
    ,o.creationtime -- 创建时间
    ,o.modifier -- 修改人
    ,o.modifiedtime -- 修改时间
    ,o.glbdef1 -- 工作单位
    ,o.glbdef2 -- 部门
    ,o.glbdef3 -- 岗位
    ,o.glbdef4 -- 证明人
    ,o.glbdef11 -- 职务
    ,o.glbdef5 -- 工作城市
    ,o.glbdef6 -- 离职原因
    ,o.glbdef7 -- 证明人电话
    ,o.glbdef9 -- 备注
    ,o.glbdef10 -- 是否进行背景调查
    ,o.ts -- 时间戳
    ,o.dr -- 备用DR
    ,o.glbdef8 -- 备用GLBDEF8
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
from ${iol_schema}.nhrs_hi_psndoc_glbdef5_bk o
    left join ${iol_schema}.nhrs_hi_psndoc_glbdef5_op n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hi_psndoc_glbdef5_cl d
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
--truncate table ${iol_schema}.nhrs_hi_psndoc_glbdef5;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hi_psndoc_glbdef5') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hi_psndoc_glbdef5 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hi_psndoc_glbdef5 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hi_psndoc_glbdef5 exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hi_psndoc_glbdef5_cl;
alter table ${iol_schema}.nhrs_hi_psndoc_glbdef5 exchange partition p_20991231 with table ${iol_schema}.nhrs_hi_psndoc_glbdef5_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef5 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef5_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef5_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef5_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hi_psndoc_glbdef5',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
