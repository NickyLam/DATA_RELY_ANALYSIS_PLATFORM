/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ul_receipt_detail
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
drop table ${iol_schema}.ncbs_ul_receipt_detail_ex purge;
alter table ${iol_schema}.ncbs_ul_receipt_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_ul_receipt_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_ul_receipt_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ul_receipt_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_ul_receipt_detail_ex(
    receipt_no -- 回收号|回收号
    ,batch_no -- 批次号|批次号
    ,cmisloan_no -- 客户借据编号|客户借据编号
    ,stage_no -- 期次|期次
    ,client_no -- 客户编号|客户编号
    ,pri_amt -- 本金金额|本金金额
    ,int_amt -- 利息金额|利息金额
    ,odp_amt -- 罚息金额|罚息金额
    ,odi_amt -- 复利金额|复利金额
    ,company -- 法人|法人
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,ul_partner_reference -- 联合贷合作方交易流水号|联合贷合作方交易流水号
    ,pre_int_amt -- 还款前应收未收正常利息
    ,pre_odi_amt -- 还款前应收未收复利
    ,pre_odp_amt -- 还款前应收未收罚息
    ,pre_pri_amt -- 还款前应收未收正常本金
    ,receipt_amt -- 回收金额
    ,receipt_type -- 还款类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    receipt_no -- 回收号|回收号
    ,batch_no -- 批次号|批次号
    ,cmisloan_no -- 客户借据编号|客户借据编号
    ,stage_no -- 期次|期次
    ,client_no -- 客户编号|客户编号
    ,pri_amt -- 本金金额|本金金额
    ,int_amt -- 利息金额|利息金额
    ,odp_amt -- 罚息金额|罚息金额
    ,odi_amt -- 复利金额|复利金额
    ,company -- 法人|法人
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,ul_partner_reference -- 联合贷合作方交易流水号|联合贷合作方交易流水号
    ,pre_int_amt -- 还款前应收未收正常利息
    ,pre_odi_amt -- 还款前应收未收复利
    ,pre_odp_amt -- 还款前应收未收罚息
    ,pre_pri_amt -- 还款前应收未收正常本金
    ,receipt_amt -- 回收金额
    ,receipt_type -- 还款类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_ul_receipt_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_ul_receipt_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ul_receipt_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ul_receipt_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_ul_receipt_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ul_receipt_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);