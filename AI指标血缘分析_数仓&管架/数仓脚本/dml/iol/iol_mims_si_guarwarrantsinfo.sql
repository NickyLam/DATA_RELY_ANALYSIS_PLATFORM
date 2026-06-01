/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_guarwarrantsinfo
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
create table ${iol_schema}.mims_si_guarwarrantsinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_guarwarrantsinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_guarwarrantsinfo_op purge;
drop table ${iol_schema}.mims_si_guarwarrantsinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarwarrantsinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_guarwarrantsinfo where 0=1;

create table ${iol_schema}.mims_si_guarwarrantsinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_guarwarrantsinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_guarwarrantsinfo_cl(
            guartype -- 
            ,guarname -- 
            ,upguartype -- 
            ,levelcode -- 
            ,isleaf -- 
            ,tname -- 
            ,financialcolumn -- 
            ,keycolumn -- 
            ,effecttype -- 
            ,controlwarrants -- 
            ,companyguarrate -- 
            ,personalguarrate -- 
            ,smallcompanyguarrate -- 
            ,guaranteeaccexplain -- 
            ,state -- 
            ,allenterystatus -- 
            ,financespecialinfo -- 
            ,datavalidation -- 
            ,reportvalidation -- 
            ,motime -- 
            ,deptcode -- 
            ,isall -- 
            ,datatype -- 
            ,guaranteetype -- 
            ,modifier -- 
            ,evalfrequency -- 
            ,risklevel -- 
            ,highestguarrate -- 
            ,keycolumn1 -- 
            ,genera -- 
            ,isneedpeoplecheck -- 
            ,fz -- 
            ,barsign -- 
            ,jzcp -- 
            ,abtype -- 
            ,isunion -- 
            ,idneeduniquecheck -- 
            ,coltypesubmcali -- 押品大类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_guarwarrantsinfo_op(
            guartype -- 
            ,guarname -- 
            ,upguartype -- 
            ,levelcode -- 
            ,isleaf -- 
            ,tname -- 
            ,financialcolumn -- 
            ,keycolumn -- 
            ,effecttype -- 
            ,controlwarrants -- 
            ,companyguarrate -- 
            ,personalguarrate -- 
            ,smallcompanyguarrate -- 
            ,guaranteeaccexplain -- 
            ,state -- 
            ,allenterystatus -- 
            ,financespecialinfo -- 
            ,datavalidation -- 
            ,reportvalidation -- 
            ,motime -- 
            ,deptcode -- 
            ,isall -- 
            ,datatype -- 
            ,guaranteetype -- 
            ,modifier -- 
            ,evalfrequency -- 
            ,risklevel -- 
            ,highestguarrate -- 
            ,keycolumn1 -- 
            ,genera -- 
            ,isneedpeoplecheck -- 
            ,fz -- 
            ,barsign -- 
            ,jzcp -- 
            ,abtype -- 
            ,isunion -- 
            ,idneeduniquecheck -- 
            ,coltypesubmcali -- 押品大类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.guartype, o.guartype) as guartype -- 
    ,nvl(n.guarname, o.guarname) as guarname -- 
    ,nvl(n.upguartype, o.upguartype) as upguartype -- 
    ,nvl(n.levelcode, o.levelcode) as levelcode -- 
    ,nvl(n.isleaf, o.isleaf) as isleaf -- 
    ,nvl(n.tname, o.tname) as tname -- 
    ,nvl(n.financialcolumn, o.financialcolumn) as financialcolumn -- 
    ,nvl(n.keycolumn, o.keycolumn) as keycolumn -- 
    ,nvl(n.effecttype, o.effecttype) as effecttype -- 
    ,nvl(n.controlwarrants, o.controlwarrants) as controlwarrants -- 
    ,nvl(n.companyguarrate, o.companyguarrate) as companyguarrate -- 
    ,nvl(n.personalguarrate, o.personalguarrate) as personalguarrate -- 
    ,nvl(n.smallcompanyguarrate, o.smallcompanyguarrate) as smallcompanyguarrate -- 
    ,nvl(n.guaranteeaccexplain, o.guaranteeaccexplain) as guaranteeaccexplain -- 
    ,nvl(n.state, o.state) as state -- 
    ,nvl(n.allenterystatus, o.allenterystatus) as allenterystatus -- 
    ,nvl(n.financespecialinfo, o.financespecialinfo) as financespecialinfo -- 
    ,nvl(n.datavalidation, o.datavalidation) as datavalidation -- 
    ,nvl(n.reportvalidation, o.reportvalidation) as reportvalidation -- 
    ,nvl(n.motime, o.motime) as motime -- 
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 
    ,nvl(n.isall, o.isall) as isall -- 
    ,nvl(n.datatype, o.datatype) as datatype -- 
    ,nvl(n.guaranteetype, o.guaranteetype) as guaranteetype -- 
    ,nvl(n.modifier, o.modifier) as modifier -- 
    ,nvl(n.evalfrequency, o.evalfrequency) as evalfrequency -- 
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 
    ,nvl(n.highestguarrate, o.highestguarrate) as highestguarrate -- 
    ,nvl(n.keycolumn1, o.keycolumn1) as keycolumn1 -- 
    ,nvl(n.genera, o.genera) as genera -- 
    ,nvl(n.isneedpeoplecheck, o.isneedpeoplecheck) as isneedpeoplecheck -- 
    ,nvl(n.fz, o.fz) as fz -- 
    ,nvl(n.barsign, o.barsign) as barsign -- 
    ,nvl(n.jzcp, o.jzcp) as jzcp -- 
    ,nvl(n.abtype, o.abtype) as abtype -- 
    ,nvl(n.isunion, o.isunion) as isunion -- 
    ,nvl(n.idneeduniquecheck, o.idneeduniquecheck) as idneeduniquecheck -- 
    ,nvl(n.coltypesubmcali, o.coltypesubmcali) as coltypesubmcali -- 押品大类
    ,case when
            n.guartype is null
            and n.barsign is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.guartype is null
            and n.barsign is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.guartype is null
            and n.barsign is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_guarwarrantsinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_guarwarrantsinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.guartype = n.guartype
            and o.barsign = n.barsign
where (
        o.guartype is null
        and o.barsign is null
    )
    or (
        n.guartype is null
        and n.barsign is null
    )
    or (
        o.guarname <> n.guarname
        or o.upguartype <> n.upguartype
        or o.levelcode <> n.levelcode
        or o.isleaf <> n.isleaf
        or o.tname <> n.tname
        or o.financialcolumn <> n.financialcolumn
        or o.keycolumn <> n.keycolumn
        or o.effecttype <> n.effecttype
        or o.controlwarrants <> n.controlwarrants
        or o.companyguarrate <> n.companyguarrate
        or o.personalguarrate <> n.personalguarrate
        or o.smallcompanyguarrate <> n.smallcompanyguarrate
        or o.guaranteeaccexplain <> n.guaranteeaccexplain
        or o.state <> n.state
        or o.allenterystatus <> n.allenterystatus
        or o.financespecialinfo <> n.financespecialinfo
        or o.datavalidation <> n.datavalidation
        or o.reportvalidation <> n.reportvalidation
        or o.motime <> n.motime
        or o.deptcode <> n.deptcode
        or o.isall <> n.isall
        or o.datatype <> n.datatype
        or o.guaranteetype <> n.guaranteetype
        or o.modifier <> n.modifier
        or o.evalfrequency <> n.evalfrequency
        or o.risklevel <> n.risklevel
        or o.highestguarrate <> n.highestguarrate
        or o.keycolumn1 <> n.keycolumn1
        or o.genera <> n.genera
        or o.isneedpeoplecheck <> n.isneedpeoplecheck
        or o.fz <> n.fz
        or o.jzcp <> n.jzcp
        or o.abtype <> n.abtype
        or o.isunion <> n.isunion
        or o.idneeduniquecheck <> n.idneeduniquecheck
        or o.coltypesubmcali <> n.coltypesubmcali
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_guarwarrantsinfo_cl(
            guartype -- 
            ,guarname -- 
            ,upguartype -- 
            ,levelcode -- 
            ,isleaf -- 
            ,tname -- 
            ,financialcolumn -- 
            ,keycolumn -- 
            ,effecttype -- 
            ,controlwarrants -- 
            ,companyguarrate -- 
            ,personalguarrate -- 
            ,smallcompanyguarrate -- 
            ,guaranteeaccexplain -- 
            ,state -- 
            ,allenterystatus -- 
            ,financespecialinfo -- 
            ,datavalidation -- 
            ,reportvalidation -- 
            ,motime -- 
            ,deptcode -- 
            ,isall -- 
            ,datatype -- 
            ,guaranteetype -- 
            ,modifier -- 
            ,evalfrequency -- 
            ,risklevel -- 
            ,highestguarrate -- 
            ,keycolumn1 -- 
            ,genera -- 
            ,isneedpeoplecheck -- 
            ,fz -- 
            ,barsign -- 
            ,jzcp -- 
            ,abtype -- 
            ,isunion -- 
            ,idneeduniquecheck -- 
            ,coltypesubmcali -- 押品大类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_guarwarrantsinfo_op(
            guartype -- 
            ,guarname -- 
            ,upguartype -- 
            ,levelcode -- 
            ,isleaf -- 
            ,tname -- 
            ,financialcolumn -- 
            ,keycolumn -- 
            ,effecttype -- 
            ,controlwarrants -- 
            ,companyguarrate -- 
            ,personalguarrate -- 
            ,smallcompanyguarrate -- 
            ,guaranteeaccexplain -- 
            ,state -- 
            ,allenterystatus -- 
            ,financespecialinfo -- 
            ,datavalidation -- 
            ,reportvalidation -- 
            ,motime -- 
            ,deptcode -- 
            ,isall -- 
            ,datatype -- 
            ,guaranteetype -- 
            ,modifier -- 
            ,evalfrequency -- 
            ,risklevel -- 
            ,highestguarrate -- 
            ,keycolumn1 -- 
            ,genera -- 
            ,isneedpeoplecheck -- 
            ,fz -- 
            ,barsign -- 
            ,jzcp -- 
            ,abtype -- 
            ,isunion -- 
            ,idneeduniquecheck -- 
            ,coltypesubmcali -- 押品大类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.guartype -- 
    ,o.guarname -- 
    ,o.upguartype -- 
    ,o.levelcode -- 
    ,o.isleaf -- 
    ,o.tname -- 
    ,o.financialcolumn -- 
    ,o.keycolumn -- 
    ,o.effecttype -- 
    ,o.controlwarrants -- 
    ,o.companyguarrate -- 
    ,o.personalguarrate -- 
    ,o.smallcompanyguarrate -- 
    ,o.guaranteeaccexplain -- 
    ,o.state -- 
    ,o.allenterystatus -- 
    ,o.financespecialinfo -- 
    ,o.datavalidation -- 
    ,o.reportvalidation -- 
    ,o.motime -- 
    ,o.deptcode -- 
    ,o.isall -- 
    ,o.datatype -- 
    ,o.guaranteetype -- 
    ,o.modifier -- 
    ,o.evalfrequency -- 
    ,o.risklevel -- 
    ,o.highestguarrate -- 
    ,o.keycolumn1 -- 
    ,o.genera -- 
    ,o.isneedpeoplecheck -- 
    ,o.fz -- 
    ,o.barsign -- 
    ,o.jzcp -- 
    ,o.abtype -- 
    ,o.isunion -- 
    ,o.idneeduniquecheck -- 
    ,o.coltypesubmcali -- 押品大类
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
from ${iol_schema}.mims_si_guarwarrantsinfo_bk o
    left join ${iol_schema}.mims_si_guarwarrantsinfo_op n
        on
            o.guartype = n.guartype
            and o.barsign = n.barsign
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_guarwarrantsinfo_cl d
        on
            o.guartype = d.guartype
            and o.barsign = d.barsign
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_si_guarwarrantsinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_guarwarrantsinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_guarwarrantsinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_guarwarrantsinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_guarwarrantsinfo exchange partition p_${batch_date} with table ${iol_schema}.mims_si_guarwarrantsinfo_cl;
alter table ${iol_schema}.mims_si_guarwarrantsinfo exchange partition p_20991231 with table ${iol_schema}.mims_si_guarwarrantsinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_guarwarrantsinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_guarwarrantsinfo_op purge;
drop table ${iol_schema}.mims_si_guarwarrantsinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_guarwarrantsinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_guarwarrantsinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
