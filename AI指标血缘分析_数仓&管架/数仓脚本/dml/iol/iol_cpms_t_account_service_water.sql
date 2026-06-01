/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cpms_t_account_service_water
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
create table ${iol_schema}.cpms_t_account_service_water_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.cpms_t_account_service_water;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cpms_t_account_service_water_op purge;
drop table ${iol_schema}.cpms_t_account_service_water_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_account_service_water_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cpms_t_account_service_water where 0=1;

create table ${iol_schema}.cpms_t_account_service_water_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cpms_t_account_service_water where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cpms_t_account_service_water_cl(
            create_date -- 日期
            ,pty_id -- 客户号
            ,pty_name -- 客户名称
            ,equi_id -- 权益id
            ,equi_name -- 权益名称
            ,rema_usab_equi_cnt -- 剩余可用权益次数
            ,equi_has_usage_cnt -- 已使用权益次数
            ,final_oper_pers -- 最后操作人
            ,val_st_dt -- 有效开始日期
            ,val_end_dt -- 有效结束日期
            ,source_name -- 操作来源
            ,water_date -- 操作日期
            ,transaction_num -- 操作数值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cpms_t_account_service_water_op(
            create_date -- 日期
            ,pty_id -- 客户号
            ,pty_name -- 客户名称
            ,equi_id -- 权益id
            ,equi_name -- 权益名称
            ,rema_usab_equi_cnt -- 剩余可用权益次数
            ,equi_has_usage_cnt -- 已使用权益次数
            ,final_oper_pers -- 最后操作人
            ,val_st_dt -- 有效开始日期
            ,val_end_dt -- 有效结束日期
            ,source_name -- 操作来源
            ,water_date -- 操作日期
            ,transaction_num -- 操作数值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.create_date, o.create_date) as create_date -- 日期
    ,nvl(n.pty_id, o.pty_id) as pty_id -- 客户号
    ,nvl(n.pty_name, o.pty_name) as pty_name -- 客户名称
    ,nvl(n.equi_id, o.equi_id) as equi_id -- 权益id
    ,nvl(n.equi_name, o.equi_name) as equi_name -- 权益名称
    ,nvl(n.rema_usab_equi_cnt, o.rema_usab_equi_cnt) as rema_usab_equi_cnt -- 剩余可用权益次数
    ,nvl(n.equi_has_usage_cnt, o.equi_has_usage_cnt) as equi_has_usage_cnt -- 已使用权益次数
    ,nvl(n.final_oper_pers, o.final_oper_pers) as final_oper_pers -- 最后操作人
    ,nvl(n.val_st_dt, o.val_st_dt) as val_st_dt -- 有效开始日期
    ,nvl(n.val_end_dt, o.val_end_dt) as val_end_dt -- 有效结束日期
    ,nvl(n.source_name, o.source_name) as source_name -- 操作来源
    ,nvl(n.water_date, o.water_date) as water_date -- 操作日期
    ,nvl(n.transaction_num, o.transaction_num) as transaction_num -- 操作数值
    ,case when
            n.pty_id is null
            and n.equi_id is null
            and n.rema_usab_equi_cnt is null
            and n.transaction_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pty_id is null
            and n.equi_id is null
            and n.rema_usab_equi_cnt is null
            and n.transaction_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pty_id is null
            and n.equi_id is null
            and n.rema_usab_equi_cnt is null
            and n.transaction_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.cpms_t_account_service_water_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.cpms_t_account_service_water where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pty_id = n.pty_id
            and o.equi_id = n.equi_id
            and o.rema_usab_equi_cnt = n.rema_usab_equi_cnt
            and o.transaction_num = n.transaction_num
where (
        o.pty_id is null
        and o.equi_id is null
        and o.rema_usab_equi_cnt is null
        and o.transaction_num is null
    )
    or (
        n.pty_id is null
        and n.equi_id is null
        and n.rema_usab_equi_cnt is null
        and n.transaction_num is null
    )
    or (
        o.create_date <> n.create_date
        or o.pty_name <> n.pty_name
        or o.equi_name <> n.equi_name
        or o.equi_has_usage_cnt <> n.equi_has_usage_cnt
        or o.final_oper_pers <> n.final_oper_pers
        or o.val_st_dt <> n.val_st_dt
        or o.val_end_dt <> n.val_end_dt
        or o.source_name <> n.source_name
        or o.water_date <> n.water_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cpms_t_account_service_water_cl(
            create_date -- 日期
            ,pty_id -- 客户号
            ,pty_name -- 客户名称
            ,equi_id -- 权益id
            ,equi_name -- 权益名称
            ,rema_usab_equi_cnt -- 剩余可用权益次数
            ,equi_has_usage_cnt -- 已使用权益次数
            ,final_oper_pers -- 最后操作人
            ,val_st_dt -- 有效开始日期
            ,val_end_dt -- 有效结束日期
            ,source_name -- 操作来源
            ,water_date -- 操作日期
            ,transaction_num -- 操作数值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cpms_t_account_service_water_op(
            create_date -- 日期
            ,pty_id -- 客户号
            ,pty_name -- 客户名称
            ,equi_id -- 权益id
            ,equi_name -- 权益名称
            ,rema_usab_equi_cnt -- 剩余可用权益次数
            ,equi_has_usage_cnt -- 已使用权益次数
            ,final_oper_pers -- 最后操作人
            ,val_st_dt -- 有效开始日期
            ,val_end_dt -- 有效结束日期
            ,source_name -- 操作来源
            ,water_date -- 操作日期
            ,transaction_num -- 操作数值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.create_date -- 日期
    ,o.pty_id -- 客户号
    ,o.pty_name -- 客户名称
    ,o.equi_id -- 权益id
    ,o.equi_name -- 权益名称
    ,o.rema_usab_equi_cnt -- 剩余可用权益次数
    ,o.equi_has_usage_cnt -- 已使用权益次数
    ,o.final_oper_pers -- 最后操作人
    ,o.val_st_dt -- 有效开始日期
    ,o.val_end_dt -- 有效结束日期
    ,o.source_name -- 操作来源
    ,o.water_date -- 操作日期
    ,o.transaction_num -- 操作数值
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.cpms_t_account_service_water_bk o
    left join ${iol_schema}.cpms_t_account_service_water_op n
        on
            o.pty_id = n.pty_id
            and o.equi_id = n.equi_id
            and o.rema_usab_equi_cnt = n.rema_usab_equi_cnt
            and o.transaction_num = n.transaction_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.cpms_t_account_service_water_cl d
        on
            o.pty_id = d.pty_id
            and o.equi_id = d.equi_id
            and o.rema_usab_equi_cnt = d.rema_usab_equi_cnt
            and o.transaction_num = d.transaction_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.cpms_t_account_service_water;

-- 4.2 exchange partition
alter table ${iol_schema}.cpms_t_account_service_water exchange partition p_19000101 with table ${iol_schema}.cpms_t_account_service_water_cl;
alter table ${iol_schema}.cpms_t_account_service_water exchange partition p_20991231 with table ${iol_schema}.cpms_t_account_service_water_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cpms_t_account_service_water to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cpms_t_account_service_water_op purge;
drop table ${iol_schema}.cpms_t_account_service_water_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.cpms_t_account_service_water_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cpms_t_account_service_water',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
