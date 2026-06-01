/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_sys_trpr
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
create table ${iol_schema}.tgls_sys_trpr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_sys_trpr
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_trpr_op purge;
drop table ${iol_schema}.tgls_sys_trpr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_trpr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_trpr where 0=1;

create table ${iol_schema}.tgls_sys_trpr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_trpr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_trpr_cl(
            module -- 业务类型
            ,trprcd -- 金额类型代码
            ,trprna -- 金额类型名称
            ,usedtp -- 使用状态（0未使用1已使用）
            ,desctx -- 描述说明
            ,tablcl -- 余额类型对应的表列字段（目前未使用）
            ,sortno -- 余额类型对应的排序（目前未使用）
            ,chcktp -- 第三次总分核对是否需要核对该余额（y-是n-否）
            ,stacid -- 账套
            ,startp -- 启用标识（0停用1启用）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_trpr_op(
            module -- 业务类型
            ,trprcd -- 金额类型代码
            ,trprna -- 金额类型名称
            ,usedtp -- 使用状态（0未使用1已使用）
            ,desctx -- 描述说明
            ,tablcl -- 余额类型对应的表列字段（目前未使用）
            ,sortno -- 余额类型对应的排序（目前未使用）
            ,chcktp -- 第三次总分核对是否需要核对该余额（y-是n-否）
            ,stacid -- 账套
            ,startp -- 启用标识（0停用1启用）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.module, o.module) as module -- 业务类型
    ,nvl(n.trprcd, o.trprcd) as trprcd -- 金额类型代码
    ,nvl(n.trprna, o.trprna) as trprna -- 金额类型名称
    ,nvl(n.usedtp, o.usedtp) as usedtp -- 使用状态（0未使用1已使用）
    ,nvl(n.desctx, o.desctx) as desctx -- 描述说明
    ,nvl(n.tablcl, o.tablcl) as tablcl -- 余额类型对应的表列字段（目前未使用）
    ,nvl(n.sortno, o.sortno) as sortno -- 余额类型对应的排序（目前未使用）
    ,nvl(n.chcktp, o.chcktp) as chcktp -- 第三次总分核对是否需要核对该余额（y-是n-否）
    ,nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.startp, o.startp) as startp -- 启用标识（0停用1启用）
    ,case when
            n.module is null
            and n.trprcd is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.module is null
            and n.trprcd is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.module is null
            and n.trprcd is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_sys_trpr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_sys_trpr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.module = n.module
            and o.trprcd = n.trprcd
            and o.stacid = n.stacid
where (
        o.module is null
        and o.trprcd is null
        and o.stacid is null
    )
    or (
        n.module is null
        and n.trprcd is null
        and n.stacid is null
    )
    or (
        o.trprna <> n.trprna
        or o.usedtp <> n.usedtp
        or o.desctx <> n.desctx
        or o.tablcl <> n.tablcl
        or o.sortno <> n.sortno
        or o.chcktp <> n.chcktp
        or o.startp <> n.startp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_trpr_cl(
            module -- 业务类型
            ,trprcd -- 金额类型代码
            ,trprna -- 金额类型名称
            ,usedtp -- 使用状态（0未使用1已使用）
            ,desctx -- 描述说明
            ,tablcl -- 余额类型对应的表列字段（目前未使用）
            ,sortno -- 余额类型对应的排序（目前未使用）
            ,chcktp -- 第三次总分核对是否需要核对该余额（y-是n-否）
            ,stacid -- 账套
            ,startp -- 启用标识（0停用1启用）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_trpr_op(
            module -- 业务类型
            ,trprcd -- 金额类型代码
            ,trprna -- 金额类型名称
            ,usedtp -- 使用状态（0未使用1已使用）
            ,desctx -- 描述说明
            ,tablcl -- 余额类型对应的表列字段（目前未使用）
            ,sortno -- 余额类型对应的排序（目前未使用）
            ,chcktp -- 第三次总分核对是否需要核对该余额（y-是n-否）
            ,stacid -- 账套
            ,startp -- 启用标识（0停用1启用）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.module -- 业务类型
    ,o.trprcd -- 金额类型代码
    ,o.trprna -- 金额类型名称
    ,o.usedtp -- 使用状态（0未使用1已使用）
    ,o.desctx -- 描述说明
    ,o.tablcl -- 余额类型对应的表列字段（目前未使用）
    ,o.sortno -- 余额类型对应的排序（目前未使用）
    ,o.chcktp -- 第三次总分核对是否需要核对该余额（y-是n-否）
    ,o.stacid -- 账套
    ,o.startp -- 启用标识（0停用1启用）
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
from ${iol_schema}.tgls_sys_trpr_bk o
    left join ${iol_schema}.tgls_sys_trpr_op n
        on
            o.module = n.module
            and o.trprcd = n.trprcd
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_sys_trpr_cl d
        on
            o.module = d.module
            and o.trprcd = d.trprcd
            and o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_sys_trpr;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_sys_trpr') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_sys_trpr drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_sys_trpr add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_sys_trpr exchange partition p_${batch_date} with table ${iol_schema}.tgls_sys_trpr_cl;
alter table ${iol_schema}.tgls_sys_trpr exchange partition p_20991231 with table ${iol_schema}.tgls_sys_trpr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_sys_trpr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_trpr_op purge;
drop table ${iol_schema}.tgls_sys_trpr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_sys_trpr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_sys_trpr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
