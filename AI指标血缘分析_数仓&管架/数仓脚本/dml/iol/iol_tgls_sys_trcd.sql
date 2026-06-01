/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_sys_trcd
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
create table ${iol_schema}.tgls_sys_trcd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_sys_trcd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_trcd_op purge;
drop table ${iol_schema}.tgls_sys_trcd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_trcd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_trcd where 0=1;

create table ${iol_schema}.tgls_sys_trcd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_trcd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_trcd_cl(
            trancd -- 子交易类别代码
            ,tranna -- 子交易类别名称
            ,enname -- 英文名称（目前未使用）
            ,tramcd -- 借贷/收付标志（目前未使用）
            ,intfcd -- 输入输出接口代码（目前未使用）
            ,propif -- 属性接口代码（目前未使用）
            ,relaif -- 关系接口代码（目前未使用）
            ,desctx -- 说明
            ,vermod -- 版本模式
            ,module -- 业务类型
            ,projcd -- 项目编号
            ,trprcd -- 余额类型(核对时)（目前未使用）
            ,demodu -- 从属模块
            ,condcd -- 子交易执行条件
            ,demona -- 从属模块名称
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_trcd_op(
            trancd -- 子交易类别代码
            ,tranna -- 子交易类别名称
            ,enname -- 英文名称（目前未使用）
            ,tramcd -- 借贷/收付标志（目前未使用）
            ,intfcd -- 输入输出接口代码（目前未使用）
            ,propif -- 属性接口代码（目前未使用）
            ,relaif -- 关系接口代码（目前未使用）
            ,desctx -- 说明
            ,vermod -- 版本模式
            ,module -- 业务类型
            ,projcd -- 项目编号
            ,trprcd -- 余额类型(核对时)（目前未使用）
            ,demodu -- 从属模块
            ,condcd -- 子交易执行条件
            ,demona -- 从属模块名称
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trancd, o.trancd) as trancd -- 子交易类别代码
    ,nvl(n.tranna, o.tranna) as tranna -- 子交易类别名称
    ,nvl(n.enname, o.enname) as enname -- 英文名称（目前未使用）
    ,nvl(n.tramcd, o.tramcd) as tramcd -- 借贷/收付标志（目前未使用）
    ,nvl(n.intfcd, o.intfcd) as intfcd -- 输入输出接口代码（目前未使用）
    ,nvl(n.propif, o.propif) as propif -- 属性接口代码（目前未使用）
    ,nvl(n.relaif, o.relaif) as relaif -- 关系接口代码（目前未使用）
    ,nvl(n.desctx, o.desctx) as desctx -- 说明
    ,nvl(n.vermod, o.vermod) as vermod -- 版本模式
    ,nvl(n.module, o.module) as module -- 业务类型
    ,nvl(n.projcd, o.projcd) as projcd -- 项目编号
    ,nvl(n.trprcd, o.trprcd) as trprcd -- 余额类型(核对时)（目前未使用）
    ,nvl(n.demodu, o.demodu) as demodu -- 从属模块
    ,nvl(n.condcd, o.condcd) as condcd -- 子交易执行条件
    ,nvl(n.demona, o.demona) as demona -- 从属模块名称
    ,nvl(n.stacid, o.stacid) as stacid -- 账套
    ,case when
            n.trancd is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trancd is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trancd is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_sys_trcd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_sys_trcd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trancd = n.trancd
            and o.vermod = n.vermod
            and o.projcd = n.projcd
            and o.stacid = n.stacid
where (
        o.trancd is null
        and o.vermod is null
        and o.projcd is null
        and o.stacid is null
    )
    or (
        n.trancd is null
        and n.vermod is null
        and n.projcd is null
        and n.stacid is null
    )
    or (
        o.tranna <> n.tranna
        or o.enname <> n.enname
        or o.tramcd <> n.tramcd
        or o.intfcd <> n.intfcd
        or o.propif <> n.propif
        or o.relaif <> n.relaif
        or o.desctx <> n.desctx
        or o.module <> n.module
        or o.trprcd <> n.trprcd
        or o.demodu <> n.demodu
        or o.condcd <> n.condcd
        or o.demona <> n.demona
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_trcd_cl(
            trancd -- 子交易类别代码
            ,tranna -- 子交易类别名称
            ,enname -- 英文名称（目前未使用）
            ,tramcd -- 借贷/收付标志（目前未使用）
            ,intfcd -- 输入输出接口代码（目前未使用）
            ,propif -- 属性接口代码（目前未使用）
            ,relaif -- 关系接口代码（目前未使用）
            ,desctx -- 说明
            ,vermod -- 版本模式
            ,module -- 业务类型
            ,projcd -- 项目编号
            ,trprcd -- 余额类型(核对时)（目前未使用）
            ,demodu -- 从属模块
            ,condcd -- 子交易执行条件
            ,demona -- 从属模块名称
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_trcd_op(
            trancd -- 子交易类别代码
            ,tranna -- 子交易类别名称
            ,enname -- 英文名称（目前未使用）
            ,tramcd -- 借贷/收付标志（目前未使用）
            ,intfcd -- 输入输出接口代码（目前未使用）
            ,propif -- 属性接口代码（目前未使用）
            ,relaif -- 关系接口代码（目前未使用）
            ,desctx -- 说明
            ,vermod -- 版本模式
            ,module -- 业务类型
            ,projcd -- 项目编号
            ,trprcd -- 余额类型(核对时)（目前未使用）
            ,demodu -- 从属模块
            ,condcd -- 子交易执行条件
            ,demona -- 从属模块名称
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trancd -- 子交易类别代码
    ,o.tranna -- 子交易类别名称
    ,o.enname -- 英文名称（目前未使用）
    ,o.tramcd -- 借贷/收付标志（目前未使用）
    ,o.intfcd -- 输入输出接口代码（目前未使用）
    ,o.propif -- 属性接口代码（目前未使用）
    ,o.relaif -- 关系接口代码（目前未使用）
    ,o.desctx -- 说明
    ,o.vermod -- 版本模式
    ,o.module -- 业务类型
    ,o.projcd -- 项目编号
    ,o.trprcd -- 余额类型(核对时)（目前未使用）
    ,o.demodu -- 从属模块
    ,o.condcd -- 子交易执行条件
    ,o.demona -- 从属模块名称
    ,o.stacid -- 账套
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
from ${iol_schema}.tgls_sys_trcd_bk o
    left join ${iol_schema}.tgls_sys_trcd_op n
        on
            o.trancd = n.trancd
            and o.vermod = n.vermod
            and o.projcd = n.projcd
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_sys_trcd_cl d
        on
            o.trancd = d.trancd
            and o.vermod = d.vermod
            and o.projcd = d.projcd
            and o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_sys_trcd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_sys_trcd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_sys_trcd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_sys_trcd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_sys_trcd exchange partition p_${batch_date} with table ${iol_schema}.tgls_sys_trcd_cl;
alter table ${iol_schema}.tgls_sys_trcd exchange partition p_20991231 with table ${iol_schema}.tgls_sys_trcd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_sys_trcd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_trcd_op purge;
drop table ${iol_schema}.tgls_sys_trcd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_sys_trcd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_sys_trcd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
