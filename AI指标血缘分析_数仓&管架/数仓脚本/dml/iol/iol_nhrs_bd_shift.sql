/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_bd_shift
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
create table ${iol_schema}.nhrs_bd_shift_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_bd_shift
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_bd_shift_op purge;
drop table ${iol_schema}.nhrs_bd_shift_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_shift_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_bd_shift where 0=1;

create table ${iol_schema}.nhrs_bd_shift_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_bd_shift where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_bd_shift_cl(
            allowearly -- 
            ,allowlate -- 
            ,beginday -- 
            ,begintime -- 
            ,capbeginday -- 
            ,capbegintime -- 
            ,capendday -- 
            ,capendtime -- 
            ,capgzsj -- 
            ,cardtype -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,defaultflag -- 
            ,dr -- 
            ,earliestendday -- 
            ,earliestendtime -- 
            ,enablestate -- 
            ,endday -- 
            ,endtime -- 
            ,gzsj -- 
            ,includenightshift -- 
            ,isallowout -- 
            ,isautokg -- 
            ,iscapedited -- 
            ,isflexiblefinal -- 
            ,ishredited -- 
            ,isotflexible -- 
            ,isotflexiblefinal -- 
            ,isrttimeflexible -- 
            ,isrttimeflexiblefinal -- 
            ,issinglecard -- 
            ,isturn -- 
            ,kghours -- 
            ,largeearly -- 
            ,largelate -- 
            ,latestbeginday -- 
            ,latestbegintime -- 
            ,memo -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,nightbeginday -- 
            ,nightbegintime -- 
            ,nightendday -- 
            ,nightendtime -- 
            ,nightgzsj -- 
            ,ontmbeyond -- 
            ,ontmend -- 
            ,overtmbegin -- 
            ,overtmbeyond -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_shift -- 
            ,pk_shifttype -- 
            ,timebeginday -- 
            ,timebegintime -- 
            ,timeendday -- 
            ,timeendtime -- 
            ,ts -- 
            ,useontmrule -- 
            ,useovertmrule -- 
            ,worklen -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_bd_shift_op(
            allowearly -- 
            ,allowlate -- 
            ,beginday -- 
            ,begintime -- 
            ,capbeginday -- 
            ,capbegintime -- 
            ,capendday -- 
            ,capendtime -- 
            ,capgzsj -- 
            ,cardtype -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,defaultflag -- 
            ,dr -- 
            ,earliestendday -- 
            ,earliestendtime -- 
            ,enablestate -- 
            ,endday -- 
            ,endtime -- 
            ,gzsj -- 
            ,includenightshift -- 
            ,isallowout -- 
            ,isautokg -- 
            ,iscapedited -- 
            ,isflexiblefinal -- 
            ,ishredited -- 
            ,isotflexible -- 
            ,isotflexiblefinal -- 
            ,isrttimeflexible -- 
            ,isrttimeflexiblefinal -- 
            ,issinglecard -- 
            ,isturn -- 
            ,kghours -- 
            ,largeearly -- 
            ,largelate -- 
            ,latestbeginday -- 
            ,latestbegintime -- 
            ,memo -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,nightbeginday -- 
            ,nightbegintime -- 
            ,nightendday -- 
            ,nightendtime -- 
            ,nightgzsj -- 
            ,ontmbeyond -- 
            ,ontmend -- 
            ,overtmbegin -- 
            ,overtmbeyond -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_shift -- 
            ,pk_shifttype -- 
            ,timebeginday -- 
            ,timebegintime -- 
            ,timeendday -- 
            ,timeendtime -- 
            ,ts -- 
            ,useontmrule -- 
            ,useovertmrule -- 
            ,worklen -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.allowearly, o.allowearly) as allowearly -- 
    ,nvl(n.allowlate, o.allowlate) as allowlate -- 
    ,nvl(n.beginday, o.beginday) as beginday -- 
    ,nvl(n.begintime, o.begintime) as begintime -- 
    ,nvl(n.capbeginday, o.capbeginday) as capbeginday -- 
    ,nvl(n.capbegintime, o.capbegintime) as capbegintime -- 
    ,nvl(n.capendday, o.capendday) as capendday -- 
    ,nvl(n.capendtime, o.capendtime) as capendtime -- 
    ,nvl(n.capgzsj, o.capgzsj) as capgzsj -- 
    ,nvl(n.cardtype, o.cardtype) as cardtype -- 
    ,nvl(n.code, o.code) as code -- 
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.defaultflag, o.defaultflag) as defaultflag -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.earliestendday, o.earliestendday) as earliestendday -- 
    ,nvl(n.earliestendtime, o.earliestendtime) as earliestendtime -- 
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 
    ,nvl(n.endday, o.endday) as endday -- 
    ,nvl(n.endtime, o.endtime) as endtime -- 
    ,nvl(n.gzsj, o.gzsj) as gzsj -- 
    ,nvl(n.includenightshift, o.includenightshift) as includenightshift -- 
    ,nvl(n.isallowout, o.isallowout) as isallowout -- 
    ,nvl(n.isautokg, o.isautokg) as isautokg -- 
    ,nvl(n.iscapedited, o.iscapedited) as iscapedited -- 
    ,nvl(n.isflexiblefinal, o.isflexiblefinal) as isflexiblefinal -- 
    ,nvl(n.ishredited, o.ishredited) as ishredited -- 
    ,nvl(n.isotflexible, o.isotflexible) as isotflexible -- 
    ,nvl(n.isotflexiblefinal, o.isotflexiblefinal) as isotflexiblefinal -- 
    ,nvl(n.isrttimeflexible, o.isrttimeflexible) as isrttimeflexible -- 
    ,nvl(n.isrttimeflexiblefinal, o.isrttimeflexiblefinal) as isrttimeflexiblefinal -- 
    ,nvl(n.issinglecard, o.issinglecard) as issinglecard -- 
    ,nvl(n.isturn, o.isturn) as isturn -- 
    ,nvl(n.kghours, o.kghours) as kghours -- 
    ,nvl(n.largeearly, o.largeearly) as largeearly -- 
    ,nvl(n.largelate, o.largelate) as largelate -- 
    ,nvl(n.latestbeginday, o.latestbeginday) as latestbeginday -- 
    ,nvl(n.latestbegintime, o.latestbegintime) as latestbegintime -- 
    ,nvl(n.memo, o.memo) as memo -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.name, o.name) as name -- 
    ,nvl(n.name2, o.name2) as name2 -- 
    ,nvl(n.name3, o.name3) as name3 -- 
    ,nvl(n.name4, o.name4) as name4 -- 
    ,nvl(n.name5, o.name5) as name5 -- 
    ,nvl(n.name6, o.name6) as name6 -- 
    ,nvl(n.nightbeginday, o.nightbeginday) as nightbeginday -- 
    ,nvl(n.nightbegintime, o.nightbegintime) as nightbegintime -- 
    ,nvl(n.nightendday, o.nightendday) as nightendday -- 
    ,nvl(n.nightendtime, o.nightendtime) as nightendtime -- 
    ,nvl(n.nightgzsj, o.nightgzsj) as nightgzsj -- 
    ,nvl(n.ontmbeyond, o.ontmbeyond) as ontmbeyond -- 
    ,nvl(n.ontmend, o.ontmend) as ontmend -- 
    ,nvl(n.overtmbegin, o.overtmbegin) as overtmbegin -- 
    ,nvl(n.overtmbeyond, o.overtmbeyond) as overtmbeyond -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.pk_shift, o.pk_shift) as pk_shift -- 
    ,nvl(n.pk_shifttype, o.pk_shifttype) as pk_shifttype -- 
    ,nvl(n.timebeginday, o.timebeginday) as timebeginday -- 
    ,nvl(n.timebegintime, o.timebegintime) as timebegintime -- 
    ,nvl(n.timeendday, o.timeendday) as timeendday -- 
    ,nvl(n.timeendtime, o.timeendtime) as timeendtime -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,nvl(n.useontmrule, o.useontmrule) as useontmrule -- 
    ,nvl(n.useovertmrule, o.useovertmrule) as useovertmrule -- 
    ,nvl(n.worklen, o.worklen) as worklen -- 
    ,case when
            n.pk_shift is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_shift is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_shift is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_bd_shift_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_bd_shift where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_shift = n.pk_shift
where (
        o.pk_shift is null
    )
    or (
        n.pk_shift is null
    )
    or (
        o.allowearly <> n.allowearly
        or o.allowlate <> n.allowlate
        or o.beginday <> n.beginday
        or o.begintime <> n.begintime
        or o.capbeginday <> n.capbeginday
        or o.capbegintime <> n.capbegintime
        or o.capendday <> n.capendday
        or o.capendtime <> n.capendtime
        or o.capgzsj <> n.capgzsj
        or o.cardtype <> n.cardtype
        or o.code <> n.code
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.defaultflag <> n.defaultflag
        or o.dr <> n.dr
        or o.earliestendday <> n.earliestendday
        or o.earliestendtime <> n.earliestendtime
        or o.enablestate <> n.enablestate
        or o.endday <> n.endday
        or o.endtime <> n.endtime
        or o.gzsj <> n.gzsj
        or o.includenightshift <> n.includenightshift
        or o.isallowout <> n.isallowout
        or o.isautokg <> n.isautokg
        or o.iscapedited <> n.iscapedited
        or o.isflexiblefinal <> n.isflexiblefinal
        or o.ishredited <> n.ishredited
        or o.isotflexible <> n.isotflexible
        or o.isotflexiblefinal <> n.isotflexiblefinal
        or o.isrttimeflexible <> n.isrttimeflexible
        or o.isrttimeflexiblefinal <> n.isrttimeflexiblefinal
        or o.issinglecard <> n.issinglecard
        or o.isturn <> n.isturn
        or o.kghours <> n.kghours
        or o.largeearly <> n.largeearly
        or o.largelate <> n.largelate
        or o.latestbeginday <> n.latestbeginday
        or o.latestbegintime <> n.latestbegintime
        or o.memo <> n.memo
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.nightbeginday <> n.nightbeginday
        or o.nightbegintime <> n.nightbegintime
        or o.nightendday <> n.nightendday
        or o.nightendtime <> n.nightendtime
        or o.nightgzsj <> n.nightgzsj
        or o.ontmbeyond <> n.ontmbeyond
        or o.ontmend <> n.ontmend
        or o.overtmbegin <> n.overtmbegin
        or o.overtmbeyond <> n.overtmbeyond
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_shifttype <> n.pk_shifttype
        or o.timebeginday <> n.timebeginday
        or o.timebegintime <> n.timebegintime
        or o.timeendday <> n.timeendday
        or o.timeendtime <> n.timeendtime
        or o.ts <> n.ts
        or o.useontmrule <> n.useontmrule
        or o.useovertmrule <> n.useovertmrule
        or o.worklen <> n.worklen
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_bd_shift_cl(
            allowearly -- 
            ,allowlate -- 
            ,beginday -- 
            ,begintime -- 
            ,capbeginday -- 
            ,capbegintime -- 
            ,capendday -- 
            ,capendtime -- 
            ,capgzsj -- 
            ,cardtype -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,defaultflag -- 
            ,dr -- 
            ,earliestendday -- 
            ,earliestendtime -- 
            ,enablestate -- 
            ,endday -- 
            ,endtime -- 
            ,gzsj -- 
            ,includenightshift -- 
            ,isallowout -- 
            ,isautokg -- 
            ,iscapedited -- 
            ,isflexiblefinal -- 
            ,ishredited -- 
            ,isotflexible -- 
            ,isotflexiblefinal -- 
            ,isrttimeflexible -- 
            ,isrttimeflexiblefinal -- 
            ,issinglecard -- 
            ,isturn -- 
            ,kghours -- 
            ,largeearly -- 
            ,largelate -- 
            ,latestbeginday -- 
            ,latestbegintime -- 
            ,memo -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,nightbeginday -- 
            ,nightbegintime -- 
            ,nightendday -- 
            ,nightendtime -- 
            ,nightgzsj -- 
            ,ontmbeyond -- 
            ,ontmend -- 
            ,overtmbegin -- 
            ,overtmbeyond -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_shift -- 
            ,pk_shifttype -- 
            ,timebeginday -- 
            ,timebegintime -- 
            ,timeendday -- 
            ,timeendtime -- 
            ,ts -- 
            ,useontmrule -- 
            ,useovertmrule -- 
            ,worklen -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_bd_shift_op(
            allowearly -- 
            ,allowlate -- 
            ,beginday -- 
            ,begintime -- 
            ,capbeginday -- 
            ,capbegintime -- 
            ,capendday -- 
            ,capendtime -- 
            ,capgzsj -- 
            ,cardtype -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,defaultflag -- 
            ,dr -- 
            ,earliestendday -- 
            ,earliestendtime -- 
            ,enablestate -- 
            ,endday -- 
            ,endtime -- 
            ,gzsj -- 
            ,includenightshift -- 
            ,isallowout -- 
            ,isautokg -- 
            ,iscapedited -- 
            ,isflexiblefinal -- 
            ,ishredited -- 
            ,isotflexible -- 
            ,isotflexiblefinal -- 
            ,isrttimeflexible -- 
            ,isrttimeflexiblefinal -- 
            ,issinglecard -- 
            ,isturn -- 
            ,kghours -- 
            ,largeearly -- 
            ,largelate -- 
            ,latestbeginday -- 
            ,latestbegintime -- 
            ,memo -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,nightbeginday -- 
            ,nightbegintime -- 
            ,nightendday -- 
            ,nightendtime -- 
            ,nightgzsj -- 
            ,ontmbeyond -- 
            ,ontmend -- 
            ,overtmbegin -- 
            ,overtmbeyond -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_shift -- 
            ,pk_shifttype -- 
            ,timebeginday -- 
            ,timebegintime -- 
            ,timeendday -- 
            ,timeendtime -- 
            ,ts -- 
            ,useontmrule -- 
            ,useovertmrule -- 
            ,worklen -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.allowearly -- 
    ,o.allowlate -- 
    ,o.beginday -- 
    ,o.begintime -- 
    ,o.capbeginday -- 
    ,o.capbegintime -- 
    ,o.capendday -- 
    ,o.capendtime -- 
    ,o.capgzsj -- 
    ,o.cardtype -- 
    ,o.code -- 
    ,o.creationtime -- 
    ,o.creator -- 
    ,o.dataoriginflag -- 
    ,o.defaultflag -- 
    ,o.dr -- 
    ,o.earliestendday -- 
    ,o.earliestendtime -- 
    ,o.enablestate -- 
    ,o.endday -- 
    ,o.endtime -- 
    ,o.gzsj -- 
    ,o.includenightshift -- 
    ,o.isallowout -- 
    ,o.isautokg -- 
    ,o.iscapedited -- 
    ,o.isflexiblefinal -- 
    ,o.ishredited -- 
    ,o.isotflexible -- 
    ,o.isotflexiblefinal -- 
    ,o.isrttimeflexible -- 
    ,o.isrttimeflexiblefinal -- 
    ,o.issinglecard -- 
    ,o.isturn -- 
    ,o.kghours -- 
    ,o.largeearly -- 
    ,o.largelate -- 
    ,o.latestbeginday -- 
    ,o.latestbegintime -- 
    ,o.memo -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.name -- 
    ,o.name2 -- 
    ,o.name3 -- 
    ,o.name4 -- 
    ,o.name5 -- 
    ,o.name6 -- 
    ,o.nightbeginday -- 
    ,o.nightbegintime -- 
    ,o.nightendday -- 
    ,o.nightendtime -- 
    ,o.nightgzsj -- 
    ,o.ontmbeyond -- 
    ,o.ontmend -- 
    ,o.overtmbegin -- 
    ,o.overtmbeyond -- 
    ,o.pk_group -- 
    ,o.pk_org -- 
    ,o.pk_shift -- 
    ,o.pk_shifttype -- 
    ,o.timebeginday -- 
    ,o.timebegintime -- 
    ,o.timeendday -- 
    ,o.timeendtime -- 
    ,o.ts -- 
    ,o.useontmrule -- 
    ,o.useovertmrule -- 
    ,o.worklen -- 
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
from ${iol_schema}.nhrs_bd_shift_bk o
    left join ${iol_schema}.nhrs_bd_shift_op n
        on
            o.pk_shift = n.pk_shift
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_bd_shift_cl d
        on
            o.pk_shift = d.pk_shift
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_bd_shift;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_bd_shift') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_bd_shift drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_bd_shift add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_bd_shift exchange partition p_${batch_date} with table ${iol_schema}.nhrs_bd_shift_cl;
alter table ${iol_schema}.nhrs_bd_shift exchange partition p_20991231 with table ${iol_schema}.nhrs_bd_shift_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_bd_shift to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_bd_shift_op purge;
drop table ${iol_schema}.nhrs_bd_shift_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_bd_shift_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_bd_shift',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
