/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_org_dept
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
create table ${iol_schema}.nhrs_org_dept_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_org_dept
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_org_dept_op purge;
drop table ${iol_schema}.nhrs_org_dept_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_org_dept_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_org_dept where 0=1;

create table ${iol_schema}.nhrs_org_dept_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_org_dept where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_org_dept_cl(
            address -- 
            ,code -- 
            ,createdate -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,deptcanceldate -- 
            ,deptlevel -- 
            ,depttype -- 
            ,displayorder -- 
            ,dr -- 
            ,enablestate -- 
            ,hrcanceled -- 
            ,innercode -- 
            ,islastversion -- 
            ,isretail -- 
            ,memo -- 
            ,mnecode -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,orgtype13 -- 
            ,orgtype17 -- 
            ,pk_dept -- 
            ,pk_fatherorg -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_vid -- 
            ,principal -- 
            ,resposition -- 
            ,shortname -- 
            ,shortname2 -- 
            ,shortname3 -- 
            ,shortname4 -- 
            ,shortname5 -- 
            ,shortname6 -- 
            ,tel -- 
            ,ts -- 
            ,venddate -- 
            ,vname -- 
            ,vname2 -- 
            ,vname3 -- 
            ,vname4 -- 
            ,vname5 -- 
            ,vname6 -- 
            ,vno -- 
            ,vstartdate -- 
            ,deptduty -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_org_dept_op(
            address -- 
            ,code -- 
            ,createdate -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,deptcanceldate -- 
            ,deptlevel -- 
            ,depttype -- 
            ,displayorder -- 
            ,dr -- 
            ,enablestate -- 
            ,hrcanceled -- 
            ,innercode -- 
            ,islastversion -- 
            ,isretail -- 
            ,memo -- 
            ,mnecode -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,orgtype13 -- 
            ,orgtype17 -- 
            ,pk_dept -- 
            ,pk_fatherorg -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_vid -- 
            ,principal -- 
            ,resposition -- 
            ,shortname -- 
            ,shortname2 -- 
            ,shortname3 -- 
            ,shortname4 -- 
            ,shortname5 -- 
            ,shortname6 -- 
            ,tel -- 
            ,ts -- 
            ,venddate -- 
            ,vname -- 
            ,vname2 -- 
            ,vname3 -- 
            ,vname4 -- 
            ,vname5 -- 
            ,vname6 -- 
            ,vno -- 
            ,vstartdate -- 
            ,deptduty -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.address, o.address) as address -- 
    ,nvl(n.code, o.code) as code -- 
    ,nvl(n.createdate, o.createdate) as createdate -- 
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 
    ,nvl(n.creator, o.creator) as creator -- 
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 
    ,nvl(n.def1, o.def1) as def1 -- 
    ,nvl(n.def10, o.def10) as def10 -- 
    ,nvl(n.def11, o.def11) as def11 -- 
    ,nvl(n.def12, o.def12) as def12 -- 
    ,nvl(n.def13, o.def13) as def13 -- 
    ,nvl(n.def14, o.def14) as def14 -- 
    ,nvl(n.def15, o.def15) as def15 -- 
    ,nvl(n.def16, o.def16) as def16 -- 
    ,nvl(n.def17, o.def17) as def17 -- 
    ,nvl(n.def18, o.def18) as def18 -- 
    ,nvl(n.def19, o.def19) as def19 -- 
    ,nvl(n.def2, o.def2) as def2 -- 
    ,nvl(n.def20, o.def20) as def20 -- 
    ,nvl(n.def3, o.def3) as def3 -- 
    ,nvl(n.def4, o.def4) as def4 -- 
    ,nvl(n.def5, o.def5) as def5 -- 
    ,nvl(n.def6, o.def6) as def6 -- 
    ,nvl(n.def7, o.def7) as def7 -- 
    ,nvl(n.def8, o.def8) as def8 -- 
    ,nvl(n.def9, o.def9) as def9 -- 
    ,nvl(n.deptcanceldate, o.deptcanceldate) as deptcanceldate -- 
    ,nvl(n.deptlevel, o.deptlevel) as deptlevel -- 
    ,nvl(n.depttype, o.depttype) as depttype -- 
    ,nvl(n.displayorder, o.displayorder) as displayorder -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 
    ,nvl(n.hrcanceled, o.hrcanceled) as hrcanceled -- 
    ,nvl(n.innercode, o.innercode) as innercode -- 
    ,nvl(n.islastversion, o.islastversion) as islastversion -- 
    ,nvl(n.isretail, o.isretail) as isretail -- 
    ,nvl(n.memo, o.memo) as memo -- 
    ,nvl(n.mnecode, o.mnecode) as mnecode -- 
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.name, o.name) as name -- 
    ,nvl(n.name2, o.name2) as name2 -- 
    ,nvl(n.name3, o.name3) as name3 -- 
    ,nvl(n.name4, o.name4) as name4 -- 
    ,nvl(n.name5, o.name5) as name5 -- 
    ,nvl(n.name6, o.name6) as name6 -- 
    ,nvl(n.orgtype13, o.orgtype13) as orgtype13 -- 
    ,nvl(n.orgtype17, o.orgtype17) as orgtype17 -- 
    ,nvl(n.pk_dept, o.pk_dept) as pk_dept -- 
    ,nvl(n.pk_fatherorg, o.pk_fatherorg) as pk_fatherorg -- 
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 
    ,nvl(n.pk_vid, o.pk_vid) as pk_vid -- 
    ,nvl(n.principal, o.principal) as principal -- 
    ,nvl(n.resposition, o.resposition) as resposition -- 
    ,nvl(n.shortname, o.shortname) as shortname -- 
    ,nvl(n.shortname2, o.shortname2) as shortname2 -- 
    ,nvl(n.shortname3, o.shortname3) as shortname3 -- 
    ,nvl(n.shortname4, o.shortname4) as shortname4 -- 
    ,nvl(n.shortname5, o.shortname5) as shortname5 -- 
    ,nvl(n.shortname6, o.shortname6) as shortname6 -- 
    ,nvl(n.tel, o.tel) as tel -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,nvl(n.venddate, o.venddate) as venddate -- 
    ,nvl(n.vname, o.vname) as vname -- 
    ,nvl(n.vname2, o.vname2) as vname2 -- 
    ,nvl(n.vname3, o.vname3) as vname3 -- 
    ,nvl(n.vname4, o.vname4) as vname4 -- 
    ,nvl(n.vname5, o.vname5) as vname5 -- 
    ,nvl(n.vname6, o.vname6) as vname6 -- 
    ,nvl(n.vno, o.vno) as vno -- 
    ,nvl(n.vstartdate, o.vstartdate) as vstartdate -- 
    ,nvl(n.deptduty, o.deptduty) as deptduty -- 
    ,nvl(n.glbdef1, o.glbdef1) as glbdef1 -- 
    ,nvl(n.glbdef2, o.glbdef2) as glbdef2 -- 
    ,nvl(n.glbdef3, o.glbdef3) as glbdef3 -- 
    ,nvl(n.glbdef4, o.glbdef4) as glbdef4 -- 
    ,nvl(n.glbdef5, o.glbdef5) as glbdef5 -- 
    ,nvl(n.glbdef6, o.glbdef6) as glbdef6 -- 
    ,nvl(n.glbdef7, o.glbdef7) as glbdef7 -- 
    ,nvl(n.glbdef8, o.glbdef8) as glbdef8 -- 
    ,nvl(n.glbdef9, o.glbdef9) as glbdef9 -- 
    ,nvl(n.glbdef10, o.glbdef10) as glbdef10 -- 
    ,nvl(n.glbdef11, o.glbdef11) as glbdef11 -- 
    ,case when
            n.pk_dept is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_dept is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_dept is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_org_dept_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_org_dept where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_dept = n.pk_dept
where (
        o.pk_dept is null
    )
    or (
        n.pk_dept is null
    )
    or (
        o.address <> n.address
        or o.code <> n.code
        or o.createdate <> n.createdate
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.def1 <> n.def1
        or o.def10 <> n.def10
        or o.def11 <> n.def11
        or o.def12 <> n.def12
        or o.def13 <> n.def13
        or o.def14 <> n.def14
        or o.def15 <> n.def15
        or o.def16 <> n.def16
        or o.def17 <> n.def17
        or o.def18 <> n.def18
        or o.def19 <> n.def19
        or o.def2 <> n.def2
        or o.def20 <> n.def20
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.def6 <> n.def6
        or o.def7 <> n.def7
        or o.def8 <> n.def8
        or o.def9 <> n.def9
        or o.deptcanceldate <> n.deptcanceldate
        or o.deptlevel <> n.deptlevel
        or o.depttype <> n.depttype
        or o.displayorder <> n.displayorder
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.hrcanceled <> n.hrcanceled
        or o.innercode <> n.innercode
        or o.islastversion <> n.islastversion
        or o.isretail <> n.isretail
        or o.memo <> n.memo
        or o.mnecode <> n.mnecode
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.orgtype13 <> n.orgtype13
        or o.orgtype17 <> n.orgtype17
        or o.pk_fatherorg <> n.pk_fatherorg
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_vid <> n.pk_vid
        or o.principal <> n.principal
        or o.resposition <> n.resposition
        or o.shortname <> n.shortname
        or o.shortname2 <> n.shortname2
        or o.shortname3 <> n.shortname3
        or o.shortname4 <> n.shortname4
        or o.shortname5 <> n.shortname5
        or o.shortname6 <> n.shortname6
        or o.tel <> n.tel
        or o.ts <> n.ts
        or o.venddate <> n.venddate
        or o.vname <> n.vname
        or o.vname2 <> n.vname2
        or o.vname3 <> n.vname3
        or o.vname4 <> n.vname4
        or o.vname5 <> n.vname5
        or o.vname6 <> n.vname6
        or o.vno <> n.vno
        or o.vstartdate <> n.vstartdate
        or o.deptduty <> n.deptduty
        or o.glbdef1 <> n.glbdef1
        or o.glbdef2 <> n.glbdef2
        or o.glbdef3 <> n.glbdef3
        or o.glbdef4 <> n.glbdef4
        or o.glbdef5 <> n.glbdef5
        or o.glbdef6 <> n.glbdef6
        or o.glbdef7 <> n.glbdef7
        or o.glbdef8 <> n.glbdef8
        or o.glbdef9 <> n.glbdef9
        or o.glbdef10 <> n.glbdef10
        or o.glbdef11 <> n.glbdef11
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_org_dept_cl(
            address -- 
            ,code -- 
            ,createdate -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,deptcanceldate -- 
            ,deptlevel -- 
            ,depttype -- 
            ,displayorder -- 
            ,dr -- 
            ,enablestate -- 
            ,hrcanceled -- 
            ,innercode -- 
            ,islastversion -- 
            ,isretail -- 
            ,memo -- 
            ,mnecode -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,orgtype13 -- 
            ,orgtype17 -- 
            ,pk_dept -- 
            ,pk_fatherorg -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_vid -- 
            ,principal -- 
            ,resposition -- 
            ,shortname -- 
            ,shortname2 -- 
            ,shortname3 -- 
            ,shortname4 -- 
            ,shortname5 -- 
            ,shortname6 -- 
            ,tel -- 
            ,ts -- 
            ,venddate -- 
            ,vname -- 
            ,vname2 -- 
            ,vname3 -- 
            ,vname4 -- 
            ,vname5 -- 
            ,vname6 -- 
            ,vno -- 
            ,vstartdate -- 
            ,deptduty -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_org_dept_op(
            address -- 
            ,code -- 
            ,createdate -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,deptcanceldate -- 
            ,deptlevel -- 
            ,depttype -- 
            ,displayorder -- 
            ,dr -- 
            ,enablestate -- 
            ,hrcanceled -- 
            ,innercode -- 
            ,islastversion -- 
            ,isretail -- 
            ,memo -- 
            ,mnecode -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,orgtype13 -- 
            ,orgtype17 -- 
            ,pk_dept -- 
            ,pk_fatherorg -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_vid -- 
            ,principal -- 
            ,resposition -- 
            ,shortname -- 
            ,shortname2 -- 
            ,shortname3 -- 
            ,shortname4 -- 
            ,shortname5 -- 
            ,shortname6 -- 
            ,tel -- 
            ,ts -- 
            ,venddate -- 
            ,vname -- 
            ,vname2 -- 
            ,vname3 -- 
            ,vname4 -- 
            ,vname5 -- 
            ,vname6 -- 
            ,vno -- 
            ,vstartdate -- 
            ,deptduty -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.address -- 
    ,o.code -- 
    ,o.createdate -- 
    ,o.creationtime -- 
    ,o.creator -- 
    ,o.dataoriginflag -- 
    ,o.def1 -- 
    ,o.def10 -- 
    ,o.def11 -- 
    ,o.def12 -- 
    ,o.def13 -- 
    ,o.def14 -- 
    ,o.def15 -- 
    ,o.def16 -- 
    ,o.def17 -- 
    ,o.def18 -- 
    ,o.def19 -- 
    ,o.def2 -- 
    ,o.def20 -- 
    ,o.def3 -- 
    ,o.def4 -- 
    ,o.def5 -- 
    ,o.def6 -- 
    ,o.def7 -- 
    ,o.def8 -- 
    ,o.def9 -- 
    ,o.deptcanceldate -- 
    ,o.deptlevel -- 
    ,o.depttype -- 
    ,o.displayorder -- 
    ,o.dr -- 
    ,o.enablestate -- 
    ,o.hrcanceled -- 
    ,o.innercode -- 
    ,o.islastversion -- 
    ,o.isretail -- 
    ,o.memo -- 
    ,o.mnecode -- 
    ,o.modifiedtime -- 
    ,o.modifier -- 
    ,o.name -- 
    ,o.name2 -- 
    ,o.name3 -- 
    ,o.name4 -- 
    ,o.name5 -- 
    ,o.name6 -- 
    ,o.orgtype13 -- 
    ,o.orgtype17 -- 
    ,o.pk_dept -- 
    ,o.pk_fatherorg -- 
    ,o.pk_group -- 
    ,o.pk_org -- 
    ,o.pk_vid -- 
    ,o.principal -- 
    ,o.resposition -- 
    ,o.shortname -- 
    ,o.shortname2 -- 
    ,o.shortname3 -- 
    ,o.shortname4 -- 
    ,o.shortname5 -- 
    ,o.shortname6 -- 
    ,o.tel -- 
    ,o.ts -- 
    ,o.venddate -- 
    ,o.vname -- 
    ,o.vname2 -- 
    ,o.vname3 -- 
    ,o.vname4 -- 
    ,o.vname5 -- 
    ,o.vname6 -- 
    ,o.vno -- 
    ,o.vstartdate -- 
    ,o.deptduty -- 
    ,o.glbdef1 -- 
    ,o.glbdef2 -- 
    ,o.glbdef3 -- 
    ,o.glbdef4 -- 
    ,o.glbdef5 -- 
    ,o.glbdef6 -- 
    ,o.glbdef7 -- 
    ,o.glbdef8 -- 
    ,o.glbdef9 -- 
    ,o.glbdef10 -- 
    ,o.glbdef11 -- 
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
from ${iol_schema}.nhrs_org_dept_bk o
    left join ${iol_schema}.nhrs_org_dept_op n
        on
            o.pk_dept = n.pk_dept
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_org_dept_cl d
        on
            o.pk_dept = d.pk_dept
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_org_dept;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_org_dept') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_org_dept drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_org_dept add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_org_dept exchange partition p_${batch_date} with table ${iol_schema}.nhrs_org_dept_cl;
alter table ${iol_schema}.nhrs_org_dept exchange partition p_20991231 with table ${iol_schema}.nhrs_org_dept_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_org_dept to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_org_dept_op purge;
drop table ${iol_schema}.nhrs_org_dept_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_org_dept_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_org_dept',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
