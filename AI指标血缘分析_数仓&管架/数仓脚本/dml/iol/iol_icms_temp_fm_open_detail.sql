/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_temp_fm_open_detail
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
drop table ${iol_schema}.icms_temp_fm_open_detail_ex purge;
alter table ${iol_schema}.icms_temp_fm_open_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_temp_fm_open_detail;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_temp_fm_open_detail_ex nologging
compress
as
select * from ${iol_schema}.icms_temp_fm_open_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_temp_fm_open_detail_ex(
    loan_approval_no -- 借款审批流水号
    ,business_date -- 业务日期 若8号发生，9号推送，则该业务日期为8号 yyyyMMdd
    ,loan_id -- 借据号
    ,cust_name -- 客户姓名
    ,cert_type -- 证件类型 01--身份证 02--营业执照
    ,cert_no -- 证件号
    ,borrower_account_number -- 借款人账户
    ,borrower_account_name -- 借款人姓名
    ,bank_name -- 银行卡开户行名称
    ,trans_time -- 交易时间 yyyyMMddHHmmss
    ,settlement_serial_no -- 清算交易编号
    ,apply_date -- 申请日期
    ,start_date -- 开始日期
    ,end_date -- 到期日期
    ,loan_amt -- 放款金额
    ,loan_status -- 放款状态 00-放款成功
    ,repay_way -- 还款方式 01--等额本息
    ,grace_day -- 宽限期
    ,int_rate -- 利息利率 百分比 1.80000000
    ,pri_rate -- 罚息利率 百分比 1.80000000
    ,cin_rate -- 复利利率 百分比 1.80000000
    ,asset_identification -- 资产标识
    ,finance_type -- 资产类型  1-联合出资 2-机构全资
    ,fund_loan_rate -- 出资比例 百分比 0.70000000
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    loan_approval_no -- 借款审批流水号
    ,business_date -- 业务日期 若8号发生，9号推送，则该业务日期为8号 yyyyMMdd
    ,loan_id -- 借据号
    ,cust_name -- 客户姓名
    ,cert_type -- 证件类型 01--身份证 02--营业执照
    ,cert_no -- 证件号
    ,borrower_account_number -- 借款人账户
    ,borrower_account_name -- 借款人姓名
    ,bank_name -- 银行卡开户行名称
    ,trans_time -- 交易时间 yyyyMMddHHmmss
    ,settlement_serial_no -- 清算交易编号
    ,apply_date -- 申请日期
    ,start_date -- 开始日期
    ,end_date -- 到期日期
    ,loan_amt -- 放款金额
    ,loan_status -- 放款状态 00-放款成功
    ,repay_way -- 还款方式 01--等额本息
    ,grace_day -- 宽限期
    ,int_rate -- 利息利率 百分比 1.80000000
    ,pri_rate -- 罚息利率 百分比 1.80000000
    ,cin_rate -- 复利利率 百分比 1.80000000
    ,asset_identification -- 资产标识
    ,finance_type -- 资产类型  1-联合出资 2-机构全资
    ,fund_loan_rate -- 出资比例 百分比 0.70000000
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_temp_fm_open_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_temp_fm_open_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_temp_fm_open_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_temp_fm_open_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_temp_fm_open_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_temp_fm_open_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);