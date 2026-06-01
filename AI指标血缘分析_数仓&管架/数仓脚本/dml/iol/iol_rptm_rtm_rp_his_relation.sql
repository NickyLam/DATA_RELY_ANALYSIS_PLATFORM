/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_rp_his_relation
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
drop table ${iol_schema}.rptm_rtm_rp_his_relation_ex purge;
alter table ${iol_schema}.rptm_rtm_rp_his_relation add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rptm_rtm_rp_his_relation truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rptm_rtm_rp_his_relation_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_his_relation where 0=1;

insert /*+ append */ into ${iol_schema}.rptm_rtm_rp_his_relation_ex(
    id -- ID
    ,bus_id -- 业务主键
    ,his_bus_id -- 关联的名单业务编号
    ,entity_rp_type -- 本层关联方类型
    ,entity_bus_id -- 本层关联方业务编号
    ,super_rp_type -- 前一层关联方类型
    ,super_bus_id -- 前一层关联方业务编号
    ,super_rp_name -- 前一层关联方名称
    ,super_ybj_card_type -- 前一层证件类型
    ,super_card_no -- 前一层关联方证件号码
    ,relation_type -- 与前一层的关联关系
    ,is_share_holding -- 与前一层之间是否有权益份额
    ,holding_pct -- 持有比例
    ,relation_info -- 关联关系说明
    ,data_state -- 数据状态
    ,valid_state -- 该关系是否仍然有效
    ,active_time -- 关系生效时间
    ,invalid_time -- 关系失效时间
    ,release_time -- 关系解除时间
    ,process_time -- 审核通过时间
    ,remarks -- 备注信息
    ,legal_org_code -- 独立法人编码
    ,create_user -- 创建人
    ,create_time -- 创建时间
    ,create_org -- 创建机构
    ,create_dep -- 创建部门
    ,update_user -- 修改人
    ,update_time -- 修改时间
    ,update_org -- 修改机构
    ,update_dep -- 修改部门
    ,wf_state -- 流程状态
    ,agree -- 同意标识
    ,process_instance_id -- 流程实例ID
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,data_dt -- 数据跑批日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ID
    ,bus_id -- 业务主键
    ,his_bus_id -- 关联的名单业务编号
    ,entity_rp_type -- 本层关联方类型
    ,entity_bus_id -- 本层关联方业务编号
    ,super_rp_type -- 前一层关联方类型
    ,super_bus_id -- 前一层关联方业务编号
    ,super_rp_name -- 前一层关联方名称
    ,super_ybj_card_type -- 前一层证件类型
    ,super_card_no -- 前一层关联方证件号码
    ,relation_type -- 与前一层的关联关系
    ,is_share_holding -- 与前一层之间是否有权益份额
    ,holding_pct -- 持有比例
    ,relation_info -- 关联关系说明
    ,data_state -- 数据状态
    ,valid_state -- 该关系是否仍然有效
    ,active_time -- 关系生效时间
    ,invalid_time -- 关系失效时间
    ,release_time -- 关系解除时间
    ,process_time -- 审核通过时间
    ,remarks -- 备注信息
    ,legal_org_code -- 独立法人编码
    ,create_user -- 创建人
    ,create_time -- 创建时间
    ,create_org -- 创建机构
    ,create_dep -- 创建部门
    ,update_user -- 修改人
    ,update_time -- 修改时间
    ,update_org -- 修改机构
    ,update_dep -- 修改部门
    ,wf_state -- 流程状态
    ,agree -- 同意标识
    ,process_instance_id -- 流程实例ID
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,data_dt -- 数据跑批日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rptm_rtm_rp_his_relation
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rptm_rtm_rp_his_relation exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_rp_his_relation_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_rp_his_relation to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rptm_rtm_rp_his_relation_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_rp_his_relation',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);