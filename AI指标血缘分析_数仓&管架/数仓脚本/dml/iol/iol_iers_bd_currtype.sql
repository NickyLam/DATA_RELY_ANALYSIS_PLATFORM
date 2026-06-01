/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_bd_currtype
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
create table ${iol_schema}.iers_bd_currtype_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_bd_currtype
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_currtype_op purge;
drop table ${iol_schema}.iers_bd_currtype_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_currtype_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_currtype where 0=1;

create table ${iol_schema}.iers_bd_currtype_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_currtype where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_currtype_cl(
            code -- 币种编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,currdigit -- 金额小数位数
            ,currtypesign -- 币种币符
            ,dataoriginflag -- 分布式
            ,dr -- 删除标志
            ,isdefault -- 全局本位币
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 币种名称
            ,name2 -- 币种名称2
            ,name3 -- 币种名称3
            ,name4 -- 币种名称4
            ,name5 -- 币种名称5
            ,name6 -- 币种名称6
            ,pk_currtype -- 币种主键
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,roundtype -- 金额进舍规则
            ,ts -- 时间戳
            ,unitcurrdigit -- 单价小数位数
            ,unitroundtype -- 单价进舍规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_currtype_op(
            code -- 币种编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,currdigit -- 金额小数位数
            ,currtypesign -- 币种币符
            ,dataoriginflag -- 分布式
            ,dr -- 删除标志
            ,isdefault -- 全局本位币
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 币种名称
            ,name2 -- 币种名称2
            ,name3 -- 币种名称3
            ,name4 -- 币种名称4
            ,name5 -- 币种名称5
            ,name6 -- 币种名称6
            ,pk_currtype -- 币种主键
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,roundtype -- 金额进舍规则
            ,ts -- 时间戳
            ,unitcurrdigit -- 单价小数位数
            ,unitroundtype -- 单价进舍规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.code, o.code) as code -- 币种编码
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.currdigit, o.currdigit) as currdigit -- 金额小数位数
    ,nvl(n.currtypesign, o.currtypesign) as currtypesign -- 币种币符
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 分布式
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.isdefault, o.isdefault) as isdefault -- 全局本位币
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.name, o.name) as name -- 币种名称
    ,nvl(n.name2, o.name2) as name2 -- 币种名称2
    ,nvl(n.name3, o.name3) as name3 -- 币种名称3
    ,nvl(n.name4, o.name4) as name4 -- 币种名称4
    ,nvl(n.name5, o.name5) as name5 -- 币种名称5
    ,nvl(n.name6, o.name6) as name6 -- 币种名称6
    ,nvl(n.pk_currtype, o.pk_currtype) as pk_currtype -- 币种主键
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.roundtype, o.roundtype) as roundtype -- 金额进舍规则
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.unitcurrdigit, o.unitcurrdigit) as unitcurrdigit -- 单价小数位数
    ,nvl(n.unitroundtype, o.unitroundtype) as unitroundtype -- 单价进舍规则
    ,case when
            n.pk_currtype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_currtype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_currtype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_bd_currtype_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_bd_currtype where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_currtype = n.pk_currtype
where (
        o.pk_currtype is null
    )
    or (
        n.pk_currtype is null
    )
    or (
        o.code <> n.code
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.currdigit <> n.currdigit
        or o.currtypesign <> n.currtypesign
        or o.dataoriginflag <> n.dataoriginflag
        or o.dr <> n.dr
        or o.isdefault <> n.isdefault
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.roundtype <> n.roundtype
        or o.ts <> n.ts
        or o.unitcurrdigit <> n.unitcurrdigit
        or o.unitroundtype <> n.unitroundtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_currtype_cl(
            code -- 币种编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,currdigit -- 金额小数位数
            ,currtypesign -- 币种币符
            ,dataoriginflag -- 分布式
            ,dr -- 删除标志
            ,isdefault -- 全局本位币
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 币种名称
            ,name2 -- 币种名称2
            ,name3 -- 币种名称3
            ,name4 -- 币种名称4
            ,name5 -- 币种名称5
            ,name6 -- 币种名称6
            ,pk_currtype -- 币种主键
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,roundtype -- 金额进舍规则
            ,ts -- 时间戳
            ,unitcurrdigit -- 单价小数位数
            ,unitroundtype -- 单价进舍规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_currtype_op(
            code -- 币种编码
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,currdigit -- 金额小数位数
            ,currtypesign -- 币种币符
            ,dataoriginflag -- 分布式
            ,dr -- 删除标志
            ,isdefault -- 全局本位币
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 币种名称
            ,name2 -- 币种名称2
            ,name3 -- 币种名称3
            ,name4 -- 币种名称4
            ,name5 -- 币种名称5
            ,name6 -- 币种名称6
            ,pk_currtype -- 币种主键
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,roundtype -- 金额进舍规则
            ,ts -- 时间戳
            ,unitcurrdigit -- 单价小数位数
            ,unitroundtype -- 单价进舍规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.code -- 币种编码
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.currdigit -- 金额小数位数
    ,o.currtypesign -- 币种币符
    ,o.dataoriginflag -- 分布式
    ,o.dr -- 删除标志
    ,o.isdefault -- 全局本位币
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.name -- 币种名称
    ,o.name2 -- 币种名称2
    ,o.name3 -- 币种名称3
    ,o.name4 -- 币种名称4
    ,o.name5 -- 币种名称5
    ,o.name6 -- 币种名称6
    ,o.pk_currtype -- 币种主键
    ,o.pk_group -- 所属集团
    ,o.pk_org -- 所属组织
    ,o.roundtype -- 金额进舍规则
    ,o.ts -- 时间戳
    ,o.unitcurrdigit -- 单价小数位数
    ,o.unitroundtype -- 单价进舍规则
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
from ${iol_schema}.iers_bd_currtype_bk o
    left join ${iol_schema}.iers_bd_currtype_op n
        on
            o.pk_currtype = n.pk_currtype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_bd_currtype_cl d
        on
            o.pk_currtype = d.pk_currtype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_bd_currtype;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_bd_currtype') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_bd_currtype drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_bd_currtype add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_bd_currtype exchange partition p_${batch_date} with table ${iol_schema}.iers_bd_currtype_cl;
alter table ${iol_schema}.iers_bd_currtype exchange partition p_20991231 with table ${iol_schema}.iers_bd_currtype_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_bd_currtype to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_currtype_op purge;
drop table ${iol_schema}.iers_bd_currtype_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_bd_currtype_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_bd_currtype',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
