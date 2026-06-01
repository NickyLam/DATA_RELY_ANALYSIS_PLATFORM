/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_limit_ctrl
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
create table ${iol_schema}.ncbs_tb_limit_ctrl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_limit_ctrl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_limit_ctrl_op purge;
drop table ${iol_schema}.ncbs_tb_limit_ctrl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_limit_ctrl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_limit_ctrl where 0=1;

create table ${iol_schema}.ncbs_tb_limit_ctrl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_limit_ctrl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_limit_ctrl_cl(
            remark -- 备注
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,ctrl_desc -- 控制描述
            ,ctrl_id -- 控制编号
            ,ctrl_type -- 尾箱限额类型
            ,eod_deal_flow -- 日终处理方式
            ,limit_status -- 限额状态
            ,tran_timestamp -- 交易时间戳
            ,online_check -- 是否日间限额检查标志
            ,online_deal_flow -- 日间处理方式
            ,eod_check -- 是否日终限额检查标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_limit_ctrl_op(
            remark -- 备注
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,ctrl_desc -- 控制描述
            ,ctrl_id -- 控制编号
            ,ctrl_type -- 尾箱限额类型
            ,eod_deal_flow -- 日终处理方式
            ,limit_status -- 限额状态
            ,tran_timestamp -- 交易时间戳
            ,online_check -- 是否日间限额检查标志
            ,online_deal_flow -- 日间处理方式
            ,eod_check -- 是否日终限额检查标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.ctrl_desc, o.ctrl_desc) as ctrl_desc -- 控制描述
    ,nvl(n.ctrl_id, o.ctrl_id) as ctrl_id -- 控制编号
    ,nvl(n.ctrl_type, o.ctrl_type) as ctrl_type -- 尾箱限额类型
    ,nvl(n.eod_deal_flow, o.eod_deal_flow) as eod_deal_flow -- 日终处理方式
    ,nvl(n.limit_status, o.limit_status) as limit_status -- 限额状态
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.online_check, o.online_check) as online_check -- 是否日间限额检查标志
    ,nvl(n.online_deal_flow, o.online_deal_flow) as online_deal_flow -- 日间处理方式
    ,nvl(n.eod_check, o.eod_check) as eod_check -- 是否日终限额检查标志
    ,case when
            n.ctrl_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ctrl_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ctrl_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_limit_ctrl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_limit_ctrl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ctrl_id = n.ctrl_id
where (
        o.ctrl_id is null
    )
    or (
        n.ctrl_id is null
    )
    or (
        o.remark <> n.remark
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.ctrl_desc <> n.ctrl_desc
        or o.ctrl_type <> n.ctrl_type
        or o.eod_deal_flow <> n.eod_deal_flow
        or o.limit_status <> n.limit_status
        or o.tran_timestamp <> n.tran_timestamp
        or o.online_check <> n.online_check
        or o.online_deal_flow <> n.online_deal_flow
        or o.eod_check <> n.eod_check
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_limit_ctrl_cl(
            remark -- 备注
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,ctrl_desc -- 控制描述
            ,ctrl_id -- 控制编号
            ,ctrl_type -- 尾箱限额类型
            ,eod_deal_flow -- 日终处理方式
            ,limit_status -- 限额状态
            ,tran_timestamp -- 交易时间戳
            ,online_check -- 是否日间限额检查标志
            ,online_deal_flow -- 日间处理方式
            ,eod_check -- 是否日终限额检查标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_limit_ctrl_op(
            remark -- 备注
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,ctrl_desc -- 控制描述
            ,ctrl_id -- 控制编号
            ,ctrl_type -- 尾箱限额类型
            ,eod_deal_flow -- 日终处理方式
            ,limit_status -- 限额状态
            ,tran_timestamp -- 交易时间戳
            ,online_check -- 是否日间限额检查标志
            ,online_deal_flow -- 日间处理方式
            ,eod_check -- 是否日终限额检查标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.remark -- 备注
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.ctrl_desc -- 控制描述
    ,o.ctrl_id -- 控制编号
    ,o.ctrl_type -- 尾箱限额类型
    ,o.eod_deal_flow -- 日终处理方式
    ,o.limit_status -- 限额状态
    ,o.tran_timestamp -- 交易时间戳
    ,o.online_check -- 是否日间限额检查标志
    ,o.online_deal_flow -- 日间处理方式
    ,o.eod_check -- 是否日终限额检查标志
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
from ${iol_schema}.ncbs_tb_limit_ctrl_bk o
    left join ${iol_schema}.ncbs_tb_limit_ctrl_op n
        on
            o.ctrl_id = n.ctrl_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_limit_ctrl_cl d
        on
            o.ctrl_id = d.ctrl_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_limit_ctrl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_limit_ctrl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_limit_ctrl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_limit_ctrl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_limit_ctrl exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_limit_ctrl_cl;
alter table ${iol_schema}.ncbs_tb_limit_ctrl exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_limit_ctrl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_limit_ctrl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_limit_ctrl_op purge;
drop table ${iol_schema}.ncbs_tb_limit_ctrl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_limit_ctrl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_limit_ctrl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
