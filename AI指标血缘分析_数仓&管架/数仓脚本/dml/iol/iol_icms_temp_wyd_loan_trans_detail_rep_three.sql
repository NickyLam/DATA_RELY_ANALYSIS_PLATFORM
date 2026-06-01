/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_temp_wyd_loan_trans_detail_rep_three
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
drop table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three_ex purge;
alter table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three_ex nologging
compress
as
select * from ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three where 0=1;

insert /*+ append */ into ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three_ex(
    orgid -- 机构号
    ,serialno -- 交易流水号
    ,oldtransserialno -- 原交易流水号
    ,bizseq -- 业务流水号
    ,txndate -- 交易日期
    ,loanno -- 借据号
    ,currency -- 币种
    ,txncode -- 交易码
    ,txndesc -- 交易描述
    ,postamt -- 交易金额
    ,txntime -- 交易时间
    ,postdate -- 入账日期
    ,youracctno -- 对方账号
    ,youracctname -- 对方户名
    ,yourbankid -- 对方行号
    ,transflag -- 冲补抹标志
    ,payeeacct -- 收款人账号
    ,payeename -- 收款人名称
    ,payeebrno -- 收款人开户行行号
    ,payeebrname -- 收款人开户行名称
    ,settleid -- 还款清算交易编号
    ,accttype -- 账户类型
    ,capitaltransserialno -- 资金交易关联流水
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    orgid -- 机构号
    ,serialno -- 交易流水号
    ,oldtransserialno -- 原交易流水号
    ,bizseq -- 业务流水号
    ,txndate -- 交易日期
    ,loanno -- 借据号
    ,currency -- 币种
    ,txncode -- 交易码
    ,txndesc -- 交易描述
    ,postamt -- 交易金额
    ,txntime -- 交易时间
    ,postdate -- 入账日期
    ,youracctno -- 对方账号
    ,youracctname -- 对方户名
    ,yourbankid -- 对方行号
    ,transflag -- 冲补抹标志
    ,payeeacct -- 收款人账号
    ,payeename -- 收款人名称
    ,payeebrno -- 收款人开户行行号
    ,payeebrname -- 收款人开户行名称
    ,settleid -- 还款清算交易编号
    ,accttype -- 账户类型
    ,capitaltransserialno -- 资金交易关联流水
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_temp_wyd_loan_trans_detail_rep_three
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three exchange partition p_${batch_date} with table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_temp_wyd_loan_trans_detail_rep_three',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);