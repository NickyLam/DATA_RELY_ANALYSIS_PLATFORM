/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cchs_uomp_workbill_detail
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
drop table ${iol_schema}.cchs_uomp_workbill_detail_ex purge;
alter table ${iol_schema}.cchs_uomp_workbill_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.cchs_uomp_workbill_detail;

-- 2.3 insert data to ex table
create table ${iol_schema}.cchs_uomp_workbill_detail_ex nologging
compress
as
select * from ${iol_schema}.cchs_uomp_workbill_detail where 0=1;

insert /*+ append */ into ${iol_schema}.cchs_uomp_workbill_detail_ex(
    code -- 流水号 YYYYMMDDhhmmss+随机数
    ,workbill_no -- 工单编号
    ,workbill_type -- 工单类型
    ,workbill_sub_type -- 子工单类型
    ,deal_node_code -- 当前节点编号
    ,next_node_code -- 下一节点编号
    ,prev_node_code -- 上一节点编号
    ,prev_org_code -- 上一处理机构Code
    ,prev_emp_code -- 上一处理人工号
    ,deal_org_code -- 当前节点处理机构Code
    ,deal_emp_code -- 当前节点处理人工号
    ,deal_content -- 处理正文
    ,reason -- 节点流转原因
    ,deal_date -- 当前节点处理时间
    ,last_deal_date -- 预计回复日期
    ,is_late_flag -- 是否逾期标识0逾期1正常
    ,prev_emp_name -- 上一处理人姓名
    ,deal_emp_name -- 当前节点处理人姓名
    ,next_org_code -- 下一节点处理机构Code
    ,accept_date -- 当前节点受理时间
    ,deal_node_name -- 当前节点名称
    ,workbill_status -- 工单当前状态(参数配置)
    ,deal_org_name -- 当前节点处理机构Name
    ,init_date -- 当前节点初始时间(上一节点结束时间)
    ,complain -- 是否有责
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    code -- 流水号 YYYYMMDDhhmmss+随机数
    ,workbill_no -- 工单编号
    ,workbill_type -- 工单类型
    ,workbill_sub_type -- 子工单类型
    ,deal_node_code -- 当前节点编号
    ,next_node_code -- 下一节点编号
    ,prev_node_code -- 上一节点编号
    ,prev_org_code -- 上一处理机构Code
    ,prev_emp_code -- 上一处理人工号
    ,deal_org_code -- 当前节点处理机构Code
    ,deal_emp_code -- 当前节点处理人工号
    ,deal_content -- 处理正文
    ,reason -- 节点流转原因
    ,deal_date -- 当前节点处理时间
    ,last_deal_date -- 预计回复日期
    ,is_late_flag -- 是否逾期标识0逾期1正常
    ,prev_emp_name -- 上一处理人姓名
    ,deal_emp_name -- 当前节点处理人姓名
    ,next_org_code -- 下一节点处理机构Code
    ,accept_date -- 当前节点受理时间
    ,deal_node_name -- 当前节点名称
    ,workbill_status -- 工单当前状态(参数配置)
    ,deal_org_name -- 当前节点处理机构Name
    ,init_date -- 当前节点初始时间(上一节点结束时间)
    ,complain -- 是否有责
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cchs_uomp_workbill_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cchs_uomp_workbill_detail exchange partition p_${batch_date} with table ${iol_schema}.cchs_uomp_workbill_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cchs_uomp_workbill_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cchs_uomp_workbill_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cchs_uomp_workbill_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);