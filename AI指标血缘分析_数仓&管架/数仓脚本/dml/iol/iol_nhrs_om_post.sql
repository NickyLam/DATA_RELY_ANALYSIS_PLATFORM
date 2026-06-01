/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_om_post
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
create table ${iol_schema}.nhrs_om_post_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_om_post
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_post_op purge;
drop table ${iol_schema}.nhrs_om_post_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_post_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_post where 0=1;

create table ${iol_schema}.nhrs_om_post_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_om_post where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_post_cl(
            abortdate -- 
            ,builddate -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,employment -- 
            ,enablestate -- 
            ,innercode -- 
            ,isabort -- 
            ,isdeptrespon -- 
            ,junior -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_dept -- 
            ,pk_group -- 
            ,pk_job -- 
            ,pk_org -- 
            ,pk_post -- 
            ,pk_postseries -- 
            ,postcode -- 
            ,postname -- 
            ,postname2 -- 
            ,postname3 -- 
            ,postname4 -- 
            ,postname5 -- 
            ,postname6 -- 
            ,reqedu -- 
            ,reqexp -- 
            ,reqother -- 
            ,reqpro -- 
            ,reqsex -- 
            ,reqworktime -- 
            ,reqyold -- 
            ,seq -- 
            ,suporior -- 
            ,ts -- 
            ,worksumm -- 
            ,worktype -- 
            ,hrcanceldate -- 
            ,hrcanceled -- 
            ,iskeypost -- 
            ,isstd -- 
            ,pk_hrorg -- 
            ,pk_poststd -- 
            ,sealflag -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_post_op(
            abortdate -- 
            ,builddate -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,employment -- 
            ,enablestate -- 
            ,innercode -- 
            ,isabort -- 
            ,isdeptrespon -- 
            ,junior -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_dept -- 
            ,pk_group -- 
            ,pk_job -- 
            ,pk_org -- 
            ,pk_post -- 
            ,pk_postseries -- 
            ,postcode -- 
            ,postname -- 
            ,postname2 -- 
            ,postname3 -- 
            ,postname4 -- 
            ,postname5 -- 
            ,postname6 -- 
            ,reqedu -- 
            ,reqexp -- 
            ,reqother -- 
            ,reqpro -- 
            ,reqsex -- 
            ,reqworktime -- 
            ,reqyold -- 
            ,seq -- 
            ,suporior -- 
            ,ts -- 
            ,worksumm -- 
            ,worktype -- 
            ,hrcanceldate -- 
            ,hrcanceled -- 
            ,iskeypost -- 
            ,isstd -- 
            ,pk_hrorg -- 
            ,pk_poststd -- 
            ,sealflag -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.abortdate, o.abortdate) as abortdate -- 
    ,nvl(n.builddate, o.builddate) as builddate -- 
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.employment, o.employment) as employment -- 
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 
    ,nvl(n.innercode, o.innercode) as innercode -- 
    ,nvl(n.isabort, o.isabort) as isabort -- 
    ,nvl(n.isdeptrespon, o.isdeptrespon) as isdeptrespon -- 
    ,nvl(n.junior, o.junior) as junior -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.pk_dept, o.pk_dept) as pk_dept -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_job, o.pk_job) as pk_job -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.pk_post, o.pk_post) as pk_post -- 
    ,nvl(n.pk_postseries, o.pk_postseries) as pk_postseries -- 
    ,nvl(n.postcode, o.postcode) as postcode -- 
    ,nvl(n.postname, o.postname) as postname -- 
    ,nvl(n.postname2, o.postname2) as postname2 -- 
    ,nvl(n.postname3, o.postname3) as postname3 -- 
    ,nvl(n.postname4, o.postname4) as postname4 -- 
    ,nvl(n.postname5, o.postname5) as postname5 -- 
    ,nvl(n.postname6, o.postname6) as postname6 -- 
    ,nvl(n.reqedu, o.reqedu) as reqedu -- 
    ,nvl(n.reqexp, o.reqexp) as reqexp -- 
    ,nvl(n.reqother, o.reqother) as reqother -- 
    ,nvl(n.reqpro, o.reqpro) as reqpro -- 
    ,nvl(n.reqsex, o.reqsex) as reqsex -- 
    ,nvl(n.reqworktime, o.reqworktime) as reqworktime -- 
    ,nvl(n.reqyold, o.reqyold) as reqyold -- 
    ,nvl(n.seq, o.seq) as seq -- 
    ,nvl(n.suporior, o.suporior) as suporior -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,nvl(n.worksumm, o.worksumm) as worksumm -- 
    ,nvl(n.worktype, o.worktype) as worktype -- 
    ,nvl(n.hrcanceldate, o.hrcanceldate) as hrcanceldate -- 
    ,nvl(n.hrcanceled, o.hrcanceled) as hrcanceled -- 
    ,nvl(n.iskeypost, o.iskeypost) as iskeypost -- 
    ,nvl(n.isstd, o.isstd) as isstd -- 
    ,nvl(n.pk_hrorg, o.pk_hrorg) as pk_hrorg -- 
    ,nvl(n.pk_poststd, o.pk_poststd) as pk_poststd -- 
    ,nvl(n.sealflag, o.sealflag) as sealflag -- 
    ,nvl(n.glbdef1, o.glbdef1) as glbdef1 -- 
    ,nvl(n.glbdef2, o.glbdef2) as glbdef2 -- 
    ,case when
            n.pk_post is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_post is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_post is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_om_post_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_om_post where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_post = n.pk_post
where (
        o.pk_post is null
    )
    or (
        n.pk_post is null
    )
    or (
        o.abortdate <> n.abortdate
        or o.builddate <> n.builddate
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.dr <> n.dr
        or o.employment <> n.employment
        or o.enablestate <> n.enablestate
        or o.innercode <> n.innercode
        or o.isabort <> n.isabort
        or o.isdeptrespon <> n.isdeptrespon
        or o.junior <> n.junior
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.pk_dept <> n.pk_dept
        or o.pk_group <> n.pk_group
        or o.pk_job <> n.pk_job
        or o.pk_org <> n.pk_org
        or o.pk_postseries <> n.pk_postseries
        or o.postcode <> n.postcode
        or o.postname <> n.postname
        or o.postname2 <> n.postname2
        or o.postname3 <> n.postname3
        or o.postname4 <> n.postname4
        or o.postname5 <> n.postname5
        or o.postname6 <> n.postname6
        or o.reqedu <> n.reqedu
        or o.reqexp <> n.reqexp
        or o.reqother <> n.reqother
        or o.reqpro <> n.reqpro
        or o.reqsex <> n.reqsex
        or o.reqworktime <> n.reqworktime
        or o.reqyold <> n.reqyold
        or o.seq <> n.seq
        or o.suporior <> n.suporior
        or o.ts <> n.ts
        or o.worksumm <> n.worksumm
        or o.worktype <> n.worktype
        or o.hrcanceldate <> n.hrcanceldate
        or o.hrcanceled <> n.hrcanceled
        or o.iskeypost <> n.iskeypost
        or o.isstd <> n.isstd
        or o.pk_hrorg <> n.pk_hrorg
        or o.pk_poststd <> n.pk_poststd
        or o.sealflag <> n.sealflag
        or o.glbdef1 <> n.glbdef1
        or o.glbdef2 <> n.glbdef2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_om_post_cl(
            abortdate -- 
            ,builddate -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,employment -- 
            ,enablestate -- 
            ,innercode -- 
            ,isabort -- 
            ,isdeptrespon -- 
            ,junior -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_dept -- 
            ,pk_group -- 
            ,pk_job -- 
            ,pk_org -- 
            ,pk_post -- 
            ,pk_postseries -- 
            ,postcode -- 
            ,postname -- 
            ,postname2 -- 
            ,postname3 -- 
            ,postname4 -- 
            ,postname5 -- 
            ,postname6 -- 
            ,reqedu -- 
            ,reqexp -- 
            ,reqother -- 
            ,reqpro -- 
            ,reqsex -- 
            ,reqworktime -- 
            ,reqyold -- 
            ,seq -- 
            ,suporior -- 
            ,ts -- 
            ,worksumm -- 
            ,worktype -- 
            ,hrcanceldate -- 
            ,hrcanceled -- 
            ,iskeypost -- 
            ,isstd -- 
            ,pk_hrorg -- 
            ,pk_poststd -- 
            ,sealflag -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_om_post_op(
            abortdate -- 
            ,builddate -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,dr -- 
            ,employment -- 
            ,enablestate -- 
            ,innercode -- 
            ,isabort -- 
            ,isdeptrespon -- 
            ,junior -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,pk_dept -- 
            ,pk_group -- 
            ,pk_job -- 
            ,pk_org -- 
            ,pk_post -- 
            ,pk_postseries -- 
            ,postcode -- 
            ,postname -- 
            ,postname2 -- 
            ,postname3 -- 
            ,postname4 -- 
            ,postname5 -- 
            ,postname6 -- 
            ,reqedu -- 
            ,reqexp -- 
            ,reqother -- 
            ,reqpro -- 
            ,reqsex -- 
            ,reqworktime -- 
            ,reqyold -- 
            ,seq -- 
            ,suporior -- 
            ,ts -- 
            ,worksumm -- 
            ,worktype -- 
            ,hrcanceldate -- 
            ,hrcanceled -- 
            ,iskeypost -- 
            ,isstd -- 
            ,pk_hrorg -- 
            ,pk_poststd -- 
            ,sealflag -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.abortdate -- 
    ,o.builddate -- 
    ,o.creationtime -- 
    ,o.creator -- 
    ,o.dataoriginflag -- 
    ,o.dr -- 
    ,o.employment -- 
    ,o.enablestate -- 
    ,o.innercode -- 
    ,o.isabort -- 
    ,o.isdeptrespon -- 
    ,o.junior -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.pk_dept -- 
    ,o.pk_group -- 
    ,o.pk_job -- 
    ,o.pk_org -- 
    ,o.pk_post -- 
    ,o.pk_postseries -- 
    ,o.postcode -- 
    ,o.postname -- 
    ,o.postname2 -- 
    ,o.postname3 -- 
    ,o.postname4 -- 
    ,o.postname5 -- 
    ,o.postname6 -- 
    ,o.reqedu -- 
    ,o.reqexp -- 
    ,o.reqother -- 
    ,o.reqpro -- 
    ,o.reqsex -- 
    ,o.reqworktime -- 
    ,o.reqyold -- 
    ,o.seq -- 
    ,o.suporior -- 
    ,o.ts -- 
    ,o.worksumm -- 
    ,o.worktype -- 
    ,o.hrcanceldate -- 
    ,o.hrcanceled -- 
    ,o.iskeypost -- 
    ,o.isstd -- 
    ,o.pk_hrorg -- 
    ,o.pk_poststd -- 
    ,o.sealflag -- 
    ,o.glbdef1 -- 
    ,o.glbdef2 -- 
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
from ${iol_schema}.nhrs_om_post_bk o
    left join ${iol_schema}.nhrs_om_post_op n
        on
            o.pk_post = n.pk_post
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_om_post_cl d
        on
            o.pk_post = d.pk_post
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_om_post;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_om_post') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_om_post drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_om_post add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_om_post exchange partition p_${batch_date} with table ${iol_schema}.nhrs_om_post_cl;
alter table ${iol_schema}.nhrs_om_post exchange partition p_20991231 with table ${iol_schema}.nhrs_om_post_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_om_post to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_om_post_op purge;
drop table ${iol_schema}.nhrs_om_post_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_om_post_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_om_post',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
