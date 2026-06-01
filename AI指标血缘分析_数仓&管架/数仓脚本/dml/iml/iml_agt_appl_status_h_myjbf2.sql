/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_appl_status_h_myjbf2
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
alter table ${iml_schema}.agt_appl_status_h add partition p_myjbf2 values ('myjbf2')(
        subpartition p_myjbf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_myjbf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_appl_status_h_myjbf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_appl_status_h partition for ('myjbf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_appl_status_h_myjbf2_tm purge;
drop table ${iml_schema}.agt_appl_status_h_myjbf2_op purge;
drop table ${iml_schema}.agt_appl_status_h_myjbf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_appl_status_h_myjbf2_tm nologging
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
from ${iml_schema}.agt_appl_status_h partition for ('myjbf2')
where 0=1
;

create table ${iml_schema}.agt_appl_status_h_myjbf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_appl_status_h partition for ('myjbf2') where 0=1;

create table ${iml_schema}.agt_appl_status_h_myjbf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_appl_status_h partition for ('myjbf2') where 0=1;

-- 3.1 get new data into table
-- rcrs_myjb_iqp_loan_app-
insert into ${iml_schema}.agt_appl_status_h_myjbf2_tm(
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
    '203002'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,'CD1084' -- 申请状态类型代码
    ,P1.APPROVE_STATUS -- 申请状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_myjb_iqp_loan_app' -- 源表名称
    ,'myjbf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_myjb_iqp_loan_app p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- rcrs_myjb_iqp_loan_app_his-
insert into ${iml_schema}.agt_appl_status_h_myjbf2_tm(
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
    '203002'||P1.SERNO -- 申请编号
    ,'9999' -- 法人编号
    ,'CD1084' -- 申请状态类型代码
    ,P1.APPROVE_STATUS -- 申请状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_myjb_iqp_loan_app_his' -- 源表名称
    ,'myjbf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_myjb_iqp_loan_app_his p1
    left join ${iol_schema}.rcrs_myjb_iqp_loan_app p2 on P1.SERNO=P2.SERNO
AND p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where  1 = 1 
    and P1.etl_dt <=to_date('${batch_date}','yyyy-mm-dd')
    and P2.SERNO is null
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_appl_status_h_myjbf2_cl(
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
        into ${iml_schema}.agt_appl_status_h_myjbf2_op(
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
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_status_type_cd, o.appl_status_type_cd) as appl_status_type_cd -- 申请状态类型代码
    ,nvl(n.appl_status_cd, o.appl_status_cd) as appl_status_cd -- 申请状态代码
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_status_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_status_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_status_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_appl_status_h_myjbf2_tm n
    full join (select * from ${iml_schema}.agt_appl_status_h_myjbf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        n.appl_id is null
        and n.lp_id is null
        and n.appl_status_type_cd is null
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
        into ${iml_schema}.agt_appl_status_h_myjbf2_cl(
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
        into ${iml_schema}.agt_appl_status_h_myjbf2_op(
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
from ${iml_schema}.agt_appl_status_h_myjbf2_bk o
    left join ${iml_schema}.agt_appl_status_h_myjbf2_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.appl_status_type_cd = n.appl_status_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_appl_status_h_myjbf2_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.appl_status_type_cd = d.appl_status_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_appl_status_h;
alter table ${iml_schema}.agt_appl_status_h truncate partition for ('myjbf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_appl_status_h exchange subpartition p_myjbf2_19000101 with table ${iml_schema}.agt_appl_status_h_myjbf2_cl;
alter table ${iml_schema}.agt_appl_status_h exchange subpartition p_myjbf2_20991231 with table ${iml_schema}.agt_appl_status_h_myjbf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_appl_status_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_appl_status_h_myjbf2_tm purge;
drop table ${iml_schema}.agt_appl_status_h_myjbf2_op purge;
drop table ${iml_schema}.agt_appl_status_h_myjbf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_appl_status_h_myjbf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_appl_status_h', partname => 'p_myjbf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
