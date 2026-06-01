/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_product_pledge
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
create table ${iol_schema}.fams_fin_product_pledge_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_product_pledge
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_product_pledge_op purge;
drop table ${iol_schema}.fams_fin_product_pledge_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product_pledge_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_product_pledge where 0=1;

create table ${iol_schema}.fams_fin_product_pledge_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_product_pledge where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_product_pledge_cl(
            id -- 主键
            ,finprod_id -- 金融产品代码(关联FIN_PRODUCT)
            ,pledge_type -- 抵质押物类型
            ,pledge_id -- 抵质押物账号（抵质押合同号）
            ,pledge_amt -- 抵质押物金额（估值）
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,val_date -- 估值日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_product_pledge_op(
            id -- 主键
            ,finprod_id -- 金融产品代码(关联FIN_PRODUCT)
            ,pledge_type -- 抵质押物类型
            ,pledge_id -- 抵质押物账号（抵质押合同号）
            ,pledge_amt -- 抵质押物金额（估值）
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,val_date -- 估值日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码(关联FIN_PRODUCT)
    ,nvl(n.pledge_type, o.pledge_type) as pledge_type -- 抵质押物类型
    ,nvl(n.pledge_id, o.pledge_id) as pledge_id -- 抵质押物账号（抵质押合同号）
    ,nvl(n.pledge_amt, o.pledge_amt) as pledge_amt -- 抵质押物金额（估值）
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.val_date, o.val_date) as val_date -- 估值日期
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
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
from (select * from ${iol_schema}.fams_fin_product_pledge_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_product_pledge where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.finprod_id <> n.finprod_id
        or o.pledge_type <> n.pledge_type
        or o.pledge_id <> n.pledge_id
        or o.pledge_amt <> n.pledge_amt
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.val_date <> n.val_date
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_product_pledge_cl(
            id -- 主键
            ,finprod_id -- 金融产品代码(关联FIN_PRODUCT)
            ,pledge_type -- 抵质押物类型
            ,pledge_id -- 抵质押物账号（抵质押合同号）
            ,pledge_amt -- 抵质押物金额（估值）
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,val_date -- 估值日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_product_pledge_op(
            id -- 主键
            ,finprod_id -- 金融产品代码(关联FIN_PRODUCT)
            ,pledge_type -- 抵质押物类型
            ,pledge_id -- 抵质押物账号（抵质押合同号）
            ,pledge_amt -- 抵质押物金额（估值）
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,val_date -- 估值日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.finprod_id -- 金融产品代码(关联FIN_PRODUCT)
    ,o.pledge_type -- 抵质押物类型
    ,o.pledge_id -- 抵质押物账号（抵质押合同号）
    ,o.pledge_amt -- 抵质押物金额（估值）
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.val_date -- 估值日期
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
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
from ${iol_schema}.fams_fin_product_pledge_bk o
    left join ${iol_schema}.fams_fin_product_pledge_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_product_pledge_cl d
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
--truncate table ${iol_schema}.fams_fin_product_pledge;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_fin_product_pledge') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_fin_product_pledge drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_fin_product_pledge add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_fin_product_pledge exchange partition p_${batch_date} with table ${iol_schema}.fams_fin_product_pledge_cl;
alter table ${iol_schema}.fams_fin_product_pledge exchange partition p_20991231 with table ${iol_schema}.fams_fin_product_pledge_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_product_pledge to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_product_pledge_op purge;
drop table ${iol_schema}.fams_fin_product_pledge_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_product_pledge_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_product_pledge',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
