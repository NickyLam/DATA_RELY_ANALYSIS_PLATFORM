/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_cpmtinst
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
create table ${iol_schema}.mpcs_cpmtinst_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_cpmtinst;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_cpmtinst_op purge;
drop table ${iol_schema}.mpcs_cpmtinst_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_cpmtinst_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_cpmtinst where 0=1;

create table ${iol_schema}.mpcs_cpmtinst_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_cpmtinst where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_cpmtinst_cl(
            instno -- 
            ,upinstno -- 
            ,instlvl -- 
            ,instname -- 
            ,instabrname -- 
            ,instaddr -- 
            ,instenname -- 
            ,instenabrname -- 
            ,instenaddr -- 
            ,insttel -- 
            ,instemail -- 
            ,insttype -- 
            ,centflag -- 
            ,seqnoprefix -- 
            ,acctinstlvl -- 
            ,upacctinst -- 
            ,bankno -- 
            ,citycd -- 
            ,isleaf -- 
            ,rowstat -- 
            ,upddt -- 
            ,updtm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_cpmtinst_op(
            instno -- 
            ,upinstno -- 
            ,instlvl -- 
            ,instname -- 
            ,instabrname -- 
            ,instaddr -- 
            ,instenname -- 
            ,instenabrname -- 
            ,instenaddr -- 
            ,insttel -- 
            ,instemail -- 
            ,insttype -- 
            ,centflag -- 
            ,seqnoprefix -- 
            ,acctinstlvl -- 
            ,upacctinst -- 
            ,bankno -- 
            ,citycd -- 
            ,isleaf -- 
            ,rowstat -- 
            ,upddt -- 
            ,updtm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.instno, o.instno) as instno -- 
    ,nvl(n.upinstno, o.upinstno) as upinstno -- 
    ,nvl(n.instlvl, o.instlvl) as instlvl -- 
    ,nvl(n.instname, o.instname) as instname -- 
    ,nvl(n.instabrname, o.instabrname) as instabrname -- 
    ,nvl(n.instaddr, o.instaddr) as instaddr -- 
    ,nvl(n.instenname, o.instenname) as instenname -- 
    ,nvl(n.instenabrname, o.instenabrname) as instenabrname -- 
    ,nvl(n.instenaddr, o.instenaddr) as instenaddr -- 
    ,nvl(n.insttel, o.insttel) as insttel -- 
    ,nvl(n.instemail, o.instemail) as instemail -- 
    ,nvl(n.insttype, o.insttype) as insttype -- 
    ,nvl(n.centflag, o.centflag) as centflag -- 
    ,nvl(n.seqnoprefix, o.seqnoprefix) as seqnoprefix -- 
    ,nvl(n.acctinstlvl, o.acctinstlvl) as acctinstlvl -- 
    ,nvl(n.upacctinst, o.upacctinst) as upacctinst -- 
    ,nvl(n.bankno, o.bankno) as bankno -- 
    ,nvl(n.citycd, o.citycd) as citycd -- 
    ,nvl(n.isleaf, o.isleaf) as isleaf -- 
    ,nvl(n.rowstat, o.rowstat) as rowstat -- 
    ,nvl(n.upddt, o.upddt) as upddt -- 
    ,nvl(n.updtm, o.updtm) as updtm -- 
    ,case when
            n.instno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.instno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.instno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_cpmtinst_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_cpmtinst where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.instno = n.instno
where (
        o.instno is null
    )
    or (
        n.instno is null
    )
    or (
        o.upinstno <> n.upinstno
        or o.instlvl <> n.instlvl
        or o.instname <> n.instname
        or o.instabrname <> n.instabrname
        or o.instaddr <> n.instaddr
        or o.instenname <> n.instenname
        or o.instenabrname <> n.instenabrname
        or o.instenaddr <> n.instenaddr
        or o.insttel <> n.insttel
        or o.instemail <> n.instemail
        or o.insttype <> n.insttype
        or o.centflag <> n.centflag
        or o.seqnoprefix <> n.seqnoprefix
        or o.acctinstlvl <> n.acctinstlvl
        or o.upacctinst <> n.upacctinst
        or o.bankno <> n.bankno
        or o.citycd <> n.citycd
        or o.isleaf <> n.isleaf
        or o.rowstat <> n.rowstat
        or o.upddt <> n.upddt
        or o.updtm <> n.updtm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_cpmtinst_cl(
            instno -- 
            ,upinstno -- 
            ,instlvl -- 
            ,instname -- 
            ,instabrname -- 
            ,instaddr -- 
            ,instenname -- 
            ,instenabrname -- 
            ,instenaddr -- 
            ,insttel -- 
            ,instemail -- 
            ,insttype -- 
            ,centflag -- 
            ,seqnoprefix -- 
            ,acctinstlvl -- 
            ,upacctinst -- 
            ,bankno -- 
            ,citycd -- 
            ,isleaf -- 
            ,rowstat -- 
            ,upddt -- 
            ,updtm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_cpmtinst_op(
            instno -- 
            ,upinstno -- 
            ,instlvl -- 
            ,instname -- 
            ,instabrname -- 
            ,instaddr -- 
            ,instenname -- 
            ,instenabrname -- 
            ,instenaddr -- 
            ,insttel -- 
            ,instemail -- 
            ,insttype -- 
            ,centflag -- 
            ,seqnoprefix -- 
            ,acctinstlvl -- 
            ,upacctinst -- 
            ,bankno -- 
            ,citycd -- 
            ,isleaf -- 
            ,rowstat -- 
            ,upddt -- 
            ,updtm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.instno -- 
    ,o.upinstno -- 
    ,o.instlvl -- 
    ,o.instname -- 
    ,o.instabrname -- 
    ,o.instaddr -- 
    ,o.instenname -- 
    ,o.instenabrname -- 
    ,o.instenaddr -- 
    ,o.insttel -- 
    ,o.instemail -- 
    ,o.insttype -- 
    ,o.centflag -- 
    ,o.seqnoprefix -- 
    ,o.acctinstlvl -- 
    ,o.upacctinst -- 
    ,o.bankno -- 
    ,o.citycd -- 
    ,o.isleaf -- 
    ,o.rowstat -- 
    ,o.upddt -- 
    ,o.updtm -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_cpmtinst_bk o
    left join ${iol_schema}.mpcs_cpmtinst_op n
        on
            o.instno = n.instno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_cpmtinst_cl d
        on
            o.instno = d.instno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_cpmtinst;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_cpmtinst exchange partition p_19000101 with table ${iol_schema}.mpcs_cpmtinst_cl;
alter table ${iol_schema}.mpcs_cpmtinst exchange partition p_20991231 with table ${iol_schema}.mpcs_cpmtinst_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_cpmtinst to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_cpmtinst_op purge;
drop table ${iol_schema}.mpcs_cpmtinst_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_cpmtinst_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_cpmtinst',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
