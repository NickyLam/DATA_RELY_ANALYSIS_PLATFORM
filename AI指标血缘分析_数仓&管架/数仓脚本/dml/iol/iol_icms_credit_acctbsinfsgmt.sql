/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_credit_acctbsinfsgmt
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
drop table ${iol_schema}.icms_credit_acctbsinfsgmt_ex purge;
alter table ${iol_schema}.icms_credit_acctbsinfsgmt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_credit_acctbsinfsgmt;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_credit_acctbsinfsgmt_ex nologging
compress
as
select * from ${iol_schema}.icms_credit_acctbsinfsgmt where 0=1;

insert /*+ append */ into ${iol_schema}.icms_credit_acctbsinfsgmt_ex(
    acctcode -- 账户标识码
    ,loanform -- 贷款发放形式
    ,busilines -- 借贷业务大类
    ,loanamt -- 借款金额
    ,guarmode -- 担保方式
    ,rptdate -- 信息报告日期
    ,flag -- 分次放款标志
    ,assettrandflag -- 资产转让标志
    ,loanconcode -- 贷款合同编号
    ,duedate -- 到期日期
    ,firsthouloanflag -- 是否为首套住房贷款
    ,create_time -- 入库时间
    ,deptcode -- 征信机构代码
    ,creditid -- 卡片标识号
    ,busidtllines -- 借贷业务种类细分
    ,applybusidist -- 业务申请地行政区划代码
    ,acctcredline -- 信用额度
    ,ccy -- 币种
    ,othrepyguarway -- 其他还款保证方式
    ,repaymode -- 还款方式
    ,repayfreqcy -- 还款频率
    ,opendate -- 开户日期
    ,repayprd -- 还款期数
    ,fundsou -- 业务经营类型
    ,top_deptcode -- 顶级征信机构代码
    ,cust_no -- 客户号码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acctcode -- 账户标识码
    ,loanform -- 贷款发放形式
    ,busilines -- 借贷业务大类
    ,loanamt -- 借款金额
    ,guarmode -- 担保方式
    ,rptdate -- 信息报告日期
    ,flag -- 分次放款标志
    ,assettrandflag -- 资产转让标志
    ,loanconcode -- 贷款合同编号
    ,duedate -- 到期日期
    ,firsthouloanflag -- 是否为首套住房贷款
    ,create_time -- 入库时间
    ,deptcode -- 征信机构代码
    ,creditid -- 卡片标识号
    ,busidtllines -- 借贷业务种类细分
    ,applybusidist -- 业务申请地行政区划代码
    ,acctcredline -- 信用额度
    ,ccy -- 币种
    ,othrepyguarway -- 其他还款保证方式
    ,repaymode -- 还款方式
    ,repayfreqcy -- 还款频率
    ,opendate -- 开户日期
    ,repayprd -- 还款期数
    ,fundsou -- 业务经营类型
    ,top_deptcode -- 顶级征信机构代码
    ,cust_no -- 客户号码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_credit_acctbsinfsgmt
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_credit_acctbsinfsgmt exchange partition p_${batch_date} with table ${iol_schema}.icms_credit_acctbsinfsgmt_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_credit_acctbsinfsgmt to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_credit_acctbsinfsgmt_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_credit_acctbsinfsgmt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);