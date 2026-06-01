/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uuss_uus_post
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
create table ${iol_schema}.uuss_uus_post_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uuss_uus_post;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_post_op purge;
drop table ${iol_schema}.uuss_uus_post_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_post_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_post where 0=1;

create table ${iol_schema}.uuss_uus_post_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_post where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_post_cl(
            postcode -- 岗位编号
            ,organcode -- 机构编码
            ,postname -- 岗位名称
            ,isbasepost -- 基准岗位标识
            ,linecode -- 条线编码
            ,serialcode -- 序列编码
            ,type -- 类型
            ,enablestate -- 启用状态
            ,placecode -- 职务编码
            ,currdate -- 创建日期
            ,currtime -- 创建时间
            ,updatedate -- 更新日期
            ,updatetime -- 更新时间
            ,createuser -- 创建人
            ,updateuser -- 最后修改人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_post_op(
            postcode -- 岗位编号
            ,organcode -- 机构编码
            ,postname -- 岗位名称
            ,isbasepost -- 基准岗位标识
            ,linecode -- 条线编码
            ,serialcode -- 序列编码
            ,type -- 类型
            ,enablestate -- 启用状态
            ,placecode -- 职务编码
            ,currdate -- 创建日期
            ,currtime -- 创建时间
            ,updatedate -- 更新日期
            ,updatetime -- 更新时间
            ,createuser -- 创建人
            ,updateuser -- 最后修改人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.postcode, o.postcode) as postcode -- 岗位编号
    ,nvl(n.organcode, o.organcode) as organcode -- 机构编码
    ,nvl(n.postname, o.postname) as postname -- 岗位名称
    ,nvl(n.isbasepost, o.isbasepost) as isbasepost -- 基准岗位标识
    ,nvl(n.linecode, o.linecode) as linecode -- 条线编码
    ,nvl(n.serialcode, o.serialcode) as serialcode -- 序列编码
    ,nvl(n.type, o.type) as type -- 类型
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 启用状态
    ,nvl(n.placecode, o.placecode) as placecode -- 职务编码
    ,nvl(n.currdate, o.currdate) as currdate -- 创建日期
    ,nvl(n.currtime, o.currtime) as currtime -- 创建时间
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.createuser, o.createuser) as createuser -- 创建人
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 最后修改人
    ,case when
            n.postcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.postcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.postcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uuss_uus_post_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uuss_uus_post where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.postcode = n.postcode
where (
        o.postcode is null
    )
    or (
        n.postcode is null
    )
    or (
        o.organcode <> n.organcode
        or o.postname <> n.postname
        or o.isbasepost <> n.isbasepost
        or o.linecode <> n.linecode
        or o.serialcode <> n.serialcode
        or o.type <> n.type
        or o.enablestate <> n.enablestate
        or o.placecode <> n.placecode
        or o.currdate <> n.currdate
        or o.currtime <> n.currtime
        or o.updatedate <> n.updatedate
        or o.updatetime <> n.updatetime
        or o.createuser <> n.createuser
        or o.updateuser <> n.updateuser
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_post_cl(
            postcode -- 岗位编号
            ,organcode -- 机构编码
            ,postname -- 岗位名称
            ,isbasepost -- 基准岗位标识
            ,linecode -- 条线编码
            ,serialcode -- 序列编码
            ,type -- 类型
            ,enablestate -- 启用状态
            ,placecode -- 职务编码
            ,currdate -- 创建日期
            ,currtime -- 创建时间
            ,updatedate -- 更新日期
            ,updatetime -- 更新时间
            ,createuser -- 创建人
            ,updateuser -- 最后修改人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_post_op(
            postcode -- 岗位编号
            ,organcode -- 机构编码
            ,postname -- 岗位名称
            ,isbasepost -- 基准岗位标识
            ,linecode -- 条线编码
            ,serialcode -- 序列编码
            ,type -- 类型
            ,enablestate -- 启用状态
            ,placecode -- 职务编码
            ,currdate -- 创建日期
            ,currtime -- 创建时间
            ,updatedate -- 更新日期
            ,updatetime -- 更新时间
            ,createuser -- 创建人
            ,updateuser -- 最后修改人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.postcode -- 岗位编号
    ,o.organcode -- 机构编码
    ,o.postname -- 岗位名称
    ,o.isbasepost -- 基准岗位标识
    ,o.linecode -- 条线编码
    ,o.serialcode -- 序列编码
    ,o.type -- 类型
    ,o.enablestate -- 启用状态
    ,o.placecode -- 职务编码
    ,o.currdate -- 创建日期
    ,o.currtime -- 创建时间
    ,o.updatedate -- 更新日期
    ,o.updatetime -- 更新时间
    ,o.createuser -- 创建人
    ,o.updateuser -- 最后修改人
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.uuss_uus_post_bk o
    left join ${iol_schema}.uuss_uus_post_op n
        on
            o.postcode = n.postcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uuss_uus_post_cl d
        on
            o.postcode = d.postcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.uuss_uus_post;

-- 4.2 exchange partition
alter table ${iol_schema}.uuss_uus_post exchange partition p_19000101 with table ${iol_schema}.uuss_uus_post_cl;
alter table ${iol_schema}.uuss_uus_post exchange partition p_20991231 with table ${iol_schema}.uuss_uus_post_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uuss_uus_post to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_post_op purge;
drop table ${iol_schema}.uuss_uus_post_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uuss_uus_post_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uuss_uus_post',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
