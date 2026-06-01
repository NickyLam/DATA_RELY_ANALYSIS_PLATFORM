/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccrm_t_cust_czxck_info
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
create table ${iol_schema}.ccrm_t_cust_czxck_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccrm_t_cust_czxck_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccrm_t_cust_czxck_info_op purge;
drop table ${iol_schema}.ccrm_t_cust_czxck_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccrm_t_cust_czxck_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccrm_t_cust_czxck_info where 0=1;

create table ${iol_schema}.ccrm_t_cust_czxck_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccrm_t_cust_czxck_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccrm_t_cust_czxck_info_cl(
            czxck_id -- 主键ID
            ,pty_id -- 客户ID
            ,cn_fname -- 客户名称
            ,acct_num -- 账号
            ,czxck_flag -- 是否财政性存款标识
            ,rd_date -- 认定日期
            ,oper_user -- 创建人ID
            ,oper_org -- 创建人机构ID
            ,oper_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccrm_t_cust_czxck_info_op(
            czxck_id -- 主键ID
            ,pty_id -- 客户ID
            ,cn_fname -- 客户名称
            ,acct_num -- 账号
            ,czxck_flag -- 是否财政性存款标识
            ,rd_date -- 认定日期
            ,oper_user -- 创建人ID
            ,oper_org -- 创建人机构ID
            ,oper_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.czxck_id, o.czxck_id) as czxck_id -- 主键ID
    ,nvl(n.pty_id, o.pty_id) as pty_id -- 客户ID
    ,nvl(n.cn_fname, o.cn_fname) as cn_fname -- 客户名称
    ,nvl(n.acct_num, o.acct_num) as acct_num -- 账号
    ,nvl(n.czxck_flag, o.czxck_flag) as czxck_flag -- 是否财政性存款标识
    ,nvl(n.rd_date, o.rd_date) as rd_date -- 认定日期
    ,nvl(n.oper_user, o.oper_user) as oper_user -- 创建人ID
    ,nvl(n.oper_org, o.oper_org) as oper_org -- 创建人机构ID
    ,nvl(n.oper_time, o.oper_time) as oper_time -- 创建时间
    ,case when
            n.czxck_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.czxck_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.czxck_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccrm_t_cust_czxck_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ccrm_t_cust_czxck_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.czxck_id = n.czxck_id
where (
        o.czxck_id is null
    )
    or (
        n.czxck_id is null
    )
    or (
        o.pty_id <> n.pty_id
        or o.cn_fname <> n.cn_fname
        or o.acct_num <> n.acct_num
        or o.czxck_flag <> n.czxck_flag
        or o.rd_date <> n.rd_date
        or o.oper_user <> n.oper_user
        or o.oper_org <> n.oper_org
        or o.oper_time <> n.oper_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccrm_t_cust_czxck_info_cl(
            czxck_id -- 主键ID
            ,pty_id -- 客户ID
            ,cn_fname -- 客户名称
            ,acct_num -- 账号
            ,czxck_flag -- 是否财政性存款标识
            ,rd_date -- 认定日期
            ,oper_user -- 创建人ID
            ,oper_org -- 创建人机构ID
            ,oper_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccrm_t_cust_czxck_info_op(
            czxck_id -- 主键ID
            ,pty_id -- 客户ID
            ,cn_fname -- 客户名称
            ,acct_num -- 账号
            ,czxck_flag -- 是否财政性存款标识
            ,rd_date -- 认定日期
            ,oper_user -- 创建人ID
            ,oper_org -- 创建人机构ID
            ,oper_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.czxck_id -- 主键ID
    ,o.pty_id -- 客户ID
    ,o.cn_fname -- 客户名称
    ,o.acct_num -- 账号
    ,o.czxck_flag -- 是否财政性存款标识
    ,o.rd_date -- 认定日期
    ,o.oper_user -- 创建人ID
    ,o.oper_org -- 创建人机构ID
    ,o.oper_time -- 创建时间
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
from ${iol_schema}.ccrm_t_cust_czxck_info_bk o
    left join ${iol_schema}.ccrm_t_cust_czxck_info_op n
        on
            o.czxck_id = n.czxck_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ccrm_t_cust_czxck_info_cl d
        on
            o.czxck_id = d.czxck_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccrm_t_cust_czxck_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ccrm_t_cust_czxck_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ccrm_t_cust_czxck_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ccrm_t_cust_czxck_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ccrm_t_cust_czxck_info exchange partition p_${batch_date} with table ${iol_schema}.ccrm_t_cust_czxck_info_cl;
alter table ${iol_schema}.ccrm_t_cust_czxck_info exchange partition p_20991231 with table ${iol_schema}.ccrm_t_cust_czxck_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccrm_t_cust_czxck_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccrm_t_cust_czxck_info_op purge;
drop table ${iol_schema}.ccrm_t_cust_czxck_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccrm_t_cust_czxck_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccrm_t_cust_czxck_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
