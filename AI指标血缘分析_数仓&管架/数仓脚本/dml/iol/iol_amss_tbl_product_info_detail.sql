/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_tbl_product_info_detail
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
create table ${iol_schema}.amss_tbl_product_info_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_tbl_product_info_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_tbl_product_info_detail_op purge;
drop table ${iol_schema}.amss_tbl_product_info_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_tbl_product_info_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_tbl_product_info_detail where 0=1;

create table ${iol_schema}.amss_tbl_product_info_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_tbl_product_info_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_tbl_product_info_detail_cl(
            id -- 
            ,product_no -- 
            ,product_nm -- 
            ,product_brand -- 
            ,supplier_nm -- 
            ,product_type -- 
            ,product_sort -- 
            ,product_serial_no -- 
            ,product_quality -- 
            ,percent_gold -- 
            ,percent_silver -- 
            ,product_material -- 
            ,product_technology -- 
            ,weight_unit -- 
            ,weight -- 
            ,product_size -- 
            ,product_unit_price -- 
            ,product_num -- 
            ,product_charge -- 
            ,sale_limited_num -- 
            ,product_status -- 
            ,onsale_time -- 
            ,offshelves_time -- 
            ,create_time -- 
            ,update_time -- 
            ,adddata1 -- 
            ,adddata2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_tbl_product_info_detail_op(
            id -- 
            ,product_no -- 
            ,product_nm -- 
            ,product_brand -- 
            ,supplier_nm -- 
            ,product_type -- 
            ,product_sort -- 
            ,product_serial_no -- 
            ,product_quality -- 
            ,percent_gold -- 
            ,percent_silver -- 
            ,product_material -- 
            ,product_technology -- 
            ,weight_unit -- 
            ,weight -- 
            ,product_size -- 
            ,product_unit_price -- 
            ,product_num -- 
            ,product_charge -- 
            ,sale_limited_num -- 
            ,product_status -- 
            ,onsale_time -- 
            ,offshelves_time -- 
            ,create_time -- 
            ,update_time -- 
            ,adddata1 -- 
            ,adddata2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.product_no, o.product_no) as product_no -- 
    ,nvl(n.product_nm, o.product_nm) as product_nm -- 
    ,nvl(n.product_brand, o.product_brand) as product_brand -- 
    ,nvl(n.supplier_nm, o.supplier_nm) as supplier_nm -- 
    ,nvl(n.product_type, o.product_type) as product_type -- 
    ,nvl(n.product_sort, o.product_sort) as product_sort -- 
    ,nvl(n.product_serial_no, o.product_serial_no) as product_serial_no -- 
    ,nvl(n.product_quality, o.product_quality) as product_quality -- 
    ,nvl(n.percent_gold, o.percent_gold) as percent_gold -- 
    ,nvl(n.percent_silver, o.percent_silver) as percent_silver -- 
    ,nvl(n.product_material, o.product_material) as product_material -- 
    ,nvl(n.product_technology, o.product_technology) as product_technology -- 
    ,nvl(n.weight_unit, o.weight_unit) as weight_unit -- 
    ,nvl(n.weight, o.weight) as weight -- 
    ,nvl(n.product_size, o.product_size) as product_size -- 
    ,nvl(n.product_unit_price, o.product_unit_price) as product_unit_price -- 
    ,nvl(n.product_num, o.product_num) as product_num -- 
    ,nvl(n.product_charge, o.product_charge) as product_charge -- 
    ,nvl(n.sale_limited_num, o.sale_limited_num) as sale_limited_num -- 
    ,nvl(n.product_status, o.product_status) as product_status -- 
    ,nvl(n.onsale_time, o.onsale_time) as onsale_time -- 
    ,nvl(n.offshelves_time, o.offshelves_time) as offshelves_time -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.adddata1, o.adddata1) as adddata1 -- 
    ,nvl(n.adddata2, o.adddata2) as adddata2 -- 
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
from (select * from ${iol_schema}.amss_tbl_product_info_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_tbl_product_info_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.product_no <> n.product_no
        or o.product_nm <> n.product_nm
        or o.product_brand <> n.product_brand
        or o.supplier_nm <> n.supplier_nm
        or o.product_type <> n.product_type
        or o.product_sort <> n.product_sort
        or o.product_serial_no <> n.product_serial_no
        or o.product_quality <> n.product_quality
        or o.percent_gold <> n.percent_gold
        or o.percent_silver <> n.percent_silver
        or o.product_material <> n.product_material
        or o.product_technology <> n.product_technology
        or o.weight_unit <> n.weight_unit
        or o.weight <> n.weight
        or o.product_size <> n.product_size
        or o.product_unit_price <> n.product_unit_price
        or o.product_num <> n.product_num
        or o.product_charge <> n.product_charge
        or o.sale_limited_num <> n.sale_limited_num
        or o.product_status <> n.product_status
        or o.onsale_time <> n.onsale_time
        or o.offshelves_time <> n.offshelves_time
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.adddata1 <> n.adddata1
        or o.adddata2 <> n.adddata2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_tbl_product_info_detail_cl(
            id -- 
            ,product_no -- 
            ,product_nm -- 
            ,product_brand -- 
            ,supplier_nm -- 
            ,product_type -- 
            ,product_sort -- 
            ,product_serial_no -- 
            ,product_quality -- 
            ,percent_gold -- 
            ,percent_silver -- 
            ,product_material -- 
            ,product_technology -- 
            ,weight_unit -- 
            ,weight -- 
            ,product_size -- 
            ,product_unit_price -- 
            ,product_num -- 
            ,product_charge -- 
            ,sale_limited_num -- 
            ,product_status -- 
            ,onsale_time -- 
            ,offshelves_time -- 
            ,create_time -- 
            ,update_time -- 
            ,adddata1 -- 
            ,adddata2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_tbl_product_info_detail_op(
            id -- 
            ,product_no -- 
            ,product_nm -- 
            ,product_brand -- 
            ,supplier_nm -- 
            ,product_type -- 
            ,product_sort -- 
            ,product_serial_no -- 
            ,product_quality -- 
            ,percent_gold -- 
            ,percent_silver -- 
            ,product_material -- 
            ,product_technology -- 
            ,weight_unit -- 
            ,weight -- 
            ,product_size -- 
            ,product_unit_price -- 
            ,product_num -- 
            ,product_charge -- 
            ,sale_limited_num -- 
            ,product_status -- 
            ,onsale_time -- 
            ,offshelves_time -- 
            ,create_time -- 
            ,update_time -- 
            ,adddata1 -- 
            ,adddata2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.product_no -- 
    ,o.product_nm -- 
    ,o.product_brand -- 
    ,o.supplier_nm -- 
    ,o.product_type -- 
    ,o.product_sort -- 
    ,o.product_serial_no -- 
    ,o.product_quality -- 
    ,o.percent_gold -- 
    ,o.percent_silver -- 
    ,o.product_material -- 
    ,o.product_technology -- 
    ,o.weight_unit -- 
    ,o.weight -- 
    ,o.product_size -- 
    ,o.product_unit_price -- 
    ,o.product_num -- 
    ,o.product_charge -- 
    ,o.sale_limited_num -- 
    ,o.product_status -- 
    ,o.onsale_time -- 
    ,o.offshelves_time -- 
    ,o.create_time -- 
    ,o.update_time -- 
    ,o.adddata1 -- 
    ,o.adddata2 -- 
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
from ${iol_schema}.amss_tbl_product_info_detail_bk o
    left join ${iol_schema}.amss_tbl_product_info_detail_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_tbl_product_info_detail_cl d
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
--truncate table ${iol_schema}.amss_tbl_product_info_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_tbl_product_info_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_tbl_product_info_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_tbl_product_info_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_tbl_product_info_detail exchange partition p_${batch_date} with table ${iol_schema}.amss_tbl_product_info_detail_cl;
alter table ${iol_schema}.amss_tbl_product_info_detail exchange partition p_20991231 with table ${iol_schema}.amss_tbl_product_info_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_tbl_product_info_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_tbl_product_info_detail_op purge;
drop table ${iol_schema}.amss_tbl_product_info_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_tbl_product_info_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_tbl_product_info_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
