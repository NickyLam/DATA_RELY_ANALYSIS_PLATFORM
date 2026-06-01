/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_tbm_psndoc
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
create table ${iol_schema}.nhrs_tbm_psndoc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_tbm_psndoc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_tbm_psndoc_op purge;
drop table ${iol_schema}.nhrs_tbm_psndoc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_tbm_psndoc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_tbm_psndoc where 0=1;

create table ${iol_schema}.nhrs_tbm_psndoc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_tbm_psndoc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_tbm_psndoc_cl(
            begindate -- 档案开始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 档案结束日期
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_adminorg -- 管理组织
            ,pk_group -- 集团主键
            ,pk_org -- 组织主键
            ,pk_place -- 考勤地点
            ,pk_psndoc -- 人员基本信息
            ,pk_psnjob -- 人员工作记录
            ,pk_psnorg -- 组织关系主键
            ,pk_tbm_psndoc -- 考勤档案主键
            ,pk_team -- 所属班组
            ,secondcardid -- 副卡号
            ,tbm_prop -- 考勤方式
            ,timecardid -- 考勤卡号
            ,ts -- 备用TS
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_tbm_psndoc_op(
            begindate -- 档案开始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 档案结束日期
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_adminorg -- 管理组织
            ,pk_group -- 集团主键
            ,pk_org -- 组织主键
            ,pk_place -- 考勤地点
            ,pk_psndoc -- 人员基本信息
            ,pk_psnjob -- 人员工作记录
            ,pk_psnorg -- 组织关系主键
            ,pk_tbm_psndoc -- 考勤档案主键
            ,pk_team -- 所属班组
            ,secondcardid -- 副卡号
            ,tbm_prop -- 考勤方式
            ,timecardid -- 考勤卡号
            ,ts -- 备用TS
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.begindate, o.begindate) as begindate -- 档案开始日期
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.enddate, o.enddate) as enddate -- 档案结束日期
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.pk_adminorg, o.pk_adminorg) as pk_adminorg -- 管理组织
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团主键
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 组织主键
    ,nvl(n.pk_place, o.pk_place) as pk_place -- 考勤地点
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员基本信息
    ,nvl(n.pk_psnjob, o.pk_psnjob) as pk_psnjob -- 人员工作记录
    ,nvl(n.pk_psnorg, o.pk_psnorg) as pk_psnorg -- 组织关系主键
    ,nvl(n.pk_tbm_psndoc, o.pk_tbm_psndoc) as pk_tbm_psndoc -- 考勤档案主键
    ,nvl(n.pk_team, o.pk_team) as pk_team -- 所属班组
    ,nvl(n.secondcardid, o.secondcardid) as secondcardid -- 副卡号
    ,nvl(n.tbm_prop, o.tbm_prop) as tbm_prop -- 考勤方式
    ,nvl(n.timecardid, o.timecardid) as timecardid -- 考勤卡号
    ,nvl(n.ts, o.ts) as ts -- 备用TS
    ,case when
            n.pk_tbm_psndoc is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_tbm_psndoc is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_tbm_psndoc is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_tbm_psndoc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_tbm_psndoc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_tbm_psndoc = n.pk_tbm_psndoc
where (
        o.pk_tbm_psndoc is null
    )
    or (
        n.pk_tbm_psndoc is null
    )
    or (
        o.begindate <> n.begindate
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dr <> n.dr
        or o.enddate <> n.enddate
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.pk_adminorg <> n.pk_adminorg
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_place <> n.pk_place
        or o.pk_psndoc <> n.pk_psndoc
        or o.pk_psnjob <> n.pk_psnjob
        or o.pk_psnorg <> n.pk_psnorg
        or o.pk_team <> n.pk_team
        or o.secondcardid <> n.secondcardid
        or o.tbm_prop <> n.tbm_prop
        or o.timecardid <> n.timecardid
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_tbm_psndoc_cl(
            begindate -- 档案开始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 档案结束日期
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_adminorg -- 管理组织
            ,pk_group -- 集团主键
            ,pk_org -- 组织主键
            ,pk_place -- 考勤地点
            ,pk_psndoc -- 人员基本信息
            ,pk_psnjob -- 人员工作记录
            ,pk_psnorg -- 组织关系主键
            ,pk_tbm_psndoc -- 考勤档案主键
            ,pk_team -- 所属班组
            ,secondcardid -- 副卡号
            ,tbm_prop -- 考勤方式
            ,timecardid -- 考勤卡号
            ,ts -- 备用TS
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_tbm_psndoc_op(
            begindate -- 档案开始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 档案结束日期
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,pk_adminorg -- 管理组织
            ,pk_group -- 集团主键
            ,pk_org -- 组织主键
            ,pk_place -- 考勤地点
            ,pk_psndoc -- 人员基本信息
            ,pk_psnjob -- 人员工作记录
            ,pk_psnorg -- 组织关系主键
            ,pk_tbm_psndoc -- 考勤档案主键
            ,pk_team -- 所属班组
            ,secondcardid -- 副卡号
            ,tbm_prop -- 考勤方式
            ,timecardid -- 考勤卡号
            ,ts -- 备用TS
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.begindate -- 档案开始日期
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dr -- 备用DR
    ,o.enddate -- 档案结束日期
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.pk_adminorg -- 管理组织
    ,o.pk_group -- 集团主键
    ,o.pk_org -- 组织主键
    ,o.pk_place -- 考勤地点
    ,o.pk_psndoc -- 人员基本信息
    ,o.pk_psnjob -- 人员工作记录
    ,o.pk_psnorg -- 组织关系主键
    ,o.pk_tbm_psndoc -- 考勤档案主键
    ,o.pk_team -- 所属班组
    ,o.secondcardid -- 副卡号
    ,o.tbm_prop -- 考勤方式
    ,o.timecardid -- 考勤卡号
    ,o.ts -- 备用TS
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
from ${iol_schema}.nhrs_tbm_psndoc_bk o
    left join ${iol_schema}.nhrs_tbm_psndoc_op n
        on
            o.pk_tbm_psndoc = n.pk_tbm_psndoc
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_tbm_psndoc_cl d
        on
            o.pk_tbm_psndoc = d.pk_tbm_psndoc
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_tbm_psndoc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_tbm_psndoc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_tbm_psndoc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_tbm_psndoc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_tbm_psndoc exchange partition p_${batch_date} with table ${iol_schema}.nhrs_tbm_psndoc_cl;
alter table ${iol_schema}.nhrs_tbm_psndoc exchange partition p_20991231 with table ${iol_schema}.nhrs_tbm_psndoc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_tbm_psndoc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_tbm_psndoc_op purge;
drop table ${iol_schema}.nhrs_tbm_psndoc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_tbm_psndoc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_tbm_psndoc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
