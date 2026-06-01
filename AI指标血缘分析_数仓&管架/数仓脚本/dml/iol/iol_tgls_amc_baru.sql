/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_amc_baru
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
create table ${iol_schema}.tgls_amc_baru_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_amc_baru
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_baru_op purge;
drop table ${iol_schema}.tgls_amc_baru_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_baru_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_baru where 0=1;

create table ${iol_schema}.tgls_amc_baru_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_baru where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_baru_cl(
            stacid -- 账套标记
            ,acruid -- 会计规则表主键
            ,busitp -- 业务类型
            ,acelto -- 目标要素
            ,acelna -- 目标要素名称
            ,condcd -- 执行条件
            ,scelfm -- 来源要素
            ,scelna -- 来源要素名称
            ,defval -- 赋常数值
            ,vlidtg -- 是否启用
            ,sortno -- 排序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_baru_op(
            stacid -- 账套标记
            ,acruid -- 会计规则表主键
            ,busitp -- 业务类型
            ,acelto -- 目标要素
            ,acelna -- 目标要素名称
            ,condcd -- 执行条件
            ,scelfm -- 来源要素
            ,scelna -- 来源要素名称
            ,defval -- 赋常数值
            ,vlidtg -- 是否启用
            ,sortno -- 排序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.acruid, o.acruid) as acruid -- 会计规则表主键
    ,nvl(n.busitp, o.busitp) as busitp -- 业务类型
    ,nvl(n.acelto, o.acelto) as acelto -- 目标要素
    ,nvl(n.acelna, o.acelna) as acelna -- 目标要素名称
    ,nvl(n.condcd, o.condcd) as condcd -- 执行条件
    ,nvl(n.scelfm, o.scelfm) as scelfm -- 来源要素
    ,nvl(n.scelna, o.scelna) as scelna -- 来源要素名称
    ,nvl(n.defval, o.defval) as defval -- 赋常数值
    ,nvl(n.vlidtg, o.vlidtg) as vlidtg -- 是否启用
    ,nvl(n.sortno, o.sortno) as sortno -- 排序
    ,case when
            n.stacid is null
            and n.acruid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.acruid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.acruid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_amc_baru_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_amc_baru where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.acruid = n.acruid
where (
        o.stacid is null
        and o.acruid is null
    )
    or (
        n.stacid is null
        and n.acruid is null
    )
    or (
        o.busitp <> n.busitp
        or o.acelto <> n.acelto
        or o.acelna <> n.acelna
        or o.condcd <> n.condcd
        or o.scelfm <> n.scelfm
        or o.scelna <> n.scelna
        or o.defval <> n.defval
        or o.vlidtg <> n.vlidtg
        or o.sortno <> n.sortno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_baru_cl(
            stacid -- 账套标记
            ,acruid -- 会计规则表主键
            ,busitp -- 业务类型
            ,acelto -- 目标要素
            ,acelna -- 目标要素名称
            ,condcd -- 执行条件
            ,scelfm -- 来源要素
            ,scelna -- 来源要素名称
            ,defval -- 赋常数值
            ,vlidtg -- 是否启用
            ,sortno -- 排序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_baru_op(
            stacid -- 账套标记
            ,acruid -- 会计规则表主键
            ,busitp -- 业务类型
            ,acelto -- 目标要素
            ,acelna -- 目标要素名称
            ,condcd -- 执行条件
            ,scelfm -- 来源要素
            ,scelna -- 来源要素名称
            ,defval -- 赋常数值
            ,vlidtg -- 是否启用
            ,sortno -- 排序
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.acruid -- 会计规则表主键
    ,o.busitp -- 业务类型
    ,o.acelto -- 目标要素
    ,o.acelna -- 目标要素名称
    ,o.condcd -- 执行条件
    ,o.scelfm -- 来源要素
    ,o.scelna -- 来源要素名称
    ,o.defval -- 赋常数值
    ,o.vlidtg -- 是否启用
    ,o.sortno -- 排序
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
from ${iol_schema}.tgls_amc_baru_bk o
    left join ${iol_schema}.tgls_amc_baru_op n
        on
            o.stacid = n.stacid
            and o.acruid = n.acruid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_amc_baru_cl d
        on
            o.stacid = d.stacid
            and o.acruid = d.acruid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_amc_baru;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_amc_baru') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_amc_baru drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_amc_baru add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_amc_baru exchange partition p_${batch_date} with table ${iol_schema}.tgls_amc_baru_cl;
alter table ${iol_schema}.tgls_amc_baru exchange partition p_20991231 with table ${iol_schema}.tgls_amc_baru_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_amc_baru to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_baru_op purge;
drop table ${iol_schema}.tgls_amc_baru_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_amc_baru_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_amc_baru',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
