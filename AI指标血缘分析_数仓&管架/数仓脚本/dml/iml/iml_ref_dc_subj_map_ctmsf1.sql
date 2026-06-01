/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_dc_subj_map_ctmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_dc_subj_map_ctmsf1_tm purge;
alter table ${iml_schema}.ref_dc_subj_map add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_dc_subj_map modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dc_subj_map_ctmsf1_tm
compress ${option_switch} for query high
as
select
    dept_id -- 部门编号
    ,subj_id -- 科目编号
    ,core_bus_id -- 核心业务编号
    ,bal_dir_cd -- 科目余额方向
    ,bal_check_entry_flg -- 余额对账标志
    ,check_entry_flg -- 对账标志
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,entry_way_name -- 记账方式名称
    ,bus_dept_id -- 业务部门编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dc_subj_map
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ctms_tbs_interface_account_mapping-
insert into ${iml_schema}.ref_dc_subj_map_ctmsf1_tm(
    dept_id -- 部门编号
    ,subj_id -- 科目编号
    ,core_bus_id -- 核心业务编号
    ,bal_dir_cd -- 科目余额方向
    ,bal_check_entry_flg -- 余额对账标志
    ,check_entry_flg -- 对账标志
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,entry_way_name -- 记账方式名称
    ,bus_dept_id -- 业务部门编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ASPCLIENT_ID -- 部门编号
    ,P1.ACCOUNTINGCODE -- 科目编号
    ,P1.CORE_ACCOUNTINGCODE -- 核心业务编号
    ,nvl(trim(P1.DEBITCREDIT),'-') -- 科目余额方向
    ,P1.ISCHECKBALANCE -- 余额对账标志
    ,P1.ISCHECKVALUE -- 对账标志
    ,nvl(trim(P1.CURRENCY_CODE),'-') -- 币种代码
    ,P1.ORG_ID -- 机构编号
    ,P1.KEEP_TYPE -- 记账方式名称
    ,P1.DEPARTMENTID -- 业务部门编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_interface_account_mapping' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_interface_account_mapping p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.ref_dc_subj_map truncate partition p_ctmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.ref_dc_subj_map exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.ref_dc_subj_map_ctmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_dc_subj_map to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_dc_subj_map_ctmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_dc_subj_map', partname => 'p_ctmsf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);