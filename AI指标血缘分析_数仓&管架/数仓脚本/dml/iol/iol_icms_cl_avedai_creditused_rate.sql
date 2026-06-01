/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_avedai_creditused_rate
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
create table ${iol_schema}.icms_cl_avedai_creditused_rate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cl_avedai_creditused_rate
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_avedai_creditused_rate_op purge;
drop table ${iol_schema}.icms_cl_avedai_creditused_rate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_avedai_creditused_rate_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_avedai_creditused_rate where 0=1;

create table ${iol_schema}.icms_cl_avedai_creditused_rate_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_avedai_creditused_rate where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_avedai_creditused_rate_cl(
            datadate -- 数据日期
            ,updateuserid -- 最后更新人
            ,updatedate -- 最后更新日期
            ,lmecreditusedrate -- 大中客户日均用信率
            ,updateorgid -- 最后更新机构
            ,individualcreditusedrate -- 个人客户日均用信率
            ,smecreditusedrate -- 小微客户日均用信率
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_avedai_creditused_rate_op(
            datadate -- 数据日期
            ,updateuserid -- 最后更新人
            ,updatedate -- 最后更新日期
            ,lmecreditusedrate -- 大中客户日均用信率
            ,updateorgid -- 最后更新机构
            ,individualcreditusedrate -- 个人客户日均用信率
            ,smecreditusedrate -- 小微客户日均用信率
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.datadate, o.datadate) as datadate -- 数据日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 最后更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 最后更新日期
    ,nvl(n.lmecreditusedrate, o.lmecreditusedrate) as lmecreditusedrate -- 大中客户日均用信率
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 最后更新机构
    ,nvl(n.individualcreditusedrate, o.individualcreditusedrate) as individualcreditusedrate -- 个人客户日均用信率
    ,nvl(n.smecreditusedrate, o.smecreditusedrate) as smecreditusedrate -- 小微客户日均用信率
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,case when
            n.datadate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.datadate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.datadate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_cl_avedai_creditused_rate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cl_avedai_creditused_rate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.datadate = n.datadate
where (
        o.datadate is null
    )
    or (
        n.datadate is null
    )
    or (
        o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.lmecreditusedrate <> n.lmecreditusedrate
        or o.updateorgid <> n.updateorgid
        or o.individualcreditusedrate <> n.individualcreditusedrate
        or o.smecreditusedrate <> n.smecreditusedrate
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_avedai_creditused_rate_cl(
            datadate -- 数据日期
            ,updateuserid -- 最后更新人
            ,updatedate -- 最后更新日期
            ,lmecreditusedrate -- 大中客户日均用信率
            ,updateorgid -- 最后更新机构
            ,individualcreditusedrate -- 个人客户日均用信率
            ,smecreditusedrate -- 小微客户日均用信率
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_avedai_creditused_rate_op(
            datadate -- 数据日期
            ,updateuserid -- 最后更新人
            ,updatedate -- 最后更新日期
            ,lmecreditusedrate -- 大中客户日均用信率
            ,updateorgid -- 最后更新机构
            ,individualcreditusedrate -- 个人客户日均用信率
            ,smecreditusedrate -- 小微客户日均用信率
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.datadate -- 数据日期
    ,o.updateuserid -- 最后更新人
    ,o.updatedate -- 最后更新日期
    ,o.lmecreditusedrate -- 大中客户日均用信率
    ,o.updateorgid -- 最后更新机构
    ,o.individualcreditusedrate -- 个人客户日均用信率
    ,o.smecreditusedrate -- 小微客户日均用信率
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
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
from ${iol_schema}.icms_cl_avedai_creditused_rate_bk o
    left join ${iol_schema}.icms_cl_avedai_creditused_rate_op n
        on
            o.datadate = n.datadate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cl_avedai_creditused_rate_cl d
        on
            o.datadate = d.datadate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_cl_avedai_creditused_rate;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cl_avedai_creditused_rate') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cl_avedai_creditused_rate drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cl_avedai_creditused_rate add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cl_avedai_creditused_rate exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_avedai_creditused_rate_cl;
alter table ${iol_schema}.icms_cl_avedai_creditused_rate exchange partition p_20991231 with table ${iol_schema}.icms_cl_avedai_creditused_rate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_avedai_creditused_rate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_avedai_creditused_rate_op purge;
drop table ${iol_schema}.icms_cl_avedai_creditused_rate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cl_avedai_creditused_rate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_avedai_creditused_rate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
