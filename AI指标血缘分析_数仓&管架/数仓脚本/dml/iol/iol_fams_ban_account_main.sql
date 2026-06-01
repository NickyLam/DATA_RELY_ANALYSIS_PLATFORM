/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ban_account_main
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
create table ${iol_schema}.fams_ban_account_main_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ban_account_main
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_account_main_op purge;
drop table ${iol_schema}.fams_ban_account_main_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_account_main_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_account_main where 0=1;

create table ${iol_schema}.fams_ban_account_main_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_account_main where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_account_main_cl(
            vouch_num -- 凭证编号
            ,bus_vouchnum -- 凭证编号
            ,bookset_id -- 账套代码
            ,trade_id -- 交易编号
            ,book_date -- 日期
            ,com_table_id -- 合并场景代码
            ,vouch_remark -- 凭证说明
            ,offset_flag -- 冲正标识
            ,vouch_year -- 年份
            ,vouch_month -- 月份
            ,num -- 编号位数
            ,book_type -- 凭证类型
            ,handle_user -- 经办人
            ,approve_user -- 复核人
            ,approve_status -- 审批状态
            ,send_user -- 发送人
            ,send_status -- 发送状态
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,vouch_type -- 账务类型
            ,customer_name -- 客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_account_main_op(
            vouch_num -- 凭证编号
            ,bus_vouchnum -- 凭证编号
            ,bookset_id -- 账套代码
            ,trade_id -- 交易编号
            ,book_date -- 日期
            ,com_table_id -- 合并场景代码
            ,vouch_remark -- 凭证说明
            ,offset_flag -- 冲正标识
            ,vouch_year -- 年份
            ,vouch_month -- 月份
            ,num -- 编号位数
            ,book_type -- 凭证类型
            ,handle_user -- 经办人
            ,approve_user -- 复核人
            ,approve_status -- 审批状态
            ,send_user -- 发送人
            ,send_status -- 发送状态
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,vouch_type -- 账务类型
            ,customer_name -- 客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.vouch_num, o.vouch_num) as vouch_num -- 凭证编号
    ,nvl(n.bus_vouchnum, o.bus_vouchnum) as bus_vouchnum -- 凭证编号
    ,nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.trade_id, o.trade_id) as trade_id -- 交易编号
    ,nvl(n.book_date, o.book_date) as book_date -- 日期
    ,nvl(n.com_table_id, o.com_table_id) as com_table_id -- 合并场景代码
    ,nvl(n.vouch_remark, o.vouch_remark) as vouch_remark -- 凭证说明
    ,nvl(n.offset_flag, o.offset_flag) as offset_flag -- 冲正标识
    ,nvl(n.vouch_year, o.vouch_year) as vouch_year -- 年份
    ,nvl(n.vouch_month, o.vouch_month) as vouch_month -- 月份
    ,nvl(n.num, o.num) as num -- 编号位数
    ,nvl(n.book_type, o.book_type) as book_type -- 凭证类型
    ,nvl(n.handle_user, o.handle_user) as handle_user -- 经办人
    ,nvl(n.approve_user, o.approve_user) as approve_user -- 复核人
    ,nvl(n.approve_status, o.approve_status) as approve_status -- 审批状态
    ,nvl(n.send_user, o.send_user) as send_user -- 发送人
    ,nvl(n.send_status, o.send_status) as send_status -- 发送状态
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.vouch_type, o.vouch_type) as vouch_type -- 账务类型
    ,nvl(n.customer_name, o.customer_name) as customer_name -- 客户名称
    ,case when
            n.vouch_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.vouch_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.vouch_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ban_account_main_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ban_account_main where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.vouch_num = n.vouch_num
where (
        o.vouch_num is null
    )
    or (
        n.vouch_num is null
    )
    or (
        o.bus_vouchnum <> n.bus_vouchnum
        or o.bookset_id <> n.bookset_id
        or o.trade_id <> n.trade_id
        or o.book_date <> n.book_date
        or o.com_table_id <> n.com_table_id
        or o.vouch_remark <> n.vouch_remark
        or o.offset_flag <> n.offset_flag
        or o.vouch_year <> n.vouch_year
        or o.vouch_month <> n.vouch_month
        or o.num <> n.num
        or o.book_type <> n.book_type
        or o.handle_user <> n.handle_user
        or o.approve_user <> n.approve_user
        or o.approve_status <> n.approve_status
        or o.send_user <> n.send_user
        or o.send_status <> n.send_status
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.vouch_type <> n.vouch_type
        or o.customer_name <> n.customer_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_account_main_cl(
            vouch_num -- 凭证编号
            ,bus_vouchnum -- 凭证编号
            ,bookset_id -- 账套代码
            ,trade_id -- 交易编号
            ,book_date -- 日期
            ,com_table_id -- 合并场景代码
            ,vouch_remark -- 凭证说明
            ,offset_flag -- 冲正标识
            ,vouch_year -- 年份
            ,vouch_month -- 月份
            ,num -- 编号位数
            ,book_type -- 凭证类型
            ,handle_user -- 经办人
            ,approve_user -- 复核人
            ,approve_status -- 审批状态
            ,send_user -- 发送人
            ,send_status -- 发送状态
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,vouch_type -- 账务类型
            ,customer_name -- 客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_account_main_op(
            vouch_num -- 凭证编号
            ,bus_vouchnum -- 凭证编号
            ,bookset_id -- 账套代码
            ,trade_id -- 交易编号
            ,book_date -- 日期
            ,com_table_id -- 合并场景代码
            ,vouch_remark -- 凭证说明
            ,offset_flag -- 冲正标识
            ,vouch_year -- 年份
            ,vouch_month -- 月份
            ,num -- 编号位数
            ,book_type -- 凭证类型
            ,handle_user -- 经办人
            ,approve_user -- 复核人
            ,approve_status -- 审批状态
            ,send_user -- 发送人
            ,send_status -- 发送状态
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,vouch_type -- 账务类型
            ,customer_name -- 客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.vouch_num -- 凭证编号
    ,o.bus_vouchnum -- 凭证编号
    ,o.bookset_id -- 账套代码
    ,o.trade_id -- 交易编号
    ,o.book_date -- 日期
    ,o.com_table_id -- 合并场景代码
    ,o.vouch_remark -- 凭证说明
    ,o.offset_flag -- 冲正标识
    ,o.vouch_year -- 年份
    ,o.vouch_month -- 月份
    ,o.num -- 编号位数
    ,o.book_type -- 凭证类型
    ,o.handle_user -- 经办人
    ,o.approve_user -- 复核人
    ,o.approve_status -- 审批状态
    ,o.send_user -- 发送人
    ,o.send_status -- 发送状态
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.vouch_type -- 账务类型
    ,o.customer_name -- 客户名称
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
from ${iol_schema}.fams_ban_account_main_bk o
    left join ${iol_schema}.fams_ban_account_main_op n
        on
            o.vouch_num = n.vouch_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ban_account_main_cl d
        on
            o.vouch_num = d.vouch_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_ban_account_main;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_ban_account_main') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_ban_account_main drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_ban_account_main add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_ban_account_main exchange partition p_${batch_date} with table ${iol_schema}.fams_ban_account_main_cl;
alter table ${iol_schema}.fams_ban_account_main exchange partition p_20991231 with table ${iol_schema}.fams_ban_account_main_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ban_account_main to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_account_main_op purge;
drop table ${iol_schema}.fams_ban_account_main_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ban_account_main_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ban_account_main',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
