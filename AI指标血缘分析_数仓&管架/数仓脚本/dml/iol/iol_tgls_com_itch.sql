/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_com_itch
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
create table ${iol_schema}.tgls_com_itch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_com_itch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_itch_op purge;
drop table ${iol_schema}.tgls_com_itch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_itch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_itch where 0=1;

create table ${iol_schema}.tgls_com_itch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_itch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_itch_cl(
            stacid -- 账套标识
            ,itemfm -- 被调整科目编号
            ,itemto -- 调整科目编号
            ,efctdt -- 科目生效日期
            ,transt -- 状态(1、已调整0、未调整）
            ,usercd -- 操作员
            ,userbr -- 操作员所属机构编号
            ,oprtcd -- 科目替换：replac科目拆分：splitt科目合并：mergee
            ,tranti -- 操作时间
            ,toname -- 拆分后的科目名称
            ,weight -- 拆分科目比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_itch_op(
            stacid -- 账套标识
            ,itemfm -- 被调整科目编号
            ,itemto -- 调整科目编号
            ,efctdt -- 科目生效日期
            ,transt -- 状态(1、已调整0、未调整）
            ,usercd -- 操作员
            ,userbr -- 操作员所属机构编号
            ,oprtcd -- 科目替换：replac科目拆分：splitt科目合并：mergee
            ,tranti -- 操作时间
            ,toname -- 拆分后的科目名称
            ,weight -- 拆分科目比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标识
    ,nvl(n.itemfm, o.itemfm) as itemfm -- 被调整科目编号
    ,nvl(n.itemto, o.itemto) as itemto -- 调整科目编号
    ,nvl(n.efctdt, o.efctdt) as efctdt -- 科目生效日期
    ,nvl(n.transt, o.transt) as transt -- 状态(1、已调整0、未调整）
    ,nvl(n.usercd, o.usercd) as usercd -- 操作员
    ,nvl(n.userbr, o.userbr) as userbr -- 操作员所属机构编号
    ,nvl(n.oprtcd, o.oprtcd) as oprtcd -- 科目替换：replac科目拆分：splitt科目合并：mergee
    ,nvl(n.tranti, o.tranti) as tranti -- 操作时间
    ,nvl(n.toname, o.toname) as toname -- 拆分后的科目名称
    ,nvl(n.weight, o.weight) as weight -- 拆分科目比例
    ,case when
            n.stacid is null
            and n.itemfm is null
            and n.itemto is null
            and n.oprtcd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.itemfm is null
            and n.itemto is null
            and n.oprtcd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.itemfm is null
            and n.itemto is null
            and n.oprtcd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_com_itch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_com_itch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.itemfm = n.itemfm
            and o.itemto = n.itemto
            and o.oprtcd = n.oprtcd
where (
        o.stacid is null
        and o.itemfm is null
        and o.itemto is null
        and o.oprtcd is null
    )
    or (
        n.stacid is null
        and n.itemfm is null
        and n.itemto is null
        and n.oprtcd is null
    )
    or (
        o.efctdt <> n.efctdt
        or o.transt <> n.transt
        or o.usercd <> n.usercd
        or o.userbr <> n.userbr
        or o.tranti <> n.tranti
        or o.toname <> n.toname
        or o.weight <> n.weight
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_itch_cl(
            stacid -- 账套标识
            ,itemfm -- 被调整科目编号
            ,itemto -- 调整科目编号
            ,efctdt -- 科目生效日期
            ,transt -- 状态(1、已调整0、未调整）
            ,usercd -- 操作员
            ,userbr -- 操作员所属机构编号
            ,oprtcd -- 科目替换：replac科目拆分：splitt科目合并：mergee
            ,tranti -- 操作时间
            ,toname -- 拆分后的科目名称
            ,weight -- 拆分科目比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_itch_op(
            stacid -- 账套标识
            ,itemfm -- 被调整科目编号
            ,itemto -- 调整科目编号
            ,efctdt -- 科目生效日期
            ,transt -- 状态(1、已调整0、未调整）
            ,usercd -- 操作员
            ,userbr -- 操作员所属机构编号
            ,oprtcd -- 科目替换：replac科目拆分：splitt科目合并：mergee
            ,tranti -- 操作时间
            ,toname -- 拆分后的科目名称
            ,weight -- 拆分科目比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标识
    ,o.itemfm -- 被调整科目编号
    ,o.itemto -- 调整科目编号
    ,o.efctdt -- 科目生效日期
    ,o.transt -- 状态(1、已调整0、未调整）
    ,o.usercd -- 操作员
    ,o.userbr -- 操作员所属机构编号
    ,o.oprtcd -- 科目替换：replac科目拆分：splitt科目合并：mergee
    ,o.tranti -- 操作时间
    ,o.toname -- 拆分后的科目名称
    ,o.weight -- 拆分科目比例
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
from ${iol_schema}.tgls_com_itch_bk o
    left join ${iol_schema}.tgls_com_itch_op n
        on
            o.stacid = n.stacid
            and o.itemfm = n.itemfm
            and o.itemto = n.itemto
            and o.oprtcd = n.oprtcd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_com_itch_cl d
        on
            o.stacid = d.stacid
            and o.itemfm = d.itemfm
            and o.itemto = d.itemto
            and o.oprtcd = d.oprtcd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_com_itch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_com_itch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_com_itch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_com_itch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_com_itch exchange partition p_${batch_date} with table ${iol_schema}.tgls_com_itch_cl;
alter table ${iol_schema}.tgls_com_itch exchange partition p_20991231 with table ${iol_schema}.tgls_com_itch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_com_itch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_itch_op purge;
drop table ${iol_schema}.tgls_com_itch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_com_itch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_com_itch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
