/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_log_busfill_info
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
create table ${iol_schema}.nibs_ib_log_busfill_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ib_log_busfill_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_log_busfill_info_op purge;
drop table ${iol_schema}.nibs_ib_log_busfill_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_busfill_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_busfill_info where 0=1;

create table ${iol_schema}.nibs_ib_log_busfill_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_busfill_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_log_busfill_info_cl(
            tx_seq_num -- 业务流水号(交易订单号)-原交易
            ,oritrandate -- 原交易日期
            ,oritrantime -- 原交易时间
            ,core_tran_flow_num -- 全局流水号
            ,tx_org_num -- 操作机构编号
            ,tx_teller_num -- 操作柜员编号
            ,maindate -- 操作日期-yyyyMMdd
            ,maintime -- 操作时间-yyyyMMdd hhmmss
            ,note1 -- 备用1
            ,note2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_log_busfill_info_op(
            tx_seq_num -- 业务流水号(交易订单号)-原交易
            ,oritrandate -- 原交易日期
            ,oritrantime -- 原交易时间
            ,core_tran_flow_num -- 全局流水号
            ,tx_org_num -- 操作机构编号
            ,tx_teller_num -- 操作柜员编号
            ,maindate -- 操作日期-yyyyMMdd
            ,maintime -- 操作时间-yyyyMMdd hhmmss
            ,note1 -- 备用1
            ,note2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tx_seq_num, o.tx_seq_num) as tx_seq_num -- 业务流水号(交易订单号)-原交易
    ,nvl(n.oritrandate, o.oritrandate) as oritrandate -- 原交易日期
    ,nvl(n.oritrantime, o.oritrantime) as oritrantime -- 原交易时间
    ,nvl(n.core_tran_flow_num, o.core_tran_flow_num) as core_tran_flow_num -- 全局流水号
    ,nvl(n.tx_org_num, o.tx_org_num) as tx_org_num -- 操作机构编号
    ,nvl(n.tx_teller_num, o.tx_teller_num) as tx_teller_num -- 操作柜员编号
    ,nvl(n.maindate, o.maindate) as maindate -- 操作日期-yyyyMMdd
    ,nvl(n.maintime, o.maintime) as maintime -- 操作时间-yyyyMMdd hhmmss
    ,nvl(n.note1, o.note1) as note1 -- 备用1
    ,nvl(n.note2, o.note2) as note2 -- 备用2
    ,case when
            n.tx_seq_num is null
            and n.maintime is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tx_seq_num is null
            and n.maintime is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tx_seq_num is null
            and n.maintime is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ib_log_busfill_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ib_log_busfill_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tx_seq_num = n.tx_seq_num
            and o.maintime = n.maintime
where (
        o.tx_seq_num is null
        and o.maintime is null
    )
    or (
        n.tx_seq_num is null
        and n.maintime is null
    )
    or (
        o.oritrandate <> n.oritrandate
        or o.oritrantime <> n.oritrantime
        or o.core_tran_flow_num <> n.core_tran_flow_num
        or o.tx_org_num <> n.tx_org_num
        or o.tx_teller_num <> n.tx_teller_num
        or o.maindate <> n.maindate
        or o.note1 <> n.note1
        or o.note2 <> n.note2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_log_busfill_info_cl(
            tx_seq_num -- 业务流水号(交易订单号)-原交易
            ,oritrandate -- 原交易日期
            ,oritrantime -- 原交易时间
            ,core_tran_flow_num -- 全局流水号
            ,tx_org_num -- 操作机构编号
            ,tx_teller_num -- 操作柜员编号
            ,maindate -- 操作日期-yyyyMMdd
            ,maintime -- 操作时间-yyyyMMdd hhmmss
            ,note1 -- 备用1
            ,note2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_log_busfill_info_op(
            tx_seq_num -- 业务流水号(交易订单号)-原交易
            ,oritrandate -- 原交易日期
            ,oritrantime -- 原交易时间
            ,core_tran_flow_num -- 全局流水号
            ,tx_org_num -- 操作机构编号
            ,tx_teller_num -- 操作柜员编号
            ,maindate -- 操作日期-yyyyMMdd
            ,maintime -- 操作时间-yyyyMMdd hhmmss
            ,note1 -- 备用1
            ,note2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tx_seq_num -- 业务流水号(交易订单号)-原交易
    ,o.oritrandate -- 原交易日期
    ,o.oritrantime -- 原交易时间
    ,o.core_tran_flow_num -- 全局流水号
    ,o.tx_org_num -- 操作机构编号
    ,o.tx_teller_num -- 操作柜员编号
    ,o.maindate -- 操作日期-yyyyMMdd
    ,o.maintime -- 操作时间-yyyyMMdd hhmmss
    ,o.note1 -- 备用1
    ,o.note2 -- 备用2
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
from ${iol_schema}.nibs_ib_log_busfill_info_bk o
    left join ${iol_schema}.nibs_ib_log_busfill_info_op n
        on
            o.tx_seq_num = n.tx_seq_num
            and o.maintime = n.maintime
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ib_log_busfill_info_cl d
        on
            o.tx_seq_num = d.tx_seq_num
            and o.maintime = d.maintime
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ib_log_busfill_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ib_log_busfill_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ib_log_busfill_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ib_log_busfill_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ib_log_busfill_info exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_log_busfill_info_cl;
alter table ${iol_schema}.nibs_ib_log_busfill_info exchange partition p_20991231 with table ${iol_schema}.nibs_ib_log_busfill_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_log_busfill_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_log_busfill_info_op purge;
drop table ${iol_schema}.nibs_ib_log_busfill_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ib_log_busfill_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_log_busfill_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
