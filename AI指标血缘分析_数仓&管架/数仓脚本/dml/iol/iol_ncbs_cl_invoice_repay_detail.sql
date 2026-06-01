/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_invoice_repay_detail
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
drop table ${iol_schema}.ncbs_cl_invoice_repay_detail_ex purge;
alter table ${iol_schema}.ncbs_cl_invoice_repay_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_invoice_repay_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_invoice_repay_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_invoice_repay_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_invoice_repay_detail_ex(
    amt_type -- 金额类型
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,invoice_tran_no -- 通知单号
    ,pay_from_seq_no -- 应还明细序号
    ,receipt_no -- 回收号
    ,repay_seq_no -- 已还明细序号
    ,reversal -- 是否冲正标志
    ,last_change_date -- 最后修改日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,paid_amt -- 已还金额
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_internal_key -- 结算账户标志符
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_base_acct_no -- 结算账号
    ,settle_prod_type -- 结算账户产品类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    amt_type -- 金额类型
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,invoice_tran_no -- 通知单号
    ,pay_from_seq_no -- 应还明细序号
    ,receipt_no -- 回收号
    ,repay_seq_no -- 已还明细序号
    ,reversal -- 是否冲正标志
    ,last_change_date -- 最后修改日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,paid_amt -- 已还金额
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_internal_key -- 结算账户标志符
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_base_acct_no -- 结算账号
    ,settle_prod_type -- 结算账户产品类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_invoice_repay_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_invoice_repay_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_invoice_repay_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_invoice_repay_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_invoice_repay_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_invoice_repay_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);