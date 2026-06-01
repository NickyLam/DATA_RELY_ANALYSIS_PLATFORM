/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_irvs_ft_orderform
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
create table ${iol_schema}.irvs_ft_orderform_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.irvs_ft_orderform
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.irvs_ft_orderform_op purge;
drop table ${iol_schema}.irvs_ft_orderform_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.irvs_ft_orderform_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.irvs_ft_orderform where 0=1;

create table ${iol_schema}.irvs_ft_orderform_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.irvs_ft_orderform where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.irvs_ft_orderform_cl(
            order_id -- 
            ,order_no -- 
            ,product_id -- 
            ,ecif_no -- 
            ,pay_amount -- 
            ,pay_status -- 
            ,channel -- 
            ,pay_accno -- 
            ,pay_time -- 
            ,custodian_bank_name -- 
            ,custodian_bank_accname -- 
            ,custodian_bank_accno -- 
            ,customer_manager_no -- 
            ,bank_ext_num -- 
            ,sort_field -- 
            ,is_push -- 
            ,created_by -- 
            ,updated_by -- 
            ,create_time -- 
            ,update_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.irvs_ft_orderform_op(
            order_id -- 
            ,order_no -- 
            ,product_id -- 
            ,ecif_no -- 
            ,pay_amount -- 
            ,pay_status -- 
            ,channel -- 
            ,pay_accno -- 
            ,pay_time -- 
            ,custodian_bank_name -- 
            ,custodian_bank_accname -- 
            ,custodian_bank_accno -- 
            ,customer_manager_no -- 
            ,bank_ext_num -- 
            ,sort_field -- 
            ,is_push -- 
            ,created_by -- 
            ,updated_by -- 
            ,create_time -- 
            ,update_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.order_id, o.order_id) as order_id -- 
    ,nvl(n.order_no, o.order_no) as order_no -- 
    ,nvl(n.product_id, o.product_id) as product_id -- 
    ,nvl(n.ecif_no, o.ecif_no) as ecif_no -- 
    ,nvl(n.pay_amount, o.pay_amount) as pay_amount -- 
    ,nvl(n.pay_status, o.pay_status) as pay_status -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.pay_accno, o.pay_accno) as pay_accno -- 
    ,nvl(n.pay_time, o.pay_time) as pay_time -- 
    ,nvl(n.custodian_bank_name, o.custodian_bank_name) as custodian_bank_name -- 
    ,nvl(n.custodian_bank_accname, o.custodian_bank_accname) as custodian_bank_accname -- 
    ,nvl(n.custodian_bank_accno, o.custodian_bank_accno) as custodian_bank_accno -- 
    ,nvl(n.customer_manager_no, o.customer_manager_no) as customer_manager_no -- 
    ,nvl(n.bank_ext_num, o.bank_ext_num) as bank_ext_num -- 
    ,nvl(n.sort_field, o.sort_field) as sort_field -- 
    ,nvl(n.is_push, o.is_push) as is_push -- 
    ,nvl(n.created_by, o.created_by) as created_by -- 
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,case when
            n.order_id is null
            and n.product_id is null
            and n.ecif_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.order_id is null
            and n.product_id is null
            and n.ecif_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.order_id is null
            and n.product_id is null
            and n.ecif_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.irvs_ft_orderform_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.irvs_ft_orderform where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.order_id = n.order_id
            and o.product_id = n.product_id
            and o.ecif_no = n.ecif_no
where (
        o.order_id is null
        and o.product_id is null
        and o.ecif_no is null
    )
    or (
        n.order_id is null
        and n.product_id is null
        and n.ecif_no is null
    )
    or (
        o.order_no <> n.order_no
        or o.pay_amount <> n.pay_amount
        or o.pay_status <> n.pay_status
        or o.channel <> n.channel
        or o.pay_accno <> n.pay_accno
        or o.pay_time <> n.pay_time
        or o.custodian_bank_name <> n.custodian_bank_name
        or o.custodian_bank_accname <> n.custodian_bank_accname
        or o.custodian_bank_accno <> n.custodian_bank_accno
        or o.customer_manager_no <> n.customer_manager_no
        or o.bank_ext_num <> n.bank_ext_num
        or o.sort_field <> n.sort_field
        or o.is_push <> n.is_push
        or o.created_by <> n.created_by
        or o.updated_by <> n.updated_by
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.irvs_ft_orderform_cl(
            order_id -- 
            ,order_no -- 
            ,product_id -- 
            ,ecif_no -- 
            ,pay_amount -- 
            ,pay_status -- 
            ,channel -- 
            ,pay_accno -- 
            ,pay_time -- 
            ,custodian_bank_name -- 
            ,custodian_bank_accname -- 
            ,custodian_bank_accno -- 
            ,customer_manager_no -- 
            ,bank_ext_num -- 
            ,sort_field -- 
            ,is_push -- 
            ,created_by -- 
            ,updated_by -- 
            ,create_time -- 
            ,update_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.irvs_ft_orderform_op(
            order_id -- 
            ,order_no -- 
            ,product_id -- 
            ,ecif_no -- 
            ,pay_amount -- 
            ,pay_status -- 
            ,channel -- 
            ,pay_accno -- 
            ,pay_time -- 
            ,custodian_bank_name -- 
            ,custodian_bank_accname -- 
            ,custodian_bank_accno -- 
            ,customer_manager_no -- 
            ,bank_ext_num -- 
            ,sort_field -- 
            ,is_push -- 
            ,created_by -- 
            ,updated_by -- 
            ,create_time -- 
            ,update_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.order_id -- 
    ,o.order_no -- 
    ,o.product_id -- 
    ,o.ecif_no -- 
    ,o.pay_amount -- 
    ,o.pay_status -- 
    ,o.channel -- 
    ,o.pay_accno -- 
    ,o.pay_time -- 
    ,o.custodian_bank_name -- 
    ,o.custodian_bank_accname -- 
    ,o.custodian_bank_accno -- 
    ,o.customer_manager_no -- 
    ,o.bank_ext_num -- 
    ,o.sort_field -- 
    ,o.is_push -- 
    ,o.created_by -- 
    ,o.updated_by -- 
    ,o.create_time -- 
    ,o.update_time -- 
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
from ${iol_schema}.irvs_ft_orderform_bk o
    left join ${iol_schema}.irvs_ft_orderform_op n
        on
            o.order_id = n.order_id
            and o.product_id = n.product_id
            and o.ecif_no = n.ecif_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.irvs_ft_orderform_cl d
        on
            o.order_id = d.order_id
            and o.product_id = d.product_id
            and o.ecif_no = d.ecif_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.irvs_ft_orderform;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('irvs_ft_orderform') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.irvs_ft_orderform drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.irvs_ft_orderform add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.irvs_ft_orderform exchange partition p_${batch_date} with table ${iol_schema}.irvs_ft_orderform_cl;
alter table ${iol_schema}.irvs_ft_orderform exchange partition p_20991231 with table ${iol_schema}.irvs_ft_orderform_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.irvs_ft_orderform to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.irvs_ft_orderform_op purge;
drop table ${iol_schema}.irvs_ft_orderform_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.irvs_ft_orderform_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'irvs_ft_orderform',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
