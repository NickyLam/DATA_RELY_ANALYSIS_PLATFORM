/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_tran_details
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
drop table ${iol_schema}.ncbs_rb_batch_tran_details_ex purge;
alter table ${iol_schema}.ncbs_rb_batch_tran_details add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_batch_tran_details truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_batch_tran_details_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_tran_details where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_batch_tran_details_ex(
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_type -- 客户类型
    ,doc_type -- 凭证类型
    ,gl_code -- 科目代码
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,acct_desc -- 账户描述
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,fh_seq_no -- 资金冻结流水号
    ,job_run_id -- 批处理任务id
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_gl_code -- 对方科目代码
    ,oth_seq_no -- 对方交易流水号
    ,oth_tran_type -- 对方交易类型
    ,prefix -- 前缀
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_type -- 渠道编号
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,channel -- 渠道
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_prod_type -- 对方账户产品类型
    ,oth_reference -- 对方交易参考号
    ,oth_tran_name -- 交易对手名称
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注5
    ,remark5 -- 备注6
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,narrative_code -- 摘要码
    ,oth_real_bank_code -- 真实对方金融机构代码
    ,oth_real_bank_name -- 真实对方金融机构名称
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_document_id -- 真实交易对手证件号码
    ,oth_real_document_type -- 真实交易对手证件类型
    ,oth_real_prod_type -- 真实交易对手账户产品类型
    ,oth_real_tran_addr -- 真实交易发生地
    ,oth_real_tran_name -- 真实交易对手名称
    ,med_ins_tran_flag -- 医保账户交易标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_type -- 客户类型
    ,doc_type -- 凭证类型
    ,gl_code -- 科目代码
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,acct_desc -- 账户描述
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,fh_seq_no -- 资金冻结流水号
    ,job_run_id -- 批处理任务id
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_gl_code -- 对方科目代码
    ,oth_seq_no -- 对方交易流水号
    ,oth_tran_type -- 对方交易类型
    ,prefix -- 前缀
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_type -- 渠道编号
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,channel -- 渠道
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_prod_type -- 对方账户产品类型
    ,oth_reference -- 对方交易参考号
    ,oth_tran_name -- 交易对手名称
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注5
    ,remark5 -- 备注6
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,narrative_code -- 摘要码
    ,oth_real_bank_code -- 真实对方金融机构代码
    ,oth_real_bank_name -- 真实对方金融机构名称
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_document_id -- 真实交易对手证件号码
    ,oth_real_document_type -- 真实交易对手证件类型
    ,oth_real_prod_type -- 真实交易对手账户产品类型
    ,oth_real_tran_addr -- 真实交易发生地
    ,oth_real_tran_name -- 真实交易对手名称
    ,med_ins_tran_flag -- 医保账户交易标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_batch_tran_details
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_batch_tran_details exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_tran_details_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_tran_details to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_batch_tran_details_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_tran_details',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);