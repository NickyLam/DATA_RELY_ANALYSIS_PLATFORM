/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_deal_settle_path
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
create table ${iol_schema}.ctms_fbs_v_deal_settle_path_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_deal_settle_path;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_deal_settle_path_op purge;
drop table ${iol_schema}.ctms_fbs_v_deal_settle_path_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_deal_settle_path_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_deal_settle_path where 0=1;

create table ${iol_schema}.ctms_fbs_v_deal_settle_path_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_deal_settle_path where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_deal_settle_path_cl(
            deal_sqno -- 
            ,self_pay -- 
            ,self_receive -- 
            ,cp_receive -- 
            ,cp_pay -- 
            ,system_name -- 
            ,is_from_pack -- 
            ,deal_type -- 
            ,memo -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_deal_settle_path_op(
            deal_sqno -- 
            ,self_pay -- 
            ,self_receive -- 
            ,cp_receive -- 
            ,cp_pay -- 
            ,system_name -- 
            ,is_from_pack -- 
            ,deal_type -- 
            ,memo -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_sqno, o.deal_sqno) as deal_sqno -- 
    ,nvl(n.self_pay, o.self_pay) as self_pay -- 
    ,nvl(n.self_receive, o.self_receive) as self_receive -- 
    ,nvl(n.cp_receive, o.cp_receive) as cp_receive -- 
    ,nvl(n.cp_pay, o.cp_pay) as cp_pay -- 
    ,nvl(n.system_name, o.system_name) as system_name -- 
    ,nvl(n.is_from_pack, o.is_from_pack) as is_from_pack -- 
    ,nvl(n.deal_type, o.deal_type) as deal_type -- 
    ,nvl(n.memo, o.memo) as memo -- 
    ,case when
            n.deal_sqno is null
            and n.deal_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_sqno is null
            and n.deal_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_sqno is null
            and n.deal_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_deal_settle_path_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_deal_settle_path where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_sqno = n.deal_sqno
            and o.deal_type = n.deal_type
where (
        o.deal_sqno is null
        and o.deal_type is null
    )
    or (
        n.deal_sqno is null
        and n.deal_type is null
    )
    or (
        o.self_pay <> n.self_pay
        or o.self_receive <> n.self_receive
        or o.cp_receive <> n.cp_receive
        or o.cp_pay <> n.cp_pay
        or o.system_name <> n.system_name
        or o.is_from_pack <> n.is_from_pack
        or o.memo <> n.memo
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_deal_settle_path_cl(
            deal_sqno -- 
            ,self_pay -- 
            ,self_receive -- 
            ,cp_receive -- 
            ,cp_pay -- 
            ,system_name -- 
            ,is_from_pack -- 
            ,deal_type -- 
            ,memo -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_deal_settle_path_op(
            deal_sqno -- 
            ,self_pay -- 
            ,self_receive -- 
            ,cp_receive -- 
            ,cp_pay -- 
            ,system_name -- 
            ,is_from_pack -- 
            ,deal_type -- 
            ,memo -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_sqno -- 
    ,o.self_pay -- 
    ,o.self_receive -- 
    ,o.cp_receive -- 
    ,o.cp_pay -- 
    ,o.system_name -- 
    ,o.is_from_pack -- 
    ,o.deal_type -- 
    ,o.memo -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_fbs_v_deal_settle_path_bk o
    left join ${iol_schema}.ctms_fbs_v_deal_settle_path_op n
        on
            o.deal_sqno = n.deal_sqno
            and o.deal_type = n.deal_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_deal_settle_path_cl d
        on
            o.deal_sqno = d.deal_sqno
            and o.deal_type = d.deal_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_fbs_v_deal_settle_path;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_fbs_v_deal_settle_path exchange partition p_19000101 with table ${iol_schema}.ctms_fbs_v_deal_settle_path_cl;
alter table ${iol_schema}.ctms_fbs_v_deal_settle_path exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_deal_settle_path_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_deal_settle_path to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_deal_settle_path_op purge;
drop table ${iol_schema}.ctms_fbs_v_deal_settle_path_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_deal_settle_path_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_deal_settle_path',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
