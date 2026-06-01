/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_impound_info
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
drop table ${iol_schema}.ncbs_rb_impound_info_ex purge;
alter table ${iol_schema}.ncbs_rb_impound_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_impound_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_impound_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_impound_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_impound_info_ex(
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,deposit_type -- 存款类型
    ,impoind_int_flag -- 标志
    ,impound_type -- 扣划类型
    ,individual_flag -- 对公对私标志
    ,int_ind_flag -- 是否计息
    ,law_no -- 法律文书号
    ,movt_status -- 转存类型
    ,narrative -- 摘要
    ,operate_channel -- 操作渠道
    ,res_seq_no -- 限制编号
    ,sched_no -- 计划编号
    ,transfer_flag -- 转账标志
    ,transfer_option -- 强制扣划操作类型
    ,transfer_times -- 已扣划次数
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,accrued_int -- 扣划后金额重新计提的利息
    ,accrued_int_adj -- 扣划后金额重新计提的调整利息
    ,auth_user_id -- 授权柜员
    ,beneficiary_branch -- 对方行行号
    ,beneficiary_branch_name -- 对方行行名
    ,benefit_base_acct_no -- 受益人账户账号
    ,benefit_prod_type -- 受益人账户产品类型
    ,benenfit_acct_name -- 受益人账户户名
    ,benenfit_ccy -- 受益人币种
    ,benenfit_seq_no -- 受益人账户序号
    ,deduction_judiciary_name -- 有权机关名称
    ,impound_amt -- 扣划金额
    ,impound_int -- 扣划利息
    ,impound_tax -- 扣划产生利息税
    ,impound_total_amt -- 扣划总金额
    ,int_acct_ccy -- 利息转入账户币种
    ,int_acct_name -- 利息入账账户户名
    ,int_acct_seq_no -- 利息转入账户序列号
    ,int_amt -- 利息金额
    ,int_base_acct_no -- 利息转入账号
    ,int_internal_key -- 利息入账账户标识符
    ,int_prod_type -- 利息转入账户产品类型
    ,judiciary_document_id -- 执法人1证件号码
    ,judiciary_document_id2 -- 执法人1证件号码2
    ,judiciary_document_type -- 执法人1证件类型
    ,judiciary_document_type2 -- 执法人1证件类型2
    ,judiciary_officer_name -- 执法人1姓名
    ,judiciary_oth_document_id -- 执法人2证件号码
    ,judiciary_oth_document_id2 -- 执法人2证件号码2
    ,judiciary_oth_document_type -- 执法人2证件类型
    ,judiciary_oth_document_type2 -- 执法人2证件类型2
    ,judiciary_oth_officer_name -- 执法人2姓名
    ,original_int -- 原计提利息
    ,original_int_adj -- 原计提调整利息
    ,oth_reference -- 对方交易参考号
    ,other_client_address -- 对方行收款人地址
    ,out_oth_acct_name -- 对方行收款人户名
    ,out_oth_base_acct_no -- 对方行收款人账户
    ,pledged_int_amt -- 冻结期间产生的利息
    ,pledged_tax_amt -- 冻结期间利息税
    ,total_amt -- 总金额
    ,tran_branch -- 核心交易机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,deposit_type -- 存款类型
    ,impoind_int_flag -- 标志
    ,impound_type -- 扣划类型
    ,individual_flag -- 对公对私标志
    ,int_ind_flag -- 是否计息
    ,law_no -- 法律文书号
    ,movt_status -- 转存类型
    ,narrative -- 摘要
    ,operate_channel -- 操作渠道
    ,res_seq_no -- 限制编号
    ,sched_no -- 计划编号
    ,transfer_flag -- 转账标志
    ,transfer_option -- 强制扣划操作类型
    ,transfer_times -- 已扣划次数
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,accrued_int -- 扣划后金额重新计提的利息
    ,accrued_int_adj -- 扣划后金额重新计提的调整利息
    ,auth_user_id -- 授权柜员
    ,beneficiary_branch -- 对方行行号
    ,beneficiary_branch_name -- 对方行行名
    ,benefit_base_acct_no -- 受益人账户账号
    ,benefit_prod_type -- 受益人账户产品类型
    ,benenfit_acct_name -- 受益人账户户名
    ,benenfit_ccy -- 受益人币种
    ,benenfit_seq_no -- 受益人账户序号
    ,deduction_judiciary_name -- 有权机关名称
    ,impound_amt -- 扣划金额
    ,impound_int -- 扣划利息
    ,impound_tax -- 扣划产生利息税
    ,impound_total_amt -- 扣划总金额
    ,int_acct_ccy -- 利息转入账户币种
    ,int_acct_name -- 利息入账账户户名
    ,int_acct_seq_no -- 利息转入账户序列号
    ,int_amt -- 利息金额
    ,int_base_acct_no -- 利息转入账号
    ,int_internal_key -- 利息入账账户标识符
    ,int_prod_type -- 利息转入账户产品类型
    ,judiciary_document_id -- 执法人1证件号码
    ,judiciary_document_id2 -- 执法人1证件号码2
    ,judiciary_document_type -- 执法人1证件类型
    ,judiciary_document_type2 -- 执法人1证件类型2
    ,judiciary_officer_name -- 执法人1姓名
    ,judiciary_oth_document_id -- 执法人2证件号码
    ,judiciary_oth_document_id2 -- 执法人2证件号码2
    ,judiciary_oth_document_type -- 执法人2证件类型
    ,judiciary_oth_document_type2 -- 执法人2证件类型2
    ,judiciary_oth_officer_name -- 执法人2姓名
    ,original_int -- 原计提利息
    ,original_int_adj -- 原计提调整利息
    ,oth_reference -- 对方交易参考号
    ,other_client_address -- 对方行收款人地址
    ,out_oth_acct_name -- 对方行收款人户名
    ,out_oth_base_acct_no -- 对方行收款人账户
    ,pledged_int_amt -- 冻结期间产生的利息
    ,pledged_tax_amt -- 冻结期间利息税
    ,total_amt -- 总金额
    ,tran_branch -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_impound_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_impound_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_impound_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_impound_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_impound_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_impound_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);