/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ds_loan_writeoff_list_success
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
drop table ${iol_schema}.icms_ds_loan_writeoff_list_success_ex purge;
alter table ${iol_schema}.icms_ds_loan_writeoff_list_success add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_ds_loan_writeoff_list_success truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_ds_loan_writeoff_list_success_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ds_loan_writeoff_list_success where 0=1;

insert /*+ append */ into ${iol_schema}.icms_ds_loan_writeoff_list_success_ex(
    writeoffdate -- 核销日期
    ,name -- 姓名
    ,custid -- 客户号
    ,bankno -- 银行号
    ,bankgroupid -- 参贷方案号
    ,productcd -- 产品号
    ,logicalcardno -- 卡号
    ,refnbr -- 参考号
    ,writeoffprocstatus -- 核销状态
    ,loaninitprin -- 本金
    ,loanintrpenalty -- 利息罚息
    ,bankproportion -- 参贷方案比例
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    writeoffdate -- 核销日期
    ,name -- 姓名
    ,custid -- 客户号
    ,bankno -- 银行号
    ,bankgroupid -- 参贷方案号
    ,productcd -- 产品号
    ,logicalcardno -- 卡号
    ,refnbr -- 参考号
    ,writeoffprocstatus -- 核销状态
    ,loaninitprin -- 本金
    ,loanintrpenalty -- 利息罚息
    ,bankproportion -- 参贷方案比例
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_ds_loan_writeoff_list_success
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_ds_loan_writeoff_list_success exchange partition p_${batch_date} with table ${iol_schema}.icms_ds_loan_writeoff_list_success_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ds_loan_writeoff_list_success to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_ds_loan_writeoff_list_success_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ds_loan_writeoff_list_success',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);