/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_wtrade_tr_si
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
create table ${iol_schema}.ctms_wtrade_tr_si_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_wtrade_tr_si
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_wtrade_tr_si_op purge;
drop table ${iol_schema}.ctms_wtrade_tr_si_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_wtrade_tr_si_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_wtrade_tr_si where 0=1;

create table ${iol_schema}.ctms_wtrade_tr_si_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_wtrade_tr_si where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_wtrade_tr_si_cl(
            aspclient_id -- 
            ,serial_number -- 
            ,bs -- 
            ,cash_acc_ename -- 
            ,cash_acc_cname -- 
            ,cash_acc_bank -- 
            ,cash_acc_no -- 
            ,cash_acc_bank_ex -- 
            ,bond_acc_name -- 
            ,bond_acc_bank -- 
            ,bond_acc_no -- 
            ,g_cash_amt -- 
            ,g_bond_id -- 
            ,g_bond_name -- 
            ,g_bond_amt -- 
            ,g_bond_total_amt -- 
            ,g_ca_name -- 
            ,g_ca_bank -- 
            ,g_ca_no -- 
            ,g_ca_bank_ex -- 
            ,g_ba_name -- 
            ,g_ba_bank -- 
            ,g_ba_no -- 
            ,g_stl_date -- 
            ,g_mgr_bank -- 
            ,lastmodified -- 
            ,datasymbol_id -- 
            ,settle_instr_name -- 清算路径名称
            ,swift_code -- Swift Code编码
            ,bond_owner -- 托管账号开户人
            ,custody_institution_type -- 托管机构类型
            ,bond_settle_instr_name -- 托管清算路径名称
            ,bond_escrow_opening_bank -- 债券托管开户行
            ,escrow_agency -- 托管机构
            ,bond_acc_ename -- 债券托管账户英文户名
            ,bond_escrow_manage_agency -- 债券托管管理机构
            ,bond_swift_code -- 托管机构SWIFT CODE
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_wtrade_tr_si_op(
            aspclient_id -- 
            ,serial_number -- 
            ,bs -- 
            ,cash_acc_ename -- 
            ,cash_acc_cname -- 
            ,cash_acc_bank -- 
            ,cash_acc_no -- 
            ,cash_acc_bank_ex -- 
            ,bond_acc_name -- 
            ,bond_acc_bank -- 
            ,bond_acc_no -- 
            ,g_cash_amt -- 
            ,g_bond_id -- 
            ,g_bond_name -- 
            ,g_bond_amt -- 
            ,g_bond_total_amt -- 
            ,g_ca_name -- 
            ,g_ca_bank -- 
            ,g_ca_no -- 
            ,g_ca_bank_ex -- 
            ,g_ba_name -- 
            ,g_ba_bank -- 
            ,g_ba_no -- 
            ,g_stl_date -- 
            ,g_mgr_bank -- 
            ,lastmodified -- 
            ,datasymbol_id -- 
            ,settle_instr_name -- 清算路径名称
            ,swift_code -- Swift Code编码
            ,bond_owner -- 托管账号开户人
            ,custody_institution_type -- 托管机构类型
            ,bond_settle_instr_name -- 托管清算路径名称
            ,bond_escrow_opening_bank -- 债券托管开户行
            ,escrow_agency -- 托管机构
            ,bond_acc_ename -- 债券托管账户英文户名
            ,bond_escrow_manage_agency -- 债券托管管理机构
            ,bond_swift_code -- 托管机构SWIFT CODE
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 
    ,nvl(n.bs, o.bs) as bs -- 
    ,nvl(n.cash_acc_ename, o.cash_acc_ename) as cash_acc_ename -- 
    ,nvl(n.cash_acc_cname, o.cash_acc_cname) as cash_acc_cname -- 
    ,nvl(n.cash_acc_bank, o.cash_acc_bank) as cash_acc_bank -- 
    ,nvl(n.cash_acc_no, o.cash_acc_no) as cash_acc_no -- 
    ,nvl(n.cash_acc_bank_ex, o.cash_acc_bank_ex) as cash_acc_bank_ex -- 
    ,nvl(n.bond_acc_name, o.bond_acc_name) as bond_acc_name -- 
    ,nvl(n.bond_acc_bank, o.bond_acc_bank) as bond_acc_bank -- 
    ,nvl(n.bond_acc_no, o.bond_acc_no) as bond_acc_no -- 
    ,nvl(n.g_cash_amt, o.g_cash_amt) as g_cash_amt -- 
    ,nvl(n.g_bond_id, o.g_bond_id) as g_bond_id -- 
    ,nvl(n.g_bond_name, o.g_bond_name) as g_bond_name -- 
    ,nvl(n.g_bond_amt, o.g_bond_amt) as g_bond_amt -- 
    ,nvl(n.g_bond_total_amt, o.g_bond_total_amt) as g_bond_total_amt -- 
    ,nvl(n.g_ca_name, o.g_ca_name) as g_ca_name -- 
    ,nvl(n.g_ca_bank, o.g_ca_bank) as g_ca_bank -- 
    ,nvl(n.g_ca_no, o.g_ca_no) as g_ca_no -- 
    ,nvl(n.g_ca_bank_ex, o.g_ca_bank_ex) as g_ca_bank_ex -- 
    ,nvl(n.g_ba_name, o.g_ba_name) as g_ba_name -- 
    ,nvl(n.g_ba_bank, o.g_ba_bank) as g_ba_bank -- 
    ,nvl(n.g_ba_no, o.g_ba_no) as g_ba_no -- 
    ,nvl(n.g_stl_date, o.g_stl_date) as g_stl_date -- 
    ,nvl(n.g_mgr_bank, o.g_mgr_bank) as g_mgr_bank -- 
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 
    ,nvl(n.settle_instr_name, o.settle_instr_name) as settle_instr_name -- 清算路径名称
    ,nvl(n.swift_code, o.swift_code) as swift_code -- Swift Code编码
    ,nvl(n.bond_owner, o.bond_owner) as bond_owner -- 托管账号开户人
    ,nvl(n.custody_institution_type, o.custody_institution_type) as custody_institution_type -- 托管机构类型
    ,nvl(n.bond_settle_instr_name, o.bond_settle_instr_name) as bond_settle_instr_name -- 托管清算路径名称
    ,nvl(n.bond_escrow_opening_bank, o.bond_escrow_opening_bank) as bond_escrow_opening_bank -- 债券托管开户行
    ,nvl(n.escrow_agency, o.escrow_agency) as escrow_agency -- 托管机构
    ,nvl(n.bond_acc_ename, o.bond_acc_ename) as bond_acc_ename -- 债券托管账户英文户名
    ,nvl(n.bond_escrow_manage_agency, o.bond_escrow_manage_agency) as bond_escrow_manage_agency -- 债券托管管理机构
    ,nvl(n.bond_swift_code, o.bond_swift_code) as bond_swift_code -- 托管机构SWIFT CODE
    ,case when
            n.aspclient_id is null
            and n.serial_number is null
            and n.bs is null
            and n.datasymbol_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.aspclient_id is null
            and n.serial_number is null
            and n.bs is null
            and n.datasymbol_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.aspclient_id is null
            and n.serial_number is null
            and n.bs is null
            and n.datasymbol_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_wtrade_tr_si_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_wtrade_tr_si where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.aspclient_id = n.aspclient_id
            and o.serial_number = n.serial_number
            and o.bs = n.bs
            and o.datasymbol_id = n.datasymbol_id
where (
        o.aspclient_id is null
        and o.serial_number is null
        and o.bs is null
        and o.datasymbol_id is null
    )
    or (
        n.aspclient_id is null
        and n.serial_number is null
        and n.bs is null
        and n.datasymbol_id is null
    )
    or (
        o.cash_acc_ename <> n.cash_acc_ename
        or o.cash_acc_cname <> n.cash_acc_cname
        or o.cash_acc_bank <> n.cash_acc_bank
        or o.cash_acc_no <> n.cash_acc_no
        or o.cash_acc_bank_ex <> n.cash_acc_bank_ex
        or o.bond_acc_name <> n.bond_acc_name
        or o.bond_acc_bank <> n.bond_acc_bank
        or o.bond_acc_no <> n.bond_acc_no
        or o.g_cash_amt <> n.g_cash_amt
        or o.g_bond_id <> n.g_bond_id
        or o.g_bond_name <> n.g_bond_name
        or o.g_bond_amt <> n.g_bond_amt
        or o.g_bond_total_amt <> n.g_bond_total_amt
        or o.g_ca_name <> n.g_ca_name
        or o.g_ca_bank <> n.g_ca_bank
        or o.g_ca_no <> n.g_ca_no
        or o.g_ca_bank_ex <> n.g_ca_bank_ex
        or o.g_ba_name <> n.g_ba_name
        or o.g_ba_bank <> n.g_ba_bank
        or o.g_ba_no <> n.g_ba_no
        or o.g_stl_date <> n.g_stl_date
        or o.g_mgr_bank <> n.g_mgr_bank
        or o.lastmodified <> n.lastmodified
        or o.settle_instr_name <> n.settle_instr_name
        or o.swift_code <> n.swift_code
        or o.bond_owner <> n.bond_owner
        or o.custody_institution_type <> n.custody_institution_type
        or o.bond_settle_instr_name <> n.bond_settle_instr_name
        or o.bond_escrow_opening_bank <> n.bond_escrow_opening_bank
        or o.escrow_agency <> n.escrow_agency
        or o.bond_acc_ename <> n.bond_acc_ename
        or o.bond_escrow_manage_agency <> n.bond_escrow_manage_agency
        or o.bond_swift_code <> n.bond_swift_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_wtrade_tr_si_cl(
            aspclient_id -- 
            ,serial_number -- 
            ,bs -- 
            ,cash_acc_ename -- 
            ,cash_acc_cname -- 
            ,cash_acc_bank -- 
            ,cash_acc_no -- 
            ,cash_acc_bank_ex -- 
            ,bond_acc_name -- 
            ,bond_acc_bank -- 
            ,bond_acc_no -- 
            ,g_cash_amt -- 
            ,g_bond_id -- 
            ,g_bond_name -- 
            ,g_bond_amt -- 
            ,g_bond_total_amt -- 
            ,g_ca_name -- 
            ,g_ca_bank -- 
            ,g_ca_no -- 
            ,g_ca_bank_ex -- 
            ,g_ba_name -- 
            ,g_ba_bank -- 
            ,g_ba_no -- 
            ,g_stl_date -- 
            ,g_mgr_bank -- 
            ,lastmodified -- 
            ,datasymbol_id -- 
            ,settle_instr_name -- 清算路径名称
            ,swift_code -- Swift Code编码
            ,bond_owner -- 托管账号开户人
            ,custody_institution_type -- 托管机构类型
            ,bond_settle_instr_name -- 托管清算路径名称
            ,bond_escrow_opening_bank -- 债券托管开户行
            ,escrow_agency -- 托管机构
            ,bond_acc_ename -- 债券托管账户英文户名
            ,bond_escrow_manage_agency -- 债券托管管理机构
            ,bond_swift_code -- 托管机构SWIFT CODE
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_wtrade_tr_si_op(
            aspclient_id -- 
            ,serial_number -- 
            ,bs -- 
            ,cash_acc_ename -- 
            ,cash_acc_cname -- 
            ,cash_acc_bank -- 
            ,cash_acc_no -- 
            ,cash_acc_bank_ex -- 
            ,bond_acc_name -- 
            ,bond_acc_bank -- 
            ,bond_acc_no -- 
            ,g_cash_amt -- 
            ,g_bond_id -- 
            ,g_bond_name -- 
            ,g_bond_amt -- 
            ,g_bond_total_amt -- 
            ,g_ca_name -- 
            ,g_ca_bank -- 
            ,g_ca_no -- 
            ,g_ca_bank_ex -- 
            ,g_ba_name -- 
            ,g_ba_bank -- 
            ,g_ba_no -- 
            ,g_stl_date -- 
            ,g_mgr_bank -- 
            ,lastmodified -- 
            ,datasymbol_id -- 
            ,settle_instr_name -- 清算路径名称
            ,swift_code -- Swift Code编码
            ,bond_owner -- 托管账号开户人
            ,custody_institution_type -- 托管机构类型
            ,bond_settle_instr_name -- 托管清算路径名称
            ,bond_escrow_opening_bank -- 债券托管开户行
            ,escrow_agency -- 托管机构
            ,bond_acc_ename -- 债券托管账户英文户名
            ,bond_escrow_manage_agency -- 债券托管管理机构
            ,bond_swift_code -- 托管机构SWIFT CODE
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.aspclient_id -- 
    ,o.serial_number -- 
    ,o.bs -- 
    ,o.cash_acc_ename -- 
    ,o.cash_acc_cname -- 
    ,o.cash_acc_bank -- 
    ,o.cash_acc_no -- 
    ,o.cash_acc_bank_ex -- 
    ,o.bond_acc_name -- 
    ,o.bond_acc_bank -- 
    ,o.bond_acc_no -- 
    ,o.g_cash_amt -- 
    ,o.g_bond_id -- 
    ,o.g_bond_name -- 
    ,o.g_bond_amt -- 
    ,o.g_bond_total_amt -- 
    ,o.g_ca_name -- 
    ,o.g_ca_bank -- 
    ,o.g_ca_no -- 
    ,o.g_ca_bank_ex -- 
    ,o.g_ba_name -- 
    ,o.g_ba_bank -- 
    ,o.g_ba_no -- 
    ,o.g_stl_date -- 
    ,o.g_mgr_bank -- 
    ,o.lastmodified -- 
    ,o.datasymbol_id -- 
    ,o.settle_instr_name -- 清算路径名称
    ,o.swift_code -- Swift Code编码
    ,o.bond_owner -- 托管账号开户人
    ,o.custody_institution_type -- 托管机构类型
    ,o.bond_settle_instr_name -- 托管清算路径名称
    ,o.bond_escrow_opening_bank -- 债券托管开户行
    ,o.escrow_agency -- 托管机构
    ,o.bond_acc_ename -- 债券托管账户英文户名
    ,o.bond_escrow_manage_agency -- 债券托管管理机构
    ,o.bond_swift_code -- 托管机构SWIFT CODE
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
from ${iol_schema}.ctms_wtrade_tr_si_bk o
    left join ${iol_schema}.ctms_wtrade_tr_si_op n
        on
            o.aspclient_id = n.aspclient_id
            and o.serial_number = n.serial_number
            and o.bs = n.bs
            and o.datasymbol_id = n.datasymbol_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_wtrade_tr_si_cl d
        on
            o.aspclient_id = d.aspclient_id
            and o.serial_number = d.serial_number
            and o.bs = d.bs
            and o.datasymbol_id = d.datasymbol_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_wtrade_tr_si;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_wtrade_tr_si') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_wtrade_tr_si drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_wtrade_tr_si add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_wtrade_tr_si exchange partition p_${batch_date} with table ${iol_schema}.ctms_wtrade_tr_si_cl;
alter table ${iol_schema}.ctms_wtrade_tr_si exchange partition p_20991231 with table ${iol_schema}.ctms_wtrade_tr_si_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_wtrade_tr_si to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_wtrade_tr_si_op purge;
drop table ${iol_schema}.ctms_wtrade_tr_si_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_wtrade_tr_si_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_wtrade_tr_si',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
