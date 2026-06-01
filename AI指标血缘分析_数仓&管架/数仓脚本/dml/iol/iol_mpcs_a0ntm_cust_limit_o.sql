/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_cust_limit_o
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
create table ${iol_schema}.mpcs_a0ntm_cust_limit_o_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ntm_cust_limit_o
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_cust_limit_o_op purge;
drop table ${iol_schema}.mpcs_a0ntm_cust_limit_o_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_cust_limit_o_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_cust_limit_o where 0=1;

create table ${iol_schema}.mpcs_a0ntm_cust_limit_o_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_cust_limit_o where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_cust_limit_o_cl(
            org -- 机构号
            ,cust_limit_id -- 客户额度ID
            ,limit_category -- 额度种类
            ,limit_type -- 额度类型
            ,credit_limit -- 信用额度
            ,jpa_version -- 乐观锁版本号
            ,last_modified_datetime -- 修改时间
            ,created_datetime -- 创建时间
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_cust_limit_o_op(
            org -- 机构号
            ,cust_limit_id -- 客户额度ID
            ,limit_category -- 额度种类
            ,limit_type -- 额度类型
            ,credit_limit -- 信用额度
            ,jpa_version -- 乐观锁版本号
            ,last_modified_datetime -- 修改时间
            ,created_datetime -- 创建时间
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org, o.org) as org -- 机构号
    ,nvl(n.cust_limit_id, o.cust_limit_id) as cust_limit_id -- 客户额度ID
    ,nvl(n.limit_category, o.limit_category) as limit_category -- 额度种类
    ,nvl(n.limit_type, o.limit_type) as limit_type -- 额度类型
    ,nvl(n.credit_limit, o.credit_limit) as credit_limit -- 信用额度
    ,nvl(n.jpa_version, o.jpa_version) as jpa_version -- 乐观锁版本号
    ,nvl(n.last_modified_datetime, o.last_modified_datetime) as last_modified_datetime -- 修改时间
    ,nvl(n.created_datetime, o.created_datetime) as created_datetime -- 创建时间
    ,nvl(n.batchfilename, o.batchfilename) as batchfilename -- 批量文件名
    ,nvl(n.seqno, o.seqno) as seqno -- 序列号
    ,case when
            n.cust_limit_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_limit_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_limit_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0ntm_cust_limit_o_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0ntm_cust_limit_o where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_limit_id = n.cust_limit_id
where (
        o.cust_limit_id is null
    )
    or (
        n.cust_limit_id is null
    )
    or (
        o.org <> n.org
        or o.limit_category <> n.limit_category
        or o.limit_type <> n.limit_type
        or o.credit_limit <> n.credit_limit
        or o.jpa_version <> n.jpa_version
        or o.last_modified_datetime <> n.last_modified_datetime
        or o.created_datetime <> n.created_datetime
        or o.batchfilename <> n.batchfilename
        or o.seqno <> n.seqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_cust_limit_o_cl(
            org -- 机构号
            ,cust_limit_id -- 客户额度ID
            ,limit_category -- 额度种类
            ,limit_type -- 额度类型
            ,credit_limit -- 信用额度
            ,jpa_version -- 乐观锁版本号
            ,last_modified_datetime -- 修改时间
            ,created_datetime -- 创建时间
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_cust_limit_o_op(
            org -- 机构号
            ,cust_limit_id -- 客户额度ID
            ,limit_category -- 额度种类
            ,limit_type -- 额度类型
            ,credit_limit -- 信用额度
            ,jpa_version -- 乐观锁版本号
            ,last_modified_datetime -- 修改时间
            ,created_datetime -- 创建时间
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.cust_limit_id -- 客户额度ID
    ,o.limit_category -- 额度种类
    ,o.limit_type -- 额度类型
    ,o.credit_limit -- 信用额度
    ,o.jpa_version -- 乐观锁版本号
    ,o.last_modified_datetime -- 修改时间
    ,o.created_datetime -- 创建时间
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
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
from ${iol_schema}.mpcs_a0ntm_cust_limit_o_bk o
    left join ${iol_schema}.mpcs_a0ntm_cust_limit_o_op n
        on
            o.cust_limit_id = n.cust_limit_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0ntm_cust_limit_o_cl d
        on
            o.cust_limit_id = d.cust_limit_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0ntm_cust_limit_o;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0ntm_cust_limit_o') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0ntm_cust_limit_o drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0ntm_cust_limit_o add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0ntm_cust_limit_o exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0ntm_cust_limit_o_cl;
alter table ${iol_schema}.mpcs_a0ntm_cust_limit_o exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ntm_cust_limit_o_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_cust_limit_o to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_cust_limit_o_op purge;
drop table ${iol_schema}.mpcs_a0ntm_cust_limit_o_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ntm_cust_limit_o_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_cust_limit_o',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
