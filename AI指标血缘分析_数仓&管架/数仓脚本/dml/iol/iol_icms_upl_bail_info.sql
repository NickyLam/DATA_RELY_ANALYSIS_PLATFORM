/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_upl_bail_info
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
drop table ${iol_schema}.icms_upl_bail_info_ex purge;
alter table ${iol_schema}.icms_upl_bail_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_upl_bail_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_upl_bail_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_upl_bail_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_upl_bail_info_ex(
    serialno -- 流水号
    ,customerid -- 客户编号
    ,bailsum -- 保证金可用金额
    ,bailminratio -- 保证金最低比例
    ,inputdate -- 登记日期
    ,actualuseratio -- 保证金占用比例
    ,corpno -- 合作公司编码
    ,bailsubaccount -- 保证金子户号
    ,inputuser -- 登记人
    ,bailaccountno -- 保证金账户
    ,corpname -- 客户名称
    ,paiedsum -- 保证金核心止付金额
    ,inputorg -- 登记机构
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,syndate -- 同步核心时间
    ,bailbalance -- 保证金余额
    ,usedsum -- 保证金占用金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,customerid -- 客户编号
    ,bailsum -- 保证金可用金额
    ,bailminratio -- 保证金最低比例
    ,inputdate -- 登记日期
    ,actualuseratio -- 保证金占用比例
    ,corpno -- 合作公司编码
    ,bailsubaccount -- 保证金子户号
    ,inputuser -- 登记人
    ,bailaccountno -- 保证金账户
    ,corpname -- 客户名称
    ,paiedsum -- 保证金核心止付金额
    ,inputorg -- 登记机构
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,syndate -- 同步核心时间
    ,bailbalance -- 保证金余额
    ,usedsum -- 保证金占用金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_upl_bail_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_upl_bail_info exchange partition p_${batch_date} with table ${iol_schema}.icms_upl_bail_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_upl_bail_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_upl_bail_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_upl_bail_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);