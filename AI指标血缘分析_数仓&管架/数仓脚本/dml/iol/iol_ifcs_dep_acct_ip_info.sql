/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_dep_acct_ip_info
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
drop table ${iol_schema}.ifcs_dep_acct_ip_info_ex purge;
alter table ${iol_schema}.ifcs_dep_acct_ip_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ifcs_dep_acct_ip_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_dep_acct_ip_info_ex nologging
compress
as
select * from ${iol_schema}.ifcs_dep_acct_ip_info where 0=1;

insert /*+ append */ into ${iol_schema}.ifcs_dep_acct_ip_info_ex(
    name -- 姓名
    ,cert_no -- 证件号码
    ,cust_id -- 客户ID
    ,acct_id -- 合作行卡号
    ,ext_card_no -- 微众银行卡号
    ,open_acct_ip -- 开户IP
    ,permanent_ip -- 常驻IP
    ,lbs_info -- LBS信息
    ,check_ip_flag -- 是否核对IP,0-未核对 1-已核对
    ,local_flag -- 是否本地,0-否 1-是
    ,province -- 省份
    ,city -- 开户IP城市
    ,check_time -- 核对时间
    ,reback_flag -- 是否回撤,0-否 1-是
    ,reback_time -- 回撤时间
    ,return_code -- 回撤返回码
    ,return_result -- 回撤返回结果
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    name -- 姓名
    ,cert_no -- 证件号码
    ,cust_id -- 客户ID
    ,acct_id -- 合作行卡号
    ,ext_card_no -- 微众银行卡号
    ,open_acct_ip -- 开户IP
    ,permanent_ip -- 常驻IP
    ,lbs_info -- LBS信息
    ,check_ip_flag -- 是否核对IP,0-未核对 1-已核对
    ,local_flag -- 是否本地,0-否 1-是
    ,province -- 省份
    ,city -- 开户IP城市
    ,check_time -- 核对时间
    ,reback_flag -- 是否回撤,0-否 1-是
    ,reback_time -- 回撤时间
    ,return_code -- 回撤返回码
    ,return_result -- 回撤返回结果
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_dep_acct_ip_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_dep_acct_ip_info exchange partition p_${batch_date} with table ${iol_schema}.ifcs_dep_acct_ip_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_dep_acct_ip_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_dep_acct_ip_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_dep_acct_ip_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);