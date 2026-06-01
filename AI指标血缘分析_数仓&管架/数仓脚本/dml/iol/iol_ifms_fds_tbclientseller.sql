/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_fds_tbclientseller
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
create table ${iol_schema}.ifms_fds_tbclientseller_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_fds_tbclientseller;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbclientseller_op purge;
drop table ${iol_schema}.ifms_fds_tbclientseller_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbclientseller_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbclientseller where 0=1;

create table ${iol_schema}.ifms_fds_tbclientseller_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbclientseller where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbclientseller_cl(
            in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,seller_code -- 
            ,open_date -- 
            ,close_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,client_group -- 
            ,address -- 
            ,post_code -- 
            ,tel -- 
            ,fax -- 
            ,mobile -- 
            ,email -- 
            ,send_freq -- 
            ,send_mode -- 
            ,education -- 
            ,income -- 
            ,vocation -- 
            ,nationality -- 
            ,channels -- 
            ,prd_types -- 
            ,client_manager -- 
            ,open_branch -- 
            ,modi_date -- 
            ,modi_time -- 
            ,modify_info -- 
            ,ta_client -- 
            ,status -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,ta_client2 -- 
            ,status2 -- 
            ,investor_type -- 
            ,other_id_type_name -- 
            ,last_modify_date -- 
            ,spv_branch -- 
            ,other_branch -- 
            ,qua_investor_type -- 
            ,region_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbclientseller_op(
            in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,seller_code -- 
            ,open_date -- 
            ,close_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,client_group -- 
            ,address -- 
            ,post_code -- 
            ,tel -- 
            ,fax -- 
            ,mobile -- 
            ,email -- 
            ,send_freq -- 
            ,send_mode -- 
            ,education -- 
            ,income -- 
            ,vocation -- 
            ,nationality -- 
            ,channels -- 
            ,prd_types -- 
            ,client_manager -- 
            ,open_branch -- 
            ,modi_date -- 
            ,modi_time -- 
            ,modify_info -- 
            ,ta_client -- 
            ,status -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,ta_client2 -- 
            ,status2 -- 
            ,investor_type -- 
            ,other_id_type_name -- 
            ,last_modify_date -- 
            ,spv_branch -- 
            ,other_branch -- 
            ,qua_investor_type -- 
            ,region_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.open_date, o.open_date) as open_date -- 
    ,nvl(n.close_date, o.close_date) as close_date -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.client_group, o.client_group) as client_group -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.post_code, o.post_code) as post_code -- 
    ,nvl(n.tel, o.tel) as tel -- 
    ,nvl(n.fax, o.fax) as fax -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.send_freq, o.send_freq) as send_freq -- 
    ,nvl(n.send_mode, o.send_mode) as send_mode -- 
    ,nvl(n.education, o.education) as education -- 
    ,nvl(n.income, o.income) as income -- 
    ,nvl(n.vocation, o.vocation) as vocation -- 
    ,nvl(n.nationality, o.nationality) as nationality -- 
    ,nvl(n.channels, o.channels) as channels -- 
    ,nvl(n.prd_types, o.prd_types) as prd_types -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.modi_date, o.modi_date) as modi_date -- 
    ,nvl(n.modi_time, o.modi_time) as modi_time -- 
    ,nvl(n.modify_info, o.modify_info) as modify_info -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.ta_client2, o.ta_client2) as ta_client2 -- 
    ,nvl(n.status2, o.status2) as status2 -- 
    ,nvl(n.investor_type, o.investor_type) as investor_type -- 
    ,nvl(n.other_id_type_name, o.other_id_type_name) as other_id_type_name -- 
    ,nvl(n.last_modify_date, o.last_modify_date) as last_modify_date -- 
    ,nvl(n.spv_branch, o.spv_branch) as spv_branch -- 
    ,nvl(n.other_branch, o.other_branch) as other_branch -- 
    ,nvl(n.qua_investor_type, o.qua_investor_type) as qua_investor_type -- 
    ,nvl(n.region_code, o.region_code) as region_code -- 
    ,case when
            n.bank_no is null
            and n.client_no is null
            and n.seller_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bank_no is null
            and n.client_no is null
            and n.seller_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bank_no is null
            and n.client_no is null
            and n.seller_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_fds_tbclientseller_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_fds_tbclientseller where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bank_no = n.bank_no
            and o.client_no = n.client_no
            and o.seller_code = n.seller_code
where (
        o.bank_no is null
        and o.client_no is null
        and o.seller_code is null
    )
    or (
        n.bank_no is null
        and n.client_no is null
        and n.seller_code is null
    )
    or (
        o.in_client_no <> n.in_client_no
        or o.open_date <> n.open_date
        or o.close_date <> n.close_date
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.client_group <> n.client_group
        or o.address <> n.address
        or o.post_code <> n.post_code
        or o.tel <> n.tel
        or o.fax <> n.fax
        or o.mobile <> n.mobile
        or o.email <> n.email
        or o.send_freq <> n.send_freq
        or o.send_mode <> n.send_mode
        or o.education <> n.education
        or o.income <> n.income
        or o.vocation <> n.vocation
        or o.nationality <> n.nationality
        or o.channels <> n.channels
        or o.prd_types <> n.prd_types
        or o.client_manager <> n.client_manager
        or o.open_branch <> n.open_branch
        or o.modi_date <> n.modi_date
        or o.modi_time <> n.modi_time
        or o.modify_info <> n.modify_info
        or o.ta_client <> n.ta_client
        or o.status <> n.status
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.ta_client2 <> n.ta_client2
        or o.status2 <> n.status2
        or o.investor_type <> n.investor_type
        or o.other_id_type_name <> n.other_id_type_name
        or o.last_modify_date <> n.last_modify_date
        or o.spv_branch <> n.spv_branch
        or o.other_branch <> n.other_branch
        or o.qua_investor_type <> n.qua_investor_type
        or o.region_code <> n.region_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbclientseller_cl(
            in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,seller_code -- 
            ,open_date -- 
            ,close_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,client_group -- 
            ,address -- 
            ,post_code -- 
            ,tel -- 
            ,fax -- 
            ,mobile -- 
            ,email -- 
            ,send_freq -- 
            ,send_mode -- 
            ,education -- 
            ,income -- 
            ,vocation -- 
            ,nationality -- 
            ,channels -- 
            ,prd_types -- 
            ,client_manager -- 
            ,open_branch -- 
            ,modi_date -- 
            ,modi_time -- 
            ,modify_info -- 
            ,ta_client -- 
            ,status -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,ta_client2 -- 
            ,status2 -- 
            ,investor_type -- 
            ,other_id_type_name -- 
            ,last_modify_date -- 
            ,spv_branch -- 
            ,other_branch -- 
            ,qua_investor_type -- 
            ,region_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbclientseller_op(
            in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,seller_code -- 
            ,open_date -- 
            ,close_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,client_group -- 
            ,address -- 
            ,post_code -- 
            ,tel -- 
            ,fax -- 
            ,mobile -- 
            ,email -- 
            ,send_freq -- 
            ,send_mode -- 
            ,education -- 
            ,income -- 
            ,vocation -- 
            ,nationality -- 
            ,channels -- 
            ,prd_types -- 
            ,client_manager -- 
            ,open_branch -- 
            ,modi_date -- 
            ,modi_time -- 
            ,modify_info -- 
            ,ta_client -- 
            ,status -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,ta_client2 -- 
            ,status2 -- 
            ,investor_type -- 
            ,other_id_type_name -- 
            ,last_modify_date -- 
            ,spv_branch -- 
            ,other_branch -- 
            ,qua_investor_type -- 
            ,region_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.seller_code -- 
    ,o.open_date -- 
    ,o.close_date -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.client_group -- 
    ,o.address -- 
    ,o.post_code -- 
    ,o.tel -- 
    ,o.fax -- 
    ,o.mobile -- 
    ,o.email -- 
    ,o.send_freq -- 
    ,o.send_mode -- 
    ,o.education -- 
    ,o.income -- 
    ,o.vocation -- 
    ,o.nationality -- 
    ,o.channels -- 
    ,o.prd_types -- 
    ,o.client_manager -- 
    ,o.open_branch -- 
    ,o.modi_date -- 
    ,o.modi_time -- 
    ,o.modify_info -- 
    ,o.ta_client -- 
    ,o.status -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.ta_client2 -- 
    ,o.status2 -- 
    ,o.investor_type -- 
    ,o.other_id_type_name -- 
    ,o.last_modify_date -- 
    ,o.spv_branch -- 
    ,o.other_branch -- 
    ,o.qua_investor_type -- 
    ,o.region_code -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_fds_tbclientseller_bk o
    left join ${iol_schema}.ifms_fds_tbclientseller_op n
        on
            o.bank_no = n.bank_no
            and o.client_no = n.client_no
            and o.seller_code = n.seller_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_fds_tbclientseller_cl d
        on
            o.bank_no = d.bank_no
            and o.client_no = d.client_no
            and o.seller_code = d.seller_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_fds_tbclientseller;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_fds_tbclientseller exchange partition p_19000101 with table ${iol_schema}.ifms_fds_tbclientseller_cl;
alter table ${iol_schema}.ifms_fds_tbclientseller exchange partition p_20991231 with table ${iol_schema}.ifms_fds_tbclientseller_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_fds_tbclientseller to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbclientseller_op purge;
drop table ${iol_schema}.ifms_fds_tbclientseller_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_fds_tbclientseller_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_fds_tbclientseller',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
