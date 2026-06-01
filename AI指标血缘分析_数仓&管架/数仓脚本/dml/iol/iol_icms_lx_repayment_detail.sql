/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lx_repayment_detail
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
drop table ${iol_schema}.icms_lx_repayment_detail_ex purge;
alter table ${iol_schema}.icms_lx_repayment_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_lx_repayment_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_lx_repayment_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_repayment_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_lx_repayment_detail_ex(
    assetid -- 资产号
    ,capitalloanno -- 借据号
    ,repayterm -- 还款期数
    ,repaymenttype -- 还款类型
    ,settledate -- 结算日
    ,realamounttotal -- 实还金额总额
    ,lxbusinesssum -- 实还本金
    ,lxintamt -- 实还利息
    ,lxqodpamt -- 实还罚息
    ,guarantyfee -- 担保费
    ,simulationfee -- 咨询服务费
    ,creditassessfee -- 信用评估费
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,repaymentacctype -- 还款账户类型
    ,repayacctno -- 还款账户号
    ,currency -- 币种
    ,repaydate -- 还款日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    assetid -- 资产号
    ,capitalloanno -- 借据号
    ,repayterm -- 还款期数
    ,repaymenttype -- 还款类型
    ,settledate -- 结算日
    ,realamounttotal -- 实还金额总额
    ,lxbusinesssum -- 实还本金
    ,lxintamt -- 实还利息
    ,lxqodpamt -- 实还罚息
    ,guarantyfee -- 担保费
    ,simulationfee -- 咨询服务费
    ,creditassessfee -- 信用评估费
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,repaymentacctype -- 还款账户类型
    ,repayacctno -- 还款账户号
    ,currency -- 币种
    ,repaydate -- 还款日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_lx_repayment_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_lx_repayment_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_lx_repayment_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lx_repayment_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_lx_repayment_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lx_repayment_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);