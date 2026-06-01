/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_inv_invoice_type
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
create table ${iol_schema}.iers_inv_invoice_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_inv_invoice_type
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_inv_invoice_type_op purge;
drop table ${iol_schema}.iers_inv_invoice_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_inv_invoice_type_op nologging
for exchange with table
${iol_schema}.iers_inv_invoice_type;

create table ${iol_schema}.iers_inv_invoice_type_cl nologging
for exchange with table
${iol_schema}.iers_inv_invoice_type;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_inv_invoice_type_cl(
            pk_inv_invoice_type -- 
            ,code -- 发票编码
            ,name -- 发票名称
            ,category -- 发票所属类目;0:餐饮;1:交通;2:住宿
            ,e_flag -- 是否电子发票;0:不是;1:是
            ,vat_flag -- 是否增值税发票;0:不是;1:是
            ,special_flag -- 是否专票;0:普票;1:专票
            ,dr -- 是否删除;0:否;1:是
            ,revision -- 乐观锁
            ,create_user -- 创建人
            ,create_time -- 创建时间
            ,last_modified_user -- 更新人
            ,last_modified_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_inv_invoice_type_op(
            pk_inv_invoice_type -- 
            ,code -- 发票编码
            ,name -- 发票名称
            ,category -- 发票所属类目;0:餐饮;1:交通;2:住宿
            ,e_flag -- 是否电子发票;0:不是;1:是
            ,vat_flag -- 是否增值税发票;0:不是;1:是
            ,special_flag -- 是否专票;0:普票;1:专票
            ,dr -- 是否删除;0:否;1:是
            ,revision -- 乐观锁
            ,create_user -- 创建人
            ,create_time -- 创建时间
            ,last_modified_user -- 更新人
            ,last_modified_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_inv_invoice_type, o.pk_inv_invoice_type) as pk_inv_invoice_type -- 
    ,nvl(n.code, o.code) as code -- 发票编码
    ,nvl(n.name, o.name) as name -- 发票名称
    ,nvl(n.category, o.category) as category -- 发票所属类目;0:餐饮;1:交通;2:住宿
    ,nvl(n.e_flag, o.e_flag) as e_flag -- 是否电子发票;0:不是;1:是
    ,nvl(n.vat_flag, o.vat_flag) as vat_flag -- 是否增值税发票;0:不是;1:是
    ,nvl(n.special_flag, o.special_flag) as special_flag -- 是否专票;0:普票;1:专票
    ,nvl(n.dr, o.dr) as dr -- 是否删除;0:否;1:是
    ,nvl(n.revision, o.revision) as revision -- 乐观锁
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.last_modified_user, o.last_modified_user) as last_modified_user -- 更新人
    ,nvl(n.last_modified_time, o.last_modified_time) as last_modified_time -- 更新时间
    ,case when
            n.pk_inv_invoice_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_inv_invoice_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_inv_invoice_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_inv_invoice_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_inv_invoice_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_inv_invoice_type = n.pk_inv_invoice_type
where (
        o.pk_inv_invoice_type is null
    )
    or (
        n.pk_inv_invoice_type is null
    )
    or (
        o.code <> n.code
        or o.name <> n.name
        or o.category <> n.category
        or o.e_flag <> n.e_flag
        or o.vat_flag <> n.vat_flag
        or o.special_flag <> n.special_flag
        or o.dr <> n.dr
        or o.revision <> n.revision
        or o.create_user <> n.create_user
        or o.create_time <> n.create_time
        or o.last_modified_user <> n.last_modified_user
        or o.last_modified_time <> n.last_modified_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_inv_invoice_type_cl(
            pk_inv_invoice_type -- 
            ,code -- 发票编码
            ,name -- 发票名称
            ,category -- 发票所属类目;0:餐饮;1:交通;2:住宿
            ,e_flag -- 是否电子发票;0:不是;1:是
            ,vat_flag -- 是否增值税发票;0:不是;1:是
            ,special_flag -- 是否专票;0:普票;1:专票
            ,dr -- 是否删除;0:否;1:是
            ,revision -- 乐观锁
            ,create_user -- 创建人
            ,create_time -- 创建时间
            ,last_modified_user -- 更新人
            ,last_modified_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_inv_invoice_type_op(
            pk_inv_invoice_type -- 
            ,code -- 发票编码
            ,name -- 发票名称
            ,category -- 发票所属类目;0:餐饮;1:交通;2:住宿
            ,e_flag -- 是否电子发票;0:不是;1:是
            ,vat_flag -- 是否增值税发票;0:不是;1:是
            ,special_flag -- 是否专票;0:普票;1:专票
            ,dr -- 是否删除;0:否;1:是
            ,revision -- 乐观锁
            ,create_user -- 创建人
            ,create_time -- 创建时间
            ,last_modified_user -- 更新人
            ,last_modified_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_inv_invoice_type -- 
    ,o.code -- 发票编码
    ,o.name -- 发票名称
    ,o.category -- 发票所属类目;0:餐饮;1:交通;2:住宿
    ,o.e_flag -- 是否电子发票;0:不是;1:是
    ,o.vat_flag -- 是否增值税发票;0:不是;1:是
    ,o.special_flag -- 是否专票;0:普票;1:专票
    ,o.dr -- 是否删除;0:否;1:是
    ,o.revision -- 乐观锁
    ,o.create_user -- 创建人
    ,o.create_time -- 创建时间
    ,o.last_modified_user -- 更新人
    ,o.last_modified_time -- 更新时间
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
from ${iol_schema}.iers_inv_invoice_type_bk o
    left join ${iol_schema}.iers_inv_invoice_type_op n
        on
            o.pk_inv_invoice_type = n.pk_inv_invoice_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_inv_invoice_type_cl d
        on
            o.pk_inv_invoice_type = d.pk_inv_invoice_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_inv_invoice_type;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_inv_invoice_type') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_inv_invoice_type drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_inv_invoice_type add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_inv_invoice_type exchange partition p_${batch_date} with table ${iol_schema}.iers_inv_invoice_type_cl;
alter table ${iol_schema}.iers_inv_invoice_type exchange partition p_20991231 with table ${iol_schema}.iers_inv_invoice_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_inv_invoice_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_inv_invoice_type_op purge;
drop table ${iol_schema}.iers_inv_invoice_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_inv_invoice_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_inv_invoice_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
