/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_vchr_iomp_detl
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
create table ${iol_schema}.tgls_vchr_iomp_detl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_vchr_iomp_detl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_vchr_iomp_detl_op purge;
drop table ${iol_schema}.tgls_vchr_iomp_detl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_vchr_iomp_detl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_vchr_iomp_detl where 0=1;

create table ${iol_schema}.tgls_vchr_iomp_detl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_vchr_iomp_detl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_vchr_iomp_detl_cl(
            module -- 业务类型
            ,tovacd -- 目标变量编码
            ,tovana -- 目标变量名称
            ,ordeid -- 序号
            ,varitp -- 目标类型（1固定区域2扩展区域）
            ,fmvacd -- 来源变量编码
            ,fmvana -- 来源变量名称
            ,desctx -- 备注说明
            ,updati -- 更新时间（目前未使用）
            ,updaid -- 更新id（目前未使用）
            ,creati -- 创建时间（目前未使用）
            ,creaid -- 创建id（目前未使用）
            ,stacid -- 账套标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_vchr_iomp_detl_op(
            module -- 业务类型
            ,tovacd -- 目标变量编码
            ,tovana -- 目标变量名称
            ,ordeid -- 序号
            ,varitp -- 目标类型（1固定区域2扩展区域）
            ,fmvacd -- 来源变量编码
            ,fmvana -- 来源变量名称
            ,desctx -- 备注说明
            ,updati -- 更新时间（目前未使用）
            ,updaid -- 更新id（目前未使用）
            ,creati -- 创建时间（目前未使用）
            ,creaid -- 创建id（目前未使用）
            ,stacid -- 账套标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.module, o.module) as module -- 业务类型
    ,nvl(n.tovacd, o.tovacd) as tovacd -- 目标变量编码
    ,nvl(n.tovana, o.tovana) as tovana -- 目标变量名称
    ,nvl(n.ordeid, o.ordeid) as ordeid -- 序号
    ,nvl(n.varitp, o.varitp) as varitp -- 目标类型（1固定区域2扩展区域）
    ,nvl(n.fmvacd, o.fmvacd) as fmvacd -- 来源变量编码
    ,nvl(n.fmvana, o.fmvana) as fmvana -- 来源变量名称
    ,nvl(n.desctx, o.desctx) as desctx -- 备注说明
    ,nvl(n.updati, o.updati) as updati -- 更新时间（目前未使用）
    ,nvl(n.updaid, o.updaid) as updaid -- 更新id（目前未使用）
    ,nvl(n.creati, o.creati) as creati -- 创建时间（目前未使用）
    ,nvl(n.creaid, o.creaid) as creaid -- 创建id（目前未使用）
    ,nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,case when
            n.module is null
            and n.tovacd is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.module is null
            and n.tovacd is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.module is null
            and n.tovacd is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_vchr_iomp_detl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_vchr_iomp_detl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.module = n.module
            and o.tovacd = n.tovacd
            and o.stacid = n.stacid
where (
        o.module is null
        and o.tovacd is null
        and o.stacid is null
    )
    or (
        n.module is null
        and n.tovacd is null
        and n.stacid is null
    )
    or (
        o.tovana <> n.tovana
        or o.ordeid <> n.ordeid
        or o.varitp <> n.varitp
        or o.fmvacd <> n.fmvacd
        or o.fmvana <> n.fmvana
        or o.desctx <> n.desctx
        or o.updati <> n.updati
        or o.updaid <> n.updaid
        or o.creati <> n.creati
        or o.creaid <> n.creaid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_vchr_iomp_detl_cl(
            module -- 业务类型
            ,tovacd -- 目标变量编码
            ,tovana -- 目标变量名称
            ,ordeid -- 序号
            ,varitp -- 目标类型（1固定区域2扩展区域）
            ,fmvacd -- 来源变量编码
            ,fmvana -- 来源变量名称
            ,desctx -- 备注说明
            ,updati -- 更新时间（目前未使用）
            ,updaid -- 更新id（目前未使用）
            ,creati -- 创建时间（目前未使用）
            ,creaid -- 创建id（目前未使用）
            ,stacid -- 账套标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_vchr_iomp_detl_op(
            module -- 业务类型
            ,tovacd -- 目标变量编码
            ,tovana -- 目标变量名称
            ,ordeid -- 序号
            ,varitp -- 目标类型（1固定区域2扩展区域）
            ,fmvacd -- 来源变量编码
            ,fmvana -- 来源变量名称
            ,desctx -- 备注说明
            ,updati -- 更新时间（目前未使用）
            ,updaid -- 更新id（目前未使用）
            ,creati -- 创建时间（目前未使用）
            ,creaid -- 创建id（目前未使用）
            ,stacid -- 账套标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.module -- 业务类型
    ,o.tovacd -- 目标变量编码
    ,o.tovana -- 目标变量名称
    ,o.ordeid -- 序号
    ,o.varitp -- 目标类型（1固定区域2扩展区域）
    ,o.fmvacd -- 来源变量编码
    ,o.fmvana -- 来源变量名称
    ,o.desctx -- 备注说明
    ,o.updati -- 更新时间（目前未使用）
    ,o.updaid -- 更新id（目前未使用）
    ,o.creati -- 创建时间（目前未使用）
    ,o.creaid -- 创建id（目前未使用）
    ,o.stacid -- 账套标记
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
from ${iol_schema}.tgls_vchr_iomp_detl_bk o
    left join ${iol_schema}.tgls_vchr_iomp_detl_op n
        on
            o.module = n.module
            and o.tovacd = n.tovacd
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_vchr_iomp_detl_cl d
        on
            o.module = d.module
            and o.tovacd = d.tovacd
            and o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_vchr_iomp_detl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_vchr_iomp_detl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_vchr_iomp_detl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_vchr_iomp_detl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_vchr_iomp_detl exchange partition p_${batch_date} with table ${iol_schema}.tgls_vchr_iomp_detl_cl;
alter table ${iol_schema}.tgls_vchr_iomp_detl exchange partition p_20991231 with table ${iol_schema}.tgls_vchr_iomp_detl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_vchr_iomp_detl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_vchr_iomp_detl_op purge;
drop table ${iol_schema}.tgls_vchr_iomp_detl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_vchr_iomp_detl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_vchr_iomp_detl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
