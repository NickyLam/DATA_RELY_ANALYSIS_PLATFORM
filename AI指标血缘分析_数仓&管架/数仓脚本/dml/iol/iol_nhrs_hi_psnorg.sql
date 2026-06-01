/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hi_psnorg
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
create table ${iol_schema}.nhrs_hi_psnorg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hi_psnorg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psnorg_op purge;
drop table ${iol_schema}.nhrs_hi_psnorg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psnorg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psnorg where 0=1;

create table ${iol_schema}.nhrs_hi_psnorg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psnorg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psnorg_cl(
            begindate -- 进入日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,empforms -- 用工形式
            ,enddate -- 退出日期
            ,endflag -- 是否终止
            ,indoc_source -- 入职来源
            ,indocflag -- 是否转入人员档案
            ,joinsysdate -- 进入集团日期
            ,lastflag -- 最新标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,orgrelaid -- 组织关系ID
            ,pk_group -- 所属集团
            ,pk_hrorg -- 人力资源组织
            ,pk_org -- 组织
            ,pk_psndoc -- 人员主键
            ,pk_psnorg -- 组织关系主键
            ,psntype -- 人员类型
            ,startpaydate -- 薪资开始日期
            ,stoppaydate -- 薪资停发日期
            ,ts -- 备用TS
            ,workage -- 备用WORKAGE
            ,orgglbdef1 -- 备用ORGGLBDEF1
            ,orgglbdef2 -- 备用ORGGLBDEF2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psnorg_op(
            begindate -- 进入日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,empforms -- 用工形式
            ,enddate -- 退出日期
            ,endflag -- 是否终止
            ,indoc_source -- 入职来源
            ,indocflag -- 是否转入人员档案
            ,joinsysdate -- 进入集团日期
            ,lastflag -- 最新标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,orgrelaid -- 组织关系ID
            ,pk_group -- 所属集团
            ,pk_hrorg -- 人力资源组织
            ,pk_org -- 组织
            ,pk_psndoc -- 人员主键
            ,pk_psnorg -- 组织关系主键
            ,psntype -- 人员类型
            ,startpaydate -- 薪资开始日期
            ,stoppaydate -- 薪资停发日期
            ,ts -- 备用TS
            ,workage -- 备用WORKAGE
            ,orgglbdef1 -- 备用ORGGLBDEF1
            ,orgglbdef2 -- 备用ORGGLBDEF2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.begindate, o.begindate) as begindate -- 进入日期
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.empforms, o.empforms) as empforms -- 用工形式
    ,nvl(n.enddate, o.enddate) as enddate -- 退出日期
    ,nvl(n.endflag, o.endflag) as endflag -- 是否终止
    ,nvl(n.indoc_source, o.indoc_source) as indoc_source -- 入职来源
    ,nvl(n.indocflag, o.indocflag) as indocflag -- 是否转入人员档案
    ,nvl(n.joinsysdate, o.joinsysdate) as joinsysdate -- 进入集团日期
    ,nvl(n.lastflag, o.lastflag) as lastflag -- 最新标志
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.orgrelaid, o.orgrelaid) as orgrelaid -- 组织关系ID
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_hrorg, o.pk_hrorg) as pk_hrorg -- 人力资源组织
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 组织
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员主键
    ,nvl(n.pk_psnorg, o.pk_psnorg) as pk_psnorg -- 组织关系主键
    ,nvl(n.psntype, o.psntype) as psntype -- 人员类型
    ,nvl(n.startpaydate, o.startpaydate) as startpaydate -- 薪资开始日期
    ,nvl(n.stoppaydate, o.stoppaydate) as stoppaydate -- 薪资停发日期
    ,nvl(n.ts, o.ts) as ts -- 备用TS
    ,nvl(n.workage, o.workage) as workage -- 备用WORKAGE
    ,nvl(n.orgglbdef1, o.orgglbdef1) as orgglbdef1 -- 备用ORGGLBDEF1
    ,nvl(n.orgglbdef2, o.orgglbdef2) as orgglbdef2 -- 备用ORGGLBDEF2
    ,case when
            n.pk_psnorg is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_psnorg is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_psnorg is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_hi_psnorg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hi_psnorg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psnorg = n.pk_psnorg
where (
        o.pk_psnorg is null
    )
    or (
        n.pk_psnorg is null
    )
    or (
        o.begindate <> n.begindate
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dr <> n.dr
        or o.empforms <> n.empforms
        or o.enddate <> n.enddate
        or o.endflag <> n.endflag
        or o.indoc_source <> n.indoc_source
        or o.indocflag <> n.indocflag
        or o.joinsysdate <> n.joinsysdate
        or o.lastflag <> n.lastflag
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.orgrelaid <> n.orgrelaid
        or o.pk_group <> n.pk_group
        or o.pk_hrorg <> n.pk_hrorg
        or o.pk_org <> n.pk_org
        or o.pk_psndoc <> n.pk_psndoc
        or o.psntype <> n.psntype
        or o.startpaydate <> n.startpaydate
        or o.stoppaydate <> n.stoppaydate
        or o.ts <> n.ts
        or o.workage <> n.workage
        or o.orgglbdef1 <> n.orgglbdef1
        or o.orgglbdef2 <> n.orgglbdef2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psnorg_cl(
            begindate -- 进入日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,empforms -- 用工形式
            ,enddate -- 退出日期
            ,endflag -- 是否终止
            ,indoc_source -- 入职来源
            ,indocflag -- 是否转入人员档案
            ,joinsysdate -- 进入集团日期
            ,lastflag -- 最新标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,orgrelaid -- 组织关系ID
            ,pk_group -- 所属集团
            ,pk_hrorg -- 人力资源组织
            ,pk_org -- 组织
            ,pk_psndoc -- 人员主键
            ,pk_psnorg -- 组织关系主键
            ,psntype -- 人员类型
            ,startpaydate -- 薪资开始日期
            ,stoppaydate -- 薪资停发日期
            ,ts -- 备用TS
            ,workage -- 备用WORKAGE
            ,orgglbdef1 -- 备用ORGGLBDEF1
            ,orgglbdef2 -- 备用ORGGLBDEF2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psnorg_op(
            begindate -- 进入日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,empforms -- 用工形式
            ,enddate -- 退出日期
            ,endflag -- 是否终止
            ,indoc_source -- 入职来源
            ,indocflag -- 是否转入人员档案
            ,joinsysdate -- 进入集团日期
            ,lastflag -- 最新标志
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,orgrelaid -- 组织关系ID
            ,pk_group -- 所属集团
            ,pk_hrorg -- 人力资源组织
            ,pk_org -- 组织
            ,pk_psndoc -- 人员主键
            ,pk_psnorg -- 组织关系主键
            ,psntype -- 人员类型
            ,startpaydate -- 薪资开始日期
            ,stoppaydate -- 薪资停发日期
            ,ts -- 备用TS
            ,workage -- 备用WORKAGE
            ,orgglbdef1 -- 备用ORGGLBDEF1
            ,orgglbdef2 -- 备用ORGGLBDEF2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.begindate -- 进入日期
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dr -- 备用DR
    ,o.empforms -- 用工形式
    ,o.enddate -- 退出日期
    ,o.endflag -- 是否终止
    ,o.indoc_source -- 入职来源
    ,o.indocflag -- 是否转入人员档案
    ,o.joinsysdate -- 进入集团日期
    ,o.lastflag -- 最新标志
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.orgrelaid -- 组织关系ID
    ,o.pk_group -- 所属集团
    ,o.pk_hrorg -- 人力资源组织
    ,o.pk_org -- 组织
    ,o.pk_psndoc -- 人员主键
    ,o.pk_psnorg -- 组织关系主键
    ,o.psntype -- 人员类型
    ,o.startpaydate -- 薪资开始日期
    ,o.stoppaydate -- 薪资停发日期
    ,o.ts -- 备用TS
    ,o.workage -- 备用WORKAGE
    ,o.orgglbdef1 -- 备用ORGGLBDEF1
    ,o.orgglbdef2 -- 备用ORGGLBDEF2
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
from ${iol_schema}.nhrs_hi_psnorg_bk o
    left join ${iol_schema}.nhrs_hi_psnorg_op n
        on
            o.pk_psnorg = n.pk_psnorg
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hi_psnorg_cl d
        on
            o.pk_psnorg = d.pk_psnorg
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_hi_psnorg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hi_psnorg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hi_psnorg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hi_psnorg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hi_psnorg exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hi_psnorg_cl;
alter table ${iol_schema}.nhrs_hi_psnorg exchange partition p_20991231 with table ${iol_schema}.nhrs_hi_psnorg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hi_psnorg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psnorg_op purge;
drop table ${iol_schema}.nhrs_hi_psnorg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hi_psnorg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hi_psnorg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
