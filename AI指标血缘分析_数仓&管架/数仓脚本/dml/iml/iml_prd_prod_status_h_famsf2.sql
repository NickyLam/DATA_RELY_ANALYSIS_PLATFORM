/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_prod_status_h_famsf2
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_prod_status_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_prod_status_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_status_h partition for ('famsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_prod_status_h_famsf2_tm purge;
drop table ${iml_schema}.prd_prod_status_h_famsf2_op purge;
drop table ${iml_schema}.prd_prod_status_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_status_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_status_type_cd -- 产品状态类型代码
    ,prod_status_cd -- 产品状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_status_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.prd_prod_status_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_status_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.prd_prod_status_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_status_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_fin_product_add-1
insert into ${iml_schema}.prd_prod_status_h_famsf2_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_status_type_cd -- 产品状态类型代码
    ,prod_status_cd -- 产品状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223002'||P1.FINPROD_ID -- 产品编号
    ,'9999' -- 法人编号
    ,'004' -- 产品状态类型代码
    ,NVL(TRIM(P1.ISSUE_STATUS),'00') -- 产品状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_product_add' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_product_add p1
    inner join ${iol_schema}.fams_fin_product p2 on p1.finprod_id=p2.finprod_id 
 and P2.FINPROD_TYPE2 in ('F16','F24','F26') 
 and P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND  P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_prod_status_h_famsf2_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_status_type_cd -- 产品状态类型代码
    ,prod_status_cd -- 产品状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_prod_status_h_famsf2_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_status_type_cd -- 产品状态类型代码
    ,prod_status_cd -- 产品状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_status_type_cd, o.prod_status_type_cd) as prod_status_type_cd -- 产品状态类型代码
    ,nvl(n.prod_status_cd, o.prod_status_cd) as prod_status_cd -- 产品状态代码
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.prod_status_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.prod_status_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.prod_status_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_status_h_famsf2_tm n
    full join (select * from ${iml_schema}.prd_prod_status_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.prod_status_type_cd = n.prod_status_type_cd
where (
        o.prod_id is null
        and o.lp_id is null
        and o.prod_status_type_cd is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
        and n.prod_status_type_cd is null
    )
    or (
        o.prod_status_cd <> n.prod_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_prod_status_h_famsf2_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_status_type_cd -- 产品状态类型代码
    ,prod_status_cd -- 产品状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_prod_status_h_famsf2_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_status_type_cd -- 产品状态类型代码
    ,prod_status_cd -- 产品状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.prod_status_type_cd -- 产品状态类型代码
    ,o.prod_status_cd -- 产品状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_status_h_famsf2_bk o
    left join ${iml_schema}.prd_prod_status_h_famsf2_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.prod_status_type_cd = n.prod_status_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_prod_status_h_famsf2_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
            and o.prod_status_type_cd = d.prod_status_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_prod_status_h;
alter table ${iml_schema}.prd_prod_status_h truncate partition for ('famsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_prod_status_h exchange subpartition p_famsf2_19000101 with table ${iml_schema}.prd_prod_status_h_famsf2_cl;
alter table ${iml_schema}.prd_prod_status_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.prd_prod_status_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_prod_status_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_prod_status_h_famsf2_tm purge;
drop table ${iml_schema}.prd_prod_status_h_famsf2_op purge;
drop table ${iml_schema}.prd_prod_status_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_prod_status_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_prod_status_h', partname => 'p_famsf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
