/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbinsurerinfo
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
create table ${iol_schema}.ifms_tbinsurerinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbinsurerinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsurerinfo_op purge;
drop table ${iol_schema}.ifms_tbinsurerinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsurerinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsurerinfo where 0=1;

create table ${iol_schema}.ifms_tbinsurerinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsurerinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsurerinfo_cl(
            ta_code -- 
            ,insure_bank_no -- 
            ,ta_name -- 
            ,ta_short_name -- 
            ,ta_busin_name -- 
            ,ta_type -- 
            ,ta_limit_flag -- 
            ,charge_flag -- 
            ,begin_date -- 
            ,end_date -- 
            ,master_internal -- 
            ,master_branch -- 
            ,insurer_acc -- 
            ,in_busin_no -- 
            ,out_busin_no -- 
            ,ip_address -- 
            ,port -- 
            ,wait_time -- 
            ,file_ip -- 
            ,file_port -- 
            ,file_wait_time -- 
            ,link_name -- 
            ,link_tel -- 
            ,signin_flag -- 
            ,signin_date -- 
            ,m_pkg_key -- 
            ,m_pwd_key -- 
            ,m_mac_key -- 
            ,pkg_key -- 
            ,pwd_key -- 
            ,mac_key -- 
            ,control_flag -- 
            ,open_time -- 
            ,close_time -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsurerinfo_op(
            ta_code -- 
            ,insure_bank_no -- 
            ,ta_name -- 
            ,ta_short_name -- 
            ,ta_busin_name -- 
            ,ta_type -- 
            ,ta_limit_flag -- 
            ,charge_flag -- 
            ,begin_date -- 
            ,end_date -- 
            ,master_internal -- 
            ,master_branch -- 
            ,insurer_acc -- 
            ,in_busin_no -- 
            ,out_busin_no -- 
            ,ip_address -- 
            ,port -- 
            ,wait_time -- 
            ,file_ip -- 
            ,file_port -- 
            ,file_wait_time -- 
            ,link_name -- 
            ,link_tel -- 
            ,signin_flag -- 
            ,signin_date -- 
            ,m_pkg_key -- 
            ,m_pwd_key -- 
            ,m_mac_key -- 
            ,pkg_key -- 
            ,pwd_key -- 
            ,mac_key -- 
            ,control_flag -- 
            ,open_time -- 
            ,close_time -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.insure_bank_no, o.insure_bank_no) as insure_bank_no -- 
    ,nvl(n.ta_name, o.ta_name) as ta_name -- 
    ,nvl(n.ta_short_name, o.ta_short_name) as ta_short_name -- 
    ,nvl(n.ta_busin_name, o.ta_busin_name) as ta_busin_name -- 
    ,nvl(n.ta_type, o.ta_type) as ta_type -- 
    ,nvl(n.ta_limit_flag, o.ta_limit_flag) as ta_limit_flag -- 
    ,nvl(n.charge_flag, o.charge_flag) as charge_flag -- 
    ,nvl(n.begin_date, o.begin_date) as begin_date -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,nvl(n.master_internal, o.master_internal) as master_internal -- 
    ,nvl(n.master_branch, o.master_branch) as master_branch -- 
    ,nvl(n.insurer_acc, o.insurer_acc) as insurer_acc -- 
    ,nvl(n.in_busin_no, o.in_busin_no) as in_busin_no -- 
    ,nvl(n.out_busin_no, o.out_busin_no) as out_busin_no -- 
    ,nvl(n.ip_address, o.ip_address) as ip_address -- 
    ,nvl(n.port, o.port) as port -- 
    ,nvl(n.wait_time, o.wait_time) as wait_time -- 
    ,nvl(n.file_ip, o.file_ip) as file_ip -- 
    ,nvl(n.file_port, o.file_port) as file_port -- 
    ,nvl(n.file_wait_time, o.file_wait_time) as file_wait_time -- 
    ,nvl(n.link_name, o.link_name) as link_name -- 
    ,nvl(n.link_tel, o.link_tel) as link_tel -- 
    ,nvl(n.signin_flag, o.signin_flag) as signin_flag -- 
    ,nvl(n.signin_date, o.signin_date) as signin_date -- 
    ,nvl(n.m_pkg_key, o.m_pkg_key) as m_pkg_key -- 
    ,nvl(n.m_pwd_key, o.m_pwd_key) as m_pwd_key -- 
    ,nvl(n.m_mac_key, o.m_mac_key) as m_mac_key -- 
    ,nvl(n.pkg_key, o.pkg_key) as pkg_key -- 
    ,nvl(n.pwd_key, o.pwd_key) as pwd_key -- 
    ,nvl(n.mac_key, o.mac_key) as mac_key -- 
    ,nvl(n.control_flag, o.control_flag) as control_flag -- 
    ,nvl(n.open_time, o.open_time) as open_time -- 
    ,nvl(n.close_time, o.close_time) as close_time -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,case when
            n.ta_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbinsurerinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbinsurerinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
where (
        o.ta_code is null
    )
    or (
        n.ta_code is null
    )
    or (
        o.insure_bank_no <> n.insure_bank_no
        or o.ta_name <> n.ta_name
        or o.ta_short_name <> n.ta_short_name
        or o.ta_busin_name <> n.ta_busin_name
        or o.ta_type <> n.ta_type
        or o.ta_limit_flag <> n.ta_limit_flag
        or o.charge_flag <> n.charge_flag
        or o.begin_date <> n.begin_date
        or o.end_date <> n.end_date
        or o.master_internal <> n.master_internal
        or o.master_branch <> n.master_branch
        or o.insurer_acc <> n.insurer_acc
        or o.in_busin_no <> n.in_busin_no
        or o.out_busin_no <> n.out_busin_no
        or o.ip_address <> n.ip_address
        or o.port <> n.port
        or o.wait_time <> n.wait_time
        or o.file_ip <> n.file_ip
        or o.file_port <> n.file_port
        or o.file_wait_time <> n.file_wait_time
        or o.link_name <> n.link_name
        or o.link_tel <> n.link_tel
        or o.signin_flag <> n.signin_flag
        or o.signin_date <> n.signin_date
        or o.m_pkg_key <> n.m_pkg_key
        or o.m_pwd_key <> n.m_pwd_key
        or o.m_mac_key <> n.m_mac_key
        or o.pkg_key <> n.pkg_key
        or o.pwd_key <> n.pwd_key
        or o.mac_key <> n.mac_key
        or o.control_flag <> n.control_flag
        or o.open_time <> n.open_time
        or o.close_time <> n.close_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsurerinfo_cl(
            ta_code -- 
            ,insure_bank_no -- 
            ,ta_name -- 
            ,ta_short_name -- 
            ,ta_busin_name -- 
            ,ta_type -- 
            ,ta_limit_flag -- 
            ,charge_flag -- 
            ,begin_date -- 
            ,end_date -- 
            ,master_internal -- 
            ,master_branch -- 
            ,insurer_acc -- 
            ,in_busin_no -- 
            ,out_busin_no -- 
            ,ip_address -- 
            ,port -- 
            ,wait_time -- 
            ,file_ip -- 
            ,file_port -- 
            ,file_wait_time -- 
            ,link_name -- 
            ,link_tel -- 
            ,signin_flag -- 
            ,signin_date -- 
            ,m_pkg_key -- 
            ,m_pwd_key -- 
            ,m_mac_key -- 
            ,pkg_key -- 
            ,pwd_key -- 
            ,mac_key -- 
            ,control_flag -- 
            ,open_time -- 
            ,close_time -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsurerinfo_op(
            ta_code -- 
            ,insure_bank_no -- 
            ,ta_name -- 
            ,ta_short_name -- 
            ,ta_busin_name -- 
            ,ta_type -- 
            ,ta_limit_flag -- 
            ,charge_flag -- 
            ,begin_date -- 
            ,end_date -- 
            ,master_internal -- 
            ,master_branch -- 
            ,insurer_acc -- 
            ,in_busin_no -- 
            ,out_busin_no -- 
            ,ip_address -- 
            ,port -- 
            ,wait_time -- 
            ,file_ip -- 
            ,file_port -- 
            ,file_wait_time -- 
            ,link_name -- 
            ,link_tel -- 
            ,signin_flag -- 
            ,signin_date -- 
            ,m_pkg_key -- 
            ,m_pwd_key -- 
            ,m_mac_key -- 
            ,pkg_key -- 
            ,pwd_key -- 
            ,mac_key -- 
            ,control_flag -- 
            ,open_time -- 
            ,close_time -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- 
    ,o.insure_bank_no -- 
    ,o.ta_name -- 
    ,o.ta_short_name -- 
    ,o.ta_busin_name -- 
    ,o.ta_type -- 
    ,o.ta_limit_flag -- 
    ,o.charge_flag -- 
    ,o.begin_date -- 
    ,o.end_date -- 
    ,o.master_internal -- 
    ,o.master_branch -- 
    ,o.insurer_acc -- 
    ,o.in_busin_no -- 
    ,o.out_busin_no -- 
    ,o.ip_address -- 
    ,o.port -- 
    ,o.wait_time -- 
    ,o.file_ip -- 
    ,o.file_port -- 
    ,o.file_wait_time -- 
    ,o.link_name -- 
    ,o.link_tel -- 
    ,o.signin_flag -- 
    ,o.signin_date -- 
    ,o.m_pkg_key -- 
    ,o.m_pwd_key -- 
    ,o.m_mac_key -- 
    ,o.pkg_key -- 
    ,o.pwd_key -- 
    ,o.mac_key -- 
    ,o.control_flag -- 
    ,o.open_time -- 
    ,o.close_time -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbinsurerinfo_bk o
    left join ${iol_schema}.ifms_tbinsurerinfo_op n
        on
            o.ta_code = n.ta_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbinsurerinfo_cl d
        on
            o.ta_code = d.ta_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbinsurerinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbinsurerinfo exchange partition p_19000101 with table ${iol_schema}.ifms_tbinsurerinfo_cl;
alter table ${iol_schema}.ifms_tbinsurerinfo exchange partition p_20991231 with table ${iol_schema}.ifms_tbinsurerinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbinsurerinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsurerinfo_op purge;
drop table ${iol_schema}.ifms_tbinsurerinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbinsurerinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbinsurerinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
