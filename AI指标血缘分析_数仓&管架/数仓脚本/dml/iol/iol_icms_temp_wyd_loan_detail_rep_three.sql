/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_temp_wyd_loan_detail_rep_three
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
drop table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three_ex purge;
alter table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three_ex nologging
compress
as
select * from ${iol_schema}.icms_temp_wyd_loan_detail_rep_three where 0=1;

insert /*+ append */ into ${iol_schema}.icms_temp_wyd_loan_detail_rep_three_ex(
    ietmcd -- 科目号
    ,orgid -- 机构号
    ,loanno -- 主借据号
    ,contractno -- 合同编号
    ,applyno -- 申请号
    ,ccif -- 客户号
    ,loanpurpose -- 投向行业
    ,startdate -- 发放日期
    ,maturitydate -- 到期日期
    ,schmaturitydate -- 约定到期日期
    ,graceperiod -- 宽限期
    ,rate -- 执行利率
    ,baserate -- 基准利率
    ,currency -- 币种
    ,amount -- 发放金额
    ,balance -- 贷款余额
    ,paymentfeq -- 还款频率
    ,payway -- 支付方式
    ,repricingdate -- 下一利率重定价日
    ,ratetype -- 利率类型
    ,overduedays -- 逾期天数
    ,interest -- 应收利息
    ,prinoddate -- 本金逾期日期
    ,prinodamt -- 欠本金额
    ,intoddate -- 利息逾期日期
    ,intodamt -- 欠息金额
    ,poverdueamt -- 逾期总金额
    ,pcanceldate -- 撤销日期
    ,pinitterm -- 总期数
    ,activatedate -- 入账日期
    ,pcurrterm -- 当前期数
    ,paidoutdate -- 结清日期
    ,extensionflg -- 是否展期
    ,extensionamt -- 展期金额
    ,extensionstart -- 展期起始日期
    ,extensionmaturity -- 展期到期日期
    ,recomflg -- 是否重组贷款
    ,recomdate -- 重组日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ietmcd -- 科目号
    ,orgid -- 机构号
    ,loanno -- 主借据号
    ,contractno -- 合同编号
    ,applyno -- 申请号
    ,ccif -- 客户号
    ,loanpurpose -- 投向行业
    ,startdate -- 发放日期
    ,maturitydate -- 到期日期
    ,schmaturitydate -- 约定到期日期
    ,graceperiod -- 宽限期
    ,rate -- 执行利率
    ,baserate -- 基准利率
    ,currency -- 币种
    ,amount -- 发放金额
    ,balance -- 贷款余额
    ,paymentfeq -- 还款频率
    ,payway -- 支付方式
    ,repricingdate -- 下一利率重定价日
    ,ratetype -- 利率类型
    ,overduedays -- 逾期天数
    ,interest -- 应收利息
    ,prinoddate -- 本金逾期日期
    ,prinodamt -- 欠本金额
    ,intoddate -- 利息逾期日期
    ,intodamt -- 欠息金额
    ,poverdueamt -- 逾期总金额
    ,pcanceldate -- 撤销日期
    ,pinitterm -- 总期数
    ,activatedate -- 入账日期
    ,pcurrterm -- 当前期数
    ,paidoutdate -- 结清日期
    ,extensionflg -- 是否展期
    ,extensionamt -- 展期金额
    ,extensionstart -- 展期起始日期
    ,extensionmaturity -- 展期到期日期
    ,recomflg -- 是否重组贷款
    ,recomdate -- 重组日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_temp_wyd_loan_detail_rep_three
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three exchange partition p_${batch_date} with table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_temp_wyd_loan_detail_rep_three to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_temp_wyd_loan_detail_rep_three_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_temp_wyd_loan_detail_rep_three',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);