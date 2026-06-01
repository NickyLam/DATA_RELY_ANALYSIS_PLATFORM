/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_type_defer
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
create table ${iol_schema}.tgls_tax_type_defer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_tax_type_defer
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_type_defer_op purge;
drop table ${iol_schema}.tgls_tax_type_defer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_defer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_type_defer where 0=1;

create table ${iol_schema}.tgls_tax_type_defer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_type_defer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_type_defer_cl(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,caclcd -- 项目代码
            ,caclna -- 项目说明
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,smrytx -- 备注
            ,aacode -- 账面小于基础借方
            ,dacode -- 账面大于基础借方
            ,aocode -- 账面小于基础贷方
            ,docode -- 账面大于基础贷方
            ,aaname -- 账面小于基础借方科目名称
            ,daname -- 账面大于基础借方科目名称
            ,aoname -- 账面小于基础贷方科目名称
            ,doname -- 账面大于基础贷方科目名称
            ,zmjzfm -- 账面价值公式
            ,jsjcfm -- 计税基础公式
            ,zjflag -- 账面价值与计税基础比较（1：大于，2：小于，3大于或小于）
            ,itemtp -- 项目类型（1：资产，2：负债）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_type_defer_op(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,caclcd -- 项目代码
            ,caclna -- 项目说明
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,smrytx -- 备注
            ,aacode -- 账面小于基础借方
            ,dacode -- 账面大于基础借方
            ,aocode -- 账面小于基础贷方
            ,docode -- 账面大于基础贷方
            ,aaname -- 账面小于基础借方科目名称
            ,daname -- 账面大于基础借方科目名称
            ,aoname -- 账面小于基础贷方科目名称
            ,doname -- 账面大于基础贷方科目名称
            ,zmjzfm -- 账面价值公式
            ,jsjcfm -- 计税基础公式
            ,zjflag -- 账面价值与计税基础比较（1：大于，2：小于，3大于或小于）
            ,itemtp -- 项目类型（1：资产，2：负债）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.taxscd, o.taxscd) as taxscd -- 税种代码
    ,nvl(n.deptcd, o.deptcd) as deptcd -- 机构编号
    ,nvl(n.caclcd, o.caclcd) as caclcd -- 项目代码
    ,nvl(n.caclna, o.caclna) as caclna -- 项目说明
    ,nvl(n.begndt, o.begndt) as begndt -- 起始日期
    ,nvl(n.endddt, o.endddt) as endddt -- 终止日期
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 备注
    ,nvl(n.aacode, o.aacode) as aacode -- 账面小于基础借方
    ,nvl(n.dacode, o.dacode) as dacode -- 账面大于基础借方
    ,nvl(n.aocode, o.aocode) as aocode -- 账面小于基础贷方
    ,nvl(n.docode, o.docode) as docode -- 账面大于基础贷方
    ,nvl(n.aaname, o.aaname) as aaname -- 账面小于基础借方科目名称
    ,nvl(n.daname, o.daname) as daname -- 账面大于基础借方科目名称
    ,nvl(n.aoname, o.aoname) as aoname -- 账面小于基础贷方科目名称
    ,nvl(n.doname, o.doname) as doname -- 账面大于基础贷方科目名称
    ,nvl(n.zmjzfm, o.zmjzfm) as zmjzfm -- 账面价值公式
    ,nvl(n.jsjcfm, o.jsjcfm) as jsjcfm -- 计税基础公式
    ,nvl(n.zjflag, o.zjflag) as zjflag -- 账面价值与计税基础比较（1：大于，2：小于，3大于或小于）
    ,nvl(n.itemtp, o.itemtp) as itemtp -- 项目类型（1：资产，2：负债）
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 弹性域列(备用)
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 弹性域列(备用)
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 弹性域列(备用)
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 弹性域列(备用)
    ,case when
            n.stacid is null
            and n.deptcd is null
            and n.caclcd is null
            and n.begndt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.deptcd is null
            and n.caclcd is null
            and n.begndt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.deptcd is null
            and n.caclcd is null
            and n.begndt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_tax_type_defer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_tax_type_defer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.deptcd = n.deptcd
            and o.caclcd = n.caclcd
            and o.begndt = n.begndt
where (
        o.stacid is null
        and o.deptcd is null
        and o.caclcd is null
        and o.begndt is null
    )
    or (
        n.stacid is null
        and n.deptcd is null
        and n.caclcd is null
        and n.begndt is null
    )
    or (
        o.taxscd <> n.taxscd
        or o.caclna <> n.caclna
        or o.endddt <> n.endddt
        or o.smrytx <> n.smrytx
        or o.aacode <> n.aacode
        or o.dacode <> n.dacode
        or o.aocode <> n.aocode
        or o.docode <> n.docode
        or o.aaname <> n.aaname
        or o.daname <> n.daname
        or o.aoname <> n.aoname
        or o.doname <> n.doname
        or o.zmjzfm <> n.zmjzfm
        or o.jsjcfm <> n.jsjcfm
        or o.zjflag <> n.zjflag
        or o.itemtp <> n.itemtp
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.attribute4 <> n.attribute4
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_type_defer_cl(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,caclcd -- 项目代码
            ,caclna -- 项目说明
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,smrytx -- 备注
            ,aacode -- 账面小于基础借方
            ,dacode -- 账面大于基础借方
            ,aocode -- 账面小于基础贷方
            ,docode -- 账面大于基础贷方
            ,aaname -- 账面小于基础借方科目名称
            ,daname -- 账面大于基础借方科目名称
            ,aoname -- 账面小于基础贷方科目名称
            ,doname -- 账面大于基础贷方科目名称
            ,zmjzfm -- 账面价值公式
            ,jsjcfm -- 计税基础公式
            ,zjflag -- 账面价值与计税基础比较（1：大于，2：小于，3大于或小于）
            ,itemtp -- 项目类型（1：资产，2：负债）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_type_defer_op(
            stacid -- 账套标记
            ,taxscd -- 税种代码
            ,deptcd -- 机构编号
            ,caclcd -- 项目代码
            ,caclna -- 项目说明
            ,begndt -- 起始日期
            ,endddt -- 终止日期
            ,smrytx -- 备注
            ,aacode -- 账面小于基础借方
            ,dacode -- 账面大于基础借方
            ,aocode -- 账面小于基础贷方
            ,docode -- 账面大于基础贷方
            ,aaname -- 账面小于基础借方科目名称
            ,daname -- 账面大于基础借方科目名称
            ,aoname -- 账面小于基础贷方科目名称
            ,doname -- 账面大于基础贷方科目名称
            ,zmjzfm -- 账面价值公式
            ,jsjcfm -- 计税基础公式
            ,zjflag -- 账面价值与计税基础比较（1：大于，2：小于，3大于或小于）
            ,itemtp -- 项目类型（1：资产，2：负债）
            ,attribute1 -- 弹性域列(备用)
            ,attribute2 -- 弹性域列(备用)
            ,attribute3 -- 弹性域列(备用)
            ,attribute4 -- 弹性域列(备用)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.taxscd -- 税种代码
    ,o.deptcd -- 机构编号
    ,o.caclcd -- 项目代码
    ,o.caclna -- 项目说明
    ,o.begndt -- 起始日期
    ,o.endddt -- 终止日期
    ,o.smrytx -- 备注
    ,o.aacode -- 账面小于基础借方
    ,o.dacode -- 账面大于基础借方
    ,o.aocode -- 账面小于基础贷方
    ,o.docode -- 账面大于基础贷方
    ,o.aaname -- 账面小于基础借方科目名称
    ,o.daname -- 账面大于基础借方科目名称
    ,o.aoname -- 账面小于基础贷方科目名称
    ,o.doname -- 账面大于基础贷方科目名称
    ,o.zmjzfm -- 账面价值公式
    ,o.jsjcfm -- 计税基础公式
    ,o.zjflag -- 账面价值与计税基础比较（1：大于，2：小于，3大于或小于）
    ,o.itemtp -- 项目类型（1：资产，2：负债）
    ,o.attribute1 -- 弹性域列(备用)
    ,o.attribute2 -- 弹性域列(备用)
    ,o.attribute3 -- 弹性域列(备用)
    ,o.attribute4 -- 弹性域列(备用)
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
from ${iol_schema}.tgls_tax_type_defer_bk o
    left join ${iol_schema}.tgls_tax_type_defer_op n
        on
            o.stacid = n.stacid
            and o.deptcd = n.deptcd
            and o.caclcd = n.caclcd
            and o.begndt = n.begndt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_tax_type_defer_cl d
        on
            o.stacid = d.stacid
            and o.deptcd = d.deptcd
            and o.caclcd = d.caclcd
            and o.begndt = d.begndt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_tax_type_defer;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_tax_type_defer') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_tax_type_defer drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_tax_type_defer add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_tax_type_defer exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_type_defer_cl;
alter table ${iol_schema}.tgls_tax_type_defer exchange partition p_20991231 with table ${iol_schema}.tgls_tax_type_defer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_type_defer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_type_defer_op purge;
drop table ${iol_schema}.tgls_tax_type_defer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_tax_type_defer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_type_defer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
