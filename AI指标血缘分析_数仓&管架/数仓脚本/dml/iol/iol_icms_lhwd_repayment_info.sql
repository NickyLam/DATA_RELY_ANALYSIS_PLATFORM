/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhwd_repayment_info
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
drop table ${iol_schema}.icms_lhwd_repayment_info_ex purge;
alter table ${iol_schema}.icms_lhwd_repayment_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_lhwd_repayment_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_lhwd_repayment_info_ex nologging
compress
as
select * from ${iol_schema}.icms_lhwd_repayment_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_lhwd_repayment_info_ex(
    serialno -- 流水号
    ,curdate -- 账务日期
    ,trantime -- 交易时间
    ,bdserialno -- 借据编号(第三方/行内)
    ,repayterm -- 还款期数
    ,totalamt -- 还款金额
    ,currency -- 币种
    ,lxbusinesssum -- 实还本金
    ,lxintamt -- 实还利息
    ,lxqodpamt -- 实还罚息
    ,odiamt -- 实还复利
    ,prepmtfeerepay -- 已还提前还款手续费
    ,repayaccounttype -- 还款账户类型
    ,repayaccountname -- 还款账户名
    ,repayaccountbankname -- 还款账户开户机构
    ,repayaccountno -- 还款账户编号
    ,repaymode -- 还款类型 1-正常还款 2-逾期还款 4-提前还款
    ,repayway -- 还款方式 1-线上还款 2-线下还款 3-系统扣款 9-未知
    ,receipttype -- 回收类型 1-正常回收 2-担保代偿
    ,settlementserialno -- 清算交易编号
    ,inseqno -- 内部交易流水号
    ,seqno -- 交易流水号
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,curdate -- 账务日期
    ,trantime -- 交易时间
    ,bdserialno -- 借据编号(第三方/行内)
    ,repayterm -- 还款期数
    ,totalamt -- 还款金额
    ,currency -- 币种
    ,lxbusinesssum -- 实还本金
    ,lxintamt -- 实还利息
    ,lxqodpamt -- 实还罚息
    ,odiamt -- 实还复利
    ,prepmtfeerepay -- 已还提前还款手续费
    ,repayaccounttype -- 还款账户类型
    ,repayaccountname -- 还款账户名
    ,repayaccountbankname -- 还款账户开户机构
    ,repayaccountno -- 还款账户编号
    ,repaymode -- 还款类型 1-正常还款 2-逾期还款 4-提前还款
    ,repayway -- 还款方式 1-线上还款 2-线下还款 3-系统扣款 9-未知
    ,receipttype -- 回收类型 1-正常回收 2-担保代偿
    ,settlementserialno -- 清算交易编号
    ,inseqno -- 内部交易流水号
    ,seqno -- 交易流水号
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_lhwd_repayment_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_lhwd_repayment_info exchange partition p_${batch_date} with table ${iol_schema}.icms_lhwd_repayment_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhwd_repayment_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_lhwd_repayment_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhwd_repayment_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);