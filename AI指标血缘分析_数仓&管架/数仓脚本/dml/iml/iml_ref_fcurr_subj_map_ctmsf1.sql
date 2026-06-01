/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_fcurr_subj_map_ctmsf1
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
alter table ${iml_schema}.ref_fcurr_subj_map add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ctmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_fcurr_subj_map partition for ('ctmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_tm purge;
drop table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_op purge;
drop table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_tm nologging
compress ${option_switch} for query high
as select
    dept_id -- 部门编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,core_bus_id -- 核心业务编号
    ,curr_cd -- 币种代码
    ,bic_code -- BIC码
    ,bal_dir_cd -- 余额方向代码
    ,check_entry_flg -- 对账标志
    ,core_org_id -- 核心机构编号
    ,entry_way_name -- 记账方式名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_fcurr_subj_map partition for ('ctmsf1')
where 0=1
;

create table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_fcurr_subj_map partition for ('ctmsf1') where 0=1;

create table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_fcurr_subj_map partition for ('ctmsf1') where 0=1;

-- 3.1 get new data into table
-- ctms_fbs_interface_account_mapping-
insert into ${iml_schema}.ref_fcurr_subj_map_ctmsf1_tm(
    dept_id -- 部门编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,core_bus_id -- 核心业务编号
    ,curr_cd -- 币种代码
    ,bic_code -- BIC码
    ,bal_dir_cd -- 余额方向代码
    ,check_entry_flg -- 对账标志
    ,core_org_id -- 核心机构编号
    ,entry_way_name -- 记账方式名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUSNUMBER -- 部门编号
    ,P1.ACCOUNTINGCODE -- 科目编号
    ,P1.ACCOUNTINGDESC -- 科目名称
    ,P1.CORE_ACCOUNTINGCODE -- 核心业务编号
    ,P1.CRNCY_CODE -- 币种代码
    ,P1.BIC -- BIC码
    ,nvl(trim(P1.DEBITCREDIT),'-') END -- 余额方向代码
    ,P1.ISCHECKVALUE -- 对账标志
    ,P1.ORG_ID -- 核心机构编号
    ,P1.KEEP_TYPE -- 记账方式名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_interface_account_mapping' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_interface_account_mapping p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_fcurr_subj_map_ctmsf1_cl(
            dept_id -- 部门编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,core_bus_id -- 核心业务编号
    ,curr_cd -- 币种代码
    ,bic_code -- BIC码
    ,bal_dir_cd -- 余额方向代码
    ,check_entry_flg -- 对账标志
    ,core_org_id -- 核心机构编号
    ,entry_way_name -- 记账方式名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_fcurr_subj_map_ctmsf1_op(
            dept_id -- 部门编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,core_bus_id -- 核心业务编号
    ,curr_cd -- 币种代码
    ,bic_code -- BIC码
    ,bal_dir_cd -- 余额方向代码
    ,check_entry_flg -- 对账标志
    ,core_org_id -- 核心机构编号
    ,entry_way_name -- 记账方式名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.subj_id, o.subj_id) as subj_id -- 科目编号
    ,nvl(n.subj_name, o.subj_name) as subj_name -- 科目名称
    ,nvl(n.core_bus_id, o.core_bus_id) as core_bus_id -- 核心业务编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.bic_code, o.bic_code) as bic_code -- BIC码
    ,nvl(n.bal_dir_cd, o.bal_dir_cd) as bal_dir_cd -- 余额方向代码
    ,nvl(n.check_entry_flg, o.check_entry_flg) as check_entry_flg -- 对账标志
    ,nvl(n.core_org_id, o.core_org_id) as core_org_id -- 核心机构编号
    ,nvl(n.entry_way_name, o.entry_way_name) as entry_way_name -- 记账方式名称
    ,case when
            n.dept_id is null
            and n.subj_id is null
            and n.curr_cd is null
            and n.bic_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dept_id is null
            and n.subj_id is null
            and n.curr_cd is null
            and n.bic_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dept_id is null
            and n.subj_id is null
            and n.curr_cd is null
            and n.bic_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_fcurr_subj_map_ctmsf1_tm n
    full join (select * from ${iml_schema}.ref_fcurr_subj_map_ctmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.dept_id = n.dept_id
            and o.subj_id = n.subj_id
            and o.curr_cd = n.curr_cd
            and o.bic_code = n.bic_code
where (
        o.dept_id is null
        and o.subj_id is null
        and o.curr_cd is null
        and o.bic_code is null
    )
    or (
        n.dept_id is null
        and n.subj_id is null
        and n.curr_cd is null
        and n.bic_code is null
    )
    or (
        o.subj_name <> n.subj_name
        or o.core_bus_id <> n.core_bus_id
        or o.bal_dir_cd <> n.bal_dir_cd
        or o.check_entry_flg <> n.check_entry_flg
        or o.core_org_id <> n.core_org_id
        or o.entry_way_name <> n.entry_way_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_fcurr_subj_map_ctmsf1_cl(
            dept_id -- 部门编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,core_bus_id -- 核心业务编号
    ,curr_cd -- 币种代码
    ,bic_code -- BIC码
    ,bal_dir_cd -- 余额方向代码
    ,check_entry_flg -- 对账标志
    ,core_org_id -- 核心机构编号
    ,entry_way_name -- 记账方式名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_fcurr_subj_map_ctmsf1_op(
            dept_id -- 部门编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,core_bus_id -- 核心业务编号
    ,curr_cd -- 币种代码
    ,bic_code -- BIC码
    ,bal_dir_cd -- 余额方向代码
    ,check_entry_flg -- 对账标志
    ,core_org_id -- 核心机构编号
    ,entry_way_name -- 记账方式名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dept_id -- 部门编号
    ,o.subj_id -- 科目编号
    ,o.subj_name -- 科目名称
    ,o.core_bus_id -- 核心业务编号
    ,o.curr_cd -- 币种代码
    ,o.bic_code -- BIC码
    ,o.bal_dir_cd -- 余额方向代码
    ,o.check_entry_flg -- 对账标志
    ,o.core_org_id -- 核心机构编号
    ,o.entry_way_name -- 记账方式名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_fcurr_subj_map_ctmsf1_bk o
    left join ${iml_schema}.ref_fcurr_subj_map_ctmsf1_op n
        on
            o.dept_id = n.dept_id
            and o.subj_id = n.subj_id
            and o.curr_cd = n.curr_cd
            and o.bic_code = n.bic_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_fcurr_subj_map_ctmsf1_cl d
        on
            o.dept_id = d.dept_id
            and o.subj_id = d.subj_id
            and o.curr_cd = d.curr_cd
            and o.bic_code = d.bic_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_fcurr_subj_map;
alter table ${iml_schema}.ref_fcurr_subj_map truncate partition for ('ctmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_fcurr_subj_map exchange subpartition p_ctmsf1_19000101 with table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_cl;
alter table ${iml_schema}.ref_fcurr_subj_map exchange subpartition p_ctmsf1_20991231 with table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_fcurr_subj_map to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_tm purge;
drop table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_op purge;
drop table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_fcurr_subj_map_ctmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_fcurr_subj_map', partname => 'p_ctmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
