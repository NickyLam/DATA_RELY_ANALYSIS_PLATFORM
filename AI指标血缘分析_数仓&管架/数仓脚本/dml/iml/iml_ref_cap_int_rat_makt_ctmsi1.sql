/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_cap_int_rat_makt_ctmsi1
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
alter table ${iml_schema}.ref_cap_int_rat_makt add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ctmsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_cap_int_rat_makt partition for ('ctmsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_tm purge;
drop table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_op purge;
drop table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_tm nologging
compress ${option_switch} for query high
as select
    int_rat_id -- 利率编号
    ,lp_id -- 法人编号
    ,int_rat -- 利率
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_cap_int_rat_makt partition for ('ctmsi1')
where 0=1
;

create table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_cap_int_rat_makt partition for ('ctmsi1') where 0=1;

create table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_cap_int_rat_makt partition for ('ctmsi1') where 0=1;

-- 3.1 get new data into table
-- ctms_tbs_rate_index_value-
insert into ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_tm(
    int_rat_id -- 利率编号
    ,lp_id -- 法人编号
    ,int_rat -- 利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.rate_index -- 利率编号
    ,'9999' -- 法人编号
    ,P1.rate -- 利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_rate_index_value' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_rate_index_value p1
where  1 = 1 
    and  P1.rate_date='${batch_date}'
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_op(
        int_rat_id -- 利率编号
    ,lp_id -- 法人编号
    ,int_rat -- 利率
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.int_rat_id -- 利率编号
    ,n.lp_id -- 法人编号
    ,n.int_rat -- 利率
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'ctmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_tm n
    left join (select * from ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.int_rat_id = n.int_rat_id
            and o.lp_id = n.lp_id
where (
        o.int_rat_id is null
        and o.lp_id is null
    )
    or (
        o.int_rat <> n.int_rat
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_cl(
            int_rat_id -- 利率编号
    ,lp_id -- 法人编号
    ,int_rat -- 利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_op(
            int_rat_id -- 利率编号
    ,lp_id -- 法人编号
    ,int_rat -- 利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.int_rat_id -- 利率编号
    ,o.lp_id -- 法人编号
    ,o.int_rat -- 利率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_bk o
    left join ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_op n
        on
            o.int_rat_id = n.int_rat_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_cap_int_rat_makt;
alter table ${iml_schema}.ref_cap_int_rat_makt truncate partition for ('ctmsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_cap_int_rat_makt exchange subpartition p_ctmsi1_19000101 with table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_cl;
alter table ${iml_schema}.ref_cap_int_rat_makt exchange subpartition p_ctmsi1_20991231 with table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_cap_int_rat_makt to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_tm purge;
drop table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_op purge;
drop table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_cap_int_rat_makt_ctmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_cap_int_rat_makt', partname => 'p_ctmsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
