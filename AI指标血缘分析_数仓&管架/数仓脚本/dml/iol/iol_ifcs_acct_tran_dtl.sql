/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_acct_tran_dtl
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
drop table ${iol_schema}.ifcs_acct_tran_dtl_ex purge;
alter table ${iol_schema}.ifcs_acct_tran_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifcs_acct_tran_dtl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_acct_tran_dtl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_acct_tran_dtl where 0=1;

insert /*+ append */ into ${iol_schema}.ifcs_acct_tran_dtl_ex(
    tran_flow_num -- 交易流水号
    ,acct_id -- 账户编号
    ,dep_prod_sub_acct_id -- 存款子户编号
    ,cust_id -- 客户编号
    ,ext_prod_id -- 外部产品代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_type_cd -- 交易类型
    ,tran_chn_cd -- 交易渠道编号
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,call_sys_id -- 调用系统编号
    ,ext_flow_num -- 外部流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tran_flow_num -- 交易流水号
    ,acct_id -- 账户编号
    ,dep_prod_sub_acct_id -- 存款子户编号
    ,cust_id -- 客户编号
    ,ext_prod_id -- 外部产品代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_type_cd -- 交易类型
    ,tran_chn_cd -- 交易渠道编号
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,call_sys_id -- 调用系统编号
    ,ext_flow_num -- 外部流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_acct_tran_dtl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_acct_tran_dtl exchange partition p_${batch_date} with table ${iol_schema}.ifcs_acct_tran_dtl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_acct_tran_dtl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_acct_tran_dtl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_acct_tran_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);