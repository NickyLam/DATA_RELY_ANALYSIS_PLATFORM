/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myhb_bill_loan_detail
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
drop table ${iol_schema}.icms_myhb_bill_loan_detail_ex purge;
alter table ${iol_schema}.icms_myhb_bill_loan_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_myhb_bill_loan_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_myhb_bill_loan_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myhb_bill_loan_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_myhb_bill_loan_detail_ex(
    contractno -- 借据号
    ,fundseqno -- 放款资金流水号
    ,loanuse -- 贷款用途
    ,applydate -- 申请支用时间
    ,dayrate -- 贷款日利率
    ,intrepayfrequency -- 利息还款频率
    ,totalterms -- 贷款期次数
    ,graceday -- 宽限期天数
    ,totalfeerate -- 分期总手续费率
    ,usearea -- 贷款资金使用位置
    ,enddate -- 贷款到期日
    ,ratetype -- 利率类型
    ,repayaccttype -- 还款帐号类型
    ,applyno -- 贷款申请单号
    ,encashaccttype -- 收款帐号类型
    ,regioncode -- 行政区划代码
    ,internaltransfertag -- 内部结转标识
    ,repaymode -- 还款方式
    ,guaranteetype -- 担保类型
    ,contracttype -- 借据类型
    ,creditcode -- 额度类型
    ,name -- 客户真实姓名
    ,encashdate -- 放款日期
    ,prodcode -- 产品码
    ,certno -- 客户证件号码
    ,startdate -- 贷款起息日
    ,encashacctno -- 收款帐号
    ,prinrepayfrequency -- 本金还款频率
    ,agreementno -- 贷款合同号
    ,certtype -- 证件类型
    ,currency -- 币种
    ,encashamt -- 放款金额
    ,creditno -- 授信编号
    ,repayacctno -- 还款帐号
    ,loanstatus -- 贷款状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    contractno -- 借据号
    ,fundseqno -- 放款资金流水号
    ,loanuse -- 贷款用途
    ,applydate -- 申请支用时间
    ,dayrate -- 贷款日利率
    ,intrepayfrequency -- 利息还款频率
    ,totalterms -- 贷款期次数
    ,graceday -- 宽限期天数
    ,totalfeerate -- 分期总手续费率
    ,usearea -- 贷款资金使用位置
    ,enddate -- 贷款到期日
    ,ratetype -- 利率类型
    ,repayaccttype -- 还款帐号类型
    ,applyno -- 贷款申请单号
    ,encashaccttype -- 收款帐号类型
    ,regioncode -- 行政区划代码
    ,internaltransfertag -- 内部结转标识
    ,repaymode -- 还款方式
    ,guaranteetype -- 担保类型
    ,contracttype -- 借据类型
    ,creditcode -- 额度类型
    ,name -- 客户真实姓名
    ,encashdate -- 放款日期
    ,prodcode -- 产品码
    ,certno -- 客户证件号码
    ,startdate -- 贷款起息日
    ,encashacctno -- 收款帐号
    ,prinrepayfrequency -- 本金还款频率
    ,agreementno -- 贷款合同号
    ,certtype -- 证件类型
    ,currency -- 币种
    ,encashamt -- 放款金额
    ,creditno -- 授信编号
    ,repayacctno -- 还款帐号
    ,loanstatus -- 贷款状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_myhb_bill_loan_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_myhb_bill_loan_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_myhb_bill_loan_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myhb_bill_loan_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_myhb_bill_loan_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myhb_bill_loan_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);