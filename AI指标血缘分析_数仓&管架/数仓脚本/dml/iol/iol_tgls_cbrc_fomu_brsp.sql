/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_cbrc_fomu_brsp
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
create table ${iol_schema}.tgls_cbrc_fomu_brsp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_cbrc_fomu_brsp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_cbrc_fomu_brsp_op purge;
drop table ${iol_schema}.tgls_cbrc_fomu_brsp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_fomu_brsp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_cbrc_fomu_brsp where 0=1;

create table ${iol_schema}.tgls_cbrc_fomu_brsp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_cbrc_fomu_brsp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_cbrc_fomu_brsp_cl(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,itemcd -- 数据项编码
            ,cellid -- 数据项id
            ,brchno -- 报送机构编号
            ,varicd -- 变量代码
            ,excode -- 执行代码
            ,sourtp -- 变量来源iner:表间item：指标体系modu：数据模型
            ,verson -- 版本号
            ,stacid -- 帐套id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_cbrc_fomu_brsp_op(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,itemcd -- 数据项编码
            ,cellid -- 数据项id
            ,brchno -- 报送机构编号
            ,varicd -- 变量代码
            ,excode -- 执行代码
            ,sourtp -- 变量来源iner:表间item：指标体系modu：数据模型
            ,verson -- 版本号
            ,stacid -- 帐套id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.subsys, o.subsys) as subsys -- 子系统编号
    ,nvl(n.shetcd, o.shetcd) as shetcd -- 报表编码
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 数据项编码
    ,nvl(n.cellid, o.cellid) as cellid -- 数据项id
    ,nvl(n.brchno, o.brchno) as brchno -- 报送机构编号
    ,nvl(n.varicd, o.varicd) as varicd -- 变量代码
    ,nvl(n.excode, o.excode) as excode -- 执行代码
    ,nvl(n.sourtp, o.sourtp) as sourtp -- 变量来源iner:表间item：指标体系modu：数据模型
    ,nvl(n.verson, o.verson) as verson -- 版本号
    ,nvl(n.stacid, o.stacid) as stacid -- 帐套id
    ,case when
            n.shetcd is null
            and n.varicd is null
            and n.sourtp is null
            and n.verson is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.shetcd is null
            and n.varicd is null
            and n.sourtp is null
            and n.verson is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.shetcd is null
            and n.varicd is null
            and n.sourtp is null
            and n.verson is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_cbrc_fomu_brsp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_cbrc_fomu_brsp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.shetcd = n.shetcd
            and o.varicd = n.varicd
            and o.sourtp = n.sourtp
            and o.verson = n.verson
            and o.stacid = n.stacid
where (
        o.shetcd is null
        and o.varicd is null
        and o.sourtp is null
        and o.verson is null
        and o.stacid is null
    )
    or (
        n.shetcd is null
        and n.varicd is null
        and n.sourtp is null
        and n.verson is null
        and n.stacid is null
    )
    or (
        o.subsys <> n.subsys
        or o.itemcd <> n.itemcd
        or o.cellid <> n.cellid
        or o.brchno <> n.brchno
        or o.excode <> n.excode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_cbrc_fomu_brsp_cl(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,itemcd -- 数据项编码
            ,cellid -- 数据项id
            ,brchno -- 报送机构编号
            ,varicd -- 变量代码
            ,excode -- 执行代码
            ,sourtp -- 变量来源iner:表间item：指标体系modu：数据模型
            ,verson -- 版本号
            ,stacid -- 帐套id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_cbrc_fomu_brsp_op(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,itemcd -- 数据项编码
            ,cellid -- 数据项id
            ,brchno -- 报送机构编号
            ,varicd -- 变量代码
            ,excode -- 执行代码
            ,sourtp -- 变量来源iner:表间item：指标体系modu：数据模型
            ,verson -- 版本号
            ,stacid -- 帐套id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.subsys -- 子系统编号
    ,o.shetcd -- 报表编码
    ,o.itemcd -- 数据项编码
    ,o.cellid -- 数据项id
    ,o.brchno -- 报送机构编号
    ,o.varicd -- 变量代码
    ,o.excode -- 执行代码
    ,o.sourtp -- 变量来源iner:表间item：指标体系modu：数据模型
    ,o.verson -- 版本号
    ,o.stacid -- 帐套id
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
from ${iol_schema}.tgls_cbrc_fomu_brsp_bk o
    left join ${iol_schema}.tgls_cbrc_fomu_brsp_op n
        on
            o.shetcd = n.shetcd
            and o.varicd = n.varicd
            and o.sourtp = n.sourtp
            and o.verson = n.verson
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_cbrc_fomu_brsp_cl d
        on
            o.shetcd = d.shetcd
            and o.varicd = d.varicd
            and o.sourtp = d.sourtp
            and o.verson = d.verson
            and o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_cbrc_fomu_brsp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_cbrc_fomu_brsp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_cbrc_fomu_brsp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_cbrc_fomu_brsp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_cbrc_fomu_brsp exchange partition p_${batch_date} with table ${iol_schema}.tgls_cbrc_fomu_brsp_cl;
alter table ${iol_schema}.tgls_cbrc_fomu_brsp exchange partition p_20991231 with table ${iol_schema}.tgls_cbrc_fomu_brsp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_cbrc_fomu_brsp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_cbrc_fomu_brsp_op purge;
drop table ${iol_schema}.tgls_cbrc_fomu_brsp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_cbrc_fomu_brsp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_cbrc_fomu_brsp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
