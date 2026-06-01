/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_asset_transfer_loan_detail_eso
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
drop table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso_ex purge;
alter table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso where 0=1;

insert /*+ append */ into ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso_ex(
    contractno -- 融资平台贷款合同号
    ,fundseqno -- 放款资金流水号
    ,prodcode -- 产品码
    ,name -- 客户真实姓名
    ,certtype -- 证件类型
    ,certno -- 客户证件号码
    ,loanstatus -- 贷款状态
    ,loanuse -- 贷款用途
    ,usearea -- 贷款资金使用位置
    ,applydate -- 申请支用时间
    ,encashdate -- 放款日期
    ,currency -- 币种
    ,encashamt -- 放款金额（单位分）
    ,startdate -- 贷款起息日
    ,enddate -- 贷款到期日
    ,totalterms -- 贷款期次数
    ,repaymode -- 还款方式
    ,graceday -- 宽限期天数
    ,ratetype -- 利率类型
    ,dayrate -- 贷款日利率
    ,prinrepayfrequency -- 本金还款频率
    ,intrepayfrequency -- 利息还款频率
    ,guaranteetype -- 担保类型
    ,creditno -- 授信编号
    ,encashaccttype -- 收款帐号类型
    ,encashacctname -- 收款账号户名
    ,encashacctno -- 收款帐号
    ,encashbankname -- 收款银行名称
    ,repayaccttype -- 还款帐号类型
    ,repayacctname -- 还款账号户名
    ,repayacctno -- 还款帐号
    ,repaybankname -- 还款银行名称
    ,bsntype -- 产品业务类型
    ,ipid -- 用户ID
    ,regioncode -- 行政区划代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    contractno -- 融资平台贷款合同号
    ,fundseqno -- 放款资金流水号
    ,prodcode -- 产品码
    ,name -- 客户真实姓名
    ,certtype -- 证件类型
    ,certno -- 客户证件号码
    ,loanstatus -- 贷款状态
    ,loanuse -- 贷款用途
    ,usearea -- 贷款资金使用位置
    ,applydate -- 申请支用时间
    ,encashdate -- 放款日期
    ,currency -- 币种
    ,encashamt -- 放款金额（单位分）
    ,startdate -- 贷款起息日
    ,enddate -- 贷款到期日
    ,totalterms -- 贷款期次数
    ,repaymode -- 还款方式
    ,graceday -- 宽限期天数
    ,ratetype -- 利率类型
    ,dayrate -- 贷款日利率
    ,prinrepayfrequency -- 本金还款频率
    ,intrepayfrequency -- 利息还款频率
    ,guaranteetype -- 担保类型
    ,creditno -- 授信编号
    ,encashaccttype -- 收款帐号类型
    ,encashacctname -- 收款账号户名
    ,encashacctno -- 收款帐号
    ,encashbankname -- 收款银行名称
    ,repayaccttype -- 还款帐号类型
    ,repayacctname -- 还款账号户名
    ,repayacctno -- 还款帐号
    ,repaybankname -- 还款银行名称
    ,bsntype -- 产品业务类型
    ,ipid -- 用户ID
    ,regioncode -- 行政区划代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_mybk_asset_transfer_loan_detail_eso
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_asset_transfer_loan_detail_eso',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);