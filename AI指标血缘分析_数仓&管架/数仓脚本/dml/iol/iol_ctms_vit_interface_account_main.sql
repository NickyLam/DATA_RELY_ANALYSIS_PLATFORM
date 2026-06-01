/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_vit_interface_account_main
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
whenever sqlerror continue none ;
create table ${iol_schema}.ctms_vit_interface_account_main_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_vit_interface_account_main;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_vit_interface_account_main_op purge;
drop table ${iol_schema}.ctms_vit_interface_account_main_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vit_interface_account_main_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ctms_vit_interface_account_main where 0=1;

create table ${iol_schema}.ctms_vit_interface_account_main_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ctms_vit_interface_account_main where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ctms_vit_interface_account_main_op(
        src_cd -- 
        ,settledate -- 
        ,settletime -- 
        ,bus_depart_id -- 
        ,ope_depart_id -- 
        ,handle_teller_id -- 
        ,check_teller_id -- 
        ,txn_num -- 
        ,txn_desc -- 
        ,alterbalance_id -- 
        ,core_seq -- 
        ,amount -- 
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.src_cd -- 
    ,n.settledate -- 
    ,n.settletime -- 
    ,n.bus_depart_id -- 
    ,n.ope_depart_id -- 
    ,n.handle_teller_id -- 
    ,n.check_teller_id -- 
    ,n.txn_num -- 
    ,n.txn_desc -- 
    ,n.alterbalance_id -- 
    ,n.core_seq -- 
    ,n.amount -- 
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_vit_interface_account_main_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.ctms_vit_interface_account_main where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.alterbalance_id = n.alterbalance_id
where (
        o.alterbalance_id is null
    )
    or (
        o.src_cd <> n.src_cd
        or o.settledate <> n.settledate
        or o.settletime <> n.settletime
        or o.bus_depart_id <> n.bus_depart_id
        or o.ope_depart_id <> n.ope_depart_id
        or o.handle_teller_id <> n.handle_teller_id
        or o.check_teller_id <> n.check_teller_id
        or o.txn_num <> n.txn_num
        or o.txn_desc <> n.txn_desc
        or o.core_seq <> n.core_seq
        or o.amount <> n.amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_vit_interface_account_main_cl(
            src_cd -- 
        ,settledate -- 
        ,settletime -- 
        ,bus_depart_id -- 
        ,ope_depart_id -- 
        ,handle_teller_id -- 
        ,check_teller_id -- 
        ,txn_num -- 
        ,txn_desc -- 
        ,alterbalance_id -- 
        ,core_seq -- 
        ,amount -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_vit_interface_account_main_op(
            src_cd -- 
        ,settledate -- 
        ,settletime -- 
        ,bus_depart_id -- 
        ,ope_depart_id -- 
        ,handle_teller_id -- 
        ,check_teller_id -- 
        ,txn_num -- 
        ,txn_desc -- 
        ,alterbalance_id -- 
        ,core_seq -- 
        ,amount -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.src_cd -- 
    ,o.settledate -- 
    ,o.settletime -- 
    ,o.bus_depart_id -- 
    ,o.ope_depart_id -- 
    ,o.handle_teller_id -- 
    ,o.check_teller_id -- 
    ,o.txn_num -- 
    ,o.txn_desc -- 
    ,o.alterbalance_id -- 
    ,o.core_seq -- 
    ,o.amount -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_vit_interface_account_main_bk o
    left join ${iol_schema}.ctms_vit_interface_account_main_op n
        on
            o.alterbalance_id = n.alterbalance_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_vit_interface_account_main;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_vit_interface_account_main exchange partition p_19000101 with table ${iol_schema}.ctms_vit_interface_account_main_cl;
alter table ${iol_schema}.ctms_vit_interface_account_main exchange partition p_20991231 with table ${iol_schema}.ctms_vit_interface_account_main_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_vit_interface_account_main to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_vit_interface_account_main_op purge;
drop table ${iol_schema}.ctms_vit_interface_account_main_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_vit_interface_account_main_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_vit_interface_account_main',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
