/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_foundation_details
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
drop table ${iol_schema}.ncbs_rb_batch_foundation_details_ex purge;
alter table ${iol_schema}.ncbs_rb_batch_foundation_details add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_batch_foundation_details;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_batch_foundation_details_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_batch_foundation_details where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_batch_foundation_details_ex(
    client_no -- 客户编号
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,restraint_type -- 限制类型
    ,user_id -- 交易柜员编号
    ,term -- 存期
    ,term_type -- 期限单位
    ,bal_type -- 余额类型
    ,batch_no -- 批次号
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,cr_card_pb_ind -- 转入账户卡折标志
    ,cr_tran_type -- 转入交易类型
    ,dr_tran_type -- 转出交易类型
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,frozen_pb_flag -- 冻结账户卡折标志
    ,frozen_seq_no -- 冻结流水号
    ,job_run_id -- 批处理任务id
    ,narrative -- 摘要
    ,res_flag -- 冻结标志
    ,ret_code -- 状态码
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,transfer_flag -- 转账标志
    ,unfrozen_flag -- 解冻标志
    ,unfrozen_pb_flag -- 解冻账户卡折标志
    ,unfrozen_seq_no -- 解冻流水号
    ,dr_card_pb_ind -- 借方账户卡折标志
    ,channel -- 渠道
    ,end_date -- 结束日期
    ,start_date -- 开始日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,cr_acct_ccy -- 贷方账户币种
    ,cr_acct_type -- 收款账户类型（行内账户）
    ,cr_base_acct_no -- 贷方账号
    ,credit_card_no -- 信用卡号
    ,dr_acct_type -- 转出账户类型
    ,dr_base_acct_no -- 借方账号
    ,frozen_acct_type -- 冻结账户类型
    ,frozen_base_acct_no -- 冻结账户
    ,frozen_ccy -- 冻结账户币种
    ,pledged_amt -- 限制金额
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,tran_branch -- 核心交易机构编号
    ,transfer_amt -- 划转金额
    ,unfrozen_base_acct_no -- 解冻账户/卡号
    ,unfrozen_ccy -- 解冻账户币种
    ,narrative_code -- 摘要码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,restraint_type -- 限制类型
    ,user_id -- 交易柜员编号
    ,term -- 存期
    ,term_type -- 期限单位
    ,bal_type -- 余额类型
    ,batch_no -- 批次号
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,cr_card_pb_ind -- 转入账户卡折标志
    ,cr_tran_type -- 转入交易类型
    ,dr_tran_type -- 转出交易类型
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,frozen_pb_flag -- 冻结账户卡折标志
    ,frozen_seq_no -- 冻结流水号
    ,job_run_id -- 批处理任务id
    ,narrative -- 摘要
    ,res_flag -- 冻结标志
    ,ret_code -- 状态码
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,transfer_flag -- 转账标志
    ,unfrozen_flag -- 解冻标志
    ,unfrozen_pb_flag -- 解冻账户卡折标志
    ,unfrozen_seq_no -- 解冻流水号
    ,dr_card_pb_ind -- 借方账户卡折标志
    ,channel -- 渠道
    ,end_date -- 结束日期
    ,start_date -- 开始日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,cr_acct_ccy -- 贷方账户币种
    ,cr_acct_type -- 收款账户类型（行内账户）
    ,cr_base_acct_no -- 贷方账号
    ,credit_card_no -- 信用卡号
    ,dr_acct_type -- 转出账户类型
    ,dr_base_acct_no -- 借方账号
    ,frozen_acct_type -- 冻结账户类型
    ,frozen_base_acct_no -- 冻结账户
    ,frozen_ccy -- 冻结账户币种
    ,pledged_amt -- 限制金额
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,tran_branch -- 核心交易机构编号
    ,transfer_amt -- 划转金额
    ,unfrozen_base_acct_no -- 解冻账户/卡号
    ,unfrozen_ccy -- 解冻账户币种
    ,narrative_code -- 摘要码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_batch_foundation_details
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_batch_foundation_details exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_foundation_details_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_foundation_details to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_batch_foundation_details_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_foundation_details',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);