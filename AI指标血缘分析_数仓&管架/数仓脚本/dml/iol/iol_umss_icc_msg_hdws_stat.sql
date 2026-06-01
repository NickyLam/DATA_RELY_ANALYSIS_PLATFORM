/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_umss_icc_msg_hdws_stat
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
create table ${iol_schema}.umss_icc_msg_hdws_stat_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.umss_icc_msg_hdws_stat
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.umss_icc_msg_hdws_stat_op purge;
drop table ${iol_schema}.umss_icc_msg_hdws_stat_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.umss_icc_msg_hdws_stat_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.umss_icc_msg_hdws_stat where 0=1;

create table ${iol_schema}.umss_icc_msg_hdws_stat_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.umss_icc_msg_hdws_stat where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.umss_icc_msg_hdws_stat_cl(
            id -- ID
            ,pack_id -- 批次ID
            ,batch_name -- 批次名称
            ,terminal_id -- 手机号
            ,cust_id -- 客户号
            ,state -- 平台提交给运营商网关的结果，0成功，1失败
            ,origin_result -- 运营商原始送达状态
            ,result -- 送达状态0成功，1失败，2未知
            ,short_url -- 是否有短链，0有，1无
            ,click_url -- 短链是否点开，0有，1无
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.umss_icc_msg_hdws_stat_op(
            id -- ID
            ,pack_id -- 批次ID
            ,batch_name -- 批次名称
            ,terminal_id -- 手机号
            ,cust_id -- 客户号
            ,state -- 平台提交给运营商网关的结果，0成功，1失败
            ,origin_result -- 运营商原始送达状态
            ,result -- 送达状态0成功，1失败，2未知
            ,short_url -- 是否有短链，0有，1无
            ,click_url -- 短链是否点开，0有，1无
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.pack_id, o.pack_id) as pack_id -- 批次ID
    ,nvl(n.batch_name, o.batch_name) as batch_name -- 批次名称
    ,nvl(n.terminal_id, o.terminal_id) as terminal_id -- 手机号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.state, o.state) as state -- 平台提交给运营商网关的结果，0成功，1失败
    ,nvl(n.origin_result, o.origin_result) as origin_result -- 运营商原始送达状态
    ,nvl(n.result, o.result) as result -- 送达状态0成功，1失败，2未知
    ,nvl(n.short_url, o.short_url) as short_url -- 是否有短链，0有，1无
    ,nvl(n.click_url, o.click_url) as click_url -- 短链是否点开，0有，1无
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.umss_icc_msg_hdws_stat_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.umss_icc_msg_hdws_stat where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.pack_id <> n.pack_id
        or o.batch_name <> n.batch_name
        or o.terminal_id <> n.terminal_id
        or o.cust_id <> n.cust_id
        or o.state <> n.state
        or o.origin_result <> n.origin_result
        or o.result <> n.result
        or o.short_url <> n.short_url
        or o.click_url <> n.click_url
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.umss_icc_msg_hdws_stat_cl(
            id -- ID
            ,pack_id -- 批次ID
            ,batch_name -- 批次名称
            ,terminal_id -- 手机号
            ,cust_id -- 客户号
            ,state -- 平台提交给运营商网关的结果，0成功，1失败
            ,origin_result -- 运营商原始送达状态
            ,result -- 送达状态0成功，1失败，2未知
            ,short_url -- 是否有短链，0有，1无
            ,click_url -- 短链是否点开，0有，1无
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.umss_icc_msg_hdws_stat_op(
            id -- ID
            ,pack_id -- 批次ID
            ,batch_name -- 批次名称
            ,terminal_id -- 手机号
            ,cust_id -- 客户号
            ,state -- 平台提交给运营商网关的结果，0成功，1失败
            ,origin_result -- 运营商原始送达状态
            ,result -- 送达状态0成功，1失败，2未知
            ,short_url -- 是否有短链，0有，1无
            ,click_url -- 短链是否点开，0有，1无
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.pack_id -- 批次ID
    ,o.batch_name -- 批次名称
    ,o.terminal_id -- 手机号
    ,o.cust_id -- 客户号
    ,o.state -- 平台提交给运营商网关的结果，0成功，1失败
    ,o.origin_result -- 运营商原始送达状态
    ,o.result -- 送达状态0成功，1失败，2未知
    ,o.short_url -- 是否有短链，0有，1无
    ,o.click_url -- 短链是否点开，0有，1无
    ,o.create_time -- 创建时间
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
from ${iol_schema}.umss_icc_msg_hdws_stat_bk o
    left join ${iol_schema}.umss_icc_msg_hdws_stat_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.umss_icc_msg_hdws_stat_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.umss_icc_msg_hdws_stat;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('umss_icc_msg_hdws_stat') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.umss_icc_msg_hdws_stat drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.umss_icc_msg_hdws_stat add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.umss_icc_msg_hdws_stat exchange partition p_${batch_date} with table ${iol_schema}.umss_icc_msg_hdws_stat_cl;
alter table ${iol_schema}.umss_icc_msg_hdws_stat exchange partition p_20991231 with table ${iol_schema}.umss_icc_msg_hdws_stat_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.umss_icc_msg_hdws_stat to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.umss_icc_msg_hdws_stat_op purge;
drop table ${iol_schema}.umss_icc_msg_hdws_stat_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.umss_icc_msg_hdws_stat_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'umss_icc_msg_hdws_stat',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
