/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_vchr_tmpl
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
create table ${iol_schema}.tgls_vchr_tmpl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_vchr_tmpl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_vchr_tmpl_op purge;
drop table ${iol_schema}.tgls_vchr_tmpl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_vchr_tmpl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_vchr_tmpl where 0=1;

create table ${iol_schema}.tgls_vchr_tmpl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_vchr_tmpl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_vchr_tmpl_cl(
            varicd -- 变量编码
            ,varitp -- 变量类型(1固定区域2多维区域)
            ,ordeid -- 序号
            ,busina -- 业务名称
            ,desctx -- 字段说明
            ,updati -- 更新时间（目前未使用）
            ,updaid -- 分片代码（目前未使用）
            ,creati -- 更新人代码（目前未使用）
            ,creaid -- 创建人代码（目前未使用）
            ,stacid -- 账套标记
            ,detner -- 弹性限定词
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_vchr_tmpl_op(
            varicd -- 变量编码
            ,varitp -- 变量类型(1固定区域2多维区域)
            ,ordeid -- 序号
            ,busina -- 业务名称
            ,desctx -- 字段说明
            ,updati -- 更新时间（目前未使用）
            ,updaid -- 分片代码（目前未使用）
            ,creati -- 更新人代码（目前未使用）
            ,creaid -- 创建人代码（目前未使用）
            ,stacid -- 账套标记
            ,detner -- 弹性限定词
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.varicd, o.varicd) as varicd -- 变量编码
    ,nvl(n.varitp, o.varitp) as varitp -- 变量类型(1固定区域2多维区域)
    ,nvl(n.ordeid, o.ordeid) as ordeid -- 序号
    ,nvl(n.busina, o.busina) as busina -- 业务名称
    ,nvl(n.desctx, o.desctx) as desctx -- 字段说明
    ,nvl(n.updati, o.updati) as updati -- 更新时间（目前未使用）
    ,nvl(n.updaid, o.updaid) as updaid -- 分片代码（目前未使用）
    ,nvl(n.creati, o.creati) as creati -- 更新人代码（目前未使用）
    ,nvl(n.creaid, o.creaid) as creaid -- 创建人代码（目前未使用）
    ,nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.detner, o.detner) as detner -- 弹性限定词
    ,case when
            n.varicd is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.varicd is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.varicd is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_vchr_tmpl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_vchr_tmpl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.varicd = n.varicd
            and o.stacid = n.stacid
where (
        o.varicd is null
        and o.stacid is null
    )
    or (
        n.varicd is null
        and n.stacid is null
    )
    or (
        o.varitp <> n.varitp
        or o.ordeid <> n.ordeid
        or o.busina <> n.busina
        or o.desctx <> n.desctx
        or o.updati <> n.updati
        or o.updaid <> n.updaid
        or o.creati <> n.creati
        or o.creaid <> n.creaid
        or o.detner <> n.detner
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_vchr_tmpl_cl(
            varicd -- 变量编码
            ,varitp -- 变量类型(1固定区域2多维区域)
            ,ordeid -- 序号
            ,busina -- 业务名称
            ,desctx -- 字段说明
            ,updati -- 更新时间（目前未使用）
            ,updaid -- 分片代码（目前未使用）
            ,creati -- 更新人代码（目前未使用）
            ,creaid -- 创建人代码（目前未使用）
            ,stacid -- 账套标记
            ,detner -- 弹性限定词
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_vchr_tmpl_op(
            varicd -- 变量编码
            ,varitp -- 变量类型(1固定区域2多维区域)
            ,ordeid -- 序号
            ,busina -- 业务名称
            ,desctx -- 字段说明
            ,updati -- 更新时间（目前未使用）
            ,updaid -- 分片代码（目前未使用）
            ,creati -- 更新人代码（目前未使用）
            ,creaid -- 创建人代码（目前未使用）
            ,stacid -- 账套标记
            ,detner -- 弹性限定词
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.varicd -- 变量编码
    ,o.varitp -- 变量类型(1固定区域2多维区域)
    ,o.ordeid -- 序号
    ,o.busina -- 业务名称
    ,o.desctx -- 字段说明
    ,o.updati -- 更新时间（目前未使用）
    ,o.updaid -- 分片代码（目前未使用）
    ,o.creati -- 更新人代码（目前未使用）
    ,o.creaid -- 创建人代码（目前未使用）
    ,o.stacid -- 账套标记
    ,o.detner -- 弹性限定词
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
from ${iol_schema}.tgls_vchr_tmpl_bk o
    left join ${iol_schema}.tgls_vchr_tmpl_op n
        on
            o.varicd = n.varicd
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_vchr_tmpl_cl d
        on
            o.varicd = d.varicd
            and o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_vchr_tmpl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_vchr_tmpl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_vchr_tmpl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_vchr_tmpl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_vchr_tmpl exchange partition p_${batch_date} with table ${iol_schema}.tgls_vchr_tmpl_cl;
alter table ${iol_schema}.tgls_vchr_tmpl exchange partition p_20991231 with table ${iol_schema}.tgls_vchr_tmpl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_vchr_tmpl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_vchr_tmpl_op purge;
drop table ${iol_schema}.tgls_vchr_tmpl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_vchr_tmpl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_vchr_tmpl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
