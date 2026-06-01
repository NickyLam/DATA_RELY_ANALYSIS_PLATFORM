/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fzss_mod_fzs_func_acct_info
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
create table ${iol_schema}.fzss_mod_fzs_func_acct_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fzss_mod_fzs_func_acct_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_func_acct_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_func_acct_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_func_acct_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_func_acct_info where 0=1;

create table ${iol_schema}.fzss_mod_fzs_func_acct_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_func_acct_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_func_acct_info_cl(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,func_acct_no -- 账户号
            ,func_acct_name -- 账户名
            ,acct_type -- 账户性质 [枚举: 01-红包,02-垫资,03-挂账,04-待清算,05-实时清算垫资功能户,09-其他]
            ,acct_status -- 账户状态 [枚举: 0-正常,1-销户,]
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_func_acct_info_op(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,func_acct_no -- 账户号
            ,func_acct_name -- 账户名
            ,acct_type -- 账户性质 [枚举: 01-红包,02-垫资,03-挂账,04-待清算,05-实时清算垫资功能户,09-其他]
            ,acct_status -- 账户状态 [枚举: 0-正常,1-销户,]
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.corp_id, o.corp_id) as corp_id -- 平台商户号
    ,nvl(n.mybank, o.mybank) as mybank -- 法人标识代码
    ,nvl(n.zone_no, o.zone_no) as zone_no -- 分行号
    ,nvl(n.func_acct_no, o.func_acct_no) as func_acct_no -- 账户号
    ,nvl(n.func_acct_name, o.func_acct_name) as func_acct_name -- 账户名
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户性质 [枚举: 01-红包,02-垫资,03-挂账,04-待清算,05-实时清算垫资功能户,09-其他]
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态 [枚举: 0-正常,1-销户,]
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,case when
            n.corp_id is null
            and n.func_acct_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.corp_id is null
            and n.func_acct_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.corp_id is null
            and n.func_acct_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fzss_mod_fzs_func_acct_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fzss_mod_fzs_func_acct_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.corp_id = n.corp_id
            and o.func_acct_no = n.func_acct_no
where (
        o.corp_id is null
        and o.func_acct_no is null
    )
    or (
        n.corp_id is null
        and n.func_acct_no is null
    )
    or (
        o.mybank <> n.mybank
        or o.zone_no <> n.zone_no
        or o.func_acct_name <> n.func_acct_name
        or o.acct_type <> n.acct_type
        or o.acct_status <> n.acct_status
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_func_acct_info_cl(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,func_acct_no -- 账户号
            ,func_acct_name -- 账户名
            ,acct_type -- 账户性质 [枚举: 01-红包,02-垫资,03-挂账,04-待清算,05-实时清算垫资功能户,09-其他]
            ,acct_status -- 账户状态 [枚举: 0-正常,1-销户,]
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_func_acct_info_op(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,func_acct_no -- 账户号
            ,func_acct_name -- 账户名
            ,acct_type -- 账户性质 [枚举: 01-红包,02-垫资,03-挂账,04-待清算,05-实时清算垫资功能户,09-其他]
            ,acct_status -- 账户状态 [枚举: 0-正常,1-销户,]
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.corp_id -- 平台商户号
    ,o.mybank -- 法人标识代码
    ,o.zone_no -- 分行号
    ,o.func_acct_no -- 账户号
    ,o.func_acct_name -- 账户名
    ,o.acct_type -- 账户性质 [枚举: 01-红包,02-垫资,03-挂账,04-待清算,05-实时清算垫资功能户,09-其他]
    ,o.acct_status -- 账户状态 [枚举: 0-正常,1-销户,]
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
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
from ${iol_schema}.fzss_mod_fzs_func_acct_info_bk o
    left join ${iol_schema}.fzss_mod_fzs_func_acct_info_op n
        on
            o.corp_id = n.corp_id
            and o.func_acct_no = n.func_acct_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fzss_mod_fzs_func_acct_info_cl d
        on
            o.corp_id = d.corp_id
            and o.func_acct_no = d.func_acct_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fzss_mod_fzs_func_acct_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fzss_mod_fzs_func_acct_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fzss_mod_fzs_func_acct_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fzss_mod_fzs_func_acct_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fzss_mod_fzs_func_acct_info exchange partition p_${batch_date} with table ${iol_schema}.fzss_mod_fzs_func_acct_info_cl;
alter table ${iol_schema}.fzss_mod_fzs_func_acct_info exchange partition p_20991231 with table ${iol_schema}.fzss_mod_fzs_func_acct_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fzss_mod_fzs_func_acct_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_func_acct_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_func_acct_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fzss_mod_fzs_func_acct_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fzss_mod_fzs_func_acct_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
