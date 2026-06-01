/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_cbrc_shet_tmpl
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
create table ${iol_schema}.tgls_cbrc_shet_tmpl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_cbrc_shet_tmpl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_cbrc_shet_tmpl_op purge;
drop table ${iol_schema}.tgls_cbrc_shet_tmpl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_shet_tmpl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_cbrc_shet_tmpl where 0=1;

create table ${iol_schema}.tgls_cbrc_shet_tmpl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_cbrc_shet_tmpl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_cbrc_shet_tmpl_cl(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,verson -- 版本号
            ,htmlna -- 报表htm模板名称
            ,exclna -- 报表excel模板名称
            ,cellxy -- 数据区域
            ,condxy -- 报表属性区域
            ,tmstyl -- 模板样式
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,rpvrsn -- 银监版本号
            ,tbrule -- 表项匹配规则
            ,fipath -- 报表存储路径
            ,stacid -- 账套
            ,jsdata -- 模板json字符串
            ,jsondata -- 报表数据json字符串
            ,maxrow -- 总行
            ,maxcol -- 总列
            ,jsonstyle -- 报表数据样式
            ,mergecells -- 报表单元格合并json字符串
            ,colwidths -- 列宽
            ,rowheights -- 行高
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_cbrc_shet_tmpl_op(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,verson -- 版本号
            ,htmlna -- 报表htm模板名称
            ,exclna -- 报表excel模板名称
            ,cellxy -- 数据区域
            ,condxy -- 报表属性区域
            ,tmstyl -- 模板样式
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,rpvrsn -- 银监版本号
            ,tbrule -- 表项匹配规则
            ,fipath -- 报表存储路径
            ,stacid -- 账套
            ,jsdata -- 模板json字符串
            ,jsondata -- 报表数据json字符串
            ,maxrow -- 总行
            ,maxcol -- 总列
            ,jsonstyle -- 报表数据样式
            ,mergecells -- 报表单元格合并json字符串
            ,colwidths -- 列宽
            ,rowheights -- 行高
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.subsys, o.subsys) as subsys -- 子系统编号
    ,nvl(n.shetcd, o.shetcd) as shetcd -- 报表编码
    ,nvl(n.verson, o.verson) as verson -- 版本号
    ,nvl(n.htmlna, o.htmlna) as htmlna -- 报表htm模板名称
    ,nvl(n.exclna, o.exclna) as exclna -- 报表excel模板名称
    ,nvl(n.cellxy, o.cellxy) as cellxy -- 数据区域
    ,nvl(n.condxy, o.condxy) as condxy -- 报表属性区域
    ,nvl(n.tmstyl, o.tmstyl) as tmstyl -- 模板样式
    ,nvl(n.begndt, o.begndt) as begndt -- 启用日期
    ,nvl(n.overdt, o.overdt) as overdt -- 停用日期
    ,nvl(n.rpvrsn, o.rpvrsn) as rpvrsn -- 银监版本号
    ,nvl(n.tbrule, o.tbrule) as tbrule -- 表项匹配规则
    ,nvl(n.fipath, o.fipath) as fipath -- 报表存储路径
    ,nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.jsdata, o.jsdata) as jsdata -- 模板json字符串
    ,nvl(n.jsondata, o.jsondata) as jsondata -- 报表数据json字符串
    ,nvl(n.maxrow, o.maxrow) as maxrow -- 总行
    ,nvl(n.maxcol, o.maxcol) as maxcol -- 总列
    ,nvl(n.jsonstyle, o.jsonstyle) as jsonstyle -- 报表数据样式
    ,nvl(n.mergecells, o.mergecells) as mergecells -- 报表单元格合并json字符串
    ,nvl(n.colwidths, o.colwidths) as colwidths -- 列宽
    ,nvl(n.rowheights, o.rowheights) as rowheights -- 行高
    ,case when
            n.subsys is null
            and n.shetcd is null
            and n.verson is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.subsys is null
            and n.shetcd is null
            and n.verson is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.subsys is null
            and n.shetcd is null
            and n.verson is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_cbrc_shet_tmpl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_cbrc_shet_tmpl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.subsys = n.subsys
            and o.shetcd = n.shetcd
            and o.verson = n.verson
            and o.stacid = n.stacid
where (
        o.subsys is null
        and o.shetcd is null
        and o.verson is null
        and o.stacid is null
    )
    or (
        n.subsys is null
        and n.shetcd is null
        and n.verson is null
        and n.stacid is null
    )
    or (
        o.htmlna <> n.htmlna
        or o.exclna <> n.exclna
        or o.cellxy <> n.cellxy
        or o.condxy <> n.condxy
        or o.tmstyl <> n.tmstyl
        or o.begndt <> n.begndt
        or o.overdt <> n.overdt
        or o.rpvrsn <> n.rpvrsn
        or o.tbrule <> n.tbrule
        or o.fipath <> n.fipath
        or o.jsdata <> n.jsdata
        or o.jsondata <> n.jsondata
        or o.maxrow <> n.maxrow
        or o.maxcol <> n.maxcol
        or o.jsonstyle <> n.jsonstyle
        or o.mergecells <> n.mergecells
        or o.colwidths <> n.colwidths
        or o.rowheights <> n.rowheights
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_cbrc_shet_tmpl_cl(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,verson -- 版本号
            ,htmlna -- 报表htm模板名称
            ,exclna -- 报表excel模板名称
            ,cellxy -- 数据区域
            ,condxy -- 报表属性区域
            ,tmstyl -- 模板样式
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,rpvrsn -- 银监版本号
            ,tbrule -- 表项匹配规则
            ,fipath -- 报表存储路径
            ,stacid -- 账套
            ,jsdata -- 模板json字符串
            ,jsondata -- 报表数据json字符串
            ,maxrow -- 总行
            ,maxcol -- 总列
            ,jsonstyle -- 报表数据样式
            ,mergecells -- 报表单元格合并json字符串
            ,colwidths -- 列宽
            ,rowheights -- 行高
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_cbrc_shet_tmpl_op(
            subsys -- 子系统编号
            ,shetcd -- 报表编码
            ,verson -- 版本号
            ,htmlna -- 报表htm模板名称
            ,exclna -- 报表excel模板名称
            ,cellxy -- 数据区域
            ,condxy -- 报表属性区域
            ,tmstyl -- 模板样式
            ,begndt -- 启用日期
            ,overdt -- 停用日期
            ,rpvrsn -- 银监版本号
            ,tbrule -- 表项匹配规则
            ,fipath -- 报表存储路径
            ,stacid -- 账套
            ,jsdata -- 模板json字符串
            ,jsondata -- 报表数据json字符串
            ,maxrow -- 总行
            ,maxcol -- 总列
            ,jsonstyle -- 报表数据样式
            ,mergecells -- 报表单元格合并json字符串
            ,colwidths -- 列宽
            ,rowheights -- 行高
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.subsys -- 子系统编号
    ,o.shetcd -- 报表编码
    ,o.verson -- 版本号
    ,o.htmlna -- 报表htm模板名称
    ,o.exclna -- 报表excel模板名称
    ,o.cellxy -- 数据区域
    ,o.condxy -- 报表属性区域
    ,o.tmstyl -- 模板样式
    ,o.begndt -- 启用日期
    ,o.overdt -- 停用日期
    ,o.rpvrsn -- 银监版本号
    ,o.tbrule -- 表项匹配规则
    ,o.fipath -- 报表存储路径
    ,o.stacid -- 账套
    ,o.jsdata -- 模板json字符串
    ,o.jsondata -- 报表数据json字符串
    ,o.maxrow -- 总行
    ,o.maxcol -- 总列
    ,o.jsonstyle -- 报表数据样式
    ,o.mergecells -- 报表单元格合并json字符串
    ,o.colwidths -- 列宽
    ,o.rowheights -- 行高
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
from ${iol_schema}.tgls_cbrc_shet_tmpl_bk o
    left join ${iol_schema}.tgls_cbrc_shet_tmpl_op n
        on
            o.subsys = n.subsys
            and o.shetcd = n.shetcd
            and o.verson = n.verson
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_cbrc_shet_tmpl_cl d
        on
            o.subsys = d.subsys
            and o.shetcd = d.shetcd
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
--truncate table ${iol_schema}.tgls_cbrc_shet_tmpl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_cbrc_shet_tmpl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_cbrc_shet_tmpl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_cbrc_shet_tmpl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_cbrc_shet_tmpl exchange partition p_${batch_date} with table ${iol_schema}.tgls_cbrc_shet_tmpl_cl;
alter table ${iol_schema}.tgls_cbrc_shet_tmpl exchange partition p_20991231 with table ${iol_schema}.tgls_cbrc_shet_tmpl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_cbrc_shet_tmpl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_cbrc_shet_tmpl_op purge;
drop table ${iol_schema}.tgls_cbrc_shet_tmpl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_cbrc_shet_tmpl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_cbrc_shet_tmpl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
