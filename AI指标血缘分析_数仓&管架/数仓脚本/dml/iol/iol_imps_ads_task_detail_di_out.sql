/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_imps_ads_task_detail_di_out
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
drop table ${iol_schema}.imps_ads_task_detail_di_out_ex purge;
alter table ${iol_schema}.imps_ads_task_detail_di_out add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.imps_ads_task_detail_di_out truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.imps_ads_task_detail_di_out_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.imps_ads_task_detail_di_out where 0=1;

insert /*+ append */ into ${iol_schema}.imps_ads_task_detail_di_out_ex(
    base_id -- 基准id
    ,main_account_id -- 主账号id
    ,app_id -- 项目id
    ,subject_id -- 主体id
    ,task_id -- 任务id
    ,schedule_id -- 调度id
    ,sub_task_id -- 子任务id/策略器id
    ,current_id_type -- 人群包的用户id类型
    ,current_id -- 人群包里的用户id
    ,current_version_index -- 实验组id
    ,send_id -- 通道用户id
    ,send_id_type -- 通道用户id类型
    ,coupon_uuid -- 发送内容里券码
    ,message -- 发送内容
    ,channel_type -- 通道类型
    ,channel_id -- 通道id
    ,click_flag -- 点击标记，0为未点击，1为已点击
    ,click_time -- 点击时间
    ,arrive_flag -- 到达标记，0为未到达、1为已到达
    ,arrive_time -- 到达时间
    ,trigger_success_flag -- 发送标记，0为未发送、1为已发送
    ,trigger_time -- 发送时间
    ,is_probe_data -- 是否为探针数据
    ,app_name -- 项目名称
    ,"mode" -- 任务触发类型
    ,task_name -- 任务名称
    ,campaign_id -- 活动id
    ,campaign_name -- 活动名称
    ,group_id -- 任务分组id
    ,group_name -- 任务分组名称
    ,campaign_group_id -- 活动分组id
    ,campaign_group_name -- 活动分组名称
    ,cohort_id -- 人群id
    ,crowd_name -- 人群名称
    ,creator -- 创建人
    ,channel_name -- 通道名称
    ,sub_task_name -- 策略器名称
    ,coupon_id -- 权益id
    ,coupon_name -- 权益名称
    ,start_time -- 任务开始时间
    ,end_time -- 任务结束时间
    ,window_popup_flag -- 弹窗标记，0为未弹窗，1为已弹窗
    ,window_popup_time -- 弹窗时间
    ,market_plan_id -- 营销计划id
    ,finish_a_events -- 完成a事件
    ,unfinish_b_events -- 未完成b事件
    ,short_links_info -- 短链信息
    ,magic_links_info -- 魔方落地页信息
    ,p_date -- 日期
    ,task_type -- 任务类型，task为触达任务、canvas为流程画布
    ,seq_id -- 序号
    ,tunnel_type -- 
    ,ecif_id -- 客户号
    ,content --内容
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    base_id -- 基准id
    ,main_account_id -- 主账号id
    ,app_id -- 项目id
    ,subject_id -- 主体id
    ,task_id -- 任务id
    ,schedule_id -- 调度id
    ,sub_task_id -- 子任务id/策略器id
    ,current_id_type -- 人群包的用户id类型
    ,current_id -- 人群包里的用户id
    ,current_version_index -- 实验组id
    ,send_id -- 通道用户id
    ,send_id_type -- 通道用户id类型
    ,coupon_uuid -- 发送内容里券码
    ,message -- 发送内容
    ,channel_type -- 通道类型
    ,channel_id -- 通道id
    ,click_flag -- 点击标记，0为未点击，1为已点击
    ,click_time -- 点击时间
    ,arrive_flag -- 到达标记，0为未到达、1为已到达
    ,arrive_time -- 到达时间
    ,trigger_success_flag -- 发送标记，0为未发送、1为已发送
    ,trigger_time -- 发送时间
    ,is_probe_data -- 是否为探针数据
    ,app_name -- 项目名称
    ,"mode" -- 任务触发类型
    ,task_name -- 任务名称
    ,campaign_id -- 活动id
    ,campaign_name -- 活动名称
    ,group_id -- 任务分组id
    ,group_name -- 任务分组名称
    ,campaign_group_id -- 活动分组id
    ,campaign_group_name -- 活动分组名称
    ,cohort_id -- 人群id
    ,crowd_name -- 人群名称
    ,creator -- 创建人
    ,channel_name -- 通道名称
    ,sub_task_name -- 策略器名称
    ,coupon_id -- 权益id
    ,coupon_name -- 权益名称
    ,start_time -- 任务开始时间
    ,end_time -- 任务结束时间
    ,window_popup_flag -- 弹窗标记，0为未弹窗，1为已弹窗
    ,window_popup_time -- 弹窗时间
    ,market_plan_id -- 营销计划id
    ,finish_a_events -- 完成a事件
    ,unfinish_b_events -- 未完成b事件
    ,short_links_info -- 短链信息
    ,magic_links_info -- 魔方落地页信息
    ,p_date -- 日期
    ,task_type -- 任务类型，task为触达任务、canvas为流程画布
    ,seq_id -- 序号
    ,tunnel_type -- 
    ,ecif_id -- 客户号
    ,content --内容
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.imps_ads_task_detail_di_out
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.imps_ads_task_detail_di_out exchange partition p_${batch_date} with table ${iol_schema}.imps_ads_task_detail_di_out_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.imps_ads_task_detail_di_out to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.imps_ads_task_detail_di_out_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'imps_ads_task_detail_di_out',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);