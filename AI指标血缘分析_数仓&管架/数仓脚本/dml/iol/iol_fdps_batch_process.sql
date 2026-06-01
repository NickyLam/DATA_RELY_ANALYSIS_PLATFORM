/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fdps_batch_process
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
drop table ${iol_schema}.fdps_batch_process_ex purge;
alter table ${iol_schema}.fdps_batch_process add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.fdps_batch_process truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.fdps_batch_process_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fdps_batch_process where 0=1;

insert /*+ append */ into ${iol_schema}.fdps_batch_process_ex(
    batch_id -- 批次编号
    ,batch_name -- 批次名称
    ,third_batch_id -- 第三方批次编号
    ,parent_merchant_id -- 银行合作商编号
    ,check_date -- 对账日期
    ,batch_type -- 批次类型
    ,deal_option -- 文件处理选项
    ,old_req_seq_no -- 第三方流水
    ,submit_file -- 提交数据文件名
    ,result_file -- 结果数据文件名
    ,submit_count -- 提交数据总笔数
    ,submit_sum -- 提交数据总金额
    ,result_count -- 结果数据总笔数
    ,result_sum -- 结果数据总金额
    ,deposit_count -- 入金提交总笔数
    ,deposit_sum -- 入金提交总金额
    ,withdraw_count -- 出金提交总笔数
    ,withdraw_sum -- 出金提交总金额
    ,success_count -- 成功笔数
    ,success_amount -- 成功金额
    ,fail_count -- 失败笔数
    ,fail_amount -- 失败金额
    ,submit_gua_amount -- 提交数据总担保金额
    ,success_gua_amount -- 成功担保金额
    ,tran_branch_id -- 交易机构
    ,tran_teller_no -- 交易柜员
    ,transaction_date -- 交易日期
    ,resp_code -- 响应码
    ,resp_msg -- 响应信息
    ,has_detal_flag -- 是否有明细
    ,batch_status -- 批次结果
    ,amt_source -- 资金来源
    ,remark -- 备注
    ,last_updated_stamp -- 最后更新时间
    ,last_updated_tx_stamp -- 最后更新事务时间
    ,created_stamp -- 创建时间
    ,created_tx_stamp -- 创建事务时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    batch_id -- 批次编号
    ,batch_name -- 批次名称
    ,third_batch_id -- 第三方批次编号
    ,parent_merchant_id -- 银行合作商编号
    ,check_date -- 对账日期
    ,batch_type -- 批次类型
    ,deal_option -- 文件处理选项
    ,old_req_seq_no -- 第三方流水
    ,submit_file -- 提交数据文件名
    ,result_file -- 结果数据文件名
    ,submit_count -- 提交数据总笔数
    ,submit_sum -- 提交数据总金额
    ,result_count -- 结果数据总笔数
    ,result_sum -- 结果数据总金额
    ,deposit_count -- 入金提交总笔数
    ,deposit_sum -- 入金提交总金额
    ,withdraw_count -- 出金提交总笔数
    ,withdraw_sum -- 出金提交总金额
    ,success_count -- 成功笔数
    ,success_amount -- 成功金额
    ,fail_count -- 失败笔数
    ,fail_amount -- 失败金额
    ,submit_gua_amount -- 提交数据总担保金额
    ,success_gua_amount -- 成功担保金额
    ,tran_branch_id -- 交易机构
    ,tran_teller_no -- 交易柜员
    ,transaction_date -- 交易日期
    ,resp_code -- 响应码
    ,resp_msg -- 响应信息
    ,has_detal_flag -- 是否有明细
    ,batch_status -- 批次结果
    ,amt_source -- 资金来源
    ,remark -- 备注
    ,last_updated_stamp -- 最后更新时间
    ,last_updated_tx_stamp -- 最后更新事务时间
    ,created_stamp -- 创建时间
    ,created_tx_stamp -- 创建事务时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fdps_batch_process
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fdps_batch_process exchange partition p_${batch_date} with table ${iol_schema}.fdps_batch_process_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fdps_batch_process to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fdps_batch_process_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fdps_batch_process',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);