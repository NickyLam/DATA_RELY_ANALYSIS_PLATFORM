/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_rp_collect_legal_stock
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
create table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rptm_rtm_rp_collect_legal_stock
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_op purge;
drop table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_collect_legal_stock where 0=1;

create table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_collect_legal_stock where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_collect_legal_stock_cl(
            rp_name -- 
            ,card_type -- 
            ,card_no -- 
            ,domestic_state -- 
            ,cust_no -- 
            ,company_type -- 
            ,economic_nature -- 
            ,business_state -- 
            ,registered_capital -- 
            ,representative -- 
            ,registered -- 
            ,economic_scope -- 
            ,stock_name -- 
            ,stock_id -- 
            ,stock_type -- 
            ,stock_type_code -- 
            ,entity_type -- 
            ,identify_type -- 
            ,stock_percent -- 
            ,etl_dt -- 
            ,stock_card_no -- 
            ,stock_economic_nature -- 
            ,stock_business_state -- 
            ,stock_registered_capital -- 
            ,stock_representative -- 
            ,stock_economic_scope -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_collect_legal_stock_op(
            rp_name -- 
            ,card_type -- 
            ,card_no -- 
            ,domestic_state -- 
            ,cust_no -- 
            ,company_type -- 
            ,economic_nature -- 
            ,business_state -- 
            ,registered_capital -- 
            ,representative -- 
            ,registered -- 
            ,economic_scope -- 
            ,stock_name -- 
            ,stock_id -- 
            ,stock_type -- 
            ,stock_type_code -- 
            ,entity_type -- 
            ,identify_type -- 
            ,stock_percent -- 
            ,etl_dt -- 
            ,stock_card_no -- 
            ,stock_economic_nature -- 
            ,stock_business_state -- 
            ,stock_registered_capital -- 
            ,stock_representative -- 
            ,stock_economic_scope -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rp_name, o.rp_name) as rp_name -- 
    ,nvl(n.card_type, o.card_type) as card_type -- 
    ,nvl(n.card_no, o.card_no) as card_no -- 
    ,nvl(n.domestic_state, o.domestic_state) as domestic_state -- 
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 
    ,nvl(n.company_type, o.company_type) as company_type -- 
    ,nvl(n.economic_nature, o.economic_nature) as economic_nature -- 
    ,nvl(n.business_state, o.business_state) as business_state -- 
    ,nvl(n.registered_capital, o.registered_capital) as registered_capital -- 
    ,nvl(n.representative, o.representative) as representative -- 
    ,nvl(n.registered, o.registered) as registered -- 
    ,nvl(n.economic_scope, o.economic_scope) as economic_scope -- 
    ,nvl(n.stock_name, o.stock_name) as stock_name -- 
    ,nvl(n.stock_id, o.stock_id) as stock_id -- 
    ,nvl(n.stock_type, o.stock_type) as stock_type -- 
    ,nvl(n.stock_type_code, o.stock_type_code) as stock_type_code -- 
    ,nvl(n.entity_type, o.entity_type) as entity_type -- 
    ,nvl(n.identify_type, o.identify_type) as identify_type -- 
    ,nvl(n.stock_percent, o.stock_percent) as stock_percent -- 
    ,nvl(n.etl_dt, o.etl_dt) as etl_dt -- 
    ,nvl(n.stock_card_no, o.stock_card_no) as stock_card_no -- 
    ,nvl(n.stock_economic_nature, o.stock_economic_nature) as stock_economic_nature -- 
    ,nvl(n.stock_business_state, o.stock_business_state) as stock_business_state -- 
    ,nvl(n.stock_registered_capital, o.stock_registered_capital) as stock_registered_capital -- 
    ,nvl(n.stock_representative, o.stock_representative) as stock_representative -- 
    ,nvl(n.stock_economic_scope, o.stock_economic_scope) as stock_economic_scope -- 
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
from (select * from ${iol_schema}.rptm_rtm_rp_collect_legal_stock_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rptm_rtm_rp_collect_legal_stock where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on

where (

    )
    or (

    )
    or (
        o.rp_name <> n.rp_name
        or o.card_type <> n.card_type
        or o.card_no <> n.card_no
        or o.domestic_state <> n.domestic_state
        or o.cust_no <> n.cust_no
        or o.company_type <> n.company_type
        or o.economic_nature <> n.economic_nature
        or o.business_state <> n.business_state
        or o.registered_capital <> n.registered_capital
        or o.representative <> n.representative
        or o.registered <> n.registered
        or o.economic_scope <> n.economic_scope
        or o.stock_name <> n.stock_name
        or o.stock_id <> n.stock_id
        or o.stock_type <> n.stock_type
        or o.stock_type_code <> n.stock_type_code
        or o.entity_type <> n.entity_type
        or o.identify_type <> n.identify_type
        or o.stock_percent <> n.stock_percent
        or o.etl_dt <> n.etl_dt
        or o.stock_card_no <> n.stock_card_no
        or o.stock_economic_nature <> n.stock_economic_nature
        or o.stock_business_state <> n.stock_business_state
        or o.stock_registered_capital <> n.stock_registered_capital
        or o.stock_representative <> n.stock_representative
        or o.stock_economic_scope <> n.stock_economic_scope
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_collect_legal_stock_cl(
            rp_name -- 
            ,card_type -- 
            ,card_no -- 
            ,domestic_state -- 
            ,cust_no -- 
            ,company_type -- 
            ,economic_nature -- 
            ,business_state -- 
            ,registered_capital -- 
            ,representative -- 
            ,registered -- 
            ,economic_scope -- 
            ,stock_name -- 
            ,stock_id -- 
            ,stock_type -- 
            ,stock_type_code -- 
            ,entity_type -- 
            ,identify_type -- 
            ,stock_percent -- 
            ,etl_dt -- 
            ,stock_card_no -- 
            ,stock_economic_nature -- 
            ,stock_business_state -- 
            ,stock_registered_capital -- 
            ,stock_representative -- 
            ,stock_economic_scope -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_collect_legal_stock_op(
            rp_name -- 
            ,card_type -- 
            ,card_no -- 
            ,domestic_state -- 
            ,cust_no -- 
            ,company_type -- 
            ,economic_nature -- 
            ,business_state -- 
            ,registered_capital -- 
            ,representative -- 
            ,registered -- 
            ,economic_scope -- 
            ,stock_name -- 
            ,stock_id -- 
            ,stock_type -- 
            ,stock_type_code -- 
            ,entity_type -- 
            ,identify_type -- 
            ,stock_percent -- 
            ,etl_dt -- 
            ,stock_card_no -- 
            ,stock_economic_nature -- 
            ,stock_business_state -- 
            ,stock_registered_capital -- 
            ,stock_representative -- 
            ,stock_economic_scope -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rp_name -- 
    ,o.card_type -- 
    ,o.card_no -- 
    ,o.domestic_state -- 
    ,o.cust_no -- 
    ,o.company_type -- 
    ,o.economic_nature -- 
    ,o.business_state -- 
    ,o.registered_capital -- 
    ,o.representative -- 
    ,o.registered -- 
    ,o.economic_scope -- 
    ,o.stock_name -- 
    ,o.stock_id -- 
    ,o.stock_type -- 
    ,o.stock_type_code -- 
    ,o.entity_type -- 
    ,o.identify_type -- 
    ,o.stock_percent -- 
    ,o.etl_dt -- 
    ,o.stock_card_no -- 
    ,o.stock_economic_nature -- 
    ,o.stock_business_state -- 
    ,o.stock_registered_capital -- 
    ,o.stock_representative -- 
    ,o.stock_economic_scope -- 
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
from ${iol_schema}.rptm_rtm_rp_collect_legal_stock_bk o
    left join ${iol_schema}.rptm_rtm_rp_collect_legal_stock_op n
        on

            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rptm_rtm_rp_collect_legal_stock_cl d
        on

where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rptm_rtm_rp_collect_legal_stock;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rptm_rtm_rp_collect_legal_stock') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rptm_rtm_rp_collect_legal_stock drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rptm_rtm_rp_collect_legal_stock add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rptm_rtm_rp_collect_legal_stock exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_cl;
alter table ${iol_schema}.rptm_rtm_rp_collect_legal_stock exchange partition p_20991231 with table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_rp_collect_legal_stock to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_op purge;
drop table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rptm_rtm_rp_collect_legal_stock_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_rp_collect_legal_stock',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
