/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_bd_vouchertype
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
create table ${iol_schema}.iers_bd_vouchertype_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_bd_vouchertype
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_vouchertype_op purge;
drop table ${iol_schema}.iers_bd_vouchertype_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_vouchertype_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_vouchertype where 0=1;

create table ${iol_schema}.iers_bd_vouchertype_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_vouchertype where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_vouchertype_cl(
            code -- 凭证类别编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 数据来源
            ,description -- 凭证类别描述
            ,description2 -- 凭证类别描述2
            ,description3 -- 凭证类别描述3
            ,description4 -- 凭证类别描述4
            ,description5 -- 凭证类别描述5
            ,description6 -- 凭证类别描述6
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 凭证类别名称
            ,name2 -- 凭证类别名称2
            ,name3 -- 凭证类别名称3
            ,name4 -- 凭证类别名称4
            ,name5 -- 凭证类别名称5
            ,name6 -- 凭证类别名称6
            ,pk_currtype -- 默认币种
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_vouchertype -- 凭证类别主键
            ,shortname -- 凭证类别简称
            ,shortname2 -- 凭证类别简称2
            ,shortname3 -- 凭证类别简称3
            ,shortname4 -- 凭证类别简称4
            ,shortname5 -- 凭证类别简称5
            ,shortname6 -- 凭证类别简称6
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_vouchertype_op(
            code -- 凭证类别编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 数据来源
            ,description -- 凭证类别描述
            ,description2 -- 凭证类别描述2
            ,description3 -- 凭证类别描述3
            ,description4 -- 凭证类别描述4
            ,description5 -- 凭证类别描述5
            ,description6 -- 凭证类别描述6
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 凭证类别名称
            ,name2 -- 凭证类别名称2
            ,name3 -- 凭证类别名称3
            ,name4 -- 凭证类别名称4
            ,name5 -- 凭证类别名称5
            ,name6 -- 凭证类别名称6
            ,pk_currtype -- 默认币种
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_vouchertype -- 凭证类别主键
            ,shortname -- 凭证类别简称
            ,shortname2 -- 凭证类别简称2
            ,shortname3 -- 凭证类别简称3
            ,shortname4 -- 凭证类别简称4
            ,shortname5 -- 凭证类别简称5
            ,shortname6 -- 凭证类别简称6
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.code, o.code) as code -- 凭证类别编码
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 数据来源
    ,nvl(n.description, o.description) as description -- 凭证类别描述
    ,nvl(n.description2, o.description2) as description2 -- 凭证类别描述2
    ,nvl(n.description3, o.description3) as description3 -- 凭证类别描述3
    ,nvl(n.description4, o.description4) as description4 -- 凭证类别描述4
    ,nvl(n.description5, o.description5) as description5 -- 凭证类别描述5
    ,nvl(n.description6, o.description6) as description6 -- 凭证类别描述6
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 启用状态
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.name, o.name) as name -- 凭证类别名称
    ,nvl(n.name2, o.name2) as name2 -- 凭证类别名称2
    ,nvl(n.name3, o.name3) as name3 -- 凭证类别名称3
    ,nvl(n.name4, o.name4) as name4 -- 凭证类别名称4
    ,nvl(n.name5, o.name5) as name5 -- 凭证类别名称5
    ,nvl(n.name6, o.name6) as name6 -- 凭证类别名称6
    ,nvl(n.pk_currtype, o.pk_currtype) as pk_currtype -- 默认币种
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.pk_vouchertype, o.pk_vouchertype) as pk_vouchertype -- 凭证类别主键
    ,nvl(n.shortname, o.shortname) as shortname -- 凭证类别简称
    ,nvl(n.shortname2, o.shortname2) as shortname2 -- 凭证类别简称2
    ,nvl(n.shortname3, o.shortname3) as shortname3 -- 凭证类别简称3
    ,nvl(n.shortname4, o.shortname4) as shortname4 -- 凭证类别简称4
    ,nvl(n.shortname5, o.shortname5) as shortname5 -- 凭证类别简称5
    ,nvl(n.shortname6, o.shortname6) as shortname6 -- 凭证类别简称6
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,case when
            n.pk_vouchertype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_vouchertype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_vouchertype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_bd_vouchertype_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_bd_vouchertype where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_vouchertype = n.pk_vouchertype
where (
        o.pk_vouchertype is null
    )
    or (
        n.pk_vouchertype is null
    )
    or (
        o.code <> n.code
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.description <> n.description
        or o.description2 <> n.description2
        or o.description3 <> n.description3
        or o.description4 <> n.description4
        or o.description5 <> n.description5
        or o.description6 <> n.description6
        or o.dr <> n.dr
        or o.enablestate <> n.enablestate
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.pk_currtype <> n.pk_currtype
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.shortname <> n.shortname
        or o.shortname2 <> n.shortname2
        or o.shortname3 <> n.shortname3
        or o.shortname4 <> n.shortname4
        or o.shortname5 <> n.shortname5
        or o.shortname6 <> n.shortname6
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_vouchertype_cl(
            code -- 凭证类别编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 数据来源
            ,description -- 凭证类别描述
            ,description2 -- 凭证类别描述2
            ,description3 -- 凭证类别描述3
            ,description4 -- 凭证类别描述4
            ,description5 -- 凭证类别描述5
            ,description6 -- 凭证类别描述6
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 凭证类别名称
            ,name2 -- 凭证类别名称2
            ,name3 -- 凭证类别名称3
            ,name4 -- 凭证类别名称4
            ,name5 -- 凭证类别名称5
            ,name6 -- 凭证类别名称6
            ,pk_currtype -- 默认币种
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_vouchertype -- 凭证类别主键
            ,shortname -- 凭证类别简称
            ,shortname2 -- 凭证类别简称2
            ,shortname3 -- 凭证类别简称3
            ,shortname4 -- 凭证类别简称4
            ,shortname5 -- 凭证类别简称5
            ,shortname6 -- 凭证类别简称6
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_vouchertype_op(
            code -- 凭证类别编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 数据来源
            ,description -- 凭证类别描述
            ,description2 -- 凭证类别描述2
            ,description3 -- 凭证类别描述3
            ,description4 -- 凭证类别描述4
            ,description5 -- 凭证类别描述5
            ,description6 -- 凭证类别描述6
            ,dr -- 删除标志
            ,enablestate -- 启用状态
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 凭证类别名称
            ,name2 -- 凭证类别名称2
            ,name3 -- 凭证类别名称3
            ,name4 -- 凭证类别名称4
            ,name5 -- 凭证类别名称5
            ,name6 -- 凭证类别名称6
            ,pk_currtype -- 默认币种
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_vouchertype -- 凭证类别主键
            ,shortname -- 凭证类别简称
            ,shortname2 -- 凭证类别简称2
            ,shortname3 -- 凭证类别简称3
            ,shortname4 -- 凭证类别简称4
            ,shortname5 -- 凭证类别简称5
            ,shortname6 -- 凭证类别简称6
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.code -- 凭证类别编码
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dataoriginflag -- 数据来源
    ,o.description -- 凭证类别描述
    ,o.description2 -- 凭证类别描述2
    ,o.description3 -- 凭证类别描述3
    ,o.description4 -- 凭证类别描述4
    ,o.description5 -- 凭证类别描述5
    ,o.description6 -- 凭证类别描述6
    ,o.dr -- 删除标志
    ,o.enablestate -- 启用状态
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.name -- 凭证类别名称
    ,o.name2 -- 凭证类别名称2
    ,o.name3 -- 凭证类别名称3
    ,o.name4 -- 凭证类别名称4
    ,o.name5 -- 凭证类别名称5
    ,o.name6 -- 凭证类别名称6
    ,o.pk_currtype -- 默认币种
    ,o.pk_group -- 所属集团
    ,o.pk_org -- 所属组织
    ,o.pk_vouchertype -- 凭证类别主键
    ,o.shortname -- 凭证类别简称
    ,o.shortname2 -- 凭证类别简称2
    ,o.shortname3 -- 凭证类别简称3
    ,o.shortname4 -- 凭证类别简称4
    ,o.shortname5 -- 凭证类别简称5
    ,o.shortname6 -- 凭证类别简称6
    ,o.ts -- 时间戳
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
from ${iol_schema}.iers_bd_vouchertype_bk o
    left join ${iol_schema}.iers_bd_vouchertype_op n
        on
            o.pk_vouchertype = n.pk_vouchertype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_bd_vouchertype_cl d
        on
            o.pk_vouchertype = d.pk_vouchertype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_bd_vouchertype;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_bd_vouchertype') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_bd_vouchertype drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_bd_vouchertype add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_bd_vouchertype exchange partition p_${batch_date} with table ${iol_schema}.iers_bd_vouchertype_cl;
alter table ${iol_schema}.iers_bd_vouchertype exchange partition p_20991231 with table ${iol_schema}.iers_bd_vouchertype_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_bd_vouchertype to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_vouchertype_op purge;
drop table ${iol_schema}.iers_bd_vouchertype_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_bd_vouchertype_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_bd_vouchertype',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
