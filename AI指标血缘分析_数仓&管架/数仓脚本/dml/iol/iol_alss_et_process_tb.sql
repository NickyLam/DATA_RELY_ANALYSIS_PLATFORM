/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_et_process_tb
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
drop table ${iol_schema}.alss_et_process_tb_ex purge;
alter table ${iol_schema}.alss_et_process_tb add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.alss_et_process_tb truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.alss_et_process_tb_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alss_et_process_tb where 0=1;

insert /*+ append */ into ${iol_schema}.alss_et_process_tb_ex(
    form_id -- 处理单编号
    ,form_type -- 处理单类型
    ,node_no -- 处理流程节点号
    ,create_time -- 生成时间
    ,pre_node_no -- 上一流程号
    ,deal_organ_no -- 交易机构
    ,deal_organ_name -- 机构名称
    ,deal_user_no -- 处理人编号
    ,deal_user_name -- 处理人名称
    ,deal_date -- 处理日期
    ,deal_description -- 处理意见
    ,deal_result_text -- 处理结果
    ,label_process -- 处理流程标签
    ,process_show_level -- 处理信息查看级别
    ,save_flag -- 存储类型
    ,deal_result_node -- 处理结果节点
    ,next_deal_no -- 下次处理节点
    ,zc -- 
    ,xc -- 
    ,yn -- 
    ,risk_busi_ct -- 
    ,risk_busi_tx -- 
    ,pre_lose -- 
    ,real_lose -- 
    ,lose_reason -- 
    ,discipline_amount -- 
    ,economic_amount -- 
    ,punish_amount -- 
    ,czy -- 
    ,spy -- 
    ,fx_flag -- 
    ,file_name -- 
    ,real_name -- 
    ,file_path -- 
    ,file_ext -- 
    ,back_date -- 应反馈日期
    ,over_flag -- 分行是否逾期0否，1是
    ,next_deal_date -- 
    ,next_deal_user -- 
    ,deal_organ -- 
    ,deal_organ_level -- 
    ,over_days -- 逾期天数
    ,risk_source_remak -- 
    ,risk_source_name -- 
    ,risk_source_type -- 
    ,risk_source_no -- 
    ,operateremarks -- 备注
    ,channelstatus -- 处置状态
    ,operatestatus -- 操作原因
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    form_id -- 处理单编号
    ,form_type -- 处理单类型
    ,node_no -- 处理流程节点号
    ,create_time -- 生成时间
    ,pre_node_no -- 上一流程号
    ,deal_organ_no -- 交易机构
    ,deal_organ_name -- 机构名称
    ,deal_user_no -- 处理人编号
    ,deal_user_name -- 处理人名称
    ,deal_date -- 处理日期
    ,deal_description -- 处理意见
    ,deal_result_text -- 处理结果
    ,label_process -- 处理流程标签
    ,process_show_level -- 处理信息查看级别
    ,save_flag -- 存储类型
    ,deal_result_node -- 处理结果节点
    ,next_deal_no -- 下次处理节点
    ,zc -- 
    ,xc -- 
    ,yn -- 
    ,risk_busi_ct -- 
    ,risk_busi_tx -- 
    ,pre_lose -- 
    ,real_lose -- 
    ,lose_reason -- 
    ,discipline_amount -- 
    ,economic_amount -- 
    ,punish_amount -- 
    ,czy -- 
    ,spy -- 
    ,fx_flag -- 
    ,file_name -- 
    ,real_name -- 
    ,file_path -- 
    ,file_ext -- 
    ,back_date -- 应反馈日期
    ,over_flag -- 分行是否逾期0否，1是
    ,next_deal_date -- 
    ,next_deal_user -- 
    ,deal_organ -- 
    ,deal_organ_level -- 
    ,over_days -- 逾期天数
    ,risk_source_remak -- 
    ,risk_source_name -- 
    ,risk_source_type -- 
    ,risk_source_no -- 
    ,operateremarks -- 备注
    ,channelstatus -- 处置状态
    ,operatestatus -- 操作原因
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alss_et_process_tb
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alss_et_process_tb exchange partition p_${batch_date} with table ${iol_schema}.alss_et_process_tb_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_et_process_tb to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alss_et_process_tb_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_et_process_tb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);