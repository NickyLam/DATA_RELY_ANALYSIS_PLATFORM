/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_appl_status_h_mybki1
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
alter table ${iml_schema}.agt_appl_status_h add partition p_mybki1 values ('mybki1')(
        subpartition p_mybki1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mybki1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_appl_status_h_mybki1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_appl_status_h partition for ('mybki1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_appl_status_h_mybki1_tm purge;
drop table ${iml_schema}.agt_appl_status_h_mybki1_op purge;
drop table ${iml_schema}.agt_appl_status_h_mybki1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_appl_status_h_mybki1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_status_type_cd -- 申请状态类型代码
    ,appl_status_cd -- 申请状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_appl_status_h partition for ('mybki1')
where 0=1
;

create table ${iml_schema}.agt_appl_status_h_mybki1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_appl_status_h partition for ('mybki1') where 0=1;

create table ${iml_schema}.agt_appl_status_h_mybki1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_appl_status_h partition for ('mybki1') where 0=1;

-- 3.1 get new data into table
-- rcrs_mybk_iqp_loan_app-
insert into ${iml_schema}.agt_appl_status_h_mybki1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_status_type_cd -- 申请状态类型代码
    ,appl_status_cd -- 申请状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203006'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,'CD2016' -- 申请状态类型代码
    ,P1.APPROVE_STATUS -- 申请状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_mybk_iqp_loan_app' -- 源表名称
    ,'mybki1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_mybk_iqp_loan_app p1
where  1 = 1 
     and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd')
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_appl_status_h_mybki1_op(
        appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_status_type_cd -- 申请状态类型代码
    ,appl_status_cd -- 申请状态代码
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.appl_id -- 申请编号
    ,n.lp_id -- 法人编号
    ,n.appl_status_type_cd -- 申请状态类型代码
    ,n.appl_status_cd -- 申请状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'mybki1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_appl_status_h_mybki1_tm n
    left join (select * from ${iml_schema}.agt_appl_status_h_mybki1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.appl_status_type_cd = n.appl_status_type_cd
where (
        o.appl_id is null
        and o.lp_id is null
        and o.appl_status_type_cd is null
    )
    or (
        o.appl_status_cd <> n.appl_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_appl_status_h_mybki1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_status_type_cd -- 申请状态类型代码
    ,appl_status_cd -- 申请状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_appl_status_h_mybki1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_status_type_cd -- 申请状态类型代码
    ,appl_status_cd -- 申请状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.appl_status_type_cd -- 申请状态类型代码
    ,o.appl_status_cd -- 申请状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_appl_status_h_mybki1_bk o
    left join ${iml_schema}.agt_appl_status_h_mybki1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.appl_status_type_cd = n.appl_status_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_appl_status_h;
alter table ${iml_schema}.agt_appl_status_h truncate partition for ('mybki1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_appl_status_h exchange subpartition p_mybki1_19000101 with table ${iml_schema}.agt_appl_status_h_mybki1_cl;
alter table ${iml_schema}.agt_appl_status_h exchange subpartition p_mybki1_20991231 with table ${iml_schema}.agt_appl_status_h_mybki1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_appl_status_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_appl_status_h_mybki1_tm purge;
drop table ${iml_schema}.agt_appl_status_h_mybki1_op purge;
drop table ${iml_schema}.agt_appl_status_h_mybki1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_appl_status_h_mybki1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_appl_status_h', partname => 'p_mybki1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
