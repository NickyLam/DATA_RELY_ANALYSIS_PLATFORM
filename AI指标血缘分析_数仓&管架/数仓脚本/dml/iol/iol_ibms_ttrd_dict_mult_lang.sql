/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_dict_mult_lang
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
create table ${iol_schema}.ibms_ttrd_dict_mult_lang_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_dict_mult_lang
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_dict_mult_lang_op purge;
drop table ${iol_schema}.ibms_ttrd_dict_mult_lang_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_dict_mult_lang_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_dict_mult_lang where 0=1;

create table ${iol_schema}.ibms_ttrd_dict_mult_lang_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_dict_mult_lang where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_dict_mult_lang_cl(
            dict_type -- 字典分类
            ,dict_sub_type -- 字典子分类
            ,dict_key -- 字典键值
            ,dict_lang -- 语言种类
            ,dict_value -- 字典值
            ,dict_key_order -- 字典显示顺序
            ,loadflag -- 加载类型
            ,isdefault -- 是否默认值
            ,dict_description -- 扩展字段描述
            ,front_flag -- 是否前台使用，0：否；1：是，会加载到JS缓存，减少前台请求
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_dict_mult_lang_op(
            dict_type -- 字典分类
            ,dict_sub_type -- 字典子分类
            ,dict_key -- 字典键值
            ,dict_lang -- 语言种类
            ,dict_value -- 字典值
            ,dict_key_order -- 字典显示顺序
            ,loadflag -- 加载类型
            ,isdefault -- 是否默认值
            ,dict_description -- 扩展字段描述
            ,front_flag -- 是否前台使用，0：否；1：是，会加载到JS缓存，减少前台请求
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dict_type, o.dict_type) as dict_type -- 字典分类
    ,nvl(n.dict_sub_type, o.dict_sub_type) as dict_sub_type -- 字典子分类
    ,nvl(n.dict_key, o.dict_key) as dict_key -- 字典键值
    ,nvl(n.dict_lang, o.dict_lang) as dict_lang -- 语言种类
    ,nvl(n.dict_value, o.dict_value) as dict_value -- 字典值
    ,nvl(n.dict_key_order, o.dict_key_order) as dict_key_order -- 字典显示顺序
    ,nvl(n.loadflag, o.loadflag) as loadflag -- 加载类型
    ,nvl(n.isdefault, o.isdefault) as isdefault -- 是否默认值
    ,nvl(n.dict_description, o.dict_description) as dict_description -- 扩展字段描述
    ,nvl(n.front_flag, o.front_flag) as front_flag -- 是否前台使用，0：否；1：是，会加载到JS缓存，减少前台请求
    ,case when
            n.dict_type is null
            and n.dict_sub_type is null
            and n.dict_key is null
            and n.dict_lang is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dict_type is null
            and n.dict_sub_type is null
            and n.dict_key is null
            and n.dict_lang is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dict_type is null
            and n.dict_sub_type is null
            and n.dict_key is null
            and n.dict_lang is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_dict_mult_lang_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_dict_mult_lang where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.dict_type = n.dict_type
            and o.dict_sub_type = n.dict_sub_type
            and o.dict_key = n.dict_key
            and o.dict_lang = n.dict_lang
where (
        o.dict_type is null
        and o.dict_sub_type is null
        and o.dict_key is null
        and o.dict_lang is null
    )
    or (
        n.dict_type is null
        and n.dict_sub_type is null
        and n.dict_key is null
        and n.dict_lang is null
    )
    or (
        o.dict_value <> n.dict_value
        or o.dict_key_order <> n.dict_key_order
        or o.loadflag <> n.loadflag
        or o.isdefault <> n.isdefault
        or o.dict_description <> n.dict_description
        or o.front_flag <> n.front_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_dict_mult_lang_cl(
            dict_type -- 字典分类
            ,dict_sub_type -- 字典子分类
            ,dict_key -- 字典键值
            ,dict_lang -- 语言种类
            ,dict_value -- 字典值
            ,dict_key_order -- 字典显示顺序
            ,loadflag -- 加载类型
            ,isdefault -- 是否默认值
            ,dict_description -- 扩展字段描述
            ,front_flag -- 是否前台使用，0：否；1：是，会加载到JS缓存，减少前台请求
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_dict_mult_lang_op(
            dict_type -- 字典分类
            ,dict_sub_type -- 字典子分类
            ,dict_key -- 字典键值
            ,dict_lang -- 语言种类
            ,dict_value -- 字典值
            ,dict_key_order -- 字典显示顺序
            ,loadflag -- 加载类型
            ,isdefault -- 是否默认值
            ,dict_description -- 扩展字段描述
            ,front_flag -- 是否前台使用，0：否；1：是，会加载到JS缓存，减少前台请求
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dict_type -- 字典分类
    ,o.dict_sub_type -- 字典子分类
    ,o.dict_key -- 字典键值
    ,o.dict_lang -- 语言种类
    ,o.dict_value -- 字典值
    ,o.dict_key_order -- 字典显示顺序
    ,o.loadflag -- 加载类型
    ,o.isdefault -- 是否默认值
    ,o.dict_description -- 扩展字段描述
    ,o.front_flag -- 是否前台使用，0：否；1：是，会加载到JS缓存，减少前台请求
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
from ${iol_schema}.ibms_ttrd_dict_mult_lang_bk o
    left join ${iol_schema}.ibms_ttrd_dict_mult_lang_op n
        on
            o.dict_type = n.dict_type
            and o.dict_sub_type = n.dict_sub_type
            and o.dict_key = n.dict_key
            and o.dict_lang = n.dict_lang
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_dict_mult_lang_cl d
        on
            o.dict_type = d.dict_type
            and o.dict_sub_type = d.dict_sub_type
            and o.dict_key = d.dict_key
            and o.dict_lang = d.dict_lang
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_dict_mult_lang;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_dict_mult_lang') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_dict_mult_lang drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_dict_mult_lang add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_dict_mult_lang exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_dict_mult_lang_cl;
alter table ${iol_schema}.ibms_ttrd_dict_mult_lang exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_dict_mult_lang_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_dict_mult_lang to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_dict_mult_lang_op purge;
drop table ${iol_schema}.ibms_ttrd_dict_mult_lang_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_dict_mult_lang_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_dict_mult_lang',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
