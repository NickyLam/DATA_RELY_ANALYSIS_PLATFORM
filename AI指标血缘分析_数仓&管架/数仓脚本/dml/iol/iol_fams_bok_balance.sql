/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_balance
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_balance_ex purge;
alter table ${iol_schema}.fams_bok_balance add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.fams_bok_balance truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.fams_bok_balance_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_balance where 0=1;

insert /*+ append */ into ${iol_schema}.fams_bok_balance_ex(
    bookset_id -- 账套代码
    ,balance_date -- 余额日期
    ,subject_no -- 科目号
    ,fsubject_no -- 父科目号
    ,subject_level -- 科目级别
    ,bal_flag -- 余额方向
    ,bal_co_flag -- 结转余额方向
    ,o_ccy -- 原币
    ,o_amt -- 原币余额
    ,o_c_amt -- 原币余额贷方
    ,o_d_amt -- 原币余额借方
    ,o_co_amt -- 原币结转余额
    ,o_co_c_amt -- 原币结转余额贷方
    ,o_co_d_amt -- 原币结转余额借方
    ,b_ccy -- 本位币
    ,b_amt -- 本位币余额
    ,b_c_amt -- 本位币余额贷方
    ,b_co_amt -- 本位币结转余额
    ,b_co_c_amt -- 本位币结转余额贷方
    ,b_co_d_amt -- 本位币结转余额借方
    ,b_d_amt -- 本位币余额借方
    ,tdy_o_amt -- 原币当日发生额
    ,tdy_o_c_amt -- 原币当日发生额贷方
    ,tdy_o_d_amt -- 原币当日发生额借方
    ,tdy_o_co_amt -- 原币结转当日发生额
    ,tdy_o_co_c_amt -- 原币结转当日发生额贷方
    ,tdy_o_co_d_amt -- 原币结转当日发生额借方
    ,tdy_b_amt -- 本位币当日发生额
    ,tdy_b_c_amt -- 本位币当日发生额贷方
    ,tdy_b_d_amt -- 本位币当日发生额借方
    ,tdy_b_co_amt -- 本位币结转当日发生额
    ,tdy_b_co_c_amt -- 本位币结转当日发生额贷方
    ,tdy_b_co_d_amt -- 本位币结转当日发生额借方
    ,is_leaf -- 是否叶子节点
    ,num_amt -- 数量余额
    ,create_user -- 创建人
    ,create_dept -- 创建部门
    ,create_time -- 创建时间
    ,update_user -- 更新人
    ,update_time -- 更新时间
    ,tdy_amt_flag -- 当日发生额方向
    ,tdy_co_flag -- 结转当日发生额方向
    ,tdy_pur_o_d_ulamt -- 原币申购未实现平准金借
    ,tdy_red_o_d_ulamt -- 原币赎回未实现平准金借
    ,tdy_pur_o_c_ulamt -- 原币申购未实现平准金贷
    ,tdy_red_o_c_ulamt -- 原币赎回未实现平准金贷
    ,tdy_pur_b_d_ulamt -- 本位币申购未实现平准金借
    ,tdy_red_b_d_ulamt -- 本位币赎回未实现平准金借
    ,tdy_pur_b_c_ulamt -- 本位币申购未实现平准金贷
    ,tdy_red_b_c_ulamt -- 本位币赎回未实现平准金贷
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    bookset_id -- 账套代码
    ,balance_date -- 余额日期
    ,subject_no -- 科目号
    ,fsubject_no -- 父科目号
    ,subject_level -- 科目级别
    ,bal_flag -- 余额方向
    ,bal_co_flag -- 结转余额方向
    ,o_ccy -- 原币
    ,o_amt -- 原币余额
    ,o_c_amt -- 原币余额贷方
    ,o_d_amt -- 原币余额借方
    ,o_co_amt -- 原币结转余额
    ,o_co_c_amt -- 原币结转余额贷方
    ,o_co_d_amt -- 原币结转余额借方
    ,b_ccy -- 本位币
    ,b_amt -- 本位币余额
    ,b_c_amt -- 本位币余额贷方
    ,b_co_amt -- 本位币结转余额
    ,b_co_c_amt -- 本位币结转余额贷方
    ,b_co_d_amt -- 本位币结转余额借方
    ,b_d_amt -- 本位币余额借方
    ,tdy_o_amt -- 原币当日发生额
    ,tdy_o_c_amt -- 原币当日发生额贷方
    ,tdy_o_d_amt -- 原币当日发生额借方
    ,tdy_o_co_amt -- 原币结转当日发生额
    ,tdy_o_co_c_amt -- 原币结转当日发生额贷方
    ,tdy_o_co_d_amt -- 原币结转当日发生额借方
    ,tdy_b_amt -- 本位币当日发生额
    ,tdy_b_c_amt -- 本位币当日发生额贷方
    ,tdy_b_d_amt -- 本位币当日发生额借方
    ,tdy_b_co_amt -- 本位币结转当日发生额
    ,tdy_b_co_c_amt -- 本位币结转当日发生额贷方
    ,tdy_b_co_d_amt -- 本位币结转当日发生额借方
    ,is_leaf -- 是否叶子节点
    ,num_amt -- 数量余额
    ,create_user -- 创建人
    ,create_dept -- 创建部门
    ,create_time -- 创建时间
    ,update_user -- 更新人
    ,update_time -- 更新时间
    ,tdy_amt_flag -- 当日发生额方向
    ,tdy_co_flag -- 结转当日发生额方向
    ,tdy_pur_o_d_ulamt -- 原币申购未实现平准金借
    ,tdy_red_o_d_ulamt -- 原币赎回未实现平准金借
    ,tdy_pur_o_c_ulamt -- 原币申购未实现平准金贷
    ,tdy_red_o_c_ulamt -- 原币赎回未实现平准金贷
    ,tdy_pur_b_d_ulamt -- 本位币申购未实现平准金借
    ,tdy_red_b_d_ulamt -- 本位币赎回未实现平准金借
    ,tdy_pur_b_c_ulamt -- 本位币申购未实现平准金贷
    ,tdy_red_b_c_ulamt -- 本位币赎回未实现平准金贷
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fams_bok_balance
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fams_bok_balance exchange partition p_${batch_date} with table ${iol_schema}.fams_bok_balance_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_balance to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fams_bok_balance_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_balance',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);