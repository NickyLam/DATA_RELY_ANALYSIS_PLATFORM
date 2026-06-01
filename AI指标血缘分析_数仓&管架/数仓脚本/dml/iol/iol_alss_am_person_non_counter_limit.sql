/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_am_person_non_counter_limit
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
drop table ${iol_schema}.alss_am_person_non_counter_limit_ex purge;
alter table ${iol_schema}.alss_am_person_non_counter_limit add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.alss_am_person_non_counter_limit truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.alss_am_person_non_counter_limit_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alss_am_person_non_counter_limit where 0=1;

insert /*+ append */ into ${iol_schema}.alss_am_person_non_counter_limit_ex(
    apply_status -- 审批类型
    ,cust_acct_id -- 账号/卡号
    ,pre_proc_id -- 预受理编号
    ,cust_name -- 客户名称
    ,cert_type -- 证件类型
    ,cert_no -- 证件号
    ,create_organ -- 发起人机构
    ,create_user_teller_id -- 发起人
    ,create_time -- 发起日期：YYYYMMDD H24:MM:SS
    ,deal_status -- 处理状态：1-待处理、2-通过、3-不通过、4-终止
    ,cust_mgr_teller_id -- 客户经理 员工号-姓名
    ,cust_mgr_deal_time -- 客户经理处理日期 YYYYMMDD H24:MM:SS
    ,check_teller_id -- 复核人 员工号-姓名
    ,check_time -- 复核日期 YYYYMMDD H24:MM:SS
    ,non_counter_limit -- 单笔交易限额
    ,person_non_counter_day_limit -- 日累计交易限额
    ,person_non_counter_day_count -- 日累计笔数
    ,person_non_counter_year_limit -- 年累计交易限额
    ,data_status -- 数据状态
    ,apply_id -- 审批单号
    ,cust_mgr_organ -- 客户经理机构
    ,check_organ -- 复核人机构
    ,check_info -- 复核说明
    ,phone -- 手机号
    ,cust_no -- 客户号
    ,card_class -- 卡片等级
    ,paper_no -- 证件号
    ,paper_type -- 证件类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    apply_status -- 审批类型
    ,cust_acct_id -- 账号/卡号
    ,pre_proc_id -- 预受理编号
    ,cust_name -- 客户名称
    ,cert_type -- 证件类型
    ,cert_no -- 证件号
    ,create_organ -- 发起人机构
    ,create_user_teller_id -- 发起人
    ,create_time -- 发起日期：YYYYMMDD H24:MM:SS
    ,deal_status -- 处理状态：1-待处理、2-通过、3-不通过、4-终止
    ,cust_mgr_teller_id -- 客户经理 员工号-姓名
    ,cust_mgr_deal_time -- 客户经理处理日期 YYYYMMDD H24:MM:SS
    ,check_teller_id -- 复核人 员工号-姓名
    ,check_time -- 复核日期 YYYYMMDD H24:MM:SS
    ,non_counter_limit -- 单笔交易限额
    ,person_non_counter_day_limit -- 日累计交易限额
    ,person_non_counter_day_count -- 日累计笔数
    ,person_non_counter_year_limit -- 年累计交易限额
    ,data_status -- 数据状态
    ,apply_id -- 审批单号
    ,cust_mgr_organ -- 客户经理机构
    ,check_organ -- 复核人机构
    ,check_info -- 复核说明
    ,phone -- 手机号
    ,cust_no -- 客户号
    ,card_class -- 卡片等级
    ,paper_no -- 证件号
    ,paper_type -- 证件类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alss_am_person_non_counter_limit
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alss_am_person_non_counter_limit exchange partition p_${batch_date} with table ${iol_schema}.alss_am_person_non_counter_limit_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_am_person_non_counter_limit to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alss_am_person_non_counter_limit_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_am_person_non_counter_limit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);