/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_property_pool_details
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
create table ${iol_schema}.bdps_property_pool_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_property_pool_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_property_pool_details_op purge;
drop table ${iol_schema}.bdps_property_pool_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_property_pool_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_property_pool_details where 0=1;

create table ${iol_schema}.bdps_property_pool_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_property_pool_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_property_pool_details_cl(
            id -- 
            ,contract_id -- 资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
            ,cancel_contract_id -- 解除资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,dtl_status -- 资产池明细状态 0-已办理 1-入池申请中 2-已入资产池 5-解除资产池办理中 6-已解除资产池 8-已冲正
            ,misc -- 信息域
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,draft_amount_rate -- 质押率
            ,pledge_serial_no -- 理财系统质押流水号
            ,pledge_flag -- 质押通知成功标识 0-质押通知失败 1-质押通知成功 2-解押通知失败 3-解押通知成功
            ,account_flag -- 记账标识0-记帐失败 1-记帐成功  2-解记帐失败 3-解记帐成功
            ,serino -- 序列号
            ,res_seq_no -- 限制编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_property_pool_details_op(
            id -- 
            ,contract_id -- 资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
            ,cancel_contract_id -- 解除资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,dtl_status -- 资产池明细状态 0-已办理 1-入池申请中 2-已入资产池 5-解除资产池办理中 6-已解除资产池 8-已冲正
            ,misc -- 信息域
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,draft_amount_rate -- 质押率
            ,pledge_serial_no -- 理财系统质押流水号
            ,pledge_flag -- 质押通知成功标识 0-质押通知失败 1-质押通知成功 2-解押通知失败 3-解押通知成功
            ,account_flag -- 记账标识0-记帐失败 1-记帐成功  2-解记帐失败 3-解记帐成功
            ,serino -- 序列号
            ,res_seq_no -- 限制编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
    ,nvl(n.cancel_contract_id, o.cancel_contract_id) as cancel_contract_id -- 解除资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
    ,nvl(n.property_id, o.property_id) as property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
    ,nvl(n.dtl_status, o.dtl_status) as dtl_status -- 资产池明细状态 0-已办理 1-入池申请中 2-已入资产池 5-解除资产池办理中 6-已解除资产池 8-已冲正
    ,nvl(n.misc, o.misc) as misc -- 信息域
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后修改操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.draft_amount_rate, o.draft_amount_rate) as draft_amount_rate -- 质押率
    ,nvl(n.pledge_serial_no, o.pledge_serial_no) as pledge_serial_no -- 理财系统质押流水号
    ,nvl(n.pledge_flag, o.pledge_flag) as pledge_flag -- 质押通知成功标识 0-质押通知失败 1-质押通知成功 2-解押通知失败 3-解押通知成功
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 记账标识0-记帐失败 1-记帐成功  2-解记帐失败 3-解记帐成功
    ,nvl(n.serino, o.serino) as serino -- 序列号
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
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
from (select * from ${iol_schema}.bdps_property_pool_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_property_pool_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_id <> n.contract_id
        or o.cancel_contract_id <> n.cancel_contract_id
        or o.property_id <> n.property_id
        or o.dtl_status <> n.dtl_status
        or o.misc <> n.misc
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.draft_amount_rate <> n.draft_amount_rate
        or o.pledge_serial_no <> n.pledge_serial_no
        or o.pledge_flag <> n.pledge_flag
        or o.account_flag <> n.account_flag
        or o.serino <> n.serino
        or o.res_seq_no <> n.res_seq_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_property_pool_details_cl(
            id -- 
            ,contract_id -- 资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
            ,cancel_contract_id -- 解除资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,dtl_status -- 资产池明细状态 0-已办理 1-入池申请中 2-已入资产池 5-解除资产池办理中 6-已解除资产池 8-已冲正
            ,misc -- 信息域
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,draft_amount_rate -- 质押率
            ,pledge_serial_no -- 理财系统质押流水号
            ,pledge_flag -- 质押通知成功标识 0-质押通知失败 1-质押通知成功 2-解押通知失败 3-解押通知成功
            ,account_flag -- 记账标识0-记帐失败 1-记帐成功  2-解记帐失败 3-解记帐成功
            ,serino -- 序列号
            ,res_seq_no -- 限制编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_property_pool_details_op(
            id -- 
            ,contract_id -- 资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
            ,cancel_contract_id -- 解除资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,dtl_status -- 资产池明细状态 0-已办理 1-入池申请中 2-已入资产池 5-解除资产池办理中 6-已解除资产池 8-已冲正
            ,misc -- 信息域
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,draft_amount_rate -- 质押率
            ,pledge_serial_no -- 理财系统质押流水号
            ,pledge_flag -- 质押通知成功标识 0-质押通知失败 1-质押通知成功 2-解押通知失败 3-解押通知成功
            ,account_flag -- 记账标识0-记帐失败 1-记帐成功  2-解记帐失败 3-解记帐成功
            ,serino -- 序列号
            ,res_seq_no -- 限制编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_id -- 资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
    ,o.cancel_contract_id -- 解除资产池批次ID 关联“PROPERTY_POOL_CONTRACT”的id
    ,o.property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
    ,o.dtl_status -- 资产池明细状态 0-已办理 1-入池申请中 2-已入资产池 5-解除资产池办理中 6-已解除资产池 8-已冲正
    ,o.misc -- 信息域
    ,o.last_upd_oper_id -- 最后修改操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.draft_amount_rate -- 质押率
    ,o.pledge_serial_no -- 理财系统质押流水号
    ,o.pledge_flag -- 质押通知成功标识 0-质押通知失败 1-质押通知成功 2-解押通知失败 3-解押通知成功
    ,o.account_flag -- 记账标识0-记帐失败 1-记帐成功  2-解记帐失败 3-解记帐成功
    ,o.serino -- 序列号
    ,o.res_seq_no -- 限制编号
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
from ${iol_schema}.bdps_property_pool_details_bk o
    left join ${iol_schema}.bdps_property_pool_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_property_pool_details_cl d
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
--truncate table ${iol_schema}.bdps_property_pool_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_property_pool_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_property_pool_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_property_pool_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_property_pool_details exchange partition p_${batch_date} with table ${iol_schema}.bdps_property_pool_details_cl;
alter table ${iol_schema}.bdps_property_pool_details exchange partition p_20991231 with table ${iol_schema}.bdps_property_pool_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_property_pool_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_property_pool_details_op purge;
drop table ${iol_schema}.bdps_property_pool_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_property_pool_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_property_pool_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
