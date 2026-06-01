/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_voucher_journal
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
drop table ${iol_schema}.ncbs_rb_voucher_journal_ex purge;
alter table ${iol_schema}.ncbs_rb_voucher_journal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_voucher_journal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_voucher_journal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_voucher_journal where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_voucher_journal_ex(
    amount -- 金额
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,voucher_status -- 凭证状态
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,module_id -- 模块
    ,old_status -- 凭证原状态
    ,prefix -- 前缀
    ,program_id -- 交易代码
    ,source_type -- 渠道编号
    ,tran_desc -- 交易描述
    ,voucher_journal_id -- 凭证流水id
    ,bill_date -- 本票兑付出票日
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,check_user_id -- 检查柜员
    ,tran_branch -- 核心交易机构编号
    ,can_reason_code -- 作废原因
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    amount -- 金额
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,voucher_status -- 凭证状态
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,module_id -- 模块
    ,old_status -- 凭证原状态
    ,prefix -- 前缀
    ,program_id -- 交易代码
    ,source_type -- 渠道编号
    ,tran_desc -- 交易描述
    ,voucher_journal_id -- 凭证流水id
    ,bill_date -- 本票兑付出票日
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,check_user_id -- 检查柜员
    ,tran_branch -- 核心交易机构编号
    ,can_reason_code -- 作废原因
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_voucher_journal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_voucher_journal exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_voucher_journal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_voucher_journal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_voucher_journal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_voucher_journal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);