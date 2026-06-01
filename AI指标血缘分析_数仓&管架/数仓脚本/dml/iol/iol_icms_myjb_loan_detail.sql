/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myjb_loan_detail
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
drop table ${iol_schema}.icms_myjb_loan_detail_ex purge;
alter table ${iol_schema}.icms_myjb_loan_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_myjb_loan_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_myjb_loan_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myjb_loan_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_myjb_loan_detail_ex(
    contract_no -- 借据号
    ,credit_no -- 授信编号
    ,encash_acct_type -- 收款帐号类型，01:银行借记卡02:支付宝
    ,guarantee_type -- 担保类型
    ,apply_no -- 贷款申请单号，和贷款合同号一一对应，根据这个单号可以到指定的合同文本文件目录下获取对应的文件
    ,name -- 客户真实姓名
    ,grace_day -- 宽限期天数
    ,prin_repay_frequency -- 本金还款频率
    ,encash_date -- 放款日期
    ,fund_seq_no -- 放款资金流水号
    ,start_date -- 贷款起息日
    ,encash_acct_no -- 收款帐号
    ,end_date -- 贷款到期日
    ,rate_type -- 利率类型
    ,repay_acct_type -- 还款帐号类型，01:银行借记卡02:支付宝03:网商二类户
    ,repay_acct_no -- 还款帐号
    ,loan_status -- 贷款状态1:成功2:失败3:在途
    ,apply_date -- 申请支用时间
    ,encash_amt -- 放款金额（单位分）
    ,cert_no -- 客户证件号码
    ,use_area -- 贷款资金使用位置
    ,int_repay_frequency -- 利息还款频率
    ,currency -- 币种，默认为CNY
    ,day_rate -- 贷款日利率，保留6位小数
    ,cert_type -- 证件类型
    ,loan_use -- 贷款用途
    ,repay_mode -- 还款方式，1:等额本息2:等额本金
    ,total_terms -- 贷款期次数
    ,prod_code -- 产品码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    contract_no -- 借据号
    ,credit_no -- 授信编号
    ,encash_acct_type -- 收款帐号类型，01:银行借记卡02:支付宝
    ,guarantee_type -- 担保类型
    ,apply_no -- 贷款申请单号，和贷款合同号一一对应，根据这个单号可以到指定的合同文本文件目录下获取对应的文件
    ,name -- 客户真实姓名
    ,grace_day -- 宽限期天数
    ,prin_repay_frequency -- 本金还款频率
    ,encash_date -- 放款日期
    ,fund_seq_no -- 放款资金流水号
    ,start_date -- 贷款起息日
    ,encash_acct_no -- 收款帐号
    ,end_date -- 贷款到期日
    ,rate_type -- 利率类型
    ,repay_acct_type -- 还款帐号类型，01:银行借记卡02:支付宝03:网商二类户
    ,repay_acct_no -- 还款帐号
    ,loan_status -- 贷款状态1:成功2:失败3:在途
    ,apply_date -- 申请支用时间
    ,encash_amt -- 放款金额（单位分）
    ,cert_no -- 客户证件号码
    ,use_area -- 贷款资金使用位置
    ,int_repay_frequency -- 利息还款频率
    ,currency -- 币种，默认为CNY
    ,day_rate -- 贷款日利率，保留6位小数
    ,cert_type -- 证件类型
    ,loan_use -- 贷款用途
    ,repay_mode -- 还款方式，1:等额本息2:等额本金
    ,total_terms -- 贷款期次数
    ,prod_code -- 产品码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_myjb_loan_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_myjb_loan_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_myjb_loan_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myjb_loan_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_myjb_loan_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myjb_loan_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);