/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_security_cus_field
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
create table ${iol_schema}.ctms_tbs_v_security_cus_field_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_security_cus_field
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_cus_field_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_cus_field_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_cus_field_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_cus_field where 0=1;

create table ${iol_schema}.ctms_tbs_v_security_cus_field_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_cus_field where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_cus_field_cl(
            security_cus_field_id -- (KMS)自定义字段ID
            ,field_id -- CMS自定义字段ID
            ,field_name -- 自定义字段定义名称
            ,field_value -- 自定义字段定义值
            ,security_code -- 债券代码
            ,seq -- 序列号
            ,field_modify_time -- 自定义字段更新时间
            ,value_modify_time -- 自定义字段值更新时间
            ,datasymbol_id -- 数据源ID
            ,aspclient_id -- 部门ID
            ,lastmodified -- 修改时间
            ,cus_number -- 机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_cus_field_op(
            security_cus_field_id -- (KMS)自定义字段ID
            ,field_id -- CMS自定义字段ID
            ,field_name -- 自定义字段定义名称
            ,field_value -- 自定义字段定义值
            ,security_code -- 债券代码
            ,seq -- 序列号
            ,field_modify_time -- 自定义字段更新时间
            ,value_modify_time -- 自定义字段值更新时间
            ,datasymbol_id -- 数据源ID
            ,aspclient_id -- 部门ID
            ,lastmodified -- 修改时间
            ,cus_number -- 机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.security_cus_field_id, o.security_cus_field_id) as security_cus_field_id -- (KMS)自定义字段ID
    ,nvl(n.field_id, o.field_id) as field_id -- CMS自定义字段ID
    ,nvl(n.field_name, o.field_name) as field_name -- 自定义字段定义名称
    ,nvl(n.field_value, o.field_value) as field_value -- 自定义字段定义值
    ,nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.seq, o.seq) as seq -- 序列号
    ,nvl(n.field_modify_time, o.field_modify_time) as field_modify_time -- 自定义字段更新时间
    ,nvl(n.value_modify_time, o.value_modify_time) as value_modify_time -- 自定义字段值更新时间
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源ID
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门ID
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 修改时间
    ,nvl(n.cus_number, o.cus_number) as cus_number -- 机构号
    ,case when
            n.security_cus_field_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.security_cus_field_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.security_cus_field_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_security_cus_field_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_security_cus_field where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.security_cus_field_id = n.security_cus_field_id
where (
        o.security_cus_field_id is null
    )
    or (
        n.security_cus_field_id is null
    )
    or (
        o.field_id <> n.field_id
        or o.field_name <> n.field_name
        or o.field_value <> n.field_value
        or o.security_code <> n.security_code
        or o.seq <> n.seq
        or o.field_modify_time <> n.field_modify_time
        or o.value_modify_time <> n.value_modify_time
        or o.datasymbol_id <> n.datasymbol_id
        or o.aspclient_id <> n.aspclient_id
        or o.lastmodified <> n.lastmodified
        or o.cus_number <> n.cus_number
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_cus_field_cl(
            security_cus_field_id -- (KMS)自定义字段ID
            ,field_id -- CMS自定义字段ID
            ,field_name -- 自定义字段定义名称
            ,field_value -- 自定义字段定义值
            ,security_code -- 债券代码
            ,seq -- 序列号
            ,field_modify_time -- 自定义字段更新时间
            ,value_modify_time -- 自定义字段值更新时间
            ,datasymbol_id -- 数据源ID
            ,aspclient_id -- 部门ID
            ,lastmodified -- 修改时间
            ,cus_number -- 机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_cus_field_op(
            security_cus_field_id -- (KMS)自定义字段ID
            ,field_id -- CMS自定义字段ID
            ,field_name -- 自定义字段定义名称
            ,field_value -- 自定义字段定义值
            ,security_code -- 债券代码
            ,seq -- 序列号
            ,field_modify_time -- 自定义字段更新时间
            ,value_modify_time -- 自定义字段值更新时间
            ,datasymbol_id -- 数据源ID
            ,aspclient_id -- 部门ID
            ,lastmodified -- 修改时间
            ,cus_number -- 机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.security_cus_field_id -- (KMS)自定义字段ID
    ,o.field_id -- CMS自定义字段ID
    ,o.field_name -- 自定义字段定义名称
    ,o.field_value -- 自定义字段定义值
    ,o.security_code -- 债券代码
    ,o.seq -- 序列号
    ,o.field_modify_time -- 自定义字段更新时间
    ,o.value_modify_time -- 自定义字段值更新时间
    ,o.datasymbol_id -- 数据源ID
    ,o.aspclient_id -- 部门ID
    ,o.lastmodified -- 修改时间
    ,o.cus_number -- 机构号
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
from ${iol_schema}.ctms_tbs_v_security_cus_field_bk o
    left join ${iol_schema}.ctms_tbs_v_security_cus_field_op n
        on
            o.security_cus_field_id = n.security_cus_field_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_security_cus_field_cl d
        on
            o.security_cus_field_id = d.security_cus_field_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_tbs_v_security_cus_field;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_tbs_v_security_cus_field') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_tbs_v_security_cus_field drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_tbs_v_security_cus_field add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_tbs_v_security_cus_field exchange partition p_${batch_date} with table ${iol_schema}.ctms_tbs_v_security_cus_field_cl;
alter table ${iol_schema}.ctms_tbs_v_security_cus_field exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_security_cus_field_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_security_cus_field to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_cus_field_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_cus_field_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_security_cus_field_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_security_cus_field',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
