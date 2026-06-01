/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_cotin_froz_rgst_b
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
drop table ${iol_schema}.ifcs_cotin_froz_rgst_b_ex purge;
alter table ${iol_schema}.ifcs_cotin_froz_rgst_b add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ifcs_cotin_froz_rgst_b;

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_cotin_froz_rgst_b_ex nologging
compress
as
select * from ${iol_schema}.ifcs_cotin_froz_rgst_b where 0=1;

insert /*+ append */ into ${iol_schema}.ifcs_cotin_froz_rgst_b_ex(
    cotin_froz_dt -- 续冻日期
    ,cotin_froz_flow_num -- 续冻流水
    ,cotin_froz_amt -- 续冻金额
    ,init_froz_end_dt -- 原冻结截至日
    ,init_proof_cate -- 原证明类别
    ,init_proof_num -- 原证明书号
    ,init_froz_rs -- 原冻结原因
    ,init_exec_org -- 原执行机关
    ,init_exec_cert_01 -- 原执行证件一
    ,init_exec_num_01 -- 原执行号码一
    ,init_exec_cert_02 -- 原执行证件二
    ,init_exec_num_02 -- 原执行号码二
    ,init_exec_ps_01 -- 原执行人
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow -- 原冻结流水
    ,init_froz_seq_num -- 原冻结序号
    ,init_exec_ps_02 -- 原执行人二
    ,con_froz_tm -- 续冻时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cotin_froz_dt -- 续冻日期
    ,cotin_froz_flow_num -- 续冻流水
    ,cotin_froz_amt -- 续冻金额
    ,init_froz_end_dt -- 原冻结截至日
    ,init_proof_cate -- 原证明类别
    ,init_proof_num -- 原证明书号
    ,init_froz_rs -- 原冻结原因
    ,init_exec_org -- 原执行机关
    ,init_exec_cert_01 -- 原执行证件一
    ,init_exec_num_01 -- 原执行号码一
    ,init_exec_cert_02 -- 原执行证件二
    ,init_exec_num_02 -- 原执行号码二
    ,init_exec_ps_01 -- 原执行人
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow -- 原冻结流水
    ,init_froz_seq_num -- 原冻结序号
    ,init_exec_ps_02 -- 原执行人二
    ,con_froz_tm -- 续冻时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_cotin_froz_rgst_b
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_cotin_froz_rgst_b exchange partition p_${batch_date} with table ${iol_schema}.ifcs_cotin_froz_rgst_b_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_cotin_froz_rgst_b to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_cotin_froz_rgst_b_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_cotin_froz_rgst_b',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);