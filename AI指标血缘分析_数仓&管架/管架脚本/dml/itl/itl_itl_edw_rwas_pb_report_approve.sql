/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_rwas_pb_report_approve
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_rwas_pb_report_approve drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_rwas_pb_report_approve drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_rwas_pb_report_approve add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_rwas_pb_report_approve partition for (to_date('${batch_date}','yyyymmdd')) (
    item_cd -- 报表编码
    ,item_name -- 报表名称
    ,data_date -- 数据日期
    ,solo_no -- 法人编码
    ,org_cd -- 机构编码
    ,ccy_cd -- 币种编码
    ,version -- 版本
    ,version_status -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
    ,operate_dt -- 操作时间
    ,operate_id -- 操作人id
    ,operate_name -- 操作人姓名
    ,flow_starter_id -- 流程发起人id
    ,flow_starter_name -- 流程发起人姓名
    ,approve_remark -- 审批意见
    ,catalog_id -- 附件目录编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(item_cd), ' ') as item_cd -- 报表编码
    ,nvl(trim(item_name), ' ') as item_name -- 报表名称
    ,nvl(trim(data_date), ' ') as data_date -- 数据日期
    ,nvl(trim(solo_no), ' ') as solo_no -- 法人编码
    ,nvl(trim(org_cd), ' ') as org_cd -- 机构编码
    ,nvl(trim(ccy_cd), ' ') as ccy_cd -- 币种编码
    ,nvl(trim(version), ' ') as version -- 版本
    ,nvl(trim(version_status), 0) as version_status -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
    ,nvl(trim(operate_dt), ' ') as operate_dt -- 操作时间
    ,nvl(trim(operate_id), ' ') as operate_id -- 操作人id
    ,nvl(trim(operate_name), ' ') as operate_name -- 操作人姓名
    ,nvl(trim(flow_starter_id), ' ') as flow_starter_id -- 流程发起人id
    ,nvl(trim(flow_starter_name), ' ') as flow_starter_name -- 流程发起人姓名
    ,nvl(trim(approve_remark), ' ') as approve_remark -- 审批意见
    ,nvl(trim(catalog_id), ' ') as catalog_id -- 附件目录编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_rwas_pb_report_approve
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_rwas_pb_report_approve to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_rwas_pb_report_approve',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);