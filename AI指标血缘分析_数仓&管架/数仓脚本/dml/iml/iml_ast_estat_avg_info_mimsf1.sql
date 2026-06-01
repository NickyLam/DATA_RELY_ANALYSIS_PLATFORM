/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_estat_avg_info_mimsf1
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
alter table ${iml_schema}.ast_estat_avg_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_estat_avg_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_estat_avg_info partition for ('mimsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_estat_avg_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_estat_avg_info_mimsf1_op purge;
drop table ${iml_schema}.ast_estat_avg_info_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_estat_avg_info_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    batch_dt -- 批次日期
    ,estat_id -- 楼盘编号
    ,lp_id -- 法人编号
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,estat_name -- 楼盘名称
    ,ext_estim_price -- 外部评估价格
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_estat_avg_info partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_estat_avg_info_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_estat_avg_info partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_estat_avg_info_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_estat_avg_info partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_buildaverageprice-
insert into ${iml_schema}.ast_estat_avg_info_mimsf1_tm(
    batch_dt -- 批次日期
    ,estat_id -- 楼盘编号
    ,lp_id -- 法人编号
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,estat_name -- 楼盘名称
    ,ext_estim_price -- 外部评估价格
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.AVGPRICEDATE -- 批次日期
    ,P1.SEQNO -- 楼盘编号
    ,'9999' -- 法人编号
    ,NVL(TRIM(P1.PROVINCE),'000000') -- 所在省代码
    ,NVL(TRIM(P1.CITY),'000000') -- 所在市代码
    ,NVL(TRIM(P1.COUNTIES),'000000') -- 所在区代码
    ,P1.BUILDINGNAME -- 楼盘名称
    ,P1.AVGPRICE -- 外部评估价格
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_buildaverageprice' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_buildaverageprice p1
where  1 = 1 
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_estat_avg_info_mimsf1_cl(
            batch_dt -- 批次日期
    ,estat_id -- 楼盘编号
    ,lp_id -- 法人编号
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,estat_name -- 楼盘名称
    ,ext_estim_price -- 外部评估价格
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_estat_avg_info_mimsf1_op(
            batch_dt -- 批次日期
    ,estat_id -- 楼盘编号
    ,lp_id -- 法人编号
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,estat_name -- 楼盘名称
    ,ext_estim_price -- 外部评估价格
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.batch_dt, o.batch_dt) as batch_dt -- 批次日期
    ,nvl(n.estat_id, o.estat_id) as estat_id -- 楼盘编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.local_prov_cd, o.local_prov_cd) as local_prov_cd -- 所在省代码
    ,nvl(n.local_city_cd, o.local_city_cd) as local_city_cd -- 所在市代码
    ,nvl(n.local_rg_cd, o.local_rg_cd) as local_rg_cd -- 所在区代码
    ,nvl(n.estat_name, o.estat_name) as estat_name -- 楼盘名称
    ,nvl(n.ext_estim_price, o.ext_estim_price) as ext_estim_price -- 外部评估价格
    ,case when
            n.batch_dt is null
            and n.estat_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_dt is null
            and n.estat_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_dt is null
            and n.estat_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_estat_avg_info_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_estat_avg_info_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.batch_dt = n.batch_dt
            and o.estat_id = n.estat_id
            and o.lp_id = n.lp_id
where (
        o.batch_dt is null
        and o.estat_id is null
        and o.lp_id is null
    )
    or (
        n.batch_dt is null
        and n.estat_id is null
        and n.lp_id is null
    )
    or (
        o.local_prov_cd <> n.local_prov_cd
        or o.local_city_cd <> n.local_city_cd
        or o.local_rg_cd <> n.local_rg_cd
        or o.estat_name <> n.estat_name
        or o.ext_estim_price <> n.ext_estim_price
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_estat_avg_info_mimsf1_cl(
            batch_dt -- 批次日期
    ,estat_id -- 楼盘编号
    ,lp_id -- 法人编号
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,estat_name -- 楼盘名称
    ,ext_estim_price -- 外部评估价格
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_estat_avg_info_mimsf1_op(
            batch_dt -- 批次日期
    ,estat_id -- 楼盘编号
    ,lp_id -- 法人编号
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,estat_name -- 楼盘名称
    ,ext_estim_price -- 外部评估价格
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.batch_dt -- 批次日期
    ,o.estat_id -- 楼盘编号
    ,o.lp_id -- 法人编号
    ,o.local_prov_cd -- 所在省代码
    ,o.local_city_cd -- 所在市代码
    ,o.local_rg_cd -- 所在区代码
    ,o.estat_name -- 楼盘名称
    ,o.ext_estim_price -- 外部评估价格
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_estat_avg_info_mimsf1_bk o
    left join ${iml_schema}.ast_estat_avg_info_mimsf1_op n
        on
            o.batch_dt = n.batch_dt
            and o.estat_id = n.estat_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_estat_avg_info_mimsf1_cl d
        on
            o.batch_dt = d.batch_dt
            and o.estat_id = d.estat_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_estat_avg_info;
alter table ${iml_schema}.ast_estat_avg_info truncate partition for ('mimsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ast_estat_avg_info exchange subpartition p_mimsf1_19000101 with table ${iml_schema}.ast_estat_avg_info_mimsf1_cl;
alter table ${iml_schema}.ast_estat_avg_info exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_estat_avg_info_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_estat_avg_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_estat_avg_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_estat_avg_info_mimsf1_op purge;
drop table ${iml_schema}.ast_estat_avg_info_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_estat_avg_info_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_estat_avg_info', partname => 'p_mimsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
