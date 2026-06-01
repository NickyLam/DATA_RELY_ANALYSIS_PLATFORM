/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_transfer_details
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
drop table ${iol_schema}.ncbs_rb_batch_transfer_details_ex purge;
alter table ${iol_schema}.ncbs_rb_batch_transfer_details add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_batch_transfer_details;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_batch_transfer_details_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_batch_transfer_details where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_batch_transfer_details_ex(
    ccy -- 币种
    ,doc_type -- 凭证类型
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,voucher_no -- 凭证号码
    ,withdrawal_type -- 支取方式
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,contrast_bat_no -- 对方批次号
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,in_purpose -- 转入账户用途
    ,job_run_id -- 批处理任务id
    ,narrative -- 摘要
    ,out_purpose -- 转出账户用途
    ,prefix -- 前缀
    ,rec_amt_ctrl -- 扣款方式
    ,ret_msg -- 服务状态描述
    ,reversal_flag -- 交易是否已冲正
    ,seq_no -- 序号
    ,sub_seq_no -- 系统流水号
    ,transfer_status -- 转账状态
    ,sign_time -- 登记时间
    ,tran_timestamp -- 交易时间戳
    ,in_acct_name -- 转入账户名称
    ,in_base_acct_no -- 移入账号
    ,in_ccy -- 转入账户币种
    ,in_prod_type -- 转入账户产品类型
    ,in_seq_no -- 转入账户序号
    ,out_acct -- 账号
    ,out_acct_name -- 转出账户名称
    ,out_ccy -- 转出账户币种
    ,out_prod_type -- 转出账户产品
    ,out_seq_no -- 转出账户序号
    ,tran_amt -- 交易金额
    ,act_tran_amt -- 实际交易金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ccy -- 币种
    ,doc_type -- 凭证类型
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,voucher_no -- 凭证号码
    ,withdrawal_type -- 支取方式
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,contrast_bat_no -- 对方批次号
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,in_purpose -- 转入账户用途
    ,job_run_id -- 批处理任务id
    ,narrative -- 摘要
    ,out_purpose -- 转出账户用途
    ,prefix -- 前缀
    ,rec_amt_ctrl -- 扣款方式
    ,ret_msg -- 服务状态描述
    ,reversal_flag -- 交易是否已冲正
    ,seq_no -- 序号
    ,sub_seq_no -- 系统流水号
    ,transfer_status -- 转账状态
    ,sign_time -- 登记时间
    ,tran_timestamp -- 交易时间戳
    ,in_acct_name -- 转入账户名称
    ,in_base_acct_no -- 移入账号
    ,in_ccy -- 转入账户币种
    ,in_prod_type -- 转入账户产品类型
    ,in_seq_no -- 转入账户序号
    ,out_acct -- 账号
    ,out_acct_name -- 转出账户名称
    ,out_ccy -- 转出账户币种
    ,out_prod_type -- 转出账户产品
    ,out_seq_no -- 转出账户序号
    ,tran_amt -- 交易金额
    ,act_tran_amt -- 实际交易金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_batch_transfer_details
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_batch_transfer_details exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_transfer_details_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_transfer_details to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_batch_transfer_details_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_transfer_details',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);