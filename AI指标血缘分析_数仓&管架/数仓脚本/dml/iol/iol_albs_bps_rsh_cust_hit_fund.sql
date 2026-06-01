/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_albs_bps_rsh_cust_hit_fund
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
drop table ${iol_schema}.albs_bps_rsh_cust_hit_fund_ex purge;
alter table ${iol_schema}.albs_bps_rsh_cust_hit_fund add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.albs_bps_rsh_cust_hit_fund truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.albs_bps_rsh_cust_hit_fund_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.albs_bps_rsh_cust_hit_fund where 0=1;

insert /*+ append */ into ${iol_schema}.albs_bps_rsh_cust_hit_fund_ex(
    id -- 表主键
    ,main_id -- 表主键
    ,own_org -- 归属组织
    ,cust_id -- 客户表主键
    ,sch_result -- 检索命中结果：00-检索通过；02-中黑名单；03-中白名单；01-中高风险国家地区；99-检索异常。
    ,match_level_id -- 命中后的侦测等级ID，对应匹配等级参数表的值。
    ,risk_level -- 风险等级（1-一级，2-二级，3-三级，4-四级，5-五级），该值从枚举表中定义，后面会变化
    ,list_scope -- 检索名单范围，登记该次检索用到的名单范围，多个用半角逗号分隔。
    ,confirm_result -- 确认结果
    ,last_confirm_result -- 上次确认结果：0-未确认；1-确认命中；2-确认误中。
    ,crt_date -- 创建日期(YYYYMMDD)
    ,crt_datetime -- 创建时间(YYYYMMDDHHMMSS)
    ,last_datetime -- 最后操作时间(YYYYMMDDHHMMSS)
    ,last_user_id -- 最后操作用户ID
    ,last_user_code -- 最后操作用户代码
    ,system_id -- 对接系统
    ,cust_code -- 客户编号
    ,cust_type -- 客户类型
    ,cust_kind -- 客户种类
    ,cust_name -- 客户名称
    ,cust_eng_name -- 客户英文名称
    ,cust_addr -- 客户地址
    ,cust_eng_addr -- 客户英文地址
    ,cust_id_type -- 客户证件类型
    ,cust_id_no -- 客户证件号
    ,cust_country -- 客户国家
    ,crt_user_code -- 创建用户代码
    ,crt_branch_code -- 创建用户机构代码
    ,last_branch_id -- 业务机构ID
    ,last_txn -- 交易码
    ,sch_kind -- 增量回溯类型
    ,backfiels1 -- 备用字段1
    ,backfiels2 -- 备用字段2
    ,backfiels3 -- 备用字段3
    ,confirm_desc -- 
    ,cust_check_pass -- 
    ,check_pass_flag -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 表主键
    ,main_id -- 表主键
    ,own_org -- 归属组织
    ,cust_id -- 客户表主键
    ,sch_result -- 检索命中结果：00-检索通过；02-中黑名单；03-中白名单；01-中高风险国家地区；99-检索异常。
    ,match_level_id -- 命中后的侦测等级ID，对应匹配等级参数表的值。
    ,risk_level -- 风险等级（1-一级，2-二级，3-三级，4-四级，5-五级），该值从枚举表中定义，后面会变化
    ,list_scope -- 检索名单范围，登记该次检索用到的名单范围，多个用半角逗号分隔。
    ,confirm_result -- 确认结果
    ,last_confirm_result -- 上次确认结果：0-未确认；1-确认命中；2-确认误中。
    ,crt_date -- 创建日期(YYYYMMDD)
    ,crt_datetime -- 创建时间(YYYYMMDDHHMMSS)
    ,last_datetime -- 最后操作时间(YYYYMMDDHHMMSS)
    ,last_user_id -- 最后操作用户ID
    ,last_user_code -- 最后操作用户代码
    ,system_id -- 对接系统
    ,cust_code -- 客户编号
    ,cust_type -- 客户类型
    ,cust_kind -- 客户种类
    ,cust_name -- 客户名称
    ,cust_eng_name -- 客户英文名称
    ,cust_addr -- 客户地址
    ,cust_eng_addr -- 客户英文地址
    ,cust_id_type -- 客户证件类型
    ,cust_id_no -- 客户证件号
    ,cust_country -- 客户国家
    ,crt_user_code -- 创建用户代码
    ,crt_branch_code -- 创建用户机构代码
    ,last_branch_id -- 业务机构ID
    ,last_txn -- 交易码
    ,sch_kind -- 增量回溯类型
    ,backfiels1 -- 备用字段1
    ,backfiels2 -- 备用字段2
    ,backfiels3 -- 备用字段3
    ,confirm_desc -- 
    ,cust_check_pass -- 
    ,check_pass_flag -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.albs_bps_rsh_cust_hit_fund
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.albs_bps_rsh_cust_hit_fund exchange partition p_${batch_date} with table ${iol_schema}.albs_bps_rsh_cust_hit_fund_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.albs_bps_rsh_cust_hit_fund to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.albs_bps_rsh_cust_hit_fund_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'albs_bps_rsh_cust_hit_fund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);