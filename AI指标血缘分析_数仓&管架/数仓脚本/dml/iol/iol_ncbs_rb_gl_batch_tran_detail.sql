/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_gl_batch_tran_detail
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
drop table ${iol_schema}.ncbs_rb_gl_batch_tran_detail_ex purge;
alter table ${iol_schema}.ncbs_rb_gl_batch_tran_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_gl_batch_tran_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_gl_batch_tran_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_gl_batch_tran_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_gl_batch_tran_detail_ex(
    acct_name -- 账户名称
    ,acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,gl_code -- 科目代码
    ,prod_type -- 产品编号
    ,bal_upd_type -- 余额更新类型
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,company -- 法人
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,hang_write_off_flag -- 挂销账标志
    ,job_run_id -- 批处理任务id
    ,od_facility -- 是否可透支
    ,prod_desc -- 产品名称
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,subject_desc -- 科目描述
    ,acct_open_date -- 账户开户日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,hang_term -- 挂账期限
    ,link_value -- 关联键值
    ,counter_dep_flag -- 是否允许柜面跨行存入许可标识
    ,counter_debt_flag -- 是否允许柜面跨行支取许可标识
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_name -- 账户名称
    ,acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,gl_code -- 科目代码
    ,prod_type -- 产品编号
    ,bal_upd_type -- 余额更新类型
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,company -- 法人
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,hang_write_off_flag -- 挂销账标志
    ,job_run_id -- 批处理任务id
    ,od_facility -- 是否可透支
    ,prod_desc -- 产品名称
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,subject_desc -- 科目描述
    ,acct_open_date -- 账户开户日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,hang_term -- 挂账期限
    ,link_value -- 关联键值
    ,counter_dep_flag -- 是否允许柜面跨行存入许可标识
    ,counter_debt_flag -- 是否允许柜面跨行支取许可标识
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_gl_batch_tran_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_gl_batch_tran_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_gl_batch_tran_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_gl_batch_tran_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_gl_batch_tran_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_gl_batch_tran_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);