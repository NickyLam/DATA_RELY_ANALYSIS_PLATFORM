/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_trappl_history
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
create table ${iol_schema}.icms_clr_trappl_history_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_trappl_history
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_trappl_history_op purge;
drop table ${iol_schema}.icms_clr_trappl_history_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_trappl_history_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_trappl_history where 0=1;

create table ${iol_schema}.icms_clr_trappl_history_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_trappl_history where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_trappl_history_cl(
            businessinsid -- 出入库申请任务流水号
            ,clrid -- 押品编号
            ,clrtypeid -- 押品类型
            ,confmamt -- 我行确认价值
            ,confmcurrency -- 我行确认价值币种
            ,trapplstatus -- 出入库状态
            ,busovetime -- 出入库时间
            ,createuser -- 创建人
            ,deptcode -- 所属机构
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_trappl_history_op(
            businessinsid -- 出入库申请任务流水号
            ,clrid -- 押品编号
            ,clrtypeid -- 押品类型
            ,confmamt -- 我行确认价值
            ,confmcurrency -- 我行确认价值币种
            ,trapplstatus -- 出入库状态
            ,busovetime -- 出入库时间
            ,createuser -- 创建人
            ,deptcode -- 所属机构
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.businessinsid, o.businessinsid) as businessinsid -- 出入库申请任务流水号
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.clrtypeid, o.clrtypeid) as clrtypeid -- 押品类型
    ,nvl(n.confmamt, o.confmamt) as confmamt -- 我行确认价值
    ,nvl(n.confmcurrency, o.confmcurrency) as confmcurrency -- 我行确认价值币种
    ,nvl(n.trapplstatus, o.trapplstatus) as trapplstatus -- 出入库状态
    ,nvl(n.busovetime, o.busovetime) as busovetime -- 出入库时间
    ,nvl(n.createuser, o.createuser) as createuser -- 创建人
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 所属机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.businessinsid is null
            and n.clrid is null
            and n.trapplstatus is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.businessinsid is null
            and n.clrid is null
            and n.trapplstatus is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.businessinsid is null
            and n.clrid is null
            and n.trapplstatus is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_trappl_history_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_trappl_history where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.businessinsid = n.businessinsid
            and o.clrid = n.clrid
            and o.trapplstatus = n.trapplstatus
where (
        o.businessinsid is null
        and o.clrid is null
        and o.trapplstatus is null
    )
    or (
        n.businessinsid is null
        and n.clrid is null
        and n.trapplstatus is null
    )
    or (
        o.clrtypeid <> n.clrtypeid
        or o.confmamt <> n.confmamt
        or o.confmcurrency <> n.confmcurrency
        or o.busovetime <> n.busovetime
        or o.createuser <> n.createuser
        or o.deptcode <> n.deptcode
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_trappl_history_cl(
            businessinsid -- 出入库申请任务流水号
            ,clrid -- 押品编号
            ,clrtypeid -- 押品类型
            ,confmamt -- 我行确认价值
            ,confmcurrency -- 我行确认价值币种
            ,trapplstatus -- 出入库状态
            ,busovetime -- 出入库时间
            ,createuser -- 创建人
            ,deptcode -- 所属机构
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_trappl_history_op(
            businessinsid -- 出入库申请任务流水号
            ,clrid -- 押品编号
            ,clrtypeid -- 押品类型
            ,confmamt -- 我行确认价值
            ,confmcurrency -- 我行确认价值币种
            ,trapplstatus -- 出入库状态
            ,busovetime -- 出入库时间
            ,createuser -- 创建人
            ,deptcode -- 所属机构
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.businessinsid -- 出入库申请任务流水号
    ,o.clrid -- 押品编号
    ,o.clrtypeid -- 押品类型
    ,o.confmamt -- 我行确认价值
    ,o.confmcurrency -- 我行确认价值币种
    ,o.trapplstatus -- 出入库状态
    ,o.busovetime -- 出入库时间
    ,o.createuser -- 创建人
    ,o.deptcode -- 所属机构
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_trappl_history_bk o
    left join ${iol_schema}.icms_clr_trappl_history_op n
        on
            o.businessinsid = n.businessinsid
            and o.clrid = n.clrid
            and o.trapplstatus = n.trapplstatus
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_trappl_history_cl d
        on
            o.businessinsid = d.businessinsid
            and o.clrid = d.clrid
            and o.trapplstatus = d.trapplstatus
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_trappl_history;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_trappl_history') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_trappl_history drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_trappl_history add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_trappl_history exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_trappl_history_cl;
alter table ${iol_schema}.icms_clr_trappl_history exchange partition p_20991231 with table ${iol_schema}.icms_clr_trappl_history_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_trappl_history to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_trappl_history_op purge;
drop table ${iol_schema}.icms_clr_trappl_history_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_trappl_history_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_trappl_history',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
