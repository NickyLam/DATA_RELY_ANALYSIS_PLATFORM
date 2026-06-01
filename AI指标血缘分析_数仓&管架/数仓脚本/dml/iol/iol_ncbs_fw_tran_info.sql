/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fw_tran_info
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
drop table ${iol_schema}.ncbs_fw_tran_info_ex purge;
alter table ${iol_schema}.ncbs_fw_tran_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_fw_tran_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_fw_tran_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fw_tran_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_fw_tran_info_ex(
    service_id -- 服务ID
    ,service_no -- 服务唯一识别号
    ,tran_date -- 交易日期
    ,tran_time -- 交易时间
    ,in_msg -- 输入报文
    ,out_msg -- 输出报文
    ,response_type -- 输出响应类型
    ,end_time -- 交易完成时间
    ,source_type -- 渠道类型
    ,seq_no -- 渠道流水号
    ,program_id -- 交易屏幕标识
    ,status -- 状态
    ,reference -- 业务参考号
    ,platform_id -- 平台流水号
    ,user_id -- 操作柜员
    ,ip_address -- IP地址
    ,branch_id -- 网点
    ,compensate_service_no -- 待补偿原交易唯一识别号
    ,week_day -- 日期
    ,create_date -- 记录创建日期
    ,bus_seq_no -- 业务流水号
    ,run_date -- 会计日期
    ,inner_service_flag -- 内部服务标识（Y:是，N:否）
    ,gl_posted_flag -- 过账标记
    ,acct_no -- 账号
    ,acct_seq_no -- 子序号
    ,tran_amt -- 交易金额
    ,ccy -- 交易币种
    ,auth_user_id -- 授权柜员
    ,oth_acct_no -- 对手账号
    ,oth_acct_seq_no -- 对手子序号
    ,voucher_no -- 开户凭证
    ,doc_type -- 开户凭证类型
    ,prefix -- 开户凭证前缀
    ,cheque_voucher_no -- 支票凭证
    ,cheque_doc_type -- 支票凭证类型
    ,cheque_prefix -- 支票凭证前缀
    ,remark -- 附言
    ,tran_name -- 交易名称
    ,inner_flag -- 内部调用标识，Y-是；N-否
    ,source_model -- 源模块
    ,base_acct_no -- 卡号
    ,sub_seq_no -- 子流水号
    ,financial_flag -- 金融标志: Y-是，N-否
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    service_id -- 服务ID
    ,service_no -- 服务唯一识别号
    ,tran_date -- 交易日期
    ,tran_time -- 交易时间
    ,in_msg -- 输入报文
    ,out_msg -- 输出报文
    ,response_type -- 输出响应类型
    ,end_time -- 交易完成时间
    ,source_type -- 渠道类型
    ,seq_no -- 渠道流水号
    ,program_id -- 交易屏幕标识
    ,status -- 状态
    ,reference -- 业务参考号
    ,platform_id -- 平台流水号
    ,user_id -- 操作柜员
    ,ip_address -- IP地址
    ,branch_id -- 网点
    ,compensate_service_no -- 待补偿原交易唯一识别号
    ,week_day -- 日期
    ,create_date -- 记录创建日期
    ,bus_seq_no -- 业务流水号
    ,run_date -- 会计日期
    ,inner_service_flag -- 内部服务标识（Y:是，N:否）
    ,gl_posted_flag -- 过账标记
    ,acct_no -- 账号
    ,acct_seq_no -- 子序号
    ,tran_amt -- 交易金额
    ,ccy -- 交易币种
    ,auth_user_id -- 授权柜员
    ,oth_acct_no -- 对手账号
    ,oth_acct_seq_no -- 对手子序号
    ,voucher_no -- 开户凭证
    ,doc_type -- 开户凭证类型
    ,prefix -- 开户凭证前缀
    ,cheque_voucher_no -- 支票凭证
    ,cheque_doc_type -- 支票凭证类型
    ,cheque_prefix -- 支票凭证前缀
    ,remark -- 附言
    ,tran_name -- 交易名称
    ,inner_flag -- 内部调用标识，Y-是；N-否
    ,source_model -- 源模块
    ,base_acct_no -- 卡号
    ,sub_seq_no -- 子流水号
    ,financial_flag -- 金融标志: Y-是，N-否
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_fw_tran_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_fw_tran_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fw_tran_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fw_tran_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_fw_tran_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fw_tran_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);