/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_rp_legal
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
create table ${iol_schema}.rptm_rtm_rp_legal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rptm_rtm_rp_legal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_legal_op purge;
drop table ${iol_schema}.rptm_rtm_rp_legal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_legal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_legal where 0=1;

create table ${iol_schema}.rptm_rtm_rp_legal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_legal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_legal_cl(
            id -- 
            ,bus_id -- 
            ,east_rp_type -- 
            ,ybj_rp_type -- 
            ,rp_name -- 
            ,ybj_card_type -- 
            ,east_card_type -- 
            ,card_no -- 
            ,domestic_state -- 
            ,company_type -- 
            ,economic_nature -- 
            ,business_state -- 
            ,registered_capital -- 
            ,representative -- 
            ,bloc_state -- 
            ,bloc_id -- 
            ,registered -- 
            ,economic_scope -- 
            ,east_relation_type -- 
            ,industry_code -- 
            ,rea_no -- 
            ,inst_org -- 
            ,remarks -- 
            ,data_state -- 
            ,effect_state -- 
            ,active_time -- 
            ,invalid_time -- 
            ,process_time -- 
            ,data_source -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,wf_state -- 
            ,agree -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,cust_no -- 
            ,east_rp_bad_info -- 不良信息-east报表口径
            ,east_rp_economic_nature -- 经济性质和类型-east报表口径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_legal_op(
            id -- 
            ,bus_id -- 
            ,east_rp_type -- 
            ,ybj_rp_type -- 
            ,rp_name -- 
            ,ybj_card_type -- 
            ,east_card_type -- 
            ,card_no -- 
            ,domestic_state -- 
            ,company_type -- 
            ,economic_nature -- 
            ,business_state -- 
            ,registered_capital -- 
            ,representative -- 
            ,bloc_state -- 
            ,bloc_id -- 
            ,registered -- 
            ,economic_scope -- 
            ,east_relation_type -- 
            ,industry_code -- 
            ,rea_no -- 
            ,inst_org -- 
            ,remarks -- 
            ,data_state -- 
            ,effect_state -- 
            ,active_time -- 
            ,invalid_time -- 
            ,process_time -- 
            ,data_source -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,wf_state -- 
            ,agree -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,cust_no -- 
            ,east_rp_bad_info -- 不良信息-east报表口径
            ,east_rp_economic_nature -- 经济性质和类型-east报表口径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 
    ,nvl(n.east_rp_type, o.east_rp_type) as east_rp_type -- 
    ,nvl(n.ybj_rp_type, o.ybj_rp_type) as ybj_rp_type -- 
    ,nvl(n.rp_name, o.rp_name) as rp_name -- 
    ,nvl(n.ybj_card_type, o.ybj_card_type) as ybj_card_type -- 
    ,nvl(n.east_card_type, o.east_card_type) as east_card_type -- 
    ,nvl(n.card_no, o.card_no) as card_no -- 
    ,nvl(n.domestic_state, o.domestic_state) as domestic_state -- 
    ,nvl(n.company_type, o.company_type) as company_type -- 
    ,nvl(n.economic_nature, o.economic_nature) as economic_nature -- 
    ,nvl(n.business_state, o.business_state) as business_state -- 
    ,nvl(n.registered_capital, o.registered_capital) as registered_capital -- 
    ,nvl(n.representative, o.representative) as representative -- 
    ,nvl(n.bloc_state, o.bloc_state) as bloc_state -- 
    ,nvl(n.bloc_id, o.bloc_id) as bloc_id -- 
    ,nvl(n.registered, o.registered) as registered -- 
    ,nvl(n.economic_scope, o.economic_scope) as economic_scope -- 
    ,nvl(n.east_relation_type, o.east_relation_type) as east_relation_type -- 
    ,nvl(n.industry_code, o.industry_code) as industry_code -- 
    ,nvl(n.rea_no, o.rea_no) as rea_no -- 
    ,nvl(n.inst_org, o.inst_org) as inst_org -- 
    ,nvl(n.remarks, o.remarks) as remarks -- 
    ,nvl(n.data_state, o.data_state) as data_state -- 
    ,nvl(n.effect_state, o.effect_state) as effect_state -- 
    ,nvl(n.active_time, o.active_time) as active_time -- 
    ,nvl(n.invalid_time, o.invalid_time) as invalid_time -- 
    ,nvl(n.process_time, o.process_time) as process_time -- 
    ,nvl(n.data_source, o.data_source) as data_source -- 
    ,nvl(n.legal_org_code, o.legal_org_code) as legal_org_code -- 
    ,nvl(n.create_user, o.create_user) as create_user -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.create_org, o.create_org) as create_org -- 
    ,nvl(n.create_dep, o.create_dep) as create_dep -- 
    ,nvl(n.update_user, o.update_user) as update_user -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.update_org, o.update_org) as update_org -- 
    ,nvl(n.update_dep, o.update_dep) as update_dep -- 
    ,nvl(n.wf_state, o.wf_state) as wf_state -- 
    ,nvl(n.agree, o.agree) as agree -- 
    ,nvl(n.process_instance_id, o.process_instance_id) as process_instance_id -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 
    ,nvl(n.east_rp_bad_info, o.east_rp_bad_info) as east_rp_bad_info -- 不良信息-east报表口径
    ,nvl(n.east_rp_economic_nature, o.east_rp_economic_nature) as east_rp_economic_nature -- 经济性质和类型-east报表口径
    ,case when
            n.id is null
            and n.card_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
            and n.card_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
            and n.card_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rptm_rtm_rp_legal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rptm_rtm_rp_legal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
            and o.card_no = n.card_no
where (
        o.id is null
        and o.card_no is null
    )
    or (
        n.id is null
        and n.card_no is null
    )
    or (
        o.bus_id <> n.bus_id
        or o.east_rp_type <> n.east_rp_type
        or o.ybj_rp_type <> n.ybj_rp_type
        or o.rp_name <> n.rp_name
        or o.ybj_card_type <> n.ybj_card_type
        or o.east_card_type <> n.east_card_type
        or o.domestic_state <> n.domestic_state
        or o.company_type <> n.company_type
        or o.economic_nature <> n.economic_nature
        or o.business_state <> n.business_state
        or o.registered_capital <> n.registered_capital
        or o.representative <> n.representative
        or o.bloc_state <> n.bloc_state
        or o.bloc_id <> n.bloc_id
        or o.registered <> n.registered
        or o.economic_scope <> n.economic_scope
        or o.east_relation_type <> n.east_relation_type
        or o.industry_code <> n.industry_code
        or o.rea_no <> n.rea_no
        or o.inst_org <> n.inst_org
        or o.remarks <> n.remarks
        or o.data_state <> n.data_state
        or o.effect_state <> n.effect_state
        or o.active_time <> n.active_time
        or o.invalid_time <> n.invalid_time
        or o.process_time <> n.process_time
        or o.data_source <> n.data_source
        or o.legal_org_code <> n.legal_org_code
        or o.create_user <> n.create_user
        or o.create_time <> n.create_time
        or o.create_org <> n.create_org
        or o.create_dep <> n.create_dep
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.update_org <> n.update_org
        or o.update_dep <> n.update_dep
        or o.wf_state <> n.wf_state
        or o.agree <> n.agree
        or o.process_instance_id <> n.process_instance_id
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.cust_no <> n.cust_no
        or o.east_rp_bad_info <> n.east_rp_bad_info
        or o.east_rp_economic_nature <> n.east_rp_economic_nature
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_legal_cl(
            id -- 
            ,bus_id -- 
            ,east_rp_type -- 
            ,ybj_rp_type -- 
            ,rp_name -- 
            ,ybj_card_type -- 
            ,east_card_type -- 
            ,card_no -- 
            ,domestic_state -- 
            ,company_type -- 
            ,economic_nature -- 
            ,business_state -- 
            ,registered_capital -- 
            ,representative -- 
            ,bloc_state -- 
            ,bloc_id -- 
            ,registered -- 
            ,economic_scope -- 
            ,east_relation_type -- 
            ,industry_code -- 
            ,rea_no -- 
            ,inst_org -- 
            ,remarks -- 
            ,data_state -- 
            ,effect_state -- 
            ,active_time -- 
            ,invalid_time -- 
            ,process_time -- 
            ,data_source -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,wf_state -- 
            ,agree -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,cust_no -- 
            ,east_rp_bad_info -- 不良信息-east报表口径
            ,east_rp_economic_nature -- 经济性质和类型-east报表口径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_legal_op(
            id -- 
            ,bus_id -- 
            ,east_rp_type -- 
            ,ybj_rp_type -- 
            ,rp_name -- 
            ,ybj_card_type -- 
            ,east_card_type -- 
            ,card_no -- 
            ,domestic_state -- 
            ,company_type -- 
            ,economic_nature -- 
            ,business_state -- 
            ,registered_capital -- 
            ,representative -- 
            ,bloc_state -- 
            ,bloc_id -- 
            ,registered -- 
            ,economic_scope -- 
            ,east_relation_type -- 
            ,industry_code -- 
            ,rea_no -- 
            ,inst_org -- 
            ,remarks -- 
            ,data_state -- 
            ,effect_state -- 
            ,active_time -- 
            ,invalid_time -- 
            ,process_time -- 
            ,data_source -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,wf_state -- 
            ,agree -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,cust_no -- 
            ,east_rp_bad_info -- 不良信息-east报表口径
            ,east_rp_economic_nature -- 经济性质和类型-east报表口径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.bus_id -- 
    ,o.east_rp_type -- 
    ,o.ybj_rp_type -- 
    ,o.rp_name -- 
    ,o.ybj_card_type -- 
    ,o.east_card_type -- 
    ,o.card_no -- 
    ,o.domestic_state -- 
    ,o.company_type -- 
    ,o.economic_nature -- 
    ,o.business_state -- 
    ,o.registered_capital -- 
    ,o.representative -- 
    ,o.bloc_state -- 
    ,o.bloc_id -- 
    ,o.registered -- 
    ,o.economic_scope -- 
    ,o.east_relation_type -- 
    ,o.industry_code -- 
    ,o.rea_no -- 
    ,o.inst_org -- 
    ,o.remarks -- 
    ,o.data_state -- 
    ,o.effect_state -- 
    ,o.active_time -- 
    ,o.invalid_time -- 
    ,o.process_time -- 
    ,o.data_source -- 
    ,o.legal_org_code -- 
    ,o.create_user -- 
    ,o.create_time -- 
    ,o.create_org -- 
    ,o.create_dep -- 
    ,o.update_user -- 
    ,o.update_time -- 
    ,o.update_org -- 
    ,o.update_dep -- 
    ,o.wf_state -- 
    ,o.agree -- 
    ,o.process_instance_id -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.cust_no -- 
    ,o.east_rp_bad_info -- 不良信息-east报表口径
    ,o.east_rp_economic_nature -- 经济性质和类型-east报表口径
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
from ${iol_schema}.rptm_rtm_rp_legal_bk o
    left join ${iol_schema}.rptm_rtm_rp_legal_op n
        on
            o.id = n.id
            and o.card_no = n.card_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rptm_rtm_rp_legal_cl d
        on
            o.id = d.id
            and o.card_no = d.card_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rptm_rtm_rp_legal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rptm_rtm_rp_legal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rptm_rtm_rp_legal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rptm_rtm_rp_legal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rptm_rtm_rp_legal exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_rp_legal_cl;
alter table ${iol_schema}.rptm_rtm_rp_legal exchange partition p_20991231 with table ${iol_schema}.rptm_rtm_rp_legal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_rp_legal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_legal_op purge;
drop table ${iol_schema}.rptm_rtm_rp_legal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rptm_rtm_rp_legal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_rp_legal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
