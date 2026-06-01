/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_supplychainfinance_list
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
drop table ${iol_schema}.icms_supplychainfinance_list_ex purge;
alter table ${iol_schema}.icms_supplychainfinance_list add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_supplychainfinance_list;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_supplychainfinance_list_ex nologging
compress
as
select * from ${iol_schema}.icms_supplychainfinance_list where 0=1;

insert /*+ append */ into ${iol_schema}.icms_supplychainfinance_list_ex(
    operatebranchorgid -- 经办分行
    ,balance -- 出账金额
    ,coreenterprisename -- 对应核心企业名称
    ,totalsum -- 敞口金额
    ,customername -- 借款人名称
    ,maturity -- 业务到期日
    ,contractserialno -- 业务合同流水号
    ,putoutdate -- 业务起始日
    ,migtflag -- 
    ,commissionrate -- 手续费率
    ,supplychainfinancetype -- 供应链金融业务品种
    ,businesssum -- 合同金额
    ,additionalbailsum -- 追加保证金
    ,inputdate -- 数据记入日期
    ,initbailsum -- 初始化保证金
    ,businessrate -- 融资利率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    operatebranchorgid -- 经办分行
    ,balance -- 出账金额
    ,coreenterprisename -- 对应核心企业名称
    ,totalsum -- 敞口金额
    ,customername -- 借款人名称
    ,maturity -- 业务到期日
    ,contractserialno -- 业务合同流水号
    ,putoutdate -- 业务起始日
    ,migtflag -- 
    ,commissionrate -- 手续费率
    ,supplychainfinancetype -- 供应链金融业务品种
    ,businesssum -- 合同金额
    ,additionalbailsum -- 追加保证金
    ,inputdate -- 数据记入日期
    ,initbailsum -- 初始化保证金
    ,businessrate -- 融资利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_supplychainfinance_list
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_supplychainfinance_list exchange partition p_${batch_date} with table ${iol_schema}.icms_supplychainfinance_list_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_supplychainfinance_list to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_supplychainfinance_list_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_supplychainfinance_list',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);