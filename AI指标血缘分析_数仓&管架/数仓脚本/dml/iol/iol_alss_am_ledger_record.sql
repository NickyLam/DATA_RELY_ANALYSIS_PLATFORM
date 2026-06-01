/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_am_ledger_record
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
drop table ${iol_schema}.alss_am_ledger_record_ex purge;
alter table ${iol_schema}.alss_am_ledger_record add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.alss_am_ledger_record;

-- 2.3 insert data to ex table
create table ${iol_schema}.alss_am_ledger_record_ex nologging
compress
as
select * from ${iol_schema}.alss_am_ledger_record where 0=1;

insert /*+ append */ into ${iol_schema}.alss_am_ledger_record_ex(
    input_date -- 通报日期
    ,data_release_id -- 发布数据主键
    ,deal_status -- 数据状态 0-未生效 1-生效 2-修订 3-待删除 4-删除
    ,add_organ_no -- 补录操作柜员机构
    ,add_user -- 补录操作人员
    ,add_date -- 补录操作日期
    ,check_data -- 补录复核时间
    ,check_user -- 补录复核人员
    ,record_data_state -- 补录状态 0-待补录  1-待复核 2-通过 3-不通过 4-退回
    ,batch_id -- 批次号
    ,is_deal -- 是否冻结/止付
    ,is_accountability -- 是否问责
    ,l_r_id -- 补录主id 主键
    ,is_reduction -- 是否核减
    ,acct_status -- 账号状态
    ,open_date -- 开户日期
    ,open_organ -- 开户机构
    ,source_type -- 开户渠道
    ,acc_name -- 账户名称
    ,acc_no -- 卡号/账号
    ,cert_num -- 证件号码
    ,cert_type -- 证件类型
    ,cus_no -- 客户号
    ,cus_type -- 客户类型 个人/对公
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    input_date -- 通报日期
    ,data_release_id -- 发布数据主键
    ,deal_status -- 数据状态 0-未生效 1-生效 2-修订 3-待删除 4-删除
    ,add_organ_no -- 补录操作柜员机构
    ,add_user -- 补录操作人员
    ,add_date -- 补录操作日期
    ,check_data -- 补录复核时间
    ,check_user -- 补录复核人员
    ,record_data_state -- 补录状态 0-待补录  1-待复核 2-通过 3-不通过 4-退回
    ,batch_id -- 批次号
    ,is_deal -- 是否冻结/止付
    ,is_accountability -- 是否问责
    ,l_r_id -- 补录主id 主键
    ,is_reduction -- 是否核减
    ,acct_status -- 账号状态
    ,open_date -- 开户日期
    ,open_organ -- 开户机构
    ,source_type -- 开户渠道
    ,acc_name -- 账户名称
    ,acc_no -- 卡号/账号
    ,cert_num -- 证件号码
    ,cert_type -- 证件类型
    ,cus_no -- 客户号
    ,cus_type -- 客户类型 个人/对公
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alss_am_ledger_record
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alss_am_ledger_record exchange partition p_${batch_date} with table ${iol_schema}.alss_am_ledger_record_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_am_ledger_record to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alss_am_ledger_record_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_am_ledger_record',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);