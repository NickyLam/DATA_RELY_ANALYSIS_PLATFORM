/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_b_c_relation_history
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
drop table ${iol_schema}.icms_cl_b_c_relation_history_ex purge;
alter table ${iol_schema}.icms_cl_b_c_relation_history add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_cl_b_c_relation_history truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_cl_b_c_relation_history_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_b_c_relation_history where 0=1;

insert /*+ append */ into ${iol_schema}.icms_cl_b_c_relation_history_ex(
    relativecreditno -- 额度系统额度编号
    ,occupycoefficient -- 占用上层额度的系数
    ,customerid -- 额度系统客户编号
    ,updatedate -- 最后更新日期
    ,occupycurrency -- 占用币种
    ,effect -- Y有效N无效
    ,roletype -- 角色类型
    ,inputuserid -- 登记人
    ,relativetype -- 关系类型
    ,inputdate -- 登记日期
    ,businessno -- 额度系统业务编号
    ,actualoccupynominalamount -- 实际占用名义金额
    ,execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,occupynominalamount -- 占用名义金额
    ,updateuserid -- 最后更新人
    ,occupyexposureamount -- 占用敞口金额
    ,createdway -- 关系建立方式
    ,actualoccupyexposureamount -- 实际占用敞口金额
    ,inputorgid -- 登记机构
    ,updateorgid -- 最后更新机构
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    relativecreditno -- 额度系统额度编号
    ,occupycoefficient -- 占用上层额度的系数
    ,customerid -- 额度系统客户编号
    ,updatedate -- 最后更新日期
    ,occupycurrency -- 占用币种
    ,effect -- Y有效N无效
    ,roletype -- 角色类型
    ,inputuserid -- 登记人
    ,relativetype -- 关系类型
    ,inputdate -- 登记日期
    ,businessno -- 额度系统业务编号
    ,actualoccupynominalamount -- 实际占用名义金额
    ,execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,occupynominalamount -- 占用名义金额
    ,updateuserid -- 最后更新人
    ,occupyexposureamount -- 占用敞口金额
    ,createdway -- 关系建立方式
    ,actualoccupyexposureamount -- 实际占用敞口金额
    ,inputorgid -- 登记机构
    ,updateorgid -- 最后更新机构
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_cl_b_c_relation_history
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_cl_b_c_relation_history exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_b_c_relation_history_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_b_c_relation_history to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_cl_b_c_relation_history_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_b_c_relation_history',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);