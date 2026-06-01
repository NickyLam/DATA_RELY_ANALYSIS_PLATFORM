/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myhb_repay_detail
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
drop table ${iol_schema}.icms_myhb_repay_detail_ex purge;
alter table ${iol_schema}.icms_myhb_repay_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_myhb_repay_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_myhb_repay_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myhb_repay_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_myhb_repay_detail_ex(
    contractno -- 花呗平台贷款合同号
    ,seqno -- 还款流水号
    ,repaytype -- 还款类型
    ,accruedstatus -- 应计非应计标识
    ,contracttype -- 借据类型
    ,repayamt -- 总金额
    ,writeoff -- 核销标识，已核销为Y，否则为N
    ,repaydate -- 还款日期
    ,paidovdprinamt -- 本次实还逾期本金金额
    ,paidovdintpnltamt -- 本次实还逾期利息罚息金额
    ,paidintamt -- 本次实还正常利息金额
    ,paidovdintamt -- 本次实还逾期利息金额
    ,regioncode -- 行政区划代码
    ,migtflag -- 
    ,paidprinamt -- 本次实还正常本金金额
    ,creditcode -- 额度类型
    ,paidovdprinpnltamt -- 本次实还逾期本金罚息金额
    ,feeamt -- 本次还款对应的平台服务费金额
    ,internaltransfertag -- 内部结转标识
    ,feerate -- 本次还款对应的平台服务费比例
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    contractno -- 花呗平台贷款合同号
    ,seqno -- 还款流水号
    ,repaytype -- 还款类型
    ,accruedstatus -- 应计非应计标识
    ,contracttype -- 借据类型
    ,repayamt -- 总金额
    ,writeoff -- 核销标识，已核销为Y，否则为N
    ,repaydate -- 还款日期
    ,paidovdprinamt -- 本次实还逾期本金金额
    ,paidovdintpnltamt -- 本次实还逾期利息罚息金额
    ,paidintamt -- 本次实还正常利息金额
    ,paidovdintamt -- 本次实还逾期利息金额
    ,regioncode -- 行政区划代码
    ,migtflag -- 
    ,paidprinamt -- 本次实还正常本金金额
    ,creditcode -- 额度类型
    ,paidovdprinpnltamt -- 本次实还逾期本金罚息金额
    ,feeamt -- 本次还款对应的平台服务费金额
    ,internaltransfertag -- 内部结转标识
    ,feerate -- 本次还款对应的平台服务费比例
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_myhb_repay_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_myhb_repay_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_myhb_repay_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myhb_repay_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_myhb_repay_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myhb_repay_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);