/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_sys_tmap_tran
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
create table ${iol_schema}.tgls_sys_tmap_tran_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_sys_tmap_tran
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_tmap_tran_op purge;
drop table ${iol_schema}.tgls_sys_tmap_tran_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_tmap_tran_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_tmap_tran where 0=1;

create table ${iol_schema}.tgls_sys_tmap_tran_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_sys_tmap_tran where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_tmap_tran_cl(
            prcscd -- 交易场景代码
            ,dttrcd -- 子交易代码
            ,trtlno -- 子交易序号
            ,sortno -- 规则序号
            ,condcd -- 子交易执行条件
            ,beanid -- 处理规则
            ,profid -- 目标变量
            ,fildcd -- 来源变量
            ,mpcdin -- 输入映射代码串（目前未使用）
            ,mpcdot -- 输出映射代码串（目前未使用）
            ,nulflg -- 非空标识（目前未使用）
            ,desctx -- 描述
            ,vermod -- 版本号
            ,module -- 业务类型
            ,projcd -- 项目
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_tmap_tran_op(
            prcscd -- 交易场景代码
            ,dttrcd -- 子交易代码
            ,trtlno -- 子交易序号
            ,sortno -- 规则序号
            ,condcd -- 子交易执行条件
            ,beanid -- 处理规则
            ,profid -- 目标变量
            ,fildcd -- 来源变量
            ,mpcdin -- 输入映射代码串（目前未使用）
            ,mpcdot -- 输出映射代码串（目前未使用）
            ,nulflg -- 非空标识（目前未使用）
            ,desctx -- 描述
            ,vermod -- 版本号
            ,module -- 业务类型
            ,projcd -- 项目
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prcscd, o.prcscd) as prcscd -- 交易场景代码
    ,nvl(n.dttrcd, o.dttrcd) as dttrcd -- 子交易代码
    ,nvl(n.trtlno, o.trtlno) as trtlno -- 子交易序号
    ,nvl(n.sortno, o.sortno) as sortno -- 规则序号
    ,nvl(n.condcd, o.condcd) as condcd -- 子交易执行条件
    ,nvl(n.beanid, o.beanid) as beanid -- 处理规则
    ,nvl(n.profid, o.profid) as profid -- 目标变量
    ,nvl(n.fildcd, o.fildcd) as fildcd -- 来源变量
    ,nvl(n.mpcdin, o.mpcdin) as mpcdin -- 输入映射代码串（目前未使用）
    ,nvl(n.mpcdot, o.mpcdot) as mpcdot -- 输出映射代码串（目前未使用）
    ,nvl(n.nulflg, o.nulflg) as nulflg -- 非空标识（目前未使用）
    ,nvl(n.desctx, o.desctx) as desctx -- 描述
    ,nvl(n.vermod, o.vermod) as vermod -- 版本号
    ,nvl(n.module, o.module) as module -- 业务类型
    ,nvl(n.projcd, o.projcd) as projcd -- 项目
    ,nvl(n.stacid, o.stacid) as stacid -- 账套
    ,case when
            n.prcscd is null
            and n.dttrcd is null
            and n.trtlno is null
            and n.sortno is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prcscd is null
            and n.dttrcd is null
            and n.trtlno is null
            and n.sortno is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prcscd is null
            and n.dttrcd is null
            and n.trtlno is null
            and n.sortno is null
            and n.vermod is null
            and n.projcd is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_sys_tmap_tran_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_sys_tmap_tran where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prcscd = n.prcscd
            and o.dttrcd = n.dttrcd
            and o.trtlno = n.trtlno
            and o.sortno = n.sortno
            and o.vermod = n.vermod
            and o.projcd = n.projcd
            and o.stacid = n.stacid
where (
        o.prcscd is null
        and o.dttrcd is null
        and o.trtlno is null
        and o.sortno is null
        and o.vermod is null
        and o.projcd is null
        and o.stacid is null
    )
    or (
        n.prcscd is null
        and n.dttrcd is null
        and n.trtlno is null
        and n.sortno is null
        and n.vermod is null
        and n.projcd is null
        and n.stacid is null
    )
    or (
        o.condcd <> n.condcd
        or o.beanid <> n.beanid
        or o.profid <> n.profid
        or o.fildcd <> n.fildcd
        or o.mpcdin <> n.mpcdin
        or o.mpcdot <> n.mpcdot
        or o.nulflg <> n.nulflg
        or o.desctx <> n.desctx
        or o.module <> n.module
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_sys_tmap_tran_cl(
            prcscd -- 交易场景代码
            ,dttrcd -- 子交易代码
            ,trtlno -- 子交易序号
            ,sortno -- 规则序号
            ,condcd -- 子交易执行条件
            ,beanid -- 处理规则
            ,profid -- 目标变量
            ,fildcd -- 来源变量
            ,mpcdin -- 输入映射代码串（目前未使用）
            ,mpcdot -- 输出映射代码串（目前未使用）
            ,nulflg -- 非空标识（目前未使用）
            ,desctx -- 描述
            ,vermod -- 版本号
            ,module -- 业务类型
            ,projcd -- 项目
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_sys_tmap_tran_op(
            prcscd -- 交易场景代码
            ,dttrcd -- 子交易代码
            ,trtlno -- 子交易序号
            ,sortno -- 规则序号
            ,condcd -- 子交易执行条件
            ,beanid -- 处理规则
            ,profid -- 目标变量
            ,fildcd -- 来源变量
            ,mpcdin -- 输入映射代码串（目前未使用）
            ,mpcdot -- 输出映射代码串（目前未使用）
            ,nulflg -- 非空标识（目前未使用）
            ,desctx -- 描述
            ,vermod -- 版本号
            ,module -- 业务类型
            ,projcd -- 项目
            ,stacid -- 账套
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prcscd -- 交易场景代码
    ,o.dttrcd -- 子交易代码
    ,o.trtlno -- 子交易序号
    ,o.sortno -- 规则序号
    ,o.condcd -- 子交易执行条件
    ,o.beanid -- 处理规则
    ,o.profid -- 目标变量
    ,o.fildcd -- 来源变量
    ,o.mpcdin -- 输入映射代码串（目前未使用）
    ,o.mpcdot -- 输出映射代码串（目前未使用）
    ,o.nulflg -- 非空标识（目前未使用）
    ,o.desctx -- 描述
    ,o.vermod -- 版本号
    ,o.module -- 业务类型
    ,o.projcd -- 项目
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
from ${iol_schema}.tgls_sys_tmap_tran_bk o
    left join ${iol_schema}.tgls_sys_tmap_tran_op n
        on
            o.prcscd = n.prcscd
            and o.dttrcd = n.dttrcd
            and o.trtlno = n.trtlno
            and o.sortno = n.sortno
            and o.vermod = n.vermod
            and o.projcd = n.projcd
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_sys_tmap_tran_cl d
        on
            o.prcscd = d.prcscd
            and o.dttrcd = d.dttrcd
            and o.trtlno = d.trtlno
            and o.sortno = d.sortno
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
--truncate table ${iol_schema}.tgls_sys_tmap_tran;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_sys_tmap_tran') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_sys_tmap_tran drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_sys_tmap_tran add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_sys_tmap_tran exchange partition p_${batch_date} with table ${iol_schema}.tgls_sys_tmap_tran_cl;
alter table ${iol_schema}.tgls_sys_tmap_tran exchange partition p_20991231 with table ${iol_schema}.tgls_sys_tmap_tran_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_sys_tmap_tran to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_sys_tmap_tran_op purge;
drop table ${iol_schema}.tgls_sys_tmap_tran_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_sys_tmap_tran_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_sys_tmap_tran',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
