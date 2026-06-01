/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_rp_sub_legal
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
create table ${iol_schema}.rptm_rtm_rp_sub_legal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rptm_rtm_rp_sub_legal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_sub_legal_op purge;
drop table ${iol_schema}.rptm_rtm_rp_sub_legal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_sub_legal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_sub_legal where 0=1;

create table ${iol_schema}.rptm_rtm_rp_sub_legal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_sub_legal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_sub_legal_cl(
            id -- 
            ,record_bus_id -- 
            ,rp_name -- 
            ,domestic_state -- 
            ,card_type -- 
            ,card_no -- 
            ,economic_nature -- 
            ,economic_scope -- 
            ,representative -- 
            ,registered -- 
            ,registered_capital -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_sub_legal_op(
            id -- 
            ,record_bus_id -- 
            ,rp_name -- 
            ,domestic_state -- 
            ,card_type -- 
            ,card_no -- 
            ,economic_nature -- 
            ,economic_scope -- 
            ,representative -- 
            ,registered -- 
            ,registered_capital -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.record_bus_id, o.record_bus_id) as record_bus_id -- 
    ,nvl(n.rp_name, o.rp_name) as rp_name -- 
    ,nvl(n.domestic_state, o.domestic_state) as domestic_state -- 
    ,nvl(n.card_type, o.card_type) as card_type -- 
    ,nvl(n.card_no, o.card_no) as card_no -- 
    ,nvl(n.economic_nature, o.economic_nature) as economic_nature -- 
    ,nvl(n.economic_scope, o.economic_scope) as economic_scope -- 
    ,nvl(n.representative, o.representative) as representative -- 
    ,nvl(n.registered, o.registered) as registered -- 
    ,nvl(n.registered_capital, o.registered_capital) as registered_capital -- 
    ,nvl(n.legal_org_code, o.legal_org_code) as legal_org_code -- 
    ,nvl(n.create_user, o.create_user) as create_user -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.create_org, o.create_org) as create_org -- 
    ,nvl(n.create_dep, o.create_dep) as create_dep -- 
    ,nvl(n.update_user, o.update_user) as update_user -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.update_org, o.update_org) as update_org -- 
    ,nvl(n.update_dep, o.update_dep) as update_dep -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when

        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when

        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when

        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rptm_rtm_rp_sub_legal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rptm_rtm_rp_sub_legal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on

where (

    )
    or (

    )
    or (
        o.id <> n.id
        or o.record_bus_id <> n.record_bus_id
        or o.rp_name <> n.rp_name
        or o.domestic_state <> n.domestic_state
        or o.card_type <> n.card_type
        or o.card_no <> n.card_no
        or o.economic_nature <> n.economic_nature
        or o.economic_scope <> n.economic_scope
        or o.representative <> n.representative
        or o.registered <> n.registered
        or o.registered_capital <> n.registered_capital
        or o.legal_org_code <> n.legal_org_code
        or o.create_user <> n.create_user
        or o.create_time <> n.create_time
        or o.create_org <> n.create_org
        or o.create_dep <> n.create_dep
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.update_org <> n.update_org
        or o.update_dep <> n.update_dep
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_sub_legal_cl(
            id -- 
            ,record_bus_id -- 
            ,rp_name -- 
            ,domestic_state -- 
            ,card_type -- 
            ,card_no -- 
            ,economic_nature -- 
            ,economic_scope -- 
            ,representative -- 
            ,registered -- 
            ,registered_capital -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_sub_legal_op(
            id -- 
            ,record_bus_id -- 
            ,rp_name -- 
            ,domestic_state -- 
            ,card_type -- 
            ,card_no -- 
            ,economic_nature -- 
            ,economic_scope -- 
            ,representative -- 
            ,registered -- 
            ,registered_capital -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.record_bus_id -- 
    ,o.rp_name -- 
    ,o.domestic_state -- 
    ,o.card_type -- 
    ,o.card_no -- 
    ,o.economic_nature -- 
    ,o.economic_scope -- 
    ,o.representative -- 
    ,o.registered -- 
    ,o.registered_capital -- 
    ,o.legal_org_code -- 
    ,o.create_user -- 
    ,o.create_time -- 
    ,o.create_org -- 
    ,o.create_dep -- 
    ,o.update_user -- 
    ,o.update_time -- 
    ,o.update_org -- 
    ,o.update_dep -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
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
from ${iol_schema}.rptm_rtm_rp_sub_legal_bk o
    left join ${iol_schema}.rptm_rtm_rp_sub_legal_op n
        on

            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rptm_rtm_rp_sub_legal_cl d
        on

where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rptm_rtm_rp_sub_legal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rptm_rtm_rp_sub_legal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rptm_rtm_rp_sub_legal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rptm_rtm_rp_sub_legal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rptm_rtm_rp_sub_legal exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_rp_sub_legal_cl;
alter table ${iol_schema}.rptm_rtm_rp_sub_legal exchange partition p_20991231 with table ${iol_schema}.rptm_rtm_rp_sub_legal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_rp_sub_legal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_sub_legal_op purge;
drop table ${iol_schema}.rptm_rtm_rp_sub_legal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rptm_rtm_rp_sub_legal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_rp_sub_legal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
