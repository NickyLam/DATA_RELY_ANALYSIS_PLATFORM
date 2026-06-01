/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_channel_tran_hist
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
drop table ${iol_schema}.ncbs_cl_channel_tran_hist_ex purge;
alter table ${iol_schema}.ncbs_cl_channel_tran_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_channel_tran_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_channel_tran_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_channel_tran_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_channel_tran_hist_ex(
    acct_name -- 账户名称
    ,branch -- 机构编号
    ,ccy -- 币种
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,collate_flag -- 对账标识
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,error_desc -- 错误描述
    ,error_no -- 错误编号
    ,narrative -- 摘要
    ,prefix -- 前缀
    ,reversed_flag -- 是否撤销标志
    ,seq_no -- 序号
    ,source_type -- 渠道编号
    ,tran_status -- 冲补抹标志
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,book_branch -- 贷款银行
    ,gl_branch -- 总账机构
    ,loan_no -- 贷款号
    ,oth_acct_name -- 对方账户名称
    ,oth_acct_no -- 对方账号
    ,settle_branch -- 清算机构
    ,tran_amt -- 交易金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_name -- 账户名称
    ,branch -- 机构编号
    ,ccy -- 币种
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,collate_flag -- 对账标识
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,error_desc -- 错误描述
    ,error_no -- 错误编号
    ,narrative -- 摘要
    ,prefix -- 前缀
    ,reversed_flag -- 是否撤销标志
    ,seq_no -- 序号
    ,source_type -- 渠道编号
    ,tran_status -- 冲补抹标志
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,book_branch -- 贷款银行
    ,gl_branch -- 总账机构
    ,loan_no -- 贷款号
    ,oth_acct_name -- 对方账户名称
    ,oth_acct_no -- 对方账号
    ,settle_branch -- 清算机构
    ,tran_amt -- 交易金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_channel_tran_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_channel_tran_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_channel_tran_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_channel_tran_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_channel_tran_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_channel_tran_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);