/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_blank_voucher_details
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
create table ${iol_schema}.bdms_bms_blank_voucher_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_blank_voucher_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_blank_voucher_details_op purge;
drop table ${iol_schema}.bdms_bms_blank_voucher_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_blank_voucher_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_blank_voucher_details where 0=1;

create table ${iol_schema}.bdms_bms_blank_voucher_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_blank_voucher_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_blank_voucher_details_cl(
            id -- ID
            ,batch_id -- 批次ID
            ,draft_no1 -- 票据1
            ,draft_no2 -- 票据2
            ,draft_number -- 票号
            ,voucher_state -- 凭证状态： 0 已领用 1 已分配 2 已使用 3 已作废
            ,operator_no -- 操作人
            ,branch_no -- 机构号
            ,bank_no -- 行号
            ,voucher_type -- 凭证种类
            ,print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
            ,reserved_no -- 预留号
            ,area_code -- 省别地区代码
            ,print_id_code -- 印制识别码
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,misc -- MISC
            ,last_upd_oper_no -- 最后修改人编号
            ,take_time -- 领用时间
            ,draft_type -- 票据种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_blank_voucher_details_op(
            id -- ID
            ,batch_id -- 批次ID
            ,draft_no1 -- 票据1
            ,draft_no2 -- 票据2
            ,draft_number -- 票号
            ,voucher_state -- 凭证状态： 0 已领用 1 已分配 2 已使用 3 已作废
            ,operator_no -- 操作人
            ,branch_no -- 机构号
            ,bank_no -- 行号
            ,voucher_type -- 凭证种类
            ,print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
            ,reserved_no -- 预留号
            ,area_code -- 省别地区代码
            ,print_id_code -- 印制识别码
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,misc -- MISC
            ,last_upd_oper_no -- 最后修改人编号
            ,take_time -- 领用时间
            ,draft_type -- 票据种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次ID
    ,nvl(n.draft_no1, o.draft_no1) as draft_no1 -- 票据1
    ,nvl(n.draft_no2, o.draft_no2) as draft_no2 -- 票据2
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票号
    ,nvl(n.voucher_state, o.voucher_state) as voucher_state -- 凭证状态： 0 已领用 1 已分配 2 已使用 3 已作废
    ,nvl(n.operator_no, o.operator_no) as operator_no -- 操作人
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 行号
    ,nvl(n.voucher_type, o.voucher_type) as voucher_type -- 凭证种类
    ,nvl(n.print_flag, o.print_flag) as print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
    ,nvl(n.reserved_no, o.reserved_no) as reserved_no -- 预留号
    ,nvl(n.area_code, o.area_code) as area_code -- 省别地区代码
    ,nvl(n.print_id_code, o.print_id_code) as print_id_code -- 印制识别码
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.misc, o.misc) as misc -- MISC
    ,nvl(n.last_upd_oper_no, o.last_upd_oper_no) as last_upd_oper_no -- 最后修改人编号
    ,nvl(n.take_time, o.take_time) as take_time -- 领用时间
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据种类
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_blank_voucher_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_blank_voucher_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.batch_id <> n.batch_id
        or o.draft_no1 <> n.draft_no1
        or o.draft_no2 <> n.draft_no2
        or o.draft_number <> n.draft_number
        or o.voucher_state <> n.voucher_state
        or o.operator_no <> n.operator_no
        or o.branch_no <> n.branch_no
        or o.bank_no <> n.bank_no
        or o.voucher_type <> n.voucher_type
        or o.print_flag <> n.print_flag
        or o.reserved_no <> n.reserved_no
        or o.area_code <> n.area_code
        or o.print_id_code <> n.print_id_code
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.misc <> n.misc
        or o.last_upd_oper_no <> n.last_upd_oper_no
        or o.take_time <> n.take_time
        or o.draft_type <> n.draft_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_blank_voucher_details_cl(
            id -- ID
            ,batch_id -- 批次ID
            ,draft_no1 -- 票据1
            ,draft_no2 -- 票据2
            ,draft_number -- 票号
            ,voucher_state -- 凭证状态： 0 已领用 1 已分配 2 已使用 3 已作废
            ,operator_no -- 操作人
            ,branch_no -- 机构号
            ,bank_no -- 行号
            ,voucher_type -- 凭证种类
            ,print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
            ,reserved_no -- 预留号
            ,area_code -- 省别地区代码
            ,print_id_code -- 印制识别码
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,misc -- MISC
            ,last_upd_oper_no -- 最后修改人编号
            ,take_time -- 领用时间
            ,draft_type -- 票据种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_blank_voucher_details_op(
            id -- ID
            ,batch_id -- 批次ID
            ,draft_no1 -- 票据1
            ,draft_no2 -- 票据2
            ,draft_number -- 票号
            ,voucher_state -- 凭证状态： 0 已领用 1 已分配 2 已使用 3 已作废
            ,operator_no -- 操作人
            ,branch_no -- 机构号
            ,bank_no -- 行号
            ,voucher_type -- 凭证种类
            ,print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
            ,reserved_no -- 预留号
            ,area_code -- 省别地区代码
            ,print_id_code -- 印制识别码
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,misc -- MISC
            ,last_upd_oper_no -- 最后修改人编号
            ,take_time -- 领用时间
            ,draft_type -- 票据种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.batch_id -- 批次ID
    ,o.draft_no1 -- 票据1
    ,o.draft_no2 -- 票据2
    ,o.draft_number -- 票号
    ,o.voucher_state -- 凭证状态： 0 已领用 1 已分配 2 已使用 3 已作废
    ,o.operator_no -- 操作人
    ,o.branch_no -- 机构号
    ,o.bank_no -- 行号
    ,o.voucher_type -- 凭证种类
    ,o.print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
    ,o.reserved_no -- 预留号
    ,o.area_code -- 省别地区代码
    ,o.print_id_code -- 印制识别码
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.misc -- MISC
    ,o.last_upd_oper_no -- 最后修改人编号
    ,o.take_time -- 领用时间
    ,o.draft_type -- 票据种类
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
from ${iol_schema}.bdms_bms_blank_voucher_details_bk o
    left join ${iol_schema}.bdms_bms_blank_voucher_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_blank_voucher_details_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_blank_voucher_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_blank_voucher_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_blank_voucher_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_blank_voucher_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_blank_voucher_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_blank_voucher_details_cl;
alter table ${iol_schema}.bdms_bms_blank_voucher_details exchange partition p_20991231 with table ${iol_schema}.bdms_bms_blank_voucher_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_blank_voucher_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_blank_voucher_details_op purge;
drop table ${iol_schema}.bdms_bms_blank_voucher_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_blank_voucher_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_blank_voucher_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
