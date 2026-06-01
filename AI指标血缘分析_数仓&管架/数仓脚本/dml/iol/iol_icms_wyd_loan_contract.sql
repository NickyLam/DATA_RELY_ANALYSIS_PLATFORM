/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_loan_contract
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
drop table ${iol_schema}.icms_wyd_loan_contract_ex purge;
alter table ${iol_schema}.icms_wyd_loan_contract add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_loan_contract truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_loan_contract_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_loan_contract where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_loan_contract_ex(
    datadt -- 数据日期
    ,contractno -- 合同号
    ,limitno -- 额度编号
    ,orgid -- 机构号
    ,custid -- 客户号
    ,custidtype -- 客户证件类型
    ,custidno -- 客户证件号码
    ,custname -- 客户名称
    ,startdate -- 贷款合同生效日期
    ,maturitydate -- 贷款合同原始到期日
    ,enddate -- 贷款合同终止日期
    ,ccycd -- 币种
    ,loanflg -- 银（社）团贷款标志
    ,subloanflg -- 转贷款标志
    ,contractamt -- 贷款合同金额
    ,acctno -- 帐号
    ,accttype -- 账户类型
    ,enterpriseemail -- 企业电子邮箱
    ,legalemail -- 法定代表人邮箱
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,contractstatus -- 合同状态
    ,credittype -- 授信类型
    ,applytype -- 申请类型
    ,baseratetype -- 基准利率类型
    ,rateadjusttype -- 利率调整方式
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    datadt -- 数据日期
    ,contractno -- 合同号
    ,limitno -- 额度编号
    ,orgid -- 机构号
    ,custid -- 客户号
    ,custidtype -- 客户证件类型
    ,custidno -- 客户证件号码
    ,custname -- 客户名称
    ,startdate -- 贷款合同生效日期
    ,maturitydate -- 贷款合同原始到期日
    ,enddate -- 贷款合同终止日期
    ,ccycd -- 币种
    ,loanflg -- 银（社）团贷款标志
    ,subloanflg -- 转贷款标志
    ,contractamt -- 贷款合同金额
    ,acctno -- 帐号
    ,accttype -- 账户类型
    ,enterpriseemail -- 企业电子邮箱
    ,legalemail -- 法定代表人邮箱
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,contractstatus -- 合同状态
    ,credittype -- 授信类型
    ,applytype -- 申请类型
    ,baseratetype -- 基准利率类型
    ,rateadjusttype -- 利率调整方式
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_loan_contract
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_loan_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_loan_contract_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_loan_contract to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_loan_contract_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_loan_contract',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);