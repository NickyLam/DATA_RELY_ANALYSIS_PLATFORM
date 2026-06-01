/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_txn_num_tab
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
create table ${iol_schema}.mrms_tbl_txn_num_tab_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_txn_num_tab;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_txn_num_tab_op purge;
drop table ${iol_schema}.mrms_tbl_txn_num_tab_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_txn_num_tab_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_txn_num_tab where 0=1;

create table ${iol_schema}.mrms_tbl_txn_num_tab_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_txn_num_tab where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_txn_num_tab_cl(
            txn_num -- 
            ,txn_name -- 
            ,fin_txn_flg -- 
            ,data_src_cd -- 
            ,del_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_txn_num_tab_op(
            txn_num -- 
            ,txn_name -- 
            ,fin_txn_flg -- 
            ,data_src_cd -- 
            ,del_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.txn_num, o.txn_num) as txn_num -- 
    ,nvl(n.txn_name, o.txn_name) as txn_name -- 
    ,nvl(n.fin_txn_flg, o.fin_txn_flg) as fin_txn_flg -- 
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 
    ,nvl(n.del_flg, o.del_flg) as del_flg -- 
    ,case when
            n.txn_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.txn_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.txn_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_txn_num_tab_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_txn_num_tab where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.txn_num = n.txn_num
where (
        o.txn_num is null
    )
    or (
        n.txn_num is null
    )
    or (
        o.txn_name <> n.txn_name
        or o.fin_txn_flg <> n.fin_txn_flg
        or o.data_src_cd <> n.data_src_cd
        or o.del_flg <> n.del_flg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_txn_num_tab_cl(
            txn_num -- 
            ,txn_name -- 
            ,fin_txn_flg -- 
            ,data_src_cd -- 
            ,del_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_txn_num_tab_op(
            txn_num -- 
            ,txn_name -- 
            ,fin_txn_flg -- 
            ,data_src_cd -- 
            ,del_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.txn_num -- 
    ,o.txn_name -- 
    ,o.fin_txn_flg -- 
    ,o.data_src_cd -- 
    ,o.del_flg -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_txn_num_tab_bk o
    left join ${iol_schema}.mrms_tbl_txn_num_tab_op n
        on
            o.txn_num = n.txn_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_txn_num_tab_cl d
        on
            o.txn_num = d.txn_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mrms_tbl_txn_num_tab;

-- 4.2 exchange partition
alter table ${iol_schema}.mrms_tbl_txn_num_tab exchange partition p_19000101 with table ${iol_schema}.mrms_tbl_txn_num_tab_cl;
alter table ${iol_schema}.mrms_tbl_txn_num_tab exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_txn_num_tab_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_txn_num_tab to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_txn_num_tab_op purge;
drop table ${iol_schema}.mrms_tbl_txn_num_tab_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_txn_num_tab_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_txn_num_tab',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
